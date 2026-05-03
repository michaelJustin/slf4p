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

unit MyClasses;

interface

uses
  djLogAPI;

type
  {$TYPEINFO ON}
  TFirstClass = class(TObject)
  private
    Log: ILogger;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TSecondClass = class(TFirstClass)
  private
    Log: ILogger;
  public
    constructor Create;
    destructor Destroy; override;
  end;
  {$TYPEINFO OFF}

implementation

uses
  slf4p;

{ TFirstClass }

constructor TFirstClass.Create;
begin
  Log := TLoggerFactory.GetLogger(TFirstClass);

  Log.Debug('in constructor');
end;

destructor TFirstClass.Destroy;
begin
  Log.Debug('in destructor');
end;

{ TSecondClass }

constructor TSecondClass.Create;
begin
  Log := TLoggerFactory.GetLogger(TSecondClass);

  if Log.IsTraceEnabled then
    Log.Trace('entering constructor');

  inherited;

  if Log.IsTraceEnabled then
    Log.Trace('leaving constructor');
end;

destructor TSecondClass.Destroy;
begin
  if Log.IsTraceEnabled then
    Log.Trace('entering destructor');

  inherited;

  if Log.IsTraceEnabled then
    Log.Trace('leaving destructor');
end;

end.
