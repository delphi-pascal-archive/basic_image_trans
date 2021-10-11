unit FMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, FadeTransition, ScrollTransition,
  WipeTransition;

type
  TFrmMain = class(TForm)
    PnlCommands: TPanel;
    RGTransition: TRadioGroup;
    PnlClient: TPanel;
    PaintBox: TPaintBox;
    BtnReplay: TButton;
    procedure BtnReplayClick(Sender: TObject);
    procedure RGTransitionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
  private
    { Private declarations }
    FBitmap1, FBitmap2: TBitmap;
    FFadeTransition: TFadeTransition;
    FScrollTransition: TScrollTransition;
    FWipeTransition: TWipeTransition;
    procedure PlayTransition;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses
{$IFDEF VER150}
  XPMan,
{$ENDIF}
  CustomTransition;

procedure TFrmMain.BtnReplayClick(Sender: TObject);
begin
  PlayTransition;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  FBitmap1 := TBitmap.Create;
  FBitmap1.LoadFromFile('Image1.bmp');

  FBitmap2 := TBitmap.Create;
  FBitmap2.LoadFromFile('Image2.bmp');

  FFadeTransition := TFadeTransition.Create;
  FScrollTransition := TScrollTransition.Create;
  FWipeTransition := TWipeTransition.Create;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FWipeTransition.Free;
  FScrollTransition.Free;
  FFadeTransition.Free;
  FBitmap2.Free;
  FBitmap1.Free;
end;

procedure TFrmMain.PaintBoxPaint(Sender: TObject);
begin
  PaintBox.Canvas.Brush.Color := clGray;
  PaintBox.Canvas.FillRect(PaintBox.ClientRect);
end;

procedure TFrmMain.PlayTransition;
var
  I: Integer;
  Transition: TCustomTransition;
  Temp: TBitmap;
begin
  PaintBox.Repaint;

  I := RGTransition.ItemIndex;
  if (I = 0) then
    Transition := FFadeTransition
  else if (I < 9) then begin
    // Scroll transitions
    FScrollTransition.ScrollOrigin := TScrollOrigin(I - 1);
    Transition := FScrollTransition;
  end else begin
    // Wipe transitions
    FWipeTransition.WipeMethod := TWipeMethod(I - 9);
    Transition := FWipeTransition;
  end;

  Transition.Initialize(FBitmap1,FBitmap2,PaintBox.Canvas,
    PaintBox.Width div 2,PaintBox.Height div 2);
  Transition.Play;

  Temp := FBitmap1;
  FBitmap1 := FBitmap2;
  FBitmap2 := Temp;
end;

procedure TFrmMain.RGTransitionClick(Sender: TObject);
begin
  PlayTransition;
  BtnReplay.Enabled := True;
end;

end.
