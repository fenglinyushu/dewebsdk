unit Msgdlg;

{==========================================================================}
{ MessageDlg Replacement v1.4 for Delphi                                   }
{ (Delphi1 - Delphi3)                                                      }
{                                                                          }
{ Copyright ?1997 by BitSoft Development, L.L.C.                          }
{ All rights reserved                                                      }
{                                                                          }
{ Web:     http://www.bitsoft.com                                          }
{ E-mail:  info@bitsoft.com                                                }
{ Support: tech-support@bitsoft.com                                        }
{--------------------------------------------------------------------------}
{ Portions Copyright (C) 1982-1997, Borland International, Inc.            }
{--------------------------------------------------------------------------}
{ This file is distributed as freeware and without warranties of any kind. }
{ You can use it in your own applications at your own risk.                }
{ See the License Agreement for more information.                          }
{==========================================================================}

interface

uses
  {$ifdef Win32}
  Windows,
  {$else}
  WinProcs, Wintypes,
  {$endif}
  StdCtrls, Forms, Dialogs, Buttons, ExtCtrls, Graphics;


function MessageDialog(const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
{ Works exactly like Delphi's MessageDlg function. }

function MessageDialogPos(const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Word;
{ Works exactly like Delphi's MessageDlgPos function. }

function InputDialog(const ACaption, APrompt, ADefault: string): string;
{ Works exactly like Delphi's InputBox function. }

function InputQueryDialog_Cn(const ACaption, APrompt: string;
  var Value: string): Boolean;
{ Works exactly like Delphi's InputQuery function. }

//------------------带自定义字体的消息框----------------------------------------------------------//
function MessageDialogWithFont(const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons;MsgFont,BtnFont:TFont): Word;
function InputQueryWithFont(const ACaption, APrompt: string;
  var Value: string;MsgFont,BtnFont:TFont): Boolean;


{ The following values can be changed either at the beginning of an        }
{ application or before a call to the functions in this unit, to customize }
{ the resulting message box.                                               }

const
  mcButtonSize : Integer = 55;
  mcButtonHeight : Integer = 13;
  mcButtonSpacing : Integer = 8;
  mcHorzMargin : Integer = 8;
  mcVertMargin : Integer = 6;
  mcHorzSpacing : Integer = 8;
  mcVertSpacing : Integer = 8;
  mcGlyphSpacing : Integer = -1;
  mcFontName : string = '宋体';
  mcFontSize : Integer = 9;
  mcFontStyle : TFontStyles = [];
  mcUseGlyphs : Boolean = False;


implementation

uses SysUtils, Controls;

{ Private }

const
  IconIDs: array [TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);

const
  { Font used for Buttons }
  FontName : string = '宋体';
  FontSize : Integer = 9;
  FontStyle : TFontStyles = [];

const
  { Strings }
  {$I msgdlg.inc}

function GetAveCharSize(Canvas: TCanvas): TPoint;
{ Copyright (C) 1982-1997, Borland International, Inc. }
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;


{ Public }

function MessageDialog(const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
    Result := MessageDialogPos(Msg, AType, AButtons, HelpCtx, -1, -1);
end;

function MessageDialogPos(const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Word;
const
    {$ifdef ver100}
        ButtonKinds : array [0..10] of TBitBtnKind = (bkYes, bkNo, bkOk, bkCancel,
            bkAbort, bkRetry, bkIgnore, bkAll, bkNo, bkAll, bkHelp);
    {$else}
        ButtonKinds : array [0..8] of TBitBtnKind = (bkYes, bkNo, bkOk, bkCancel,
            bkAbort, bkRetry, bkIgnore, bkAll, bkHelp);
    {$endif}
var
    TextWidth, TextHeight, LeftPos, i : Integer;
    Dialog : TForm;
    TextRect : TRect;
    DialogImage : TImage;
    ICOHandle : HICON;
    MsgText : TLabel;
    ButtonsWidth, ButtonCount : Integer;
    ButtonList : array[0..10] of TBitBtn;
    HorzMargin, VertMargin, HorzSpacing, VertSpacing, ButtonSize,
    ButtonHeight, ButtonSpacing : Integer;
    DialogUnits : TPoint;
    BMP : TBitmap;
    {$ifndef Win32}
    TmpStr : array[0..255] of Char;
    {$endif}
begin
    Dialog := TForm.Create(Application);
    ICOHandle := 0;
    try
        with Dialog do begin
            with Canvas.Font do begin
                Name := mcFontName;
                Size := mcFontSize;
                Style := mcFontStyle;
            end; { with }
            DialogUnits := GetAveCharSize(Canvas);
            HorzMargin := MulDiv(mcHorzMargin, DialogUnits.X, 4);
            VertMargin := MulDiv(mcVertMargin, DialogUnits.Y, 8);
            HorzSpacing := MulDiv(mcHorzSpacing, DialogUnits.X, 4);
            VertSpacing := MulDiv(mcVertSpacing, DialogUnits.Y, 8);
            ButtonSize := MulDiv(mcButtonSize, DialogUnits.X, 4);
            ButtonHeight := 25;//MulDiv(mcButtonHeight, DialogUnits.Y, 8);
            ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
            HelpContext := HelpCtx;
            if (X < 0) or (Y < 0) then
                Position := poScreenCenter
            else begin
                Left := X;
                Top := Y;
            end; { else }
            SetRect(TextRect, 0, 0, Screen.Width div 2, 0);
            {$ifdef Win32}
                DrawText(Canvas.Handle, PChar(Msg), Length(Msg), TextRect,
                        DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK);
            {$else}
                StrPCopy(TmpStr, Msg);
                DrawText(Canvas.Handle, TmpStr, Length(Msg), TextRect,
                        DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK);
            {$endif}
            TextWidth := TextRect.Right;
            TextHeight := TextRect.Bottom;
            if AType <> mtCustom then
            begin
                ClientWidth := TextWidth + 32 + HorzSpacing + (HorzMargin * 2);
                if TextHeight < 32 then
                    TextHeight := 32;
            end { if } else
            ClientWidth := TextWidth + (HorzMargin * 8);
            ClientHeight := TextHeight + ButtonHeight + VertSpacing + (VertMargin * 6);
            BorderIcons := [biSystemMenu];
            BorderStyle := bsDialog;
            if AType = mtCustom then
                Caption := Application.Title
            else begin
                Caption := DialogTitles[Integer(AType)];
                ICOHandle := LoadIcon(0, IconIDs[AType]);
            end; { else }
            LeftPos := HorzMargin;
            if AType <> mtCustom then begin
                DialogImage := TImage.Create(Dialog);
                DialogImage.Left := HorzMargin;
                DialogImage.Top := VertMargin;
                DialogImage.Picture.Icon.Handle := ICOHandle;
                DialogImage.AutoSize := True;
                InsertControl(DialogImage);
                LeftPos := LeftPos + 32 + HorzSpacing;
            end; { if }
            MsgText := TLabel.Create(Dialog);
            with MsgText do begin
                WordWrap := True;
                Caption := Msg;
                BoundsRect := TextRect;
                Font.Name := FontName;
                Font.Size := FontSize;
                Font.Style := FontStyle;
                SetBounds(LeftPos, VertMargin, TextRect.Right, TextRect.Bottom);
            end; { with }
            InsertControl(MsgText);
            ButtonCount := 0;
            {$ifdef ver100}
                for i := 0 to 10 do
            {$else}
                for i := 0 to 8 do
            {$endif}
            begin
                if TMsgDlgBtn(i) in AButtons then
                begin
                    ButtonList[ButtonCount] := TBitBtn.Create(Dialog);
                    with ButtonList[ButtonCount] do begin
                        Kind := ButtonKinds[i];
                        Caption := ButtonCaptions[i];
                        Font.Name := FontName;
                        Font.Size := FontSize;
                        Width := ButtonSize;
                        Height := ButtonHeight;
                        if mcUseGlyphs then
                            Spacing := mcGlyphSpacing
                        else
                            Glyph := nil;
                    end; { with }
                    Inc(ButtonCount);
                end; { if }
            end; { for }
            ButtonsWidth := (ButtonCount * (ButtonSize)) + (Pred(ButtonCount) *
            ButtonSpacing);
            if (ClientWidth - (HorzMargin * 2)) < ButtonsWidth then
                ClientWidth := ButtonsWidth + (HorzMargin * 2);
            LeftPos := ((ClientWidth - ButtonsWidth) div 2);
            for i := 0 to Pred(ButtonCount) do begin
                with ButtonList[i] do begin
                    Top := VertMargin + TextHeight + VertSpacing;
                    Left := LeftPos;
                end; { with }
                InsertControl(ButtonList[i]);
                Inc(LeftPos, ButtonList[i].Width + ButtonSpacing);
            end; { for }
        end; { with }
        Dialog.Width    := 300;
        Result := Dialog.ShowModal;
    finally;
        Dialog.Destroy;
    end; { finally }
end;

//---------------------带自定义字体的对话框-------------------------------------------------------//
function MessageDialogWithFont(const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons;MsgFont,BtnFont:TFont): Word;
const
  {$ifdef ver100}
  ButtonKinds : array [0..10] of TBitBtnKind = (bkYes, bkNo, bkOk, bkCancel,
    bkAbort, bkRetry, bkIgnore, bkAll, bkNo, bkAll, bkHelp);
  {$else}
  ButtonKinds : array [0..8] of TBitBtnKind = (bkYes, bkNo, bkOk, bkCancel,
    bkAbort, bkRetry, bkIgnore, bkAll, bkHelp);
  {$endif}
var
  TextWidth, TextHeight, LeftPos, i : Integer;
  Dialog : TForm;
  TextRect : TRect;
  DialogImage : TImage;
  ICOHandle : HICON;
  MsgText : TLabel;
  ButtonsWidth, ButtonCount : Integer;
  ButtonList : array[0..10] of TBitBtn;
  HorzMargin, VertMargin, HorzSpacing, VertSpacing, ButtonSize,
    ButtonHeight, ButtonSpacing : Integer;
  DialogUnits : TPoint;
  BMP : TBitmap;
  {$ifndef Win32}
  TmpStr : array[0..255] of Char;
  {$endif}
begin
     Dialog := TForm.Create(Application);
     Dialog.Tag     := 99;
     ICOHandle := 0;
     try
          with Dialog do begin
               Canvas.Font.Assign(MsgFont);
               Canvas.Brush.Style  := bsClear;
               DialogUnits := GetAveCharSize(Canvas);
               HorzMargin := MulDiv(mcHorzMargin, DialogUnits.X, 4);
               VertMargin := MulDiv(mcVertMargin, DialogUnits.Y, 8);
               HorzSpacing := MulDiv(mcHorzSpacing, DialogUnits.X, 4);
               VertSpacing := MulDiv(mcVertSpacing, DialogUnits.Y, 8);
               //
               Canvas.Font.Assign(BtnFont);
               DialogUnits := GetAveCharSize(Canvas);
               ButtonSize := MulDiv(mcButtonSize, DialogUnits.X, 4);
               ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 8);
               ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);

               Canvas.Font.Assign(MsgFont);
               DialogUnits := GetAveCharSize(Canvas);
               Position := poScreenCenter;
               SetRect(TextRect, 0, 0, Screen.Width div 2, 0);
               {$ifdef Win32}
                    DrawText(Canvas.Handle, PChar(Msg), Length(Msg), TextRect,
                              DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK);
               {$else}
                    StrPCopy(TmpStr, Msg);
                    DrawText(Canvas.Handle, TmpStr, Length(Msg), TextRect,
                    DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK);
               {$endif}
               TextWidth := TextRect.Right;
               TextHeight := TextRect.Bottom;
               if AType <> mtCustom then begin
                    ClientWidth := TextWidth + 32 + HorzSpacing + (HorzMargin * 2);
                    if TextHeight < 32 then
                         TextHeight := 32;
               end { if }else
                    ClientWidth := TextWidth + (HorzMargin * 3);
               ClientHeight := TextHeight + ButtonHeight + VertSpacing + (VertMargin * 2);
               BorderIcons := [biSystemMenu];
               BorderStyle := bsDialog;
               if AType = mtCustom then
                    Caption := Application.Title
               else begin
                    Caption := DialogTitles[Integer(AType)];
                    ICOHandle := LoadIcon(0, IconIDs[AType]);
               end; { else }
               LeftPos := HorzMargin;
               if AType <> mtCustom then  begin
                    DialogImage := TImage.Create(Dialog);
                    DialogImage.Left := HorzMargin;
                    DialogImage.Top := VertMargin;
                    DialogImage.Picture.Icon.Handle := ICOHandle;
                    DialogImage.AutoSize := True;
                    InsertControl(DialogImage);
                    LeftPos := LeftPos + 32 + HorzSpacing;
               end; { if }
               MsgText := TLabel.Create(Dialog);
               with MsgText do begin
                    WordWrap := True;
                    Caption := Msg;
                    BoundsRect := TextRect;
                    Font := MsgFont;
                    //ShowMessage(MsgFont.Name);
                    SetBounds(LeftPos, VertMargin, TextRect.Right, TextRect.Bottom);
               end; { with }
               InsertControl(MsgText);
               ButtonCount := 0;
          {$ifdef ver100}
               for i := 0 to 10 do
          {$else}
               for i := 0 to 8 do
          {$endif}
               begin
                    if TMsgDlgBtn(i) in AButtons then begin
                         ButtonList[ButtonCount] := TBitBtn.Create(Dialog);
                         with ButtonList[ButtonCount] do  begin
                              Kind := ButtonKinds[i];
                              Caption := ButtonCaptions[i];
                              Font := BtnFont;
                              Width := ButtonSize;
                              Height := ButtonHeight;
                              if mcUseGlyphs then
                                   Spacing := mcGlyphSpacing
                              else
                                   Glyph := nil;
                         end; { with }
                         Inc(ButtonCount);
                    end; { if }
               end; { for }
               ButtonsWidth := (ButtonCount * (ButtonSize)) + (Pred(ButtonCount) *
                         ButtonSpacing);
               if (ClientWidth - (HorzMargin * 2)) < ButtonsWidth then
                    ClientWidth := ButtonsWidth + (HorzMargin * 2);
               LeftPos := ((ClientWidth - ButtonsWidth) div 2);
               for i := 0 to Pred(ButtonCount) do begin
                    with ButtonList[i] do begin
                         Top := VertMargin + TextHeight + VertSpacing;
                         Left := LeftPos;
                    end; { with }
                    InsertControl(ButtonList[i]);
                    Inc(LeftPos, ButtonList[i].Width + ButtonSpacing);
               end; { for }
          end; { with }
          Result := Dialog.ShowModal;
     finally;
          Dialog.Destroy;
     end; { finally }

end;

function InputDialog(const ACaption, APrompt, ADefault: string): string;
{ Copyright (C) 1982-1997, Borland International, Inc. }
begin
  Result := ADefault;
  InputQueryDialog_Cn(ACaption, APrompt, Result);
end;

function InputQueryWithFont(const ACaption, APrompt: string;
  var Value: string;MsgFont,BtnFont:TFont): Boolean;
var
     Form: TForm;
     Prompt: TLabel;
     Edit: TEdit;
     DialogUnits: TPoint;
     ButtonTop, ButtonWidth, ButtonHeight, ButtonSpacing: Integer;
begin
     Result := False;
     Form := TForm.Create(Application);
     with Form do
          try
               Canvas.Font.Assign(MsgFont);
               DialogUnits := GetAveCharSize(Canvas);
               BorderStyle := bsDialog;
               Caption := ACaption;
               ClientWidth := MulDiv(120, DialogUnits.X, 4);
               ClientHeight := MulDiv(63, DialogUnits.Y, 8);
               Position := poScreenCenter;
               Prompt := TLabel.Create(Form);
               with Prompt do begin
                    Font := MsgFont;
                    Parent := Form;
                    AutoSize := True;
                    Left := MulDiv(8, DialogUnits.X, 4);
                    Top := MulDiv(8, DialogUnits.Y, 8);
                    Caption := APrompt;
               end;
               Edit := TEdit.Create(Form);
               with Edit do begin
                    Font := MsgFont;
                    Parent := Form;
                    Left := Prompt.Left;
                    Top := Prompt.Top+Prompt.Height+10;;   // MulDiv(35, DialogUnits.Y, 8);
                    Width := MulDiv(104, DialogUnits.X, 4);
                    MaxLength := 255;
                    Text := Value;
                    SelectAll;
               end;
               //
               ButtonTop := Edit.Top+Edit.Height+20;// MulDiv(51, DialogUnits.Y, 8);
               Canvas.Font.Assign(BtnFont);
               DialogUnits := GetAveCharSize(Canvas);
               ButtonWidth := MulDiv(mcButtonSize, DialogUnits.X, 4);
               ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 8);
               ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
               with TBitBtn.Create(Form) do begin
                    Parent := Form;
                    Kind := bkOk;
                    Caption := ButtonCaptions[Integer(mbOk)];
                    if mcUseGlyphs then
                         Spacing := mcGlyphSpacing
                    else
                         Glyph := nil;
                    Default := True;
                    Font := BtnFont;
                    SetBounds(MulDiv(34, DialogUnits.X, 4), ButtonTop, ButtonWidth,
                              ButtonHeight);
               end;
               with TBitBtn.Create(Form) do begin
                    Parent := Form;
                    Kind := bkCancel;
                    Caption := ButtonCaptions[Integer(mbCancel)];
                    if mcUseGlyphs then
                         Spacing := mcGlyphSpacing
                    else
                         Glyph := nil;
                    Cancel := True;
                    SetBounds(MulDiv(34, DialogUnits.X, 4) + ButtonWidth + ButtonSpacing,
                              ButtonTop, ButtonWidth, ButtonHeight);
                    Font := BtnFont;
               end;
               //
               Form.ClientHeight   := ButtonTop+ButtonHeight+20;
               //
               if ShowModal = mrOk then begin
                    Value := Edit.Text;
                    Result := True;
               end;
          finally
               Form.Free;
          end;
end;
function InputQueryDialog_Cn(const ACaption, APrompt: string;
  var Value: string): Boolean;
{ Copyright (C) 1982-1997, Borland International, Inc. }
{ Portions Copyright (C) 1997, BitSoft Development, L.L.C. }
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight, ButtonSpacing: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font.Name   := '宋体';
      Canvas.Font.Size   := 9;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      ClientHeight := MulDiv(63, DialogUnits.Y, 8);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Font.Name   := '宋体';
        Font.Size   := 9;
        AutoSize := True;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Caption := APrompt;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := MulDiv(19, DialogUnits.Y, 8);
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        //PasswordChar    := '*';
        SelectAll;
      end;
      ButtonTop := MulDiv(41, DialogUnits.Y, 8);
      ButtonWidth := MulDiv(mcButtonSize, DialogUnits.X, 4);
      ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 7);
      ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
      with TBitBtn.Create(Form) do
      begin
        Parent := Form;
        Kind := bkOk;
        Height := 25;
        Caption := ButtonCaptions[Integer(mbOk)];
        if mcUseGlyphs then
          Spacing := mcGlyphSpacing
        else
          Glyph := nil;
        Default := True;
        SetBounds(MulDiv(34, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TBitBtn.Create(Form) do
      begin
        Parent := Form;
        Kind := bkCancel;
        Height := 25;
        Caption := ButtonCaptions[Integer(mbCancel)];
        if mcUseGlyphs then
          Spacing := mcGlyphSpacing
        else
          Glyph := nil;
        Cancel := True;
        SetBounds(MulDiv(34, DialogUnits.X, 4) + ButtonWidth + ButtonSpacing,
          ButtonTop, ButtonWidth, ButtonHeight);
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

end.
