# slf4p
A simple logging facade for Object Pascal.


Typical usage pattern:

    uses 
       ...
       djLogAPI, djLoggingFactory;
       
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

