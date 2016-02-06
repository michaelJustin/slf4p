program Unittests;

{$APPTYPE CONSOLE}

uses
  djLogAPI in '..\main\djLogAPI.pas',
  djLoggerFactory in '..\main\djLoggerFactory.pas',
  djLogOverNOPLogger in '..\main\djLogOverNOPLogger.pas',
  LoggerFactoryTests in 'LoggerFactoryTests.pas',
  NOPLoggerTests in 'NOPLoggerTests.pas',
  SimpleLoggerTests in 'SimpleLoggerTests.pas',
  Log4DLoggerTests in 'Log4DLoggerTests.pas',
  Log4D,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SysUtils;

begin
  RegisterTests('TdjLoggerFactory Tests', [TdjLoggerFactoryTests.Suite]);
  RegisterTests('TNOPLogger Tests', [TNOPLoggerTests.Suite]);
  RegisterTests('TSimpleLogger Tests', [TSimpleLoggerTests.Suite]);
  RegisterTests('TLog4DLogger Tests', [TLog4DLoggerTests.Suite]);

  // Create a default ODS logger
  TLogBasicConfigurator.Configure;
  // see output in the 'Event log' IDE Window
  TLogLogger.GetRootLogger.Level := Debug;

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
