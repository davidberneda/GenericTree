program TeeGenericTree_Tests;

{$APPTYPE CONSOLE}

{$R *.res}

(*
  Basic tests for TeeGenericTree
*)

uses
  System.SysUtils, System.DateUtils,

  TeeGenericTree;

procedure BasicCreate;
var Root : TNode<String>;
begin
  Root := TNode<String>.Create;
  try
    Root.Add('Hello').Add('World !');

    Assert(Root.Count=1,'Wrong Count');
    Assert(Root[0].Data='Hello','Wrong Data');
    Assert(Root[0].Count=1,'Wrong Count');
    Assert(Root[0][0].Data='World !','Wrong Data');
  finally
    Root.Free;
  end;
end;

procedure CustomType;
type
   TFloatTree = TNode<Single>;
var
  Tree1 : TFloatTree;
begin
  Tree1:=TFloatTree.Create;
  try
    Assert(Tree1.ClassType=TFloatTree,'Wrong ClassType');
    Assert(Tree1.ClassName='TNode<System.Single>','Wrong ClassName');
  finally
    Tree1.Free;
  end;
end;

procedure AddNode;
var Root,
    Node : TNode<String>;
begin
  Root:=TNode<String>.Create;
  try
    Node := Root.Add('abc');

    Assert(Node<>nil,'Node is nil');
    Assert(Root.Count=1,'Wrong Root Count');
    Assert(Node.Data='abc','Wrong Node Data');
  finally
    Root.Free;
  end;
end;

procedure CustomData;
var Root,
    Node : TNode<TDateTime>;
    tmp,
    When : TDateTime;
begin
  Root:=TNode<TDateTime>.Create;
  try
    tmp:=Now;

    Node := Root.Add(tmp);
    When := Node.Data;
    Node.Data := Tomorrow;

    Assert(When=tmp,'Wrong Node Data');
    Assert(Node.Data=Tomorrow,'Wrong Node Data');
  finally
    Root.Free;
  end;
end;

procedure Count;
type
  TMyRecord=record
  end;

var t : Integer;
    Node : TNode<TMyRecord>;

    Record1,
    Record2,
    Record3 : TMyRecord;
begin
  Node:=TNode<TMyRecord>.Create;
  try
    Node.Add(Record1);
    Node.Add(Record2);
    Node.Add(Record3);

    t:=Node.Count;

    Assert(t=3,'Wrong Count');
  finally
    Node.Free;
  end;
end;

type
  TMyClass=class
  public
    Destructor Destroy; override;
  end;

Destructor TMyClass.Destroy;
begin
  inherited;
end;

procedure Empty;
var b : Boolean;
    Node : TNode<TMyClass>;
begin
  Node:=TNode<TMyClass>.Create;
  try
    Node.Add(TMyClass.Create);
    Node.Add(TMyClass.Create);
    Node.Add(TMyClass.Create);

    Node.Clear;
    b:=Node.Empty;

    Assert(b=True,'Node not empty');
  finally
    Node.Free;
  end;
end;

procedure Free_Index_Parent_Delete;
var Node : TNode<TMyClass>;
    tmp : TInteger;
begin
  Node:=TNode<TMyClass>.Create;
  try
    Node.Add(TMyClass.Create);
    Node.Add(TMyClass.Create);
    Node.Add(TMyClass.Create);

    Assert(Node.Count=3,'Wrong Count');

    Node[1].DisposeOf;

    Assert(Node.Count=2,'Wrong Count');

    tmp:=Node[1].Index;

    Assert(tmp=1,'Wrong Index');

    Assert(Node[1].Parent=Node,'Wrong Parent');

    Node[1].Parent:=nil;

    Assert(Node.Count=1,'Wrong Count');

    Node.Delete(0);

    Assert(Node.Count=0,'Wrong Count');
  finally
    Node.Free;
  end;
end;

procedure Foreach;
var Total : Integer;
    Root  : TNode<Int64>;
    t : Integer;
    Node : TNode<Int64>;
