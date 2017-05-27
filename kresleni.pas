unit Kresleni;

interface

uses Windows, Graphics, SysUtils;

   procedure Kriz(Objekt: TCanvas; X,Y: integer; Barva: TColor);
   procedure Vybuch(Objekt: TCanvas; X,Y: integer; r: integer; Barva: TColor);
   procedure Pulkruh(Objekt: TCanvas; X,Y: integer; r: integer; Barva: TColor);
   procedure Sipka(Objekt: TCanvas; X,Y: integer; Barva: TColor);
   procedure Ukazatele(Objekt: TCanvas; X,Y: integer; Progress,max,Progress2: integer; Ukaz, Pozadi: TColor);
   procedure Tlacitko(Objekt: TCanvas; X,Y: integer; Barva, Barva2: TColor);
   procedure Info(Objekt: TCanvas; X,Y: integer; Text: string; PBarva: TColor);
   procedure ZaklStrela(Objekt: TCanvas; X,Y: integer);
   procedure Missile(Objekt: TCanvas; X,Y: integer);
   procedure BtnZbrane(Objekt: TCanvas; X,Y: integer; left: bool);
   procedure LittleABomb(Objekt: TCanvas; X,Y: integer);
   procedure ABomb(Objekt: TCanvas; X,Y: integer);
   procedure Button(Objekt: TCanvas; X1,Y1,X2,Y2: integer; Barva: TColor);
   procedure VybStrela(Objekt: TCanvas; X,Y: integer);
   procedure HBomb(Objekt: TCanvas; X,Y: integer);

implementation

procedure Info(Objekt: TCanvas; X,Y: integer; Text: string; PBarva: TColor);
begin
   Objekt.Pen.Color:=clBlack;
   Objekt.Brush.Color:=PBarva;
   Objekt.TextOut(X,Y,Text);
end;

procedure Kriz(Objekt: TCanvas; X,Y: integer; Barva: TColor);
begin
   Objekt.Pixels[X,Y]:=Barva;
   Objekt.Pixels[X+1,Y]:=Barva;
   Objekt.Pixels[X-1,Y]:=Barva;
   Objekt.Pixels[X,Y+1]:=Barva;
   Objekt.Pixels[X,Y-1]:=Barva;
end;

procedure Sipka(Objekt: TCanvas; X,Y: integer; Barva: TColor);
begin
   Objekt.Pixels[X,Y]:=Barva;
   Objekt.Pixels[X,Y-2]:=Barva;
   Objekt.Pixels[X,Y-1]:=Barva;
   Objekt.Pixels[X-1,Y-1]:=Barva;
   Objekt.Pixels[X+1,Y-1]:=Barva;
   Objekt.Pixels[X-2,Y]:=Barva;
   Objekt.Pixels[X-1,Y]:=Barva;
   Objekt.Pixels[X+1,Y]:=Barva;
   Objekt.Pixels[X+2,Y]:=Barva;
   Objekt.Pixels[X-3,Y+1]:=Barva;
   Objekt.Pixels[X-2,Y+1]:=Barva;
   Objekt.Pixels[X-1,Y+1]:=Barva;
   Objekt.Pixels[X,Y+1]:=Barva;
   Objekt.Pixels[X+3,Y+1]:=Barva;
   Objekt.Pixels[X+2,Y+1]:=Barva;
   Objekt.Pixels[X+1,Y+1]:=Barva;
   Objekt.Pixels[X-4,Y+2]:=Barva;
   Objekt.Pixels[X-3,Y+2]:=Barva;
   Objekt.Pixels[X-2,Y+2]:=Barva;
   Objekt.Pixels[X-1,Y+2]:=Barva;
   Objekt.Pixels[X,Y+2]:=Barva;
   Objekt.Pixels[X+4,Y+2]:=Barva;
   Objekt.Pixels[X+3,Y+2]:=Barva;
   Objekt.Pixels[X+2,Y+2]:=Barva;
   Objekt.Pixels[X+1,Y+2]:=Barva;
end;

procedure Vybuch(Objekt: TCanvas; X,Y: integer; r: integer; Barva: TColor);
begin
   Objekt.Brush.Color:=Barva;
   Objekt.Pen.Color:=Barva;
   Objekt.Ellipse(X-r,Y-r,X+r,Y+r);
end;

procedure Pulkruh(Objekt: TCanvas; X,Y: integer; r: integer; Barva: TColor);
begin
   Objekt.Brush.Color:=Barva;
   Objekt.Pen.Color:=Barva;
   Objekt.Chord(X-r,Y-r,X+r+1,Y+r,X+r+1,Y,X-r,Y);
end;

