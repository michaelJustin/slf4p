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

unit LogConsoleAppender;

interface

uses
  Log4D;

type
  TLogConsoleAppender = class(TLogCustomAppender)
  protected
    procedure DoAppend(const Message: string); override;
  end;

implementation

{ TLogConsoleAppender }

procedure TLogConsoleAppender.DoAppend(const Message: string);
begin
  if IsConsole then
    Write(Message);
end;

initialization
  RegisterAppender(TLogConsoleAppender);

end.
