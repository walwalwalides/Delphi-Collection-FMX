{ ============================================
  Software Name : 	PrintMySinature
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com           }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, System.ImageList, FMX.ImgList,
  FMX.Colors, FMX.Printer, FMX.Menus{$IFDEF WIN32},winapi.windows{$ENDIF};

type
  TLineStatus = (sStart, sNext, sEnd);

  TLinePoint = record
    Positon: TPointF;
    Status: TLineStatus;
  end;

  PLinePoint = ^TLinePoint;

  TfrmMain = class(TForm)
    PaintBox1: TPaintBox;
    SplitMittel: TSplitter;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    btnClear: TButton;
    ilMain: TImageList;
    btnLastLine: TButton;
    ColorPanelSignature: TColorPanel;
    btnPrintSignature: TButton;
    PrintDialogSignature: TPrintDialog;
    btnSaveSignature: TButton;
    SaveDialog1: TSaveDialog;
    MMSignature: TMainMenu;
    MiFile: TMenuItem;
    MiExit: TMenuItem;
    MiInformation: TMenuItem;
    MiAbout: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure btnClearClick(Sender: TObject);
    procedure btnLastLineClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnPrintSignatureClick(Sender: TObject);
    procedure btnSaveSignatureClick(Sender: TObject);
    procedure MiExitClick(Sender: TObject);
    procedure MiAboutClick(Sender: TObject);
  private
    DrawPoints: TList<TLinePoint>;
    PressStatus: Boolean;
    procedure AddPoint(const X, Y: Single; const Status: TLineStatus);

    { private }

  public
    { public }
  end;

const
  crSignature = 1;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses FMX.platform, System.SysConst,uAbout;

type
  TMyCursorService = class(TInterfacedObject, IFMXCursorService)
  private
//    class var FWinCursorService: TWinCursorService;
    class var FoldWinPlatformService: IFMXCursorService;
    class var FCursor: TCursor;
    class var FMyService: TMyCursorService;
  public
    class constructor Create;
    procedure SetCursor(const ACursor: TCursor);
    function GetCursor: TCursor;
  end;

const
  My_Signature = PChar(1000);

  { TWinCursorService }

class constructor TMyCursorService.Create;
begin
  FMyService := TMyCursorService.Create;
  FoldWinPlatformService := IFMXCursorService(TPlatformServices.Current.GetPlatformService(IFMXCursorService));
  TPlatformServices.Current.RemovePlatformService(IFMXCursorService);
  TPlatformServices.Current.AddPlatformService(IFMXCursorService, FmyService);
end;

function TMyCursorService.GetCursor: TCursor;
begin
  Result := FCursor;
end;

procedure TMyCursorService.SetCursor(const ACursor: TCursor);
const
MapCursor:
array [1 .. 1] of PChar = (My_Signature);
var
  NewCursor:Hcursor;
begin
  FCursor := ACursor;
  if FCursor in [1 .. 1] then
  begin
    NewCursor:=LoadCursorW(HInstance, MapCursor[FCursor]);
    Winapi.Windows.SetCursor(NewCursor);

  end
  else
  begin
    FoldWinPlatformService.SetCursor(ACursor);
  end;
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
var
  i, k: integer;
begin
  i := DrawPoints.Count;
  if (i < 0) and (i > DrawPoints.Count) then
    exit;
  for k := 0 to DrawPoints.Count - 1 do
  begin
    DrawPoints.Remove(DrawPoints.Last);
  end;

  PaintBox1.Repaint;
end;

procedure TfrmMain.btnLastLineClick(Sender: TObject);
var
  i, k: integer;
begin
  i := DrawPoints.Count - 2;
  if (i < 0) and (i > DrawPoints.Count) then
    exit;

  DrawPoints.Remove(DrawPoints.Last);
  DrawPoints.Remove(DrawPoints.Last);

  PaintBox1.Repaint;
end;

procedure TfrmMain.btnPrintSignatureClick(Sender: TObject);
var
  Printer: TPrinter;

var
  SrcRect, DestRect: TRectF;

