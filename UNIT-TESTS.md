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
search path uses `..\..\..\log4d\src\main`), since `Log4DLoggerTests.pas` exercises
the `djLogOverLog4D` adapter against the real library. The Delphi project has
no such dependency: `Log4D` and `Log4DLoggerTests` are commented out of
`Unittests.dpr` and never registered.

## Free Pascal / Lazarus

From `src/test/`:

```
lazbuild -B Unittests.lpi
Unittests.exe
```

This opens the FPCUnit **GUI** test runner (`TGuiTestRunner`) — needs an
interactive desktop.

For a headless run, build the **Console** build mode instead, which produces
a separate console-subsystem executable, and pass it any argument (e.g.
`--all --format=plain`) so it dispatches to the FPCUnit **console** runner
instead of the GUI one:

```
lazbuild -B --build-mode=Console Unittests.lpi
UnittestsConsole.exe --all --format=plain
```

The exit code has bit 0 set on failures and bit 1 set on errors (FPCUnit's
`TProgressWriter.GetExitCode`), so scripts/CI can detect a red run from the
process exit status alone. `Unittests.lpr` picks GUI vs. console at runtime
via `ParamCount > 0`, so running `UnittestsConsole.exe` with no arguments
still opens the GUI.

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

- FPCUnit console runner: `--suite=<TestCaseClass>` (e.g. `--suite=TLogEventTests`),
  or `--list` to see the registered suite/test names.
- FPCUnit GUI runner: pick the suite/test in the tree and run it manually.
- DUnit text runner: no command-line selection; runs everything registered
  in `Unittests.dpr`. To narrow it, temporarily comment out the
  `RegisterTests(...)` calls you don't want, or use the GUI runner.

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

## Continuous integration

[`.github/workflows/tests.yml`](.github/workflows/tests.yml) checks out
`log4d` as a sibling and runs the **Console** build mode headless on both
`windows-latest` and `ubuntu-latest`. It triggers on every push to `master`
and every pull request that touches `src/main/`, `src/test/` or the workflow
file itself, and can be started by hand (`workflow_dispatch`). Windows
installs Lazarus via `setup-lazarus` (the `stable` version), with the
installed tree cached (keyed on the Lazarus/FPC version) so the SourceForge
download only happens on a cache miss; Linux installs it from the Ubuntu
archive (the action's SourceForge download stalls on the hosted Linux
runners) and runs the console runner under `xvfb` (the runner links the
LCL). Delphi is not covered in CI — run `Unittests.dpr` locally before
merging.

## Notes

- A green run is not a memory-leak check by itself:
  - FPC — the project is built with heap tracing (`-gh`), and the runner
    calls `SetHeapTraceOutput('heaptrace.log')`, so every run rewrites
    `src/test/heaptrace.log` with the leak report. Open it and confirm the
    unfreed-block count hasn't grown.
  - Delphi — `ReportMemoryLeaksOnShutDown := True` is set, so a leak pops up
    as a dialog when the GUI test window closes (or is reported on process
    exit for the text runner).
