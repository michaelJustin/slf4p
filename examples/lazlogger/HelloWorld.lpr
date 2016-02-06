program HelloWorld;

uses
  djLogOverLazLogger, djLogAPI, djLoggerFactory,
  LazLogger;

var
  Logger: ILogger;

begin
  Logger := TdjLoggerFactory.GetLogger('demo');
  Logger.Info('Hello World');

  WriteLn('hit any key');
  ReadLn;
end.

