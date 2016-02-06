program demo;

uses
  djLogOverLazLogger, djLogAPI, djLoggerFactory;

var
  Logger: ILogger;

begin
  Logger := TdjLoggerFactory.GetLogger('demo');
  Logger.Info('Hello World');

  WriteLn('hit any key');
  ReadLn;
end.

