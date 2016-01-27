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
  Log4DelphiLoggerTests in 'Log4DelphiLoggerTests.pas',
  Log4D,
  TLoggerUnit,
  TConfiguratorUnit,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  SysUtils;

begin
  RegisterTests('TdjLoggerFactory Tests', [TdjLoggerFactoryTests.Suite]);
  RegisterTests('TNOPLogger Tests', [TNOPLoggerTests.Suite]);
  RegisterTests('TSimpleLogger Tests', [TSimpleLoggerTests.Suite]);
  RegisterTests('TLog4DLogger Tests', [TLog4DLoggerTests.Suite]);
  RegisterTests('TLog4DelphiLogger Tests', [TLog4DelphiLoggerTests.Suite]);

  // Create a default ODS logger
  TLogBasicConfigurator.Configure;
  // see output in the 'Event log' IDE Window
  TLogLogger.GetRootLogger.Level := Debug;

  // Log4Delphi
  TConfiguratorUnit.doBasicConfiguration;

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

  // Log4Delphi cleanup ...
  TLogger.freeInstances;
end.
