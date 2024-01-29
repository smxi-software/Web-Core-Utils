unit SMX.Web.XData.Utils;

interface

uses JS;

type

  TAppConfig = class
  private
    FBaseUrl: string;
    FAuthUrl: string;
    FConfig: TJSObject;
  public
    constructor Create;
    procedure Load(AResponse: string);

    function GetValue(const Key: string): string;
    property BaseUrl: string read FBaseUrl write FBaseUrl;
    /// <summary>
    /// for Sphinx based Systems this points to the Sphinx Server
    /// </summary>
    property AuthUrl: string read FAuthUrl write FAuthUrl;
  end;

  TWebXDataUtils = class
  public
    [async]
    class function LoadConfig: boolean;
  end;

function AppConfig: TAppConfig;

implementation

uses
  XData.Web.Connection,
  XData.Web.Request,
  XData.Web.Response;

var
  FAppConfig: TAppConfig;

function AppConfig: TAppConfig;
begin
  if not Assigned(FAppConfig) then
    FAppConfig := TAppConfig.Create;
  Result := FAppConfig;
end;


{ TAppConfig }

constructor TAppConfig.Create;
begin
  FBaseUrl := '';
  FAuthUrl := '';
end;

function TAppConfig.GetValue(const Key: string): string;
begin
  Result := JS.toString(FConfig[Key]);
end;

procedure TAppConfig.Load(AResponse: string);
begin
  FConfig := TJSObject(TJSJSON.parse(AResponse));

  if JS.toString(FConfig['BaseUrl']) <> '' then
    FBaseUrl := JS.toString(FConfig['BaseUrl']);

  if JS.toString(FConfig['AuthUrl']) <> '' then
    FAuthUrl := JS.toString(FConfig['AuthUrl']);

  if FAuthUrl = '' then
    FAuthUrl := FBaseUrl;


end;

{ TWebXDataUtils }

class function TWebXDataUtils.LoadConfig: boolean;
var
  Conn: TXDataWebConnection;
  Response: IHttpResponse;
  Request: IHttpRequest;
begin
  Result := False;
  Conn := TXDataWebConnection.Create(nil);
  try
    Request := THttpRequest.Create('config/config.json');
    Response := TAwait.Exec<IHttpResponse>(Conn.SendRequestAsync(Request));
    if Response.StatusCode = 200 then
    begin
      AppConfig.Load(Response.ContentAsText);
      Result := True;
    end;
  finally
    Conn.Free;
  end;
end;

end.
