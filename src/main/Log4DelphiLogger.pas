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

unit Log4DelphiLogger;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  TLoggerUnit, TLevelUnit,
  djLogAPI, SysUtils;

type
  TLog4DelphiLogger = class(TInterfacedObject, ILogger)
  private
    Delegate: TLogger;
    FName: string;

    procedure Log(const ALevel: TLevel; const AMsg: string); overload;
    procedure Log(const ALevel: TLevel; const AFormat: string; const AArgs: array of const); overload;

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

  end;

  TLog4DelphiLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    function GetLogger(const AName: string): ILogger;
  end;

implementation

uses
  TFileAppenderUnit;

{ TLog4DelphiLogger }

constructor TLog4DelphiLogger.Create(const AName: string);
begin
  inherited Create;

  Delegate := TLogger.GetInstance;
  Delegate.AddAppender(TFileAppender.Create('test.log'));

  FName := AName;
end;

procedure TLog4DelphiLogger.Log(const ALevel: TLevel; const AMsg: string);
begin
  Delegate.Log(ALevel, AMsg);
end;

procedure TLog4DelphiLogger.Log(const ALevel: TLevel; const AFormat: string;
  const AArgs: array of const);
begin
  if Delegate.GetLevel.IsGreaterOrEqual(ALevel) then
    Delegate.Log(ALevel, Format(AFormat, AArgs));
end;

procedure TLog4DelphiLogger.Debug(const AMsg: string);
begin
  Log(TLevelUnit.DEBUG, AMsg);
end;

procedure TLog4DelphiLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  Log(TLevelUnit.DEBUG, AFormat, AArgs);
end;

procedure TLog4DelphiLogger.Debug(const AMsg: string; const AException: Exception);
begin
  Delegate.Debug(AMsg);
  Delegate.Debug(AException.Message);
end;

procedure TLog4DelphiLogger.Trace(const AMsg: string; const AException: Exception);
begin
  Delegate.Trace(AMsg);
  Delegate.Trace(AException.Message);
end;

procedure TLog4DelphiLogger.Trace(const AFormat: string;
  const AArgs: array of const);
begin
  Log(TLevelUnit.TRACE, AFormat, AArgs);
end;

procedure TLog4DelphiLogger.Trace(const AMsg: string);
begin
  Log(TLevelUnit.TRACE, AMsg);
end;

procedure TLog4DelphiLogger.Warn(const AMsg: string; const AException: Exception);
begin
  Delegate.Warn(AMsg);
  Delegate.Warn(AException.Message);
end;

procedure TLog4DelphiLogger.Warn(const AFormat: string; const AArgs: array of const);
begin
  Log(TLevelUnit.WARN, AFormat, AArgs);
end;

procedure TLog4DelphiLogger.Warn(const AMsg: string);
begin
  Log(TLevelUnit.WARN, AMsg);
end;

procedure TLog4DelphiLogger.Error(const AFormat: string;
  const AArgs: array of const);
begin
  Log(TLevelUnit.ERROR, AFormat, AArgs);
end;

procedure TLog4DelphiLogger.Error(const AMsg: string);
begin
  Log(TLevelUnit.ERROR, AMsg);
end;

procedure TLog4DelphiLogger.Error(const AMsg: string; const AException: Exception);
begin
  Delegate.Error(AMsg);
  Delegate.Error(AException.Message);
end;

function TLog4DelphiLogger.Name: string;
begin
  Result := FName;
end;

procedure TLog4DelphiLogger.Info(const AMsg: string; const AException: Exception);
begin
  Delegate.Info(AMsg);
  Delegate.Info(AException.Message);
end;

function TLog4DelphiLogger.IsDebugEnabled: Boolean;
begin
  Result := Delegate.GetLevel.IsGreaterOrEqual(TLevelUnit.DEBUG);
end;

function TLog4DelphiLogger.IsErrorEnabled: Boolean;
begin
  Result := Delegate.GetLevel.IsGreaterOrEqual(TLevelUnit.ERROR);
end;

function TLog4DelphiLogger.IsInfoEnabled: Boolean;
begin
  Result := Delegate.GetLevel.IsGreaterOrEqual(TLevelUnit.INFO);
end;

function TLog4DelphiLogger.IsTraceEnabled: Boolean;
begin
  Result := Delegate.GetLevel.IsGreaterOrEqual(TLevelUnit.TRACE);
end;

function TLog4DelphiLogger.IsWarnEnabled: Boolean;
begin
  Result := Delegate.GetLevel.IsGreaterOrEqual(TLevelUnit.WARN);
end;

procedure TLog4DelphiLogger.Info(const AFormat: string; const AArgs: array of const);
begin
  Log(TLevelUnit.INFO, AFormat, AArgs);
end;

procedure TLog4DelphiLogger.Info(const AMsg: string);
begin
  Log(TLevelUnit.INFO, AMsg);
end;

{ TLog4DelphiLoggerFactory }

function TLog4DelphiLoggerFactory.GetLogger(const AName: string): ILogger;
begin
  Result := TLog4DelphiLogger.Create(AName);
end;

end.
