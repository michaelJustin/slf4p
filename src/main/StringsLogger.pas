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

unit StringBuilderLogger;

interface

uses
  djLogAPI, Classes, SysUtils;

type
  TLogLevel = (Trace, Debug, Info, Warn, Error);

  { TStringsLogger }

  TStringsLogger = class(TInterfacedObject, ILogger)
  private
    FStrings: TStringBuilder;
    FDateTimeFormat: string;
    FLevel: TLogLevel;
    FName: string;
    FShowDateTime: Boolean;

    function GetElapsedTime: LongInt;
    function DateTimeStr: string;
    function LevelAsString(const ALogLevel: TLogLevel): string;

    function IsEnabledFor(ALogLevel: TLogLevel): Boolean;

    procedure WriteMsg(const ALogLevel: TLogLevel; const AMsg: string);
      overload;
    procedure WriteMsg(const ALogLevel: TLogLevel; const AMsg: string;
      const AException: Exception); overload;

    procedure SetLevel(AValue: TLogLevel);

  public
    constructor Create(const AName: string; const AStrings: TStringBuilder);

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

    property DateTimeFormat: string read FDateTimeFormat write FDateTimeFormat;
    property Level: TLogLevel read FLevel write SetLevel;
    property ShowDateTime: Boolean read FShowDateTime write FShowDateTime;
  end;

  { TStringsLoggerFactory }

  TStringsLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  private
    FStrings: TStringBuilder;
  public
    constructor Create(const AStrings: TStringBuilder);
    destructor Destroy; override;

    function GetLogger(const AName: string): ILogger;
  end;

implementation

type
  { TStringsLoggerConfiguration }
  TStringsLoggerConfiguration = class(TObject)
  private
    FDateTimeFormat: string;
    FLevel: TLogLevel;
    FShowDateTime: Boolean;
  public
    constructor Create;

    procedure Configure(const AStrings: TStrings); overload;

    procedure Configure(const AKey, AValue: string); overload;

    property DateTimeFormat: string read FDateTimeFormat;
    property Level: TLogLevel read FLevel;
    property ShowDateTime: Boolean read FShowDateTime;
  end;

resourcestring
  SNoFactory = 'A logger factory must be created before calling Configure';

const
  MilliSecsPerDay = 24 * 60 * 60 * 1000;
  SBlanks = '  ';

var
  { Contains logger configuration }
  Config: TStringsLoggerConfiguration;

  { Start time for the logging process - to compute elapsed time. }
  StartTime: TDateTime;

{ TSimpleLoggerConfiguration }

constructor TStringsLoggerConfiguration.Create;
begin
  FLevel := Info;
end;

procedure TStringsLoggerConfiguration.Configure(const AStrings: TStrings);
var
  Line: string;
begin
  Line := LowerCase(AStrings.Values['defaultLogLevel']);
  if Line <> '' then
  begin
    if Line = 'trace' then FLevel := Trace
    else if Line = 'debug' then FLevel := Debug
    else if Line = 'info' then FLevel := Info
    else if Line = 'warn' then FLevel := Warn
    else if Line = 'error' then FLevel := Error;
  end;

  Line := LowerCase(AStrings.Values['showDateTime']);
  if Line <> '' then
  begin
    FShowDateTime := (Line = 'true');
    FDateTimeFormat := 'hh:nn:ss.zzz';
  end;

  Line := LowerCase(AStrings.Values['dateTimeFormat']);
  if Line <> '' then
  begin
    try
      FormatDateTime(Line, Now);
      FDateTimeFormat := Line;
    except
      on E: Exception do
      begin
        FDateTimeFormat := '';
      end;
    end;
  end;
end;

procedure TStringsLoggerConfiguration.Configure(const AKey, AValue: string);
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

{ TStringsLogger }

constructor TStringsLogger.Create(const AName: string;
  const AStrings: TStringBuilder);
begin
  FName := AName;
  FStrings := AStrings;
end;

function TStringsLogger.LevelAsString(const ALogLevel: TLogLevel): string;
begin
  case ALogLevel of
    StringBuilderLogger.Trace: Result := 'TRACE';
    StringBuilderLogger.Debug: Result := 'DEBUG';
    StringBuilderLogger.Info: Result := 'INFO';
    StringBuilderLogger.Warn: Result := 'WARN';
    StringBuilderLogger.Error: Result := 'ERROR';
  end;
end;

function TStringsLogger.IsEnabledFor(ALogLevel: TLogLevel): Boolean;
begin
  Result := Ord(FLevel) <= Ord(ALogLevel);
end;

procedure TStringsLogger.WriteMsg(const ALogLevel: TLogLevel; const AMsg: string);
begin
  FStrings.Append(LevelAsString(ALogLevel) + ' ' + Name + ' - ' + AMsg);
end;

function TStringsLogger.DateTimeStr: string;
begin
  if ShowDateTime and (DateTimeFormat <> '') then
    Result := FormatDateTime(DateTimeFormat, Now)
  else
    Result := IntToStr(GetElapsedTime);
end;

