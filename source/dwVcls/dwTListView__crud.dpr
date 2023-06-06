library  dwTListView__crud;
{�������Ͻ�ֱ���޸Ĵ��룡����}

uses
    System.ShareMem,      //�������
    //
    dwCtrlBase,
    dwDB,
    //
    SynCommons,
    //
    FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MSAcc,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.ADSDef,
    FireDAC.Phys.FBDef, FireDAC.Phys.PGDef, FireDAC.Phys.IBDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef,
    FireDAC.Phys.DB2Def, FireDAC.Phys.InfxDef, FireDAC.Phys.TDataDef, FireDAC.Phys.ASADef,
    FireDAC.Phys.MongoDBDef, FireDAC.Phys.DSDef, FireDAC.Phys.TDBXDef, FireDAC.Phys.TDBX,
    FireDAC.Phys.TDBXBase, FireDAC.Phys.DS, FireDAC.Phys.MongoDB, FireDAC.Phys.ASA,
    FireDAC.Phys.TData, FireDAC.Phys.Infx, FireDAC.Phys.DB2, FireDAC.Phys.Oracle, FireDAC.Phys.SQLite,
    FireDAC.Phys.IB, FireDAC.Phys.PG, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Phys.ADS,
    FireDAC.Phys.MySQL, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML, FireDAC.Stan.StorageBin,
    FireDAC.Moni.FlatFile, FireDAC.Moni.Custom, FireDAC.Moni.Base, FireDAC.Moni.RemoteClient,
    //
    Math,
    StrUtils,
    Generics.Collections,
    Messages,
    Graphics,
    ComCtrls,
    ExtCtrls,
    Data.DB,
    ADODB,
    Vcl.DBGrids,
    SysUtils,
    Variants,
    Classes,
    Dialogs,
    StdCtrls,
    Windows,
    Controls,
    Forms;
//function _PreprocessHint(var AHint:Variant):Integer; //Ԥ����Hint, ������ڵ�Ĭ����
function _PreprocessHint(var AHint:Variant):Integer;
begin
    //������ԣ��粻���ڣ���Ĭ��ֵ
    //����
    dwSetDefaultObj(AHint,'merge',_json('[]'));
    dwSetDefaultObj(AHint,'summary',_json('[]'));
    dwSetDefaultObj(AHint,'__selection',_json('[]'));
    //��ɫ
    dwSetDefaultStr(AHint,'headbkcolor','#f8f8f8');
    dwSetDefaultStr(AHint,'hover','#f5f5f5');
    dwSetDefaultStr(AHint,'record','rgb(224,243,255)');   //��ǰ��¼λ����ɫ 
    //��ֵ
    dwSetDefaultInt(AHint,'rowheight',40);
    dwSetDefaultInt(AHint,'headerheight',40);
    dwSetDefaultInt(AHint,'summaryheight',40);
    dwSetDefaultInt(AHint,'pagesize',10);
    //
    dwSetDefaultStr(AHint,'__sort','');
    dwSetDefaultStr(AHint,'__search','');
    //
    dwSetDefaultStr(AHint,'dataset','');
    dwSetDefaultStr(AHint,'topstyle','');
    dwSetDefaultStr(AHint,'datastyle','');
    //����ֵ
    Result  := 0;                             
end;

//function _GetFontWeight(AFont:TFont):String; //ȡ�������
function _GetFontWeight(AFont:TFont):String;
begin
    if fsBold in AFont.Style then begin
        Result    := 'bold';
    end else begin
        Result    := 'normal';
    end;
end;

//function _GetFontStyle(AFont:TFont):String; //ȡ����б��
function _GetFontStyle(AFont:TFont):String;
begin
    if fsItalic in AFont.Style then begin
        Result    := 'italic';
    end else begin
        Result    := 'normal';
    end;
end;

//function _GetTextDecoration(AFont:TFont):String; //ȡ�����»���/ɾ����
function _GetTextDecoration(AFont:TFont):String;
begin
    if fsUnderline in AFont.Style then begin
        Result    :='underline';
        if fsStrikeout in AFont.Style then begin
            Result    := 'line-through';
        end;
    end else begin
        if fsStrikeout in AFont.Style then begin
            Result    := 'line-through';
        end else begin
            Result    := 'none';
        end;
    end;
end;

//function _GetModule(AHint:Variant;AIndex:Integer):Boolean; //ģ���Ƿ���ʾ���ã�Ϊ����/��/ɾ/��/��/��
//0:������1/2/3/4��ɾ�Ĳ飬5��ҳ
function _GetModule(AHint:Variant;AIndex:Integer):Boolean;
begin
    Result  := True;
    //0,1,2,3,4,5 �� ��/��/ɾ/��/��/��ҳ
    if AIndex in [0,1,2,3,4,5] then begin
        if AHint.Exists('module') then begin
            if AHint.module._Count>AIndex then begin
                Result  := AHint.module._(AIndex)<>0;
            end;
        end;
    end;
end;

//function _GetFields(AGrid:TListView):Variant; //ȡ�ֶ�JSON��������
function _GetFields(AGrid:TListView):Variant;
var
    iCol    : Integer;
    iFullW  : Integer;  //DBGrid�ܿ��
    iSumW   : Integer;  //�����ܺ�
    iL      : Integer;
    //W
    fRatio  : Double;   //���ű���
    //
    sCapt   : string;
    //
    joField : Variant;
begin
    Result  := _json('[]');
    //�����������ֶεĿ���ܺ�iSumW = 0.Ҳ����ǰ�е�left
    iSumW   := 0;
    //ȡ�ø��ֶε����ԣ����û�У�������ΪĬ��ֵ����ȡ��iSumW
    for iCol := 0 to AGrid.Columns.Count-1 do begin
        //����caption����JSON
        joField := _json(AGrid.Columns[iCol].Caption);
        //���Caption����JSON������ֶ���Ϣ������
        if joField = unassigned then begin
            //�����ֶ���Ϣ�������ֶ�JSON����joField
            joField             := _json('{}');
            joField.type        := 'string';
            joField.fieldname   := '';
            joField.width       := AGrid.Columns[iCol].Width;
            joField.caption     := AGrid.Columns[iCol].Caption;
            joField.color       := dwColor(AGrid.Font.Color);
            joField.bkcolor     := 'transparent';
            joField.align       := dwGetAlignment(AGrid.Columns[iCol].alignment);
        end;
        //����Ĭ����
        dwSetDefaultStr(joField,'type','string');
        dwSetDefaultInt(joField,'width',AGrid.Columns[iCol].Width);
        dwSetDefaultStr(joField,'fieldname','');
        dwSetDefaultStr(joField,'caption',joField.fieldname);
        dwSetDefaultStr(joField,'color',dwColor(AGrid.Font.Color));
        dwSetDefaultStr(joField,'bkcolor','transparent');
        dwSetDefaultStr(joField,'align',dwGetAlignment(AGrid.Columns[iCol].alignment));
        dwSetDefaultInt(joField,'sort',0);
        //dwSetDefaultInt(joField,'minvalue',0);
        //dwSetDefaultInt(joField,'maxvalue',100);
        dwSetDefaultObj(joField,'readonly',0);
        joField.left := iSumW;
        //�����ֶο��֮��
        iSumW   := iSumW + joField.width;
        //Ĭ��viewwidth
        joField.viewwidth   := joField.width;
        //����ǰ�ֶ���ӵ�����ֵJSON����
        Result.Add(joField);
    end;
    //�������Ч�ֶ���Ϣ�����˳�
    if (Result._Count = 0) or ((Result._Count = 1) and ((Result._(0).fieldname = ''))) then begin
        Exit;
    end;
    //������ʾ���viewwidth
    //ȡ��Grid���iFullW����
    iFullW  := AGrid.Width;
    //���Grid��� > ���п��֮��
    if iFullW>iSumW then begin
        if Result._(Result._Count-1).type = 'button' then begin
            //��չ������2�п��
            Result._(Result._Count-2).viewwidth := Result._(Result._Count-2).viewwidth + iFullW - iSumW - 9;
        end else begin
            //��չ������1�п��
            Result._(Result._Count-1).viewwidth := Result._(Result._Count-1).viewwidth + iFullW - iSumW - 9;
        end;
    end;
end;

//function _GetTitleCount(AHint:Variant):Integer;
//ȡ����������
function _GetTitleCount(AHint:Variant):Integer;
var
    iItem   : Integer;
    iCount  : Integer;
    
begin
    Result  := 1;
    for iItem := 0 to AHint.merge._Count - 1 do begin
        Result  := Max(Result,AHint.merge._(iItem)._(0));
    end;
end;

//function _GetSumCount(AHint:Variant):Integer;
//ȡ����������
function _GetSumCount(AHint:Variant):Integer;
var
    iSum    : Integer;
    iCount  : Integer;
    iItem   : Integer;
begin
    Result  := 0;
    for iSum := 1 to AHint.summary._Count - 1 do begin
        iCount  := 1;
        for iItem := 1 to iSum-1 do begin
            if AHint.summary._(iSum)._(0) = AHint.summary._(iItem)._(0) then begin
                iCount  := iCount + 1;
            end;
        end;
        Result := Max(Result,iCount);
    end;
end;

//function _GetTitleHtml(AGrid:TListView;AHint,AFields:Variant):string;
//������ͷHTML�ַ���
function _GetTitleHtml(AGrid:TListView;AHint,AFields:Variant):string;
var
    iL,iT   : Integer;
    iW,iH   : Integer;
    iCol    : Integer;
    iLevel  : Integer;  //��ͷ�Ĳ��
    iStart  : Integer;  //��ͷ�ϲ��Ŀ�ʼ��ţ���0��ʼ ���ռ�Ϊ[]
    iEnd    : Integer;  //��ͷ�ϲ��Ľ�����ţ���0��ʼ
    iItem   : Integer;
    iCount  : Integer;  //��ͷ�л��з��ĸ��������ڼ���TOp
    iTop    : Integer;
    iMax    : Integer;
    iHeadH  : Integer;
    //
    sCapt   : String;
    sFull   : string;
    //
    joField : Variant;
    joMerge : Variant;
    joCols  : Variant;
    joItem  : Variant;
const
    //���⻻�к�����topֵ
    _TOPS   : array[0..5] of Integer = (-4,-12,-24,-32,-42,-54);
