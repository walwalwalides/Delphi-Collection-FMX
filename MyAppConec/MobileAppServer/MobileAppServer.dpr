program MobileAppServer;

uses
  FMX.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Server in 'Server.pas' {frmServer},
  ServerMethodsServ in 'ServerMethodsServ.pas' {ServerMethods: TDSServerModule},
  ServerContainerServ in 'ServerContainerServ.pas' {ServerContainer1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  AApplication.CreateForm(TfrmServer, frmServer);
  Application.CreateForm(TServerContainer1, ServerContainer1);
  pplication.Run;
end.

