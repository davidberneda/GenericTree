unit Unit_Main;

interface

{
  Example using TeeGenericTree class.

  https://github.com/davidberneda/GenericTree


  This example creates a generic tree structure and displays it at a VCL
  TreeView.


}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TeeGenericTree, Vcl.ComCtrls,
  Vcl.StdCtrls;

type
  TGenericTree_Example = class(TForm)
    TreeView1: TTreeView;
    BRemove: TButton;
    EData: TEdit;
    BUp: TButton;
    BDown: TButton;
    Label1: TLabel;
    LChildren: TLabel;
    BAdd: TButton;
    Button1: TButton;
    CBCase: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure BRemoveClick(Sender: TObject);
    procedure EDataChange(Sender: TObject);
    procedure TreeView1Edited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure BAddClick(Sender: TObject);
    procedure BUpClick(Sender: TObject);
    procedure BDownClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    Tree : TNode<String>;

    procedure MoveNode(const ADelta:Integer);
    procedure Present;
  end;

var
  GenericTree_Example: TGenericTree_Example;

implementation

{$R *.dfm}

uses
  NodeView;

procedure TGenericTree_Example.BDownClick(Sender: TObject);
begin
  MoveNode(1);
end;

procedure TGenericTree_Example.BRemoveClick(Sender: TObject);
var Node : TNode<String>;
begin
  Node:=TreeView1.Selected.Data;

  TreeView1.Selected.Free;

  if Tree=Node then
     Tree:=nil;

  Node.Free;

  TreeView1Change(Self,TreeView1.Selected);
end;

procedure TGenericTree_Example.MoveNode(const ADelta:Integer);
var Current,
    Node : TTreeNode;
    tmp : TNode<String>;
begin
  Current:=TreeView1.Selected;
  Node:=Current.Parent;

  Node:=Node.Item[Current.Index+ADelta];

  tmp:=Current.Data;

  if ADelta>0 then
     Current.MoveTo(Node,TNodeAttachMode.naAdd)
  else
     Current.MoveTo(Node,TNodeAttachMode.naInsert);

  TreeView1Change(TreeView1,Current);

  tmp.Parent.Exchange(tmp.Index,tmp.Index+ADelta);
end;

procedure TGenericTree_Example.BUpClick(Sender: TObject);
begin
  MoveNode(-1);
end;

procedure TGenericTree_Example.Button1Click(Sender: TObject);
begin
  Tree.Sort(function(const A,B:TNode<String>):Integer
    begin
      if CBCase.Checked then
         result:=CompareStr(A.Data,B.Data)
      else
         result:=CompareText(A.Data,B.Data);
    end);

  Present;
end;

procedure TGenericTree_Example.BAddClick(Sender: TObject);
var tmp : String;
    NewNode,
    Node : TTreeNode;
    Item : TNode<String>;
begin
  Node:=TreeView1.Selected;

  tmp:='Children '+Node.Count.ToString;

  if InputQuery('New Node','Text',tmp) then
  begin
    Item:=Node.Data;

    Node.Expanded:=True;

    NewNode:=TreeView1.Items.AddChildObject(Node,tmp,Item.Add(tmp));

    TreeView1.Selected:=NewNode;
  end;
end;

procedure TGenericTree_Example.EDataChange(Sender: TObject);
var Node : TNode<String>;
    tmp : TTreeNode;
begin
  tmp:=TreeView1.Selected;

  if tmp<>nil then
  begin
    tmp.Text:=EData.Text;

    Node:=tmp.Data;

    Node.Data:=EData.Text;
  end;
end;

procedure TGenericTree_Example.Present;
begin
  TNodeView.Fill<String>(TreeView1,Tree,
      function(const Data:String):String
      begin
        result:=Data;
      end);
end;

procedure TGenericTree_Example.FormCreate(Sender: TObject);
begin
  Tree:=TNode<String>.Create('Root');

  Tree.Add('Children 1').Add('Grand Children 1 0');

  Tree[0].Add('Grand Children 1 1');

  Tree.Add('Children 2').Add('Grand Children 2');

  Present;
end;

procedure TGenericTree_Example.FormDestroy(Sender: TObject);
begin
  Tree.Free;
end;

procedure TGenericTree_Example.TreeView1Change(Sender: TObject;
  Node: TTreeNode);

var tmp : TNode<String>;
begin
  BRemove.Enabled:=Node<>nil;

  BAdd.Enabled:=BRemove.Enabled;
  EData.Enabled:=BRemove.Enabled;

  if EData.Enabled then
  begin
    tmp:=Node.Data;
    EData.Text:=tmp.Data;
  end
  else
     EData.Text:='';

  BUp.Enabled:=(Node<>nil) and (Node.Index>0);

  BDown.Enabled:=(Node<>nil) and (Node.Parent<>nil) and
                 (Node.Index<Node.Parent.Count-1);

  if Node=nil then
     LChildren.Caption:=''
  else
     LChildren.Caption:=Node.Count.ToString;
end;

procedure TGenericTree_Example.TreeView1Edited(Sender: TObject; Node: TTreeNode;
  var S: string);
var tmp : TNode<String>;
begin
  tmp:=Node.Data;

  tmp.Data:=Node.Text;
end;

end.
