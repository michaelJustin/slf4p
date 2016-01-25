# slf4p
A simple logging facade for Object Pascal.


## Typical usage pattern

### Step 1: In the project file, add the required binding unit. It will register a factory for the actual logging framework.


    program Test;
    
    interface
    
    uses
      djLogImplLog4D, // the djLog logging facade unit
      Log4D, // required for additional configuration
      ...;
      
    begin
      // Log4D specific configuration ----------------------
      // Create a default ODS logger
      Log4D.TLogBasicConfigurator.Configure;
      // which directs output to the 'Event log' IDE Window
      Log4D.TLogLogger.GetRootLogger.Level := Debug;
      // ---------------------------------------------------
      
      ...
      
    end.


### Step 2: create a new logger in your program where needed. 


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

