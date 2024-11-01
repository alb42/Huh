unit generalwinunit;

{$mode ObjFPC}{$H+}

interface

uses
  identifylib, mui, muihelper, EXEC,
  Classes, SysUtils, utility,
  MUIClass.Window, MUIClass.StringGrid;

type

  { TGeneralWin }

  TGeneralWin = class(TMUIWindow)
    List: TMUIStringGrid;
  public
    constructor Create; override;

    procedure Execute;
  end;

var
  GeneralWin: TGeneralWin;

implementation


const
  Names: array of string = (
    'System',  //0
    'CPU',
    'FPU',
    'MMU',
    'OS Version',
    'Exec Version', // 5
    'Workbench Version',
    'ROM Size',
    'Chipset',
    'Graphic System',
    'Chip RAM',    // 10
    'Fast RAM',
    'Total RAM',
    'SetPatch Version',
    'Audio System',
    'Amiga OS',
    'VMM Chip RAM',
    'VMM Fast RAM',
    'VMM Total RAM',
    'Non Virtual Chip RAM',
    'Non Virtual Fast RAM',   // 20
    'Non Virtual Total RAM',
    'VBR Base',
    'Last Alert',
    'VBlank Frequency',
    'Power Frequency',
    'System E Clock',
    'Slow RAM',
    'Gary Revision',
    'Ramsey Revision',
    'Battery Clock',            // 30
    'Chunky to Planar Hardware',
    'PowerPC',
    'PowerPC Frequency',
    'CPU Revision',
    'CPU Frequency',
    'FPU Frequency',
    'RAM Access Timing',
    'Mainboard RAM Width',
    'Mainboard RAM CAS',
    'MainBoard RAM BandWidth',  // 40
    'TCP/IP Stack',
    'PowerPC OS',
    'Agnus Type and Revision',
    'Agnus Mode',
    'Denise Version',
    'Denise Revision',
    'Boing Bag',
    'Emulated',
    'Amiga XL Version',
    'Host OS',             // 50
    'Host OS Version',
    'Host Machine',
    'Host CPU',
    'Host Speed',
    'Last Alert Task',
    'Paula Type',
    'ROM Version',
    'RTC present',
    'Number of Types');

{ TGeneralWin }

constructor TGeneralWin.Create;
begin
  inherited Create;

  Title := 'General Information';
  ScreenTitle := 'Huh? - General Information';
  ID := Make_ID('G','N','R','L');

  List := TMUIStringGrid.Create;
  List.NumColumns := 2;
  List.NumRows := 0;
  List.ShowLines := True;
  List.ShowTitle := False;
  List.Parent := Self;

  Width := MUIV_Window_Width_Screen(50);
  Height := MUIV_Window_Height_Screen(80);
end;

procedure TGeneralWin.Execute;
var
  str: STRPTR;
  Idx, i: Integer;
begin
  List.Quiet := True;
  List.NumRows := Length(Names);
  Idx := 0;
  for i := 0 to High(Names) do
  begin
    List.Cells[0, i] := '';
    List.Cells[1, i] := '';
    str := IdHardwareTags(i, [IDTAG_NULL4NA, AsTag(False)]);
    if Assigned(Str) then
    begin
      List.Cells[0, Idx] := Names[i];
      List.Cells[1, Idx] := str;
      Inc(Idx);
    end;
  end;
  List.NumRows := Idx;
  List.Quiet := False;
  Show;
  ToFront;
end;

end.

