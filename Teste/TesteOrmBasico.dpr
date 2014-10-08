program TesteOrmBasico;

uses
  FastMM4,
  Vcl.Forms,
  Cidade in 'Entity\Cidade.pas',
  Cliente in 'Entity\Cliente.pas',
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufrmTesteAtributos in 'Views\ufrmTesteAtributos.pas' {frmTesteAtributos},
  ufrmTesteIbx in 'Views\ufrmTesteIbx.pas' {Form1},
  PrsAtributos in '..\OrmBasico\Classes\PrsAtributos.pas',
  PrsBase in '..\OrmBasico\Classes\PrsBase.pas',
  PrsDaoIBX in '..\OrmBasico\Classes\PrsDaoIBX.pas',
  udmPrin in 'DataModule\udmPrin.pas' {dmPrin: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTesteAtributos, frmTesteAtributos);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdmPrin, dmPrin);
  Application.Run;
end.
