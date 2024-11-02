unit ScreenShotWinUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  Mui, muihelper, EXEC, identifylib,
  MUIClass.Window, MUIClass.StringGrid, MUIClass.Area, MUIClass.Group;

type

  { TScreenShotWindow }

  TScreenShotWindow = class(TMUIWindow)
  private
  public
    constructor Create; override;
  end;

var
  ScreenShotWin: TScreenShotWindow;

implementation

uses
  boardwinunit;

{ TScreenShotWindow }

constructor TScreenShotWindow.Create;
var
  s: STRPTR;
  Info: String;
  BoardList: TMUIStringGrid;
  Board: TBoard;
  i: Integer;
begin
  inherited Create;

  Title := 'Overview';
  ScreenTitle := 'Huh - Overview';

  Horizontal := False;

  s := IdHardware(IDHW_SYSTEM, nil);
  Info := string(s);
  s := IdHardware(IDHW_CPU, nil);
  Info := Info + ' CPU: ' + string(s);
  s := IdHardware(IDHW_CHIPSET, nil);
  Info := Info + ' Chipset: ' + string(s);
  s := IdHardware(IDHW_OSNR, nil);
  Info := Info + ' OS: ' + string(s);
  s := IdHardware(IDHW_CHIPRAM, nil);
  Info := Info + ' Chip:' + string(s);
  s := IdHardware(IDHW_FASTRAM, nil);
  Info := Info + ' Fast:' + string(s);

  with TMUIText.Create(Info) do
  begin
    Frame := MUIV_Frame_Text;
    Parent := Self;
  end;

  BoardList := TMUIStringGrid.Create;
  BoardList.NumColumns := 5;
  BoardList.NumRows := BoardsWin.BoardCount;
  BoardList.ShowTitle := True;
  BoardList.Titles[0] := MUIX_B + 'Nr.';
  BoardList.Titles[1] := MUIX_B + 'Manufacturer';
  BoardList.Titles[2] := MUIX_B + 'Product';
  BoardList.Titles[3] := MUIX_B + 'ID''s';
  BoardList.Titles[4] := MUIX_B + 'Size';

  for i := 0 to BoardsWin.BoardCount - 1 do
  begin
    Board := BoardsWin.Board[i];
    BoardList.Cells[0, i] := IntToStr(i + 1);
    BoardList.Cells[1, i] := Board.Manu + '   ';
    BoardList.Cells[2, i] := Board.Prod + '   ';
    BoardList.Cells[3, i] := '  $' + IntToHex(Board.Config^.cd_Rom.er_Manufacturer, 4) + ',$' + IntToHex(Board.Config^.cd_Rom.er_Product ,2);
    BoardList.Cells[4, i] := '  ' + FormatBytes(Board.Config^.cd_BoardSize);
  end;

  BoardList.Parent := Self;


  Info := 'identify.library ' + IntToStr(IdentifyBase^.lib_Version) + '.' + IntToStr(IdentifyBase^.lib_Revision);
  with TMUIText.Create(Info) do
  begin
    Frame := MUIV_Frame_Text;
    Parent := Self;
  end;



end;

end.

