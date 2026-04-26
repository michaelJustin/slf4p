{$APPTYPE CONSOLE}

program HelloWorld;

uses
  slf4p;

procedure RunDemo;
begin
  Logger.Debug('Using slf4p ' + SLF4P_VERSION);
  Logger.Info('Hello, World!');
  Logger.Debug('Hit any key');
  ReadLn;
end;

begin
  RunDemo;
end.

