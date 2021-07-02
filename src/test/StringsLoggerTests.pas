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
  djLogAPI, StringBuilderLogger, Classes, SysUtils;

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
begin
  SB := TStringBuilder.Create;
  try
    LoggerFactory := TStringsLoggerFactory.Create(SB);

    Logger := LoggerFactory.GetLogger('sl');

    Logger.Info('simple info msg');

    CheckEquals('INFO sl - simple info msg', SB.ToString);
  finally
    SB.Free;
  end;
end;

end.

