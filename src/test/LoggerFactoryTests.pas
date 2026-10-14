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

interface

uses
  {$IFDEF FPC}
  fpcunit,testregistry
  {$ELSE}
  TestFramework
  {$ENDIF};

type

  { TdjLoggerFactoryTests }

  TdjLoggerFactoryTests = class(TTestCase)
  published
    // Must stay the first test: it needs the state in which no factory is
    // registered yet. That state exists only at the start of the FPC test
    // run (Unittests.lpr uses no djLogOver... unit); the Delphi project
    // registers the NOP factory at startup, so there this test can't fail.
    procedure TestNoFactoryAssignedGetLoggerByClass;
    procedure TestNoFactoryAssigned;

  end;

implementation

uses
  djLogAPI, djLoggerFactory, SysUtils;

{ TLoggerFactoryTests }

procedure TdjLoggerFactoryTests.TestNoFactoryAssignedGetLoggerByClass;
var
  Logger: ILogger;
begin
  // without a registered factory, the class overload must fall back to the
  // NOP factory like the string overload does, not use a nil factory (#94)
  Logger := TdjLoggerFactory.GetLogger(TdjLoggerFactoryTests);
  CheckTrue(TdjLoggerFactory.IsRegistered);
  CheckEquals('LoggerFactoryTests.TdjLoggerFactoryTests', Logger.Name);
  Logger.Info('logging with NOP logger');
end;

procedure TdjLoggerFactoryTests.TestNoFactoryAssigned;
var
  Logger: ILogger;
begin
  // ExpectException(Exception);
  Logger := TdjLoggerFactory.GetLogger('djLoggerFactory');
  Logger.Info('logging with NOP logger');
end;


end.
