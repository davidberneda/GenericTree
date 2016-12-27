program TeeGenericTree_Demo;

uses
  Vcl.Forms,
  Unit_Main in 'Unit_Main.pas' {GenericTree_Example},
  NodeView in 'NodeView.pas';

{$R *.res}

begin
  {$IFOPT D+}
  ReportMemoryLeaksOnShutdown:=True;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGenericTree_Example, GenericTree_Example);
  Application.Run;
end.
