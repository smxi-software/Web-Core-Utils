unit SMX.CRM.Utils;

interface

uses
  System.SysUtils,
  WebLib.ExtCtrls,
  WebLib.CDS,
  JS,
  Data.DB;

type

  TPostCodePart = (pcNotPostCode, pcPartial, pcFull);

  TCRMUtils = class
    class function IsPostCode(const Value: string): TPostCodePart;
    class function FormatPostCode(const Value: string): string;
    class function FormattedAddress(const ADataset: TDataset; const ADelim: string): string;
    class function FullName(const ADataset: TDataset): string;
    class function ShortName(const ADataset: TDataset): string;

    class function IsEmailValid(const Value: string): Boolean;

  end;

const
  NAME_TITLES = 'Capt,Cllr,Col,Dame,Dr,Hon,Lord,Lady,Lt,Miss,Mjr,Mr,Mrs,Ms,Mstr,Mx,Past,Rev,Sgt,Sir';

implementation

uses
  SMX.Web.Utils,
  System.StrUtils;

{ TCRMUtils }

class function TCRMUtils.FormatPostCode(const Value: string): string;
var
  lLength: Integer;
begin
  result := Value.ToUpper;
  if result.IndexOf(' ') = -1 then
  begin
    lLength := result.Length;
    if lLength <= 7 then
      result := result.Substring(0, lLength - 3) + ' ' + result.Substring(lLength - 3);
  end
  else
  begin
    result := Value;
    while result.IndexOf('  ') > -1 do
      result := StringReplace(result, '  ', ' ', []);
  end;
end;

class function TCRMUtils.FormattedAddress(const ADataset: TDataset; const ADelim: string): string;
begin
  result := TWebUtils.ConCat([ADataset.FieldByName('Add1').AsString, ADataset.FieldByName('Add2').AsString,
    ADataset.FieldByName('Add3').AsString, ADataset.FieldByName('City').AsString,
    ADataset.FieldByName('PostCode').AsString], ADelim);
end;

class function TCRMUtils.FullName(const ADataset: TDataset): string;
begin
  result := TWebUtils.ConCat([ADataset.FieldByName('Title').AsString, ADataset.FieldByName('FirstName').AsString,
    ADataset.FieldByName('LastName').AsString], ' ').Trim;
end;

class function TCRMUtils.IsEmailValid(const Value: string): Boolean;
  function CheckAllowed(const s: string): Boolean;
  var
    i: Integer;
  begin
    result := False;
    for i := 1 to Length(s) do
    begin
      // illegal char - no valid address
      if not(s[i] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-', '.', '+']) then
        Exit;
    end;
    result := True;
  end;

var
  i: Integer;
  namePart, serverPart: string;
begin
  result := False;

  i := Pos('@', Value);
  if (i = 0) then
    Exit;

  if (Pos('..', Value) > 0) or (Pos('@@', Value) > 0) or (Pos('.@', Value) > 0) then
    Exit;

  if (Pos('.', Value) = 1) or (Pos('@', Value) = 1) then
    Exit;

  namePart := Copy(Value, 1, i - 1);
  serverPart := Copy(Value, i + 1, Length(Value));
  if (Length(namePart) = 0) or (Length(serverPart) < 5) then
    Exit; // too short

  i := Pos('.', serverPart);
  // must have dot and at least 3 places from end
  if (i = 0) or (i > (Length(serverPart) - 2)) then
    Exit;

  result := CheckAllowed(namePart) and CheckAllowed(serverPart);

end;

class function TCRMUtils.IsPostCode(const Value: string): TPostCodePart;
{
  Valid Formats
  AA9A 9AA
  A9A 9AA
  A9 9AA
  A99 9AA
  AA99 9AA
}

var
  lInwardLen: Integer;

  function _CheckInward(const AInward: string): Boolean;
  begin
    if StrToIntDef(Copy(AInward, 1, 1), -1) = -1 then
      Exit(False); // first char has to be a number
    lInwardLen := Length(AInward);
    // these characters never appear in the inward code
    if (lInwardLen > 1) and (AInward[2] in ['C', 'I', 'K', 'M', 'O', 'V', '0' .. '9']) then
      Exit(False);
    if (lInwardLen = 3) and (AInward[3] in ['C', 'I', 'K', 'M', 'O', 'V', '0' .. '9']) then
      Exit(False);
    result := True;
  end;

  function _CheckOutward(AOutward: string): Boolean;
  var
    i: byte;
  begin
    for i := 1 to Length(AOutward) do
      if ord(AOutward[i]) in [65 .. 90] then // or AOutward[i] in ['A'..'Z']
        AOutward[i] := 'A'
      else
        AOutward[i] := '9';

    if AnsiIndexStr(AOutward, ['A9', 'A99', 'AA9', 'A9A', 'AA99', 'AA9A']) = -1 then
      Exit(False);

    result := True;
  end;

var
  iSpacePos, lLen: byte;
  sInput, sInward, sOutward: string;
begin
  result := pcNotPostCode;

  if (Value = EmptyStr) then
    Exit;

  if Length(Value) > 8 then
    Exit;

  sInput := UpperCase(Value);

  iSpacePos := Pos(' ', sInput);
  if iSpacePos = 0 then
  begin
    lLen := Length(sInput);
    if (lLen = 6) then
      sInput := Copy(sInput, 1, 3) + ' ' + Copy(sInput, 4, 3)
    else if (lLen = 7) then
      sInput := Copy(sInput, 1, 4) + ' ' + Copy(sInput, 4, 3)
    else if (lLen <= 4) then
    begin
      if not _CheckOutward(sInput) then
        Exit(pcNotPostCode)
      else
        Exit(pcPartial);
    end
    else
      Exit;
  end;

  sInward := Copy(sInput, iSpacePos + 1, 3);
  sOutward := Copy(sInput, 1, iSpacePos - 1);

  if not _CheckInward(sInward) then
    Exit(pcNotPostCode);

  if not _CheckOutward(sOutward) then
    Exit(pcNotPostCode);
  // build the outward code as the patterns from the site

  if lInwardLen < 3 then
    result := TPostCodePart.pcPartial
  else
    result := pcFull;

end;

class function TCRMUtils.ShortName(const ADataset: TDataset): string;
begin
  result := TWebUtils.ConCat([ADataset.FieldByName('FirstName').AsString, ADataset.FieldByName('LastName').AsString],
    ' ').Trim;
end;

end.
