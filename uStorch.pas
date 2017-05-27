unit uStorch;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, ExtCtrls, StdCtrls, Math, ComCtrls, AppEvnts, Buttons,
     DXClass, DXDraws;

type
  TForm1 = class(TForm)
    DXDraw: TDXDraw;
    DXTimer1: TDXTimer;
    procedure FormCreate(Sender: TObject);
    procedure KresliDelo(tank: byte; prekreslit: bool);
    procedure Odpal;
    procedure VypocetUhelSila(X,Y: integer);
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure KresliZbrane;
    procedure GenerujHru;
    procedure VykresliHru;
    procedure HUD;
    procedure ButonEnd;
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDrawRestoreSurface(Sender: TObject);
  private
    { Private declarations }

    klik, kontrol, explo: bool;
    t: longint; //word
    vx: Single;
    faze: ^byte;
    PocZbrani: longint; //byte
    land: array[0..72] of TPoint;
    MaxExplo, narade, tanku, zbyva, padaku, polomerExp, RExplo, n, hor: longint; //byte
    naZbr, naEnd, obnovovatP, fy, oznac, zmena: bool;
    X1,X2,Xa,Xb: ^longint;  //word

    pom2: record
       X: Single;
       Y: longint; //smallint
    end;

    pom: record
      X: Single;
      Y: longint; //smallint
    end;

  public
    { Public declarations }

  published
    { Published declarations }

  end;

type
   TTank = record
      pos: TPoint;
      barva: TColor;
      health: longint; //smallint
      alfa: longint; //smallint
      delo: array[0..1] of TPoint;
      nazemi, znicen, padal: bool;
      sila: longint; //smallint
      score,zbran,padaku: longint; //shortint
   end;

const
  RDela=5;
  RTanku=8;
  BOblohy=16500000;
  BZeme=clGreen;
  BOblohy2=2147835;
  BZeme2=32768;
  g: single=0.2;

var
  Form1: TForm1;

  tanky: array[1..5] of TTank;

  strela: record
    X: Single;
    Y: longint; //smallint
  end;

implementation

uses kresleni, Procedury;

{$R *.dfm}

//---------------------------------procedury------------------------------------

procedure TForm1.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
   Handled:=false;

   if (Msg.message = WM_MouseWheel) and not (DXTimer1.Enabled) then
    begin
      if kontrol then
       begin
         if Msg.wParam>0 then Tanky[narade].alfa:=Tanky[narade].alfa+1
                         else Tanky[narade].alfa:=Tanky[narade].alfa-1;
         KresliDelo(narade,true);
       end else begin
         if Msg.wParam > 0 then Tanky[narade].sila:=Tanky[narade].sila+1
                           else Tanky[narade].sila:=Tanky[narade].sila-1;
       end;

      HUD;
      DXDraw.Surface.Canvas.Release;
      DXDraw.Flip;
      Handled:=true;
    end;

   if (Msg.message = WM_KEYDOWN) and not (DXTimer1.Enabled) then
    begin
      case Msg.wParam of
        13: begin
              Odpal;
              Handled:=true;
        end;
        17: begin
              Kontrol:=true;
              Handled:=true;
        end;
        37: begin
              Tanky[narade].alfa:=Tanky[narade].alfa-1;
              KresliDelo(narade,true);
              HUD;
              DXDraw.Surface.Canvas.Release;
              DXDraw.Flip;
              Handled:=true;
        end;
        38: begin
              Tanky[narade].sila:=Tanky[narade].sila+1;
              HUD;
              DXDraw.Surface.Canvas.Release;
              DXDraw.Flip;
              Handled:=true;
        end;
        39: begin
              Tanky[narade].alfa:=Tanky[narade].alfa+1;
              KresliDelo(narade,true);
              HUD;
              DXDraw.Surface.Canvas.Release;
              DXDraw.Flip;
              Handled:=true;
        end;
        40: begin
              Tanky[narade].sila:=Tanky[narade].sila-1;
              HUD;
              DXDraw.Surface.Canvas.Release;
              DXDraw.Flip;
              Handled:=true;
        end;
      end;
    end;

   if (Msg.message = WM_KEYUP) and (Msg.wParam = 17) then
    begin
      Kontrol:=false;
      Handled:=true;
    end;
end;

