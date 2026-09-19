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

unit StringsLoggerTests;

interface

uses
  {$IFDEF FPC}
  fpcunit,testregistry
  {$ELSE}
  TestFramework
  {$ENDIF};

type

  { TStringsLoggerTests }

  TStringsLoggerTests = class(TTestCase)
  published
    procedure CreateLogger;
    procedure TestInfo;
    procedure TestObjectArg;
    procedure TestObjectArgWithCustomToString;
    procedure TestTwoObjectArgs;
    procedure TestObjectArgNotEvaluatedWhenLevelDisabled;
  end;

implementation

uses
  djLogAPI, StringsLogger, Classes, SysUtils;

var
  { Counts TCountingToString.ToString invocations; reset by each test that
    uses it. }
  GToStringCallCount: Integer;

type
  { A point whose ToString is overridden, to verify ObjectToStr prefers it
    over ClassName. }
  TPoint2D = class(TObject)
  strict private
    FX, FY: Integer;
  public
    constructor Create(AX, AY: Integer);
    function ToString: string; override;
  end;

  { A ToString that counts its own invocations, to verify a disabled-level
    log call never evaluates the object argument's ToString. }
  TCountingToString = class(TObject)
  public
    function ToString: string; override;
  end;

{ TPoint2D }

constructor TPoint2D.Create(AX, AY: Integer);
begin
  FX := AX;
  FY := AY;
end;

function TPoint2D.ToString: string;
begin
  Result := Format('(%d, %d)', [FX, FY]);
end;

{ TCountingToString }

function TCountingToString.ToString: string;
begin
  Inc(GToStringCallCount);
  Result := 'counted';
end;

{ TStringsLoggerTests }

procedure TStringsLoggerTests.CreateLogger;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
     LoggerFactory := TStringsLoggerFactory.Create(SB);
     Logger := LoggerFactory.GetLogger('strings');

     CheckEquals('strings', Logger.Name);
  finally
    SB.Free;
  end;
end;

procedure TStringsLoggerTests.TestInfo;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  SB: TStringBuilder;
  SL: TStrings;
begin
  SB := TStringBuilder.Create;
  try
    LoggerFactory := TStringsLoggerFactory.Create(SB);
    StringsLogger.Configure('defaultLogLevel', 'debug');

    Logger := LoggerFactory.GetLogger('test.stringslogger');
    Logger.Info('simple info msg');
    Logger.Debug('simple debug msg');
    try
      raise Exception.Create('some exception occured');
    except
      on E: Exception do
      begin
        Logger.Error('exception', E);
      end;
    end;

    SL := TStringList.Create;
    try
      SL.Text := SB.ToString;

      CheckEquals('INFO test.stringslogger - simple info msg', SL[0]);
      CheckEquals('DEBUG test.stringslogger - simple debug msg', SL[1]);
      CheckEquals('ERROR test.stringslogger - exception', SL[2]);
      CheckEquals('  Exception', SL[3]);
      CheckEquals('  some exception occured', SL[4]);

      WriteLn(SL.Text);
    finally
      SL.Free;
    end;
  finally
    SB.Free;
  end;
end;

procedure TStringsLoggerTests.TestObjectArg;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  SB: TStringBuilder;
  SL: TStrings;
  Obj: TStringList;
begin
  SB := TStringBuilder.Create;
  try
    LoggerFactory := TStringsLoggerFactory.Create(SB);
    StringsLogger.Configure('defaultLogLevel', 'debug');

    Logger := LoggerFactory.GetLogger('test.stringslogger');

    Obj := TStringList.Create;
    try
      Logger.Info('found %s', Obj);
    finally
      Obj.Free;
    end;

    Logger.Info('found %s', TObject(nil));

    SL := TStringList.Create;
    try
      SL.Text := SB.ToString;

      CheckEquals('INFO test.stringslogger - found TStringList', SL[0]);
      CheckEquals('INFO test.stringslogger - found nil', SL[1]);
    finally
      SL.Free;
    end;
  finally
    SB.Free;
  end;
end;

procedure TStringsLoggerTests.TestObjectArgWithCustomToString;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  SB: TStringBuilder;
  SL: TStrings;
  Obj: TPoint2D;
begin
  SB := TStringBuilder.Create;
  try
    LoggerFactory := TStringsLoggerFactory.Create(SB);
    StringsLogger.Configure('defaultLogLevel', 'debug');

    Logger := LoggerFactory.GetLogger('test.stringslogger');

    Obj := TPoint2D.Create(3, 4);
    try
      Logger.Info('found %s', Obj);
    finally
      Obj.Free;
    end;

    SL := TStringList.Create;
    try
      SL.Text := SB.ToString;

      CheckEquals('INFO test.stringslogger - found (3, 4)', SL[0]);
    finally
      SL.Free;
    end;
  finally
    SB.Free;
  end;
end;

procedure TStringsLoggerTests.TestTwoObjectArgs;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  SB: TStringBuilder;
  SL: TStrings;
  Obj1, Obj2: TStringList;
begin
  SB := TStringBuilder.Create;
  try
    LoggerFactory := TStringsLoggerFactory.Create(SB);
    StringsLogger.Configure('defaultLogLevel', 'debug');

    Logger := LoggerFactory.GetLogger('test.stringslogger');

    Obj1 := TStringList.Create;
    Obj2 := TStringList.Create;
    try
      Logger.Info('matched %s to %s', Obj1, Obj2);
    finally
      Obj2.Free;
      Obj1.Free;
    end;

    Logger.Info('matched %s to %s', TObject(nil), TObject(nil));

    SL := TStringList.Create;
    try
      SL.Text := SB.ToString;

      CheckEquals('INFO test.stringslogger - matched TStringList to TStringList', SL[0]);
      CheckEquals('INFO test.stringslogger - matched nil to nil', SL[1]);
    finally
      SL.Free;
    end;
  finally
    SB.Free;
  end;
end;

procedure TStringsLoggerTests.TestObjectArgNotEvaluatedWhenLevelDisabled;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  SB: TStringBuilder;
  Obj: TCountingToString;
begin
  SB := TStringBuilder.Create;
  try
    LoggerFactory := TStringsLoggerFactory.Create(SB);
    StringsLogger.Configure('defaultLogLevel', 'error');

    Logger := LoggerFactory.GetLogger('test.stringslogger');

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

    { restore the default used by the other tests in this suite }
    StringsLogger.Configure('defaultLogLevel', 'debug');
  finally
    SB.Free;
  end;
end;

end.

