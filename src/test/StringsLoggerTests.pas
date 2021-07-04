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
  end;

implementation

uses
  djLogAPI, StringsLogger, Classes, SysUtils;

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
    finally
      SL.Free;
    end;
  finally
    SB.Free;
  end;
end;

end.

