unit NodeView;

interface

uses
  TeeGenericTree, VCL.ComCtrls;

type
  DataToString<T>=reference to function(const Data:T):String;

  TNodeView=class
  private
    class procedure Add<T>(const AView:TTreeView;
                           const AParent:TTreeNode; const AItem:TNode<T>;
                           const ToString:DataToString<T>); static;
  public
    class procedure Fill<T>(const AView:TTreeView; const AItem:TNode<T>;
                            const ToString:DataToString<T>); static;
  end;

implementation

{ TNodeView }

class procedure TNodeView.Add<T>(const AView:TTreeView;
                                 const AParent: TTreeNode; const AItem: TNode<T>;
                                 const ToString:DataToString<T>);
var N : TNode<T>;
    I : TTreeNode;
begin
  for N in AItem.Items do
  begin
    I:=AView.Items.AddChildObject(AParent,ToString(N.Data),N);

    Add(AView,I,N,ToString);
  end;
end;

class procedure TNodeView.Fill<T>(const AView: TTreeView;
                                  const AItem: TNode<T>;
                                  const ToString:DataToString<T>);
var Node : TTreeNode;
begin
  AView.Items.Clear;

  Node:=AView.Items.AddChildObject(nil,ToString(AItem.Data),AItem);

  Add<T>(AView,Node,AItem,ToString);
end;

end.
