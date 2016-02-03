program Unittests;

{$mode DELPHI}{$H+}

uses
  djLogAPI,
  djLogOverNOPLogger, djLoggerFactory,
  LoggerFactoryTests,
  NOPLoggerTests,
  SimpleLoggerTests,
  Log4DLoggerTests,
  Log4D,
  Interfaces, Forms,
  fpcunit, testutils, testregistry, GuiTestRunner,
  SysUtils;

{$R *.res}

var
  Tests: TTestSuite;

begin
  // Log4D specific initialization: create a default logger
  TLogBasicConfigurator.Configure;

  Tests := TTestSuite.Create('Library Tests');

  Tests.AddTest(TdjLoggerFactoryTests.Suite);
  Tests.AddTest(TNOPLoggerTests.Suite);
  Tests.AddTest(TSimpleLoggerTests.Suite);
  Tests.AddTest(TLog4DLoggerTests.Suite);

  RegisterTest('', Tests);

  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  TestRunner.Caption := 'Logging Facade FPCUnit tests';
  TestRunner.TestTree.Items[0].Text := 'Logging Facade FPCUnit tests';
  Application.Run;

  SetHeapTraceOutput('heaptrace.log');
end.

