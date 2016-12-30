unit Unit_QuickSort_Compare;

{$C+} // Assertions enabled

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TQuickSortCompare = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    ECount: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QuickSortCompare: TQuickSortCompare;

implementation

{$R *.dfm}

uses
  System.Diagnostics;

type
  TInteger=NativeInt;
  TCompareProc=reference to function(const A,B:Integer):Integer;

  TIntegerArray=Array of Integer;

  TSortMethod=procedure(const AItems:TIntegerArray);

const
  SortThreshold=16;

var
  TotalCompare,
  TotalExchange : Integer;

// Returns -1, 0, +1
function CompareIntegers(const A,B:Integer):Integer;
begin
  if A<B then
     result:=-1
  else
  if A>B then
     result:=1
  else
     result:=0;

  Inc(TotalCompare);
end;

procedure Method2(const AItems:TIntegerArray);

  procedure Exchange(const A,B:Integer);
  var tmp : Integer;
  begin
    tmp:=AItems[A];
    AItems[A]:=AItems[B];
    AItems[B]:=tmp;

    Inc(TotalExchange);
  end;

  procedure PrivateSort(l,r:TInteger);
  var I, J: TInteger;
      P  : Integer;
  begin
    if r < 0 then
       Exit;

    if r-l<=SortThreshold then
    begin
      // Insertion Sort

      for i:=L+1 to R do
      begin
        P:=AItems[i];
        j:=Pred(i);

        while (j>=L) and (CompareIntegers(AItems[j],P)>0) do
        begin
          AItems[j+1]:=AItems[j];
          Dec(j);
        end;

        AItems[j+1]:=P;
      end;

      Exit;
    end;

    repeat
      I := L;
      J := R;
      P := AItems[(L + R) shr 1];

      repeat
        while CompareIntegers(AItems[I], P) < 0 do Inc(I);
        while CompareIntegers(AItems[J], P) > 0 do Dec(J);

        if I <= J then
        begin
          if I <> J then
             Exchange(I,J);

          Inc(I);
          Dec(J);
        end;
      until I > J;

      if L < J then
         PrivateSort(L,J);

      L := I;
    until I >= R;
  end;

begin
  PrivateSort(0,High(AItems));
end;

procedure Method1(const AItems:TIntegerArray);

  procedure Exchange(const A,B:Integer);
  var tmp : Integer;
  begin
    tmp:=AItems[A];
    AItems[A]:=AItems[B];
    AItems[B]:=tmp;

    Inc(TotalExchange);
  end;

  procedure PrivateSort(const l,r:TInteger);
  var i : TInteger;
      j : TInteger;
      x : TInteger;
      P : Integer;
  begin
    if r-l<=SortThreshold then
    begin
      // Insertion Sort

      for i:=L+1 to R do
      begin
        P:=AItems[i];
        j:=Pred(i);

        while (j>=L) and  (CompareIntegers(AItems[j],P)>0) do
        begin
          AItems[j+1]:=AItems[j];
          Dec(j);
        end;

        AItems[j+1]:=P;
      end;

      Exit;
    end;

    i:=l;
    j:=r;
    x:=(i+j) shr 1;

    while i<j do
    begin
      P:=AItems[x];

      while CompareIntegers(P,AItems[i])>0 do inc(i);
      while CompareIntegers(P,AItems[j])<0 do dec(j);

      if i<j then
      begin
        Exchange(i,j);

        if i=x then
           x:=j
        else
        if j=x then
           x:=i;
      end;

      if i<=j then
      begin
        inc(i);
        dec(j)
      end;
    end;

    if l<j then
       PrivateSort(l,j);

    if i<r then
       PrivateSort(i,r);
  end;

begin
  PrivateSort(0,High(AItems));
end;

procedure TQuickSortCompare.Button1Click(Sender: TObject);

  procedure VerifySort(const AItems:TIntegerArray);
  var t, tmp : Integer;
  begin
    if Length(AItems)>0 then
    begin
      tmp:=AItems[0];

      for t:=1 to High(AItems) do
      begin
        Assert(AItems[t]>=tmp,'Wrong order at position: '+IntToStr(t));
        tmp:=AItems[t];
      end;
    end;
  end;

  procedure TestSort(const AMethod:TSortMethod; const AName:String);
  var Items : TIntegerArray;
      t1 : TStopwatch;
      t,
      Count : Integer;
  begin
    Count:=StrToInt(ECount.Text);

    RandSeed:=12345678;

    SetLength(Items,Count);
    for t:=0 to Count-1 do
        Items[t]:=Random(100000);

    TotalCompare:=0;
    TotalExchange:=0;

    t1:=TStopwatch.StartNew;
    AMethod(Items);

    Memo1.Lines.Add(AName+' '+t1.ElapsedMilliseconds.ToString+' msec');

    Memo1.Lines.Add('Compares:' +TotalCompare.ToString);
    Memo1.Lines.Add('Exchanges:' +TotalExchange.ToString);
    Memo1.Lines.Add('');

    VerifySort(Items);
  end;

begin
  Memo1.Clear;

  TestSort(Method1,'Method 1:');
  TestSort(Method2,'Method 2:');
end;

end.
