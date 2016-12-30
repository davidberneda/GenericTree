program QuickSort_Compare;

uses
  Vcl.Forms,
  Unit_QuickSort_Compare in 'Unit_QuickSort_Compare.pas' {QuickSortCompare};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TQuickSortCompare, QuickSortCompare);
  Application.Run;
end.
