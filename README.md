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

The Simple Logging Facade for Pascal serves as a simple facade or abstraction for various logging frameworks (e.g. Log4D, LazLogger), allowing the end user to plug in the desired logging framework at build time.

Developed with Delphi 2009 and Lazarus 4.4, tested with DUnit and FPCUnit.

To register a specific logging framework, add one of the `djLogOver...` units to the project.

* `djLogOverNOPLogger` for logging over NOPLogger
* `djLogOverSimpleLogger` for logging over SimpleLogger
* `djLogOverLog4D` for logging over [Log4D](http://sourceforge.net/projects/log4d/)
* `djLogOverLazLogger` for logging over [LazLogger](http://wiki.lazarus.freepascal.org/LazLogger)

## Choosing Between SLF4P and Log4D
Before deciding which logging tool to use, it’s important to understand what each one does.

SLF4P is not a logging implementation on its own. It’s an abstraction layer that lets you plug in a logging framework at runtime, such as Log4D or LazLogger. You write your code against the SLF4P API and then link it to a logging backend via the source path.

Log4D, by contrast, is a complete logging implementation. It provides its own APIs, configuration mechanisms for generating logs, and powerful built-in features, including filtering, custom appenders, and advanced formatting.

## Examples

The examples use the helper unit [slf4p](src/main/slf4p.pas), which is located in the src/main folder and provides the TLoggerFactory class. (since v1.0.7)

One of the LogOver... units must be added to the project. When no unit is added, a NOPLogger factory will be used as a fallback, and a message indicating the fallback will be printed.

### NOPLogger

Since no unit for registering a logger factory is used, a factory for NOP loggers will be registered.

```pascal
program HelloWorld;

uses
  slf4p, djLogApi;

procedure RunDemo;
var
  Log: ILogger;
begin
  Log := TLoggerFactory.GetLogger;

  Log.Debug('Using slf4p %s', [SLF4P_VERSION]);
  Log.Info('Hello, World!');
  Log.Debug('Hit any key');

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

The first unit used, djLogOverSimpleLogger, registers a factory for console loggers.

```pascal
program HelloWorld;

uses
  djLogOverSimpleLogger,
  slf4p, djLogApi;

procedure RunDemo;
var
  Log: ILogger;
begin
  Log := TLoggerFactory.GetLogger;

  Log.Debug('Using slf4p %s', [SLF4P_VERSION]);
  Log.Info('Hello, World!');
  Log.Debug('Hit any key');

  ReadLn;
end;

begin
  RunDemo;
end.
```

#### Program output

```console
[12:05:46.732] DEBUG - Using slf4p 1.0.7-SNAPSHOT
[12:05:46.732] INFO - Hello, World!
[12:05:46.733] DEBUG - Hit any key
```

### Log4D

The first unit used, djLogOverLog4D, registers a logger factory which created Log4D loggers.

```pascal
program HelloWorld;

uses
  djLogOverLog4D, djLogApi, slf4p,
  LogConsoleAppender, Log4d;

procedure RunDemo;
var
  Log: ILogger;
  ConsoleAppender: ILogAppender;
begin
  ConsoleAppender := TLogConsoleAppender.Create('console');
  TLogBasicConfigurator.Configure(ConsoleAppender);

  TLogLogger.GetRootLogger.Level := Debug;
  WriteLn('Logging with Log4D version ' + Log4DVersion);

  Log := TLoggerFactory.GetLogger('slf4p/log4d');
  Log.Debug('Using slf4p %s', [SLF4P_VERSION]);
  Log.Info('Hello, World!');
  Log.Debug('Hit any key');
  ReadLn;
end;

begin
  RunDemo;
end.
```

#### Program output

```console
Logging with Log4D version 1.2.12
debug - Using slf4p 1.0.7-SNAPSHOT
info - Hello, World!
debug - Hit any key
```

### LazLogger

The first unit used, djLogOverLazLogger, registers a logger factory which creates LazLogger loggers.

```pascal
program HelloWorld;

uses
  djLogOverLazLogger,
  slf4p, djLogApi;

var
  Log: ILogger;
begin
  Log := TLoggerFactory.GetLogger;
  Log.Debug('Using slf4p %s', [SLF4P_VERSION]);
  Log.Info('Hello, World!');
  Log.Debug('Hit any key');
  ReadLn;
end.
```

#### Program output

```console
0 DEBUG  - Using slf4p 1.0.7-SNAPSHOT
0 INFO  - Hello, World!
0 DEBUG  - Hit any key
```

## Named loggers

The example uses named loggers in the classes TFirstClass and TSecondClass. The logger is created in the constructor of each class, using the class type as a parameter for the GetLogger method. With the help of classic published RTTI, the example classes write their unit name and class name to the log.

```pascal
program HelloWorld;

uses
  djLogOverSimpleLogger, SimpleLogger, slf4p, djLogApi,
  MyClasses in 'MyClasses.pas';

procedure RunDemo;
var
  Log: ILogger;
  Obj1: TFirstClass;
  Obj2: TSecondClass;
begin
  SimpleLogger.Configure('defaultLogLevel', 'trace');
  SimpleLogger.Configure('showDateTime', 'false');

  Log := TLoggerFactory.GetLogger;
  Log.Info('Using slf4p %s', [SLF4P_VERSION]);

  Obj1 := TFirstClass.Create;
  Obj2 := TSecondClass.Create;
  try
    Log.Info('Instances created');
  finally
    Obj2.Free;
    Obj1.Free;
  end;

  Log.Info('Hit any key');
  ReadLn;
end;

begin
  RunDemo;
end.
```

With the help of classic published RTTI, the example classes write their unit name and class name to the log.

```pascal
unit MyClasses;

interface

uses
  djLogApi;

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
```

#### Program output

```console
0 INFO - Using slf4p 1.0.7-SNAPSHOT
0 DEBUG MyClasses.TFirstClass in constructor
0 TRACE MyClasses.TSecondClass entering constructor
0 DEBUG MyClasses.TFirstClass in constructor
0 TRACE MyClasses.TSecondClass leaving constructor
0 INFO - Instances created
0 TRACE MyClasses.TSecondClass entering destructor
0 DEBUG MyClasses.TFirstClass in destructor
0 TRACE MyClasses.TSecondClass leaving destructor
0 DEBUG MyClasses.TFirstClass in destructor
0 INFO - Hit any key
```
