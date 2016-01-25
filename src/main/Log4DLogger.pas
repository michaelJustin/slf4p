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

unit Log4DLogger;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Log4D,
  djLogAPI, SysUtils;

type
  TLog4DLogger = class(TInterfacedObject, ILogger)
  private
    Delegate: TLogLogger;

    procedure Log(const ALevel: TLogLevel; const AMsg: string); overload;
    procedure Log(const ALevel: TLogLevel; const AFormat: string; const AArgs: array of const); overload;

  public
    constructor Create(const AName: string);

    procedure Debug(const AMsg: string); overload;
    procedure Debug(const AFormat: string; const AArgs: array of const); overload;
    procedure Debug(const AMsg: string; const AException: Exception); overload;

  end;

  TLog4DLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    function GetLogger(const AName: string): ILogger;
  end;

implementation

{ TLog4DLogger }

constructor TLog4DLogger.Create(const AName: string);
begin
  inherited Create;

  Delegate := TLogLogger.GetLogger(AName);
end;

procedure TLog4DLogger.Log(const ALevel: TLogLevel; const AMsg: string);
begin
  Delegate.Log(ALevel, AMsg);
end;

procedure TLog4DLogger.Log(const ALevel: TLogLevel; const AFormat: string;
  const AArgs: array of const);
begin
  if Delegate.IsEnabledFor(ALevel) then
    Delegate.Log(ALevel, Format(AFormat, AArgs));
end;

procedure TLog4DLogger.Debug(const AMsg: string);
begin
  Log(Log4D.Debug, AMsg);
end;

procedure TLog4DLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  Log(Log4D.Debug, AFormat, AArgs);
end;

procedure TLog4DLogger.Debug(const AMsg: string; const AException: Exception);
begin
  Delegate.Debug(AMsg, AException);
end;

{ TLog4DLoggerFactory }

function TLog4DLoggerFactory.GetLogger(const AName: string): ILogger;
begin
  Result := TLog4DLogger.Create(AName);
end;

end.
