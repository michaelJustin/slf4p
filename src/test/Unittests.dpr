program Unittests;

uses
  // API units
  djLogAPI in '..\main\djLogAPI.pas',
  djLoggerFactory in '..\main\djLoggerFactory.pas',
  djLogOverNOPLogger in '..\main\djLogOverNOPLogger.pas',
  // Implementations
  NOPLogger in '..\main\NOPLogger.pas',
  SimpleLogger in '..\main\SimpleLogger.pas',
  StringsLogger in '..\main\StringsLogger.pas',
  // Test classes
  LoggerFactoryTests in 'LoggerFactoryTests.pas',
  NOPLoggerTests in 'NOPLoggerTests.pas',
  SimpleLoggerTests in 'SimpleLoggerTests.pas',
  StringsLoggerTests in 'StringsLoggerTests.pas',
  // Log4DLoggerTests in 'Log4DLoggerTests.pas',
  // Log4D,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SysUtils;

begin
  RegisterTests('TdjLoggerFactory Tests', [TdjLoggerFactoryTests.Suite]);
  RegisterTests('TNOPLogger Tests', [TNOPLoggerTests.Suite]);
  RegisterTests('TSimpleLogger Tests', [TSimpleLoggerTests.Suite]);
  RegisterTests('TStringsLogger Tests', [TStringsLoggerTests.Suite]);
  // RegisterTests('TLog4DLogger Tests', [TLog4DLoggerTests.Suite]);

  // Create a default ODS logger
  // TLogBasicConfigurator.Configure;
  // see output in the 'Event log' IDE Window
  // TLogLogger.GetRootLogger.Level := Debug;

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
