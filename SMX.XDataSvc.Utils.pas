Unit SMX.XDataSvc.Utils;

Interface

Uses
  System.Generics.Collections,
  XData.Web.Client,
  JS;

Type
  TXDataSvcUtils = Class
  Public
    Class Function AsString(Response: TXDataClientResponse): String;
    Class Function AsInteger(Response: TXDataClientResponse): integer;
    Class Function AsFloat(Response: TXDataClientResponse): double;
    Class Function AsBoolean(Response: TXDataClientResponse): boolean;
    Class Function AsObject(Response: TXDataClientResponse): TJSObject;
    Class Function AsArray(Response: TXDataClientResponse): TJSArray;
    Class Function AsListOfStrings(Response: TXDataClientResponse): TList<string>;
  End;

Implementation

{ TsmxXDataUtils }

Class Function TXDataSvcUtils.AsArray(Response: TXDataClientResponse): TJSArray;
Begin
  Result := JS.ToArray(Response.ResultAsObject['value']);
End;

class function TXDataSvcUtils.AsBoolean(Response: TXDataClientResponse): boolean;
begin
    Result := JS.toBoolean(Response.ResultAsObject['value']);
end;

Class Function TXDataSvcUtils.AsFloat(Response: TXDataClientResponse): double;
Begin
  Result := JS.toNumber(Response.ResultAsObject['value']);
End;

Class Function TXDataSvcUtils.AsInteger(Response: TXDataClientResponse): integer;
Begin
  Result := JS.ToInteger(Response.ResultAsObject['value']);
End;

class function TXDataSvcUtils.AsListOfStrings(Response: TXDataClientResponse): TList<string>;
var
 AnArray: TJSArray;
 I: Integer;
begin
  Result := TList<string>.Create;
  AnArray := AsArray(Response);
  for I := 0 to AnArray.Length - 1 do
   Result.Add(JS.toString(AnArray[I]));
end;

Class Function TXDataSvcUtils.AsObject(Response: TXDataClientResponse): TJSObject;
Begin
  Result := JS.ToObject(Response.ResultAsObject);
End;

Class Function TXDataSvcUtils.AsString(Response: TXDataClientResponse): String;
Begin
  Result := JS.ToString(Response.ResultAsObject['value']);
End;

End.
