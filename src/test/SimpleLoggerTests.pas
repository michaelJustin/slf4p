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

unit SimpleLoggerTests;

interface

uses
  {$IFDEF FPC}
  fpcunit,testregistry
  {$ELSE}
  TestFramework
  {$ENDIF};

type

  { TSimpleLoggerTests }

  TSimpleLoggerTests = class(TTestCase)
  published
    procedure CreateLogger;
    procedure TestConfig;
    procedure TestConfigShowDateTime;

    procedure TestDebug;
    procedure TestInfo;
  end;

implementation

uses
  djLogAPI, SimpleLogger, Classes, SysUtils;

{ TSimpleLoggerTests }

procedure TSimpleLoggerTests.CreateLogger;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
begin
  LoggerFactory := TSimpleLoggerFactory.Create;
  Logger := LoggerFactory.GetLogger('simple');

  CheckEquals('simple', Logger.Name);
end;

procedure TSimpleLoggerTests.TestConfig;
var
  S: TStrings;
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
begin
  LoggerFactory := TSimpleLoggerFactory.Create;

  // configure with TStrings
  S := TStringList.Create;
  try
    S.Values['defaultLogLevel'] := 'debug';
    SimpleLogger.Configure(S);
  finally
    S.Free;
  end;

  Logger := LoggerFactory.GetLogger('simple');
  CheckFalse(Logger.IsTraceEnabled, 'trace');
  CheckTrue(Logger.IsDebugEnabled, 'debug');
  CheckTrue(Logger.IsInfoEnabled, 'info');
  CheckTrue(Logger.IsWarnEnabled, 'warn');
  CheckTrue(Logger.IsErrorEnabled, 'error');

  // configure key-value pair
  SimpleLogger.Configure('defaultLogLevel', 'info');
  Logger := LoggerFactory.GetLogger('simple');
  CheckFalse(Logger.IsTraceEnabled, 'trace 2');
  CheckFalse(Logger.IsDebugEnabled, 'debug 2');
  CheckTrue(Logger.IsInfoEnabled, 'info 2');
  CheckTrue(Logger.IsWarnEnabled, 'warn 2');
  CheckTrue(Logger.IsErrorEnabled, 'error 2');
end;

procedure TSimpleLoggerTests.TestConfigShowDateTime;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
begin
  SimpleLogger.Configure('showDateTime', 'true');
  // SimpleLogger.Configure('dateTimeFormat', 'hh:nn:ss.zzz');

  LoggerFactory := TSimpleLoggerFactory.Create;

  Logger := LoggerFactory.GetLogger('dateTime on');
  Logger.Info('testShowDateTime 1');

  SimpleLogger.Configure('showDateTime', 'false');

  Logger := LoggerFactory.GetLogger('dateTime off');
  Logger.Info('testShowDateTime 2');
end;

procedure TSimpleLoggerTests.TestDebug;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  E: EAbort;
begin
  LoggerFactory := TSimpleLoggerFactory.Create;

  SimpleLogger.Configure('defaultLogLevel', 'debug');

  Logger := LoggerFactory.GetLogger('simple');

  Logger.Trace('simple trace msg');
  Logger.Debug('simple debug msg');
  Logger.Info('simple info msg');

  E := EAbort.Create('simple example exception');
  Logger.Debug('simple msg', E);
  E.Free;
end;

procedure TSimpleLoggerTests.TestInfo;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  E: EAbort;
begin
  LoggerFactory := TSimpleLoggerFactory.Create;

  SimpleLogger.Configure('defaultLogLevel', 'info');

  Logger := LoggerFactory.GetLogger('simple');

  Logger.Trace('simple trace msg');
  Logger.Debug('simple debug msg');
  Logger.Info('simple info msg');

  E := EAbort.Create('simple example exception');
  Logger.Info('simple msg', E);
  E.Free;
end;

end.
