library dwTSpeedButton;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     Buttons,
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;
const
     _K   = 3;

//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     {
     //以下是TChart时的代码,供参考
     joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
     }

     //
     Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
     //
     joData    := _Json(AData);

     if joData.e = 'onclick' then begin
          //
          if Assigned(TSpeedButton(ACtrl).OnClick) then begin
               TSpeedButton(ACtrl).OnClick(TSpeedButton(ACtrl));
          end;
     end else if joData.e = 'onenter' then begin
          //
          if Assigned(TSpeedButton(ACtrl).OnMouseEnter) then begin
               TSpeedButton(ACtrl).OnMouseEnter(TSpeedButton(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          //
          if Assigned(TSpeedButton(ACtrl).OnMouseLeave) then begin
               TSpeedButton(ACtrl).OnMouseLeave(TSpeedButton(ACtrl));
          end;
     end;

end;

function _ImageLTWH(ACtrl:TControl):String;  //可以更新位置的用法
begin
     //
     with ACtrl do begin
          Result    := ' :style="{left:0,top:0,width:'+Name+'__wid,'
                    +'height:'+Name+'__imh}" style="position:absolute;';
     end;
end;
function _LabelLTWH(ACtrl:TControl):String;  //可以更新位置的用法
begin
     //
     with ACtrl do begin
          Result    := ' :style="{left:0,top:'+Name+'__lbt,width:'+Name+'__wid,'
                    +'height:'+Name+'__lbh}" style="position:absolute;';
     end;
end;

function _GetFont(AFont:TFont):string;
begin
     Result    := 'color:'+dwColor(AFont.color)+';'
               +'font-family:'''+AFont.name+''';'
               +'font-size:'+IntToStr(AFont.size)+'pt;';

     //粗体
     if fsBold in AFont.Style then begin
          Result    := Result+'font-weight:bold;';
     end else begin
          Result    := Result+'font-weight:normal;';
     end;

     //斜体
     if fsItalic in AFont.Style then begin
          Result    := Result+'font-style:italic;';
     end else begin
          Result    := Result+'font-style:normal;';
     end;

     //下划线
     if fsUnderline in AFont.Style then begin
          Result    := Result+'text-decoration:underline;';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end else begin
               Result    := Result+'text-decoration:none;';
          end;
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     iTri      : Integer;     //用于绘制三角形的正方形边长
     sCode     : string;
     sSize     : string;
     sName     : string;
     //
     joHint    : Variant;
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));


     with TSpeedButton(ACtrl) do begin
          //添加外框
          joRes.Add('<div'
               +dwVisible(TControl(ACtrl))
               +dwDisable(TControl(ACtrl))
               +dwLTWH(TControl(ACtrl))
               +dwIIF(Flat,'','border:1px solid #E8E8E8;')
               +'overflow:hidden;'
               +'"'
               +'>');

          //左上提示三角，   颜色为groupindex
          if Layout = blGlyphRight then begin
               iTri := Round(Width / 2.5);
               joRes.Add('<div'
                         +' v-if="'+ACtrl.Name+'__tri"'
                         +' style="position:absolute;'
                         +'left:'+IntToStr(Round(Width-iTri*0.5))+'px;'
                         +'top:'+IntToStr(Round(-iTri*0.707))+'px;'
                         +'width:'+IntToStr(iTri)+'px;height:'+IntToStr(iTri)+'px;'
                         +'background-color:'+dwColor(groupindex)+';'
                         +'transform:rotate(45deg);"></div>');
          end else if Layout = blGlyphTop then begin
               iTri := Round(Width / 10);
               joRes.Add('<el-badge'
                         +' v-if="'+ACtrl.Name+'__bdg"'
                         +' :value="'+ACtrl.Name+'__spc"'
                         +' :max="'+ACtrl.Name+'__max"'
                         +' :type="'+Name+'__typ"'
                         +' class="item"'
                         +' style="position:absolute;'
                         +'left:'+IntToStr(Round(Width-iTri*3))+'px;'
                         +'top:'+IntToStr(Round(iTri))+'px;'
                         //+'width:'+IntToStr(iTri)+'px;height:'+IntToStr(iTri)+'px;'
                         //+'background-color:'+dwColor(groupindex)+';'
                         +'">'
                         +'<el-button  v-if="false" ></el-button>'
                         +'</el-badge>');
          end else if Layout = blGlyphBottom then begin
               iTri := Round(Width / 10);
               joRes.Add('<el-badge'
                         +' v-if="'+ACtrl.Name+'__idt"'
                         +' is-dot'
                         +' class="item"'
                         +' style="position:absolute;'
                         +'left:'+IntToStr(Round(Width-iTri*3))+'px;'
                         +'top:'+IntToStr(Round(iTri*1.5))+'px;'
                         +'">'
                         +'<el-button  v-if="false" ></el-button>'
                         +'</el-badge>');
          end;

          //图标
          joRes.Add('<el-image'
               +' :src="'+Name+'__src"'
               +' fit="none"'
               +_ImageLTWH(TControl(ACtrl))
               +'cursor: pointer;'   //图片鼠标样式
               +'"'
               +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
               +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
               +dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
               +'></el-image>');

          //文本
          joRes.Add('<div'
               +' v-html="'+Name+'__cap"'
               +_LabelLTWH(TControl(ACtrl))
               +_GetFont(Font)
               //style
               +'text-align:center;'
               +'line-height:'+IntToStr(Round(Font.Size * _K))+'px;'
               +'cursor: pointer;'   //图片鼠标样式
               +'"'
               //style 封闭
               +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
               +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
               +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
               +'>{{'+Name+'__cap}}</div>');
     end;

     //
     Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //生成返回值数组
     joRes.Add('</div>');          //此处需要和dwGetHead对应

     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TSpeedButton(ACtrl) do begin
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__imh:"'+IntToStr(Height-Round(Font.Size*2))+'px",');
          joRes.Add(Name+'__lbt:"'+IntToStr(Height-Round(Font.Size*_K))+'px",');
          joRes.Add(Name+'__lbh:"'+IntToStr(Round(Font.Size*_K))+'px",');
          //
          joRes.Add(Name+'__tri:'+dwIIF(Layout = blGlyphRight,'true,','false,'));
          joRes.Add(Name+'__bdg:'+dwIIF(Layout = blGlyphTop,'true,','false,'));
          joRes.Add(Name+'__idt:'+dwIIF(Layout = blGlyphBottom,'true,','false,'));
          joRes.Add(Name+'__spc:'+IntToStr(Spacing)+',');
          joRes.Add(Name+'__max:'+IntToStr(Margin)+',');
          //
          joRes.Add(Name+'__src:"'+dwGetProp(TControl(ACtrl),'src')+'",');
          //
          joRes.Add(Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          //
          joRes.Add(Name+'__typ:"'+dwGetProp(TButton(ACtrl),'type')+'",');
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TSpeedButton(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__imh="'+IntToStr(Height-Round(Font.Size*2))+'px";');
          joRes.Add('this.'+Name+'__lbt="'+IntToStr(Height-Round(Font.Size*_K))+'px";');
          joRes.Add('this.'+Name+'__lbh="'+IntToStr(Round(Font.Size*_K))+'px";');
          //
          joRes.Add('this.'+Name+'__tri='+dwIIF(Layout = blGlyphRight,'true;','false;'));
          joRes.Add('this.'+Name+'__bdg='+dwIIF(Layout = blGlyphTop,'true;','false;'));
          joRes.Add('this.'+Name+'__idt='+dwIIF(Layout = blGlyphBottom,'true;','false;'));
          joRes.Add('this.'+Name+'__spc='+IntToStr(Spacing)+';');
          joRes.Add('this.'+Name+'__max='+IntToStr(Margin)+';');
          //
          joRes.Add('this.'+Name+'__src="'+dwGetProp(TControl(ACtrl),'src')+'";');
          //
          joRes.Add('this.'+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          joRes.Add('this.'+Name+'__typ="'+dwGetProp(TButton(ACtrl),'type')+'";');
     end;
     //
     Result    := (joRes);
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethod,
     dwGetData;
     
begin
end.
 
