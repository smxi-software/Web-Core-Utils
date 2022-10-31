unit SMX.Web.FileSupport;

interface

Uses JS, SysUtils, Web, WebLib.Forms;

type

  TFileSupport = class
    class procedure SaveEncoded64File(const aFileName: string; const AData: string);
  end;

implementation

{ TFileSupport }

class procedure TFileSupport.SaveEncoded64File(const aFileName, AData: string);
var
  FileData: WideString;
  FileLen: Integer;
  I: Integer;
  AB: TJSArrayBuffer;
  AV: TJSUInt8Array;
begin
  try
    FileData := window.atob(AData);
    FileLen := Length(FileData);
  except
    on E: Exception do
    begin
      console.log('ERROR: (Base64) File could not be decoded');
      raise Exception.Create('ERROR: (Base64) File could not be decoded');
    end;
  end;

  if (FileLen <> -1) then
  begin
    console.log('Retrieved (Base64) File: ' + IntToStr(Length(AData)) + ' bytes');
    console.log('Decoded (Base64) File: ' + IntToStr(FileLen) + ' bytes');
  end;

  AB := TJSArrayBuffer.new(FileLen);
  AV := TJSUInt8Array.new(AB);
  for I := 0 to FileLen - 1 do
    AV[i] := TJSString(FileData).charCodeAt(i);
  Application.DownloadBinaryFile(AV, aFileName);

end;

end.
