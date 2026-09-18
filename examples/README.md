# Examples

Each subfolder is a small standalone program demonstrating a different way to
use slf4p. All of them log through the same `ILogger` API from `djLogAPI`;
they differ in which backend is registered (via a `djLogOver...` unit) and
how the logger is obtained.

| Example | Backend | Project |
|---------|---------|---------|
| [`simple/`](simple/) | `SimpleLogger` | Delphi (`.dpr`) |
| [`named/`](named/) | `SimpleLogger` | Delphi (`.dpr`) |
| [`log4d/`](log4d/) | [Log4D](http://sourceforge.net/projects/log4d/) | Delphi (`.dpr`) |
| [`lazlogger/`](lazlogger/) | [LazLogger](http://wiki.lazarus.freepascal.org/LazLogger) | Free Pascal / Lazarus (`.lpr`) |

## `simple/`

The minimal case: registers `djLogOverSimpleLogger`, gets the default (unnamed)
logger with `TLoggerFactory.GetLogger`, and logs a `Debug` and an `Info`
message.

## `named/`

Same `SimpleLogger` backend, but shows `TLoggerFactory.GetLogger(TClass)` —
using a class as the logger name. `MyClasses.pas` defines `TFirstClass` and a
subclass `TSecondClass`, each fetching its own logger named after itself in
its constructor/destructor, so the log output shows which class produced each
line, including both constructors running when a `TSecondClass` is created.

## `log4d/`

Registers `djLogOverLog4D` instead, so log calls are dispatched to
[Log4D](http://sourceforge.net/projects/log4d/) rather than `SimpleLogger`.
`LogConsoleAppender.pas` defines a console appender, which the program wires
up via Log4D's own `TLogBasicConfigurator` before logging through the same
`ILogger` API as the other examples.

## `lazlogger/`

The Free Pascal / Lazarus counterpart to `simple/`: registers
`djLogOverLazLogger` to dispatch log calls to the LCL's `LazLogger`, then logs
through `TLoggerFactory.GetLogger` the same way.
