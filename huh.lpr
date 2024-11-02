program huh;

uses
  MUIClass.Base, MUIClass.Dialog, SysUtils,
  mainwinunit, identifylib, alertwindowunit, boardwinunit, generalwinunit, ScreenShotWinUnit;

const
  VERSION = '$VER: Huh? 0.2 (02.11.2024)';

begin
  if not Assigned(IdentifyBase) then
  begin
    writeln(IdentifyLibName + ' Version ' +  IntToStr(IdentifyLibMinVersion) + ' not found.');
    ShowMessage(IdentifyLibName + ' Version ' +  IntToStr(IdentifyLibMinVersion) + ' not found.');
    Halt(5);
  end;
  //
  TMainWindow.Create;
  AlertWindow := TAlertWindow.Create;
  BoardsWin := TBoardsWin.Create;
  GeneralWin := TGeneralWin.Create;
  ScreenShotWin := TScreenShotWindow.Create;

  MUIApp.Title := 'Huh?';
  MUIApp.Author := 'Marcus "ALB42" Sackrow';
  MUIApp.Version := Copy(VERSION, 7);
  MUIApp.Run;
end.

