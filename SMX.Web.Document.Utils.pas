Unit SMX.Web.Document.Utils;

Interface

Uses
  System.Classes,
  System.SysUtils;

Type

  TwebValidityState = (vsValid, vsInvalid, vsVoid, vsNone);

  TwebInputType = (witButton, witCheckbox, witColor, witDate, witDatetimeLocal, witEmail, witFile, witHidden, witImage,
    witMonth, witNumber, witPassword, witRadio, witRange, witReset, witSearch, witSubmit, witTel, witText, witTime,
    witUrl, witWeek);

  TwebTextTransform = (ttNone, ttUppercase, ttLowercase, ttCapitalize, ttFullWidth, ttInherit, ttInitial, ttUnset);

  TDocUtils = Class
  Public

    Class Function stringsToUL(AStrings: TStrings; Const AListClass: String = ''; AItemClass: String = ''): String;

    Class Procedure addClass(Const aElementId: String; Const AClassName: String);
    Class Procedure removeClass(Const aElementId: String; Const AClassName: String);
    Class Procedure setControlValidity(Const aElementId: String; Const aState: TwebValidityState);
    Class Procedure hideElement(Const aElementId: String);
    Class Procedure showElement(Const aElementId: String);

    Class Procedure setTextTransform(Const aElementId: String; Const transformStyle: TwebTextTransform);

    Class Function elementHeight(Const aElementId: String): integer;
    Class Function elementWidth(Const aElementId: String): integer;
    Class Procedure writeHTML(Const aElementId: String; Const Value: String);
    Class Procedure loadHTML(Const aElementId: String; Const URL: String);
    Class Procedure appendHTML(Const aElementId: String; Const Value: String);
    Class Procedure emptyDiv(Const aElementId: String);
    Class Function elementIdExists(Const aElementId: String): Boolean;
    Class Procedure setInputType(Const aElementId: String; Const aInputType: TwebInputType);

    Class Function isCSSLinked(Const aFileURL: String): Boolean;
    /// <summary>
    /// The TMS WebCore Application object now has InsertCSS and RemoveCSS,
    /// so probably better to move to that
    /// </summary>
    Class Procedure addCSSFile(Const aFileURL: String);

    Class Function isScriptLinked(Const aFileURL: String): Boolean;
    Class Procedure addScriptFile(Const aFileURL: String);

    Class Procedure writeImageSrc(Const aElementId, aImageURL: String);
    Class Procedure pushState(Const AURL: String; Const ATitle: String = 'unused'; Const aState: String = '{}');
    // '{}');
    Class Procedure replaceState(Const AURL: String; Const ATitle: String = 'unused'; Const aState: String = '{}');
    // '{}');
  End;

Const
  Valid_Check: Array [Boolean] Of TwebValidityState = (vsInvalid, vsValid);
  Alt_Valid_Check: Array [Boolean] Of TwebValidityState = (vsInvalid, vsNone);

Implementation

Uses
  System.Rtti,
  WebLib.Forms;

Const

  validity_class_map: Array [TwebValidityState] Of String = ('is-valid', 'is-invalid', 'is-void', 'is-none');

  input_type_map: Array [TwebInputType] Of String = ('button', 'checkbox', 'color', 'date', 'datetime - local', 'email',
    'file', 'hidden', 'image', 'month', 'number', 'password', 'radio', 'range', 'reset', 'search', 'submit', 'tel',
    'text', 'time', 'url', 'week');

  transform_type_map: Array [TwebTextTransform] Of String = ('none', 'uppercase', 'lowercase', 'capitalize',
    'full-width', 'inherit', 'initial', 'unset');

{$HINTS OFF}

Class Procedure TDocUtils.addClass(Const aElementId, AClassName: String);
Begin
{$IFDEF PAS2JS}
  asm
    $("#" + aElementId).addClass(AClassName);
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.addCSSFile(Const aFileURL: String);
Begin
  If isCSSLinked(aFileURL) Then
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
End;

Class Procedure TDocUtils.addScriptFile(Const aFileURL: String);
Begin
  If isScriptLinked(aFileURL) Then
    Exit;

End;

Class Procedure TDocUtils.appendHTML(Const aElementId, Value: String);
Begin
{$IFDEF PAS2JS}
  asm
    var Doc = document.getElementById(aElementId);
    if (Doc !== null) {
    Doc.innerHTML += Value;
     }
  end;
{$ENDIF}
End;

Class Function TDocUtils.elementHeight(Const aElementId: String): integer;
Begin
{$IFDEF PAS2JS}
  asm
    Result = parseInt($("#" + aElementId).height());
  end;
{$ENDIF}
End;

