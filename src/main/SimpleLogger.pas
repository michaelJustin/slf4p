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
  djLogAPI, SysUtils;

type
  TSimpleLogger = class(TInterfacedObject, ILogger)
  public
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
  end;

  TSimpleLoggerFactory = class(TInterfacedObject, ILoggerFactory)
  public
    function GetLogger(const AName: string): ILogger;
  end;

implementation

{ TSimpleLogger }

procedure TSimpleLogger.Debug(const AMsg: string);
begin
  WriteLn(AMsg);
end;

procedure TSimpleLogger.Debug(const AFormat: string; const AArgs: array of const);
begin
  WriteLn(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Debug(const AMsg: string; const AException: Exception);
begin
  WriteLn(AMsg);
  WriteLn(AException.ClassName);
  WriteLn(AException.Message);
end;

procedure TSimpleLogger.Error(const AMsg: string; const AException: Exception);
begin
  WriteLn(AMsg);
  WriteLn(AException.ClassName);
  WriteLn(AException.Message);
end;

procedure TSimpleLogger.Error(const AFormat: string;
  const AArgs: array of const);
begin
  WriteLn(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Error(const AMsg: string);
begin
  WriteLn(AMsg);
end;

procedure TSimpleLogger.Info(const AMsg: string; const AException: Exception);
begin
  WriteLn(AMsg);
  WriteLn(AException.ClassName);
  WriteLn(AException.Message);
end;

procedure TSimpleLogger.Info(const AFormat: string;
  const AArgs: array of const);
begin
  WriteLn(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Info(const AMsg: string);
begin
  WriteLn(AMsg);
end;

procedure TSimpleLogger.Trace(const AMsg: string; const AException: Exception);
begin
  WriteLn(AMsg);
  WriteLn(AException.ClassName);
  WriteLn(AException.Message);
end;

procedure TSimpleLogger.Trace(const AFormat: string;
  const AArgs: array of const);
begin
  WriteLn(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Trace(const AMsg: string);
begin
  WriteLn(AMsg);
end;

procedure TSimpleLogger.Warn(const AMsg: string; const AException: Exception);
begin
  WriteLn(AMsg);
  WriteLn(AException.ClassName);
  WriteLn(AException.Message);
end;

procedure TSimpleLogger.Warn(const AFormat: string;
  const AArgs: array of const);
begin
  WriteLn(Format(AFormat, AArgs));
end;

procedure TSimpleLogger.Warn(const AMsg: string);
begin
  WriteLn(AMsg);
end;

{ TSimpleLoggerFactory }

function TSimpleLoggerFactory.GetLogger(const AName: string): ILogger;
begin
  Result := TSimpleLogger.Create;
end;

end.
