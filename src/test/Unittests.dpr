program Unittests;

{$APPTYPE CONSOLE}

uses
  NOPLoggerTests in 'NOPLoggerTests.pas',
  SimpleLoggerTests in 'SimpleLoggerTests.pas',
  LoggerFactoryTests in 'LoggerFactoryTests.pas',
  djLogImplSimple in '..\main\djLogImplSimple.pas',
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SysUtils;

begin
  RegisterTests('TdjLoggerFactory Tests', [TdjLoggerFactoryTests.Suite]);
  RegisterTests('TNOPLogger Tests', [TNOPLoggerTests.Suite]);
  RegisterTests('TSimpleLogger Tests', [TSimpleLoggerTests.Suite]);

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
