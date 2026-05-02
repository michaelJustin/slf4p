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
  djLogOverSimpleLogger, SimpleLogger, slf4p,
  MyClasses in 'MyClasses.pas';

resourcestring
  StrLog = '[demo]';

procedure RunDemo;
var
  Obj1: TFirstClass;
  Obj2: TSecondClass;
begin
  SimpleLogger.Configure('defaultLogLevel', 'trace');
  SimpleLogger.Configure('showDateTime', 'false');

  LOGGER(StrLog).Info('Using slf4p %s', [SLF4P_VERSION]);

  Obj1 := TFirstClass.Create;
  Obj2 := TSecondClass.Create;
  try
    LOGGER(StrLog).Info(Obj1.ToString + ' ' + Obj2.ToString);
  finally
    Obj2.Free;
    Obj1.Free;
  end;

  LOGGER(StrLog).Info('Hit any key');
  ReadLn;
end;

begin
  RunDemo;
end.
