unit SMX.Web.Document.Utils;

interface

uses
  System.Classes,
  System.SysUtils;

type

  TwebValidityState = (vsValid, vsInvalid, vsVoid, vsNone);

  TwebInputType = (witButton, witCheckbox, witColor, witDate, witDatetimeLocal, witEmail, witFile, witHidden, witImage,
    witMonth, witNumber, witPassword, witRadio, witRange, witReset, witSearch, witSubmit, witTel, witText, witTime,
    witUrl, witWeek);

  TDocUtils = class
  public

    class function stringsToUL(AStrings: TStrings; const AListClass: string = ''; AItemClass: string = ''): string;

    class procedure addClass(const aElementId: string; const AClassName: string);
    class procedure removeClass(const aElementId: string; const AClassName: string);
    class procedure setControlValidity(const aElementId: string; const aState: TwebValidityState);
    class procedure hideElement(const aElementId: string);
    class procedure showElement(const aElementId: string);

    class function elementHeight(const aElementId: string): integer;
    class function elementWidth(const aElementId: string): integer;
    class procedure writeHTML(const aElementId: string; const Value: string);
    class procedure loadHTML(const aElementId: string; const URL: string);
    class procedure appendHTML(const aElementId: string; const Value: string);
    class procedure emptyDiv(const aElementId: string);
    class function elementIdExists(const aElementId: string): Boolean;
    class procedure setInputType(const aElementId: string; const aInputType: TwebInputType);

    class function isCSSLinked(const aFileURL: string): Boolean;
    class procedure addCSSFile(const aFileURL: string);
    class function isScriptLinked(const aFileURL: string): Boolean;
    class procedure addScriptFile(const aFileURL: string);

  end;

const
Valid_Check: Array[Boolean] of  TwebValidityState = (vsInvalid, vsValid);

implementation

uses
  System.Rtti;

const

  validity_class_map: array [TwebValidityState] of string = ('is-valid', 'is-invalid', 'is-void', 'is-none');

  input_type_map: array [TwebInputType] of string = ('button', 'checkbox', 'color', 'date', 'datetime - local', 'email',
    'file', 'hidden', 'image', 'month', 'number', 'password', 'radio', 'range', 'reset', 'search', 'submit', 'tel',
    'text', 'time', 'url', 'week');

  { THTMLHelper }

class procedure TDocUtils.addClass(const aElementId, AClassName: string);
begin
  {$IFDEF PAS2JS}
  asm
    $("#" + aElementId).addClass(AClassName);
  end;
  {$ENDIF}
end;

class procedure TDocUtils.addCSSFile(const aFileURL: string);
begin
  if isCSSLinked(aFileURL) then
    Exit;

  {$IFDEF PAS2JS}
  asm
    var link = document.createElement('link');

    // set the attributes for link element
    link.rel = 'stylesheet';

    link.type = 'text/css';

    link.href = aFileURL;

    // Get HTML head element to append
    // link element to it
    document.getElementsByTagName('HEAD')[0].appendChild(link);
  end;
  {$ENDIF}
end;

class procedure TDocUtils.addScriptFile(const aFileURL: string);
begin
  if isScriptLinked(aFileURL) then
    Exit;

end;

class procedure TDocUtils.appendHTML(const aElementId, Value: string);
begin
  {$IFDEF PAS2JS}
  asm
    var Doc = document.getElementById(aElementId);
    if (Doc !== null) {
    Doc.innerHTML += Value;
     }
  end;
  {$ENDIF}
end;

class function TDocUtils.elementHeight(const aElementId: string): integer;
begin
  {$IFDEF PAS2JS}
  asm
    Result = parseInt($("#" + aElementId).height());
  end;
  {$ENDIF}
end;

class function TDocUtils.elementIdExists(const aElementId: string): Boolean;
begin
  {$IFDEF PAS2JS}
  asm
    return (document.getElementById("#" + aElementId) !== null);
  end;
  {$ENDIF}
