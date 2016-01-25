program Unittests;

{$APPTYPE CONSOLE}

uses
  LoggerFactoryTests in 'LoggerFactoryTests.pas',
  NOPLoggerTests in 'NOPLoggerTests.pas',
  SimpleLoggerTests in 'SimpleLoggerTests.pas',
  {.IFDEF USE_LOG4D}
  Log4DLoggerTests in 'Log4DLoggerTests.pas',
  {.ENDIF}
  djLogImplNOP in '..\main\djLogImplNOP.pas',
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SysUtils;

begin
  RegisterTests('TdjLoggerFactory Tests', [TdjLoggerFactoryTests.Suite]);
  RegisterTests('TNOPLogger Tests', [TNOPLoggerTests.Suite]);
  RegisterTests('TSimpleLogger Tests', [TSimpleLoggerTests.Suite]);
  RegisterTests('TLog4DLogger Tests', [TLog4DLoggerTests.Suite]);

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
