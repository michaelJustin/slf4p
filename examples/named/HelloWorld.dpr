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

{$APPTYPE CONSOLE}

program HelloWorld;

uses
  djLogOverSimpleLogger, SimpleLogger,
  slf4p;

type
  TFirstClass = class
    constructor Create;
    destructor Destroy; override;
  end;

  TSecondClass = class(TFirstClass)
    constructor Create;
    destructor Destroy; override;
  end;

procedure RunDemo;
var
  Obj1: TFirstClass;
  Obj2: TSecondClass;
begin
  SimpleLogger.Configure('defaultLogLevel', 'trace');
  SimpleLogger.Configure('showDateTime', 'false');

  LOGGER.Info('Using slf4p %s', [SLF4P_VERSION]);

  Obj1 := TFirstClass.Create;
  Obj2 := TSecondClass.Create;
  try
    LOGGER.Info(Obj1.ToString + ' ' + Obj2.ToString);
  finally
    Obj2.Free;
    Obj1.Free;
  end;

  LOGGER.Info('Hit any key');
  ReadLn;
end;

{ TExampleClass }

constructor TFirstClass.Create;
begin
  LOGGER(ClassName).Info('in constructor');
end;

destructor TFirstClass.Destroy;
begin
  LOGGER(ClassName).Info('in destructor');
end;

{ TSecondClass }

constructor TSecondClass.Create;
begin
  LOGGER(ClassName).Trace('entering constructor');
  inherited;
  LOGGER(ClassName).Trace('leaving constructor');
end;

destructor TSecondClass.Destroy;
begin
  LOGGER(ClassName).Trace('entering destructor');
  inherited;
  LOGGER(ClassName).Trace('leaving destructor');
end;

begin
  RunDemo;
end.
