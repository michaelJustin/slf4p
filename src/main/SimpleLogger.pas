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

unit SimpleLogger;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  djLogAPI, Classes, SysUtils;

type
  TSimpleLogLevel = (Trace, Debug, Info, Warn, Error);

  { TSimpleLogger }

  TSimpleLogger = class(TInterfacedObject, ILogger)
  private
    FLevel: TSimpleLogLevel;
    FName: string;
    LevelAsString: string;

    function LevelIsGreaterOrEqual(ALogLevel: TSimpleLogLevel): Boolean;

    procedure WriteMsg(const AMsg: string);

    procedure SetLevel(AValue: TSimpleLogLevel);

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

  { TSimpleLoggerFactory }

  TSimpleLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    constructor Create;
    destructor Destroy; override;

    function GetLogger(const AName: string): ILogger;
  end;


procedure Configure(const AStrings: TStrings); overload;

procedure Configure(const AKey, AValue: string); overload;

implementation

type
  { TSimpleLoggerConfiguration }
  TSimpleLoggerConfiguration = class(TObject)
  private
    FLevel: TSimpleLogLevel;
  public
    constructor Create;

    procedure Configure(const AStrings: TStrings); overload;

    procedure Configure(const AKey, AValue: string); overload;

    property Level: TSimpleLogLevel read FLevel;
  end;

const
  MilliSecsPerDay = 24 * 60 * 60 * 1000;

var
  { Contains logger configuration }
  Config: TSimpleLoggerConfiguration;

  { Start time for the logging process - to compute elapsed time. }
  StartTime: TDateTime;

  { The elapsed time since package start up (in milliseconds). }
  function GetElapsedTime: LongInt;
  begin
    Result := Round((Now - StartTime) * MilliSecsPerDay);
  end;

procedure Configure(const AStrings: TStrings);
begin
  Config.Configure(AStrings);
end;

procedure Configure(const AKey, AValue: string);
begin
  Config.Configure(AKey, AValue);
end;

{ TSimpleLoggerConfiguration }

constructor TSimpleLoggerConfiguration.Create;
begin
  FLevel := Info;
end;

procedure TSimpleLoggerConfiguration.Configure(const AStrings: TStrings);
var
  Line: string;
begin
  Line := LowerCase(AStrings.Values['defaultLogLevel']);

  if Line = 'trace' then FLevel := Trace
  else if Line = 'debug' then FLevel := Debug
  else if Line = 'info' then FLevel := Info
  else if Line = 'warn' then FLevel := Warn
  else if Line = 'error' then FLevel := Error
  else WriteLn('unknown log level ' + Line);

end;

procedure TSimpleLoggerConfiguration.Configure(const AKey, AValue: string);
var
  SL: TStrings;
begin
  SL := TStringList.Create;
  try
    SL.Values[AKey] := AValue;
    Configure(SL);
  finally
    SL.Free;
  end;
end;

{ TSimpleLogger }

constructor TSimpleLogger.Create(const AName: string);
begin
  FName := AName;
end;

function TSimpleLogger.LevelIsGreaterOrEqual(ALogLevel: TSimpleLogLevel
  ): Boolean;
begin
  Result := Ord(FLevel) <= Ord(ALogLevel);
end;

procedure TSimpleLogger.WriteMsg(const AMsg: string);
begin
  WriteLn(IntToStr(GetElapsedTime) + ' '
    + LevelAsString + ' '
    + Name + ' - '
    + AMsg);
end;

procedure TSimpleLogger.SetLevel(AValue: TSimpleLogLevel);
begin
  if FLevel=AValue then Exit;

  FLevel:=AValue;

  case Level of
    SimpleLogger.Trace: LevelAsString:= 'TRACE';
    SimpleLogger.Debug: LevelAsString:= 'DEBUG';
    SimpleLogger.Info: LevelAsString:= 'INFO';
    SimpleLogger.Warn: LevelAsString:= 'WARN';
    SimpleLogger.Error: LevelAsString:= 'ERROR';
  end;
end;

procedure TSimpleLogger.Debug(const AMsg: string);
begin
  if IsDebugEnabled then
    WriteMsg(AMsg);
end;

procedure TSimpleLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  if IsDebugEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Debug(const AMsg: string; const AException: Exception);
begin
  if IsDebugEnabled then
  begin
    WriteMsg(AMsg);
    WriteLn(AException.ClassName);
    WriteLn(AException.Message);
  end;
end;

procedure TSimpleLogger.Error(const AMsg: string; const AException: Exception);
begin
  if IsErrorEnabled then
  begin
    WriteMsg(AMsg);
    WriteLn(AException.ClassName);
    WriteLn(AException.Message);
  end;
end;

function TSimpleLogger.Name: string;
begin
  Result := FName;
end;

procedure TSimpleLogger.Error(const AFormat: string;
  const AArgs: array of const);
begin
  if IsErrorEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Error(const AMsg: string);
begin
  if IsErrorEnabled then
    WriteMsg(AMsg);
end;

function TSimpleLogger.IsDebugEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(SimpleLogger.Debug);
end;

function TSimpleLogger.IsErrorEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(SimpleLogger.Error);
end;

function TSimpleLogger.IsInfoEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(SimpleLogger.Info);
end;

function TSimpleLogger.IsTraceEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(SimpleLogger.Trace);
end;

function TSimpleLogger.IsWarnEnabled: Boolean;
begin
  Result := LevelIsGreaterOrEqual(SimpleLogger.Warn);
end;

procedure TSimpleLogger.Info(const AFormat: string;
  const AArgs: array of const);
begin
  if IsInfoEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Info(const AMsg: string);
begin
  if IsInfoEnabled then
    WriteMsg(AMsg);
end;

procedure TSimpleLogger.Info(const AMsg: string; const AException: Exception);
begin
  if IsInfoEnabled then
  begin
    WriteMsg(AMsg);
    WriteLn(AException.ClassName);
    WriteLn(AException.Message);
  end;
end;

procedure TSimpleLogger.Trace(const AMsg: string; const AException: Exception);
begin
  if IsTraceEnabled then
  begin
    WriteMsg(AMsg);
    WriteLn(AException.ClassName);
    WriteLn(AException.Message);
  end;
end;

procedure TSimpleLogger.Trace(const AFormat: string;
  const AArgs: array of const);
begin
  if IsTraceEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Trace(const AMsg: string);
begin
  WriteMsg(AMsg);
end;

procedure TSimpleLogger.Warn(const AMsg: string; const AException: Exception);
begin
  if IsWarnEnabled then
  begin
    WriteMsg(AMsg);
    WriteLn(AException.ClassName);
    WriteLn(AException.Message);
  end;
end;

procedure TSimpleLogger.Warn(const AFormat: string;
  const AArgs: array of const);
begin
  if IsWarnEnabled then
    WriteMsg(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Warn(const AMsg: string);
begin
  if IsWarnEnabled then
    WriteMsg(AMsg);
end;

{ TSimpleLoggerFactory }

constructor TSimpleLoggerFactory.Create;
begin
  inherited Create;

  Config := TSimpleLoggerConfiguration.Create;
end;

destructor TSimpleLoggerFactory.Destroy;
begin
  Config.Free;

  inherited;
end;

function TSimpleLoggerFactory.GetLogger(const AName: string): ILogger;
var
  L: TSimpleLogger;
begin
  L := TSimpleLogger.Create(AName);
  L.Level := Config.Level;
  Result := L;
end;

initialization
  StartTime := Now;

end.