//------------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
var soubor: ^TextFile;
    nastaveni: ^string;
begin
   New(soubor);
   New(nastaveni);

   tanky[1].barva:=clRed;
   tanky[2].barva:=clBlue;
   tanky[3].barva:=100;
   tanky[4].barva:=clYellow-8000;
   tanky[5].barva:=clGray;

   AssignFile(soubor^,'set.dat');
   Reset(soubor^);

    Readln(soubor^,nastaveni^);           //Nastaven� ���ky
    DXDraw.Width:=StrToInt(nastaveni^);
    Form1.Width:=StrToInt(nastaveni^);

    Readln(soubor^,nastaveni^);           //Nastaven� v��ky
    DXDraw.Height:=StrToInt(nastaveni^);
    Form1.Height:=StrToInt(nastaveni^);

    Readln(soubor^,nastaveni^); //T nebo F
    if nastaveni^='T' then
     begin
       Form1.BorderStyle:=bsNone;
       Form1.Width:=Screen.Width;
       Form1.Height:=Screen.Height;
       Form1.FormStyle:=fsStayOnTop;
       DXDraw.Width:=Screen.Width;
       DXDraw.Height:=Screen.Height;
     end;

    Readln(soubor^,nastaveni^);
    tanku:=StrToInt(nastaveni^);  // 2 - 5 tank�

    Readln(soubor^,nastaveni^);
    PocZbrani:=StrToInt(nastaveni^);  // 0 - 5 zbran�

    Readln(soubor^,nastaveni^);         // po�et pad�k�
    padaku:=StrToInt(nastaveni^);
       tanky[1].padaku:=padaku;
       tanky[2].padaku:=padaku;
       tanky[3].padaku:=padaku;
       tanky[4].padaku:=padaku;
       tanky[5].padaku:=padaku;

    Readln(soubor^,nastaveni^);                         //obnovov�n� pad�k� po ka�d� h�e
    if nastaveni^='T' then obnovovatP:=true else obnovovatP:=false;

    Readln(soubor^,nastaveni^);
    if nastaveni^='T' then fy:=true else fy:=false;   //T nebo F pad�n� hl�ny

    Readln(soubor^,nastaveni^);           //Nastaven� velikosti exploze 1 - 3
    polomerExp:=StrToInt(nastaveni^);

   CloseFile(soubor^);

   Dispose(soubor);
   Dispose(nastaveni);

   Randomize;

   land[0].Y:=DXDraw.Height+50;
   land[0].X:=0;
   land[1].X:=0;
   land[72].Y:=DXDraw.Height+50;
   land[72].X:=DXDraw.Width;

   Application.OnMessage:=AppMessage;

   hor:=DXDraw.Height div 4;

   DXDraw.Restore;
end;

//------------------------------------------------------------------------------

procedure TForm1.KresliDelo(tank: byte; prekreslit: bool);
begin
   DXDraw.Surface.Canvas.Pen.Width:=2;

   if prekreslit then
    begin
      DXDraw.Surface.Canvas.Pen.Color:=BOblohy;
      DXDraw.Surface.Canvas.MoveTo(Tanky[Tank].delo[0].X,Tanky[Tank].delo[0].Y);
      DXDraw.Surface.Canvas.LineTo(Tanky[Tank].delo[1].X,Tanky[Tank].delo[1].Y);
    end;

   Tanky[Tank].delo[0].X:=round((RTanku+1)*cos(DegToRad(Tanky[Tank].alfa))+Tanky[Tank].pos.X);
   Tanky[Tank].delo[0].Y:=round((RTanku+1)*sin(DegToRad(Tanky[Tank].alfa))+Tanky[Tank].pos.Y);
   Tanky[Tank].delo[1].X:=round((RTanku+RDela+1)*cos(DegToRad(Tanky[Tank].alfa))+Tanky[Tank].pos.X);
   Tanky[Tank].delo[1].Y:=round((RTanku+RDela+1)*sin(DegToRad(Tanky[Tank].alfa))+Tanky[Tank].pos.Y);

   DXDraw.Surface.Canvas.Pen.Color:=Tanky[Tank].Barva;
   DXDraw.Surface.Canvas.MoveTo(Tanky[Tank].delo[0].X,Tanky[Tank].delo[0].Y);
   DXDraw.Surface.Canvas.LineTo(Tanky[Tank].delo[1].X,Tanky[Tank].delo[1].Y);

   DXDraw.Surface.Canvas.Pen.Width:=1;

