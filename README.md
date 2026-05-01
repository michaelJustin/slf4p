# slf4p - Simple Logging Facade for Pascal

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Pascal](https://img.shields.io/badge/language-Object%20Pascal-blue.svg)]()
[![Stars](https://img.shields.io/github/stars/michaelJustin/slf4p.svg)](https://github.com/michaelJustin/slf4p/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/michaelJustin/slf4p.svg)](https://github.com/michaelJustin/slf4p/commits)

[![Delphi](https://img.shields.io/badge/Delphi-2009+-blue.svg)]()
[![Lazarus](https://img.shields.io/badge/Lazarus-2.0+-blue.svg)]()
[![FPC](https://img.shields.io/badge/FPC-supported-brightgreen.svg)]()
[![Log4D](https://img.shields.io/badge/Log4D-supported-brightgreen.svg)]()
[![LazLogger](https://img.shields.io/badge/LazLogger-supported-brightgreen.svg)]()
[![Workflow Status](https://github.com/michaelJustin/slf4p/actions/workflows/compile-examples.yml/badge.svg)](https://github.com/michaelJustin/slf4p/actions/workflows/compile-examples.yml)

The Simple Logging Facade for Pascal serves as a simple facade or abstraction for various logging frameworks (e.g. Log4D, LazLogger) allowing the end user to plug in the desired logging framework at build time.

Developed with Dephi 2009 and Lazarus 2.0, tested with DUnit and FPCUnit.

To register a specific logging framework, just add one of the `djLogOver...` units to the project.

* `djLogOverNOPLogger` for logging over NOPLogger (included)
* `djLogOverSimpleLogger` for logging over SimpleLogger (included)
* `djLogOverLog4D` for logging over [Log4D](http://sourceforge.net/projects/log4d/)
* `djLogOverLazLogger` for logging over [LazLogger](http://wiki.lazarus.freepascal.org/LazLogger)

## Examples

The examples use the helper unit [slf4p](src/main/slf4p.pas), which is located in the src/main folder, and provides the LOGGER method. (New in 1.0.5)
Note: 
* the unit which specifies (registers) a logger factory must appear in the uses list before unit slf4p.
* when no unit is added, a NOPLogger factory will be used as fallback, and a message indicating the fallback will be printed.
* the last logger factory unit found will be used to create logger instances.

### NOPLogger

Since no unit for registering a logger factory is used, a factory for NOP loggers will be registered.

```pascal
program HelloWorld;

uses
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
```

#### Program output

```console
SLF4P: Logger factory is not assigned
SLF4P: Defaulting to no-operation (NOP) logger implementation
```

### SimpleLogger

This example uses the helper unit [slf4p](src/main/slf4p.pas), which is located in the src/main folder, and provides the LOGGER method. (New in 1.0.5)
The first unit used, djLogOverSimpleLogger, registers a factory for console loggers.

```pascal
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
```

#### Program output

```console
[09:58:46.491] DEBUG - Using slf4p 1.0.6
[09:58:46.491] INFO - Hello, World!
[09:58:46.491] DEBUG - Hit any key
```

### Log4D

This example uses the helper unit [slf4p](src/main/slf4p.pas), which is located in the src/main folder, and provides the LOGGER method. (New in 1.0.5)
The first unit used, djLogOverLog4D, registers a logger factory which created Log4D loggers.

```pascal
program HelloWorld;

uses
  djLogOverLog4D, LogConsoleAppender, Log4d,
  slf4p;

procedure RunDemo;
var
  LogLayout: ILogLayout;
  ConsoleAppender: ILogAppender;
begin
  LogLayout := TLogPatternLayout.Create(TTCCPattern);
  ConsoleAppender := TLogConsoleAppender.Create('console');
  ConsoleAppender.Layout := LogLayout;
  TLogBasicConfigurator.Configure(ConsoleAppender);

  TLogLogger.GetRootLogger.Level := Debug;
  WriteLn('Logging with Log4D version ' + Log4DVersion);

  LOGGER.Debug('Using slf4p %s', [SLF4P_VERSION]);
  LOGGER.Info('Hello, World!');
  LOGGER.Debug('Hit any key');
  ReadLn;
end;

begin
  RunDemo;
end.
```

#### Program output

```console
Logging with Log4D version 1.2.12
0 [13620] debug   - Using slf4p 1.0.6-SNAPSHOT
0 [13620] info   - Hello, World!
0 [13620] debug   - Hit any key
```

### LazLogger

This example uses the helper unit [slf4p](src/main/slf4p.pas), which is located in the src/main folder, and provides the LOGGER method. (New in 1.0.5)
The first unit used, djLogOverLazLogger, registers a logger factory which created LazLogger loggers.

```pascal
program HelloWorld;

uses
  djLogOverLazLogger,
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
```

#### Program output

```console
3 DEBUG  - Using slf4p 1.0.6
3 INFO  - Hello, World!
3 DEBUG  - Hit any key
```
