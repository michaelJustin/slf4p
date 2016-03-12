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

interface

uses
  djLogAPI, Classes, SysUtils;

type
  TSimpleLogLevel = (Trace, Debug, Info, Warn, Error);

  { TSimpleLogger }

  TSimpleLogger = class(TInterfacedObject, ILogger)
  private
    FDateTimeFormat: string;
    FLevel: TSimpleLogLevel;
    FName: string;
    FShowDateTime: Boolean;

    function GetElapsedTime: LongInt;
    function DateTimeStr: string;
    function LevelAsString(const ALogLevel: TSimpleLogLevel): string;

    function IsEnabledFor(ALogLevel: TSimpleLogLevel): Boolean;

    procedure WriteMsg(const ALogLevel: TSimpleLogLevel; const AMsg: string);
      overload;
    procedure WriteMsg(const ALogLevel: TSimpleLogLevel; const AMsg: string;
      const AException: Exception); overload;

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

    property DateTimeFormat: string read FDateTimeFormat write FDateTimeFormat;
    property Level: TSimpleLogLevel read FLevel write SetLevel;
    property ShowDateTime: Boolean read FShowDateTime write FShowDateTime;
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
    FDateTimeFormat: string;
    FLevel: TSimpleLogLevel;
    FShowDateTime: Boolean;
  public
    constructor Create;

    procedure Configure(const AStrings: TStrings); overload;

    procedure Configure(const AKey, AValue: string); overload;

    property DateTimeFormat: string read FDateTimeFormat;
    property Level: TSimpleLogLevel read FLevel;
    property ShowDateTime: Boolean read FShowDateTime;
  end;

resourcestring
  SNoFactory = 'A logger factory must be created before calling Configure';

const
  MilliSecsPerDay = 24 * 60 * 60 * 1000;
  SBlanks = '  ';

var
  { Contains logger configuration }
  Config: TSimpleLoggerConfiguration;

  { Start time for the logging process - to compute elapsed time. }
  StartTime: TDateTime;

procedure Configure(const AStrings: TStrings);
begin
  Assert(Assigned(Config), SNoFactory);

  Config.Configure(AStrings);
end;

procedure Configure(const AKey, AValue: string);
begin
  Assert(Assigned(Config), SNoFactory);

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

function TSimpleLogger.LevelAsString(const ALogLevel: TSimpleLogLevel): string;
begin
  case ALogLevel of
    SimpleLogger.Trace: Result := 'TRACE';
    SimpleLogger.Debug: Result := 'DEBUG';
    SimpleLogger.Info: Result := 'INFO';
    SimpleLogger.Warn: Result := 'WARN';
    SimpleLogger.Error: Result := 'ERROR';
  end;
end;

function TSimpleLogger.IsEnabledFor(ALogLevel: TSimpleLogLevel): Boolean;
begin
  Result := Ord(FLevel) <= Ord(ALogLevel);
end;

procedure TSimpleLogger.WriteMsg(const ALogLevel: TSimpleLogLevel; const AMsg: string);
begin
  WriteLn(DateTimeStr + ' '
    + LevelAsString(ALogLevel) + ' '
    + Name + ' - '
    + AMsg);
end;

function TSimpleLogger.DateTimeStr: string;
begin
  if ShowDateTime and (DateTimeFormat <> '') then
    Result := FormatDateTime(DateTimeFormat, Now)
  else
    Result := IntToStr(GetElapsedTime);
end;

{ The elapsed time since package start up (in milliseconds). }
function TSimpleLogger.GetElapsedTime: LongInt;
begin
  Result := Round((Now - StartTime) * MilliSecsPerDay);
end;

procedure TSimpleLogger.WriteMsg(const ALogLevel: TSimpleLogLevel; const AMsg: string;
  const AException: Exception);
begin
  WriteMsg(ALogLevel,
        AMsg + SLineBreak
      + SBlanks + AException.ClassName + SLineBreak
      + SBlanks + AException.Message);
end;

procedure TSimpleLogger.SetLevel(AValue: TSimpleLogLevel);
begin
  if FLevel = AValue then Exit;

  FLevel := AValue;
