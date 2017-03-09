program consoleplaymemorystream;

///WARNING : if FPC version < 2.7.1 => Do not forget to uncoment {$DEFINE consoleapp} in define.inc !

{$mode objfpc}{$H+}
   {$DEFINE UseCThreads}
uses
{$IFDEF UNIX}
  cthreads,
  cwstring, {$ENDIF}
  Classes,
  ctypes,
  SysUtils,
  CustApp,
  uos_flat;

type

  { TUOSConsole }

  TuosConsole = class(TCustomApplication)
  private
    procedure ConsolePlay;
  protected
    procedure doRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  res, i: integer;
  ordir, opath, st, SoundFilename, PA_FileName, SF_FileName, MP_FileName: string;
  PlayerIndex1 : integer;
  thememorystream : Tmemorystream;
  { TuosConsole }

  procedure TuosConsole.ConsolePlay;
  begin
    ordir := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));

 {$IFDEF Windows}
     {$if defined(cpu64)}
    PA_FileName := ordir + 'lib\Windows\64bit\LibPortaudio-64.dll';
    SF_FileName := ordir + 'lib\Windows\64bit\LibSndFile-64.dll';
    MP_FileName := ordir + 'lib\Windows\64bit\LibMpg123-64.dll';
     {$else}
    PA_FileName := ordir + 'lib\Windows\32bit\LibPortaudio-32.dll';
    SF_FileName := ordir + 'lib\Windows\32bit\LibSndFile-32.dll';
    MP_FileName := ordir + 'lib\Windows\32bit\LibMpg123-32.dll';
     {$endif}
    SoundFilename := ordir + 'sound\test.flac';
 {$ENDIF}

 {$IFDEF linux}
    {$if defined(cpu64)}
    PA_FileName := ordir + 'lib/Linux/64bit/LibPortaudio-64.so';
    SF_FileName := ordir + 'lib/Linux/64bit/LibSndFile-64.so';
    MP_FileName := ordir + 'lib/Linux/64bit/LibMpg123-64.so';
    {$else}
    PA_FileName := ordir + 'lib/Linux/32bit/LibPortaudio-32.so';
    SF_FileName := ordir + 'lib/Linux/32bit/LibSndFile-32.so';
    MP_FileName := ordir + 'lib/Linux/32bit/LibMpg123-32.so';
    {$endif}
    SoundFilename := ordir + 'sound/test.flac';
   {$ENDIF}

 {$IFDEF freebsd}
    {$if defined(cpu64)}
    PA_FileName := ordir + 'lib/FreeBSD/64bit/libportaudio-64.so';
    SF_FileName := ordir + 'lib/FreeBSD/64bit/libsndfile-64.so';
    MP_FileName := ordir + 'lib/FreeBSD/64bit/libmpg123-64.so';
    {$else}
    PA_FileName := ordir + 'lib/FreeBSD/32bit/libportaudio-32.so';
    SF_FileName := ordir + 'lib/FreeBSD/32bit/libsndfile-32.so';
    MP_FileName := ordir + 'lib/FreeBSD/32bit/libmpg123-32.so';
    {$endif}
    SoundFilename := ordir + 'sound/test.flac';
 {$ENDIF}

 {$IFDEF Darwin}
    opath := ordir;
    opath := copy(opath, 1, Pos('/UOS', opath) - 1);
    PA_FileName := opath + '/lib/Mac/32bit/LibPortaudio-32.dylib';
    SF_FileName := opath + '/lib/Mac/32bit/LibSndFile-32.dylib';
    SoundFilename := opath + '/sound/test.flac';
 {$ENDIF}

   // Load the libraries
   // function uos_loadlib(PortAudioFileName, SndFileFileName, Mpg123FileName, Mp4ffFileName, FaadFileName,  opusfilefilename: PChar) : LongInt;
   res := uos_LoadLib(Pchar(PA_FileName), Pchar(SF_FileName), Pchar(MP_FileName), nil, nil, nil) ;

    writeln('Result of loading (if 0 => ok ) : ' + IntToStr(res));

   if res = 0 then begin
   
       PlayerIndex1 := 0;
       
       // Create a memory stream from a audio file
       thememorystream:= TMemoryStream.Create; 
       thememorystream.LoadFromFile(pchar(SoundFilename)); 
       thememorystream.Position:= 0; 
       
      
       uos_CreatePlayer(PlayerIndex1);

   // Add a input from memory stream with custom parameters
   uos_AddFromMemoryStream(PlayerIndex1,thememorystream,-1,-1,-1,0,512);
 
   writeln('uos_inputlength(0,0) = ' + inttostr(uos_inputlength(0,0))); 

   // add a Output into device with default parameters
   uos_AddIntoDevOut(PlayerIndex1, -1, -1, -1, -1, 0,512);

    /////// everything is ready, here we are, lets play it...

   uos_Play(PlayerIndex1);
   
    sleep(2000);
    end;

 end;

  procedure TuosConsole.doRun;
  begin
    ConsolePlay;
    writeln('Press a key to exit...');
    readln;
    Terminate;
  //  thememorystream.free;
    sleep(50);
    uos_free();
  end;

constructor TuosConsole.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

var
  Application: TUOSConsole;
begin
  Application := TUOSConsole.Create(nil);
  Application.Title := 'Console Player from Memory';
  Application.Run;
  Application.Free;
end.

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

begin
end.
