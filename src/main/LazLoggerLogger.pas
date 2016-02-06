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

unit LazLoggerLogger;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  LazLogger,
  djLogAPI, SysUtils;

type
  TLazLogLevel = (Trace, Debug, Info, Warn, Error);

  { TLazLoggerLogger }

  TLazLoggerLogger = class(TInterfacedObject, ILogger)
  private
    FLevel: TLazLogLevel;

    FName: string;

    LogGroup: PLazLoggerLogGroup;

    function LevelAsString(const ALogLevel: TLazLogLevel): string;

    function IsEnabledFor(ALogLevel: TLazLogLevel): Boolean;

    procedure SetLevel(AValue: TLazLogLevel);

    procedure WriteMsg(const ALogLevel: TLazLogLevel; const AMsg: string); overload;
    procedure WriteMsg(const ALogLevel: TLazLogLevel; const AMsg: string; const AException: Exception); overload;

  public
    constructor Create(const AName: string);

    procedure Debug(const AMsg: string); overload;
    procedure Debug(const AFormat: string; const AArgs: array of const); overload;
    procedure Debug(const AMsg: string; const AException: Exception); overload;

    procedure Error(const AMsg: string); overload;
    procedure Error(const AFormat: string; const AArgs: array of const); overload;
    procedure Error(const AMsg: string; const AException: Exception); overload;

    procedure Info(const AMsg: string); overload;
    procedure Info(const AFormat: string; const AArgs: array of const); overload;
    procedure Info(const AMsg: string; const AException: Exception); overload;

    procedure Warn(const AMsg: string); overload;
    procedure Warn(const AFormat: string; const AArgs: array of const); overload;
    procedure Warn(const AMsg: string; const AException: Exception); overload;

    procedure Trace(const AMsg: string); overload;
    procedure Trace(const AFormat: string; const AArgs: array of const); overload;
    procedure Trace(const AMsg: string; const AException: Exception); overload;

    function Name: string;

    function IsDebugEnabled: Boolean;
    function IsErrorEnabled: Boolean;
    function IsInfoEnabled: Boolean;
    function IsWarnEnabled: Boolean;
    function IsTraceEnabled: Boolean;

    property Level: TLazLogLevel read FLevel write SetLevel;

  end;

  TLazLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    function GetLogger(const AName: string): ILogger;
  end;

var
  DefaultLevel: TLazLogLevel;

implementation

const
  MilliSecsPerDay = 24 * 60 * 60 * 1000;
  SBlanks = '  ';

var
  { Start time for the logging process - to compute elapsed time. }
  StartTime: TDateTime;

{ The elapsed time since package start up (in milliseconds). }
function GetElapsedTime: LongInt;
begin
  Result := Round((Now - StartTime) * MilliSecsPerDay);
end;

{ TLazLoggerLogger }

constructor TLazLoggerLogger.Create(const AName: string);
begin
  FName := AName;

  LogGroup := DebugLogger.RegisterLogGroup(AName, False);
  DebugLogger.ParamForEnabledLogGroups := '--debug-enabled=';
end;

function TLazLoggerLogger.LevelAsString(const ALogLevel: TLazLogLevel): string;
begin
  case ALogLevel of
    LazLoggerLogger.Trace: LevelAsString := 'TRACE';
    LazLoggerLogger.Debug: LevelAsString := 'DEBUG';
    LazLoggerLogger.Info: LevelAsString := 'INFO';
    LazLoggerLogger.Warn: LevelAsString := 'WARN';
    LazLoggerLogger.Error: LevelAsString := 'ERROR';
  end;
end;

function TLazLoggerLogger.IsEnabledFor(ALogLevel: TLazLogLevel
  ): Boolean;
begin
   Result := Ord(FLevel) <= Ord(ALogLevel);
end;

procedure TLazLoggerLogger.WriteMsg(const ALogLevel: TLazLogLevel; const AMsg: string);
begin
  LazLogger.DebugLn(
    LogGroup, IntToStr(GetElapsedTime) + ' ' + LevelAsString(ALogLevel) + ' '
    + Name + ' - ' + AMsg);
end;

procedure TLazLoggerLogger.WriteMsg(const ALogLevel: TLazLogLevel; const AMsg: string;
  const AException: Exception);
