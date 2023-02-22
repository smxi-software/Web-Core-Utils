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
    class function IsNumber(const Value: string): Boolean;
    class function IsInteger(const Value: string): Boolean;
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

  //FontAwesome Icons for Toasts
  FA_AnyOld_Icon = 'far fa-dot-circle';
  FA_Saved_Icon = 'fas fa-save';


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

class function TWebUtils.IsInteger(const Value: string): Boolean;
var
  v: Integer;
begin
  result := TryStrToInt(Value, v);
end;

class function TWebUtils.IsNumber(const Value: string): Boolean;
var
  v: Double;
begin
  result := TryStrToFloat(Value, v);
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
