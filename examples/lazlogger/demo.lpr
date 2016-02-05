program demo;

uses
  LazLogger,
  djLogAPI, djLogOverLazLogger, djLoggerFactory,
  SysUtils;

var
  Logger: ILogger;

begin
  // write a log message using LazLogger API
  DebugLn(['Foo=', 1, ' Bar=', 2]);
  WriteLn('hit any key');
  ReadLn;

  // write a log message with SLF4P over LazLogger
  Logger := TdjLoggerFactory.GetLogger('demo');
  Logger.Debug('Foo=%d Bar=%d', [1, 2]);
  Logger.Debug('Log exception: ', EAbort.Create('test exception'));
  WriteLn('hit any key');
  ReadLn;

end.