end;

//------------------------------------------------------------------------------

procedure TForm1.GenerujHru;
var I,J: longint; //byte
    UmisteniT: ^bool;
    good, all, a, b: ^longint; //byte
    maxvyska: ^longint; //smallint

begin
   New(maxvyska);
   New(a);
   New(b);
   New(UmisteniT);
   New(good);
   New(all);

   maxvyska^:=Random(Form1.DXDraw.Height div 3);  //maxim�ln� v��ka kopc�
   a^:=0;
   b^:=Random(2);

   zbyva:=tanku;
   narade:=1;

   land[1].Y:=Form1.DXDraw.Height div 2+Random(maxvyska^);

   for I := 2 to 71 do
    begin
      land[I].Y:=Form1.DXDraw.Height div 2+Random(maxvyska^) + b^*I;
      land[I].X:=land[I-1].X + Form1.DXDraw.Width div (5*tanku) - Random(Form1.DXDraw.Width div (5*tanku) - 2*RTanku);
      if land[I].X<Form1.DXDraw.Width then inc(a^);  // po�et viditeln�ch zlom� ter�nu
    end;

   UmisteniT^:=false;

   while not UmisteniT^ do
    begin
      for I := 1 to Tanku do
       begin
         Tanky[I].pos.X:=Random(a^-6)+3;
       end;

      good^:=0;
      all^:=0;

      for I := 1 to Tanku-1 do
       begin
         for J := I + 1 to Tanku do
          begin
            inc(all^);
            if abs(Tanky[I].pos.X-Tanky[J].pos.X)>3 then inc(good^);
          end;
       end;

      if good^=all^ then UmisteniT^:=True;
    end;

   for I := 1 to Tanku do
    begin
      if obnovovatP then tanky[I].padaku:=padaku;
      Tanky[I].znicen:=false;
      Tanky[I].health:=100;
      Tanky[I].alfa:=-Random(150)-15;
      Tanky[I].sila:=20;
      Tanky[I].zbran:=0;

      Tanky[I].pos.Y:=land[Tanky[I].pos.X].Y;
      land[Tanky[I].pos.X+1].Y:=land[Tanky[I].pos.X].Y;
      land[Tanky[I].pos.X+1].X:=land[Tanky[I].pos.X].X+2*RTanku;
      Tanky[I].pos.X:=land[Tanky[I].pos.X].X+RTanku;
    end;

   Dispose(maxvyska);
   Dispose(a);
   Dispose(b);
   Dispose(UmisteniT);
   Dispose(good);
   Dispose(all);
end;

//------------------------------------------------------------------------------

procedure TForm1.VykresliHru;
var
  I: longint; //byte
begin
   with Form1.DXDraw.Surface.Canvas do
    begin
      Brush.Color:=BOblohy;
      Rectangle(-1,-1,Form1.DXDraw.Width+1,Form1.DXDraw.Height+1);
      Pen.Color:=BZeme;
      Brush.Color:=BZeme;
      Polygon(land);

      for I := 1 to Tanku do
       begin
         KresliTank(I);
         Form1.KresliDelo(I,false);
       end;

      oznac:=true; //-----------

      HUD;

      DXDraw.Surface.Canvas.Release;
      DXDraw.Flip;
    end;
end;

//------------------------------------------------------------------------------