begin
    iMax    := _GetTitleCount(AHint);
    iHeadH  := dwGetInt(AHint,'headerheight',40);
    //������ֶα�ͷ�ĸ߶ȣ�¥�㣩,������joFields.max
    for iCol := 0 to AFields._Count - 1 do begin
        //Ĭ��Ϊ���¥���
        //ȡ�õ�ǰ�ֶ�JSON����
        joField     := AFields._(iCol);
        //Ĭ��Ϊ���¥���
        joField.max := iMax;
        for iItem := 0 to AHint.merge._Count - 1 do begin
            //ȡ��ǰ��ͷ�ϲ���Ϣ
            iLevel  := AHint.merge._(iItem)._(0)-1;  //¥��
            iStart  := AHint.merge._(iItem)._(1);  //��ʼ���
            iEnd    := AHint.merge._(iItem)._(2);  //�������
            //�����ǰ���ںϲ���Χ֮�У��򽵵�¥��
            if (iCol>=iStart) and (iCol<=iEnd) then begin
                AFields._(iCol).max := Min(AFields._(iCol).max,iLevel);
            end;
        end;
    end;
    //����max������ֶα�ͷ��T/H�������joField.top/height
    for iCol := 0 to AFields._Count - 1 do begin
        joField := AFields._(iCol);
        //
        joField.top     := ( iMax - joField.max ) * iHeadH;
        joField.height  := joField.max * iHeadH;
    end;
    //����HTML
    //���ɱ��������(�ײ�) dg__tit
    sFull   := dwFullName(AGrid);
    Result  := Concat('<div',
            ' id="'+sFull+'__tit"',
            ' :style="{',
                'left:'+sFull+'__ttl',       //ttl : title left
            '}"',
            ' style="',
                'position:absolute;',
                'top:-1px;',
                //'color: #606266;',
                'color:'+dwColor(AGrid.Font.Color),
                'background: linear-gradient(#f4f5f8,#f1f3f6);',
                'z-index:9;',
                'height:'+IntToStr(iMax*iHeadH)+'px;',
            '"',
            '>');
    //���ɺϲ��ֶ�merge�����HTML
    for iItem := 0 to AHint.merge._Count - 1 do begin
        //ȡ��Top/CAPTION����
        joMerge := AHint.merge._(iItem);
        //
        iT      := iHeadH * (iMax-joMerge._(0));
        sCapt   := joMerge._(3);
        Result  := Result + Format(#13'                <div class="'+sFull+'dwdbgridtitle"'
                + ' :style="{'
                    +'left:'+sFull+'__ml%d,'
                    +'width:'+sFull+'__mw%d'
                +'}"'
                +' style="'
                   +'position:absolute;top:%dpx;height:%dpx;'
                +'"'
                +'>'
                +'<span style="display:inline-block;">'
                    +'%s'
                +'</span>'
                +'</div>',
                [iItem,iItem,iT,iHeadH-1,sCapt]);
    end;
    //���ɸ��ֶα����HTML
    for iCol := 0 to AFields._Count - 1 do begin
        //ȡ��LTWH/CAPTION����
        joField := AFields._(iCol);
        //
        iL      := joField.left;
        iT      := joField.top;
        iW      := joField.viewwidth;
        iH      := joField.height;
        sCapt   := joField.caption;
        
        if joField.type = 'check' then begin
            Result  := Result + Format(
                    #13'<el-checkbox'
                    +' v-model="'+sFull+'__cb'+IntToStr(iCol)+'"'
                    +' class="'+sFull+'dwdbgridtitle"'
                    +' :style="{'
                        +'left:'+sFull+'__fl%d,'
                        +'width:'+sFull+'__fw%d'
                    +'}"'
                    +' style="'
                       +'position:absolute;'
                       +'top:%dpx;'
                       +'height:%dpx;'
                       +'line-height:%dpx;'
                    +'"'
                    +' @change='''+sFull+'__cc'+IntToStr(iCol)+''''
                    +'>'
                    +'</el-checkbox>',
                    [iCol,iCol,iT,iH,iH,iCol]);
        end else begin
            Result  := Result + Format(#13'                '
                    +'<div class="'+sFull+'dwdbgridtitle"'
                	+ ' :style="{'
                		+'left:'+sFull+'__fl%d,'
                		+'width:'+sFull+'__fw%d'
                	+'}"'
                	+' style="'
                		+'position:absolute;top:%dpx;height:%dpx;'
                	+'">'
                		+'<div>'
                		+'<span style="display:inline-block;">'
                			+'%s'
                		+'</span>',
                		[iCol,iCol,iT,iH,sCapt]);
            if joField.sort=1 then begin
                //�õ�����Ļ��и���
                iCount  := dwSubStrCount(sCapt,'<br/>');
                //����Top������ʾ����ť
                if iCount <= 5 then begin
                    iTop    := _Tops[iCount];
                end else begin
                    iTop    := -42-10*(iCount-4);
                end;
                Result  := Result
                        + '<span class="caret-wrapper"'
                            +' style="'
                                +'display: inline-flex;'
                                +'flex-direction: column;'
                                +'top: '+IntToStr(iTop)+'px;'     //���ݱ�����<br/>�ĸ�������top
                                +'position: relative;'
                            +'"'
                        +'>'
                        +'<i class="el-icon-caret-top"'
                            //+' @click=''dwevent('
                            //        +'"",'
                            //        +'"'+sFull+'",'
                            //        +'"'+IntToStr(iCol)+'",'
                            //        +'"onsortasc",'
                            //        +IntToStr(TForm(AGrid.Owner).Handle)
                            //+');'''
                            +' @click="'+sFull+'__sortasc($event,'+IntToStr(iCol)+')"'            
                        +'></i>'
                        +'<i class="el-icon-caret-bottom"'
                            //+' @click=''dwevent('
                            //        +'"",'
                            //        +'"'+sFull+'",'
                            //        +'"'+IntToStr(iCol)+'",'
                            //        +'"onsortdesc",'
                            //        +IntToStr(TForm(AGrid.Owner).Handle)
                            //+');'''
                            +' @click="'+sFull+'__sortdesc($event,'+IntToStr(iCol)+')"'            
                        +'>'
                        +'</i>'
                        +'</span>';
            end;
            Result  := Result + '</div></div>';
        end;
    end;
    //���ɱ��������(β��) dg__tit
    Result  := Result + '</div>';
end;

//function _GetSQL(ACtrl:TComponent;var AOldSQL:String):Boolean;
function _GetSQL(ACtrl:TComponent;var AOldSQL:String):Boolean;
var
    iPos        : Integer;
    iSelect     : Integer;   //Select λ��
    iFrom       : Integer;   //from  λ��
    iWhere      : Integer;   //where λ��
    iGroup      : Integer;   //group λ��
    iGroupBy    : Integer;   //group ��� by λ��
    iOrder      : Integer;   //order λ��
    iOrderBy    : Integer;   //order ��� by λ��
    iStart      : Integer;
    iEnd        : Integer;
    //
    sSQL        : string;
    sTmp        : string;
    //
    oDataSet    : TDataSet;
    //
    joHint      : Variant;
    
begin
    //Ĭ��ֵ
    AOldSQL     := '';  //ȥ���ֶ��б��е�as
    Result  := False;
    //ȡ��HINT����JSON
    joHint    := dwGetHintJson(TControl(ACtrl));
    if joHint.Exists('__oldsql') then begin
        //��HINT��JSON������ֱ��ȡSQL�ؼ���Ϣ
        AOldSQL     := joHint.__oldsql;
        //
        Result  := True;
        Exit;
    end else begin
        with TListView(ACtrl) do begin
            oDataSet    := nil;
            if ( joHint.dataset<> '' ) then begin
                //ȡDataSet
                oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
            end;
            //��oDataSet = nil�� ���˳�
            if oDataSet = nil then begin
                Exit;
            end;
            if oDataSet.ClassName <> 'TFDQuery' then begin
                Exit;
            end;
            AOldSQL := LowerCase(Trim(TFDQuery(oDataSet).SQL.Text));
            //��������浽Hint��
            joHint.__oldsql     := AOldSQL;
            Hint                := joHint;
            
            //
            Result  := True;
        end;
    end;
end;

//function _UpdateQuery(ACtrl:TComponent):Integer; //ȡ��ҳ���ݣ����ؼ�¼��
function _UpdateQuery(ACtrl:TComponent):Integer;
var
    iPos        : Integer;
    iPageSize   : Integer;
    iOldRecNo   : Integer;
    //
    sSQL        : string;
    sOldSQL     : string;
    s0          : string;   //���ڷ�ҳʱ���м�SQL�ַ���
    //
    sField      : string;   //SQL���ֶ��б�
    sTable      : string;   //SQL�ı���
    sWhere      : string;   //SQL��WHERE��ԭʼ��   ǰ���� WHERE
    sGroup      : string;   //SQL��GROUP           ǰ���� GROUP BY
    sOrder      : string;   //SQL��ORDER��ԭʼ��   ǰ���� ORDER BY
    sSort       : string;   //�û�����������ַ��� ǰ���� ORDER BY
    sSearch     : String;   //�û�����ؼ������ɵ�WHERE�� ����WHERE (...)
    sPrimaryKey : string;   //���������õ��ֶΣ�Ĭ��Ϊid
    sDB         : string;   //���ݿ����ͣ�Ĭ��Ϊͨ�ã���ѡ����mssql, mysql, sqlite, oracle��
    //
    oDataSet    : TDataSet;
    //
    joHint      : Variant;
    oAfter      : Procedure(DataSet: TDataSet) of Object;
    oBefore     : Procedure(DataSet: TDataSet) of Object;
begin
    //Ĭ��ֵ :  0
    Result  := 0;
    _GetSQL(ACtrl,sOldSQL);
    //Ԥ����ȡ�����ò���
    //ȡ��HINT����joHint,��Ԥ����
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    //ȡpagesize
    iPageSize   := dwGetInt(joHint,'pagesize',10);
    with TListView(ACtrl) do begin
        //ȡ oDataSet,����⡣�粻���ڻ��TFDQuery,���˳�
        oDataSet    := nil;
        if ( joHint.dataset<> '' ) then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        if oDataSet = nil then begin
            Exit;
        end;
        if oDataSet.ClassName <> 'TFDQuery' then begin
            Exit;
        end;
        iOldRecNo   := oDataSet.RecNo;
        //�����Ƿ�append״̬,�ֱ���
        if Cursor = crCross then begin
            //append״̬
            joHint.__recordcount := oDataSet.RecordCount;
            Hint    := joHint;
            Result  := oDataSet.RecordCount;
        end else begin
            //������������
            //ȡ�����ֶ��������ڸ���select top,Ĭ��Ϊid.����Hint��дprimarykey
            sPrimaryKey := 'id';
            if joHint.Exists('primarykey') then begin
                sPrimaryKey := joHint.primarykey;
            end;
            //ȡ�ùؼ����� sSort/sSearch
            sSort   := dwGetStr(joHint,'__sort','');
            sSearch := dwGetStr(joHint,'__search','');
            sWhere  := sSearch;
            //�ϲ�sSort/sOrder �� sOrder, ��ʱsOrder����'ORDER BY'��ʼ
            if sSort <> '' then begin
                sOrder := sSort;
            end;
            //Ϊ�ǿ�sGroup����group by
            if sGroup <> '' then begin
                sGroup  := ' GROUP BY ' + sGroup;
            end;
            //���²�ѯ��ȡ��RecordCount,���浽joHint.__recordcount
            with TFDQuery(oDataSet) do begin
                DisableControls;
                
                //����ԭ�¼�����
                oAfter  := AfterScroll;
                oBefore := BeforeScroll;
                //����¼�
                AfterScroll    := nil;
                BeforeScroll   := nil;
                //ִ��SQL
                Close;
                S0          := Format('SELECT %s FROM %s %s %s',[sField,sTable,sWhere,sGroup]);
                SQL.Text    := Format('SELECT count(*) FROM (%s) A %s',[sOldSQL,sWhere]);
                FetchOptions.RecsSkip   := 0;
                FetchOptions.RecsMax    := -1;
                Open;
                joHint.__recordcount := Fields[0].AsInteger; 
                Hint    := joHint;
                Result  := Fields[0].AsInteger; 
                EnableControls;
                //�ָ�ԭ�¼�����
                AfterScroll    := oAfter;
                BeforeScroll   := oBefore;
            end;
            //���²�ѯ��ȡ�����ݼ�,����
            with TFDQuery(oDataSet) do begin
                if sOrder <> '' then begin
                    sOrder := ' ORDER BY ' + sOrder;
                end else begin
                    sOrder := ' ORDER BY ' + sPrimaryKey;
                end;
                //�Ƿ��ҳ,Ȼ���ѯ
                if iPageSize = 9999 then begin
                    //9999
                    Close;
                    SQL.Text    := Format('SELECT %s FROM %s %s %s %s',[sField,sTable,sWhere,sGroup,sOrder]);
                    Open;
                end else begin
                    Close;
                    SQL.Text    := Format('SELECT * FROM (%s) A %s %s',[sOldSQL,sWhere,sOrder]);
                    FetchOptions.RecsSkip   := iPageSize * HelpContext;
                    FetchOptions.RecsMax    := iPageSize;
                    Open;
                end;
                //�ָ�ԭ��λ��
                if (oDataSet.RecordCount>=iOldRecNo)and(iOldRecNo>0) then begin
                    oDataSet.RecNo  := iOldRecNo;
                end;
            end;
        end;
    end;
end;

//---------------------����Ϊ��������---------------------------------------------------------------
function dwGetExtra(ACtrl: TComponent): string; stdcall;
var
    joRes       : Variant;
    joHint      : Variant;
    //
    sCode           : string;
    sFull           : string;
    sHeaderBKColor  : string;
    sEvenBKColor    : string;   //ż���б���ɫ

    //
    iRowH           : Integer;
    iColW           : Integer;
    iRowHeight      : Integer;
    iHeaderHeight   : Integer;
begin
    joRes    := _Json('[]');
    joHint  := dwGetHintJson(TListView(Actrl));
    //�õ��и�
    iRowHeight  := dwGetInt(joHint,'rowheight',40);
    
    //�õ��������и�
    iHeaderHeight   := dwGetInt(joHint,'rowheight',40);
    
    //�õ�����������ɫ
    sHeaderBKColor  := dwGetStr(JoHint,'headerbkcolor','#f8f9fe');
    
    //��������ɫ
    sEvenBkColor    := dwGetStr(JoHint,'evenbkcolor','#f8f9fe');
    
    //
    sFull           := dwFullName(ACtrl);
    with TListView(ACtrl) do begin
        sCode   := '<style>'
        		+' .'+sFull+'dwdbgridtitle{'
                    +'position:absolute;'
        			+dwIIF(BorderStyle=bsSingle,'text-align:center;','text-align:left;')
        			//+'text-align:left;'
        			+dwIIF(BorderStyle=bsSingle,'','padding-left:5px;')
        			+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ebeef5;','border-top:solid 1px #dcdfe6;border-bottom:solid 1px #ebeef5;')
        			+'font-weight:bold;'
                    +'overflow:hidden;'
                    //+'background-color:#fafafa;'//+sHeaderBKColor+';'            
                    //+'background: linear-gradient(rgb(244, 245, 248), rgb(241, 243, 246));'
        			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'color:'+dwColor(Font.Color)+';'
        			//+'line-height:'+IntToStr(iHeaderHeight)+'px;'
                    +'justify-content: center;'
                    +'flex-direction: column;'
                    +'display: flex;'
        		+'}'
        		+' .'+sFull+'dwdbgrid0{'
                    +'position:absolute;'
        			//+'text-align:center;'
                    +'padding-left:5px;padding-right:5px;'
        			+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ebeef5;','border-top:solid 1px #ebeef5;border-bottom:solid 1px #ebeef5;')
                    +'outline:none;'
        			+'overflow:hidden;'
        			//+'border:solid 1px #ececec;'
        			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'color:'+dwColor(Font.Color)+';'
        			+'height:'+IntToStr(iRowHeight-1)+'px;'
        			+'line-height:'+IntToStr(iRowHeight-1)+'px;'
                    +'white-space: nowrap;'     //������
        		+'}'
                +'</style>';
        //�����Ӧ�Ŀ�
        joRes.Add(sCode);
        
        //
        sCode   := '<style>'
                +'.dwscroll_bottom::-webkit-scrollbar {/*������������ʽ*/'
                    +'width:5px;/*�߿�ֱ��Ӧ�����������ĳߴ�*/'
                    +'height:5px;'
                +'}'
                +'.dwscroll_bottom::-webkit-scrollbar-thumb {/*����������С����*/'
                    +'border-radius:5px;'
                    +'-webkit-box-shadow: inset005pxrgba(0,0,0,0.2);'
                    +'background:rgba(0,0,0,0.2);'
                +'}'
                +'.dwscroll_bottom::-webkit-scrollbar-track {/*������������*/'
                    +'-webkit-box-shadow: inset005pxrgba(0,0,0,0.2)'
                    +'border-radius:0;'
                    +'background:rgba(0,0,0,0.1);'
        		+'}'
                +'</style>';
        
        //�����Ӧ�Ŀ�
        joRes.Add(sCode);
        
        
        //
        Result    := joRes;
    end;
end;

//function dwGetEvent(ACtrl: TComponent; AData: string): string; stdcall;
function dwGetEvent(ACtrl: TComponent; AData: string): string; stdcall;
var
    //
    iCol        : Integer;
    iItem       : Integer;
    iColId      : Integer;
    iOldRecNo   : Integer;
    iRecNo      : Integer;
    iPageSize   : Integer;
    //
    bFound      : Boolean;
    //
    sValue      : String;
    sField      : string;
    sOldSQL     : string;
    sTable      : string;
    sWhere      : String;
    sGroup      : string;
    sOrder      : string;
    sSort       : string; //���ڼ�¼������Ϣ��__sort
    sSearch     : string; //���ڼ�¼������Ϣ��__search
    sDBFields   : string;
    sNewWhere   : String;
    sJS         : string;
    sFull       : string;
    sPrimaryKey : string;  //���ݱ����������ڸ���select top��Ĭ��Ϊid,��joHint.primarykey
    //
    oDataSet    : TDataSet;
    //
    joData      : Variant;
    joHint      : Variant;
    joValue     : Variant;
    joFields    : Variant;
    joField     : Variant;
    joSelection : variant;
begin
    //ȡjoData,joHint,sFull
    joData  := _Json(AData);
    joHint  := dwGetHintJson(TControl(ACtrl));
    _PreProcessHint(joHint);
    sFull   := dwFullName(Actrl);
    if joData = unassigned then begin
        Exit;
    end;
    with TListView(ACtrl) do begin
        //ȡDataSet. Ϊnil���˳�
        oDataSet    := nil;
        if ( joHint.dataset<> '' ) then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        if oDataSet = nil then begin
            Exit;
        end;
        joFields    := _GetFields(TListView(ACtrl));
        oDataSet.DisableControls;
        //�����¼����ƣ��ֱ���
        if joData.e = 'oncompclick' then begin
            //joData.e = 'oncompclick'
        end else if joData.e = 'onappend' then begin
            oDataSet.Append;
            for iCol := 0 to joFields._Count-1 do begin
                joField    := joFields._(iCol);
                if joField.fieldname <> '' then begin
                    if joField.Exists('default') then begin
                        oDataSet.FieldByName(joField.fieldname).AsVariant   := joField.default;
                    end else begin
                        if oDataSet.FieldByName(joField.fieldname).DataType in [ftString, ftMemo, ftFmtMemo,ftWideString, ftFixedWideChar, ftWideMemo ] then begin
                            oDataSet.FieldByName(joField.fieldname).AsString   := '';
                        end;
                    end;
                end;
            end;
            oDataSet.Post;
            oDataSet.Refresh;
            //����Cursor Ϊ crCross ��ʶ��ǰΪ�������� ����������
            Cursor  := crCross;
            //�����¼�¼��ֵ(���������һ�Σ�����ʾ�ϴεļ�¼ֵ)
            sJS := '';
            for iCol := 0 to joFields._Count-1 do begin
                joField    := joFields._(iCol);
                if joField.fieldname <> '' then begin
                    if (joField.type='integer') or (joField.type='rate') then begin
                        sJS := sJS + 'this.'+sFull+'__di'+IntToStr(iCol)+'=0;'
                    end else begin
                        if joField.Exists('default') then begin
                            sJS := sJS + 'this.'+sFull+'__di'+IntToStr(iCol)+'="'+joField.default+'";'
                        end else begin
                            sJS := sJS + 'this.'+sFull+'__di'+IntToStr(iCol)+'="";'
                        end;
                    end;
                end;
            end;
        end else if joData.e = 'onappendcancel' then begin
            oDataSet.Delete;
            //����Cursor Ϊ crDefault ��ʶ��ǰ��Ϊ�������Ը�������
            Cursor  := crDefault;
        end else if joData.e = 'oneditsave' then begin
            //�õ������ַ�����JSON�����ʽ,0ʼ
            sValue  := dwUnescape(joData.v);
            joValue := _json(sValue);
            //����Cursor Ϊ crDefault ��ʶ��ǰ��Ϊ�������Ը�������
            Cursor  := crDefault;
            oDataSet.Edit;
            for iCol := 0 to joFields._Count-1 do begin
                joField    := joFields._(iCol);
                if joField.fieldname <> '' then begin
                    if oDataSet.FieldByName(joField.fieldname).DataType <> ftAutoInc then begin
                        oDataSet.FieldByName(joField.fieldname).AsString   := joValue._(iCol);
                    end;
                end;
            end;
            oDataSet.Post;
            oDataSet.Refresh;
        end else if joData.e = 'onclick' then begin
            //�õ���¼λ�ú������
            iCol    := joData.v mod 100;
            iRecNo  := joData.v div 100;
            //�ƶ����ݱ�λ��
            oDataSet.RecNo := iRecNo;
        end else if joData.e = 'onquery' then begin
            //vΪ�����ؼ��֣����ܶ���� sValue
            sValue  := Trim(dwUnescape(joData.v));
            //�õ�ǰΪ��1ҳ����HelpContext := 0;
            HelpContext := 0;
            //���ɵ�ǰ���е��ֶ����б� sDBFields���磺name,model,age,memo
            sDBFields   := '';
            for iCol := 0 to joFields._Count-1 do begin
                joField     := joFields._(iCol);
                if joField.fieldname <> '' then begin
                    sDBFields   := sDBFields + '['+joField.fieldname + '],';
                end;
            end;
            Delete(sDBFields,Length(sDBFields),1);
            //���ɹؼ��ֵ�WHERE,��д__search
            sNewWhere   := dwGetWhere(sDBFields,sValue);
            joHint.__search := sNewWhere;
            Hint    := joHint;
            _UpdateQuery(ACtrl);
        end else if joData.e = 'onsortasc' then begin
            //��vȡ�����iColId
            iColId  := StrToIntDef(joData.v,0);
            //iColId����Χ�����˳�
            if (iColId<0)or(iColId>joFields._Count-1) then begin
                Exit;
            end;
            //iColId�ֶ���fieldname�����˳�
            if joFields._(iColId).fieldname='' then begin
                Exit;
            end;
            //ȡԭSQL�Ĺؼ�Ҫ��
            _GetSQL(ACtrl,sOldSQL);
            //
            sSort    := joHint.__sort;
            sSearch  := joHint.__search;
            //ȡ�����ֶ��������ڸ���select top,Ĭ��Ϊid.����Hint��дprimarykey
            sPrimaryKey := 'id';
            if joHint.Exists('primarykey') then begin
                sPrimaryKey := joHint.primarykey;
            end;
            if sSearch = '' then begin
                if sWhere = '' then begin
                    sWhere  := 'WHERE (1=1)';
                end else begin
                    sWhere  := 'WHERE ('+sWhere+')';
                end;
            end else begin
                if sWhere = '' then begin
                    sWhere  := sSearch;
                end else begin
                    sWhere  := sSearch + ' And ('+sWhere+')';
                end;
            end;
            sOrder  := 'ORDER BY ['+joFields._(iColId).fieldname+'],'+sPrimaryKey;
            joHint.__sort := '['+joFields._(iColId).fieldname+'],'+sPrimaryKey;
            Hint    := joHint;
            _UpdateQuery(ACtrl);
        end else if joData.e = 'onsortdesc' then begin
            //��vȡ�����iColId
            iColId  := StrToIntDef(joData.v,0);
            //iColId����Χ�����˳�
            if (iColId<0)or(iColId>joFields._Count-1) then begin
                Exit;
            end;
            //iColId�ֶ���fieldname�����˳�
            if joFields._(iColId).fieldname='' then begin
                Exit;
            end;
            //ȡԭSQL�Ĺؼ�Ҫ��
            _GetSQL(ACtrl,sOldSQL);
            //
            sSort    := joHint.__sort;
            sSearch  := joHint.__search;
            //ȡ�����ֶ��������ڸ���select top,Ĭ��Ϊid.����Hint��дprimarykey
            sPrimaryKey := 'id';
            if joHint.Exists('primarykey') then begin
                sPrimaryKey := joHint.primarykey;
            end;
            if sSearch = '' then begin
                if sWhere = '' then begin
                    sWhere  := 'WHERE (1=1)';
                end else begin
                    sWhere  := 'WHERE ('+sWhere+')';
                end;
            end else begin
                if sWhere = '' then begin
                    sWhere  := sSearch;
                end else begin
                    sWhere  := sSearch + ' And ('+sWhere+')';
                end;
            end;
            //����__sort
            sOrder  := 'ORDER BY ['+joFields._(iColId).fieldname+'] DESC,'+sPrimaryKey;
            joHint.__sort := '['+joFields._(iColId).fieldname+'] DESC,'+sPrimaryKey;
            Hint    := joHint;
            _UpdateQuery(ACtrl);
        end else if joData.e = 'onpagechange' then begin
            //��vȡҳ�� HelpContext
            HelpContext  := StrToIntDef(joData.v,1)-1;
            _UpdateQuery(ACtrl);
        end else if joData.e = 'onfullcheck' then begin
            if joData.v='true' then begin
                //ȫ��ѡ��
                //__selection д��[-1]��ʾȫ��ѡ��
                joHint.__selection  := _json('[]');
                for iItem := 1 to oDataSet.RecordCount do begin
                    joHint.__selection.Add(iItem);
                end;
                //__selection д��Hint
                Hint    := joHint;
            end else begin
                //ȫ��ȡ��
                //__selection д��[]��ʾȫ����ѡ��
                joHint.__selection  := _json('[]');
                Hint    := joHint;
            end;
            //ִ��OnEndDock�¼�
            if Assigned(OnEndDock) then begin
                if joData.v='true' then begin
                    //ȫ��ѡ��
                    OnEndDock(TListView(ACtrl),nil,3,-1);
                end else begin
                    //ȫ��ȡ��
                    OnEndDock(TListView(ACtrl),nil,3,0);
                end;
            end;
        end else if joData.e = 'onsinglecheck' then begin
            iRecNo  := joData.v div 100;
            joSelection := joHint.__selection;
            //���ȫѡ��־ -1
            for iItem := joSelection._Count-1 downto 0 do begin
                if joSelection._(iItem) = -1 then begin
                    joSelection.Delete(iItem);
                    break;
                end;
            end;
            if joData.v mod 2 = 1 then begin
                //ѡ��
                bFound  := False;
                for iItem := joSelection._Count-1 downto 0 do begin
                    if joSelection._(iItem) = iRecNo then begin
                        bFound  := True;
                        break;
                    end;
                end;
                if not bFound then begin
                    joSelection.Add(iRecNo);
                end;
            end else begin
                //ȡ��
                for iItem := joSelection._Count-1 downto 0 do begin
                    if joSelection._(iItem) = iRecNo then begin
                        joSelection.Delete(iItem);
                        break;
                    end;
                end;
            end;
            Hint    := joHint;
            //ִ��OnEndDock�¼�
            if Assigned(OnEndDock) then begin
                OnEndDock(TListView(ACtrl),nil,3,joData.v div 100);
            end;
        end else if joData.e = 'ondeleteclick' then begin
            joSelection := joHint.__selection;
            //����joSelection����¼�����飩�ֱ���
            if joSelection._Count = 0 then begin
                //δѡ�У���ɾ����ǰ
                oDataSet.Delete;
            //ȫѡ
            end else if joSelection._(0) = -1 then begin
                while not oDataSet.Eof do begin
                    oDataSet.Delete;
                end;
            end else begin
                //����ѡ��
                for iItem := joSelection._Count-1 downto 0 do begin
                    oDataSet.RecNo  := joSelection._(iItem);
                    oDataSet.Delete;
                end;
            end;
            joHint.__selection  := _Json('[]');
            Hint    := joHint;
            //ִ��OnEndDock�¼�
            if Assigned(OnEndDock) then begin
                if joData.v='true' then begin
                    //ȫ��ѡ��
                    OnEndDock(TListView(ACtrl),nil,3,-1);
                end else begin
                    //ȫ��ȡ��
                    OnEndDock(TListView(ACtrl),nil,3,0);
                end;
            end;
        end;
        oDataSet.EnableControls;
    end;
end;

//function dwGetHead(ACtrl: TComponent): string; stdcall;
function dwGetHead(ACtrl: TComponent): string; stdcall;
var
    iItem       : Integer;
    iBtn        : Integer;
    iCol        : Integer;
    iMax        : Integer;
    iTotal      : Integer;      //�ܿ�ȣ����ڿ�Ȳ���
    iRowH       : Integer;      //�и�
    iTopH       : Integer;      //�������߰�ť���߶�
    iPageH      : Integer;      //��ҳ���߶�
    iTitleColW  : Integer;      //������ʾʱ���п�
    iHeaderH    : Integer;      //��ͷ���и�
    iTitleCount : Integer;
    iRecCount   : Integer;      //��¼����
    iSumCount   : Integer;      //
    iSumCol     : Integer;      //���������
    iSum        : Integer;
    iCount      : Integer;
    iL,iT,iW,iH : Integer;
    iTop        : Integer;
    iList       : Integer;
    iPageSize   : Integer;      //��ҳʱÿҳ�ļ�¼���ݣ�Ĭ��10����Ϊ9999���򲻷�ҳ
    //
    sFull       : string;
    sHover      : string;
    sRecord     : string;
    sCols       : String;
    sCode       : string;
    sHeaderBKC  : string;
    sChange     : string;   //���ɼ���༭��OnChange�¼��Ĵ���
    sTopBack    : string;
    sCaption    : string;

    joHint      : Variant;  //HINT
    joRes       : Variant;  //���ؽ��
    joFields    : Variant;  //�ֶ�����
    joField     : Variant;  //�ֶ�
    joButton    : Variant;  //������ť
    joSummary   : Variant;  //��������
    joSum       : variant;  //���������
const
    _ICONS  : array[1..3] of string = ('el-icon-plus','el-icon-minus','el-icon-edit');
    _TEXTS  : array[1..3] of string = ('����','ɾ��','�༭');
    
begin
    //Ĭ�Ϸ���ֵ
    joRes := _Json('[]');
    //Ԥ����ȡ�����ò���
    //ȡ��HINT����joHint,��Ԥ����
    //ȡ��HINT����joHint
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    sFull       := dwFullName(Actrl);
    //ȡ����Ĭ��ֵ
    iTopH       := dwGetInt(joHint,'topheight',40);
    iRowH       := dwGetInt(joHint,'rowheight',40);
    iPageH      := dwGetInt(joHint,'pageheight',40);
    iPageSize   := dwGetInt(joHint,'pagesize',10);
    //
    sTopBack    := dwGetStr(joHint,'topbackground','transparent');
    sHover      := dwGetStr(joHint,'hover','rgb(245,247,250)');
    sRecord     := dwGetStr(joHint,'record','rgb(224,243,255)');
    //�������ҳ�������÷�ҳ�߶�Ϊ0
    if (not _GetModule(joHint,5)) OR ( iPageSize = 9999 ) then begin
        iPageH := 0;
    end;
    //ȡ�ø�����ֵ
    iTitleCount := _GetTitleCount(joHint);
    iSumCount   := _GetSumCount(joHint);
    joFields    := _GetFields(TListView(ACtrl));
    //����ģ�� =====================
    with TListView(ACtrl) do begin
        //����� dg ���ײ���
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    //+'border: 1px solid #dcdfe6;'
                    +dwGetDWStyle(joHint)
                    //����
                    +'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'font-family:'+Font.Name+';'
                    +'font-weight:'+_GetFontWeight(Font)+';'
                    +'font-style:'+_GetFontStyle(Font)+';'
                    +'text-decoration:'+_GetTextDecoration(Font)+';'
                    +'background-color:'+dwColor(Color)+';'
                    //+'overflow:hidden;'
                +'"' //style ���
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'>';
        joRes.Add(sCode);
        //������ dg__top ����ɾ�Ĳ顣������
        if _GetModule(joHint,0) then begin
            //�ײ�
            sCode   := '<div'
                    +' id="'+sFull+'__top"'
                    +' :style="{'
                        +'background:'+sFull+'__tpb,'
                        +'height:'+sFull+'__tph'
                    +'}"'
                    +' style="position:absolute;'
                        +'left:0px;'
                        +'top:0px;'
                        +'width:100%;'
                        +joHint.topstyle
                    +'"'
                    +'>';
            joRes.Add(sCode);
            //��ѯ��
            if _GetModule(joHint,4) then begin
                sCode   := concat(
                        '<el-input',
                            ' v-model="'+sFull+'__key"',     //keyword
                            ' suffix-icon="el-icon-search"',
                            ' placeholder="search"',
                            ' style="',
                                'position:absolute;',
                                'top:17%;',
                                'bottom:17%;',
                                'height:66%;',
                                'left:3px;',
                                'width:200px;',
                                //'border: solid 1px #ececec;',
                                'border-radius: 3px;',
                                'background:rgb(242,242,242);',
                            '"',
                            ' @input="'+sFull+'__query($event,'+sFull+'__key)"',
                        '></el-input>');
                joRes.Add(sCode);
            end;
            //��ɾ�ģ���ť��
            for iBtn :=3 downto 1 do begin
                if _GetModule(joHint,iBtn) then begin
                    sCode   := concat(
                            '<el-button',
                                ' id="'+sFull+'__bt'+IntToStr(iBtn)+'"',
                                ' icon="'+_ICONS[iBtn]+'"',
                                ' type="primary"',
                                ' style="',
                                    'position:relative;',
                                    'float: right;',
                                    'top: calc(50% - 15px);',
                                    'height:28px;',
                                    'border-radius: 3px;',
                                    'margin-right:3px;',
                                    'width:70px;',
                                '"',
                                ' @click="'+sFull+'__buttonclick($event,'+IntToStr(iBtn)+')"',
                            '>',
                            _TEXTS[iBtn],
                            '</el-button>');
                    joRes.Add(sCode);
                end;
            end;
            //β��
            joRes.Add('</div>');
        end;
        //���ݿ� dg__dat������ͷ�ͻ��ܣ�
        //�ײ� dg__dat
        sCode   := '<div'
                +' id="'+sFull+'__dat"'
                +' :style="{'
                    +'top:'+sFull+'__dtt,'
                    +'height:'+sFull+'__dth'
                +'}"'
                +' style="position:absolute;'
        			+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ebeef5;','border-top:solid 1px #ebeef5;border-bottom:solid 1px #ebeef5;')
                    //+'border: 1px solid #dcdfe6;'
                    +'overflow:hidden;'
                    +'left:0px;'
                    +'width: calc(100% - 2px);'
                    +joHint.datastyle
                +'"'
                +'>';
        joRes.Add(sCode);
        //��ͷ dg__tit
        sCode   := _GetTitleHtml(TListView(ACtrl),joHint,joFields);
        joRes.Add(sCode);
        //���� dg__dav : data view
        joRes.Add('<div'
                +' id="'+sFull+'__dav"' //dav: data view
                +' class="dwscroll_bottom"'
                //+' v-show="'+sFull+'__dvv"'     //dvv: data view visible
                +' :style="{'
                   +'top:'+sFull+'__dvt,'       //aph : Append Height
                   +'height:'+sFull+'__dvh'       //aph : Append Height
                +'}"'
                +' style="'
                       +'position:absolute;'
                       +'overflow:auto;'
                       //+'background-color:#fcf;'
                       //+'z-index:9;'
                       +'left:0;'
                       +'top:0;'
                       +'width: calc(100% - 0px);'
                       //+'height:200px;'
                +'"' //style ���
                +' @scroll="'+sFull+'__scroll($event)" '
                +' @mouseover=''function(e){'
                    +'var iRecNo=parseInt((Math.abs(e.offsetY)+e.target.offsetTop)/'+IntToStr(iRowH)+');'//ת��Ϊ��¼No,��0��ʼ
                    +'if (iRecNo<'+IntToStr(iPageSize)+'){'                           //���ⳬ��¼
                         //+'this.console.log(iRecNo);'
                         //+'this.console.log(e);'
                         +sFull+'__hov=parseInt(iRecNo*'+IntToStr(iRowH)+')+"px";'   //���¼�¼ָʾ��λ��
                    +'}else{'
                        +sFull+'__hov="-500px";'   //���¼�¼ָʾ��λ��
                    +'};'      
                +'}'''
                +' @mouseleave=''function(e){'
                    //+'this.console.log(e);'
                    +sFull+'__hov="-500px";'   //���¼�¼ָʾ��λ��
                +'}'''
                +' @click=''function(e){'
                    //+'this.alert("pause");'
                    //+'this.console.log(e);'
                    +'var iRecNo=parseInt((e.offsetY+e.target.offsetTop)/'+IntToStr(iRowH)+');'//ת��Ϊ��¼No,��0��ʼ
                    //+'this.console.log(iRecNo);'
                    //+'this.console.log('+sFull+'__rcc);'
                    +'if (iRecNo<'+IntToStr(iPageSize)+'){'                           //���ⳬ��¼
                         +sFull+'__rnt=parseInt(iRecNo*'+IntToStr(iRowH)+')+"px";'   //���¼�¼ָʾ��λ��
                         +'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                    +'};'      
                +'}'''
                + ' @dblclick='''
                   //+'this.console.log(''dblclick'');'
                   +'dwevent("","'+sFull+'","0","ondblclick",'+IntToStr(TForm(Owner).Handle)+');'
               +''''
                +'>');
        //Hove�� dg__hov
        joRes.Add('        <div'
               + ' id="'+sFull+'__hov"'
               + ' :style="{'
                   +'width:'+sFull+'__how,'
                   +'top:'+sFull+'__hov'
               +'}"'
               + ' style="'
                   +'position:absolute;'
                   +'background:'+sHover+';'
                   //+'z-index:-2;'
                   +'left:0;'
                   //+'width:100%;'
                   +'height:'+IntToStr(iRowH)+'px;'
               +'"' //style ���
               + '></div>');
        //��¼�� dg__row
        joRes.Add('        <div'
                + ' id="'+sFull+'__row"'
                + ' :style="{'
                    +'width:'+sFull+'__how,'
                    +'top:'+sFull+'__rnt'
                +'}"'
                + ' style="'
                    +'position:absolute;'
                    +'background:'+sRecord+';'
                    //+'z-index:-1;'
                    +'left:0;'
                    //+'width:100%;'
                    +'height:'+IntToStr(iRowH)+'px;'
                +'"' //style ���
                + '></div>');
        //��Ӹ��ֶ�����
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            //����type�ֱ���
            if joField.type = 'check' then begin
                //Check�ֶ�
                sCode   := '<el-checkbox class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+sFull+'__cd'+IntToStr(iCol)+'"'  //cd:ColumnData
                		+' :row="item.r"'
                		+' :key="index"'
                		+' v-model="item.c"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                		+' style="position:absolute;"'
                		+' @change=''function(val){'
                		     +'dwevent("","'+sFull+'",Number(item.r)*100+Number(val),"onsinglecheck",'+IntToStr(TForm(Owner).Handle)+');'
                		+'}'''
                		+'></el-checkbox>';
            //image�ֶ�
            end else if joField.type = 'image' then begin
                sCode   := '<div class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                		+' :row="item.r"'
                		//+' :key="index"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                		+' style="position:absolute;text-align:center;'
                		+'"'
                		//+' @mouseenter=''DBGrid1__hov=item.t'''
                		//+' @mouseleave=''DBGrid1__hov="-500px"'''
                		//+' @click=''DBGrid1__rnt=item.t;'
                		//        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                		+' >';
                		//���image
                		sCode   := sCode + '<img :src="item.c" style="vertical-align:middle;' + dwGetDWStyle(joField)+ '"></img>';
                		//
                		sCode   := sCode+'</div>';
            //progress�ֶ�
            end else if joField.type = 'progress' then begin
                sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                		+' :row="item.r"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                		+' style="position:absolute;text-align:center;'
                		+'"'
                		+' >';
                //���
                sCode   := sCode + '<el-progress'
                		+' :text-inside="true"'
                		+' color="#ccc"'    //�˴�Ϊ��������ǰ��ɫ����Ҫ���޸�����
                		+' style="'
                			+'top:8px;'
                            +'height: calc(100% - 10px);'
                		+'"'
                		+' :stroke-width="'+IntToStr(dwGetInt(joHint,'rowheight',40)-16)+'"'
                		//+' :percentage="item.c"'
                		+' :percentage="item.c > 100 ? 100 : item.c"'
                		+' :format="'+sFull+'__format(item.c)"'
                		+'>'
                		+'</el-progress>';
                //
                sCode   := sCode+'</div>';
            //button�ֶ�
            end else if joField.type = 'button' then begin
                sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                		+' :row="item.r"'
                		//+' :key="index"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                		+' style="position:absolute;text-align:center;'
                		+'"'
                		+' >';
                if joField.Exists('list') then begin
                    for iItem := 0 to joField.list._Count -1 do begin
                        joButton    := joField.list._(iItem);
                        sCode   := sCode + '<el-button'
                        		+' type="'+joButton._(1)+'"'
                        		+' style="vertical-align:middle;margin:2px;"'
                        		+' @click=''function(e){'
                        				+'dwevent("","'+sFull+'",item.r*10000+'+IntToStr(iCol*100+iItem)+',"onbuttonclick",'+IntToStr(TForm(Owner).Handle)+');'
                        				+'e.stopPropagation();'//��ֹð��
                        		+'}'''
                        		+'>'+joButton._(0)+'</el-button>';
                    end;
                end;
                sCode   := sCode+'</div>';
            end else begin
                //��ͨ�ֶ�
                sCode   := '<div'
                		+' class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                		+' :row="item.r"'
                		+' tabIndex=0'
                		//+' :key="index"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align,color:item.color,''background-color'':item.bkcolor}"'
                		+' style="position:absolute;"'
                		//+' @mouseenter=''DBGrid1__hov=item.t'''
                		//+' @mouseleave=''DBGrid1__hov="-500px"'''
                		//+' @click=''DBGrid1__rnt=item.t;'
                		//        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                		+' >{{item.c}}</div>';
            end;
            joRes.Add(sCode);
        end;
        //�����ݿ�β�� dg_dav
        joRes.Add('</div>');
        //���� dg__sum
        if joHint.summary._count>0 then begin
            //�ײ� <div>
            joRes.Add('<div'
                    +' id="'+sFull+'__sum"'
                    +' :style="{'
                        +'width: '+sFull+'__fuw,'  
                        +'left:'+sFull+'__ttl,'       
                        +'height:'+sFull+'__smh'       //smh : summary Height
                    +'}"'
                    +' style="'
                        +'position:absolute;'
                        +'overflow:hidden;'
                        //+'border: 1px solid #dcdfe6;'
                        +'background: linear-gradient(#f4f5f8,#f1f3f6);'
                        +'left:0;'
                        +'bottom:0;'
                    +'"' //style ���
                    +'>');
            joSummary     := joHint.summary;
            //���� ��ʾ�����ܡ�����
            joRes.Add('        <div'
                    + ' style="'
                            +'position:absolute;'
                            +'overflow:hidden;'
                            +'left:10px;'
                            +'top:0;'
                            +'width:200px;'
                            +'font-size:'+IntToStr(Font.Size+3)+'px;color:'+dwColor(Font.Color)+';'
                            +'height:'+IntToStr(iSumCount*iRowH)+'px;'
                            +'line-height:'+IntToStr(iSumCount*iRowH)+'px;'
                    +'"' //style ���
                    + '>'
                    +joSummary._(0)
                    +'</div>');
            //���� iItem := 1 to joSummary._Count -1
            for iItem := 1 to joSummary._Count -1 do begin
                joSum   := joSummary._(iItem);
                iSumCol := joSum._(0);
                //iSumCol ������Χ��������
                if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                    continue;
                end;
                iL  := joFields._(iSumCol).left;
                //���㵱ǰ��Top
                iT  := -2;
                for iCol := 1 to iItem -1 do begin
                    if joSummary._(iCol)._(0) = iSumCol then begin
                        iT  := iT + iRowH;
                    end;
                end;
                iW  := joFields._(iSumCol).width-1;
                iH  := iRowH-1;
                //��ʾ�����ܡ���ֵ
                joRes.Add('        <div'
                        +' :style="{'
                            +'left:'+sFull+'__fl'+IntToStr(iSumCol)+','   //sum left
                            //+'top:'+sFull+'__st'+IntToStr(iItem)+','    //sum top
                            +'width:'+sFull+'__fw'+IntToStr(iSumCol)      //sum width
                        +'}"'
                        + ' style="'
                                +'position:absolute;'
                                +'overflow:hidden;'
                                //+'left:'+IntToStr(iL)+'px;'
                                +'top:'+IntToStr(iT)+'px;'
                                //+'width:'+IntToStr(iW)+'px;'
                                +'height:'+IntToStr(iH)+'px;'
                                +'line-height:'+IntToStr(iH)+'px;'
                                +'border:solid 1px #ececec;'
                                +'text-align:center;'
                                +'font-size:'+IntToStr(Font.Size+3)+'px;color:'+dwColor(Font.Color)+';'
                        +'"' //style ���
                        + '>'
                        +'{{'+sFull+'__sm'+IntToStr(iItem-1)+'}}'
                        +'</div>');
                //Ϊ��ǰ����ʾһ��ͨ��صĿ�������
                joRes.Add('        <div'
                        +' :style="{'
                            +'left:'+sFull+'__fl'+IntToStr(iSumCol)+','   //sum left
                            +'width:'+sFull+'__fw'+IntToStr(iSumCol)      //sum width
                        +'}"'
                        + ' style="'
                                +'position:absolute;'
                                //+'left:'+IntToStr(iL)+'px;'
                                +'top:-2px;'
                                //+'width:'+IntToStr(iW)+'px;'
                                +'height:100%;'
                                +'border:solid 1px #ececec;'
                        +'"' //style ���
                        + '>'
                        +'</div>');
            end;
            //β�� </div>
            joRes.Add('</div>');
        end;
        //β�� dg__dat
        joRes.Add('</div>');
        //��ҳ�� dg__pag
        if _GetModule(joHint,5) and (iPageSize<>9999) then begin
            //�ײ�
            sCode   := concat(
                    '<el-pagination',
                    ' background',
                    ' :pager-count="5"',
                    ' :page-size="'+IntToStr(iPageSize)+'"',
                    ' layout="prev, pager, next, jumper, ->, total"',
                    ' :total="'+sFull+'__drc"',
                    ' style="',
                         'position:absolute;',
                         //'height:'+IntToStr(iRowH)+'px;',
                         //'bottom:'+IntToStr(30-iRowH)+'px;',
                         'height:30px;',
                         'width:100%;',
                         'bottom:0px;',
                         'color:'+dwColor(Font.Color)+';',
                    '"',
                    '@current-change="'+sFull+'__pagechange"',
                    '>');
            joRes.Add(sCode);
            //β��
            joRes.Add('</el-pagination>');
        end;
        //ɾ���� dg__cfm : confirm form mask ɾ��ȷ�Ͽ�
        //���ֲ� dg__cfm �ײ� confirm mask
        sCode   := Concat('<div id="'+sFull+'__cfm"',   //cfm:confirm mask
        		' v-show="'+sFull+'__cfv"',         //confirm visible
        		' style="',
        			'position:fixed;',
        			'left:0;',
        			'top:0;',
        			'right:0;',
        			'bottom:0;',
        			'background: rgba(0,0,0,0.5);',
        			'z-index:9;',
        		'"',
        		'>');
        joRes.Add(sCode);
        //����� dg__cff �ײ� confirm form
        sCode   := Concat('<div id="'+sFull+'__cff"',   //cff:confirm form
        		' style="',
        			'position:absolute;',
        			'left: calc(50% - 160px);',
        			'top:200px;',
        			'width:320px;',
        			'height:130px;',
        			'border-radius:15px;',
        			'background-color:#fff;',
        			'opacity: 1;',
        		'"',
        		'>');
        joRes.Add(sCode);
        //����� dg__cft ȫ�� confirm title
        sCode   := Concat('<div id="'+sFull+'__cft"',   
        		' style="',
        			'position:absolute;',
        			'top:0px;',
        			'width:100%;',
        			'height:80px;',
        			'line-height:80px;',
        			'text-align:center;',
        			'border-bottom:solid 1px #ccc;',
        		'"',
        		'>',
        		'ȷ��ɾ����',
        		'</div>');
        joRes.Add(sCode);
        //ȡ��ť dg__cfc ȫ�� confirm cancel
        sCode   := Concat('<div id="'+sFull+'__cfc"',   //confirm cancel
        		' style="',
        			'position:absolute;',
        			'left:0px;',
        			'bottom:0px;',
        			'width:50%;',
        			'height:50px;',
        			'line-height:50px;',
        			'text-align:center;',
        			'border-right:solid 1px #ccc;',
        		'"',
        		' @click="function(event){',
        			''+sFull+'__cfv=false;',
        		'}" ',
        		'>',
        		'ȡ��',
        		'</div>');
        joRes.Add(sCode);
        //ɾ��ť dg__cfd ȫ�� confirm delete
        sCode   := Concat('<div id="'+sFull+'__cfd"',   //confirm delete
        		' style="',
        			'position:absolute;',
        			'right:0;',
        			'bottom:0px;',
        			'width:50%;',
        			'height:50px;',
        			'line-height:50px;',
        			'text-align:center;',
        			'color:red;',
        		'"',
                ' @click="'+sFull+'__deleteconfirm($event)"',
        		'>',
        		'ɾ��',
        		'</div>');
        joRes.Add(sCode);
        //����� dg__cff β��
        joRes.Add('</div>');
        //���ֲ� dg__cfm β��
        joRes.Add('</div>');
        //�༭�� dg__edm
        //���ֲ� dg__edm �ײ� edit mask
        sCode   := Concat('<div id="'+sFull+'__edm"',   //edit/append mask
        		' v-show="'+sFull+'__edv"',         //confirm visible
        		' style="',
        			'position:fixed;',
        			'left:0;',
        			'top:0;',
        			'right:0;',
        			'bottom:0;',
        			'background: rgba(0,0,0,0.5);',
        			'z-index:9;',
        		'"',
        		'>');
        joRes.Add(sCode);
        //����� dg__edf �ײ� edit form
        sCode   := Concat('<div id="'+sFull+'__edf"',   //cff:confirm form
                //��ֵ̬
                ' :style="{',
                    'height:'+sFull+'__efh',       //edit form height
                '}"',
        		' style="',
        			'position:absolute;',
        			'left: calc(50% - 160px);',
        			'top:25px;',
        			'width:320px;',
        			'max-height:calc(100% - 50px);',
        			'border-radius:15px;',
        			'background-color:#fff;',
        			'opacity: 1;',
        		'"',
        		'>');
        joRes.Add(sCode);
        //������ dg__edt ȫ�� edit title
        sCode   := Concat('<div id="'+sFull+'__edt"',   //edit/append title
                ' style="',
                    'position:absolute;',
                    'top:0px;',
                    'width:100%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-bottom:solid 1px #ccc;',
                '"',
                '>',
                'Data',
                '</div>');
        joRes.Add(sCode);
        //������ �ײ�
        sCode   := concat('<el-scrollbar',
                ' ref="'+sFull+'__dts"',    //data scroll
                //��ֵ̬
                //' :style="{',
                //    'height:'+sFull+'__dsh',       //data scroll height
                //'}"',
                ' style="',
                    'position:absolute;',
                    'top:50px;',
                    'width:100%;',
                    'bottom:50px;',
                    'height: calc(100% - 100px);',
                '"',
                '>');
        joRes.Add(sCode);
        //���ݿ� �ײ�
        sCode   := concat('<el-main',
                ' id="'+sFull+'__dtc"',     //data content
                //��ֵ̬
                ' :style="{',
                    'height:'+sFull+'__dch',       //data content height
                '}"',
                //��ֵ̬
                ' style="',
                    'position:relative;',
                    'color:'+dwColor(Font.Color)+';',
                    'left:0;',
                    'top:0;',
                    'width:100%;', 
                    'overflow:hidden;',
                '"',
                '>');
        joRes.Add(sCode);
        //�༭�� ���
        iTop    := 25;
        //��Ӹ��ֶ�����
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            if joField.fieldname = '' then begin
                continue;
            end;
            if joField.type = 'autoinc' then begin
                continue;
            end;
            if joField.readonly = 1 then begin
                continue;
            end;
            //�ֶ� caption
            sCaption    := joField.caption;
            sCaption    := StringReplace(sCaption,'<br>','',[rfReplaceAll]); 
            sCaption    := StringReplace(sCaption,'<br/>','',[rfReplaceAll]); 
            sCode   := Concat('<div',
                    ' style="',
                        'position:absolute;',
                        'top:'+IntToStr(iTop)+'px;',
                        'left:25px;',
                        'right:25px;',
                        'height:20px;',
                        'line-height:20px;',
                        'background:transparent;',
                        'padding-left:5px;',
                    '"',
                    '>',
                    sCaption,
                    '</div>');
            joRes.Add(sCode);
            //����type�ֱ��� �ֶα༭��
            if joField.type = 'boolean' then begin
                //boolean �ֶ�
                //��� �ײ����ޱ߿򣬽����ڽ綨��Χ��
                sCode   := Concat('<div',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:27px;',
                            'width: calc(100% - 50px);',
                            'padding:0 0 0 5px;',
                            'margin-top:5px;',
                        '"',
                        '>');
                joRes.Add(sCode);
                //ѡ�� list
                sCode   := concat('<el-radio',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' label="True">',
                        joField.list._(0),
                        '</el-radio>');
                joRes.Add(sCode);
                
                sCode   := concat('<el-radio',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' label="False">',
                        joField.list._(1),
                        '</el-radio>');
                joRes.Add(sCode);
                //��� β��
                joRes.Add('</div>');
            //combo   �ֶ�
            end else if joField.type = 'combo' then begin
                //��� �ײ����ޱ߿򣬽����ڽ綨��Χ��
                sCode   := Concat('<div',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:27px;',
                            'width: calc(100% - 50px);',
                            'padding:0 0 0 5px;',
                            'margin-top:5px;',
                        '"',
                        '>');
                joRes.Add(sCode);
                //ѡ�� ���select
                sCode   := concat('<select',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' style="',
                            'appearance:none;',
                            '-moz-appearance:none;',
                            '-webkit-appearance:none;',
                            'background:url(''media/images/dwarrow.png'') no-repeat scroll right center transparent;',
                            'padding:0 14px 0 5px;',
                            'position:absolute;',
                            'top:0px;',
                            'left:0px;',
                            'height:100%;',
                            'width:100%;',
                            'outline:none;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                        '"',
                        //' @change="'+sFull+'__change'+IntToStr(iCol)+'($event)"',
                        '>');
                joRes.Add(sCode);
                for iList := 0 to joField.list._count-1 do begin
                    sCode   := '<option value="'+joField.list._(iList)+'">'+joField.list._(iList)+'</option>';
                    joRes.Add(sCode);
                end;
                joRes.Add('</select>');
                //���input
                sCode   := concat('<input',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        //' type="text"',
                        //' name="format"',
                        //' value=""',
                        ' style="',
                            'position:absolute;',
                            'top:1px;',
                            'color:inherit;',
                            'left:6px;',
                            'right:20px;',
                            'bottom:1px;',
                            'border:0;',
                            'outline:none;',
                        '"',
                        ' />');
                joRes.Add(sCode);
                //��� β��
                joRes.Add('</div>');
            //date    �ֶ�
            end else if joField.type = 'date' then begin
                sCode   := Concat('<el-date-picker',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' value-format="yyyy-MM-dd"',
                        ' type="date"',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'width: calc(100% - 50px);',
                            'height:32px;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                            'padding:0 0 0 5px;',
                        '"',
                        '>');
                joRes.Add(sCode);
                
                
                //β�����
                joRes.Add('</el-date-picker>');
            //integer �ֶ�
            end else if joField.type = 'integer' then begin
                sCode   := Concat('<el-input-number',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' type="date"',
                        dwIIF(joField.Exists('minvalue'),' :min="'+sFull+'__min'+IntToStr(iCol)+'"',''),
                        dwIIF(joField.Exists('maxvalue'),' :max="'+sFull+'__max'+IntToStr(iCol)+'"',''),
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:34px;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                            'width: calc(100% - 50px);',
                            'padding:0 0 0 5px;',
                        '"',
                        '>');
                joRes.Add(sCode);
                
                
                //β�����
                joRes.Add('</el-input-number>');
            end else begin
                //��ͨ    �ֶ�
                sCode   := Concat('<input',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'width: calc(100% - 50px);',
                            'right:25px;',
                            'height:32px;',
                            'line-height:32px;',
                            'border-radius:4px;',
                            'outline-style: none;',
                            'border: 1px solid #ccc;',
                            'color:#808080;',
                            'padding:0px 0px 0px 5px;',
                        '"',
                        '>',
                        '</input>');
                joRes.Add(sCode);
            end;
            iTop    := iTop + 70;
        end;
        //���ݿ� β��
        joRes.Add('</el-main>');
        //������ β��
        joRes.Add('</el-scrollbar>');
        //��ť�� ȡ��/����
        //�༭����ġ�ȡ������ť
        sCode   := Concat('<div id="'+sFull+'__edc"',   //edit/append cancel
                ' style="',
                    'position:absolute;',
                    'left:0px;',
                    'bottom:0px;',
                    'width:50%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-right:solid 1px #ccc;',
                    'border-top:solid 1px #ccc;',
                '"',
                ' @click="'+sFull+'__editcancel($event)"',
                '>',
                'ȡ��',
                '</div>');
        joRes.Add(sCode);
        
        //�༭����ġ����桰��ť
        sCode   := Concat('<div id="'+sFull+'__eds"',   //edit/append save
                ' style="',
                    'position:absolute;',
                    'right:0;',
                    'bottom:0px;',
                    'width:50%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-top:solid 1px #ccc;',
                    'color:red;',
                '"',
                ' @click="'+sFull+'__editsave($event)"',
                '>',
                '����',
                '</div>');
        joRes.Add(sCode);
        //����� dg__edf β��
        joRes.Add('</div>');
        //���ֲ� dg__edm β��
        joRes.Add('</div>');
        //����� dg ��β����
        joRes.Add('</div>');
    end;
    Result := joRes;
end;

//function dwGetTail(ACtrl: TComponent): string; stdcall;
function dwGetTail(ACtrl: TComponent): string; stdcall;
var
    joRes: Variant;
begin
    joRes := _Json('[]');
    
    Result := (joRes);
end;

//function _dwGeneral(ACtrl:TComponent;AMode:String):Variant;
function _dwGeneral(ACtrl:TComponent;AMode:String):Variant;
var
    iRow, iCol  : Integer;
    iItem       : Integer;
    iSum        : Integer;
    iSumW       : Integer;      //�����ֶεĿ��֮�ͣ����ڸ��µ�1/2�ֶ�viewwidth                           
    iSumCol     : Integer;
    iSumCount   : Integer;      //
    iTitleCount : Integer;
    iCount      : Integer;
    iTotal      : Integer;
    iMax        : Integer;
    iRecCount   : Integer;
    iHeadH      : Integer;
    iRowH       : Integer;
    iL,iT,iW,iH : Integer;
    iLevel      : Integer;
    iStart      : Integer;
    iEnd        : Integer;
    iTopH       : Integer;
    iPageH      : Integer;
    iDch        : Integer;
    //
    sCode       : string;
    sCols       : string;
    sHover      : string;
    sRecord     : string;
    sFull       : string;
    sMiddle     : string;
    sTail       : string;
    sTopBack    : string;
    //����SQL
    sField      : string;
    sOldSQL     : string;
    sTable      : string;
    sWhere      : String;
    sGroup      : string;
    sOrder      : string;
    sSQL        : string; //SQL
    iPageSize   : Integer;
    //
    fValues     : array of Double;
    //
    joHint      : Variant;
    joRes       : Variant;
    joFields    : Variant;
    joField     : Variant;
    joColDatas  : array of Variant;
    joValue     : Variant;
    joSummary   : variant;
    joSum       : variant;
    joSItem     : variant;
    joItem      : variant;
    joItems     : variant;
    joMerge     : Variant;
    //
    oDataSet    : TDataSet;
    oBookMark   : TBookMark;
    oAfter      : Procedure(DataSet: TDataSet) of Object;
    oBefore     : Procedure(DataSet: TDataSet) of Object;
begin
    //Ĭ�Ϸ���ֵ
    joRes := _Json('[]');
    
    //Ԥ����ȡ�����ò���
    //ȡ��HINT����joHint,��Ԥ����
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    //ȡ����Ĭ��ֵ
    iTopH       := dwGetInt(joHint,'topheight',50);
    iPageH      := dwGetInt(joHint,'pageheight',40);
    iHeadH      := dwGetInt(joHint,'headerheight',40);
    iRowH       := dwGetInt(joHint,'rowheight',40);
    iPageSize   := dwGetInt(joHint,'pagesize',10);
    sTopBack    := dwGetStr(joHint,'topbackground','transparent');
    //�Ƿ���ʾ��ҳ��
    if not _GetModule(joHint,5) then begin
        iPageH  := 0;
    end;
    //ȡ�ø�����ֵ
    iTitleCount := _GetTitleCount(joHint);
    iSumCount   := _GetSumCount(joHint);
    joFields    := _GetFields(TListView(ACtrl));
    joSummary   := joHint.summary;
    //�����Ƿ�GetData����ȷ��ʹ�� ;/,
    if LowerCase(AMode) = 'data' then begin
        sFull   := dwFullName(Actrl);
        sMiddle := ':';
        sTail   := ',';
    end else begin
        sFull   := 'this.'+dwFullName(Actrl);
        sMiddle := '=';
        sTail   := ';';
    end;
    //with TListView(ACtrl) ======================
    with TListView(ACtrl) do begin
        //����LTWH/VD/recordcount
        joRes.Add(sFull + '__lef'+sMiddle+'"' + IntToStr(Left) + 'px"'+sTail);
        joRes.Add(sFull + '__top'+sMiddle+'"' + IntToStr(Top) + 'px"'+sTail);
        joRes.Add(sFull + '__wid'+sMiddle+'"' + IntToStr(Width-2) + 'px"'+sTail); //-2����Ϊborder������
        joRes.Add(sFull + '__hei'+sMiddle+'"' + IntToStr(Height-2) + 'px"'+sTail);
        
        //visible/enabled
        joRes.Add(sFull + '__vis'+sMiddle+'' + dwIIF(Visible, 'true', 'false')+sTail);
        joRes.Add(sFull + '__dis'+sMiddle+'' + dwIIF(Enabled, 'false', 'true')+sTail);
        
        //���� dg__top
        joRes.Add(sFull + '__tph'+sMiddle+'"' + IntToStr(iTopH) + 'px"'+sTail);
        joRes.Add(sFull + '__tpb'+sMiddle+'"' + sTopBack + '"'+sTail);
        //���� dg__dat
        joRes.Add(sFull + '__dtt'+sMiddle+'"' + IntToStr(iTopH) + 'px"'+sTail);
        joRes.Add(sFull + '__dth'+sMiddle+'"' + IntToStr(Height - iTopH - iPageH) + 'px"'+sTail);
        //���� dg__dav : __dvt/__dvh
        joRes.Add(sFull + '__dvt'+sMiddle+'"' + IntToStr(iTitleCount *iHeadH ) + 'px"'+sTail);
        joRes.Add(sFull + '__dvh'+sMiddle+'"' + IntToStr(Height - iTopH - iTitleCount *iHeadH - iSumCount * iHeadH - iPageH) + 'px"'+sTail);
        //���� dg__sum : __smh
        joRes.Add(sFull + '__smh'+sMiddle+'"' + IntToStr(iSumCount *iHeadH-1) + 'px"'+sTail);
        //ȡ�����ݼ������� oDataSet
        oDataSet    := nil;
        if ( joHint.dataset<> '' ) then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        //�������ɷ�ҳ����
        iRecCount   := _UpdateQuery(ACtrl);
        joRes.Add(sFull + '__drc'+sMiddle+'' + IntToStr(iRecCount) + ''+sTail);
        if oDataSet <> nil then begin
            //��¼ __rnt
            joRes.Add(sFull + '__rnt'+sMiddle+'"'+IntToStr((oDataSet.RecNo-1)*iRowH)+'px"'+sTail);      //Ĭ��
        end else begin
            //��¼ __rnt
            joRes.Add(sFull + '__rnt'+sMiddle+'"'+IntToStr(0*iRowH)+'px"'+sTail);      //Ĭ��
        end;
        //�����ֶε�viewwidth, ��Ҫ�ǵ�����1/2�ֶ�
        iSumW   := 0;
        //���������ֶ���width֮�� : iSumW
        for iCol := 0 to joFields._Count-1 do begin
            iSumW   := iSumW + joFields._(iCol).width;
        end;
        //���Grid��� > ���п��֮��,����չ��1��2��
        if Width > iSumW then begin
            if joFields._(joFields._Count-1).type = 'button' then begin
                //��չ������2�п��
                joFields._(joFields._Count-2).viewwidth := joFields._(joFields._Count-2).width + Width - iSumW - 1;
            end else begin
                //��չ������1�п��
                joFields._(joFields._Count-1).viewwidth := joFields._(joFields._Count-1).width + Width - iSumW - 1;
            end;
        end;
        //�����ֶε�left, ��Ҫ�ǵ�����1/2�ֶ�viewwidth�����и���
        iSumW   := -1;
        //���¸��ֶ�left
        for iCol := 0 to joFields._Count-1 do begin
            joFields._(iCol).left   := iSumW;
            iSumW   := iSumW + joFields._(iCol).viewwidth;
        end;
        //���ɸ������ֶε��ܿ��iSumW -> dg__fuw ,dg__how
        joRes.Add(sFull + '__fuw'+sMiddle+'"'+IntToStr(iSumW)+'px"'+sTail);
        joRes.Add(sFull + '__how'+sMiddle+'"'+IntToStr(iSumW-8)+'px"'+sTail);
        //���ɸ��е�left/width: __fl/__fw
        for iCol := 0 to joFields._Count-1 do begin
            if iCol < joFields._Count-1 then begin
                joField := joFields._(iCol);
                
                //fl:field left
                joRes.Add(sFull + '__fl'+IntToStr(iCol)+''+sMiddle+'"'+IntToStr(joField.left) + 'px"'+sTail);
                
                //fw:field width
                joRes.Add(sFull + '__fw'+IntToStr(iCol)+''+sMiddle+'"'+IntToStr(joField.viewwidth-1) + 'px"'+sTail);
            end else begin
                joField := joFields._(iCol);
                
                //fl:field left
                joRes.Add(sFull + '__fl'+IntToStr(iCol)+''+sMiddle+'"'+IntToStr(joField.left) + 'px"'+sTail);
                
                //fw:field width
                joRes.Add(sFull + '__fw'+IntToStr(iCol)+''+sMiddle+' "'+IntToStr(iSumW-joField.left) + 'px"'+sTail);
            end;
        end;
        //���ɸ�merge��left/width : __ml/__mw
        for iItem := 0 to joHint.merge._Count-1 do begin
            joMerge := joHint.merge._(iItem);
            iL  := joFields._(joMerge._(1)).left;
            iW  := 0;
            for iCol := joMerge._(1) to joMerge._(2) do begin
                iW  := iW + joFields._(iCol).viewwidth;
            end;
            joRes.Add(sFull + '__ml'+IntToStr(iItem)+''+sMiddle+'"'+IntToStr(iL) + 'px"'+sTail);
            joRes.Add(sFull + '__mw'+IntToStr(iItem)+''+sMiddle+'"'+IntToStr(iW-1) + 'px"'+sTail);
        end;
        if oDataSet <> nil then begin
            //��������
            //���ݷ�ҳ��Ϣ�ȸ���SQL�������´�����
            if _GetModule(joHint,5) and ( iPageSize <> 9999 ) then begin
                //ȡԭSQL�Ĺؼ�Ҫ��
                _GetSQL(ACtrl,sOldSQL);
                if HelpContext = 0 then begin
                    sSQL    := 'SELECT TOP '+IntToStr(iPageSize)+' '+ sField+' FROM '+sTable+' WHERE '+sWhere+' ORDER BY'+sOrder;
                end;
            end;
            //���浱ǰ��¼λ�ã�����ԭ�¼�
            oBookMark := oDataSet.GetBookmark;
            
            oDataSet.DisableControls;
            
            //����ԭ�¼�����
            oAfter  := oDataSet.AfterScroll;
            oBefore := oDataSet.BeforeScroll;
            //����¼�
            oDataSet.AfterScroll    := nil;
            oDataSet.BeforeScroll   := nil;
            SetLength(joColDatas,Integer(joFields._Count));
            //��joColDatas���յĳ�ֵ
            for iCol := 0 to joFields._Count-1 do begin
                joColDatas[iCol]    := _json('[]');
            end;
            if joSummary._count > 1 then begin
                SetLength(fValues,Integer(joSummary._Count)-1);
            end else begin
                SetLength(fValues,0);
            end;
            oDataSet.First;
            iRow := 0;
            while not oDataSet.Eof do begin
                for iCol := 0 to joFields._Count-1 do begin
                    joField := joFields._(iCol);
                    joValue         := _json('{}');
                    joValue.l       := IntToStr(joField.left)+'px';
                    joValue.h       := IntToStr(iRowH)+'px';        //��ʱû��
                    joValue.t       := IntToStr(oDataSet.RecNo * iRowH - iRowH)+'px';
                    joValue.w       := IntToStr(joField.viewwidth-10-1)+'px';  //-10����Ϊpadding:5px
                    joValue.align   := joField.align;
                    joValue.color   := joField.color;
                    joValue.bkcolor := joField.bkcolor;
                    joValue.r       := oDataSet.RecNo;
                    //�������һ�еĿ�ȣ������޹ʳ��ֺ��������
                    if iCol = joFields._Count-1 then begin
                        joValue.w       := IntToStr(joField.viewwidth-10-1-8)+'px';  //-10����Ϊpadding:5px
                    end;
                    //�����ֶ�type�ֱ�õ�joValue.c
                    if joField.type = 'check' then begin
                        //joField.type = 'check'
                        joValue.c   := false;
                    end else if joField.type = 'index' then begin
                        joValue.c   := IntToStr(oDataSet.RecNo);
                    end else if joField.type = 'boolean' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := '';
                        end else begin
                            if joField.Exists('list') then begin
                                if oDataSet.FieldByName(joField.fieldname).AsBoolean then begin
                                    joValue.c   := joField.list._(0);
                                end else begin
                                    joValue.c   := joField.list._(1);
                                end;
                            end else begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end;
                        end;
                    end else if joField.type = 'date' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := FormatDateTime(joField.format,0);
                        end else begin
                            if joField.Exists('format') then begin
                                joValue.c   := FormatDateTime(joField.format,oDataSet.FieldByName(joField.fieldname).AsDateTime);
                            end else begin
                                joValue.c   := FormatDateTime('yyyy-MM-dd',oDataSet.FieldByName(joField.fieldname).AsDateTime);
                            end;
                        end;
                    end else if joField.type = 'image' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := '';
                        end else begin
                            joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsString]);
                        end;
                    end else if joField.type = 'progress' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := 0;
                        end else begin
                            joValue.c   := Round(100*oDataSet.FieldByName(joField.fieldname).AsFloat / joField.total);
                        end;
                    end else if joField.type = 'button' then begin
                        joValue.c   := '';
                    end else if joField.type = 'float' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := 0;
                        end else begin
                            if joField.Exists('format') then begin
                                joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsFloat]);
                            end else begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end;
                        end;
                    end else begin
                        if joField.fieldname = '' then begin
                            joValue.c   := '';
                        end else begin
                            joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                        end;
                    end;
                    joColDatas[iCol].Add(joValue);
                end;
                //�������
                for iSum := 1 to joSummary._Count-1 do begin
                    //�õ������Ӷ���
                    joSItem := joSummary._(iSum);
                    //���������� iSumCol
                    iSumCol := joSItem._(0);
                    //��ֹ�кų���Χ
                    if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                        continue;
                    end;
                    //�õ��������ֶ����� sField
                    sField  := joFields._(iSumCol).fieldname;
                    if (joSItem._(1) = 'avg') or (joSItem._(1) = 'sum') then begin
                        //avg / sum
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := oDataSet.FieldByName(sField).AsFloat;
                        end else begin
                            fValues[iSum-1] := fValues[iSum-1] + oDataSet.FieldByName(sField).AsFloat;
                        end;
                    //min
                    end else if joSItem._(1) = 'min' then begin
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := oDataSet.FieldByName(sField).AsFloat;
                        end else begin
                            fValues[iSum-1] := Min(fValues[iSum-1], oDataSet.FieldByName(sField).AsFloat);
                        end;
                    end else if joSItem._(1) = 'max' then begin
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := oDataSet.FieldByName(sField).AsFloat;
                        end else begin
                            fValues[iSum-1] := Max(fValues[iSum-1], oDataSet.FieldByName(sField).AsFloat);
                        end;
                    end;
                end;
                oDataSet.Next;
                Inc(iRow);
            end;
            for iCol := 0 to joFields._Count-1 do begin
                sCode := sFull + '__cd'+IntToStr(iCol)+sMiddle+VariantSaveJSON(joColDatas[iCol]) + ''+sTail ;
                joRes.Add(sCode);
            end;
            //���¶�λ��¼ָ��ص�ԭ����λ��,�ָ��¼�
            oDataSet.GotoBookmark(oBookMark);
            oDataSet.EnableControls;
            //ɾ����ǩBookMark��־
            oDataSet.FreeBookmark(oBookMark);
            //�ָ�ԭ�¼�����
            oDataSet.AfterScroll    := oAfter;
            oDataSet.BeforeScroll   := oBefore;
            //�������� dg__sm_
            for iSum := 1 to joSummary._Count-1 do begin
                //�õ������Ӷ��� joSItem
                joSItem := joSummary._(iSum);
                //�õ���������� iSumCol
                iSumCol := joSItem._(0);
                //����ƽ��ֵ
                if joSItem._(1) = 'avg' then begin
                    if iRecCount = 0 then begin
                        fValues[iSum-1] := 0;
                    end else begin
                        fValues[iSum-1] := fValues[iSum-1] / iRecCount;
                    end;
                end;
                //���ɸ������ֶε����� dg__sm_
                sCode := sFull + '__sm'+IntToStr(iSum-1)+sMiddle+'"'+Format(joSItem._(2),[fValues[iSum-1]])+'"'+sTail;
                joRes.Add(sCode);
            end;
        end else begin
            //������DataSet״̬�µ�����
            SetLength(joColDatas,Integer(joFields._Count));
            //��joColDatas���յĳ�ֵ
            for iCol := 0 to joFields._Count-1 do begin
                joColDatas[iCol]    := _json('[]');
            end;
            if joSummary._count > 1 then begin
                SetLength(fValues,Integer(joSummary._Count)-1);
            end else begin
                SetLength(fValues,0);
            end;
            for iCol := 0 to joFields._Count-1 do begin
                sCode := sFull + '__cd'+IntToStr(iCol)+sMiddle+VariantSaveJSON(joColDatas[iCol]) + ''+sTail ;
                joRes.Add(sCode);
            end;
            //�������� dg__sm_
            for iSum := 1 to joSummary._Count-1 do begin
                //�õ������Ӷ��� joSItem
                joSItem := joSummary._(iSum);
                //�õ���������� iSumCol
                iSumCol := joSItem._(0);
                //���ɸ������ֶε����� dg__sm_
                sCode := sFull + '__sm'+IntToStr(iSum-1)+sMiddle+'"'+Format(joSItem._(2),[fValues[iSum-1]])+'"'+sTail;
                joRes.Add(sCode);
            end;
        end;
    end;
    //dg__dch/dg__di_ �༭ʱ�༭���ĸ߶�/�༭ֵ
    idch    := 25;
    for iCol := 0 to joFields._Count -1 do begin
        joField := joFields._(iCol);
        if joField.fieldname = '' then begin
            continue;
        end;
        if joField.type = 'autoinc' then begin
            continue;
        end else if joField.type = 'integer' then begin
            if joField.Exists('minvalue') then begin
                joRes.Add(sFull + '__min'+IntToStr(iCol) + sMiddle + IntToStr(joField.minvalue) + sTail);
            end;
            if joField.Exists('maxvalue') then begin
                joRes.Add(sFull + '__max'+IntToStr(iCol) + sMiddle + IntToStr(joField.maxvalue) + sTail);
            end;
        end;
        if oDataSet <> nil then begin
            if joField.type = 'integer' then begin
                //integer
                sCode   := sFull+'__di'+IntToStr(iCol)+sMiddle+IntToStr(oDataSet.FieldByName(joField.fieldname).AsInteger)+sTail;
            end else begin
                sCode   := oDataSet.FieldByName(joField.fieldname).AsString;
                sCode   := sFull+'__di'+IntToStr(iCol)+sMiddle+'"'+sCode+'"'+sTail;
            end;
        end else begin
            if joField.type = 'integer' then begin
                //integer
                sCode   := sFull+'__di'+IntToStr(iCol)+sMiddle+IntToStr(0)+sTail;
            end else begin
                sCode   := sFull+'__di'+IntToStr(iCol)+sMiddle+'""'+sTail;
            end;
        end;
        joRes.Add(sCode);
        idch    := idch + 70;
    end;
    joRes.Add(sFull+'__dch'+sMiddle+'"'+IntToStr(idch)+'px"'+sTail); //data content height
    joRes.Add(sFull+'__efh'+sMiddle+'"'+IntToStr(idch+120)+'px"'+sTail);
    Result := joRes;
