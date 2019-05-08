unit UDinamic;

interface

uses System.Classes, System.Variants, System.SysUtils, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Data.DB, Datasnap.DBClient,
  REST.Response.Adapter, System.JSON;

type
  Metodo = (mGET, mPOST, mPATCH, mDELETE);

type
  RClientDataSet = record
    Indice: Integer;
    CDSet: TClientDataSet;
    StatusCode: Integer;
    mensagem: String;
    erro: string;
  end;

type
  Dinamic = class

  class var
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    BaseURL: String;
    ClientDataSet: TClientDataSet;

  public
    class procedure Config;

    class function Request(recurso, body: string; Metodo: Metodo)
      : RClientDataSet;


    class function Dataset: TClientDataSet;

    class procedure JsonToDataset(aDataset: TDataSet; aJSON: string);

  end;

var
  RCDS: array of RClientDataSet;

implementation

{ TDinamic }

class procedure Dinamic.Config;
begin
  BaseURL := 'https://appagendamedica.herokuapp.com/';
  RESTClient := TRESTClient.Create(BaseURL);
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';

  RESTResponse := TRESTResponse.Create(RESTClient);
  RESTResponse.ContentType := 'application/json';

  RESTRequest := TRESTRequest.Create(RESTClient);
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;

  ClientDataSet := TClientDataSet.Create(RESTClient);
  RESTResponseDataSetAdapter := TRESTResponseDataSetAdapter.Create(RESTClient);
  RESTResponseDataSetAdapter.Response := RESTResponse;
  RESTResponseDataSetAdapter.Dataset := ClientDataSet;

end;

class function Dinamic.Dataset: TClientDataSet;
begin
  Result := ClientDataSet;
end;

class function Dinamic.Request(recurso, body: string; Metodo: Metodo)
  : RClientDataSet;
var
  rcds: RClientDataSet;
begin
  RESTClient.BaseURL := BaseURL + recurso;
  RESTRequest.ClearBody;
  RESTRequest.AddBody(body, ctAPPLICATION_JSON);
  case Metodo of
    mGET:
      begin
        RESTRequest.Method := rmGET;
        if body <> '{"RowId":1,"id":"0"}' then
          RESTRequest.AddBody(body, ctAPPLICATION_JSON)
        else
          RESTRequest.ClearBody;
      end;
    mPOST:
      begin
        RESTClient.BaseURL := BaseURL + recurso + '/cadastrar/';
        RESTRequest.Method := rmPOST;
      end;
    mPATCH:
      begin
        RESTRequest.Method := rmPATCH;
      end;
    mDELETE:
      begin
        RESTRequest.Method := rmDELETE;
      end;
  end;

  try
{    RESTRequest.ExecuteAsync(
      procedure
      begin
        rcds.StatusCode := RESTResponse.StatusCode;
        rcds.Indice := 0;
        // rcds.CDSet := ClientDataSet;

      end, true, true);
 }
     RESTRequest.Execute;
  finally
    rcds.StatusCode := RESTResponse.StatusCode;
    rcds.Indice := 0;
    rcds.CDSet := ClientDataSet;
    Result := rcds;
  end;

end;

class procedure Dinamic.JsonToDataset(aDataset: TDataSet; aJSON: string);
var
  JObj: TJSONArray;
  vConv: TCustomJSONDataSetAdapter;
begin
  if (aJSON = EmptyStr) then
  begin
    Exit;
  end;

  JObj := TJSONObject.ParseJSONValue(aJSON) as TJSONArray;
  vConv := TCustomJSONDataSetAdapter.Create(Nil);

  try
    vConv.Dataset := aDataset;
    vConv.UpdateDataSet(JObj);
  finally
    vConv.Free;
    JObj.Free;
  end;
end;

end.
