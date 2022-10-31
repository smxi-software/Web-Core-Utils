unit SMX.Web.ThirdParty.Base;

interface

uses System.Classes;

Type

TsmwThirdPartyBase = class
private
    FTargetId: String;
    FRequiredCSS: TStrings;
    FRequiredJSLibs: TStrings;
protected
   procedure AddCSSLinksToDocument;
   procedure AddJSLibsToDocument;
   function InitialiseTarget: Boolean; virtual;
   function InternalLoad: Boolean; virtual;
public
  constructor Create;
  destructor Destroy;
  function Load: Boolean;
  property TargetId: String read FTargetId write FTargetId;
  property RequiredCSS: TStrings read FRequiredCSS;
  property RequiredJSLibs: TStrings read FRequiredJSLibs;
end;

implementation

uses SMX.Web.Document.Utils;

{ TsmwThirdPartyBase }

procedure TsmwThirdPartyBase.AddCSSLinksToDocument;
var
  I: Integer;
begin
  for I := 0 to FRequiredCSS.Count - 1 do
      TDocUtils.addCSSFile(FRequiredCSS[I]);
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
  FRequiredCSS.Free;
  FRequiredJSLibs.Free;
end;

function TsmwThirdPartyBase.InternalLoad: Boolean;
begin
  result := True;
end;

function TsmwThirdPartyBase.Load: Boolean;
begin
  AddCSSLinksToDocument;
  AddJSLibsToDocument;
  Result := InitialiseTarget;
  if Result then
     Result := InternalLoad;
end;

end.