procedure TForm1.HUD;
begin
   if Tanky[narade].sila>Tanky[narade].health then Tanky[narade].sila:=Tanky[narade].health else if Tanky[narade].sila<0 then Tanky[narade].sila:=0;
   if Tanky[narade].alfa<-180 then Tanky[narade].alfa:=-180 else if Tanky[narade].alfa>0 then Tanky[narade].alfa:=0;

   Ukazatele(Form1.DXDraw.Surface.Canvas,10,10,Tanky[narade].sila,Tanky[narade].health,-Tanky[narade].alfa, Tanky[narade].Barva, BOblohy);
   Info(Form1.DXDraw.Surface.Canvas,120,13,IntToStr(Tanky[narade].sila)+'    ',BOblohy);
   Info(Form1.DXDraw.Surface.Canvas,120,38,IntToStr(90-abs(Tanky[narade].alfa+90))+'�  ',BOblohy);
   Info(Form1.DXDraw.Surface.Canvas,170,13,'  Score: '+IntToStr(Tanky[narade].score)+'  ',BOblohy);
   Info(Form1.DXDraw.Surface.Canvas,170,38,'  Pad�k�: '+IntToStr(Tanky[narade].padaku)+'  ',BOblohy);
   ButonEnd;
   Form1.KresliZbrane;

   if oznac then DXDraw.Surface.Canvas.Pen.Color:=5000 else DXDraw.Surface.Canvas.Pen.Color:=BOblohy;

   DXDraw.Surface.Canvas.MoveTo(Tanky[narade].pos.X,Tanky[narade].pos.Y-2*RTanku-RDela);
   DXDraw.Surface.Canvas.LineTo(Tanky[narade].pos.X+RTanku-3,Tanky[narade].pos.Y-4*RTanku-RDela);
   DXDraw.Surface.Canvas.LineTo(Tanky[narade].pos.X-RTanku+3,Tanky[narade].pos.Y-4*RTanku-RDela);
   DXDraw.Surface.Canvas.LineTo(Tanky[narade].pos.X,Tanky[narade].pos.Y-2*RTanku-RDela);
end;

//------------------------------------------------------------------------------

procedure TForm1.ButonEnd;
begin
   if naEnd then Tlacitko(Form1.DXDraw.Surface.Canvas,Form1.DXDraw.Width-43,21,BOblohy,clBlack) else Tlacitko(Form1.DXDraw.Surface.Canvas,Form1.DXDraw.Width-43,21,BOblohy,clGray+5000);
end;

//------------------------------------------------------------------------------

procedure TForm1.Odpal;
begin
    vx:=cos(DegToRad(Tanky[narade].alfa))*Tanky[narade].sila/6;
    t:=round(sin(DegToRad(Tanky[narade].alfa))*Tanky[narade].sila);

    strela.X:=Tanky[narade].delo[1].X;
    strela.Y:=Tanky[narade].delo[1].Y;
    pom.X:=Tanky[narade].pos.X;
    pom.Y:=Tanky[narade].pos.Y;

    pom2.X:=strela.X;
    pom2.Y:=strela.Y;
    pom.X:=strela.X;
    pom.Y:=strela.Y;

    New(faze);

    if fy then
     begin
       New(X1);
       New(X2);
       New(Xa);
       New(Xb);
     end;

    faze^:=0;

    naZbr:=false;
    DXTimer1.Enabled:=true;
end;

//------------------------------------------------------------------------------

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var J,I: longint; //word
    good: longint; //byte
    bodkolize: TPoint;

