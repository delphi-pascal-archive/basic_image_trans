unit CustomTransition;

interface

uses
  Windows, Graphics;

type
  TCustomTransition = class
  { Abstract base class for various transition effects }
  private
    FBitmap1: TBitmap;
    FBitmap2: TBitmap;
    FTarget: TBitmap;
    FCanvas: TCanvas;
  protected
    property Bitmap1: TBitmap read FBitmap1;
    { The first bitmap used in the transition. The transition is from the
      first bitmap to the second. }

    property Bitmap2: TBitmap read FBitmap2;
    { The second bitmap used in the transition.
      NOTE: In this implementation, the dimensions of this bitmap must match
      those if Bitmap1. }

    property Target: TBitmap read FTarget;
    { The target bitmap to which the transition is rendered }

    procedure BeginTransition; virtual; abstract;
    { Abstract method called when the transition is started. Derived classes
      must override this method to perform the necessary initialization steps }

    function PlayStep: Boolean; virtual; abstract;
    { Abstract function that is called to render one frame of the transition
      to the Target bitmap. Derived classes must override this method to
      perform the actual rendering of a single transition frame. The function
      must return False if the transition has finished (if there are no more
      frames left to render) }
  public
    constructor Create;
    destructor Destroy; override;

    procedure Initialize(const Bitmap1, Bitmap2: TBitmap; const Canvas: TCanvas;
      const X, Y: Integer);
    { Initializes the transition with the two given bitmaps and a target
      canvas. X and Y are the coordinates in the canvas where the center
      of the target bitmap is rendered to.  }

    procedure Play;
    { Plays the transition by gradually changing Bitmap1 to Bitmap2 using the
      transition effect. NOTE: this method works synchronously and returns only
      when the transition has finished. A better method would be to play the
      transition in a separate thread. }
  end;

implementation

{ TCustomTransition }

constructor TCustomTransition.Create;
begin
  inherited;
  FTarget := TBitmap.Create;
end;

destructor TCustomTransition.Destroy;
begin
  FTarget.Free;
  inherited;
end;

procedure TCustomTransition.Initialize(const Bitmap1, Bitmap2: TBitmap;
  const Canvas: TCanvas; const X, Y: Integer);
begin
  Assert(Assigned(Bitmap1));
  Assert(Assigned(Bitmap2));
  Assert(Assigned(Canvas));
  Assert(Bitmap1.Width = Bitmap2.Width);
  Assert(Bitmap1.Height = Bitmap2.Height);

  FBitmap1 := Bitmap1;
  FBitmap2 := Bitmap2;
  FCanvas := Canvas;

  { Match the dimension and pixel format of the target bitmap to that of the
    other bitmaps }
  FTarget.Width := FBitmap1.Width;
  FTarget.Height := FBitmap1.Height;
  FTarget.PixelFormat := FBitmap1.PixelFormat;

  { Move the viewport origin to the given coordinates (usually the center of
    the paint box) so we don't need to include positioning calculations in our
    blit operations }
  SetViewportOrgEx(Canvas.Handle,X,Y,nil);
end;

procedure TCustomTransition.Play;
const
  Delay = 30; // 30 ms between frames
var
  NextTime: Cardinal;
  X, Y: Integer;
begin
  { Initialize the transition }
  BeginTransition;
  X := -FTarget.Width div 2;
  Y := -FTarget.Height div 2;
  NextTime := GetTickCount + Delay;

  { Keep rendering frames with 30 ms intervals until PlayStep returns False }
  while PlayStep do begin
    FCanvas.Draw(X,Y,FTarget);
    while GetTickCount < NextTime do ;
    Inc(NextTime,Delay);
  end;
end;

end.
