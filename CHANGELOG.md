# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [1.1.0] - 2026-09-19

### Core library
#### Added
- `TLogLevel`, `ILogEvent`/`TLogEvent` and `ILogEventAppender` in `djLogAPI`, encapsulating a single log call (level, logger name, message, format args, timestamp, exception) for future structured/queryable logging backends. `ILogger`'s public API is unchanged.
- `TAbstractLogger` in a new `djAbstractLogger` unit: implements `ILogger` (and `ILogEventAppender`) once, owning the level check and `TLogEvent` construction for every call, and exposes a single `Append(const AEvent: ILogEvent)` for subclasses to override. `TSimpleLogger`, `TLazLoggerLogger` and `TStringsLogger` now derive from it instead of each re-implementing the full fifteen-overload `ILogger` surface and its own private level enum; `TNOPLogger` and `TLog4DLogger` are unchanged for now (see the doc comment on `TAbstractLogger` and issue #69/#77 for why).
- `ILogger.Debug/Info/Warn/Error/Trace(const AFormat: string; const AArg: TObject)`: a fourth overload per level for logging a single object without wrapping it in an array-of-const literal. Formats `AArg` via a new `djLogAPI.ObjectToStr` (which also backs `VarRecToStr`'s existing `vtObject` handling), using `AArg.ToString` - the class name by default, or whatever the logged class overrides `ToString` to return.
- `ILogger.Debug/Info/Warn/Error/Trace(const AFormat: string; const AArg1, AArg2: TObject)`: a fifth overload per level for logging two objects the same way.

#### Changed
- `SimpleLogger`, `LazLoggerLogger` and `StringsLogger` no longer declare their own `Trace`/`Debug`/`Info`/`Warn`/`Error` level enum; they use `djLogAPI.TLogLevel` via `TAbstractLogger`. Logged output is unchanged.

#### Fixed
- A log call whose format string and arguments don't match (e.g. too few/many placeholders, a `%d` given a non-numeric argument) no longer raises `EConvertError` out of `Log.Debug`/`Info`/`Warn`/`Error`/`Trace`. `TLogEvent`'s format-args constructor (`djLogAPI.pas`, used by every backend derived from `TAbstractLogger`) and `TLog4DLogger.Log` (`Log4DLogger.pas`, which formats independently) now go through a new `djLogAPI.SafeFormat`, which falls back to the raw format string plus the formatting exception's message so the mistake stays visible in the log output instead of propagating to the caller.

### Internal / toolchain
#### Added
- A headless **Console** FPCUnit build mode for `src/test/Unittests.lpi`, so the test suite can run unattended (`UnittestsConsole.exe --all --format=plain`).
- A GitHub Actions workflow (`tests.yml`) that runs the FPCUnit suite headless on Windows and Linux for every push to `master` and every relevant pull request.
- `UNIT-TESTS.md` and `examples/README.md`, documenting how to build/run the test suite and what each example project demonstrates.

#### Fixed
- `Unittests.lpi`'s `log4d` unit search path was missing `\main` (`log4d`'s `Log4D.pas` lives in `src/main`), which broke a clean checkout even though it went unnoticed locally due to stale precompiled units.

## [1.0.8] - 2026-05-14
### Added
- CycloneDX SBOM generation via a new `run-syft.yml` GitHub Actions workflow and `.syft.yaml` config.

### Removed
- Removed the standalone `slf4p` unit; `SLF4P_VERSION` and related declarations now live in `djLogAPI`.

## [1.0.7] - 2026-05-03
### Added
- `TLoggerFactory` in the `slf4p` unit, replacing the `LOGGER` function-based API.
- Overloaded `TdjLoggerFactory.GetLogger` for class-based logging.
- Log guards for cheaper disabled-level logging calls.

### Changed
- Logger name is now optional and defaults to `''`.
- Refactored classes to use dedicated `ILogger` instances instead of global `LOGGER` calls.
- Normalized unit naming/casing (`djLogAPI`).

### Removed
- Removed the FPC project for `log4d`, simplifying maintenance.

## [1.0.6] - 2026-05-01
### Added
- GitHub Actions workflow to compile the examples (`compile-examples.yml`).
- Delphi and Lazarus/Free Pascal demo projects.

### Changed
- Default logger level is `Debug`.
- Various README updates and clarifications on the logging facade.

## [1.0.5] - 2026-04-26
### Added
- Simple example and accompanying README section.

### Changed
- Default logger name is empty; an empty name is rendered as a dash.
- Default timestamp format now uses enclosing brackets `[hh:nn:ss.zzz]`.
- `SimpleLogger` default level set to `Debug`, with timestamps enabled.
- General refactoring and use of `strict private` visibility.

## [1.0.4] - 2021-07-04
Maintenance release; see the [full commit history](https://github.com/michaelJustin/slf4p/compare/1.0.2...1.0.4) for details.

## [1.0.2] - 2016-08-27
## [1.0.1] - 2016-07-15
## [1.0] - 2016-03-29
## [0.3.0] - 2016-03-23
## [0.2.0] - 2016-03-12
## [0.1.0] - 2016-02-13
Initial releases. See the [full commit history](https://github.com/michaelJustin/slf4p/commits/1.0.2) for details.

[Unreleased]: https://github.com/michaelJustin/slf4p/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/michaelJustin/slf4p/compare/v1.0.8...v1.1.0
[1.0.8]: https://github.com/michaelJustin/slf4p/compare/v1.0.7...v1.0.8
[1.0.7]: https://github.com/michaelJustin/slf4p/compare/v1.0.6...v1.0.7
[1.0.6]: https://github.com/michaelJustin/slf4p/compare/v1.0.5...v1.0.6
[1.0.5]: https://github.com/michaelJustin/slf4p/compare/1.0.4...v1.0.5
[1.0.4]: https://github.com/michaelJustin/slf4p/compare/1.0.2...1.0.4
[1.0.2]: https://github.com/michaelJustin/slf4p/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/michaelJustin/slf4p/compare/1.0...1.0.1
[1.0]: https://github.com/michaelJustin/slf4p/compare/0.3.0...1.0
[0.3.0]: https://github.com/michaelJustin/slf4p/compare/v0.2.0...0.3.0
[0.2.0]: https://github.com/michaelJustin/slf4p/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/michaelJustin/slf4p/releases/tag/v0.1.0
