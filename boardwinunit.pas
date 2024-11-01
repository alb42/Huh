unit boardwinunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mui, configvars, Utility, Math,
  identifylib, muihelper,
  MUIClass.Window,
  MUIClass.Area, MUIClass.Group, MUIClass.StringGrid;

type
  TBoard = class
    Config: PConfigDev;
    Manu: string;
    Prod: string;
    ExpClass: string;
  end;

  { TBoardsWin }

  TBoardsWin = class(TMUIWindow)
  private
    FList: TList;
    BoardList: TMUIStringGrid;
    ConfigText, ManuText, ProdText, ClassText,
    BAddText, SlotText, SerialText, DriverText: TMUIText;
    procedure ClearList;
    procedure RedoList;
    procedure SelectChange(Sender: TObject);
  public
    constructor Create; override;
    destructor Destroy; override;

  end;

var
  BoardsWin: TBoardsWin;

implementation

function FormatBytes(ABytes: LongWord): string;
var
  f: Single;
begin
  if ABytes > 1024 then
  begin
    f := ABytes / 1024;
    if f > 1024 then
    begin
      f := f / 1024;
      if f > 1024 then
      begin
        f := f / 1024;
        Result := FloatToStrF(f, ffFixed, 8,1) + ' GByte';
      end
      else
        Result := FloatToStrF(f, ffFixed, 8,1) + ' MByte';
    end
    else
      Result := FloatToStrF(f, ffFixed, 8,1) + ' kByte';
  end
  else
  begin
    Result := IntToStr(ABytes) + ' Byte';
  end;

end;


{ TBoardsWin }

procedure TBoardsWin.ClearList;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    TObject(FList[i]).Free;
  FList.Clear;
  BoardList.NumRows := 0;
  SelectChange(nil);
end;

procedure TBoardsWin.RedoList;
var
  Expans: PConfigDev;
  Manuf, Prod, EClass: PChar;
  NB: TBoard;
  i: Integer;
begin
  ClearList;
  Expans := nil;
  Manuf := AllocMem(128);
  Prod := AllocMem(128);
  EClass := AllocMem(128);
  while (IdExpansionTags([
    IDTAG_ManufStr, AsTag(Manuf),
    IDTAG_ProdStr, AsTag(Prod),
    IDTAG_ClassStr, AsTag(EClass),
    IDTAG_Expansion, AsTag(@Expans),
    IDTAG_StrLength, 127,
    TAG_END]) = 0) do
  begin
    NB := TBoard.Create;
    NB.Config := Expans;
    NB.Manu := Manuf;
    NB.Prod := Prod;
    NB.ExpClass := EClass;
    FList.Add(NB);
    //writeln(NB.Manu, ';', NB.Prod,';',NB.ExpClass);
  end;

  BoardList.Quiet := True;
  BoardList.NumRows := FList.Count;
  BoardList.NumColumns := 2;
  BoardList.ShowLines := True;
  for i := 0 to FList.Count - 1 do
  begin
    NB := TBoard(FList[i]);
    BoardList.Cells[0, i] := IntToStr(i + 1);
    BoardList.Cells[1, i] := NB.Prod;
  end;
  FreeMem(Manuf);
  FreeMem(Prod);
  FreeMem(EClass);
end;

procedure TBoardsWin.SelectChange(Sender: TObject);
var
  Idx: Integer;
  NB: TBoard;
begin
  Idx := BoardList.Row;
  if InRange(Idx, 0, FList.Count - 1) then
  begin
    NB := TBoard(FList[Idx]);
    ConfigText.Contents := '$' + HexStr(NB.Config);
    ManuText.Contents := NB.Manu;
    ProdText.Contents := NB.Prod;
    ClassText.Contents := NB.ExpClass;
    SerialText.Contents := IntToStr(NB.Config^.cd_Rom.er_SerialNumber);
    BAddText.Contents := '$' + HexStr(NB.Config^.cd_BoardAddr) + ' Len: ' + FormatBytes(NB.Config^.cd_BoardSize);
    SlotText.Contents := '$' + HexStr(NB.Config^.cd_SlotAddr, 4) + ' Num: ' + FormatBytes(NB.Config^.cd_SlotSize);
    DriverText.Contents := '$' + HexStr(NB.Config^.cd_Driver);
  end
  else
  begin
    ConfigText.Contents := '$' + HexStr(nil);
    ManuText.Contents := '';
    ProdText.Contents := '';
    ClassText.Contents := '';
    SerialText.Contents := '';
    BAddText.Contents := '';
    SlotText.Contents := '';
    DriverText.Contents := '';
  end;
end;

constructor TBoardsWin.Create;
var
  Grp: TMUIGroup;

begin
  inherited Create;

  Title := 'Boards Information';
  ScreenTitle := 'Huh? - Boards Information';
  ID := Make_ID('B','O','R','D');

  FList := TList.Create;

  Horizontal := True;

  BoardList := TMUIStringGrid.Create;
  BoardList.Horiz := True;
  BoardList.Columns := 1;
  BoardList.OnClick := @SelectChange;
  BoardList.Parent := Self;

  Grp := TMUIGroup.Create;
  Grp.Frame := MUIV_Frame_None;
  Grp.Parent:= Self;
  Grp.Weight := 200;
  Grp.Columns := 2;

  with TMUIText.Create('Current ConfigDev') do
  begin
    FixWidthTxt := 'Current ConfigDev';
    Parent := Grp;
  end;
  ConfigText := TMUIText.Create('$00000000');
  ConfigText.Frame := MUIV_Frame_Text;
  ConfigText.Weight := 200;
  ConfigText.Parent := Grp;

  TMUIText.Create('Manufacturer').Parent := Grp;
  ManuText := TMUIText.Create(StringOfChar(' ', 50));
  ManuText.Frame := MUIV_Frame_Text;
  ManuText.Parent := Grp;

  TMUIText.Create('Product').Parent := Grp;
  ProdText := TMUIText.Create(StringOfChar(' ', 50));
  ProdText.Frame := MUIV_Frame_Text;
  ProdText.Parent := Grp;

  TMUIText.Create('Expansion Class').Parent := Grp;
  ClassText := TMUIText.Create(StringOfChar(' ', 50));
  ClassText.Frame := MUIV_Frame_Text;
  ClassText.Parent := Grp;

  TMUIText.Create('Serial').Parent := Grp;
  SerialText := TMUIText.Create(StringOfChar(' ', 50));
  SerialText.Frame := MUIV_Frame_Text;
  SerialText.Parent := Grp;

  TMUIText.Create('Board Address').Parent := Grp;
  BAddText := TMUIText.Create(StringOfChar(' ', 60));
  BAddText.Frame := MUIV_Frame_Text;
  BAddText.Parent := Grp;

  TMUIText.Create('Slot Address').Parent := Grp;
  SlotText := TMUIText.Create(StringOfChar(' ', 60));
  SlotText.Frame := MUIV_Frame_Text;
  SlotText.Parent := Grp;

  TMUIText.Create('Driver Address').Parent := Grp;
  DriverText := TMUIText.Create(StringOfChar(' ', 60));
  DriverText.Frame := MUIV_Frame_Text;
  DriverText.Parent := Grp;


  TMUIRectangle.Create.Parent := Grp;
  TMUIRectangle.Create.Parent := Grp;

  RedoList;

end;

destructor TBoardsWin.Destroy;
begin
  ClearList;
  FList.Free;
  inherited Destroy;
end;

end.

