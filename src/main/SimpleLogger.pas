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
  djLogAPI, djAbstractLogger, Classes, SysUtils;

type
  { TSimpleLogger }

  TSimpleLogger = class(TAbstractLogger)
  strict private
    FDateTimeFormat: string;
    FShowDateTime: Boolean;

    function DateTimeStr: string;
    function NameOrDash: string;

  public
    procedure Append(const AEvent: ILogEvent); override;

    property DateTimeFormat: string read FDateTimeFormat write FDateTimeFormat;
    property ShowDateTime: Boolean read FShowDateTime write FShowDateTime;
  end;

  { TSimpleLoggerFactory }

  TSimpleLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    function GetLogger(const AName: string): ILogger;
  end;


procedure Configure(const AStrings: TStrings); overload;

procedure Configure(const AKey, AValue: string); overload;

implementation

const
  LOG_DATETIME = '[hh:nn:ss.zzz]';

type
  { TSimpleLoggerConfiguration }
  TSimpleLoggerConfiguration = class(TObject)
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

var
  { Contains logger configuration }
  Config: TSimpleLoggerConfiguration;

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
  FLevel := Debug;
  FShowDateTime := True;
  FDateTimeFormat := LOG_DATETIME;
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
    FDateTimeFormat := LOG_DATETIME;
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

function TSimpleLogger.DateTimeStr: string;
begin
  if ShowDateTime and (DateTimeFormat <> '') then
    Result := FormatDateTime(DateTimeFormat, Now)
  else
    Result := IntToStr(ElapsedMillis);
end;

function TSimpleLogger.NameOrDash: string;
begin
  if Name = '' then
    Result := '- '
  else
    Result := Name + ' ';
end;

procedure TSimpleLogger.Append(const AEvent: ILogEvent);
begin
  WriteLn(DateTimeStr + ' '
    + LevelAsString(AEvent.Level) + ' '
    + NameOrDash
    + FormatEventMessage(AEvent));
end;

{ TSimpleLoggerFactory }

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
  Config := TSimpleLoggerConfiguration.Create;

finalization
  Config.Free;

end.
