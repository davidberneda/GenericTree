// david@steema.com

// Latest source:
// https://github.com/davidberneda/GenericTree

unit TeeGenericTree;

{
 Generic Tree structure
 ======================

 Basic usage:

 var Root : TNode<String>;

 Root := TNode<String>.Create;
 try
   Root.Add('Hello').Add('World !');
 finally
   Root.Free;
 end;

 The generic type can be pre-declared for easier typing:

 type
   TFloatTree = TNode<Single>;

 var Tree1 : TFloatTree;

 Features:

 Adding nodes using the Add method, returns the new created node:

 var Node : TNode<String>;
 Node := Root.Add('abc');

 "Count" returns the number of child nodes for a given node:

 var t : Integer,
 t:=Node.Count;

 "Empty" returns True when the "Count" of children nodes is zero:

 var b : Boolean,
 b:=Node.Empty;

 Destroying a node removes it from its parent:

 Node.Free;

 Nodes can be accessed using the default array property:

 Node := Root[3];

 "Clear" removes and destroys all children nodes of a given node (recursively):

 Node.Clear;

 "Index" returns the position of a node in its parent children array, or -1
 if the node is a "root" node.

 var t : Integer;
 t:=Node.Index;

 "Parent" property returns the node that is the parent of a given node, or
 nil if the node is a "root" node.

 var tmp : TNode<String>;
 tmp:=Node.Parent;

 A node can be "detached" from its parent (without destroying it), setting the
 Parent property to nil:

 Node.Parent:=nil;

 A node can also be removed and destroyed using its Parent Delete method:

 Root.Delete(3); // removes and destroys the 4th child of Root

 Traversing nodes (recursively or not) using the ForEach method:

 var Total:Integer;
 Total:=0;
 Root.ForEach(procedure(const Item:TNode<String>) begin Inc(Total); end);

 The "Level" property returns the depth of a node, (the number of parent->parent->...),
 being zero for root nodes that have no parent.

 var t : Integer;
 t:=Node.Level;

 Exchanging nodes (swap positions):

 Root.Exchange( 5, 9 );  <-- swap positions

 Sorting nodes:

 Root.Sort(function(const A,B:TNode<String>):Integer
    begin
      if CaseSensitive then
         result:=CompareStr(A.Data,B.Data)
      else
         result:=CompareText(A.Data,B.Data);
    end);


}

interface

type
  TInteger=NativeInt;

  TNode<T>=class
  public
  type
    // <0 : A<B
    //  0 : A=B
    // >0 : A>B
    TCompareProc=reference to function(const A,B:TNode<T>):Integer;

  private
  type
    TTypeItem=TNode<T>;

  var
    FItems : TArray<TNode<T>>;

    {$IFDEF AUTOREFCOUNT}[Weak]{$ENDIF}
    FParent : TNode<T>;

    procedure Adopt(const Item:TNode<T>);
    procedure Extract(const Index: TInteger; const ACount: TInteger=1);
    function Get(Index:TInteger):TNode<T>; inline;
    function GetIndex:TInteger;
    function GetLevel:TInteger;
    procedure Orphan;
    procedure PrivateSort(const ACompare: TCompareProc; const l,r:TInteger);
    procedure SetParent(const Value:TNode<T>);
  protected
    property Items:TArray<TNode<T>> read FItems;
  public
  type
    TNodeProc=reference to procedure(const Item:TNode<T>);

  var
    Data : T;

    Constructor Create(const AData:T);
    Destructor Destroy; override;

    function Add(const AData:T):TNode<T>;
    procedure Clear; inline;
    function Count:TInteger; inline;
    function Empty:Boolean; inline;
    procedure Exchange(const Index1,Index2:TInteger);
    procedure Delete(const Index:TInteger; const ACount:TInteger=1);
    procedure ForEach(const AProc:TNodeProc; const Recursive:Boolean=True);
    procedure Sort(const ACompare:TCompareProc; const Recursive:Boolean=True);

    property Index:TInteger read GetIndex;
    property Item[Index:TInteger]:TNode<T> read Get; default;
    property Level:TInteger read GetLevel;
    property Parent:TNode<T> read FParent write SetParent;
  end;

implementation

{ TNode<T> }

// Creates a new Node
constructor TNode<T>.Create(const AData: T);
begin
  inherited Create;
  Data:=AData;
end;

// Remove and destroy all children nodes, then remove Self from Parent
destructor TNode<T>.Destroy;
begin
  Clear;
  Orphan;
  inherited;
end;

