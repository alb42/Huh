program huh;

uses
  MUIClass.Base, MUIClass.Dialog, SysUtils,
  mainwinunit, identifylib, alertwindowunit, boardwinunit, generalwinunit;

const
  VERSION = '$VER: Huh? 0.1 (01.11.2024)';

begin
  if not Assigned(IdentifyBase) then
  begin
    ShowMessage(IdentifyLibName + ' Version ' +  IntToStr(IdentifyLibMinVersion) + ' not found.');
    Halt(5);
  end;
  //
  TMainWindow.Create;
  AlertWindow := TAlertWindow.Create;
  BoardsWin := TBoardsWin.Create;
  GeneralWin := TGeneralWin.Create;

  MUIApp.Title := 'Huh?';
  MUIApp.Author := 'Marcus "ALB42" Sackrow';
  MUIApp.Version := Copy(VERSION, 7);
  MUIApp.Run;
end.

