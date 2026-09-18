program Unittests;

{$mode DELPHI}{$H+}

uses
  LoggerFactoryTests,
  LogEventTests,
  Log4DLoggerTests,
  NOPLoggerTests,
  SimpleLoggerTests,
  LazLoggerTests,
  StringsLoggerTests,
  Log4D,
  Interfaces, Forms,
  fpcunit, testregistry, GuiTestRunner, consoletestrunner,
  SysUtils;

{$R *.res}

var
  Tests: TTestSuite;

begin
  // Write the heap trace report to heaptrace.log next to the executable.
  // Must run before any allocation. See UNIT-TESTS.md.
  SetHeapTraceOutput('heaptrace.log');

  Tests := TTestSuite.Create('Library Tests');

  Tests.AddTest(TdjLoggerFactoryTests.Suite);
  Tests.AddTest(TLogEventTests.Suite);
  Tests.AddTest(TLazLoggerTests.Suite);
  Tests.AddTest(TNOPLoggerTests.Suite);
  Tests.AddTest(TSimpleLoggerTests.Suite);
  Tests.AddTest(TStringsLoggerTests.Suite);

  // Log4D specific initialization: create a default logger
  TLogBasicConfigurator.Configure;
  Tests.AddTest(TLog4DLoggerTests.Suite);

  RegisterTest('', Tests);

  if ParamCount > 0 then
  begin
    // Console Test Runner: headless, for scripted / CI runs, e.g.
    // `UnittestsConsole --all --format=plain`. Exit code has bit 0 set on
    // failures and bit 1 set on errors (FPCUnit TProgressWriter.GetExitCode),
    // so scripts and CI can detect a red run from the process exit status.
    consoletestrunner.TTestRunner.Create(nil).Run;
  end
  else
  begin
    Application.Initialize;
    Application.CreateForm(TGuiTestRunner, TestRunner);
    TestRunner.Caption := 'Logging Facade FPCUnit tests';
    TestRunner.TestTree.Items[0].Text := 'Logging Facade FPCUnit tests';
    Application.Run;
  end;
end.

