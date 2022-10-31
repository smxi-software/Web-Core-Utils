program Graphs;

uses
  Vcl.Forms,
  WEBLib.Forms,
  Webcore.Graph in 'Webcore.Graph.pas' {Form1: TWebForm} {*.html},
  SMX.Web.FileSupport in '..\..\SMX.Web.FileSupport.pas',
  SMX.Web.ThirdParty.Base in '..\..\SMX.Web.ThirdParty.Base.pas',
  SMX.Web.Graphs.Base in '..\..\SMX.Web.Graphs.Base.pas',
  SMX.Web.Document.Utils in '..\..\SMX.Web.Document.Utils.pas',
  SMX.Web.Graphs.ChartJS in '..\..\SMX.Web.Graphs.ChartJS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
