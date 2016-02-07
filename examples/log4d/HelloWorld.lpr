program HelloWorld;

uses
  djLogOverLog4D, djLogAPI, djLoggerFactory, LogConsoleAppender,
  Log4D;

var
  ConsoleAppender: ILogAppender;
  Logger: ILogger;

begin
  // Log4D configuration
  ConsoleAppender := TLogConsoleAppender.Create('console');
  ConsoleAppender.Layout := TLogPatternLayout.Create(TTCCPattern);
  TLogBasicConfigurator.Configure(ConsoleAppender);
  TLogLogger.GetRootLogger.Level := Info;
  WriteLn('Logging with Log4D version ' + Log4DVersion);


  Logger := TdjLoggerFactory.GetLogger('demo');
  Logger.Info('Hello World');


  WriteLn('hit any key');
  ReadLn;
end.

