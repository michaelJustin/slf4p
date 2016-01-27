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

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  {$IFDEF FPC}
  fpcunit,testregistry
  {$ELSE}
  TestFramework
  {$ENDIF};

type
  TSimpleLoggerTests = class(TTestCase)
  published
    procedure CreateLogger;
    procedure TestDebug;
    procedure TestInfo;
  end;

implementation

uses
  djLogAPI, SimpleLogger, SysUtils;

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

procedure TSimpleLoggerTests.TestDebug;
var
  LoggerFactory: ILoggerFactory;
  Logger: ILogger;
  E: EAbort;
begin
  LoggerFactory := TSimpleLoggerFactory.Create;

  Logger := LoggerFactory.GetLogger('simple');

  Logger.Debug('simple msg');
  Logger.Debug('simple msg', ['a', 2, Date]);

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

  Logger := LoggerFactory.GetLogger('simple');

  Logger.Info('simple msg');
  Logger.Info('simple msg', ['a', 2, Date]);

  E := EAbort.Create('simple example exception');
  Logger.Info('simple msg', E);
  E.Free;
end;

end.
