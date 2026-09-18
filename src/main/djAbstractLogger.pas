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

unit djAbstractLogger;

interface

uses
  djLogAPI, SysUtils;

type
  { Implements ILogger once: owns the level check and the construction of a
    TLogEvent for every call, then hands the event to Append (also exposed
    as ILogEventAppender, so an instance can be reused as a plain event
    sink). Concrete backends only need to override Append and turn the
    already-level-checked event into their framework's native call or
    output format.

    Not every backend derives from this (see issue #69): TNOPLogger stays
    as-is because TLogLevel has no "always off" value to gate every level
    the way NOP's contract requires without extending the enum; TLog4DLogger
    stays as-is because it already delegates its own level check and
    dispatch to Log4D's TLogLogger, so routing it through this class's level
    gate would mean checking the level twice against two different models. }
  TAbstractLogger = class(TInterfacedObject, ILogger, ILogEventAppender)
  strict private
    FName: string;
    FLevel: TLogLevel;

    function IsEnabledFor(ALevel: TLogLevel): Boolean;

    procedure Log(ALevel: TLogLevel; const AMsg: string); overload;
    procedure Log(ALevel: TLogLevel; const AFormat: string; const AArgs: array of const); overload;
    procedure Log(ALevel: TLogLevel; const AMsg: string; const AException: Exception); overload;
  public
    constructor Create(const AName: string; ALevel: TLogLevel = djLogAPI.Debug);

    procedure Append(const AEvent: ILogEvent); virtual; abstract;

    procedure Debug(const AMsg: string); overload;
    procedure Debug(const AFormat: string; const AArgs: array of const); overload;
    procedure Debug(const AFormat: string; const AArg: TObject); overload;
    procedure Debug(const AMsg: string; const AException: Exception); overload;

    procedure Error(const AMsg: string); overload;
    procedure Error(const AFormat: string; const AArgs: array of const); overload;
    procedure Error(const AFormat: string; const AArg: TObject); overload;
    procedure Error(const AMsg: string; const AException: Exception); overload;

    procedure Info(const AMsg: string); overload;
    procedure Info(const AFormat: string; const AArgs: array of const); overload;
    procedure Info(const AFormat: string; const AArg: TObject); overload;
    procedure Info(const AMsg: string; const AException: Exception); overload;

    procedure Warn(const AMsg: string); overload;
    procedure Warn(const AFormat: string; const AArgs: array of const); overload;
    procedure Warn(const AFormat: string; const AArg: TObject); overload;
    procedure Warn(const AMsg: string; const AException: Exception); overload;

    procedure Trace(const AMsg: string); overload;
    procedure Trace(const AFormat: string; const AArgs: array of const); overload;
    procedure Trace(const AFormat: string; const AArg: TObject); overload;
    procedure Trace(const AMsg: string; const AException: Exception); overload;

    function Name: string;

    function IsDebugEnabled: Boolean;
    function IsErrorEnabled: Boolean;
    function IsInfoEnabled: Boolean;
    function IsWarnEnabled: Boolean;
    function IsTraceEnabled: Boolean;

    property Level: TLogLevel read FLevel write FLevel;
  end;

{ TRACE / DEBUG / INFO / WARN / ERROR }
function LevelAsString(const ALevel: TLogLevel): string;

{ AEvent.Message, plus - if AEvent.Exception is assigned - its class name
  and message on two indented lines. This is the exception layout every
  backend used before they shared TLogEvent. }
function FormatEventMessage(const AEvent: ILogEvent): string;

{ Milliseconds elapsed since this process loaded djAbstractLogger - shared
  clock for backends that log elapsed time instead of a timestamp. }
function ElapsedMillis: LongInt;

implementation

const
  MilliSecsPerDay = 24 * 60 * 60 * 1000;

var
  StartTime: TDateTime;

function LevelAsString(const ALevel: TLogLevel): string;
begin
  case ALevel of
    djLogAPI.Trace: Result := 'TRACE';
    djLogAPI.Debug: Result := 'DEBUG';
    djLogAPI.Info:  Result := 'INFO';
    djLogAPI.Warn:  Result := 'WARN';
    djLogAPI.Error: Result := 'ERROR';
  end;
end;

function FormatEventMessage(const AEvent: ILogEvent): string;
begin
  Result := AEvent.Message;
  if Assigned(AEvent.Exception) then
    Result := Result + SLineBreak
      + '  ' + AEvent.Exception.ClassName + SLineBreak
      + '  ' + AEvent.Exception.Message;
end;

function ElapsedMillis: LongInt;
begin
  Result := Round((Now - StartTime) * MilliSecsPerDay);
end;

{ TAbstractLogger }

constructor TAbstractLogger.Create(const AName: string; ALevel: TLogLevel = djLogAPI.Debug);
begin
  inherited Create;
  FName := AName;
  FLevel := ALevel;
end;

function TAbstractLogger.IsEnabledFor(ALevel: TLogLevel): Boolean;
begin
  Result := Ord(FLevel) <= Ord(ALevel);
end;

procedure TAbstractLogger.Log(ALevel: TLogLevel; const AMsg: string);
var
  Event: ILogEvent;
begin
  if IsEnabledFor(ALevel) then
  begin
    Event := TLogEvent.Create(FName, ALevel, AMsg);
    Append(Event);
  end;
end;

procedure TAbstractLogger.Log(ALevel: TLogLevel; const AFormat: string; const AArgs: array of const);
var
  Event: ILogEvent;
begin
  if IsEnabledFor(ALevel) then
  begin
    Event := TLogEvent.Create(FName, ALevel, AFormat, AArgs);
    Append(Event);
  end;
end;

procedure TAbstractLogger.Log(ALevel: TLogLevel; const AMsg: string; const AException: Exception);
var
  Event: ILogEvent;
begin
  if IsEnabledFor(ALevel) then
  begin
    Event := TLogEvent.Create(FName, ALevel, AMsg, AException);
    Append(Event);
  end;
end;

procedure TAbstractLogger.Debug(const AMsg: string);
begin
  Log(djLogAPI.Debug, AMsg);
end;

procedure TAbstractLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  Log(djLogAPI.Debug, AFormat, AArgs);
end;

procedure TAbstractLogger.Debug(const AFormat: string; const AArg: TObject);
begin
  Log(djLogAPI.Debug, AFormat, [ObjectToStr(AArg)]);
end;

procedure TAbstractLogger.Debug(const AMsg: string; const AException: Exception);
begin
  Log(djLogAPI.Debug, AMsg, AException);
end;

procedure TAbstractLogger.Error(const AMsg: string);
begin
  Log(djLogAPI.Error, AMsg);
end;

procedure TAbstractLogger.Error(const AFormat: string; const AArgs: array of const);
begin
  Log(djLogAPI.Error, AFormat, AArgs);
end;

procedure TAbstractLogger.Error(const AFormat: string; const AArg: TObject);
begin
  Log(djLogAPI.Error, AFormat, [ObjectToStr(AArg)]);
end;

procedure TAbstractLogger.Error(const AMsg: string; const AException: Exception);
begin
  Log(djLogAPI.Error, AMsg, AException);
end;

procedure TAbstractLogger.Info(const AMsg: string);
begin
  Log(djLogAPI.Info, AMsg);
end;

procedure TAbstractLogger.Info(const AFormat: string; const AArgs: array of const);
begin
  Log(djLogAPI.Info, AFormat, AArgs);
end;

procedure TAbstractLogger.Info(const AFormat: string; const AArg: TObject);
begin
  Log(djLogAPI.Info, AFormat, [ObjectToStr(AArg)]);
end;

procedure TAbstractLogger.Info(const AMsg: string; const AException: Exception);
begin
  Log(djLogAPI.Info, AMsg, AException);
end;

procedure TAbstractLogger.Warn(const AMsg: string);
begin
  Log(djLogAPI.Warn, AMsg);
end;

procedure TAbstractLogger.Warn(const AFormat: string; const AArgs: array of const);
begin
  Log(djLogAPI.Warn, AFormat, AArgs);
end;

procedure TAbstractLogger.Warn(const AFormat: string; const AArg: TObject);
begin
  Log(djLogAPI.Warn, AFormat, [ObjectToStr(AArg)]);
end;

procedure TAbstractLogger.Warn(const AMsg: string; const AException: Exception);
begin
  Log(djLogAPI.Warn, AMsg, AException);
end;

procedure TAbstractLogger.Trace(const AMsg: string);
begin
  Log(djLogAPI.Trace, AMsg);
end;

procedure TAbstractLogger.Trace(const AFormat: string; const AArgs: array of const);
begin
  Log(djLogAPI.Trace, AFormat, AArgs);
end;

procedure TAbstractLogger.Trace(const AFormat: string; const AArg: TObject);
begin
  Log(djLogAPI.Trace, AFormat, [ObjectToStr(AArg)]);
end;

procedure TAbstractLogger.Trace(const AMsg: string; const AException: Exception);
begin
  Log(djLogAPI.Trace, AMsg, AException);
end;

function TAbstractLogger.Name: string;
begin
  Result := FName;
end;

function TAbstractLogger.IsDebugEnabled: Boolean;
begin
  Result := IsEnabledFor(djLogAPI.Debug);
end;

function TAbstractLogger.IsErrorEnabled: Boolean;
begin
  Result := IsEnabledFor(djLogAPI.Error);
end;

function TAbstractLogger.IsInfoEnabled: Boolean;
begin
  Result := IsEnabledFor(djLogAPI.Info);
end;

function TAbstractLogger.IsWarnEnabled: Boolean;
begin
  Result := IsEnabledFor(djLogAPI.Warn);
end;

function TAbstractLogger.IsTraceEnabled: Boolean;
begin
  Result := IsEnabledFor(djLogAPI.Trace);
end;

initialization
  StartTime := Now;

end.
