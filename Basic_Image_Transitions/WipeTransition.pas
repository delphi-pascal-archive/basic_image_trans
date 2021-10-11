unit WipeTransition;

interface

uses
  CustomTransition;

type
  TWipeMethod = (wmLeftToRight,wmRightToLeft,wmTopToBottom,wmBottomToTop,
    wmBoxIn,wmBoxFromTL,wmBoxFromTR,wmBoxFromBL,wmBoxFromBR);

type
  TWipeTransition = class(TCustomTransition)
  { This transition can be used for several wipe effects }
  private
    FWipeMethod: TWipeMethod;
    FNumIterations: Integer;
    FX, FY, FW, FH: Integer;
    FDX, FDY, FDW, FDH: Integer;
  protected
    procedure BeginTransition; override;
    function PlayStep: Boolean; override;
  public
    property WipeMethod: TWipeMethod read FWipeMethod write FWipeMethod;
    { The method used for the wipe }
  end;

implementation

uses
  Windows, Graphics, Math;

{ TWipeTransition }

procedure TWipeTransition.BeginTransition;
var
  NumHorz, NumVert: Integer;
begin
  { Calculate the number of iterations needed to complete the transition.
    The wipe is performed in increments of 8 pixels, so the number of iterations
    can be calculated by dividing the width or height of the bitmap by 8. }
  NumHorz := (Target.Width + 7) div 8;
  NumVert := (Target.Height + 7) div 8;
  if FWipeMethod in [wmLeftToRight,wmRightToLeft] then
    FNumIterations := NumHorz
  else if FWipeMethod in [wmTopToBottom,wmBottomToTop] then
    FNumIterations := NumVert
  else
    FNumIterations := Max(NumHorz,NumVert);

  { The wipe is performed by moving a rectangle over the canvas and copying
    this rectangle from Bitmap2 to the target canvas. Each iteration, the
    position and/or size of the rectangle is adjusted by the values FDX, FDY,
    FDW and FDH. The rectangle itself is specified in the parameters FX, FY,
    FW and FH. Here, we calculate the initial size and position of the
    rectangle, and the amount by which the rectangle moves and resizes during
    each iteration. These calculations are based on the selected wipe method. }
  FX := 0; FY := 0; FW := Target.Width; FH := Target.Height;
  FDX := 0; FDY := 0; FDW := 0; FDH := 0;
  case FWipeMethod of
    wmLeftToRight:
      begin
        FW := 8; FDX := 8;
      end;
    wmRightToLeft:
      begin
        FX := FW - 8; FW := 8; FDX := -8;
      end;
    wmTopToBottom:
      begin
        FH := 8; FDY := 8;
      end;
    wmBottomToTop:
      begin
        FY := FH - 8; FH := 8; FDY := -8;
      end;
    wmBoxIn:
      begin
        FX := (FW div 2) - 4; FY := (FH div 2) - 4; FW := 8; FH := 8;
        FDX := -4; FDY := -4; FDW := 8; FDH := 8;
      end;
    wmBoxFromTL:
      begin
        FW := 8; FH := 8; FDW := 8; FDH := 8;
      end;
    wmBoxFromTR:
      begin
        FX := FW - 8; FW := 8; FH := 8;
        FDX := -8; FDW := 8; FDH := 8;
      end;
    wmBoxFromBL:
      begin
        FY := FH - 8; FW := 8; FH := 8;
        FDY := -8; FDW := 8; FDH := 8;
      end;
    wmBoxFromBR:
      begin
        FX := FW - 8; FY := FH - 8; FW := 8; FH := 8;
        FDX := -8; FDY := -8; FDW := 8; FDH := 8;
      end;
  end;

  { As a first step, render the first bitmap to the target canvas. The
    additional iterations render portions of the second bitmap }
  Target.Canvas.Draw(0,0,Bitmap1);
end;

function TWipeTransition.PlayStep: Boolean;
begin
  { The transition works like this: each step, copy the rect (FX,FY,FW,FH)
    from Bitmap2 to the target canvas, and adjust the rect by the values in
    (FDX,FDY,FDW,FDH). This moves and/or resizes the rect during the transition.
    Repeat this process for the calculated number of iterations. }
  Result := (FNumIterations > 0);
  if Result then begin
    if (FW > 0) and (FH > 0) then
      BitBlt(Target.Canvas.Handle,FX,FY,FW,FH,Bitmap2.Canvas.Handle,FX,FY,SRCCOPY);
    Inc(FX,FDX);
    Inc(FY,FDY);
    Inc(FW,FDW);
    Inc(FH,FDH);
    Dec(FNumIterations);
  end;
end;

end.
