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

unit StringsLogger;

interface

uses
  djLogAPI, djAbstractLogger, Classes, SysUtils;

type
  { TStringsLogger }

  TStringsLogger = class(TAbstractLogger)
  strict private
    FStrings: TStringBuilder;
    FDateTimeFormat: string;
    FShowDateTime: Boolean;

    function DateTimeStr: string;

  public
    constructor Create(const AName: string; const AStrings: TStringBuilder);

    procedure Append(const AEvent: ILogEvent); override;

    property DateTimeFormat: string read FDateTimeFormat write FDateTimeFormat;
    property ShowDateTime: Boolean read FShowDateTime write FShowDateTime;
  end;

  { TStringsLoggerFactory }

  TStringsLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  strict private
    FStrings: TStringBuilder;
  public
    constructor Create(const AStrings: TStringBuilder);

    function GetLogger(const AName: string): ILogger;
  end;


procedure Configure(const AStrings: TStrings); overload;

procedure Configure(const AKey, AValue: string); overload;

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

var
  { Contains logger configuration }
  Config: TStringsLoggerConfiguration;

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

{ TStringsLoggerConfiguration }

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
  inherited Create(AName);

  FStrings := AStrings;
end;

function TStringsLogger.DateTimeStr: string;
begin
  if ShowDateTime and (DateTimeFormat <> '') then
    Result := FormatDateTime(DateTimeFormat, Now)
  else
    Result := IntToStr(ElapsedMillis);
end;

procedure TStringsLogger.Append(const AEvent: ILogEvent);
begin
  if Config.ShowDateTime then
    FStrings.Append(DateTimeStr + ' ');

  FStrings.Append(LevelAsString(AEvent.Level) + ' ' + Name + ' - '
    + FormatEventMessage(AEvent) + sLinebreak);
end;

{ TStringsLoggerFactory }

constructor TStringsLoggerFactory.Create(const AStrings: TStringBuilder);
begin
  inherited Create;

  FStrings := AStrings;
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
  Config := TStringsLoggerConfiguration.Create;

finalization
  Config.Free;

end.
