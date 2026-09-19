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

unit djLogAPI;

interface

uses
  SysUtils;

const
  SLF4P_VERSION = '1.1.0-SNAPSHOT';

type
  TLogLevel = (Trace, Debug, Info, Warn, Error);

  { An array of the format arguments passed to a log call, captured as
    strings so they outlive the caller's stack frame. }
  TLogEventArgs = array of string;

  { A single log call, encapsulating its level, logger name, formatted
    message, format arguments and exception (if any). }
  ILogEvent = interface ['{9B2A5E10-6C3D-4B8E-9A1F-3D2C7E4A8F01}']
    function GetLevel: TLogLevel;
    function GetLoggerName: string;
    function GetMessage: string;
    function GetArgs: TLogEventArgs;
    function GetTimeStamp: TDateTime;
    function GetException: Exception;

    property Level: TLogLevel read GetLevel;
    property LoggerName: string read GetLoggerName;
    property Message: string read GetMessage;

    { What's this good for? Message already holds the fully formatted
      string; Args keeps the individual values alongside it so a future
      appender can treat the call as structured data instead of an opaque
      string - e.g. group/aggregate log calls by template regardless of
      argument values, emit machine-parseable fields (JSON, ELK, ...), or
      redact specific arguments. No built-in appender uses this yet
      (decide later whether to keep it, or drop it and rely on Message
      alone, once a real consumer exists). }
    property Args: TLogEventArgs read GetArgs;

    property TimeStamp: TDateTime read GetTimeStamp;
    property Exception: Exception read GetException;
  end;

  TLogEvent = class(TInterfacedObject, ILogEvent)
  strict private
    FLevel: TLogLevel;
    FLoggerName: string;
    FMessage: string;
    FArgs: TLogEventArgs;
    FTimeStamp: TDateTime;
    FException: Exception;
  protected
    function GetLevel: TLogLevel;
    function GetLoggerName: string;
    function GetMessage: string;
    function GetArgs: TLogEventArgs;
    function GetTimeStamp: TDateTime;
    function GetException: Exception;
  public
    { Message-only / exception constructor (no format args) }
    constructor Create(const ALoggerName: string; ALevel: TLogLevel;
      const AMsg: string; const AException: Exception = nil); overload;

    { Format-args constructor: message is formatted eagerly, args are
      captured as strings so they outlive the caller's stack frame }
    constructor Create(const ALoggerName: string; ALevel: TLogLevel;
      const AFormat: string; const AArgs: array of const;
      const AException: Exception = nil); overload;
  end;

  ILogger = interface ['{58764670-2414-477F-8CE6-02A418D4CF09}']
    procedure Trace(const AMsg: string); overload;
    procedure Trace(const AFormat: string; const AArgs: array of const); overload;
    procedure Trace(const AFormat: string; const AArg: TObject); overload;
    procedure Trace(const AFormat: string; const AArg1, AArg2: TObject); overload;
    procedure Trace(const AMsg: string; const AException: Exception); overload;

    procedure Debug(const AMsg: string); overload;
    procedure Debug(const AFormat: string; const AArgs: array of const); overload;
    procedure Debug(const AFormat: string; const AArg: TObject); overload;
    procedure Debug(const AFormat: string; const AArg1, AArg2: TObject); overload;
    procedure Debug(const AMsg: string; const AException: Exception); overload;

    procedure Info(const AMsg: string); overload;
    procedure Info(const AFormat: string; const AArgs: array of const); overload;
    procedure Info(const AFormat: string; const AArg: TObject); overload;
    procedure Info(const AFormat: string; const AArg1, AArg2: TObject); overload;
    procedure Info(const AMsg: string; const AException: Exception); overload;

    procedure Warn(const AMsg: string); overload;
    procedure Warn(const AFormat: string; const AArgs: array of const); overload;
    procedure Warn(const AFormat: string; const AArg: TObject); overload;
    procedure Warn(const AFormat: string; const AArg1, AArg2: TObject); overload;
    procedure Warn(const AMsg: string; const AException: Exception); overload;

    procedure Error(const AMsg: string); overload;
    procedure Error(const AFormat: string; const AArgs: array of const); overload;
    procedure Error(const AFormat: string; const AArg: TObject); overload;
    procedure Error(const AFormat: string; const AArg1, AArg2: TObject); overload;
    procedure Error(const AMsg: string; const AException: Exception); overload;

    function IsTraceEnabled: Boolean;
    function IsDebugEnabled: Boolean;
    function IsInfoEnabled: Boolean;
    function IsWarnEnabled: Boolean;
    function IsErrorEnabled: Boolean;

    function Name: string;

  end;

  { Optional extension point for appenders that want the raw log event,
    e.g. backends that support structured/contextual logging. }
  ILogEventAppender = interface ['{4F1E9C22-7B6A-4D5E-9C3A-1B2D6E7F9A02}']
    procedure Append(const AEvent: ILogEvent);
  end;

  ILoggerFactory = interface ['{B5EC64AC-85D6-40F1-88CC-EC045D9ED653}']
    function GetLogger(const AName: string): ILogger;
  end;

{ AObj.ToString, or 'nil' if AObj is not assigned. Used to turn the single-
  object ILogger overloads into a plain string before formatting, since
  SysUtils.Format itself does not support a "%s" argument of type TObject.
  TObject.ToString defaults to the class name but can be overridden, so
  callers get a more meaningful representation than ClassName alone when
  their class provides one. }
function ObjectToStr(AObj: TObject): string;

{ Format(AFormat, AArgs), or - if the format string and arguments don't
  match (wrong placeholder count/type etc.) - AFormat with the resulting
  exception's message appended, so a malformed log call never propagates
  an exception into the caller. }
function SafeFormat(const AFormat: string; const AArgs: array of const): string;

implementation

function ObjectToStr(AObj: TObject): string;
begin
  if Assigned(AObj) then
    Result := AObj.ToString
  else
    Result := 'nil';
end;

function SafeFormat(const AFormat: string; const AArgs: array of const): string;
begin
  try
    Result := Format(AFormat, AArgs);
  except
    on E: Exception do
      Result := AFormat + ' [FORMAT ERROR: ' + E.Message + ']';
  end;
end;

{ Converts a single TVarRec, as produced by an "array of const" literal, to
  its string representation. }
function VarRecToStr(const AValue: TVarRec): string;
begin
  case AValue.VType of
    vtInteger:    Result := IntToStr(AValue.VInteger);
    vtInt64:      Result := IntToStr(AValue.VInt64^);
    vtBoolean:    Result := BoolToStr(AValue.VBoolean, True);
    vtChar:       Result := string(AValue.VChar);
    vtWideChar:   Result := AValue.VWideChar;
    vtExtended:   Result := FloatToStr(AValue.VExtended^);
    vtCurrency:   Result := CurrToStr(AValue.VCurrency^);
    vtString:     Result := string(AValue.VString^);
    vtPChar:      Result := string(AValue.VPChar);
    vtAnsiString: Result := string(AnsiString(AValue.VAnsiString));
    vtWideString: Result := string(WideString(AValue.VWideString));
    vtUnicodeString: Result := string(AValue.VUnicodeString);
    vtObject:     Result := ObjectToStr(AValue.VObject);
    vtPointer:    Result := IntToHex(NativeInt(AValue.VPointer), SizeOf(Pointer) * 2);
  else
    Result := '';
  end;
end;

constructor TLogEvent.Create(const ALoggerName: string; ALevel: TLogLevel;
  const AMsg: string; const AException: Exception = nil);
begin
  inherited Create;
  FLoggerName := ALoggerName;
  FLevel := ALevel;
  FMessage := AMsg;
  FTimeStamp := Now;
  FException := AException;
end;

constructor TLogEvent.Create(const ALoggerName: string; ALevel: TLogLevel;
  const AFormat: string; const AArgs: array of const;
  const AException: Exception = nil);
var
  I: Integer;
begin
  inherited Create;
  FLoggerName := ALoggerName;
  FLevel := ALevel;
  FTimeStamp := Now;
  FException := AException;

  SetLength(FArgs, Length(AArgs));
  for I := 0 to High(AArgs) do
    FArgs[I] := VarRecToStr(AArgs[I]);

  FMessage := SafeFormat(AFormat, AArgs);
end;

function TLogEvent.GetLevel: TLogLevel;
begin
  Result := FLevel;
end;

function TLogEvent.GetLoggerName: string;
begin
  Result := FLoggerName;
end;

function TLogEvent.GetMessage: string;
begin
  Result := FMessage;
end;

function TLogEvent.GetArgs: TLogEventArgs;
begin
  Result := FArgs;
end;

function TLogEvent.GetTimeStamp: TDateTime;
begin
  Result := FTimeStamp;
end;

function TLogEvent.GetException: Exception;
begin
  Result := FException;
end;

end.