Class Function TDocUtils.elementIdExists(Const aElementId: String): Boolean;
Begin
{$IFDEF PAS2JS}
  asm
    return (document.getElementById("#" + aElementId) !== null);
  end;
{$ENDIF}
End;

Class Function TDocUtils.elementWidth(Const aElementId: String): integer;
Begin
{$IFDEF PAS2JS}
  asm
    Result = parseInt($("#" + aElementId).width());
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.emptyDiv(Const aElementId: String);
Begin
{$IFDEF PAS2JS}
  asm
    var Doc = document.getElementById(aElementId);
    if (Doc !== null) {
    Doc.innerHTML = "";
     }
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.hideElement(Const aElementId: String);
Begin
{$IFDEF PAS2JS}
  asm
    $("#" + aElementId).hide();
  end;
{$ENDIF}
End;

Class Function TDocUtils.isCSSLinked(Const aFileURL: String): Boolean;
Begin
{$IFDEF PAS2JS}
  asm
    var linkEl = document.head.querySelector('link[href*="' + aFileURL + '"]');
    return Boolean(linkEl.sheet);
  end;
{$ENDIF}
End;

Class Function TDocUtils.isScriptLinked(Const aFileURL: String): Boolean;
Begin
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
End;

Class Procedure TDocUtils.loadHTML(Const aElementId, URL: String);
Begin
{$IFDEF PAS2JS}
  asm
    $("#" + aElementId).load(URL);
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.pushState(Const AURL: String; Const ATitle: String; Const aState: String); // '{}');
Begin
{$IFDEF PAS2JS}
  asm
    history.pushState(aState, ATitle, AURL);
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.removeClass(Const aElementId, AClassName: String);
Begin
{$IFDEF PAS2JS}
  asm
    $("#" + aElementId).removeClass(AClassName);
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.replaceState(Const AURL: String; Const ATitle: String; Const aState: String);
Begin
{$IFDEF PAS2JS}
  asm
    history.replaceState(aState, ATitle, AURL);
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.setControlValidity(Const aElementId: String; Const aState: TwebValidityState);
Var
  lState: TwebValidityState;
Begin
  For lState := Low(TwebValidityState) To High(TwebValidityState) Do
  Begin
    If lState <> aState Then
      removeClass(aElementId, validity_class_map[lState]);
  End;

  If aState <> TwebValidityState.vsNone Then
    addClass(aElementId, validity_class_map[aState]);

End;

Class Procedure TDocUtils.setInputType(Const aElementId: String; Const aInputType: TwebInputType);
Var
  lInputType: String;
Begin
  lInputType := input_type_map[aInputType];
{$IFDEF PAS2JS}
  asm
    const element = document.getElementById(aElementId);
    if (element.tagName.toLowerCase() === 'input') {
    Document.getElementById(aElementId).type = lInputType;
     };
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.setTextTransform(Const aElementId: String; Const transformStyle: TwebTextTransform);
Var
  lStyle: String;
Begin
  lStyle := transform_type_map[transformStyle];
{$IFDEF PAS2JS}
  asm
    const element = document.getElementById(aElementId);

    if (element.style.textTransform !== lStyle) {
    element.style.textTransform = lStyle;
     };
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.showElement(Const aElementId: String);
Begin
{$IFDEF PAS2JS}
  asm
    $("#" + aElementId).show();
  end;
{$ENDIF}
End;

Class Function TDocUtils.stringsToUL(AStrings: TStrings; Const AListClass: String = '';
  AItemClass: String = ''): String;
Var
  I: integer;
  lClass: String;
Begin
  Result := '';

  If AItemClass <> '' Then
    lClass := format(' class="%s">', [AItemClass])
  Else
    lClass := '>';

  For I := 0 To AStrings.Count - 1 Do
    Result := Result + '<li' + lClass + AStrings[I] + '</li>';

  If AListClass <> '' Then
    lClass := format(' class="%s">', [AListClass])
  Else
    lClass := '>';

  Result := '<ul' + lClass + Result + '</ul>';
End;

Class Procedure TDocUtils.writeHTML(Const aElementId, Value: String);
Begin
{$IFDEF PAS2JS}
  asm
    $("#" + aElementId).html(Value);
  end;
{$ENDIF}
End;

Class Procedure TDocUtils.writeImageSrc(Const aElementId, aImageURL: String);
Begin
{$IFDEF PAS2JS}
  asm
    var img
    $("#" + aElementId).attr("src", aImageURL);
  end;
{$ENDIF}
End;

{$HINTS ON}

End.