begin
   case faze^ of
    0: begin
      faze^:=1;
      n:=1;
    end;

    1: begin
      pom2.X:=pom.X;
      pom2.Y:=pom.Y;
      pom.X:=strela.X;
      pom.Y:=strela.Y;

      strela.X:=strela.X+vx;
      strela.Y:=round(strela.Y+g*t);

      if (strela.X<=0) or (strela.X>=DXDraw.Width) then vx:=-vx;

      Inc(t);

      Kriz(DXDraw.Surface.Canvas,round(pom.X),pom.Y,BOblohy);

      if strela.Y > hor then
       begin

         if strela.Y>=DXDraw.Height then   //odraz od zem�
          begin
            strela.Y:=DXDraw.Height;
            t:=t div 3-t;
            inc(n);
            if n > 5 then explo:=true;
          end;

         if abs(strela.y-pom.y)>abs(strela.x-pom.X) then     // kolize se zem� a tanky
          begin
            for I := 1 to abs(strela.y-pom.y) do
             begin
               if not explo then
                begin
                  bodkolize.X:=round(pom.x+I*(strela.X-pom.x)/abs(strela.Y-pom.y));
                  bodkolize.Y:=round(pom.y+I*(strela.y-pom.y)/abs(strela.y-pom.y));

                  if DXDraw.Surface.Canvas.Pixels[bodkolize.X,bodkolize.Y]=BZeme then
                   begin
                     explo:=true;
                     strela.X:=bodkolize.X;
                     strela.Y:=bodkolize.Y;
                   end else begin
                     for J := 1 to Tanku do
                      begin
                        if DXDraw.Surface.Canvas.Pixels[bodkolize.X,bodkolize.Y]=Tanky[J].barva then
                         begin
                           Tanky[J].health:=0;
                           explo:=true;
                           strela.X:=bodkolize.X;
                           strela.Y:=bodkolize.Y;
                         end;
                      end;
                   end;
                end;
             end;
          end else begin
            for I := 1 to abs(Round(strela.x-pom.x)) do
             begin
               if not explo then
                begin
                  bodkolize.X:=round(pom.x+I*(strela.x-pom.x)/abs(strela.x-pom.x));
                  bodkolize.Y:=round(pom.y+I*(strela.Y-pom.Y)/abs(strela.X-pom.X));

                  if DXDraw.Surface.Canvas.Pixels[bodkolize.X,bodkolize.Y]=BZeme then
                   begin
                     explo:=true;
                     strela.X:=bodkolize.X;
                     strela.Y:=bodkolize.Y;
                   end else begin
                     for J := 1 to tanku do
                      begin
                        if DXDraw.Surface.Canvas.Pixels[bodkolize.X,bodkolize.Y]=Tanky[J].barva then
                         begin
                           Tanky[J].health:=0;
                           explo:=true;
                           strela.X:=bodkolize.X;
                           strela.Y:=bodkolize.Y;
                         end;
                      end;
                   end;
                end;
             end;
          end;      // konec kolize se zem� a tanky

       end else begin                                   // pr�let oblohou + �ipka
         Sipka(DXDraw.Surface.Canvas,round(pom.X),2,BOblohy);
         if strela.Y<0 then Sipka(DXDraw.Surface.Canvas,round(strela.X),2,clGray);
       end;

      if explo then
       begin
         DXDraw.Surface.Canvas.MoveTo(round(pom2.X),pom2.Y);
         DXDraw.Surface.Canvas.Pen.Color:=BOblohy;
         DXDraw.Surface.Canvas.LineTo(round(pom.X),pom.Y);
         RExplo:=0;
         t:=0;
         explo:=false;
         faze^:=2;

       end else begin
         DXDraw.Surface.Canvas.MoveTo(round(pom2.X),pom2.Y);
         DXDraw.Surface.Canvas.Pen.Color:=BOblohy;
         DXDraw.Surface.Canvas.LineTo(round(pom.X),pom.Y);

         DXDraw.Surface.Canvas.Pen.Color:=clBlack;
         DXDraw.Surface.Canvas.MoveTo(round(pom.X),pom.Y);
         DXDraw.Surface.Canvas.LineTo(round(strela.X),strela.Y);
         Kriz(DXDraw.Surface.Canvas,round(strela.X),strela.Y,clBlack);
       end;

      HUD;
    end;

    2: begin
       if RExplo>MaxExplo then
        begin
          Vybuch(DXDraw.Surface.Canvas, round(strela.X), strela.Y, RExplo, BOblohy);
          explo:=false;
          for I := 1 to Tanku do
           begin
             Tanky[I].padal:=false;
             if not Tanky[I].znicen then
              begin
                KresliTank(I);
                KresliDelo(I,true);
                Tanky[I].nazemi:=false;
              end;
           end;

          faze^:=3;

          zmena:=true;
          t:=0;

          X1^:=0;
          X2^:=DXDraw.Width;
          Xa^:=DXDraw.Width;
          Xb^:=0;

        end else begin

          Vybuch(DXDraw.Surface.Canvas, round(strela.X), strela.Y, RExplo, clRed);
          RExplo:=RExplo+3;

          for I := 1 to tanku do
           begin
             if (sqrt(sqr(Tanky[I].pos.X-strela.X)+sqr(Tanky[I].pos.Y-strela.Y))-RTanku<RExplo) and not (Tanky[I].znicen) then
                Tanky[I].health:=Tanky[I].health-10;
           end;
        end;
    end;

    3: begin

       //----------- pad�n� hl�ny -------------

       if zmena and fy then
        begin
          zmena:=false;

          DXDraw.Surface.Lock;

          for J:=X1^ to X2^ do
           begin
             for I:=DXDraw.Height downto hor do
              begin
                if (DXdraw.Surface.Pixel[J,I]=BZeme2) and (DXdraw.Surface.Pixel[J,I+1]=BOblohy2) then
                 begin
                   if Xa^>J then Xa^:=J else if Xb^<J then Xb^:=J;

                   zmena:=true;
                   DXdraw.Surface.Pixel[J,I]:=BOblohy2;
                   DXdraw.Surface.Pixel[J,I+round(g*t)+1]:=BZeme2;
                 end;
              end;
           end;

          DXDraw.Surface.UnLock;

          X1^:=Xa^-2;
          X2^:=Xb^+2;

          Xb^:=X1^;
          Xa^:=X2^;
        end else zmena:=false;

       //-----------------------------------------


       for I := 1 to Tanku do
        begin
         for J := Tanky[I].pos.X-RTanku+1 to Tanky[I].pos.X+RTanku-1 do
           begin
             if not (tanky[I].znicen) and not (tanky[I].nazemi) and (DXDraw.Surface.Canvas.Pixels[J,Tanky[I].pos.Y]<>BOblohy) then
              begin
                Tanky[I].nazemi:=true;
                if tanky[I].padaku=0 then
                 begin
                   tanky[I].health:=tanky[I].health-t; //�bytek zdrav� po p�du bez pad�ku
                 end;
              end;
           end;

          if not Tanky[I].nazemi then
           begin
             VymazTank(I);

             if (Tanky[I].padaku>0) and (tanky[I].health>0) then
              begin
                VymazPadak(I);
                if Tanky[I].pos.Y>DXDraw.Height then
                 begin
                   Tanky[I].pos.Y:=DXDraw.Height;
                   Tanky[I].nazemi:=true;
                 end else begin
                   Tanky[I].pos.Y:=Tanky[I].pos.Y+1;
                   Tanky[I].padal:=true;
                 end;
                KresliPadak(I);
              end else begin
                if Tanky[I].pos.Y>DXDraw.Height then
                 begin
                   Tanky[I].pos.Y:=DXDraw.Height;
                   Tanky[I].nazemi:=true;
                 end else
                   Tanky[I].pos.Y:=Tanky[I].pos.Y+round(g*t);
              end;

             KresliTank(I);
             KresliDelo(I,false);
           end;
        end;

       good:=0;

       for I:=1 to Tanku do
        begin
          if Tanky[I].nazemi and not Tanky[I].znicen then
           begin
             Inc(good);
             if Tanky[I].padaku>0 then
              begin
                VymazPadak(I);
                if Tanky[I].padal then dec(Tanky[I].padaku);

                KresliTank(I);
                KresliDelo(I,false);
              end;
           end;
        end;

       inc(t);

       if (good=zbyva) and (not zmena) then faze^:=4;
    end;

    4: begin
       for I := 1 to Tanku do
        begin
          if (Tanky[I].health<=0) and not (Tanky[I].znicen) then
           begin
             if I=narade then Tanky[narade].score:=Tanky[narade].score-1 else Tanky[narade].score:=Tanky[narade].score+1;

             Tanky[I].znicen:=true;
             dec(zbyva);
             strela.X:=Tanky[I].pos.X;
             strela.Y:=Tanky[I].pos.Y;
             faze^:=2;
             RExplo:=0;
             MaxExplo:=25;
             explo:=true;
             exit;
           end;
        end;

       if faze^=4 then
        begin
          if zbyva>1 then
           begin
             repeat
              begin
                inc(narade);
                if narade>tanku then narade:=1;
              end until not Tanky[narade].znicen;

             oznac:=true;

             HUD;

           end else begin
             GenerujHru;
             VykresliHru;
           end;

          Dispose(faze);

          if fy then
           begin
             Dispose(X1);
             Dispose(X2);
             Dispose(Xa);
             Dispose(Xb);
           end;

          DXTimer1.Enabled:=false;
        end;
    end;
   end;

   DXDraw.Surface.Canvas.Release;
   DXDraw.Flip;
