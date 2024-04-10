unit SMX.Web.Table.Simple;

interface

uses
  System.Generics.Collections,
  System.Classes,
  System.SysUtils;

type

  TBodyData = class(TList<string>);

  TsmwSimpleTable = class
  private
    FTableClass: string;
    FCols: Integer;
    FRows: Integer;
    FData: TObjectList<TBodyData>;
    FTitles: TStrings;
    FTitle: string;
    function GetTableClass: string;
    function GetCell(const ARow, ACol: Integer): string;
    procedure SetCell(const ARow, ACol: Integer; const Value: string);
  public
    constructor Create(const ARows, ACols: Integer; ATableClass: string);
    destructor Destroy; override;
    function Table: string;
    procedure AddCell(const ARow, ACol: Integer; const AData: string);
    property Titles: TStrings read FTitles;
    property Title: string read FTitle write FTitle;
    property Cell[const ARow, ACol: Integer]: string read GetCell write SetCell;
  end;

implementation

{ TsmwSimpleTable }

procedure TsmwSimpleTable.AddCell(const ARow, ACol: Integer; const AData: string);
var
  Index: Integer;
  lBodyData: TBodyData;
begin
  lBodyData := FData[ARow];
  lBodyData[ACol] := AData;
end;

constructor TsmwSimpleTable.Create(const ARows, ACols: Integer; ATableClass: string);
var
  I, J: Integer;
  lBodyData: TBodyData;
begin
  FRows := ARows;
  FCols := ACols;
  FTableClass := ATableClass;
  FTitles := TStringList.Create;
  FData := TObjectList<TBodyData>.Create(True);
  for I := 0 to FRows - 1 do
  begin
    lBodyData := TBodyData.Create;
    for J := 0 to FCols - 1 do
      lBodyData.Add('');
    FData.Add(lBodyData);
  end;
end;

destructor TsmwSimpleTable.Destroy;
begin
  FTitles.Free;
  inherited;
end;

function TsmwSimpleTable.GetCell(const ARow, ACol: Integer): string;
var
  lBodyData: TBodyData;
begin
  lBodyData := FData[ARow];
  Result := lBodyData[ACol];
end;

function TsmwSimpleTable.GetTableClass: string;
begin
  if FTableClass <> '' then
    Result := ' ' + FTableClass
  else
    Result := FTableClass;
end;

procedure TsmwSimpleTable.SetCell(const ARow, ACol: Integer; const Value: string);
var
  lBodyData: TBodyData;
begin
  lBodyData := FData[ARow];
  lBodyData[ACol] := Value;
end;

function TsmwSimpleTable.Table: string;
var
  I: Integer;
  J: Integer;
  lBodyData: TBodyData;
begin
  Result := '<table class="smwtable' + GetTableClass + '">'#10;

  if FTitle <> '' then
    Result := Result + '<caption>' + FTitle + '</caption>'#10;

  if FTitles.Count > 0 then
  begin
    Result := Result + '<thead>'#10'<tr class="smwtitles">';
    for I := 0 to FCols - 1 do
    begin
      if (FTitles.Count >= I + 1) then
        Result := Result + '<th>' + FTitles[I] + '</th>'
      else
        Result := Result + '<th></th>';
    end;
    Result := Result + '</tr>'#10'</thead>'#10;
  end;

  Result := Result + '<tbody>'#10;

  for I := 0 to FRows - 1 do
  begin
    Result := Result + '<tr>';
    lBodyData := FData[I];
    for J := 0 to FCols - 1 do
    begin
      Result := Result + '<td>' + lBodyData[J] + '</td>';
    end;
    Result := Result + '</tr>'#10;
  end;

  Result := Result + '</tbody>'#10'</table>';
end;

end.
