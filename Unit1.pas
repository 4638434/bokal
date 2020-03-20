unit Unit1;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

const
  NAME_PROG = 'Бокалы';
type
  TForm1 = class(TForm)
    ImgUp: TImage;
    ImgUpRed: TImage;
    ImgDown: TImage;
    imgDownRed: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    sbBok: TScrollBar;
    sbPerev: TScrollBar;
    Edit1: TEdit;
    lblBok: TLabel;
    lblPerev: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    sbtPerev: TSpeedButton;
    sbtNewPlay: TSpeedButton;
    Label1: TLabel;
    lblHod: TLabel;
    sbtHint: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sbBokChange(Sender: TObject);
    procedure sbPerevChange(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure sbtPerevClick(Sender: TObject);
    procedure sbtNewPlayClick(Sender: TObject);
//    procedure SpeedButton1Click(Sender: TObject);
    procedure sbtHintClick(Sender: TObject);
//    procedure ScrollBar1Change(Sender: TObject);
//    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ChangeBok;
    procedure DrawBok;
    procedure NewPlay;
//   procedure Hint2;
    procedure Hint;
  public
    { Public declarations }
  end;

type stBok= (Up, Down, UpRed, DownRed, None);
var
  Form1: TForm1;

  //всего бокалов:
  nBok: integer;
  //переворачиваем за один раз:
  nPerev: integer;
  //массив бокалов:
  masBok: array[1..19] of stBok;
  //ходы:
  Hod: integer=0;

implementation

{$R *.lfm}

//СОЗДАТЬ ФОРМУ
procedure TForm1.FormCreate(Sender: TObject);
begin
  form1.AutoSize:= True;
  NewPlay;
end; //FormCreate

//ПОКАЗАТЬ БОКАЛЫ
procedure TForm1.DrawBok;
var
  i: integer;
  comp: TComponent;
begin
  for i:= 1 to 19 do begin
    comp:= FindComponent('Image'+inttostr(i));
    (comp as Timage).top:= 36;
    case masBok[i] of
      None: (comp as Timage).visible:= False;
      Up: begin
            (comp as Timage).visible:= True;
            (comp as Timage).Picture.Assign(ImgUp.Picture);
          end;
      Down: begin
            (comp as Timage).visible:= True;
            (comp as Timage).Picture.Assign(ImgDown.Picture);
          end;
      UpRed: begin
            (comp as Timage).visible:= True;
            (comp as Timage).Picture.Assign(ImgUpRed.Picture);
          end;
      DownRed: begin
            (comp as Timage).visible:= True;
            (comp as Timage).Picture.Assign(ImgDownRed.Picture);
          end;
    end;
  end;
end; //DrawBok

//ПЕРЕВЕСТИ БОКАЛЫ В ИСХОДНОЕ ПОЛОЖЕНИЕ
procedure TForm1.ChangeBok;
var
  i: integer;
begin
  for i:= 1 to 19 do begin
    if i <= nBok then
      masBok[i]:= Up
    else
      masBok[i]:= None;
  end;
  DrawBok;
end; //ChangeBok

//ИЗМЕНИТЬ ЧИСЛО БОКАЛОВ
procedure TForm1.sbBokChange(Sender: TObject);
begin
  lblBok.Caption:= inttostr(sbBok.Position);
  nBok:= sbBok.Position;
  //скорректировать число переворачиваемых бокалов:
  sbPerevChange(Self);
end; //sbBokChange


//ИЗМЕНИТЬ ЧИСЛО ПЕРЕВОРАЧИВАЕМЫХ БОКАЛОВ
procedure TForm1.sbPerevChange(Sender: TObject);
begin
  lblPerev.Caption:= inttostr(sbPerev.Position);
  nPerev:= sbPerev.Position;
  while nPerev >= nBok do sbPerev.Position:= sbPerev.Position-1;
  NewPlay;
end;  //sbPerevChange

//ВЫДЕЛИТЬ БОКАЛ
procedure TForm1.Image1Click(Sender: TObject);
var i: integer;
begin
  //номер бокала:
  i:= (Sender as TImage).tag;
  case masBok[i] of
    Up: masBok[i] := UpRed;
    Down: masBok[i] := DownRed;
    UpRed: masBok[i] := Up;
    DownRed: masBok[i] := Down
  end;
  DrawBok;
end; //Image1Click

//ПЕРЕВЕРНУТЬ БОКАЛЫ
procedure TForm1.sbtPerevClick(Sender: TObject);
var i, n: integer;
begin
  //проверить ход:
  n:= 0;
  for i:= 1 to 19 do
    if (masBok[i]= UpRed) or (masBok[i]= DownRed)
      then inc(n);
  if n <> nPerev then begin
    application.MessageBox('Столько бокалов вам не перевернуть!',
    NAME_PROG,IDOK);
    exit
  end;
  //выполнить ход:
  for i:= 1 to 19 do
  case masBok[i] of
    UpRed: masBok[i] := Down;
    DownRed: masBok[i] := Up
  end;
  DrawBok;
  inc(Hod);
  lblHod.Caption:= inttostr(Hod);

  //все бокалы перевёрнуты?
  n:= 0;
  for i:= 1 to 19 do
    if masBok[i]= Down
      then inc(n);
  if n = nBok then begin
    application.MessageBox('Отличная работа!',
    NAME_PROG,IDOK);
    NewPlay;
  end;
end; //sbtPerevClick

//НОВАЯ ИГРА
procedure TForm1.NewPlay;
begin
   //число бокалов:
  lblBok.Caption:= inttostr(sbBok.Position);
  nBok:= sbBok.Position;
  ChangeBok;
  //переворачиваем за 1 раз:
  lblPerev.Caption:= inttostr(sbPerev.Position);
  nPerev:= sbPerev.Position;
  //обнулить ходы:
  Hod:= 0;
  lblHod.Caption:= '0';
end; //NewPlay

//НАЧАТЬ НОВУЮ ИГРУ
procedure TForm1.sbtNewPlayClick(Sender: TObject);
begin
  NewPlay;
end; //sbtNewPlayClick

{//РЕШАЕМ ЗАДАЧУ
procedure TForm1.SpeedButton1Click(Sender: TObject);
label
  nextHod, nextPtr, BackHod;
var
  str: array [0..20] of string;
  i, n: integer;
  maxHod: integer;
  //:
  ptr: array[0..20] of integer;
  Hod: integer;
  s, strEnd: string;
begin
    //ограничить глубину поиска:
  maxHod:= 8;
  maxHod:= scrollbar1.Position;
  listbox1.Items.Add(inttostr(maxHod));
//listbox1.Items.Add(inttostr(nPerev));
  //формируем начальную позицию:
  s:= '';
  for i:= 1 to 19 do
    s:= s+ '1';
  for i:= 0 to 20 do
    str[i]:= s;
  //формируем конечную позицию:
  for i:= 1 to nBok do
    s[i]:= '0';
  strEnd:= s;

  Hod:= 0;
  //ptr[0]:= -1;
//сделать следующий ход:
nextHod:
  inc(Hod);
  if hod> maxHod then goto BackHod;
  ptr[hod]:= 0;
  //ptr[hod]:= ptr[hod-1]+1;
//переходим к следующей клетке:
nextPtr:
  inc(ptr[hod]);

  //if ptr[hod] > nBok - nPerev + 1 then goto backhod; //- дальше двигаться нельзя
  if ptr[hod] > nBok then goto backhod;
 }
  {//сделать ход - перевернуть бокалы:
  str[hod]:= str[hod-1];
  for i:= ptr[hod] to ptr[hod] + nPerev - 1 do
    if str[hod-1][i]= '0' then
       str[hod][i]:= '1'
    else
       str[hod][i]:= '0';}

{ //сделать ход - перевернуть бокалы:
  str[hod]:= str[hod-1];
  for i:= ptr[hod] to ptr[hod] + nPerev - 1 do
  begin
    if i> nBok then n:= i- nBok
    else n:= i;
    if str[hod-1][n]= '0' then
       str[hod][n]:= '1'
    else
       str[hod][n]:= '0';
  end;

  s:= 'hod= '+inttostr(hod)+ ' '+ inttostr(ptr[hod])
   + '  позиция: '+ str[hod];
  //showmessage(s);
  //listbox1.Items.Add(s);

  //не решена ли задача?
  if str[hod]= strEnd then //- решена!
  begin
    //записать решение в список:
    listbox1.Items.Add('');
    listbox1.Items.Add('');

    for i:= 1 to hod do begin
      s:= 'hod= '+inttostr(i)+ ' '+ inttostr(ptr[i])
          + '  позиция: '+ str[i];
      listbox1.Items.Add(s);
    end;
    showmessage('Задача решена!');
    //exit;
    //не искать длинных вариантов:
    if hod< maxHod then maxHod:= hod;
    goto backhod;
    
  end;
  //не повторилась ли позиция?
  for i:= 0 to hod-1 do
    if str[hod] = str[i] then //- была
      goto nextptr;

  goto nextHod;
  
//ход назад
BackHod:
  dec(hod);
  if hod<= 0 then begin
    showmessage('Всё!');
    exit
  end;
  goto nextPtr;
end;   }

{procedure TForm1.Hint2;
var
  i, p, n: integer;
  flg: Boolean;
begin
  if odd(nBok) and not odd(nPerev) then
  begin
    showmessage('Задача решений не имеет!');
    exit
  end;

  for i:= 0 to 100 do begin
    if odd(nPerev) then
      if odd(nBok) and not odd(i) then
    else if not odd(nBok) and  odd(i) then continue
  else;

    p:= (2+i)*nPerev - nBok;
    if (p mod 2 = 0) and (p>=0) then begin
      p:= p div 2;
      n:= i+2;
      break;
    end;
  end;
  showmessage('Ходов: '+ inttostr (n)+ #10#13+'p = '+ inttostr (p));
end;}

//ВЫВЕСТИ ПОДСКАЗКУ
procedure TForm1.Hint;
var
  i, n, m: integer;
begin
  //если число бокалов нечётное, а переворачиваем чётное
  //число бокалов, то задача неразрешима:
  if odd(nBok) and not odd(nPerev) then
  begin
    showmessage('Задача решений не имеет!');
    exit
  end;

  m:= nBok;
  n:= nPerev;
  i:= 0;
  while (n*i< m) or ((n*i - m) mod 2 <> 0) do inc (i);
  showmessage('На решение задачи потребуется ходов - '+ inttostr (i)+
              #10#13+
              'Число возвращаемых бокалов = '+ inttostr ((n * i - m) div 2));
end;  //Hint

//ПОДСКАЗКА
procedure TForm1.sbtHintClick(Sender: TObject);
begin
  Hint;
end;

{procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  label2.Caption:= inttostr(ScrollBar1.Position);
end;}

{procedure TForm1.ListBox1Click(Sender: TObject);
begin
 ListBox1.Clear
end;}

end.
       