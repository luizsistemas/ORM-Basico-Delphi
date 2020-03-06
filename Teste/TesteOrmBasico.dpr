program TesteOrmBasico;

uses
  Vcl.Forms,
  Cidade in 'Entity\Cidade.pas',
  Cliente in 'Entity\Cliente.pas',
  ufrmTesteRelacionamento in 'Views\ufrmTesteRelacionamento.pas' {frmTesteRelacionamento},
  ufrmTesteIbx in 'Views\ufrmTesteIbx.pas' {frmTesteIbx},
  Lca.Orm.Atributos in '..\OrmBasico\Classes\Lca.Orm.Atributos.pas',
  Lca.Orm.Base in '..\OrmBasico\Classes\Lca.Orm.Base.pas',
  udmPrin in 'DataModule\udmPrin.pas' {dmPrin: TDataModule},
  Lca.Orm.Comp.FireDac in '..\OrmBasico\Classes\Lca.Orm.Comp.FireDac.pas',
  Lca.Orm.Comp.IBX in '..\OrmBasico\Classes\Lca.Orm.Comp.IBX.pas',
  Lca.Orm.GerarClasse in '..\OrmBasico\Classes\Lca.Orm.GerarClasse.pas',
  Lca.Orm.GerarClasse.BancoFirebird in '..\OrmBasico\Classes\Lca.Orm.GerarClasse.BancoFirebird.pas',
  Lca.Orm.GerarClasseFireDac in '..\OrmBasico\Classes\Lca.Orm.GerarClasseFireDac.pas',
  Lca.Orm.GerarClasseIBX in '..\OrmBasico\Classes\Lca.Orm.GerarClasseIBX.pas',
  ufrmCadFunc in 'Views\ufrmCadFunc.pas' {frmCadFunc},
  ufrmTesteAtributos in 'Views\ufrmTesteAtributos.pas' {frmTesteAtributos},
  Depto in 'Entity\Depto.pas',
  Funcionario in 'Entity\Funcionario.pas';

{$R *.res}

begin
  {$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmPrin, dmPrin);
  Application.CreateForm(TfrmTesteRelacionamento, frmTesteRelacionamento);
  Application.Run;
end.
