unit ScrollTransition;

interface

uses
  CustomTransition;

type
  TScrollOrigin = (soTopLeft,soTop,soTopRight,soRight,soBottomRight,
    soBottom,soBottomLeft,soLeft);

type
  TScrollTransition = class(TCustomTransition)
  { This transition allows scrolling the second bitmap into the first. }
  private
    FScrollOrigin: TScrollOrigin;
    FNumIterations: Integer;
    FX, FY: Integer;
    FDX, FDY: Integer;
  protected
    procedure BeginTransition; override;
    function PlayStep: Boolean; override;
  public
    property ScrollOrigin: TScrollOrigin read FScrollOrigin write FScrollOrigin;
    { Determines from which direction the scroll originates. }
  end;

implementation

uses
  Windows, Math;

{ TScrollTransition }

procedure TScrollTransition.BeginTransition;
var
  NumHorz, NumVert: Integer;
begin
  { Calculate the number of iterations needed to complete the transition.
    The bitmap is scrolled 8 pixels at a time, so the number of iterations
    can be calculated by dividing the width or height of the bitmap by 8. }
  NumHorz := (Target.Width + 7) div 8;
  NumVert := (Target.Height + 7) div 8;
  if (FScrollOrigin in [soLeft,soRight]) then
    FNumIterations := NumHorz
  else if (FScrollOrigin in [soTop,soBottom]) then
    FNumIterations := NumVert
  else
    FNumIterations := Max(NumHorz,NumVert);

  { Calculate the start position of the second bitmap (FX and FY) and the
    number of pixels the bitmap is scrolled each iteration (FDX and FDY).
    These values depend on the scroll origin. }
  if (FScrollOrigin in [soTopLeft,soBottomLeft,soLeft]) then begin
    FX := -FNumIterations * 8;
    FDX := 8;
  end else if (FScrollOrigin in [soTopRight,soBottomRight,soRight]) then begin
    FX := FNumIterations * 8;
    FDX := -8;
  end else begin
    FX := 0;
    FDX := 0;
  end;

  if (FScrollOrigin in [soTopLeft,soTopRight,soTop]) then begin
    FY := -FNumIterations * 8;
    FDY := 8;
  end else if (FScrollOrigin in [soBottomLeft,soBottomRight,soBottom]) then begin
    FY := FNumIterations * 8;
    FDY := -8;
  end else begin
    FY := 0;
    FDY := 0;
  end;

  { As a first step, render the first bitmap to the target canvas. The
    additional iterations render portions of the second bitmap }
  Target.Canvas.Draw(0,0,Bitmap1);
end;

function TScrollTransition.PlayStep: Boolean;
begin
  { This transition is fairly simple: just render Bitmap2 to the calculated
    destination coordinates (FX, FY) and update these coordinates each step
    until the calculated number of iterations is reached. }
  Result := (FNumIterations >= 0);
  if Result then begin
    BitBlt(Target.Canvas.Handle,FX,FY,Bitmap2.Width,Bitmap2.Height,
      Bitmap2.Canvas.Handle,0,0,SRCCOPY);
    Inc(FX,FDX);
    Inc(FY,FDY);
    Dec(FNumIterations);
  end;
end;

end.
