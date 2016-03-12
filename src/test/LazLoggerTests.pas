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

unit LazLoggerTests;

interface

uses
  {$IFDEF FPC}
  fpcunit,testregistry
  {$ELSE}
  TestFramework
  {$ENDIF};

type

  { TLazLoggerTests }

  TLazLoggerTests = class(TTestCase)
  published
    procedure CreateLogger;
    procedure TestDebug;
    procedure TestInfo;

    procedure TestWriteFile;
  end;

implementation

uses
  djLogAPI, LazLoggerLogger,
  LazLogger,
  SysUtils;

{ TLazLoggerTests }

procedure TLazLoggerTests.CreateLogger;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
begin
  LoggerFactory := TLazLoggerFactory.Create;
  Logger := LoggerFactory.GetLogger('lazlogger1');

  CheckEquals('lazlogger1', Logger.Name);
end;

procedure TLazLoggerTests.TestDebug;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  E: EAbort;
begin
  LoggerFactory := TLazLoggerFactory.Create;

  Logger := LoggerFactory.GetLogger('lazlogger2');

  Logger.Debug('log4d msg');
  Logger.Debug('log4d msg', ['a', 2, Date]);

  E := EAbort.Create('example');
  Logger.Debug('log4d msg', E);
  E.Free;
end;

procedure TLazLoggerTests.TestInfo;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  E: EAbort;
begin
  LoggerFactory := TLazLoggerFactory.Create;

  Logger := LoggerFactory.GetLogger('lazlogger3');

  Logger.Info('simple msg');
  Logger.Info('simple msg', ['a', 2, Date]);

  E := EAbort.Create('simple example exception');
  Logger.Info('simple msg', E);
  E.Free;
end;

procedure TLazLoggerTests.TestWriteFile;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
begin
  LoggerFactory := TLazLoggerFactory.Create;

  Logger := LoggerFactory.GetLogger('lazlogger4');

  DebugLogger.LogName := 'lazlogger.log';

  Logger.Info('logged to lazlogger.log');
end;

end.