begin
  WriteMsg(ALogLevel,
    AMsg + SLineBreak
    + SBlanks + AException.ClassName + SLineBreak
    + SBlanks + AException.Message);
end;

procedure TLazLoggerLogger.SetLevel(AValue: TLazLogLevel);
begin
  if FLevel = AValue then Exit;

  FLevel := AValue;
end;

procedure TLazLoggerLogger.Debug(const AMsg: string);
begin
  if IsDebugEnabled then
    WriteMsg(LazLoggerLogger.Debug, AMsg);
end;

procedure TLazLoggerLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  if IsDebugEnabled then
    WriteMsg(LazLoggerLogger.Debug, Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Debug(const AMsg: string; const AException: Exception);
begin
  if IsDebugEnabled then
    WriteMsg(LazLoggerLogger.Debug, AMsg, AException);
end;

procedure TLazLoggerLogger.Error(const AMsg: string; const AException: Exception);
begin
  if IsErrorEnabled then
    WriteMsg(LazLoggerLogger.Error, AMsg, AException);
end;

procedure TLazLoggerLogger.Error(const AFormat: string;
  const AArgs: array of const);
begin
  if IsErrorEnabled then
    WriteMsg(LazLoggerLogger.Error, Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Error(const AMsg: string);
begin
  if IsErrorEnabled then
    WriteMsg(LazLoggerLogger.Error, AMsg);
end;

function TLazLoggerLogger.IsDebugEnabled: Boolean;
begin
  Result := IsEnabledFor(LazLoggerLogger.Debug);
end;

function TLazLoggerLogger.IsErrorEnabled: Boolean;
begin
  Result := IsEnabledFor(LazLoggerLogger.Error);
end;

function TLazLoggerLogger.IsInfoEnabled: Boolean;
begin
  Result := IsEnabledFor(LazLoggerLogger.Info);
end;

function TLazLoggerLogger.IsTraceEnabled: Boolean;
begin
  Result := IsEnabledFor(LazLoggerLogger.Trace);
end;

function TLazLoggerLogger.IsWarnEnabled: Boolean;
begin
  Result := IsEnabledFor(LazLoggerLogger.Warn);
end;

procedure TLazLoggerLogger.Info(const AFormat: string;
  const AArgs: array of const);
begin
  if IsInfoEnabled then
    WriteMsg(LazLoggerLogger.Info, Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Info(const AMsg: string);
begin
  if IsInfoEnabled then
    WriteMsg(LazLoggerLogger.Info, AMsg);
end;

procedure TLazLoggerLogger.Info(const AMsg: string; const AException: Exception);
begin
  if IsInfoEnabled then
    WriteMsg(LazLoggerLogger.Info, AMsg, AException);
end;

procedure TLazLoggerLogger.Trace(const AMsg: string; const AException: Exception);
begin
  if IsTraceEnabled then
    WriteMsg(LazLoggerLogger.Trace, AMsg, AException);
end;

function TLazLoggerLogger.Name: string;
begin
  Result := FName;
end;

procedure TLazLoggerLogger.Trace(const AFormat: string;
  const AArgs: array of const);
begin
  if IsTraceEnabled then
    WriteMsg(LazLoggerLogger.Trace, Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Trace(const AMsg: string);
begin
  if IsTraceEnabled then
    WriteMsg(LazLoggerLogger.Trace, AMsg);
end;

procedure TLazLoggerLogger.Warn(const AMsg: string; const AException: Exception);
begin
  if IsWarnEnabled then
    WriteMsg(LazLoggerLogger.Warn, AMsg, AException);
end;

procedure TLazLoggerLogger.Warn(const AFormat: string;
  const AArgs: array of const);
begin
  if IsWarnEnabled then
    WriteMsg(LazLoggerLogger.Warn, Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Warn(const AMsg: string);
begin
  if IsWarnEnabled then
    WriteMsg(LazLoggerLogger.Warn, AMsg);
end;

{ TLazLoggerFactory }

function TLazLoggerFactory.GetLogger(const AName: string): ILogger;
var
  Logger: TLazLoggerLogger;
begin
  Logger := TLazLoggerLogger.Create(AName);
  Logger.Level := DefaultLevel;
  Result := Logger;
end;

initialization
  StartTime := Now;
  DefaultLevel:= Info;

end.
