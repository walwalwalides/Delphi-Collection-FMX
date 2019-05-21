{ ============================================
  Software Name : 	MyAppConec
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit Server;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Types,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmServer = class(TForm)
    lblDTServ: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmServer: TfrmServer;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

procedure TfrmServer.FormCreate(Sender: TObject);
begin
  Position := TFormPosition.MainFormCenter;
  lblDTServ.Position.x := 3;
  lblDTServ.Position.y := 3;
  lblDTServ.StyledSettings := [TStyledSetting.Family, TStyledSetting.Size, TStyledSetting.FontColor];
  //----------------------------------------------------------------------------------------------
//  lblDTServ.TextSettings.Font.Style := [TFontStyle.fsBold];
  lblDTServ.TextSettings.Font.Size := 25;
//  lblDTServ.TextSettings.Font.Style := lblDTServ.TextSettings.Font.Style + [TFontStyle.fsBold];
  lblDTServ.Text := 'Starting Time : '+DateTimeToStr(Now);

end;

end.
