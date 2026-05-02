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

type
  {$TYPEINFO ON}
  TFirstClass = class(TObject)
    constructor Create;
    destructor Destroy; override;
  end;

  TSecondClass = class(TFirstClass)
    constructor Create; virtual;
    destructor Destroy; override;
  end;
  {$TYPEINFO OFF}

implementation

uses
  slf4p;

{ TExampleClass }

constructor TFirstClass.Create;
begin
  LOGGER(Self).Debug('in constructor');
end;

destructor TFirstClass.Destroy;
begin
  LOGGER(Self).Debug('in destructor');
end;

{ TSecondClass }

constructor TSecondClass.Create;
begin
  if LOGGER.IsTraceEnabled then
    LOGGER(Self).Trace('entering constructor');
  inherited;
  if LOGGER.IsTraceEnabled then
    LOGGER(Self).Trace('leaving constructor');
end;

destructor TSecondClass.Destroy;
begin
  if LOGGER.IsTraceEnabled then
    LOGGER(Self).Trace('entering destructor');
  inherited;
  if LOGGER.IsTraceEnabled then
    LOGGER(Self).Trace('leaving destructor');
end;

end.
