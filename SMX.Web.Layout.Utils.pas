unit SMX.Web.Layout.Utils;

interface

uses
  System.SysUtils,
  Web,
  WebLib.Controls,
  WebLib.WebCtrls,
  WebLib.ExtCtrls;

type

  TLayoutUtils = class
  public
    /// <param name="AFontAwesomeClass">
    /// this is the 'fad fa-edit' part of '&lt;i class="fad fa-edit
    /// fa-lg"&gt;&lt;/i&gt;'
    /// </param>
    class function RowActionSpan(const AParentElement: TJSHTMLElement; const AFontAwesomeClass: string;
      const AToolTip: string = ' '; const HorizontalFlip: Boolean = False): TWebHTMLSpan;
  end;

implementation

{ TLayoutUtils }

class function TLayoutUtils.RowActionSpan(const AParentElement: TJSHTMLElement;
    const AFontAwesomeClass: string; const AToolTip: string = ' '; const
    HorizontalFlip: Boolean = False): TWebHTMLSpan;
var
  lFlip, lTip: string;
begin
  if AToolTip = '' then
     lTip := ''
  else
     lTip := format(' title="%s"', [AToolTip]);

  if HorizontalFlip then
    lFlip := ' fa-flip-horizontal'
  else
    lFlip := '';

  result := TWebHTMLSpan.Create(nil);
  result.Cursor := crHandPoint;
  result.ElementPosition := epIgnore;
  result.HeightStyle := ssAuto;
  result.WidthStyle := ssAuto;
  result.ParentElement := AParentElement;
  if AFontAwesomeClass.StartsWith('<') then
    result.HTML.Text := AFontAwesomeClass
  else
    result.HTML.Text := format('<i class="%s fa-fw fa-lg%s"%s></i> ', [AFontAwesomeClass, lFlip, lTip]);
end;

end.
