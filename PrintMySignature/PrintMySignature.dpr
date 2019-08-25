program PrintMySignature;

{$R 'Cursors.res' 'Resource\Cursors\Cursors.rc'}
{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain},
  uAbout in 'About\uAbout.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
