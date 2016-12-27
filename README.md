# GenericTree

Delphi implementation of a generic Tree structure

## Basic usage:

```delphi
 var Root : TNode<String>;

 Root := TNode<String>.Create;
 try
   Root.Add('Hello').Add('World !');
 finally
   Root.Free;
 end;
```

The generic type can be pre-declared for easier typing:

```delphi
 type
   TFloatTree = TNode<Single>;

 var Tree1 : TFloatTree;
```

## Features:

Adding nodes using the Add method, returns the new created node:

```delphi
 var Node : TNode<String>;
 Node := Root.Add('abc');
```

"Data" property is your own custom data at each node:

```delphi
 var Node : TNode<TDateTime>;
     When : TDateTime;
 Node := Root.Add(Now);
 When := Node.Data;
 Node.Data := Tomorrow;
```

"Count" returns the number of child nodes for a given node:

```delphi
 var t : Integer;
 t:=Node.Count;
```

"Empty" returns True when the number of children nodes is zero:

```delphi
 var b : Boolean;
 b:=Node.Empty;
```

Destroying a node removes it from its parent:

```delphi
 Node.Free;
```

Nodes can be accessed using the default array property:

```delphi
 Node := Root[3];
```

"Clear" removes and destroys all children nodes of a given node (recursively):

```delphi
 Node.Clear;
```

"Index" returns the position of a node in its parent children array, or -1 if the node is a "root" node.

```delphi
 var t : Integer;
 t:=Node.Index;
```

"Parent" property returns the node that is the parent of a given node, or nil if the node is a "root" node.

```delphi
 var tmp : TNode<String>;
 tmp:=Node.Parent;
```

A node can be "detached" from its parent (without destroying it), setting the Parent property to nil:

```delphi
 Node.Parent:=nil;
```

A node can also be removed and destroyed using its Parent Delete method:

```delphi
 Root.Delete(3); // removes and destroys the 4th child of Root
```

Traversing nodes (recursively or not) using the ForEach method:

```delphi
 var Total:Integer;
 Total:=0;
 Root.ForEach(procedure(const Item:TNode<String>) begin Inc(Total); end);
```

A loop of all children nodes can be done using a traditional loop:

```delphi
 var t : Integer;
 for t:=0 to Node.Count-1 do Node[t].Data:='hello';
```

And also using a "for N" :

```delphi
 var N : TNode<String>;
 for N in Node.Items do N.Data:='hello';
```

The "Level" property returns the depth of a node, (the number of parent->parent->...), being zero for root nodes that have no parent.

```delphi
 var t : Integer;
 t:=Node.Level;
```

Children nodes can be exchanged positions:

```delphi
Node.Exchange( 5, 9 );  // <-- swap children nodes at 5 and 9 positions
```

Sorting nodes using a custom "compare" function:

```delphi
Node.Sort(function(const A,B:TNode<String>):Integer
    begin
      if CaseSensitive then
         result:=CompareStr(A.Data,B.Data)
      else
         result:=CompareText(A.Data,B.Data);
    end);
```

