# slf4p
A simple logging facade for Object Pascal, which eliminates dependencies on a specific logging framework.

The idea behind using a 'facade' is that your code can be prepared for log output, without the need to add  {$IFDEF LOGGING_ENABLED} switches all over it, and without linking a specfic logging solution such as Log4D or Log4Delphi etc.

The facade allows to start with a NOP implementation, which does nothing, and switch to a different logging framework, such as Log4Delphi or Log4D, when needed. This can be useful when

* application size is important (using a NOP logger keeps the executable compact)
* commercial / open source licenses may collide 


# Usage example

## Add a self-registering binding unit. It will register a factory for the actual logging framework. 


    program Test;
    
    interface
    
    uses
      ...
      djLogImplSimple, // registers the 'simple' logger implementation
      ...;
      
    begin
      ...
    end.


## Create loggers where needed.


    unit A;
    
    interface
    
    uses 
       ...
       djLogAPI, djLoggerFactory;
       
    type
      TMyMainClass = class(TObject)
      private
        Logger: ILogger;
        ...
      public
        constructor Create;
        ...
      end;
      ...
    constructor TMyMainClass.Create;
    begin
      inherited;
      
      Logger := TdjLoggerFactory.GetLogger('TMyMainClass');
      Logger.Debug('Creating instance %d', GetTickCount);
      ...
    end;
    
     
Bindings
--------

Included bindings: NOPLogger, SimpleLogger

Binding usage
-------------

To use a specific binding, add the corresponding unit to your project:

* to use the NOPLogger, add unit *TdjLogImplNOP*
* to use the SimpleLogger, add unit *TdjLogImplSimple*

