unit Procedury;

interface

uses Windows, SysUtils, Graphics;


procedure KresliTank(tank: integer);
procedure VymazTank(tank: integer);
procedure VymazPadak(tank: integer);
procedure KresliPadak(tank: integer);

implementation

uses kresleni, uStorch;

procedure KresliTank(tank: integer);
begin
   Pulkruh(Form1.DXDraw.Surface.Canvas,Tanky[Tank].pos.X,Tanky[Tank].pos.Y,RTanku,Tanky[Tank].Barva);
   Pulkruh(Form1.DXDraw.Surface.Canvas,Tanky[Tank].pos.X,Tanky[Tank].pos.Y,RTanku div 2,Tanky[Tank].health*Tanky[Tank].Barva div 100);
end;


procedure VymazTank(tank: integer);
begin
   Pulkruh(Form1.DXDraw.Surface.Canvas,Tanky[Tank].pos.X,Tanky[Tank].pos.Y,RTanku,BOblohy);
   Form1.DXDraw.Surface.Canvas.Pen.Width:=2;
   Form1.DXDraw.Surface.Canvas.Pen.Color:=BOblohy;
   Form1.DXDraw.Surface.Canvas.MoveTo(Tanky[Tank].delo[0].X,Tanky[Tank].delo[0].Y);
   Form1.DXDraw.Surface.Canvas.LineTo(Tanky[Tank].delo[1].X,Tanky[Tank].delo[1].Y);
   Form1.DXDraw.Surface.Canvas.Pen.Width:=1;
end;

procedure VymazPadak(tank: integer);
begin
   Pulkruh(Form1.DXDraw.Surface.Canvas,Tanky[tank].pos.X,Tanky[tank].pos.Y-2*Rtanku,Rtanku,BOblohy);
   Form1.DXDraw.Surface.Canvas.MoveTo(Tanky[tank].pos.X,Tanky[tank].pos.Y-1);
   Form1.DXDraw.Surface.Canvas.LineTo(Tanky[tank].pos.X+RTanku,Tanky[tank].pos.Y-2*RTanku-1);
   Form1.DXDraw.Surface.Canvas.MoveTo(Tanky[tank].pos.X,Tanky[tank].pos.Y-1);
   Form1.DXDraw.Surface.Canvas.LineTo(Tanky[tank].pos.X-RTanku,Tanky[tank].pos.Y-2*RTanku-1);
end;

procedure KresliPadak(tank: integer);
begin
   Pulkruh(Form1.DXDraw.Surface.Canvas,Tanky[tank].pos.X,Tanky[tank].pos.Y-2*Rtanku,Rtanku,clWhite);
   Form1.DXDraw.Surface.Canvas.Pen.Color:=clBlack;
   Form1.DXDraw.Surface.Canvas.MoveTo(Tanky[tank].pos.X,Tanky[tank].pos.Y-1);
   Form1.DXDraw.Surface.Canvas.LineTo(Tanky[tank].pos.X+RTanku,Tanky[tank].pos.Y-2*RTanku-1);
   Form1.DXDraw.Surface.Canvas.MoveTo(Tanky[tank].pos.X,Tanky[tank].pos.Y-1);
   Form1.DXDraw.Surface.Canvas.LineTo(Tanky[tank].pos.X-RTanku,Tanky[tank].pos.Y-2*RTanku-1);
end;

end.
