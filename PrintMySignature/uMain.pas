{ ============================================
  Software Name : 	PrintMySinature
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2019 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }
unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  System.Generics.Collections,
  FMX.Types, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, System.ImageList, FMX.ImgList,
  FMX.Colors, FMX.Printer, FMX.Menus{$IFDEF WIN32}, winapi.windows,
  FMX.ExtCtrls, FMX.Controls, FMX.Effects, FMX.Filter.Effects{$ENDIF};

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
    Button1: TButton;
    Image1: TImage;
    MonochromeEffect1: TMonochromeEffect;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure btnClearClick(Sender: TObject);
    procedure btnLastLineClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnPrintSignatureClick(Sender: TObject);
    procedure btnSaveSignatureClick(Sender: TObject);
    procedure MiExitClick(Sender: TObject);
    procedure MiAboutClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    DrawPoints: TList<TLinePoint>;
    Marks: Single;
    Frequency: Single;
    PressStatus: Boolean;
    FLineFill: TStrokeBrush;
    procedure AddPoint(const X, Y: Single; const Status: TLineStatus);
    function snaptogrid(gridxy, pos: integer): integer;

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

uses FMX.platform, System.SysConst, uAbout, System.UIConsts, System.IOUtils, FMX.TextLayout, System.Math.vectors;

type
  TMyCursorService = class(TInterfacedObject, IFMXCursorService)
  private
    // class var FWinCursorService: TWinCursorService;
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
  FoldWinPlatformService := IFMXCursorService
    (TPlatformServices.Current.GetPlatformService(IFMXCursorService));
  TPlatformServices.Current.RemovePlatformService(IFMXCursorService);
  TPlatformServices.Current.AddPlatformService(IFMXCursorService, FMyService);
end;

function TMyCursorService.GetCursor: TCursor;
begin
  Result := FCursor;
end;

function TfrmMain.snaptogrid(gridxy, pos: integer): integer;
var
  i, u, t: integer;
  hw: real;
begin

  hw := PaintBox1.Width / 25;

  for i := 1 to 25 do
  begin
    u := trunc(hw * i);
    t := trunc(hw * (i + 1));
    if (pos > u) and (pos < t) then
    begin

      Result := trunc(hw * i);
    end;
  end;
end;

procedure TMyCursorService.SetCursor(const ACursor: TCursor);
const
  MapCursor: array [1 .. 1] of PChar = (My_Signature);
var
  NewCursor: Hcursor;
begin
  FCursor := ACursor;
  if FCursor in [1 .. 1] then
  begin
    NewCursor := LoadCursorW(HInstance, MapCursor[FCursor]);
    winapi.windows.SetCursor(NewCursor);

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
  bmp: TBitmap;

Begin
  rSource := TRect.Create(iLeft, iTop, iRecW + iLeft, iRecH + iTop);
  // Rect in source bm
  rDest := TRect.Create(iRecX, iRecY, iRecW, iRecH); // Rect of destination bm

{$IFDEF ANDROID}
  if SaveDialog1.Execute then
    with TBitmap.Create do
      try
        // PixelFormat := pf32bit;
        // Width := Round(PaintBox1.Width);
        // Height := Round(PaintBox1.Height);
        Canvas.DrawBitmap(PaintBox1.Canvas.Bitmap, rSource, rDest, 1);
        SaveToFile(SaveDialog1.FileName);
      finally
        Free;
      end;
{$ENDIF}
  // PaintBox1.Canvas.Bitmap.SaveToFile('test.bmp');

end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  MyCanvas: TCanvas;
  Save: TCanvasSaveState;
  pl: TRectF;
  tmpPath: string;
  MyBitmap: FMX.Graphics.TBitmap;
  rScr, rDstr,aRect: TRectF;
begin
  tmpPath := Tpath.GetLibraryPath + 'test.bmp';

  // Save := PaintBox1.Canvas.SaveState;
  // try
  // PaintBox1.Canvas.IntersectClipRect(TRectF.Create(20, 20, 100, 100));
  // PaintBox1.Canvas.Fill.Color := claRed;
  // PaintBox1.Canvas.FillEllipse(TRectF.Create(50, 50, 150, 150), 100);
  // finally
  // PaintBox1.Canvas.RestoreState(Save);
  // end;
  //
  // // Example of ExcludeClipRect
  // Save := PaintBox1.Canvas.SaveState;
  // try
  // PaintBox1.Canvas.ExcludeClipRect(TRectF.Create(60, 210, 90, 240));
  // PaintBox1.Canvas.Fill.Color := claBlue;
  // PaintBox1.Canvas.FillEllipse(TRectF.Create(50, 200, 100, 250), 100);
  // pl.Create(60, 210, 90, 240);
  // PaintBox1.Canvas.DrawRect(pl, 0, 0, AllCorners, 100);
  // finally
  // PaintBox1.Canvas.RestoreState(Save);
  // end;
  //
    { TODO : save paintbox as bitmap and convert to jpg }

  MyBitmap := FMX.Graphics.TBitmap.Create;