procedure Ukazatele(Objekt: TCanvas; X,Y: integer; Progress, max, Progress2: integer; Ukaz, Pozadi: TColor);
begin
   Objekt.Pen.Color:=clBlack;
   Objekt.Brush.color:=Pozadi+5000;
   Objekt.RoundRect(X,Y,102+X,20+Y,2,2);
   Objekt.RoundRect(X,Y+25,102+X,45+Y,2,2);

   Objekt.Brush.color:=Pozadi-4000;
   Objekt.Pen.Color:=Pozadi;
   Objekt.Pen.Width:=2;
   Objekt.Rectangle(X+2,Y+10,101+X,18+Y);
   Objekt.Rectangle(X+2,Y+35,101+X,43+Y);
   Objekt.Pen.Width:=1;

   Objekt.Pen.color:=Ukaz;
   Objekt.Brush.color:=Ukaz;
   Objekt.Rectangle(1+X,Y+1,progress+1+X,19+Y);
   Objekt.Rectangle(51+X,Y+26,Round((-progress2+90)/90*50 +51 +X),44+Y);

   Objekt.Brush.color:=Ukaz-50;
   Objekt.Pen.color:=Ukaz-25;
   Objekt.Rectangle(1+X,Y+11,progress+1+X,17+Y);
   Objekt.Rectangle(51+X,Y+36,Round((-progress2+90)/90*50 +51 +X),42+Y);

   Objekt.Pen.Color:=0;
   Objekt.MoveTo(max+1+X,Y+1);
   Objekt.LineTo(max+1+X,Y+19);

   Objekt.MoveTo(X+51,Y+26);
   Objekt.LineTo(X+51,Y+44);
end;

procedure Tlacitko(Objekt: TCanvas; X,Y: integer; Barva, Barva2: TColor);
begin
   Objekt.Pen.Color:=Barva2;
   Objekt.Brush.Color:=Barva;
   Objekt.RoundRect(X,Y,X+23,Y+23,2,2);
   Objekt.Pen.Color:=ClBlack;
   Objekt.Pen.Width:=2;
   Objekt.MoveTo(X+5,Y+5);
   Objekt.LineTo(X+17,Y+17);
   Objekt.MoveTo(X+17,Y+5);
   Objekt.LineTo(X+5,Y+17);
   Objekt.Pen.Width:=1;
end;

procedure Button(Objekt: TCanvas; X1,Y1,X2,Y2: integer; Barva: TColor);
begin
   Objekt.Pen.Color:=clBlack;
   Objekt.Brush.color:=Barva+5000;
   Objekt.RoundRect(X1,Y1,X2,Y2,2,2);

   Objekt.Brush.color:=Barva-4000;
   Objekt.Pen.Color:=Barva;
   Objekt.Pen.Width:=2;
   Objekt.Rectangle(X1+2,Y1+10,X2-2,Y2-2);
   Objekt.Pen.Width:=1;
end;

procedure ZaklStrela(Objekt: TCanvas; X,Y: integer);
begin
   with Objekt do
    begin
      Pen.Color:=clBlack;
      Brush.Color:=clBlack;
      Rectangle(X,Y,X+5,Y+2);
      Rectangle(X+2,Y+2,X+12,Y+5);
      Rectangle(X,Y+5,X+5,Y+7);
    end;
end;

procedure VybStrela(Objekt: TCanvas; X,Y: integer);
begin
   with Objekt do
    begin
      Pen.Color:=clBlack;
      Brush.Color:=clBlack;
      Rectangle(X,Y,X+4,Y+2);
      Rectangle(X+2,Y+2,X+12,Y+5);
      Rectangle(X,Y+5,X+4,Y+7);
      Pixels[X+10,Y+1]:=clBlack;
      Pixels[X+10,Y+5]:=clBlack;
      Pixels[X+9,Y+1]:=clBlack;
      Pixels[X+9,Y+5]:=clBlack;
      Pixels[X+8,Y+1]:=clBlack;
      Pixels[X+8,Y+5]:=clBlack;
      Pixels[X+4,Y+1]:=clBlack;
      Pixels[X+4,Y+5]:=clBlack;
    end;
end;

procedure Missile(Objekt: TCanvas; X,Y: integer);
begin
   with Objekt do
    begin
      Pen.Color:=clBlack;
      Brush.Color:=clBlack;
      Rectangle(X,Y,X+3,Y+3);
      Rectangle(X+2,Y+2,X+10,Y+5);
      Rectangle(X,Y+4,X+3,Y+7);
      Pixels[X+3,Y+1]:=clblack;
      Pixels[X+3,Y+5]:=clblack;
      Pixels[X+4,Y+1]:=clblack;
      Pixels[X+4,Y+5]:=clblack;
      Pixels[X-1,Y]:=clblack;
      Pixels[X-1,Y+6]:=clblack;
      Pixels[X+10,Y+3]:=clblack;
    end;
