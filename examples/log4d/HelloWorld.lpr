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