//  rScr.Create(0, 0, PaintBox1.Width, PaintBox1.Height);
//  PaintBox1.Canvas.BeginScene;
//  PaintBox1.Canvas.DrawBitmap(MyBitmap, rScr, rScr, 20);
//  PaintBox1.Canvas.EndScene;

    aRect := RectF(0,0,MyBitmap.Width,MyBitmap.Height);
 PaintBox1.Canvas.DrawBitmap(MyBitmap, aRect, PaintBox1.ClipRect, 1, False);

  try
    MyBitmap.SaveToFile(tmpPath);
  finally
    MyBitmap.Free;
  end;

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

  TMyCursorService.Create;
  // ------------------------------- //
  FLineFill := TStrokeBrush.Create(TBrushKind.Solid, $FF505050);
  Marks := 50;
  Frequency := 20;
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

  if Assigned(f) then
    Application.CreateForm(TfrmAbout, f);
  f.position := TFormPosition.MainFormCenter;
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

procedure TfrmMain.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if ssLeft in Shift then
  begin
    PressStatus := True;
    AddPoint(X, Y, sStart);

  end;
end;

procedure TfrmMain.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
  if ssLeft in Shift then
  begin
    if (PressStatus = True) then
      AddPoint(X, Y, sNext);
  end;
end;

procedure TfrmMain.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
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

  X, Y: Single;

  TextLayout: TTextLayout;
  TextPath: TPathData;
begin

{$REGION 'Add three rectangle'}

//
//  Canvas.Fill := Canvas.Fill;
//  TextLayout := TTextLayoutManager.DefaultTextLayout.Create;
//  try
//    TextPath := TPathData.Create;
//    try
//      TextLayout.Font.Size :=15;
//      TextLayout.Text := 'Enter a Number : ';
//      TextLayout.ConvertToPath(TextPath);
//      TextPath.ApplyMatrix(System.Math.vectors.TMatrix.CreateTranslation(3,0));
//      Canvas.FillPath(TextPath, 1);
//      Canvas.DrawPath(TextPath, 1);
//    finally
//      TextPath.Free;
//    end;
//  finally
//    TextLayout.Free;
//  end;
//  X := 0;
//  Y := 0;
//  Canvas.Stroke.Assign(FLineFill);
//  while X < Width / 2 do
//  begin
//    if (X = 0) then
//    begin
//      Canvas.Stroke.Thickness := 4;
//      Canvas.Stroke.Color := FLineFill.Color
//    end
//    else
//    begin
//      if (frac(X) = 0) and (frac(X / Frequency / Marks) = 0) then
//        Canvas.Stroke.Color := FLineFill.Color
//      else
//        Canvas.Stroke.Color := MakeColor(FLineFill.Color, 0.4);
//
//      Canvas.Stroke.Thickness := 1;
//    end;
//
//    Canvas.DrawLine(PointF(0, 0), PointF(0, 300), 1, Canvas.Stroke);
//    Canvas.DrawLine(PointF(300, 0), PointF(300, 300), 1, Canvas.Stroke);
//    Canvas.DrawLine(PointF(600, 0), PointF(600, 300), 1, Canvas.Stroke);
//    Canvas.DrawLine(PointF(900, 0), PointF(900, 300), 1, Canvas.Stroke);
//
//    // Canvas.DrawLine(PointF(round(Width / 2) + X + (Canvas.Stroke.Thickness / 2),
//    // 0), PointF(round(Width / 2) + X + (Canvas.Stroke.Thickness / 2), Height),
//    // 1, Canvas.Stroke);
//
//    // if X <> 0 then
//    // Canvas.DrawLine(PointF(round(Width / 2) - X + (Canvas.Stroke.Thickness /
//    // 2), 0), PointF(round(Width / 2) - X + (Canvas.Stroke.Thickness / 2),
//    // Height), 1, Canvas.Stroke);
//    X := X + Frequency;
//  end;
//  while Y < Height / 2 do
//  begin
//    if (Y = 0) then
//    begin
//      Canvas.Stroke.Thickness := 4;
//      Canvas.Stroke.Color := FLineFill.Color
//    end
//    else
//    begin
//      if (frac(Y) = 0) and (frac(Y / Frequency / Marks) = 0) then
//        Canvas.Stroke.Color := FLineFill.Color
//      else
//        Canvas.Stroke.Color := MakeColor(FLineFill.Color, 0.4);
//      Canvas.Stroke.Thickness := 1;
//    end;
//
//    Canvas.DrawLine(PointF(0, 0), PointF(900, 0), 1, Canvas.Stroke);
//    Canvas.DrawLine(PointF(0, 300), PointF(900, 300), 1, Canvas.Stroke);
//
//    // Canvas.DrawLine(PointF(0, round(Height / 2) + Y + (Canvas.Stroke.Thickness /
//    // 2)), PointF(Width, round(Height / 2) + Y + (Canvas.Stroke.Thickness / 2)),
//    // 1, Canvas.Stroke);
//    // if Y <> 0 then
//    // Canvas.DrawLine(PointF(0, round(Height / 2) - Y + (Canvas.Stroke.Thickness
//    // / 2)), PointF(Width, round(Height / 2) - Y + (Canvas.Stroke.Thickness /
//    // 2)), 1, Canvas.Stroke);
//    Y := Y + Frequency;
//  end;

  {$ENDREGION}

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
