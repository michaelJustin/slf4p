program Unittests;

{$APPTYPE CONSOLE}

uses
  NOPLoggerTests in 'NOPLoggerTests.pas',
  SimpleLoggerTests in 'SimpleLoggerTests.pas',
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SysUtils;

begin
  RegisterTests('NOP Logger', [TNOPLoggerTests.Suite]);
  RegisterTests('Simple Logger', [TSimpleLoggerTests.Suite]);

  if FindCmdLineSwitch('text-mode', ['-', '/'], True) then
  begin
    TextTestRunner.RunRegisteredTests(rxbContinue)
  end
  else
  begin
    ReportMemoryLeaksOnShutDown := True;
    TGUITestRunner.RunRegisteredTests;
  end;

  ReportMemoryLeaksOnShutdown := True;
end.