{ The elapsed time since package start up (in milliseconds). }
function TStringsLogger.GetElapsedTime: LongInt;
begin
  Result := Round((Now - StartTime) * MilliSecsPerDay);
end;

procedure TStringsLogger.WriteMsg(const ALogLevel: TLogLevel; const AMsg: string;
  const AException: Exception);
begin
  WriteMsg(ALogLevel,
        AMsg + SLineBreak
      + SBlanks + AException.ClassName + SLineBreak
      + SBlanks + AException.Message);
end;

procedure TStringsLogger.SetLevel(AValue: TLogLevel);
begin
  if FLevel = AValue then Exit;

  FLevel := AValue;
end;

procedure TStringsLogger.Debug(const AMsg: string);
begin
  if IsDebugEnabled then
    WriteMsg(StringBuilderLogger.Debug, AMsg);
end;

procedure TStringsLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  if IsDebugEnabled then
    WriteMsg(StringBuilderLogger.Debug, Format(AFormat, AArgs));
end;

procedure TStringsLogger.Debug(const AMsg: string; const AException: Exception);
begin
  if IsDebugEnabled then
    WriteMsg(StringBuilderLogger.Debug, AMsg, AException);
end;

procedure TStringsLogger.Error(const AMsg: string; const AException: Exception);
begin
  if IsErrorEnabled then
    WriteMsg(StringBuilderLogger.Error, AMsg, AException);
end;

function TStringsLogger.Name: string;
begin
  Result := FName;
end;

procedure TStringsLogger.Error(const AFormat: string;
  const AArgs: array of const);
begin
  if IsErrorEnabled then
    WriteMsg(StringBuilderLogger.Error, Format(AFormat, AArgs));
end;

procedure TStringsLogger.Error(const AMsg: string);
begin
  if IsErrorEnabled then
    WriteMsg(StringBuilderLogger.Error, AMsg);
end;

function TStringsLogger.IsDebugEnabled: Boolean;
begin
  Result := IsEnabledFor(StringBuilderLogger.Debug);
end;

function TStringsLogger.IsErrorEnabled: Boolean;
begin
  Result := IsEnabledFor(StringBuilderLogger.Error);
end;

function TStringsLogger.IsInfoEnabled: Boolean;
begin
  Result := IsEnabledFor(StringBuilderLogger.Info);
end;

function TStringsLogger.IsTraceEnabled: Boolean;
begin
  Result := IsEnabledFor(StringBuilderLogger.Trace);
end;

function TStringsLogger.IsWarnEnabled: Boolean;
begin
  Result := IsEnabledFor(StringBuilderLogger.Warn);
end;

procedure TStringsLogger.Info(const AFormat: string;
  const AArgs: array of const);
begin
  if IsInfoEnabled then
    WriteMsg(StringBuilderLogger.Info, Format(AFormat, AArgs));
end;

procedure TStringsLogger.Info(const AMsg: string);
begin
  if IsInfoEnabled then
    WriteMsg(StringBuilderLogger.Info, AMsg);
end;

procedure TStringsLogger.Info(const AMsg: string; const AException: Exception);
begin
  if IsInfoEnabled then
    WriteMsg(StringBuilderLogger.Info, AMsg, AException);
end;

procedure TStringsLogger.Trace(const AMsg: string; const AException: Exception);
begin
  if IsTraceEnabled then
    WriteMsg(StringBuilderLogger.Trace, AMsg, AException);
end;

procedure TStringsLogger.Trace(const AFormat: string;
  const AArgs: array of const);
begin
  if IsTraceEnabled then
    WriteMsg(StringBuilderLogger.Trace, Format(AFormat, AArgs));
end;

procedure TStringsLogger.Trace(const AMsg: string);
begin
  if IsTraceEnabled then
    WriteMsg(StringBuilderLogger.Trace, AMsg);
end;

procedure TStringsLogger.Warn(const AMsg: string; const AException: Exception);
begin
  if IsWarnEnabled then
    WriteMsg(StringBuilderLogger.Warn, AMsg, AException);
end;

procedure TStringsLogger.Warn(const AFormat: string;
  const AArgs: array of const);
begin
  if IsWarnEnabled then
    WriteMsg(StringBuilderLogger.Warn, Format(AFormat, AArgs));
end;

procedure TStringsLogger.Warn(const AMsg: string);
begin
  if IsWarnEnabled then
    WriteMsg(StringBuilderLogger.Warn, AMsg);
end;

{ TStringsLoggerFactory }

constructor TStringsLoggerFactory.Create(const AStrings: TStringBuilder);
begin
  inherited Create;

  FStrings := AStrings;
end;

destructor TStringsLoggerFactory.Destroy;
begin

  inherited;
end;

function TStringsLoggerFactory.GetLogger(const AName: string): ILogger;
var
  Logger: TStringsLogger;
begin
  Logger := TStringsLogger.Create(AName, FStrings);

  Logger.DateTimeFormat := Config.DateTimeFormat;
  Logger.Level := Config.Level;
  Logger.ShowDateTime := Config.ShowDateTime;

  Result := Logger;
end;

initialization
  StartTime := Now;
  Config := TStringsLoggerConfiguration.Create;

finalization
  Config.Free;

end.

