Program blablabla; //Проверено на 18 и 26(пример), 18 и -26, 18 и 18. 
var
  n:boolean;
  A,B,k,i,ShiftCount:integer;
  c:boolean;
  mokA,
  mokB,
  mdkA,
  mdkB,
  pkA,
  pkB,
  operand, //в ней мы всё считаем и сравниваем
  res:array of integer; //в ней мы складываем нули и единицы для конечного ответа
  
{
функция переводит число в двоичный код + знаки переполнения
Возвращает МАССИВ ПК, с которым потом удобно работать.
}
function pk(x:integer):array of integer; 
var 
  code: string;
  mas: array of integer;
  negf: boolean;
  i: integer;
begin
  negf:=(x < 0)? true : false;
  repeat  
    insert(abs(x mod 2).ToString,code,1); 
    x:= x div 2;
  until abs(x) <2 ; //вставляем в 1 элемент строки разряды
  
  if not(negf) then
    insert('00'+ abs(x mod 2).toString ,code,1) //добавляем 00(знаки переполнения) и 1 - самый левый разряд двоичного числа
  else
    insert('11'+ abs(x mod 2).toString ,code,1); //добавляем 11(знаки переполнения) и 1 - самый левый разряд двоичного числа
  
  setLength(mas,code.Length); //исходя из размера ПК, мы задаём размер массиву
  for i:=0 to code.Length-1 do //заполняем массив
  begin
    mas[i]:= code[i+1].ToString.ToInteger; 
  end;
  
  pk:= mas; //выводим массив с разрядами ПК в виде [00|00000]
end;

{
Делает равным число разрядов у делимого и делителя
}
procedure equal();
var
  i,n:integer;
begin
  n:= abs(pkA.length - pkB.length);
  if(pkA.length > pkB.length) then 
  begin
    setlength(pkB,pkA.length);
    for i:=pkB.length-1 downto 2+n do
    begin
      pkB[i]:=pkB[i-n];
      pkB[i-n]:=0;
    end;
  end;
  if(pkA.length < pkB.length) then
  begin
    setlength(pkA,pkB.length);
    for i:=pkA.length-1 downto 2+n do
    begin
      pkA[i]:=pkA[i-n];
      pkA[i-n]:=0;
    end;
      
  end;
end;


{
функция переводит ПК в МОК - всё просто
}
function mok(pk:array of integer):array of integer;
var
  i: integer;
  pkx: array of integer;
begin
  pkx:= pk.Slice(0,1); //Клонируем массив чтобы не сломать входящий аргумент
  for i:=0 to pkx.Length-1 do
    pkx[i]:=(pkx[i]=1)? 0 : 1;
  mok:= pkx;
end;

{
функция переводит МОК в МДK - прибавляет единицу.
}
function mdk(mok:array of integer):array of integer; 
var 
  i: integer;
  mokx: array of integer;
begin
  mokx:= mok.Slice(0,1); //Клонируем массив чтобы не сломать входящий аргумент
  mokx[mokx.length-1]:= mokx[mokx.length-1] + 1;
  for i:= mokx.Length-1 downto 1 do
  begin
    mokx[i-1]:=(mokx[i]=2)? mokx[i-1] + 1 : mokx[i-1];
    mokx[i]:=(mokx[i]=2)? 0 : mokx[i];
  end;
  mdk:= mokx;
end;

{
Функция складывает столбиком массивы взависимости от ситуации.
}
procedure sum(operand1,operand2:array of integer);
var i:integer;
begin
  for i:= operand1.length-1 downto 0 do 
  begin
    operand1[i]:= operand1[i] + operand2[i]; //складываем
  end;
  
  for i:= operand1.length-1 downto 1 do 
  begin
    if(operand1[i] >= 2) then 
    begin
      operand1[i-1]:= operand1[i-1] + 1;
      operand1[i]:=operand1[i]-2;
    end;
    
    if(operand1[0] >= 2) then
      operand1[0]:=0;
  end;
end;

{
Функция сдвига.
}
procedure shift(operand1:array of integer);
var i:integer;
begin
  operand1[0]:=operand[1];
  for i:= 0 to operand1.Length-2 do 
  begin
    operand1[i]:= operand1[i+1]; //cдвигаем
  end;
  operand1[operand1.Length-1]:=0;
end;

begin
  write('Введите делимое: ');
  readln(A);
  write('Введите делитель: ');
  readln(B);
  n:=false; //знак операции
  n:=((A<0) or (B<0))? true : false;
  n:=((B<0) and (A<0))? false: n; 
  pkA:= pk(abs(A));
  pkB:= pk(abs(B));
  equal();
  mokA:= mok(pkA);
  mokB:= mok(pkB);
  mdkA:= mdk(mokA);
  mdkB:= mdk(mokB);
  writeln('ПК А =', pkA);
  writeln('ПК B =', pkB);
//  writeln('МОК А =', mokA);
  writeln('МОК B =', mokB);
//  writeln('МДК А =', mdkA);
  writeln('МДК B =', mdkB);

// пока не будет обнаружено переполнение
operand:= pkA.slice(0,1);
sum(operand,mdkB);
k:=1;
while k<=pkA.length do 
  begin  
      setLength(res,k);
      
      if(operand[0] = 0) then
      begin
        res[k-1]:=1;
        shift(operand);
        ShiftCount:=ShiftCount+1;
//        if ((operand[0] = 1)and(operand[1] = 0)) or 
//        ((operand[0] = 0)and(operand[1] = 1)) then
//        begin
//          sum(operand,mdkB);
//          break;
//        end;
        sum(operand,mdkB);
      end
      else
      begin
        res[k-1]:=0;
        shift(operand);
        ShiftCount:=ShiftCount+1;
        sum(operand,pkB);
      end;
      k:=k+1;
  end;
  
  //всё что ниже - округляет последнее доп значение
  res[res.length-1]:=(operand[0] = 0)? 1 : 0;
  
  write((n=true)?'-':' ');
  
  writeln('Ответ:');
  for i:=0 to res.Length-2 do
  begin
    write(((res.length - i)=ShiftCount)? res[i].ToString+',' : res[i].ToString)
  end;
  write('|',res[res.Length-1]);

  read(A);
end.

//"Деление без восстановления остатка со сдвигом остатка". Алгоритм: 
//1. ввод чисел в 10 системе счисления
//2. перевод их в 2 СС
//3. сложение первого числа(делимого) в 2 СС с делителем в МДК
//4. если полученное значение <0, то
//  - в ответ пишем 0
//  - сдвигаем ответ на 1 позицию влево и на освободившееся место вписываем 0
//  - складываем сдвинутый ответ и ПК
//6. если полученное значение >0, то
//  - в ответ пишем 1
//  - сдвигаем ответ на 1 позицию влево и на освободившееся место вписываем 0
//  - складываем сдвинутый ответ и ДК
//И это в цикл (кол-во знаков после запятой делимого и делителя (должно быть одинаковое) +1 для округления)
//В итоге должен получиться .exe с таким меню и стилем работы
//
//Знак результата - это положительное (знаковый разряд 00. ) плюс отрицательное (зн. разр. 11. ), к примеру, дают знак "-", т.е. 11.
//ВАЖНО - ПК - просто число в двоичном коде со знаковыми разрядами (всегда 00 по умолчанию)
//МОК - инвертированный код (0 заменяется на 1, 1 на 0)
//МДК - МОК + 1