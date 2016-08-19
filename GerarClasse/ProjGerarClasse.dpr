program ProjGerarClasse;

uses
  FastMM4,
  Vcl.Forms,
  ufrmGerarClasse in 'ufrmGerarClasse.pas' {frmConverte},
  udmPrin in '..\Teste\DataModule\udmPrin.pas' {dmPrin: TDataModule},
  Lca.Orm.Atributos in '..\OrmBasico\Classes\Lca.Orm.Atributos.pas',
  Lca.Orm.Base in '..\OrmBasico\Classes\Lca.Orm.Base.pas',
  Lca.Orm.Comp.FireDac in '..\OrmBasico\Classes\Lca.Orm.Comp.FireDac.pas',
  Lca.Orm.Comp.IBX in '..\OrmBasico\Classes\Lca.Orm.Comp.IBX.pas',
  Lca.Orm.GerarClasse in '..\OrmBasico\Classes\Lca.Orm.GerarClasse.pas',
  Lca.Orm.GerarClasse.BancoFirebird in '..\OrmBasico\Classes\Lca.Orm.GerarClasse.BancoFirebird.pas',
  Lca.Orm.GerarClasseIBX in '..\OrmBasico\Classes\Lca.Orm.GerarClasseIBX.pas',
  Lca.Orm.GerarClasseFireDac in '..\OrmBasico\Classes\Lca.Orm.GerarClasseFireDac.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmPrin, dmPrin);
  Application.CreateForm(TfrmConverte, frmConverte);
  Application.Run;
end.
