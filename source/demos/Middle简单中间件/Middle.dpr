library Middle;

uses
  SysUtils,
  SynCommons,
  IdURI,
  dwBase,
  Forms,
  Messages,
  StdCtrls,
  Variants,
  Windows,
  Classes,
  Unit_middle in 'Unit_middle.pas' {Form_Middle};

{$R *.res}
function dwDirectInteraction(AData:PWideChar):PWideChar;stdcall;
var
    sData   : string;
    joRes   : Variant;
    oForm   : TForm_Middle;
begin
{
    //此处用于取得post或get发送的数据
    sData   := TIdURI.URLDecode(String(AData));

    //更新表dw_Order相应id的记录的state为9
    oForm   := TForm_Middle.Create(nil);
    Result  := PChar(oForm.GetData(0,10));
    oForm.Free;
}
    Result  := '''
    [
        {
            "Brand": "BMW",
            "Model": "Z8",
            "Hp": 400,
            "Max speed": 250,
            "City": "Munchen",
            "Country": "Germany",
            "Type": "cabrio",
            "Picture": "bmw1.jpg",
            "Year": 2000,
            "Price": 95000,
            "Cylinders": 8,
            "URL": "www.bmw.com",
            "Stock": 0
        },
        {
            "Brand": "Lamborghini",
            "Model": "Urus",
            "Hp": 600,
            "Max speed": 250,
            "City": "Sant'Agata Bolognese",
            "Country": "Italy",
            "Type": "SUV",
            "Picture": "lam1.jpg",
            "Year": 2017,
            "Price": 150000,
            "Cylinders": 10,
            "URL": "www.lamborghini.com",
            "Stock": 1
        },
        {
            "Brand": "BMW",
            "Model": "i8",
            "Hp": 228,
            "Max speed": 227,
            "City": "Munchen",
            "Country": "Germany",
            "Type": "cabrio",
            "Picture": "bmw2.jpg",
            "Year": 2014,
            "Price": 142000,
            "Cylinders": 3,
            "URL": "www.bmw.com",
            "Stock": 0
        },
        {
            "Brand": "BMW",
            "Model": "Z4",
            "Hp": 335,
            "Max speed": 155,
            "City": "Munchen",
            "Country": "Germany",
            "Type": "cabrio",
            "Picture": "bmw3.jpg",
            "Year": 2003,
            "Price": 60000,
            "Cylinders": 6,
            "URL": "www.bmw.com",
            "Stock": 0
        },
        {
            "Brand": "Ferrari",
            "Model": "California T",
            "Hp": 553,
            "Max speed": 294,
            "City": "Maranello",
            "Country": "Italy",
            "Type": "cabrio GT",
            "Picture": "fer4.jpg",
            "Year": 2009,
            "Price": 250000,
            "Cylinders": 8,
            "URL": "www.ferrari.com",
            "Stock": 1
        },
        {
            "Brand": "Lamborghini",
            "Model": "Aventador",
            "Hp": 751,
            "Max speed": 350,
            "City": "Sant'Agata Bolognese",
            "Country": "Italy",
            "Type": "cabrio",
            "Picture": "lam2.jpg",
            "Year": 2011,
            "Price": 475000,
            "Cylinders": 12,
            "URL": "www.lamborghini.com",
            "Stock": 0
        },
        {
            "Brand": "Lamborghini",
            "Model": "Gallardo",
            "Hp": 350,
            "Max speed": 350,
            "City": "Sant'Agata Bolognese",
            "Country": "Italy",
            "Type": "cabrio",
            "Picture": "lam3.jpg",
            "Year": 2003,
            "Price": 200000,
            "Cylinders": 8,
            "URL": "www.lamborghini.com",
            "Stock": 0
        },
        {
            "Brand": "Mercedes",
            "Model": "S63 AMG",
            "Hp": 525,
            "Max speed": 320,
            "City": "Stuttgart",
            "Country": "Germany",
            "Type": "coupé",
            "Picture": "merc5.jpg",
            "Year": 2006,
            "Price": 220000,
            "Cylinders": 8,
            "URL": "www.mercedes-benz.com",
            "Stock": 0
        }
    ]
    ''';
end;




exports
     dwDirectInteraction;

end.
