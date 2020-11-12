(*****************************************************************************
 *                      main_deviceinfo
 *
 * Show all audio devices available to UOS
 ****************************************************************************)
unit main_deviceinfo;

{$mode objfpc}{$H+}

interface

uses
  Controls, Forms, Dialogs, SysUtils, Graphics,
  StdCtrls, ExtCtrls, Grids, Classes,
  uos_flat;

type

  { TfDeviceInfo }

  TfDeviceInfo = class(TForm)
    btnLoad: TButton;
    btnReload: TButton;
    edDriverFile: TEdit;
    imgLogo: TImage;
    lblDescription: TLabel;
    lblNDevices: TLabel;
    lblDevIn: TLabel;
    lblDevOut: TLabel;
    gAudioDrivers: TStringGrid;
    pnlInfo: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
  private
    procedure GetAudioInfo();
  end;

var
  fDeviceInfo: TfDeviceInfo;

implementation

{$R *.lfm}

uses
  u_tools;

procedure TfDeviceInfo.FormCreate(Sender: TObject);
begin
  edDriverFile.Text := u_getdriver( application.Location );
  pnlInfo.Visible := false;
end;


procedure TfDeviceInfo.FormDestroy(Sender: TObject);
begin
  if btnLoad.Enabled = False then
    uos_free();
end;


procedure TfDeviceInfo.GetAudioInfo();
var
  i: integer;
begin

  uos_GetInfoDevice();

  lblNDevices.Caption := 'Device Count = ' + IntToStr(uosDeviceCount);
  lblDevIn.Caption := 'Default Device IN = ' + IntToStr(uosDefaultDeviceIN);
  lblDevOut.Caption := 'Default Device OUT = ' + IntToStr(uosDefaultDeviceOUT);
  gAudioDrivers.rowcount := uosDeviceCount + 1;

  i := 1;
  while i < uosDeviceCount + 1  do
  begin
    gAudioDrivers.Cells[0, i] := IntToStr(uosDeviceInfos[i - 1].DeviceNum);
    gAudioDrivers.Cells[1, i] := uosDeviceInfos[i - 1].DeviceName;
    if uosDeviceInfos[i - 1].DefaultDevIn = True then
      gAudioDrivers.Cells[2, i] := 'Yes'
    else
      gAudioDrivers.Cells[2, i] := 'No';

    if uosDeviceInfos[i - 1].DefaultDevOut = True then
      gAudioDrivers.Cells[3, i] := 'Yes'
    else
      gAudioDrivers.Cells[3, i] := 'No';

    gAudioDrivers.Cells[4, i] := IntToStr(uosDeviceInfos[i - 1].ChannelsIn);
    gAudioDrivers.Cells[5, i] := IntToStr(uosDeviceInfos[i - 1].ChannelsOut);
    gAudioDrivers.Cells[6, i] := floattostrf(uosDeviceInfos[i - 1].SampleRate, ffFixed, 15, 0);
    gAudioDrivers.Cells[7, i] := floattostrf(uosDeviceInfos[i - 1].LatencyHighIn, ffFixed, 15, 8);
    gAudioDrivers.Cells[8, i] := floattostrf(uosDeviceInfos[i - 1].LatencyHighOut, ffFixed, 15, 8);
    gAudioDrivers.Cells[9, i] := floattostrf(uosDeviceInfos[i - 1].LatencyLowIn, ffFixed, 15, 8);
    gAudioDrivers.Cells[10, i] := floattostrf(uosDeviceInfos[i - 1].LatencyLowOut, ffFixed, 15, 8);
    gAudioDrivers.Cells[11, i] := uosDeviceInfos[i - 1].HostAPIName;
    gAudioDrivers.Cells[12, i] := uosDeviceInfos[i - 1].DeviceType;
    Inc(i);
  end;
end;


procedure TfDeviceInfo.btnLoadClick(Sender: TObject);
begin
    // Load PortAudio library
    // function  uos_loadlib( PortAudioFileName, SndFileFileName, Mpg123FileName, Mp4ffFileName,
    //                       FaadFileName, opusfilefilename: PChar) : LongInt;
  Screen.Cursor := crHourglass;

  if uos_LoadLib(pchar(edDriverFile.Text), nil, nil, nil, nil, nil) = 0 then begin
    btnLoad.Caption := 'PortAudio is loaded!';
    edDriverFile.ReadOnly := true;

    GetAudioInfo();

    pnlInfo.Visible := true;
    Screen.Cursor := crDefault;
  end  else  begin
    Screen.Cursor := crDefault;
    if uosLoadResult.PAloaderror = 1 then
      MessageDlg(edDriverFile.Text + ' does not exist...', mtWarning, [mbYes], 0);
    if uosLoadResult.PAloaderror = 2 then
      MessageDlg(edDriverFile.Text + ' does not load...', mtWarning, [mbYes], 0);
  end;
end;


procedure TfDeviceInfo.btnReloadClick(Sender: TObject);
begin
  GetAudioInfo();
end;


end.