end;

//function dwGetData(ACtrl: TControl): string; stdcall;
function dwGetData(ACtrl: TControl): string; stdcall;
var 
    //
    joRes     : Variant;
    joHint    : variant;
    joFields  : Variant;
    joField   : Variant;
    //
    iCol      : Integer;
    //
    sFull     : string;
    sMiddle   : string;
    sTail     : string;
begin
    //Ԥ����ȡ�����ò���
    //ȡ��HINT����joHint,��Ԥ����
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    sFull       := dwFullName(Actrl);
    //ȡ����Ĭ��ֵ,joFields
    joFields    := _GetFields(TListView(ACtrl));
    joRes   := _dwGeneral(ACtrl,'data');
    sFull   := dwFullName(Actrl);
    sMiddle := ':';
    sTail   := ',';
    //GetData����
    joRes.Add(sFull + '__key:"",');
    joRes.Add(sFull + '__ttl:"0px",');      //title top
    joRes.Add(sFull + '__hov:"-500px",');   //Ĭ�ϲ���ʾhover��
    //ɾ��ȷ�Ͽ�Ĭ�ϲ��ɼ�
    joRes.Add(sFull+'__cfv'+sMiddle+'false'+sTail);  //cfv:conform visible
    joRes.Add(sFull+'__edv'+sMiddle+'false'+sTail);  //edv:edit visible
    joRes.Add(sFull+'__eds'+sMiddle+'""'+sTail);     //eds:edit state �� ��������edit/append
    joRes.Add(sFull+'__btm'+sMiddle+'0'+sTail);     //btm : button mode . 0���༭��1������
    //�������check����մ���
    for iCol := 0 to joFields._Count -1 do begin
        joField := joFields._(iCol);
        if joField.type = 'check' then begin
            //���±�������check
            joRes.Add(sFull+'__cb'+IntToStr(iCol)+sMiddle+'false'+sTail);  
        end;
    end;
    Result := (joRes);
