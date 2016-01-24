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

unit LoggerFactoryTests;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  {$IFDEF FPC}
  fpcunit,testregistry
  {$ELSE}
  TestFramework
  {$ENDIF};

type
  TdjLoggerFactoryTests = class(TTestCase)
  published
    procedure TestDebug;
  end;

implementation

uses
  djLogAPI, djLoggerFactory, SysUtils;

{ TLoggerFactoryTests }

procedure TdjLoggerFactoryTests.TestDebug;
var
  Logger: ILogger;
  E: EAbort;
begin
  Logger := TdjLoggerFactory.GetLogger('djLoggerFactory');

  Logger.Debug('djLoggerFactory msg');
  Logger.Debug('djLoggerFactory msg', ['a', 2, Date]);

  E := EAbort.Create('djLoggerFactory example exception');
  Logger.Debug('djLoggerFactory msg', E);
  E.Free;

end;

end.
