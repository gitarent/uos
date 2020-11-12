unit u_tools;

{$mode objfpc}{$H+}

interface

  uses
    Classes, SysUtils;

  function  u_getdriver( basedir: string ): string;

implementation

function u_getdriver( basedir: string ): string;
{$IFDEF Darwin}
var
  opath: string;
{$ENDIF}
begin
{$IFDEF Windows}
 {$if defined(cpu64)}
   result := basedir + 'lib\Windows\64bit\LibPortaudio-64.dll';
 {$else}
   result := basedir + 'lib\Windows\32bit\LibPortaudio-32.dll';
 {$endif}
{$ENDIF}

{$IFDEF Darwin}
 {$IFDEF CPU32}
  opath := basedir;
  opath := copy( opath, 1, Pos('/uos', opath) - 1);
  edit1.Text := opath + '/lib/Mac/32bit/LibPortaudio-32.dylib';
 {$ENDIF}
 {$IFDEF CPU64}

  opath := basedir
  opath := copy( opath, 1, Pos('/uos', opath) - 1);
  Edit1.Text := opath + '/lib/Mac/64bit/LibPortaudio-64.dylib';
 {$ENDIF}
{$ENDIF}

{$if defined(cpu64) and defined(linux) }
  result := basedir + 'lib/Linux/64bit/LibPortaudio-64.so';
{$endif}

{$if defined(cpu86) and defined(linux)}
  result := basedir + 'lib/Linux/32bit/LibPortaudio-32.so';
{$endif}

{$if defined(linux) and defined(cpuarm)}
  result := basedir + 'lib/Linux/arm_raspberrypi/libportaudio-arm.so';
{$endif}

{$IFDEF freebsd}
  {$if defined(cpu64)}
    result := basedir + 'lib/FreeBSD/64bit/libportaudio-64.so';
 {$else}
    result := basedir + 'lib/FreeBSD/32bit/libportaudio-32.so';
 {$endif}
{$ENDIF}
end;


end.

