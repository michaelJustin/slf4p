# slf4p
A simple logging facade for Object Pascal.


Typical usage pattern:

    uses 
       ...
       djLog;
       
    type
      TMyMainClass = class(TObject)
      private
         LoggerFactory: ILoggerFactory;
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
      
      LoggerFactory := TNOPLoggerFactory.Create;
      Logger := LoggerFactory.GetLogger('TMyMainClass');
      Logger.Debug('Creating instance %d', GetTickCount);
      ...
    end;
     
