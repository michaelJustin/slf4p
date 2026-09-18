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

unit LogEventTests;

interface

uses
  {$IFDEF FPC}
  fpcunit,testregistry
  {$ELSE}
  TestFramework
  {$ENDIF};

type

  { TLogEventTests }

  TLogEventTests = class(TTestCase)
  published
    procedure TestMessageOnly;
    procedure TestMessageWithException;
    procedure TestFormattedMessage;
    procedure TestNoException;
  end;

implementation

uses
  djLogAPI, SysUtils;

{ TLogEventTests }

procedure TLogEventTests.TestMessageOnly;
var
  Event: ILogEvent;
begin
  Event := TLogEvent.Create('root', Info, 'hello world');

  CheckEquals('root', Event.LoggerName);
  CheckTrue(Info = Event.Level);
  CheckEquals('hello world', Event.Message);
  CheckEquals(0, Length(Event.Args));
  CheckTrue(Event.TimeStamp > 0);
end;

procedure TLogEventTests.TestMessageWithException;
var
  Event: ILogEvent;
  E: Exception;
begin
  E := Exception.Create('boom');
  try
    Event := TLogEvent.Create('root', Error, 'failed', E);

    CheckEquals('failed', Event.Message);
    CheckSame(E, Event.Exception);
  finally
    E.Free;
  end;
end;

procedure TLogEventTests.TestFormattedMessage;
var
  Event: ILogEvent;
begin
  Event := TLogEvent.Create('root', Debug, 'hello %s, you are %d',
    ['world', 42]);

  CheckEquals('hello world, you are 42', Event.Message);
  CheckEquals(2, Length(Event.Args));
  CheckEquals('world', Event.Args[0]);
  CheckEquals('42', Event.Args[1]);
end;

procedure TLogEventTests.TestNoException;
var
  Event: ILogEvent;
begin
  Event := TLogEvent.Create('root', Warn, 'no exception here');

  CheckFalse(Assigned(Event.Exception));
end;

end.
