(*
   Copyright 2016 Michael Justin

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)

program HelloWorld;

uses
  djLogOverLog4D, djLogAPI, djLoggerFactory, LogConsoleAppender,
  Log4D;

var
  LogLayout: ILogLayout;
  ConsoleAppender: ILogAppender;
  FileAppender: ILogAppender;
  Logger: ILogger;

begin
  // Log4D configuration: configure console and file logging
  LogLayout := TLogPatternLayout.Create(TTCCPattern);
  ConsoleAppender := TLogConsoleAppender.Create('console');
  ConsoleAppender.Layout := LogLayout;
  TLogBasicConfigurator.Configure(ConsoleAppender);
  FileAppender := TLogFileAppender.Create('file', 'log4d.log');
  FileAppender.Layout := LogLayout;
  TLogBasicConfigurator.Configure(FileAppender);

  TLogLogger.GetRootLogger.Level := Info;
  WriteLn('Logging with Log4D version ' + Log4DVersion);


  Logger := TdjLoggerFactory.GetLogger('demo');
  Logger.Info('Hello World');


  WriteLn('hit any key');
  ReadLn;
end.