// Adds a new node and sets its AData
function TNode<T>.Add(const AData: T): TNode<T>;
begin
  result:=TNode<T>.Create(AData);
  Adopt(result);
end;

// Remove and destroy all children nodes
procedure TNode<T>.Clear;
begin
  Delete(0,Count);
  FItems:=nil;
end;

// Returns the number of children nodes
function TNode<T>.Count: TInteger;
begin
  result:=Length(FItems);
end;

// Removes ACount items from the array, starting at Index position (without destroying them)
procedure TNode<T>.Extract(const Index, ACount: TInteger);
{$IF CompilerVersion<=28}
var t : TInteger;
{$ENDIF}
begin
  {$IF CompilerVersion>28}
  System.Delete(FItems,Index,ACount);
  {$ELSE}
  t:=Count-ACount;

  if t-Index>0 then
     System.Move(FItems[Index+ACount],FItems[Index],SizeOf(TObject)*(t-Index));

  SetLength(FItems,t);
  {$IFEND}
end;

// Removes and destroys children nodes from Index position (ACount default = 1)
procedure TNode<T>.Delete(const Index, ACount: TInteger);
var t : TInteger;
begin
  // Destroy nodes
  for t:=Index to Index+ACount-1 do
  begin
    FItems[t].FParent:=nil;
    FItems[t].Free;
  end;

  Extract(Index,ACount);
end;

// Returns True when this node has no children nodes
function TNode<T>.Empty:Boolean;
begin
  result:=Count=0;
end;

// Swap children nodes at positions: Index1 <---> Index2
procedure TNode<T>.Exchange(const Index1, Index2: TInteger);
var tmp : TNode<T>;
begin
  tmp:=FItems[Index1];
  FItems[Index1]:=FItems[Index2];
  FItems[Index2]:=tmp;
end;

// Calls AProc for each children node (optionally recursive)
procedure TNode<T>.ForEach(const AProc: TNodeProc; const Recursive: Boolean);
var t : TInteger;
    N : TTypeItem;
begin
  for t:=0 to Count-1 do
  begin
    N:=FItems[t];
    AProc(N);

    if Recursive then
       N.ForEach(AProc);
  end;
end;

// Returns children node at Index position
function TNode<T>.Get(Index: TInteger): TNode<T>;
begin
  result:=FItems[Index];
end;

// Returns the Index position of Self in Parent children list
function TNode<T>.GetIndex: TInteger;
var t : Integer;
begin
  if FParent<>nil then
     for t:=0 to FParent.Count-1 do
         if FParent[t]=Self then
            Exit(t);

  result:=-1;
end;

// Returns the number of parents in the hierarchy up to top of tree
function TNode<T>.GetLevel: TInteger;
begin
  if FParent=nil then
     result:=0
  else
     result:=FParent.Level+1;
end;

// Adds Item to children list, sets Item Parent = Self
procedure TNode<T>.Adopt(const Item:TNode<T>);
var L: TInteger;
begin
  Item.FParent:=Self;

  // Pending: Capacity
  L:=Count;
  SetLength(FItems,L+1);
  FItems[L]:=Item;
end;

// Removes itself from Parent children list
procedure TNode<T>.Orphan;
begin
  if FParent<>nil then
     FParent.Extract(Index);
end;

// Sets or changes the Parent node of Self
procedure TNode<T>.SetParent(const Value: TNode<T>);
begin
  if FParent<>Value then
  begin
    Orphan;

    FParent:=Value;

    if FParent<>nil then
       FParent.Adopt(Self);
  end;
end;

// Internal. Re-order nodes using QuickSort algorithm
procedure TNode<T>.PrivateSort(const ACompare: TCompareProc; const l,r:TInteger);
var i : TInteger;
    j : TInteger;
    x : TInteger;
begin
  i:=l;
  j:=r;
  x:=(i+j) shr 1;

  while i<j do
  begin
    while ACompare(Self[i],Self[x])>0 do inc(i);
    while ACompare(Self[x],Self[j])<0 do dec(j);

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
     PrivateSort(ACompare,l,j);

  if i<r then
     PrivateSort(ACompare,i,r);
end;

// Re-order children items according to a custom ACompare function
procedure TNode<T>.Sort(const ACompare: TCompareProc; const Recursive: Boolean);
var t : TInteger;
begin
  if Count>1 then
  begin
    PrivateSort(ACompare,0,Count-1);

    // Optionally, re-order all children-children... nodes
    if Recursive then
       for t:=0 to Count-1 do
           Items[t].Sort(ACompare,Recursive);
  end;
end;

end.
