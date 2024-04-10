unit SMX.Web.ThirdParty.Base;

interface

uses
  System.Classes;

type

  TsmwThirdPartyBase = class
  private
    FTargetId: string;
    FRequiredCSS: TStrings;
    FRequiredJSLibs: TStrings;
    procedure AddCSSToDocument;
    procedure RemoveCSSFromDocument;
    procedure AddJSLibsToDocument;
  protected
    function InitialiseTarget: Boolean; virtual;
    function InternalLoad: Boolean; virtual;
    procedure AddCSS(const AID, AURL: string);
  public
    constructor Create;
    destructor Destroy;
    function Load: Boolean;
    property TargetId: string read FTargetId write FTargetId;
    property RequiredCSS: TStrings read FRequiredCSS;
    property RequiredJSLibs: TStrings read FRequiredJSLibs;
  end;

implementation

uses
  WebLib.Forms,
  SMX.Web.Document.Utils;

{ TsmwThirdPartyBase }

procedure TsmwThirdPartyBase.AddCSS(const AID, AURL: string);
begin
  FRequiredCSS.AddPair(AID, AURL);
end;

procedure TsmwThirdPartyBase.AddCSSToDocument;
var
  I: Integer;
  CSSID, CSSURL: string;
begin
  for I := 0 to FRequiredCSS.Count - 1 do
  begin
    CSSID := FRequiredCSS.Names[I];
    CSSURL := FRequiredCSS.ValueFromIndex[I];
    Application.InsertCSS(CSSID, CSSURL);
  end;
end;

procedure TsmwThirdPartyBase.AddJSLibsToDocument;
var
  I: Integer;
begin
  for I := 0 to FRequiredJSLibs.Count - 1 do
    TDocUtils.addScriptFile(FRequiredJSLibs[I]);
end;

constructor TsmwThirdPartyBase.Create;
begin
  FRequiredCSS := TStringList.Create;
  FRequiredJSLibs := TStringList.Create;
end;

destructor TsmwThirdPartyBase.Destroy;
begin
  RemoveCSSFromDocument;
  FRequiredCSS.Free;

  FRequiredJSLibs.Free;
end;

function TsmwThirdPartyBase.InitialiseTarget: Boolean;
begin

end;

function TsmwThirdPartyBase.InternalLoad: Boolean;
begin
  result := True;
end;

function TsmwThirdPartyBase.Load: Boolean;
begin
  AddCSSToDocument;
  AddJSLibsToDocument;
  result := InitialiseTarget;
  if result then
    result := InternalLoad;
end;

procedure TsmwThirdPartyBase.RemoveCSSFromDocument;
var
  I: Integer;
begin
  for I := 0 to FRequiredCSS.Count - 1 do
  begin
    Application.RemoveCSS(FRequiredCSS.Names[I]);
  end;

end;

end.
