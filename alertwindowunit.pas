unit alertwindowunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, identifylib, utility, mui, muihelper,
  MUIClass.Window, MUIClass.Area, MUIClass.Gadget, MUIClass.Dialog, MUIClass.Group;

type

  { TAlertWindow }

  TAlertWindow = class(TMUIWindow)
  private
    Input: TMUIString;
    TypeText, SubText, GeneralText, SpecText: TMUIText;
    procedure AlertEntered(Sender: TObject);
  public
    constructor Create; override;
  end;

var
  AlertWindow: TAlertWindow;

implementation


{ TAlertWindow }

procedure TAlertWindow.AlertEntered(Sender: TObject);
const
  BufSize = 127;
var
  AlertNum: Cardinal;
  s: array[0..3] of PChar;
  i: Integer;
  Err: LongInt;
begin
  // Read the inserted number
  if not TryStrToUInt('$' + Input.Contents, AlertNum) then
  begin
    ShowMessage('Error: "' + Input.Contents + '" is not a alert number');
    Exit;
  end;
  // get some memory
  for i := 0 to 3 do
    s[i] := AllocMem(BufSize + 1);
  // get the meaning
  Err := IdAlertTags(AlertNum, [
    IDTAG_DeadStr, AsTag(s[0]),
    IDTAG_SubsysStr, AsTag(s[1]),
    IDTAG_GeneralStr, AsTag(s[2]),
    IDTAG_SpecStr, AsTag(s[3]),
    IDTAG_StrLength, BufSize,
    TAG_END
    ]);
  // decode that
  if Err = 0 then
  begin // successful decoded
    TypeText.Contents := s[0];
    SubText.Contents := s[1];
    GeneralText.Contents := s[2];
    SpecText.Contents := s[3];
  end
  else
  begin  // error occured on decode (how can that happen?)
    TypeText.Contents := '';
    SubText.Contents := '';
    GeneralText.Contents := '';
    SpecText.Contents := '';
    ShowMessage('Error decode Alert ' + IntToHex(AlertNum) + ' Error: ' + IntToStr(Err));
  end;
  // free all
  for i := 0 to 3 do
    FreeMem(s[i]);
end;

constructor TAlertWindow.Create;
var
  Grp: TMUIGroup;
begin
  inherited Create;
  //
  Title := 'Alert Information';
  ScreenTitle := 'Huh? - Alert Information';
  ID := Make_ID('A','L','R','T');
  //
  Input := TMUIString.Create;
  Input.Accept := '0123456789abcdefABCDEF';
  Input.MaxLen := 8;
  Input.Contents := '80000000';
  Input.OnAcknowledge  := @AlertEntered;
  Input.Parent := Self;
  //
  Grp := TMUIGroup.Create;
  Grp.Columns := 2;
  Grp.FrameTitle := 'Alert Decode';
  Grp.Parent := Self;

  TMUIText.Create('Type: ').Parent := Grp;

  TypeText := TMUIText.Create();
  TypeText.Contents := StringOfChar(' ', 50);
  TypeText.Parent := Grp;

  TMUIText.Create('Subsystem: ').Parent := Grp;

  SubText := TMUIText.Create();
  SubText.Parent := Grp;

  TMUIText.Create('General cause: ').Parent := Grp;

  GeneralText := TMUIText.Create();
  GeneralText.Parent := Grp;

  TMUIText.Create('Specified cause: ').Parent := Grp;

  SpecText := TMUIText.Create();
  SpecText.Parent := Grp;

end;

end.

