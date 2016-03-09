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

unit djLoggerFactory;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  djLogAPI;

type
  TdjLoggerFactory = class(TObject)
  public
    class function GetILoggerFactory: ILoggerFactory;
    class function GetLogger(const AName: string): ILogger;
  end;

procedure RegisterFactory(const AFactory: ILoggerFactory);

implementation

uses
  NOPLogger,
  SysUtils;

resourcestring
  SLF4PTag = 'SLF4P: ';
  NoLoggerFactoryAvailable = 'Logger factory is not assigned';
  UseNOPLogger = 'Defaulting to no-operation (NOP) logger implementation';
  WarnOverwrite = 'Warning: overwriting logger factory!';

var
  LoggerFactory: ILoggerFactory;

procedure RegisterFactory(const AFactory: ILoggerFactory);
begin
  Assert(Assigned(AFactory));

  if Assigned(LoggerFactory) then
  begin
    WriteLn(SLF4PTag + WarnOverwrite);
  end;

  LoggerFactory := AFactory;
end;

{ TdjLoggerFactory }

class function TdjLoggerFactory.GetILoggerFactory: ILoggerFactory;
begin
  Result := LoggerFactory;
end;

class function TdjLoggerFactory.GetLogger(const AName: string): ILogger;
begin
  if not Assigned(LoggerFactory) then
  begin
    WriteLn(SLF4PTag + NoLoggerFactoryAvailable);
    WriteLn(SLF4PTag + UseNOPLogger);
    RegisterFactory(TNOPLoggerFactory.Create);
  end;

  Result := LoggerFactory.GetLogger(AName);
end;

end.
