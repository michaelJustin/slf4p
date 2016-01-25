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

unit Log4DLoggerTests;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  {$IFDEF FPC}
  fpcunit,testregistry
  {$ELSE}
  TestFramework
  {$ENDIF};

type
  TLog4DLoggerTests = class(TTestCase)
  published
    procedure CreateLogger;
    procedure TestDebug;
  end;

implementation

uses
  Log4D,
  djLogAPI, Log4DLogger, SysUtils;

{ TLog4DLoggerTests }

procedure TLog4DLoggerTests.CreateLogger;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
begin
  LoggerFactory := TLog4DLoggerFactory.Create;
  Logger := LoggerFactory.GetLogger('log4d');
end;

procedure TLog4DLoggerTests.TestDebug;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  E: EAbort;
begin
  // Create a default ODS logger
  TLogBasicConfigurator.Configure;
  // see output in the 'Event log' IDE Window
  TLogLogger.GetRootLogger.Level := Debug;

  LoggerFactory := TLog4DLoggerFactory.Create;

  Logger := LoggerFactory.GetLogger('log4d');

  Logger.Debug('log4d msg');
  Logger.Debug('log4d msg', ['a', 2, Date]);

  E := EAbort.Create('example');
  Logger.Debug('log4d msg', E);
  E.Free;
end;

end.