end;

procedure LittleABomb(Objekt: TCanvas; X,Y: integer);
begin
   with Objekt do
    begin
      Pen.Color:=clBlack;
      Brush.Color:=clBlack;
      Rectangle(X,Y+2,X+9,Y+6);
      Pixels[X,Y]:=clBlack;
      Pixels[X,Y+1]:=clBlack;
      Pixels[X+1,Y+1]:=clBlack;
      Pixels[X,Y+6]:=clBlack;
      Pixels[X,Y+7]:=clBlack;
      Pixels[X+1,Y+6]:=clBlack;
      Pixels[X+8,Y]:=clBlack;
      Pixels[X+8,Y+1]:=clBlack;
      Pixels[X+7,Y+1]:=clBlack;
      Pixels[X+8,Y+1]:=clBlack;
      Pixels[X+7,Y+6]:=clBlack;
      Pixels[X+8,Y+6]:=clBlack;
      Pixels[X+8,Y+7]:=clBlack;
      Pen.Color:=clRed;
      Brush.Color:=clRed;
      Chord(X+6,Y,X+14,Y+8,X+10,Y+8,X+10,Y);
    end;
end;

procedure ABomb(Objekt: TCanvas; X,Y: integer);
begin
   with Objekt do
    begin
      Pen.Color:=clBlack;
      Brush.Color:=clBlack;
      Chord(X,Y,X+13,Y+9,X+8,Y,X+8,Y+9);
      Pixels[X,Y]:=clBlack;
      Pixels[X+1,Y+1]:=clBlack;
      Pixels[X,Y+1]:=clBlack;
      Pixels[X,Y+2]:=clBlack;
      Pixels[X-1,Y]:=clBlack;
      Pixels[X-1,Y+1]:=clBlack;
      Pixels[X-1,Y+2]:=clBlack;
      Pixels[X-2,Y]:=clBlack;
      Pixels[X-2,Y+1]:=clBlack;
      Pixels[X,Y+3]:=clBlack;

      Pixels[X-1,Y+4]:=clBlack;
      Pixels[X-2,Y+4]:=clBlack;

      Pixels[X,Y+8]:=clBlack;
      Pixels[X+1,Y+7]:=clBlack;
      Pixels[X,Y+7]:=clBlack;
      Pixels[X,Y+6]:=clBlack;

      Pixels[X-1,Y+8]:=clBlack;
      Pixels[X-1,Y+7]:=clBlack;
      Pixels[X-1,Y+6]:=clBlack;
      Pixels[X-2,Y+8]:=clBlack;
      Pixels[X-2,Y+7]:=clBlack;
      Pixels[X,Y+5]:=clBlack;
      
      Pen.Color:=clRed;
      Brush.Color:=clRed;
      Chord(X,Y,X+13,Y+9,X+9,Y+9,X+9,Y);
    end;
end;

procedure HBomb(Objekt: TCanvas; X,Y: integer);
begin
   with Objekt do
    begin
      Pen.Color:=clBlack;
      Brush.Color:=clBlack;

      MoveTo(X-2,Y+1);
      LineTo(X+6,Y+1);
      MoveTo(X+3,Y+2);
      LineTo(X+9,Y+2);
      MoveTo(X+5,Y+3);
      LineTo(X+11,Y+3);
      Rectangle(X+7,Y+4,X+12,Y+8);
      Rectangle(X+3,Y+5,X+7,Y+7);

      MoveTo(X-2,Y+10);
      LineTo(X+6,Y+10);
      MoveTo(X+3,Y+9);
      LineTo(X+9,Y+9);
      MoveTo(X+5,Y+8);
      LineTo(X+11,Y+8);

      Pen.Color:=clBlue;
      Brush.Color:=clBlue;
      Rectangle(X+12,Y+4,X+14,Y+8);
      MoveTo(X+14,Y+5);
      LineTo(X+14,Y+7);

    end;
end;

procedure BtnZbrane(Objekt: TCanvas; X,Y: integer; left: bool);
begin
   with Objekt do
    begin
      if left then
       begin
         Pen.Color:=clBlack;
         MoveTo(X,Y);
         LineTo(X-8,Y+8);
         LineTo(X,Y+16);
         LineTo(X,Y);
       end else begin
         Pen.Color:=clBlack;
         MoveTo(X,Y);
         LineTo(X+8,Y+8);
         LineTo(X,Y+16);
         LineTo(X,Y);
       end;
    end;
end;

end.
