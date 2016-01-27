# slf4p
A simple logging facade for Object Pascal

## Usage

### Register a specific implementation


    
    program Test;
        interface
        uses
          djLogImplSimple, // registers the 'simple' logger implementation
          UnitA, ...
          ...;
        begin
          ...
    end.


### Create loggers where needed


    unit UnitA;
    
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
    
     
