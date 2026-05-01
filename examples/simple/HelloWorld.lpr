program HelloWorld;

uses
  djLogOverSimpleLogger,
  slf4p;

procedure RunDemo;
begin
  LOGGER.Debug('Using slf4p %s', [SLF4P_VERSION]);
  LOGGER.Info('Hello, World!');
  LOGGER.Debug('Hit any key');
  ReadLn;
end;

begin
  RunDemo;
end.