end;

class function TDocUtils.elementWidth(const aElementId: string): integer;
begin
  {$IFDEF PAS2JS}
  asm
    Result = parseInt($("#" + aElementId).width());
  end;
  {$ENDIF}
end;

class procedure TDocUtils.emptyDiv(const aElementId: string);
begin
  {$IFDEF PAS2JS}
  asm
    var Doc = document.getElementById(aElementId);
    if (Doc !== null) {
    Doc.innerHTML = "";
     }
  end;
  {$ENDIF}
end;

class procedure TDocUtils.hideElement(const aElementId: string);
begin
  {$IFDEF PAS2JS}
  asm
    $("#" + aElementId).hide();
  end;
  {$ENDIF}
end;

class function TDocUtils.isCSSLinked(const aFileURL: string): Boolean;
begin
  {$IFDEF PAS2JS}
  asm
    var linkEl = document.head.querySelector('link[href*="' + aFileURL + '"]');
    return Boolean(linkEl.sheet);
  end;
  {$ENDIF}
end;

class function TDocUtils.isScriptLinked(const aFileURL: string): Boolean;
begin
  {$IFDEF PAS2JS}
  asm
    const found_in_resources = performance.getEntries()
    .filter(e => e.entryType === 'resource')
    .map(e => e.name)
    .indexOf(src) !== -1;
    const found_in_script_tags = document.querySelectorAll(`script[src*="${ src }"]`).length > 0;
    return found_in_resources || found_in_script_tags;
  end;
  {$ENDIF}
end;

class procedure TDocUtils.loadHTML(const aElementId, URL: string);
begin
  {$IFDEF PAS2JS}
  asm
    $("#" + aElementId).load(URL);
  end;
  {$ENDIF}
end;

class procedure TDocUtils.removeClass(const aElementId, AClassName: string);
begin
  {$IFDEF PAS2JS}
  asm
    $("#" + aElementId).removeClass(AClassName);
  end;
  {$ENDIF}
end;

class procedure TDocUtils.setControlValidity(const aElementId: string; const aState: TwebValidityState);
var
  lState: TwebValidityState;
begin
  for lState := low(TwebValidityState) to high(TwebValidityState) do
  begin
    if lState <> aState then
      removeClass(aElementId, validity_class_map[lState]);
  end;

  addClass(aElementId, validity_class_map[aState]);

end;

class procedure TDocUtils.setInputType(const aElementId: string; const aInputType: TwebInputType);
var
  lInputType: string;
begin
  lInputType := input_type_map[aInputType];
  {$IFDEF PAS2JS}
  asm
    const element = document.getElementById(aElementId);
    if (element.tagName.toLowerCase() === 'input') {
       Document.getElementById(aElementId).type = lInputType;
    };
  end;
  {$ENDIF}
end;

class procedure TDocUtils.showElement(const aElementId: string);
begin
  {$IFDEF PAS2JS}
  asm
    $("#" + aElementId).show();
  end;
  {$ENDIF}
end;

class function TDocUtils.stringsToUL(AStrings: TStrings; const AListClass: string = '';
  AItemClass: string = ''): string;
var
  I: integer;
  lClass: string;
begin
  Result := '';

  if AItemClass <> '' then
    lClass := format(' class="%s">', [AItemClass])
  else
    lClass := '>';

  for I := 0 to AStrings.Count - 1 do
    Result := Result + '<li' + lClass + AStrings[I] + '</li>';

  if AListClass <> '' then
    lClass := format(' class="%s">', [AListClass])
  else
    lClass := '>';

  Result := '<ul' + lClass + Result + '</ul>';
end;

class procedure TDocUtils.writeHTML(const aElementId, Value: string);
begin
  {$IFDEF PAS2JS}
  asm
    $("#" + aElementId).html(Value);
  end;
  {$ENDIF}
end;

end.