end;

//------------------------------------------------------------------------------

procedure TForm1.DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if not (DXTimer1.enabled) then
    begin
      if button=mbLeft then
       begin
         if naZbr then
          begin
            Tanky[narade].zbran:=Tanky[narade].zbran+1;
            if Tanky[narade].zbran>PocZbrani then Tanky[narade].zbran:=0;
            KresliZbrane;
          end else begin
            klik:=true;
            VypocetUhelSila(X,Y);
          end;
       end else begin
         if button=mbRight then
          begin
            if naZbr then
             begin
               Tanky[narade].zbran:=Tanky[narade].zbran-1;
               if Tanky[narade].zbran<0 then Tanky[narade].zbran:=PocZbrani;
               KresliZbrane;
             end else begin oznac:=false; Odpal; end;
          end;
       end;
    end;

   if naEnd then Application.Terminate;

   DXDraw.Surface.Canvas.Release;
   DXDraw.Flip;
end;

//------------------------------------------------------------------------------

procedure TForm1.DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   klik:=false;
end;

//------------------------------------------------------------------------------

procedure TForm1.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   if not DXtimer1.enabled then
    begin
      if klik then
         VypocetUhelSila(X,Y)
       else
         if (X > 265) and (X < 434) and (Y > 20) and (Y < 44) then begin naZbr:=true; end else begin naZbr:=false; end;
         KresliZbrane;
    end;
   if (X>DXDraw.Width-43) and (X<DXDraw.Width-21) and (Y>21) and (Y<43) then begin naEnd:=true; end else begin naEnd:=false; end;
   ButonEnd;

   DXDraw.Surface.Canvas.Release;
   DXDraw.Flip;