end;

//function dwGetAction(ACtrl: TControl): string; stdcall;
function dwGetAction(ACtrl: TControl): string; stdcall;
var 
    joRes   : Variant;
    sFull   : string;
begin
    joRes   := _dwGeneral(ACtrl,'action');
    Result := (joRes);
end;

//function dwGetMethods(ACtrl:TControl):String;stdCall;
function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    iCol        : Integer;  //��
    iItem       : Integer;  //
    iSum        : Integer;  //����
    iSumCount   : Integer;  //���ܵ��������
    iCount      : Integer;
    iRowH       : Integer;      //�����и�
    iTopH       : Integer;      //�������߰�ť���߶�
    iPageH      : Integer;      //��ҳ���߶�
    iRecCount   : Integer;  //���ݵ��ܼ�¼��
    iTitleH     : Integer;  //�������ĸ߶�
    iHeaderH    : Integer;
    iMaxTitle   : Integer;
    //
    sCode       : string;
    sFull       : string;
    sPrimaryKey : String;       //���ݱ�����
    slKeys      : TStringList;
    sTopBack    : string;
    //
    oDataSet    : TDataSet;
    //
    joRes       : Variant;
    joFields    : Variant;
    joField     : Variant;
    joSels      : Variant;  //���ڱ���
    joHint      : Variant;
    joSummary   : Variant;
    joSum       : Variant;
