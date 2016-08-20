program OrmBasicoTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  FastMM4,
  Cidade in '..\Teste\Entity\Cidade.pas',
  udmPrin in '..\Teste\DataModule\udmPrin.pas' {dmPrin: TDataModule},
  DUnitTestRunner,
  Lca.Orm.Base in '..\OrmBasico\Classes\Lca.Orm.Base.pas',
  Lca.Orm.Atributos in '..\OrmBasico\Classes\Lca.Orm.Atributos.pas',
  Lca.Orm.Comp.FireDac in '..\OrmBasico\Classes\Lca.Orm.Comp.FireDac.pas',
  TestPrsDaoFireDac in 'TestPrsDaoFireDac.pas',
  TestPrsDaoIBX in 'TestPrsDaoIBX.pas',
  Lca.Orm.GerarClasseFireDac in '..\OrmBasico\Classes\Lca.Orm.GerarClasseFireDac.pas',
  Lca.Orm.GerarClasse.BancoFirebird in '..\OrmBasico\Classes\Lca.Orm.GerarClasse.BancoFirebird.pas',
  Lca.Orm.GerarClasse in '..\OrmBasico\Classes\Lca.Orm.GerarClasse.pas',
  Lca.Orm.Comp.IBX in '..\OrmBasico\Classes\Lca.Orm.Comp.IBX.pas',
  Lca.Orm.GerarClasseIBX in '..\OrmBasico\Classes\Lca.Orm.GerarClasseIBX.pas',
  TestPrsDaoGerarClasse in 'TestPrsDaoGerarClasse.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

