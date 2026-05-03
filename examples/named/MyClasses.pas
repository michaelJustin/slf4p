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
    LOG: ILogger;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TSecondClass = class(TFirstClass)
  private
    LOG: ILogger;
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
  LOG := LOGGER(TFirstClass);

  LOG.Debug('in constructor');
end;

destructor TFirstClass.Destroy;
begin
  LOG.Debug('in destructor');
end;

{ TSecondClass }

constructor TSecondClass.Create;
begin
  LOG := LOGGER(TSecondClass);

  if LOG.IsTraceEnabled then
    LOG.Trace('entering constructor');

  inherited;

  if LOG.IsTraceEnabled then
    LOG.Trace('leaving constructor');
end;

destructor TSecondClass.Destroy;
begin
  if LOG.IsTraceEnabled then
    LOG.Trace('entering destructor');

  inherited;

  if LOG.IsTraceEnabled then
    LOG.Trace('leaving destructor');
end;

end.