end;

procedure TSimpleLogger.Debug(const AMsg: string);
begin
  if IsDebugEnabled then
    WriteMsg(SimpleLogger.Debug, AMsg);
end;

procedure TSimpleLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  if IsDebugEnabled then
    WriteMsg(SimpleLogger.Debug, Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Debug(const AMsg: string; const AException: Exception);
begin
  if IsDebugEnabled then
    WriteMsg(SimpleLogger.Debug, AMsg, AException);
end;

procedure TSimpleLogger.Error(const AMsg: string; const AException: Exception);
begin
  if IsErrorEnabled then
    WriteMsg(SimpleLogger.Error, AMsg, AException);
end;

function TSimpleLogger.Name: string;
begin
  Result := FName;
end;

procedure TSimpleLogger.Error(const AFormat: string;
  const AArgs: array of const);
begin
  if IsErrorEnabled then
    WriteMsg(SimpleLogger.Error, Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Error(const AMsg: string);
begin
  if IsErrorEnabled then
    WriteMsg(SimpleLogger.Error, AMsg);
end;

function TSimpleLogger.IsDebugEnabled: Boolean;
begin
  Result := IsEnabledFor(SimpleLogger.Debug);
end;

function TSimpleLogger.IsErrorEnabled: Boolean;
begin
  Result := IsEnabledFor(SimpleLogger.Error);
end;

function TSimpleLogger.IsInfoEnabled: Boolean;
begin
  Result := IsEnabledFor(SimpleLogger.Info);
end;

function TSimpleLogger.IsTraceEnabled: Boolean;
begin
  Result := IsEnabledFor(SimpleLogger.Trace);
end;

function TSimpleLogger.IsWarnEnabled: Boolean;
begin
  Result := IsEnabledFor(SimpleLogger.Warn);
end;

procedure TSimpleLogger.Info(const AFormat: string;
  const AArgs: array of const);
begin
  if IsInfoEnabled then
    WriteMsg(SimpleLogger.Info, Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Info(const AMsg: string);
begin
  if IsInfoEnabled then
    WriteMsg(SimpleLogger.Info, AMsg);
end;

procedure TSimpleLogger.Info(const AMsg: string; const AException: Exception);
begin
  if IsInfoEnabled then
    WriteMsg(SimpleLogger.Info, AMsg, AException);
end;

procedure TSimpleLogger.Trace(const AMsg: string; const AException: Exception);
begin
  if IsTraceEnabled then
    WriteMsg(SimpleLogger.Trace, AMsg, AException);
end;

procedure TSimpleLogger.Trace(const AFormat: string;
  const AArgs: array of const);
begin
  if IsTraceEnabled then
    WriteMsg(SimpleLogger.Trace, Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Trace(const AMsg: string);
begin
  if IsTraceEnabled then
    WriteMsg(SimpleLogger.Trace, AMsg);
end;

procedure TSimpleLogger.Warn(const AMsg: string; const AException: Exception);
begin
  if IsWarnEnabled then
    WriteMsg(SimpleLogger.Warn, AMsg, AException);
end;

procedure TSimpleLogger.Warn(const AFormat: string;
  const AArgs: array of const);
begin
  if IsWarnEnabled then
    WriteMsg(SimpleLogger.Warn, Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Warn(const AMsg: string);
begin
  if IsWarnEnabled then
    WriteMsg(SimpleLogger.Warn, AMsg);
end;

{ TSimpleLoggerFactory }

constructor TSimpleLoggerFactory.Create;
begin
  inherited Create;

end;

destructor TSimpleLoggerFactory.Destroy;
begin

  inherited;
end;

function TSimpleLoggerFactory.GetLogger(const AName: string): ILogger;
var
  Logger: TSimpleLogger;
begin
  Logger := TSimpleLogger.Create(AName);

  Logger.DateTimeFormat := Config.DateTimeFormat;
  Logger.Level := Config.Level;
  Logger.ShowDateTime := Config.ShowDateTime;

  Result := Logger;
end;

initialization
  StartTime := Now;
  Config := TSimpleLoggerConfiguration.Create;

finalization
  Config.Free;

end.
