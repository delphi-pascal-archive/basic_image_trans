unit FadeTransition;

interface

uses
  Windows, CustomTransition;

type
  TFadeTransition = class(TCustomTransition)
  { This transition uses alpha blending to perform a fade between two bitmaps }
  private
    FAlpha: Integer;
  protected
    procedure BeginTransition; override;
    function PlayStep: Boolean; override;
  end;

implementation

{ TFadeTransition }

procedure TFadeTransition.BeginTransition;
begin
  { The Alpha value determines with how much transparency Bitmap2 is rendered
    over Bitmap1. 0 means totally transparent and 255 means totally opaque. }
  FAlpha := 0;
end;

function TFadeTransition.PlayStep: Boolean;
var
  BF: TBlendFunction;
  W, H: Integer;
begin
  Result := (FAlpha <= 255);
  if Result then begin
    Target.Canvas.Draw(0,0,Bitmap1);

    // NOTE: AlphaBlend does not work in Windows 95 and Windows NT
    BF.BlendOp := AC_SRC_OVER;
    BF.BlendFlags := 0;
    BF.SourceConstantAlpha := FAlpha;
    BF.AlphaFormat := 0;
    W := Target.Width;
    H := Target.Height;
    AlphaBlend(Target.Canvas.Handle,0,0,W,H,
      Bitmap2.Canvas.Handle,0,0,W,H,BF);

    Inc(FAlpha,5);
  end;
end;

end.
