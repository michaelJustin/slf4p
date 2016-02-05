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
  TSimpleLogLevel = (Trace, Debug, Info, Warn, Error);

  { TLazLoggerLogger }

  TLazLoggerLogger = class(TInterfacedObject, ILogger)
  private
    FLevel: TSimpleLogLevel;
    FName: string;
    LevelAsString: string;

   function LevelIsGreaterOrEqual(ALogLevel: TSimpleLogLevel): Boolean;

   procedure SetLevel(AValue: TSimpleLogLevel);

   procedure WriteMsg(const AMsg: string); overload;
   procedure WriteMsg(const AMsg: string; const AException: Exception); overload;

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

    property Level: TSimpleLogLevel read FLevel write SetLevel;

  end;

  TLazLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    function GetLogger(const AName: string): ILogger;
  end;

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
end;

function TLazLoggerLogger.LevelIsGreaterOrEqual(ALogLevel: TSimpleLogLevel
  ): Boolean;
begin
   Result := Ord(FLevel) <= Ord(ALogLevel);
end;

procedure TLazLoggerLogger.WriteMsg(const AMsg: string);
begin
  LazLogger.DebugLn(
    IntToStr(GetElapsedTime) + ' ' + LevelAsString + ' '
    + Name + ' - '
    + AMsg);
end;

procedure TLazLoggerLogger.WriteMsg(const AMsg: string;
  const AException: Exception);
begin
  WriteMsg(AMsg + SLineBreak
      + SBlanks + AException.ClassName + SLineBreak
      + SBlanks + AException.Message);
end;

procedure TLazLoggerLogger.SetLevel(AValue: TSimpleLogLevel);
begin
  if FLevel=AValue then Exit;

  FLevel:=AValue;

  case Level of
    LazLoggerLogger.Trace: LevelAsString:= 'TRACE';
    LazLoggerLogger.Debug: LevelAsString:= 'DEBUG';
    LazLoggerLogger.Info: LevelAsString:= 'INFO';
    LazLoggerLogger.Warn: LevelAsString:= 'WARN';
    LazLoggerLogger.Error: LevelAsString:= 'ERROR';
  end;
end;

procedure TLazLoggerLogger.Debug(const AMsg: string);
begin
  if IsDebugEnabled then
    WriteMsg(AMsg);
end;

procedure TLazLoggerLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  if IsDebugEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Debug(const AMsg: string; const AException: Exception);
begin
  if IsDebugEnabled then
  begin
    WriteMsg(AMsg, AException);
  end;
end;

procedure TLazLoggerLogger.Error(const AMsg: string; const AException: Exception);
begin
  if IsErrorEnabled then
  begin
    WriteMsg(AMsg, AException);
  end;
end;

procedure TLazLoggerLogger.Error(const AFormat: string;
  const AArgs: array of const);
begin
  if IsErrorEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Error(const AMsg: string);
begin
  if IsErrorEnabled then
    WriteMsg(AMsg);
end;

function TLazLoggerLogger.IsDebugEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(LazLoggerLogger.Debug);
end;

function TLazLoggerLogger.IsErrorEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(LazLoggerLogger.Error);
end;

function TLazLoggerLogger.IsInfoEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(LazLoggerLogger.Info);
end;

function TLazLoggerLogger.IsTraceEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(LazLoggerLogger.Trace);
end;

function TLazLoggerLogger.IsWarnEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(LazLoggerLogger.Warn);
end;

procedure TLazLoggerLogger.Info(const AFormat: string;
  const AArgs: array of const);
begin
  if IsInfoEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Info(const AMsg: string);
begin
  if IsInfoEnabled then
    WriteMsg(AMsg);
end;

procedure TLazLoggerLogger.Info(const AMsg: string; const AException: Exception);
begin
  if IsInfoEnabled then
  begin
    WriteMsg(AMsg, AException);
  end;
end;

procedure TLazLoggerLogger.Trace(const AMsg: string; const AException: Exception);
begin
  if IsTraceEnabled then
  begin
    WriteMsg(AMsg, AException);
  end;
end;

function TLazLoggerLogger.Name: string;
begin
  Result := FName;
end;

procedure TLazLoggerLogger.Trace(const AFormat: string;
  const AArgs: array of const);
begin
  if IsTraceEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Trace(const AMsg: string);
begin
  WriteMsg(AMsg);
end;

procedure TLazLoggerLogger.Warn(const AMsg: string; const AException: Exception);
begin
  if IsWarnEnabled then
  begin
    WriteMsg(AMsg, AException);
  end;
end;

procedure TLazLoggerLogger.Warn(const AFormat: string;
  const AArgs: array of const);
begin
  if IsWarnEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TLazLoggerLogger.Warn(const AMsg: string);
begin
  if IsWarnEnabled then
    WriteMsg(AMsg);
end;

{ TLazLoggerFactory }

function TLazLoggerFactory.GetLogger(const AName: string): ILogger;
begin
  Result := TLazLoggerLogger.Create(AName);
end;

initialization
  StartTime := Now;

end.
