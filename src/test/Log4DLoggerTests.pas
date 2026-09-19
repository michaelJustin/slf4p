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
    procedure TestInfo;
    procedure TestBadFormatDoesNotRaise;
    procedure TestObjectArgNotEvaluatedWhenLevelDisabled;
  end;

implementation

uses
  djLogAPI, Log4DLogger, Log4D, SysUtils;

var
  { Counts TCountingToString.ToString invocations; reset by the test that
    uses it. }
  GToStringCallCount: Integer;

type
  { A ToString that counts its own invocations, to verify a disabled-level
    log call never evaluates the object argument's ToString. }
  TCountingToString = class(TObject)
  public
    function ToString: string; override;
  end;

{ TCountingToString }

function TCountingToString.ToString: string;
begin
  Inc(GToStringCallCount);
  Result := 'counted';
end;

{ TLog4DLoggerTests }

procedure TLog4DLoggerTests.CreateLogger;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
begin
  LoggerFactory := TLog4DLoggerFactory.Create;
  Logger := LoggerFactory.GetLogger('log4dlogger');

  CheckEquals('log4dlogger', Logger.Name);
end;

procedure TLog4DLoggerTests.TestDebug;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  E: EAbort;
begin
  LoggerFactory := TLog4DLoggerFactory.Create;

  Logger := LoggerFactory.GetLogger('log4d');

  Logger.Debug('log4d msg');
  Logger.Debug('log4d msg', ['a', 2, Date]);

  E := EAbort.Create('example');
  Logger.Debug('log4d msg', E);
  E.Free;
end;

procedure TLog4DLoggerTests.TestInfo;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  E: EAbort;
begin
  LoggerFactory := TLog4DLoggerFactory.Create;

  Logger := LoggerFactory.GetLogger('simple');

  Logger.Info('simple msg');
  Logger.Info('simple msg', ['a', 2, Date]);

  E := EAbort.Create('simple example exception');
  Logger.Info('simple msg', E);
  E.Free;
end;

procedure TLog4DLoggerTests.TestBadFormatDoesNotRaise;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
begin
  LoggerFactory := TLog4DLoggerFactory.Create;
  Logger := LoggerFactory.GetLogger('log4d');

  { '%d' given a non-numeric argument: SysUtils.Format would raise
    EConvertError; TLog4DLogger.Log must not let that propagate. }
  Logger.Debug('value is %d', ['not a number']);
end;

procedure TLog4DLoggerTests.TestObjectArgNotEvaluatedWhenLevelDisabled;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  Obj: TCountingToString;
begin
  TLogLogger.GetLogger('log4d-disabled-test').Level := Log4D.Error;

  LoggerFactory := TLog4DLoggerFactory.Create;
  Logger := LoggerFactory.GetLogger('log4d-disabled-test');

  GToStringCallCount := 0;
  Obj := TCountingToString.Create;
  try
    { Debug is disabled (level is Error): ToString must never run. }
    Logger.Debug('found %s', Obj);
    Logger.Debug('matched %s to %s', Obj, Obj);
  finally
    Obj.Free;
  end;

  CheckEquals(0, GToStringCallCount);
end;

end.
