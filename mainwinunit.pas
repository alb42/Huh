unit mainwinunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  identifylib,
  alertwindowunit, boardwinunit, generalwinunit, ScreenShotWinUnit,
  MUIClass.Window, MUIClass.Group, MUIClass.Area;

type

  { TMainWindow }

  TMainWindow = class(TMUIWindow)
  private
    procedure AlertClick(Sender: TObject);
    procedure BoardClick(Sender: TObject);
    procedure GeneralClick(Sender: TObject);
    procedure ScreenShotClick(Sender: TObject);
  public
    constructor Create; override;
  end;

implementation

{ TMainWindow }

procedure TMainWindow.AlertClick(Sender: TObject);
begin
  AlertWindow.Show;
  AlertWindow.ToFront;
end;

procedure TMainWindow.BoardClick(Sender: TObject);
begin
  BoardsWin.Show;
  BoardsWin.ToFront;
end;

procedure TMainWindow.GeneralClick(Sender: TObject);
begin
  GeneralWin.Execute;
end;

procedure TMainWindow.ScreenShotClick(Sender: TObject);
begin
  ScreenShotWin.Show;
  ScreenShotWin.ToFront;
end;

constructor TMainWindow.Create;
var
  Grp: TMUIGroup;
begin
  inherited Create;

  Title := 'Huh?';
  ScreenTitle := 'Huh?';

  Grp := TMUIGroup.Create;
  Grp.Parent := Self;

  TMUIText.Create('Huh? identify.library Version ' + IntToStr(identifylib.IdentifyBase^.lib_Version) + '.' + IntToStr(identifylib.IdentifyBase^.lib_Revision)).Parent := Grp;


  with TMUIButton.Create('Overview') do
  begin
    OnClick  := @ScreenShotClick;
    Parent := Grp;
  end;

  with TMUIButton.Create('General') do
  begin
    OnClick  := @GeneralClick;
    Parent := Grp;
  end;

  with TMUIButton.Create('Boards') do
  begin
    OnClick := @BoardClick;
    Parent := Grp;
  end;

  with TMUIButton.Create('Alert') do
  begin
    OnClick := @AlertClick;
    Parent := Grp;
  end;

  TMUIRectangle.Create.Parent := Grp;


end;

end.

