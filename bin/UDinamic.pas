unit UDinamic;

interface

uses System.Classes, System.Variants, System.SysUtils, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Data.DB, Datasnap.DBClient,
  REST.Response.Adapter;

type
  Metodo = (GET, POST, PATCH, DELETE);

type
  RClientDataSet = record
    Indice: Integer;
    CDSet: TClientDataSet;
    StatusCode: Integer;
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
      : RClientDataSet; overload;

    class function Request(recurso: string; Metodo: Metodo)
      : RClientDataSet; overload;

    class function Dataset: TClientDataSet;

  end;

var
  cds: array of TClientDataSet;

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

class function Dinamic.Request(recurso: string; Metodo: Metodo): RClientDataSet;
begin

  RESTClient.BaseURL := BaseURL + recurso;
  case Metodo of
    GET:
      RESTRequest.Method := rmGET;
    POST:
      RESTRequest.Method := rmPOST;
    PATCH:
      RESTRequest.Method := rmPATCH;
    DELETE:
      RESTRequest.Method := rmDELETE;
  end;

  RESTRequest.Execute;
  Result.StatusCode := RESTResponse.StatusCode;
  Result.CDSet := ClientDataSet;
  Result.Indice := 0;

end;

class function Dinamic.Request(recurso, body: string; Metodo: Metodo)
  : RClientDataSet;
begin
  RESTClient.BaseURL := BaseURL + recurso + body;
  RESTRequest.ClearBody;
  case Metodo of
    GET:
      begin
        RESTRequest.Method := rmGET;
      end;
    POST:
      begin
        RESTClient.BaseURL := BaseURL + recurso + '/cadastrar/' + body;
        RESTRequest.Method := rmPOST;
        // RESTRequest.AddBody(parametros, ctAPPLICATION_JSON);
      end;
    PATCH:
      begin
        RESTClient.BaseURL := BaseURL + recurso;
        RESTRequest.Method := rmPATCH;
        RESTRequest.AddBody(body, ctAPPLICATION_JSON);
      end;
    DELETE:
      begin
        RESTClient.BaseURL := BaseURL + recurso + body;
        RESTRequest.Method := rmDELETE;
        // RESTRequest.AddBody(body, ctAPPLICATION_JSON);
      end;
  end;

  RESTRequest.Execute;
  Result.StatusCode := RESTResponse.StatusCode;
  Result.CDSet := ClientDataSet;
  Result.Indice := 0;

end;

end.
