# slf4p

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Pascal](https://img.shields.io/badge/language-Object%20Pascal-blue.svg)]()
[![Stars](https://img.shields.io/github/stars/michaelJustin/slf4p.svg)](https://github.com/michaelJustin/slf4p/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/michaelJustin/slf4p.svg)](https://github.com/michaelJustin/slf4p/commits)

[![Delphi](https://img.shields.io/badge/Delphi-2009+-blue.svg)]()
[![Lazarus](https://img.shields.io/badge/Lazarus-2.0+-blue.svg)]()
[![FPC](https://img.shields.io/badge/FPC-supported-brightgreen.svg)]()
[![Log4D](https://img.shields.io/badge/Log4D-supported-brightgreen.svg)]()
[![LazLogger](https://img.shields.io/badge/LazLogger-supported-brightgreen.svg)]()

A simple logging facade for Object Pascal, developed with Dephi 2009 and Lazarus 2.0. Tested with DUnit and FPCUnit.

To register a specific logging framework, just add one of the `djLogOver...` units to the project.

* `djLogOverLog4D` for logging over [Log4D](http://sourceforge.net/projects/log4d/)
* `djLogOverLazLogger` for logging over [LazLogger](http://wiki.lazarus.freepascal.org/LazLogger)
* `djLogOverSimpleLogger` for logging over SimpleLogger (included)
* `djLogOverNOPLogger` for logging over NOPLogger (included)

## Example

This example uses the helper unit [slf4p](src/main/slf4p.pas), which located in the src/main folder.

https://github.com/michaelJustin/slf4p/blob/4cc0b6899ebc0ddc83d6f9a9d9614279a99cd000/examples/simple/HelloWorld.dpr#L1-L18
