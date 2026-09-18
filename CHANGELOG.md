# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]
### Added
- `TLogLevel`, `ILogEvent`/`TLogEvent` and `ILogEventAppender` in `djLogAPI`, encapsulating a single log call (level, logger name, message, format args, timestamp, exception) for future structured/queryable logging backends. `ILogger`'s public API is unchanged.
- A headless **Console** FPCUnit build mode for `src/test/Unittests.lpi`, so the test suite can run unattended (`UnittestsConsole.exe --all --format=plain`).
- A GitHub Actions workflow (`tests.yml`) that runs the FPCUnit suite headless on Windows and Linux for every push to `master` and every relevant pull request.
- `UNIT-TESTS.md` and `examples/README.md`, documenting how to build/run the test suite and what each example project demonstrates.

### Fixed
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

[Unreleased]: https://github.com/michaelJustin/slf4p/compare/v1.0.8...HEAD
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
