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

program LogException;

{$APPTYPE CONSOLE}

uses
  djLoggerFactory, djLogAPI, djLogOverSimpleLogger, SysUtils;

type
  EDestroyFailed = class(Exception);

procedure DestroyFilter;
begin
  raise EDestroyFailed.Create('error in destroy');
end;

procedure RunDemo;
var
  Log: ILogger;
begin
  Log := TLoggerFactory.GetLogger('TdjWebFilterHolder');

  try
    DestroyFilter;
  except
    on E: Exception do
    begin
      // format arguments and the exception in one call
      Log.Warn('TdjWebFilterHolder.Stop: %s', [E.Message], E);

      // a plain message and the exception: its class and message still
      // appear, below the message
      Log.Warn('TdjWebFilterHolder.Stop:', E);
    end;
  end;

  Log.Info('Hit any key');
  ReadLn;
end;

begin
  RunDemo;
end.
