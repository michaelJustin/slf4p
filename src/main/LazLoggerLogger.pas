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

interface

uses
  LazLogger,
  djLogAPI, djAbstractLogger, SysUtils;

type
  { TLazLoggerLogger }

  TLazLoggerLogger = class(TAbstractLogger)
  private
    LogGroup: PLazLoggerLogGroup;

  public
    constructor Create(const AName: string);

    procedure Append(const AEvent: ILogEvent); override;
  end;

  TLazLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    function GetLogger(const AName: string): ILogger;
  end;

var
  DefaultLevel: TLogLevel;

implementation

{ TLazLoggerLogger }

constructor TLazLoggerLogger.Create(const AName: string);
begin
  inherited Create(AName);

  LogGroup := DebugLogger.RegisterLogGroup(AName, True); // always on
  // DebugLogger.ParamForEnabledLogGroups := '--debug-enabled=';
end;

procedure TLazLoggerLogger.Append(const AEvent: ILogEvent);
begin
  LazLogger.DebugLn(
    LogGroup, IntToStr(ElapsedMillis) + ' ' + LevelAsString(AEvent.Level) + ' '
    + Name + ' - ' + FormatEventMessage(AEvent));
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
  DefaultLevel := Debug;

end.
