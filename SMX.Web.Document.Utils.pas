{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
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
  asm
    $("#" + aElementId).addClass(AClassName);
  end;
end;

class procedure TDocUtils.addCSSFile(const aFileURL: string);
begin
  if isCSSLinked(aFileURL) then
    Exit;

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
end;

class procedure TDocUtils.addScriptFile(const aFileURL: string);
begin
  if isScriptLinked(aFileURL) then
    Exit;

end;

class procedure TDocUtils.appendHTML(const aElementId, Value: string);
begin
  asm
    var Doc = document.getElementById(aElementId);
    if (Doc !== null) {
    Doc.innerHTML += Value;
     }
  end;
end;

class function TDocUtils.elementHeight(const aElementId: string): integer;
begin
  asm
    Result = parseInt($("#" + aElementId).height());
  end;
end;

class function TDocUtils.elementIdExists(const aElementId: string): Boolean;
begin
  asm
    return (document.getElementById("#" + aElementId) !== null);
  end;
end;

class function TDocUtils.elementWidth(const aElementId: string): integer;
begin
  asm
    Result = parseInt($("#" + aElementId).width());
  end;
end;

class procedure TDocUtils.emptyDiv(const aElementId: string);
begin
  asm
    var Doc = document.getElementById(aElementId);
    if (Doc !== null) {
    Doc.innerHTML = "";
     }
  end;
end;

class procedure TDocUtils.hideElement(const aElementId: string);
begin
  asm
    $("#" + aElementId).hide();
  end;
end;

class function TDocUtils.isCSSLinked(const aFileURL: string): Boolean;
begin
  asm
    var linkEl = document.head.querySelector('link[href*="' + aFileURL + '"]');
    return Boolean(linkEl.sheet);
  end;
end;

class function TDocUtils.isScriptLinked(const aFileURL: string): Boolean;
begin
  asm
    const found_in_resources = performance.getEntries()
    .filter(e => e.entryType === 'resource')
    .map(e => e.name)
    .indexOf(src) !== -1;
    const found_in_script_tags = document.querySelectorAll(`script[src*="${ src }"]`).length > 0;
    return found_in_resources || found_in_script_tags;
  end;
end;

class procedure TDocUtils.loadHTML(const aElementId, URL: string);
begin
  asm
    $("#" + aElementId).load(URL);
  end;
end;

class procedure TDocUtils.removeClass(const aElementId, AClassName: string);
begin
  asm
    $("#" + aElementId).removeClass(AClassName);
  end;
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
  asm
    const element = document.getElementById(aElementId);
    if (element.tagName.toLowerCase() === 'input') {
       Document.getElementById(aElementId).type = lInputType;
    };
  end;
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
  asm
    $("#" + aElementId).html(Value);
  end;
end;

end.