begin
    joRes := _Json('[]');
    //Ԥ����ȡ�����ò���
    //ȡ��HINT����joHint,��Ԥ����
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    sFull       := dwFullName(Actrl);
    //ȡ����Ĭ��ֵ,joFields
    iTopH       := dwGetInt(joHint,'topheight',40);
    iPageH      := dwGetInt(joHint,'pageheight',40);
    sTopBack    := dwGetStr(joHint,'topbackground','transparent');
    //
    joFields    := _GetFields(TListView(ACtrl));
    //�������ҳ�������÷�ҳ�߶�Ϊ0
    if not _GetModule(joHint,5) then begin
        iPageH := 0;
    end;
    with TListView(ACtrl) do begin
        
        //��ͷȫѡ/ȫ��ѡ�¼�
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            if joField.type = 'check' then begin
                sCode   := sFull+'__cc'+IntToStr(iCol)+'(val) {'
                			//�������м�¼��CheckBox
                			+'this.'+sFull+'__cd'+IntToStr(iCol)+'.forEach((item,index)=>{'
                				+'Vue.set(item,''c'',val);'
                			+'});'
                			+'this.dwevent("","'+sFull+'",val,"onfullcheck",'+IntToStr(TForm(Owner).Handle)+');'
                		+'},';
                joRes.Add(sCode);
            end;
        end;
        
        //__save �༭��save�¼�
        sCode   := sFull+'__save(e) '
                +'{'
                    //�������м�¼��CheckBox
                    +'var fds = [];'
                    +'for (var i=0;i<'+IntToStr(joFields._Count)+';i++) {'
                        +'var v = ''this.'+sFull+'__fd'' + i;'
                        +'fds.push(eval(v).toString());'
                    +'};'
                    //+'console.log(fds);'
                    +'var stmp = "''"+JSON.stringify(fds).toString()+"''";'
                    //+'console.log(stmp);'
                    +'if (this.'+sFull+'__dvv == true){'
                        +'this.dwevent("","'+sFull+'",stmp,"onsave",'+IntToStr(TForm(Owner).Handle)+');'
                    +'}else{'
                        +'this.dwevent("","'+sFull+'",stmp,"onappend",'+IntToStr(TForm(Owner).Handle)+');'
                    +'};'
                    //�������ݱ༭��
                    //+'this.'+sFull+'__sed=false;'
                    //��ʾ������ʾ��
                    +'this.'+sFull+'__dvv=true;'
                    +'e.stopPropagation();'//��ֹð��
                +'},';
        joRes.Add(sCode);
        
        //__canel �༭��cancel�¼�
        sCode   := sFull+'__cancel(e) '
                +'{'
                    //����"�༭"/"append"�ֱ� ����
                    +'if (this.'+sFull+'__dvv == true){'
                        //+'this.dwevent("","'+sFull+'",stmp,"onsave",'+IntToStr(TForm(Owner).Handle)+');'
                    +'}else{'
                        //��ʾ������ʾ��
                        +'this.'+sFull+'__edt=false;'
                    +'};'
                    //��ʾ������ʾ��
                    +'this.'+sFull+'__dvv=true;'
                    //���ر༭��
                    //+'this.'+sFull+'__sed=false;'   //sed:show editor
                    //
                    +'this.dwevent("","'+sFull+'","","oncancel",'+IntToStr(TForm(Owner).Handle)+');'
                    +'e.stopPropagation();'//��ֹð��
                +'},';
        joRes.Add(sCode);
        //__scroll �����������¼�����Ҫ������������
        sCode   := sFull+'__scroll(e) '
                +'{'
                    +'this.'+sFull+'__ttl = -e.target.scrollLeft+"px";'
                +'},';
        joRes.Add(sCode);
        //__format ���ڽ�������ʾ����100%����ֵ
        joRes.Add(sFull+'__format(value) {return () => { return value + ''%'' }},');
        //__query �����ؼ���input�ļ����¼�
        sCode   := concat(
                sFull+'__query(e,skeyword) {',
                    'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__key'',''onquery'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//��ֹð��
                '},');
        joRes.Add(sCode);
        //__pagechange ��ҳ�ؼ��л�ҳ���¼�
        sCode   := concat(
                sFull+'__pagechange(pageno) {',
                    'this.dwevent('''','''+sFull+''',pageno,''onpagechange'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//��ֹð��
                '},');
        joRes.Add(sCode);
        //__sortasc  ���������¼�
        sCode   := concat(
                sFull+'__sortasc(e,icol) {',
                    'this.dwevent(e,'''+sFull+''',icol,''onsortasc'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//��ֹð��
                '},');
        joRes.Add(sCode);
        //__sortdesc ���������¼�
        sCode   := concat(
                sFull+'__sortdesc(e,icol) {',
                    'this.dwevent(e,'''+sFull+''',icol,''onsortdesc'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//��ֹð��
                '},');
        joRes.Add(sCode);
        //__buttonclick ��ɾ�ģ�1/2/3����ť�¼�
        sCode   := concat(
                sFull+'__buttonclick(e,id) {'#13,
                    'switch(id) {'#13,
                         'case 1: //��'#13,
                            'this.'+sFull+'__btm = 1;'#13,
                            'this.dwevent(e,'''+sFull+''','''',''onappend'','''+IntToStr(TForm(Owner).Handle)+''');',
                            'this.'+sFull+'__edv = true;'#13,
                            'break;'#13,
                         'case 2: //ɾ'#13,
                            'this.'+sFull+'__cfv = true;'#13,
                            'break;'#13,
                         'case 3: //��'#13,
                            'this.'+sFull+'__btm = 3;'#13,
                            'this.'+sFull+'__edv = true;'#13,
                            'break;'#13,
                         'default: //'#13,
                            ''#13,
                    '};', 
                    //'this.dwevent(e,'''+sFull+''',id,''onsortdesc'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//��ֹð��
                '},');
        joRes.Add(sCode);
        //__editcancel �༭/������cancel�¼�
        sCode   := concat(
                sFull+'__editcancel(e) {'#13,
                    //'console.log(this.'+sFull+'__btm);',
                    'if(1 == this.'+sFull+'__btm) {'#13,
                        'this.dwevent(e,'''+sFull+''','''',''onappendcancel'','''+IntToStr(TForm(Owner).Handle)+''');',
                    '};', 
                    'this.'+sFull+'__edv = false;'#13,
                    //'this.dwevent(e,'''+sFull+''',id,''onsortdesc'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//��ֹð��
                '},');
        joRes.Add(sCode);
        //__editsave   �༭/������save�¼�
        
        sCode   := concat(
        		sFull+'__editsave(e) ',
        		'{',
        			//�������м�¼��CheckBox
        			'var fds = [];',
        			//'fds.push(recordno);',
        			'for (var i=0;i<'+IntToStr(joFields._Count)+';i++) {',
        				'var v = ''this.'+sFull+'__di'' + i;',
        				'if (eval(v)==null){',
        					'fds.push("");',
        				'}else{',
        					'fds.push(eval(v));',
        				'};',
        			'};',
        			//+'console.log(fds);'
        			'var stmp = "''"+JSON.stringify(fds).toString()+"''";',
        			//+'console.log(stmp);'
        			'this.dwevent("","'+sFull+'",stmp,"oneditsave",'+IntToStr(TForm(Owner).Handle)+');',
        			'this.'+sFull+'__edv=false;',
        			//�������ݱ༭��
        			//+'this.'+dwFullName(Actrl)+'__sed=false;'
        			'e.stopPropagation();',//��ֹð��
        		'},');
        joRes.Add(sCode);
        
        //__deleteconfirm ɾ��ȷ���¼�
        //__deleteconfirm ɾ��ȷ���¼�
        sCode   := concat(
                sFull+'__deleteconfirm(e) {'#13,
        			'this.'+sFull+'__cfv=false;',
        			'this.dwevent(e,'''+sFull+''','''',''ondeleteclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                    );
        //�������check����մ���
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            if joField.type = 'check' then begin
                //sCode   := Concat(sCode,
                sCode   := Concat(sCode,
                			'this.'+sFull+'__cd'+IntToStr(iCol)+'.forEach((item,index)=>{',
                				'Vue.set(item,''c'',0);',
                			'});');
                //���±�������check
                sCode   := Concat(sCode,
                			//�������м�¼��CheckBox
                			'this.'+sFull+'__cb'+IntToStr(iCol)+'=false;');
            end;
        end;
        joRes.Add(sCode+'},');
    end;
    Result   := joRes;
end;

exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetMethods,
    dwGetData;

begin
end.