program deviceinfos;

{$mode objfpc}{$H+}
 {$DEFINE UseCThreads}

uses
  {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads,
  cwstring, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  main_deviceinfo, u_tools { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfDeviceInfo, fDeviceInfo);
  Application.Run;
end.


