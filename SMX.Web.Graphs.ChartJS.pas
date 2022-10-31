unit SMX.Web.Graphs.ChartJS;


//https://www.tmssoftware.com/site/blog.asp?post=982

interface

uses SMX.Web.Graphs.Base;

Type

TsmwChartJS = class(TsmwGraphBase)

public
  constructor Create;
end;

implementation

{ TsmwChartJS }

constructor TsmwChartJS.Create;
begin
  inherited Create;
  RequiredJSLibs.Add('https://cdn.jsdelivr.net/npm/chart.js@3/dist/chart.min.js');

end;

end.
