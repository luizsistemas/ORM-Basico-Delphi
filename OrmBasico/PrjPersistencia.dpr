program PrjPersistencia;

uses
 // FastMM4,
  Vcl.Forms,
  PrsAtributos in 'Classes\PrsAtributos.pas',
  PrsBase in 'Classes\PrsBase.pas',
  udmPrin in 'DataModule\udmPrin.pas' {dmPrin: TDataModule},
  ufrmMain in 'Views\ufrmMain.pas' {frmMain},
  ufrmTesteAtributos in 'Views\ufrmTesteAtributos.pas' {frmTesteAtributos},
  ufrmTesteIbx in 'Views\ufrmTesteIbx.pas' {Form1},
  PrsDaoIBX in 'Classes\PrsDaoIBX.pas',
  Cidade in 'Views\Entity\Cidade.pas',
  Cliente in 'Views\Entity\Cliente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmPrin, dmPrin);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
