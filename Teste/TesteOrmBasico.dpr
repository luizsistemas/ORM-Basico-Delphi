program TesteOrmBasico;

uses
  FastMM4,
  Vcl.Forms,
  Cidade in 'Entity\Cidade.pas',
  Cliente in 'Entity\Cliente.pas',
  ufrmTesteAtributos in 'Views\ufrmTesteAtributos.pas' {frmTesteAtributos},
  ufrmTesteIbx in 'Views\ufrmTesteIbx.pas' {Form1},
  PrsAtributos in '..\OrmBasico\Classes\PrsAtributos.pas',
  PrsBase in '..\OrmBasico\Classes\PrsBase.pas',
  udmPrin in 'DataModule\udmPrin.pas' {dmPrin: TDataModule},
  PrsDaoFireDac in '..\OrmBasico\Classes\PrsDaoFireDac.pas',
  PrsDaoIBX in '..\OrmBasico\Classes\PrsDaoIBX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTesteAtributos, frmTesteAtributos);
  Application.CreateForm(TdmPrin, dmPrin);
  Application.Run;
end.
