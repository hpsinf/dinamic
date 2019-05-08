unit UTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Data.DB, Datasnap.DBClient,
  REST.Response.Adapter, Vcl.Grids, Vcl.DBGrids, UDinamic, Vcl.StdCtrls,
  Vcl.ExtCtrls,

  uJson, Helper, Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.StrUtils;

type
  TForm2 = class(TForm)
    Button1: TButton;
    DBGrid2: TDBGrid;
    DataSource2: TDataSource;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Button4: TButton;
    Edit1: TLabeledEdit;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
  procedure FormatarDatas;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  cds: RClientDataSet;
  mem: TFDMemTable;
  json: string;
begin
  mem := TFDMemTable.Create(Self);
  mem.FieldDefs.Clear;
  mem.FieldDefs.Add('id', ftString, 50);
  mem.CreateDataSet;

  mem.Open;
  mem.Edit;
  mem.FieldByName('id').Value := '0';
  mem.POST;

  json := mem.ToJson();
  Delete(json, 1, 1);
  Delete(json, json.Length, 1);

  mem.Free;


  cds := Dinamic.Request('iris/pacientes/', json, mGET);
  DataSource2.DataSet := cds.CDSet;
  Label1.Caption := 'Status Code: ' + IntToStr(cds.StatusCode);
  FormatarDatas;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  cds: RClientDataSet;
begin
  cds := Dinamic.Request('iris/pacientes', '?nome=' + Edit1.Text +
    '&genero=Masculino&data_nascimento=' + FormatDateTime('DD-MM-YYYY',
    Now), mPOST);
  DataSource2.DataSet := cds.CDSet;
  Label1.Caption := 'Status Code: ' + IntToStr(cds.StatusCode);
  Button1.Click;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  cds: RClientDataSet;
  json: string;
  mem: TFDMemTable;
begin
  mem := TFDMemTable.Create(Self);
  mem.FieldDefs.Clear;
  mem.FieldDefs.Add('id', ftString, 50);
  mem.CreateDataSet;

  mem.Open;
  mem.Edit;
  mem.FieldByName('id').Value := DataSource2.DataSet.FieldByName('_id')
    .AsString;
  mem.POST;

  json := mem.ToJson();
  Delete(json, 1, 1);
  Delete(json, json.Length, 1);

  mem.Free;
  cds := Dinamic.Request('iris/pacientes/', json, mDELETE);
  Label1.Caption := 'Status Code: ' + IntToStr(cds.StatusCode);
  Button1.Click;
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  RCds: RClientDataSet;
  json: string;
  mem: TFDMemTable;
begin
  // -------------------------------------------------------
  mem := TFDMemTable.Create(Self);
  mem.FieldDefs.Clear;
  mem.FieldDefs.Add('id', ftString, 50);
  mem.FieldDefs.Add('nome', ftString, 50);
  mem.CreateDataSet;

  mem.Open;
  mem.Edit;
  mem.FieldByName('id').Value := DataSource2.DataSet.FieldByName('_id')
    .AsString;
  mem.FieldByName('nome').Value := Edit1.Text;
  mem.POST;

  json := mem.ToJson();

  mem.Free;

  // remover o '[' no inicio e  ']' no final da json
  // Caso contrario o json é atribuido como um obj array no servidor
  Delete(json, 1, 1);
  Delete(json, json.Length, 1);

  // -------------------------------------------------------

  RCds := Dinamic.Request('iris/pacientes/', json, mPATCH);
  Label1.Caption := 'Status Code: ' + IntToStr(RCds.StatusCode);
  // Button1.Click;
  DataSource1.DataSet := RCds.CDSet;

end;

procedure TForm2.Button5Click(Sender: TObject);
var
  ch, dia, ano, mes: string;

  FmtStngs: TFormatSettings;
begin
  DataSource2.DataSet.Open;
  while not DataSource2.DataSet.Eof do
  begin
    DataSource2.DataSet.Edit;
    ch := DataSource2.DataSet.FieldByName('data_nascimento').AsString;
    Delete(ch, 11, ch.Length - 10);
//    ch := StringReplace(ch, '-', '/', [rfReplaceAll]);
    dia := Copy(ch,9, 2);
    mes := Copy(ch,6, 2);
    ano := Copy(ch,1, 4);
    DataSource2.DataSet.FieldByName('data_nascimento').AsString := dia+'/'+mes+'/'+ano;
    DataSource2.DataSet.Next;
  end;
  DataSource2.DataSet.First;
end;

procedure TForm2.FormatarDatas;
var
  ch, dia, ano, mes: string;

begin
  DataSource2.DataSet.Open;
  while not DataSource2.DataSet.Eof do
  begin
    DataSource2.DataSet.Edit;
    ch := DataSource2.DataSet.FieldByName('data_nascimento').AsString;
    Delete(ch, 11, ch.Length - 10);
//    ch := StringReplace(ch, '-', '/', [rfReplaceAll]);
    dia := Copy(ch,9, 2);
    mes := Copy(ch,6, 2);
    ano := Copy(ch,1, 4);
    DataSource2.DataSet.FieldByName('data_nascimento').AsString := dia+'/'+mes+'/'+ano;

    DataSource2.DataSet.Next;
  end;
  DataSource2.DataSet.First;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Dinamic.Config;
end;

end.