end;

//------------------------------------------------------------------------------

procedure TForm1.VypocetUhelSila(X,Y: integer);
begin
   if Tanky[narade].pos.X-X=0 then
     Tanky[narade].alfa:=-90
      else begin
        if Tanky[narade].pos.X-X<0 then
         begin
           Tanky[narade].alfa:=Round(RadToDeg(arcTan((Tanky[narade].pos.Y-Y)/(Tanky[narade].pos.X-X))));
           if Tanky[narade].alfa>0 then Tanky[narade].alfa:=0
         end else begin
           Tanky[narade].alfa:=-Round(RadToDeg(arcCoT((Tanky[narade].pos.Y-Y)/(Tanky[narade].pos.X-X))))-90;
           if Tanky[narade].alfa>-90 then Tanky[narade].alfa:=-180
         end;
      end;

   KresliDelo(narade,true);
   Tanky[narade].sila:=Round(sqrt(sqr(Tanky[narade].Delo[1].X-X)+sqr(Tanky[narade].Delo[1].Y-Y)));

   HUD;
end;

//------------------------------------------------------------------------------

procedure TForm1.KresliZbrane;
begin
   if naZbr then DXDraw.Surface.Canvas.Pen.Color:=clblack else DXDraw.Surface.Canvas.Pen.Color:=clGray+5000;
   DXDraw.Surface.Canvas.RoundRect(265,20,435,45,2,2);

   case Tanky[narade].zbran of
      0: begin
         Info(DXDraw.Surface.Canvas,320,25,' St�ela ',BOblohy);
         ZaklStrela(DXDraw.Surface.Canvas,285,29);
         MaxExplo:=0;
      end;
      1: begin
         Info(DXDraw.Surface.Canvas,320,25,' V�bu�n� st�ela ',BOblohy);
         VybStrela(DXDraw.Surface.Canvas,285,29);

         MaxExplo:=polomerExp*3;
      end;
      2: begin
         Info(DXDraw.Surface.Canvas,320,25,' Raketa ',BOblohy);
         Missile(DXDraw.Surface.Canvas,286,29);
         MaxExplo:=polomerExp*8;
      end;
      3: begin
         Info(DXDraw.Surface.Canvas,320,25,' Mal� A-bomba ',BOblohy);
         LittleABomb(DXDraw.Surface.Canvas,286,28);
         MaxExplo:=polomerExp*26;
      end;
      4: begin
         Info(DXDraw.Surface.Canvas,320,25,' A-bomba ',BOblohy);
         ABomb(DXDraw.Surface.Canvas,286,28);
         MaxExplo:=polomerExp*50;
      end;
      5: begin
         Info(DXDraw.Surface.Canvas,320,25,' H-bomba ',BOblohy);
         HBomb(DXDraw.Surface.Canvas,286,27);
         MaxExplo:=polomerExp*75;
      end;
   end;

   DXDraw.Surface.Canvas.Brush.Color:=BOblohy;
end;

//------------------------------------------------------------------------------

procedure TForm1.DXDrawRestoreSurface(Sender: TObject);
begin
   DXTimer1.Enabled:=false;
   GenerujHru;
   VykresliHru;
end;

end.