begin
  if PrintDialogSignature.Execute then
  begin

    Printer.ActivePrinter.SelectDPI(1200, 1200);

    Printer.Canvas.Fill.Color := TAlphaColorRec.Black;
    Printer.Canvas.Fill.Kind := TBrushKind.Solid;

    Printer.BeginDoc;

    SrcRect := PaintBox1.LocalRect;
    DestRect := TRectF.Create(0, 0, Printer.PageWidth, Printer.PageHeight);

    Printer.Canvas.DrawBitmap(PaintBox1.Canvas.Bitmap, SrcRect, DestRect, 1);

    Printer.EndDoc;
  end;
end;

procedure TfrmMain.btnSaveSignatureClick(Sender: TObject);
Const
  iRecX = 0;
  iRecY = 0;
  iRecW = 500;
  iRecH = 300;
  iLeft = 10;
  iTop = 20;
var
  rSource: TRect;
  rDest: TRect;
  bmp:TBitmap;

begin
  rSource := TRect.Create(iLeft, iTop, iRecW + iLeft, iRecH + iTop); // Rect in source bm
  rDest := TRect.Create(iRecX, iRecY, iRecW, iRecH); // Rect of destination bm

  {$IFDEF ANDROID}
  if SaveDialog1.Execute then
    with TBitmap.Create do
    try
    //         PixelFormat := pf32bit;
    //     Width := Round(PaintBox1.Width);
    //        Height := Round(PaintBox1.Height);
    Canvas.DrawBitmap(PaintBox1.Canvas.Bitmap, rSource, rDest, 1);
    SaveToFile(SaveDialog1.FileName);
    finally
    Free;
    end;
   {$ENDIF}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  CS: IFMXCursorService;
begin
  self.position := TFormPosition.MainFormCenter;
  self.WindowState := TWindowState.wsMaximized;
  pnlLeft.Width := frmMain.Width + pnlLeft.Width;
  ColorPanelSignature.Color := TAlphaColorRec.Black;

  DrawPoints := TList<TLinePoint>.Create;
  btnClear.Cursor := crHandPoint;

  TMyCursorService.Create

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  DrawPoints.DisposeOf;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  PaintBox1.Repaint;
end;

procedure TfrmMain.MiAboutClick(Sender: TObject);
var
  f: TfrmAbout;
begin

  if  Assigned(f) then
    Application.CreateForm(TfrmAbout, f);
  f.Position :=  TFormPosition.MainFormCenter;
  try
    f.ShowModal;
  finally
    FreeAndNil(f);
  end;

end;

procedure TfrmMain.MiExitClick(Sender: TObject);
begin
Application.terminate;
end;

procedure TfrmMain.AddPoint(const X, Y: Single; const Status: TLineStatus);
var
  TLP: TLinePoint;
begin
  if (DrawPoints.Count < 0) then
    exit;

  TLP.Positon := PointF(X, Y);
  TLP.Status := Status;
  DrawPoints.Add(TLP);
  PaintBox1.Repaint;
end;

procedure TfrmMain.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if ssLeft in Shift then
  begin
    PressStatus := True;
    AddPoint(X, Y, sStart);

  end;
end;

procedure TfrmMain.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  if ssLeft in Shift then
  begin
    if (PressStatus = True) then
      AddPoint(X, Y, sNext);
  end;
end;

procedure TfrmMain.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if (PressStatus = True) then
  begin
    AddPoint(X, Y, sEnd);
  end;
  PressStatus := false;
end;

procedure TfrmMain.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
var
  TLP: TLinePoint;
  StartPoint: TPointF;
begin
  if (DrawPoints.Count < 0) then
    exit;

  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Dash := TStrokeDash.Solid;
  Canvas.Stroke.Thickness := 2;

  Canvas.Stroke.Color := ColorPanelSignature.Color;

  for TLP in DrawPoints do
  begin
    case TLP.Status of
      sStart:
        StartPoint := TLP.Positon;
    else
      begin
        Canvas.DrawLine(StartPoint, TLP.Positon, 1, Canvas.Stroke);
        StartPoint := TLP.Positon;
      end;
    end;
  end;
end;

end.
