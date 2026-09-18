# Building and running the unit tests

The tests live in [`src/test/`](src/test/). One set of test source files
feeds two project files:

| Project | Compiler | Runner |
|---------|----------|--------|
| `Unittests.lpi` | Free Pascal / Lazarus | FPCUnit |
| `Unittests.dpr` | Delphi | DUnit |

## Dependencies

The Free Pascal build expects [`log4d`](https://sourceforge.net/projects/log4d/)
checked out as a **sibling of the repository directory** (`Unittests.lpi`'s
search path uses `..\..\..\log4d\src`), since `Log4DLoggerTests.pas` exercises
the `djLogOverLog4D` adapter against the real library. The Delphi project has
no such dependency: `Log4D` and `Log4DLoggerTests` are commented out of
`Unittests.dpr` and never registered.

## Free Pascal / Lazarus

From `src/test/`:

```
lazbuild -B Unittests.lpi
Unittests.exe
```

This opens the FPCUnit **GUI** test runner (`TGuiTestRunner`) — there is no
headless/console build mode, so a run needs an interactive desktop.

`lazbuild` is not on `PATH` on this machine; call it by full path, e.g.
`C:\lazarus\lazbuild.exe`.

## Delphi

From `src/test/`:

```
set RS=C:\Program Files (x86)\CodeGear\RAD Studio\6.0
"%RS%\bin\dcc32.exe" -B -Q "-U%RS%\lib;..\main" -N0<dcu-out-dir> -E. Unittests.dpr
Unittests.exe -text-mode
```

`Unittests.dpr` runs the DUnit **text** runner when passed `-text-mode`
(single dash — it's read with `FindCmdLineSwitch`) and prints a plain-text
pass/fail report to the console; without that switch it opens the DUnit
**GUI** runner instead.

## Running a subset

Neither runner currently exposes a command-line filter for selecting a
single test case:

- FPCUnit GUI runner: pick the suite/test in the tree and run it manually.
- DUnit text runner: runs everything that's registered in `Unittests.dpr`;
  to narrow it, temporarily comment out the `RegisterTests(...)` calls you
  don't want.

## What each test file covers

- `LoggerFactoryTests.pas` — `TdjLoggerFactory` fallback behaviour (no
  backend registered).
- `LogEventTests.pas` — `TLogEvent` construction, message formatting and
  argument capture.
- `NOPLoggerTests.pas`, `SimpleLoggerTests.pas`, `StringsLoggerTests.pas` —
  one suite per `djLogOver...` backend adapter; built and run by both
  projects.
- `LazLoggerTests.pas`, `Log4DLoggerTests.pas` — FPC/Lazarus **only** (see
  Dependencies above); not part of the Delphi build.

## Notes

- There is no CI workflow that runs this suite (`.github/workflows/` only
  has example-compilation and SBOM generation); treat a local run as the
  gate before merging changes to `src/main/`.
- A green run is not a memory-leak check by itself:
  - FPC — the project is built with heap tracing (`-gh`), and the runner
    calls `SetHeapTraceOutput('heaptrace.log')`, so every run rewrites
    `src/test/heaptrace.log` with the leak report. Open it and confirm the
    unfreed-block count hasn't grown.
  - Delphi — `ReportMemoryLeaksOnShutDown := True` is set, so a leak pops up
    as a dialog when the GUI test window closes (or is reported on process
    exit for the text runner).
