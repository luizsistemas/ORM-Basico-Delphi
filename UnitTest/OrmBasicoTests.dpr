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
  PrsBase in '..\OrmBasico\Classes\PrsBase.pas',
  PrsAtributos in '..\OrmBasico\Classes\PrsAtributos.pas',
  PrsDaoFireDac in '..\OrmBasico\Classes\PrsDaoFireDac.pas',
  TestPrsDaoFireDac in 'TestPrsDaoFireDac.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

