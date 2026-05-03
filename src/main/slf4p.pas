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

unit slf4p;

interface

uses
  djLogAPI, djLoggerFactory;

const
  SLF4P_VERSION = '1.0.7-SNAPSHOT';

type
  TLoggerFactory = class(TdjLoggerFactory)
  public
    class function GetLogger(const AClass: TClass): ILogger; overload;
  end;

implementation

class function TLoggerFactory.GetLogger(const AClass: TClass): ILogger;
var
  Name: string;
begin
  Name := AClass.UnitName;
  if Name <> '' then Name := Name + '.';
  Name := Name + AClass.ClassName;
  Result := GetLogger(Name);
end;

end.
