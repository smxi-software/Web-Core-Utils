unit SMX.Web.Table.Simple;

interface

uses
  System.Generics.Collections,
  System.Classes,
  System.SysUtils;

type

   TCellData = class
   Data: string;
   ClassNames: string;
   end;

  TRowData = class(TObjectList<TCellData>);
  TBodyData = class(TObjectList<TRowData>);

  //TBodyData = class(TList<string>);

  //FData holds a list of Rows so FData[0] is the first body row of the table
  //so FData[0] returns a TRowData object which is a list of TCellData so FData[0][0] returns the top left cell

  TsmwSimpleTable = class
  private
    FTableClass: string;
    FTableId: string;
    FCols: Integer;
    FRows: Integer;
    FData: TBodyData;
    FTitles: TStrings;
    FTitle: string;
    function GetTableClass: string;
    function GetTableId: string;
    function GetCell(const ARow, ACol: Integer): string;
    procedure SetCell(const ARow, ACol: Integer; const Value: string);
  public
    constructor Create(const ARows, ACols: Integer; const ATableId, ATableClass: string);
    destructor Destroy; override;
    function Table: string;
    procedure AddCell(const ARow, ACol: Integer; const AData: string; const AClassNames: string = '');
    property Titles: TStrings read FTitles;
    property Title: string read FTitle write FTitle;
    property Cell[const ARow, ACol: Integer]: string read GetCell write SetCell;
  end;

implementation

uses system.StrUtils;

{ TsmwSimpleTable }

procedure TsmwSimpleTable.AddCell(const ARow, ACol: Integer; const AData:
    string; const AClassNames: string = '');
var
  Index: Integer;
  lBodyData: TRowData;
begin
  lBodyData := FData[ARow];
  lBodyData[ACol].Data := AData;
  lBodyData[ACol].ClassNames := IfThen(AClassNames <> '', ' ') + AClassNames;
end;

constructor TsmwSimpleTable.Create(const ARows, ACols: Integer; const ATableId, ATableClass: string);
var
  I, J: Integer;
  lBodyData: TBodyData;
  lRowData: TRowData;
begin
  FRows := ARows;
  FCols := ACols;
  FTableClass := ATableClass;
  FTableId := ATableId;
  FTitles := TStringList.Create;
  FData := TBodyData.Create(True);
  for I := 0 to FRows - 1 do
  begin
    lRowData := TRowData.Create(True);
    for J := 0 to FCols - 1 do
      lRowData.Add(TCellData.Create);
    FData.Add(lRowData);
  end;
end;

destructor TsmwSimpleTable.Destroy;
begin
  FTitles.Free;
  FData.Free;
  inherited;
end;

function TsmwSimpleTable.GetCell(const ARow, ACol: Integer): string;
var
  lRowData: TRowData;
begin
  lRowData := FData[ARow];
  Result := lRowData[ACol].Data;
end;

function TsmwSimpleTable.GetTableClass: string;
begin
  if FTableClass <> '' then
    Result := ' ' + FTableClass
  else
    Result := '';
end;

function TsmwSimpleTable.GetTableId: string;
begin
  if FTableId <> '' then
    Result := ' id="' + FTableId + '"'
  else
    Result := '';
end;

procedure TsmwSimpleTable.SetCell(const ARow, ACol: Integer; const Value: string);
var
  lRowData: TRowData;
begin
  lRowData := FData[ARow];
  lRowData[ACol].Data := Value;
end;

function TsmwSimpleTable.Table: string;
var
  I: Integer;
  J: Integer;
  lRowData: TRowData;
begin
  Result := '<table' + GetTableId + ' class="smwtable' + GetTableClass + '">'#10;

  if FTitle <> '' then
    Result := Result + '<caption>' + FTitle + '</caption>'#10;

  if FTitles.Count > 0 then
  begin
    Result := Result + '<thead>'#10'<tr class="smwtitles">';
    for I := 0 to FCols - 1 do
    begin
      if (FTitles.Count >= I + 1) then
        Result := Result + format('<th class="th-col-%d">%s</th>', [I, FTitles[I]])
      else
        Result := Result + '<th></th>';
    end;
    Result := Result + '</tr>'#10'</thead>'#10;
  end;

  Result := Result + '<tbody>'#10;

  for I := 0 to FRows - 1 do
  begin
    Result := Result + '<tr>';
    lRowData := FData[I];
    for J := 0 to FCols - 1 do
    begin
      Result := Result + format('<td class="td-col-%d%s">%s</td>', [J, lRowData[J].ClassNames, lRowData[J].Data]);
    end;
    Result := Result + '</tr>'#10;
  end;

  Result := Result + '</tbody>'#10'</table>';
end;

end.
