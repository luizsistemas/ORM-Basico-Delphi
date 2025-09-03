program TesteOrmBasico;

uses
  Vcl.Forms,
  Cidade in 'Entity\Cidade.pas',
  Cliente in 'Entity\Cliente.pas',
  ufrmTesteRelacionamento in 'Views\ufrmTesteRelacionamento.pas' {frmTesteRelacionamento},
  ufrmTesteIbx in 'Views\ufrmTesteIbx.pas' {frmTesteIbx},
  udmPrin in 'DataModule\udmPrin.pas' {dmPrin: TDataModule},
  ufrmCadFunc in 'Views\ufrmCadFunc.pas' {frmCadFunc},
  Depto in 'Entity\Depto.pas',
  Funcionario in 'Entity\Funcionario.pas',
  ufrmTesteAtributos in 'Views\ufrmTesteAtributos.pas' {frmTesteAtributos};

{$R *.res}

begin
  {$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmPrin, dmPrin);
  Application.Run;
end.