begin
  Root:=TNode<Int64>.Create;
  try
    for t:=0 to 4 do
        Root.Add(t).Add(1000);

    Total:=0;

    // Recursive
    Root.ForEach(procedure(const Item:TNode<Int64>)
         begin
           Inc(Total);
         end);

    Assert(Total=10,'Wrong Count');

    Total:=0;

    // Non Recursive
    Root.ForEach(procedure(const Item:TNode<Int64>)
         begin
           Inc(Total);
         end,
         False);

    Assert(Total=5,'Wrong Count');

    // Test traditional "for t:=..."
    Assert(Root.Count=5,'Wrong Count');

    for t:=0 to Root.Count-1 do
        Root[t].Data:=123;

    for t:=0 to Root.Count-1 do
        Assert(Root[t].Data=123,'Wrong Data');

    // Test modern "for Node in ..."
    for Node in Root.Items do
        Node.Data:=456;

    for Node in Root.Items do
        Assert(Node.Data=456,'Wrong Data');

  finally
    Root.Free;
  end;
end;

procedure Level;
var Root  : TNode<Int64>;
    t : Integer;
begin
  Root:=TNode<Int64>.Create;
  try
    for t:=0 to 4 do
        Root.Add(t).Add(1000);

    // Test Node "Level"
    Assert(Root.Level=0,'Wrong Level 0');
    Assert(Root[0].Level=1,'Wrong Level 1');
    Assert(Root[0][0].Level=2,'Wrong Level 2');
  finally
    Root.Free;
  end;
end;

procedure Exchange;
var Root  : TNode<Byte>;
    t : Integer;
begin
  Root:=TNode<Byte>.Create;
  try
    for t:=0 to 4 do
        Root.Add(t).Add(255);

    Assert(Root.Count=5,'Wrong Count');

    for t:=0 to Root.Count-1 do
        Assert(Root[t].Data=t,'Wrong Data');

    // Test Exchange
    Root.Exchange(3,1);

    Assert(Root[1].Data=3,'Wrong Data');
    Assert(Root[3].Data=1,'Wrong Data');
  finally
    Root.Free;
  end;
end;

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
end;

// Verify Node children Items "Data" is sorted
procedure AssertOrder(const ANode:TNode<Integer>; const Recursive:Boolean);
var t, tmp : Integer;
begin
  if ANode.Count>0 then
  begin
    if Recursive then
       for t:=0 to ANode.Count-1 do
           AssertOrder(ANode[t],Recursive);

    tmp:=ANode[0].Data;

    for t:=1 to ANode.Count-1 do
    begin
      Assert(ANode[t].Data > tmp,'Wrong order at position: '+IntToStr(t));

      tmp:=ANode[t].Data;
    end;
  end;
end;

procedure Sort;
var Node,
    Root  : TNode<Integer>;
    t,tt  : Integer;
begin
  Root:=TNode<Integer>.Create;
  try
    for t:=0 to 4 do
    begin
      Node:=Root.Add(Random(1000));

      for tt:=0 to 10 do
          Node.Add(Random(1000));
    end;

    // Sort non-recursive

    Root.Sort(function(const A,B:TNode<Integer>):Integer
       begin
         result:=CompareIntegers(A.Data,B.Data);
       end,
       False);

    // Verify order ascending (non-recursive)
    AssertOrder(Root,False);

    // Sort recursive

    Root.Sort(function(const A,B:TNode<Integer>):Integer
       begin
         result:=CompareIntegers(A.Data,B.Data);
       end);

    // Verify order ascending (recursive)
    AssertOrder(Root,True);
  finally
    Root.Free;
  end;
end;

begin
  {$IFOPT D+}
  ReportMemoryLeaksOnShutdown:=True;
  {$ENDIF}

  try
    BasicCreate;
    CustomType;
    AddNode;
    CustomData;
    Count;
    Empty;
    Free_Index_Parent_Delete;
    Foreach;
    Level;
    Exchange;
    Sort;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
