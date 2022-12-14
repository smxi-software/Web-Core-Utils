unit SMX.Web.Utils;

interface

type

  TWebUtils = class
  public
    class function SplitOnCaps(const Value: string): string;
    class function CapitaliseFirstLetter(const Value: string): string;
    class function CapitaliseWords(const Value: string): string;
    class function ConCat(Value: array of string; const ADelim: string): string;
    class function SecondsAsTime(const ASeconds: Int64): string;
    class function IsEmailValid(const Value: string): Boolean;
  end;

const
  YesNo: array [Boolean] of string = ('No', 'Yes');
  SYS_DATE_FORMAT = 'dd/mm/yyyy';
  SYS_DATETIME_FORMAT = 'dd/mm/yyyy hh:nn';
  SYS_MONEY_FORMAT = '#,##0.00';
  key_tab = 9;
  key_enter = 13;
  key_space = 32;
  key_left = 37;
  key_up = 38;
  key_right = 39;
  key_down = 40;
  smWordDelimiters: array of Char = [' ', ';', ':', ',', ',', ')', '-', #10, #13, #160];

implementation

uses
  System.SysUtils,
  System.DateUtils;

{ TWebUtils }

class function TWebUtils.CapitaliseFirstLetter(const Value: string): string;
begin
  if Value = '' then
    Exit('');
  result := Value.Substring(0, 1).ToUpper + Value.Substring(1).ToLower;
end;

class function TWebUtils.CapitaliseWords(const Value: string): string;
var
  i: Integer;
  c, lc: Char;
  lWord: string;
  lWords: TArray<string>;
begin

  result := '';
  lWords := Value.Split(smWordDelimiters);
  for lWord in lWords do
  begin
    if lWord = '' then
      Continue;
    result := result + lWord.Substring(0, 1).ToUpper + lWord.Substring(1).ToLower + ' ';
  end;

  result := result.TrimRight;
end;

class function TWebUtils.ConCat(Value: array of string; const ADelim: string): string;
var
  i: Integer;
begin
  result := '';
  for i := 0 to Length(Value) - 1 do
  begin
    if Value[i] <> '' then
      result := result + Value[i] + ADelim;
  end;
  result := result.Substring(0, result.Length - ADelim.Length);
end;

class function TWebUtils.IsEmailValid(const Value: string): Boolean;
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

class function TWebUtils.SecondsAsTime(const ASeconds: Int64): string;
var
  lTime: TDateTime;
begin
  lTime := IncSecond(0.0, ASeconds);
  result := FormatDateTime('hh:nn:ss', lTime);
  if lTime >= 1 then
    result := Trunc(lTime).ToString + 'days ' + result;
end;

class function TWebUtils.SplitOnCaps(const Value: string): string;
var
  i: Integer;
  c: Char;
begin
  if Value.Length < 4 then
    Exit(Value);

  result := Value.Chars[0];
  if Value.Length = 1 then
    Exit;
  for i := 1 to Value.Length - 1 do
  begin
    c := Value.Chars[i];
    if (c in ['A' .. 'Z']) then
      result := result + ' ' + c
    else
      result := result + c;
  end;
end;

end.
