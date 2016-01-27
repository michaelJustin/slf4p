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

unit NOPLogger;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  djLogAPI, SysUtils;

type
  TNOPLogger = class(TInterfacedObject, ILogger)
  private
    FName: string;

  public
    constructor Create(AName: string);

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

  TNOPLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    function GetLogger(const AName: string): ILogger;
  end;

implementation

{ TNOPLogger }

constructor TNOPLogger.Create(AName: string);
begin
  FName := AName;
end;

procedure TNOPLogger.Debug(const AMsg: string);
begin

end;

procedure TNOPLogger.Debug(const AFormat: string; const AArgs: array of const);
begin

end;

procedure TNOPLogger.Debug(const AMsg: string; const AException: Exception);
begin

end;

procedure TNOPLogger.Error(const AMsg: string; const AException: Exception);
begin

end;

function TNOPLogger.Name: string;
begin
  Result := FName;
end;

procedure TNOPLogger.Error(const AFormat: string; const AArgs: array of const);
begin

end;

procedure TNOPLogger.Error(const AMsg: string);
begin

end;

procedure TNOPLogger.Info(const AMsg: string; const AException: Exception);
begin

end;

function TNOPLogger.IsDebugEnabled: Boolean;
begin
  Result := False;
end;

function TNOPLogger.IsErrorEnabled: Boolean;
begin
  Result := False;
end;

function TNOPLogger.IsInfoEnabled: Boolean;
begin
  Result := False;
end;

function TNOPLogger.IsTraceEnabled: Boolean;
begin
  Result := False;
end;

function TNOPLogger.IsWarnEnabled: Boolean;
begin
  Result := False;
end;

procedure TNOPLogger.Info(const AFormat: string; const AArgs: array of const);
begin

end;

procedure TNOPLogger.Info(const AMsg: string);
begin

end;

procedure TNOPLogger.Trace(const AMsg: string; const AException: Exception);
begin

end;

procedure TNOPLogger.Trace(const AFormat: string; const AArgs: array of const);
begin

end;

procedure TNOPLogger.Trace(const AMsg: string);
begin

end;

procedure TNOPLogger.Warn(const AMsg: string; const AException: Exception);
begin

end;

procedure TNOPLogger.Warn(const AFormat: string; const AArgs: array of const);
begin

end;

procedure TNOPLogger.Warn(const AMsg: string);
begin

end;

{ TNOPLoggerFactory }

function TNOPLoggerFactory.GetLogger(const AName: string): ILogger;
begin
  Result := TNOPLogger.Create(AName);
end;

end.
