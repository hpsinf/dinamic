unit UTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Data.DB, Datasnap.DBClient,
  REST.Response.Adapter, Vcl.Grids, Vcl.DBGrids, UDinamic, Vcl.StdCtrls,
  Vcl.ExtCtrls,

  uJson, Helper, Vcl.ComCtrls;

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
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  cds: RClientDataSet;
begin
  cds := Dinamic.Request('iris/pacientes/', GET);
  DataSource2.DataSet := cds.CDSet;
  Label1.Caption := 'Status Code: ' + IntToStr(cds.StatusCode);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  cds: RClientDataSet;
begin
  cds := Dinamic.Request('iris/pacientes',
    '?nome='+Edit1.Text+'&genero=Masculino&data_nascimento='+FormatDateTime('DD-MM-YYYY',Now), POST);
  DataSource2.DataSet := cds.CDSet;
  Label1.Caption := 'Status Code: ' + IntToStr(cds.StatusCode);
  Button1.Click;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  cds: RClientDataSet;
  id: string;
begin
  id := DataSource2.DataSet.FieldByName('_id').AsVariant;
  cds := Dinamic.Request('iris/pacientes/', id, DELETE);
  Label1.Caption := 'Status Code: ' + IntToStr(cds.StatusCode);
  Button1.Click;
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  cds: RClientDataSet;
  id: string;
begin
  id := DataSource2.DataSet.FieldByName('_id').AsVariant;
  cds := Dinamic.Request('iris/pacientes/?id=' + id,
    '{'+
    '"nome": "' + Edit1.Text + '"}', PATCH);
  Label1.Caption := 'Status Code: ' + IntToStr(cds.StatusCode);
  Button1.Click;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Dinamic.Config;
end;
end.
