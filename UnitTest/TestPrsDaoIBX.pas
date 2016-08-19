unit TestPrsDaoIBX;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, Db, Lca.Orm.Comp.IBX, ibx.IBDatabase,
  Lca.Orm.Atributos, ibx.IB, ibx.IBQuery, Rtti,
  Lca.Orm.Base, system.SysUtils, system.Classes, system.Generics.Collections,
  Cidade, udmPrin, Vcl.Dialogs;

type
  // Test methods for class TDaoIBX

  TestTDaoIBX = class(TTestCase)
  strict private
    FDao: TDaoIBX;
    FDm: TdmPrin;
    FCidade: TCidade;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConexaoComBanco;
    procedure TestLimparDadosDoObjetoCidade;
    procedure TestInserirCidade;
    procedure TestAlterarCidade;
    procedure TestAlterarSomenteCampoIBGEDaCidade;
    procedure TestConsultaSQLComRetornoDeDataSet;
    procedure TestConsultaTabPorCampoEspecifico;
    procedure TestConsultaTabPorCampoEspecificoOrdenadoPorNome;
    procedure TestConsultaTabRetornandoApenasUmCampo;
    procedure TestConsultaGenerica;
    procedure TestRecordCount;
    procedure TestRecordCountComChaveComposta;
    procedure TestExcluirCidade;
  end;

implementation

procedure TestTDaoIBX.SetUp;
begin
  FDm := TdmPrin.Create(nil);
  FDm.IBDatabase1.Open;
  FDao := TDaoIBX.Create(FDm.IBDatabase1, FDm.texec);
  FCidade := TCidade.Create;
end;

procedure TestTDaoIBX.TearDown;
begin
  FDm.Free;
  FDm := nil;
  FDao.Free;
  FDao := nil;
  FCidade.free;
end;

procedure TestTDaoIBX.TestAlterarCidade;
var
  Resultado: Integer;
begin
  FDao.StartTransaction;
  try
    FCidade.ID := 1;
    Resultado := FDao.Buscar(FCidade);

    CheckTrue(Resultado>0, 'Cidade com ID ' + FCidade.ID.ToString + ' n�o encontrada');

    FCidade.Nome := 'BALSAS';
    FCidade.DataCad := Date;

    Resultado := FDao.Salvar(FCidade);

    FDao.Commit;
  except
    on e:Exception do
    begin
      FDao.RollBack;
      ShowMessage(e.Message);
    end;
  end;

  CheckTrue(Resultado>0,'Nenhuma cidade alterada!');
end;

procedure TestTDaoIBX.TestAlterarSomenteCampoIBGEDaCidade;
var
  Resultado: Integer;
begin
  FDao.StartTransaction;
  try
    FCidade.ID := 1;
    Resultado := FDao.Buscar(FCidade);

    CheckTrue(Resultado>0, 'Cidade com ID ' + FCidade.ID.ToString + ' n�o encontrada');

    FCidade.IBGE := 2101400;

    Resultado := FDao.Salvar(FCidade);

    FDao.Commit;

    FDao.Buscar(FCidade);

    CheckEquals(2101400, FCidade.IBGE, 'Campo IBGE n�o Alterado!');
  except
    on e:Exception do
    begin
      FDao.RollBack;
      ShowMessage(e.Message);
    end;
  end;

  CheckTrue(Resultado>0,'Nenhuma cidade alterada!');
end;

procedure TestTDaoIBX.TestConexaoComBanco;
begin
  CheckTrue(FDm.IBDatabase1.Connected, 'Erro, banco n�o conectado! Configure o DM.');
end;

procedure TestTDaoIBX.TestConsultaGenerica;
var
  Registros: TObjectList<TCidade>;
begin
  FDao.Limpar(FCidade);
  FCidade.UF := 'MA';
  Registros := FDao.ConsultaGen<TCidade>(FCidade, ['uf']);
  try
    CheckNotNull(Registros,'Dataset nulo!');
    CheckTrue(Registros.Count>0, 'Nenhum dado retornado!');
  finally
    Registros.Free;
  end;
end;

procedure TestTDaoIBX.TestConsultaSQLComRetornoDeDataSet;
var
  Registros: TDataset;
begin
  Registros := FDao.ConsultaSql('Select * from Cidade order by id');
  CheckNotNull(Registros,'Dataset nulo!');
  CheckTrue(Registros.RecordCount>0, 'Nenhum dado retornado!');
end;

procedure TestTDaoIBX.TestConsultaTabPorCampoEspecifico;
var
  Registros: TDataset;
begin
  FDao.Limpar(FCidade);
  FCidade.UF := 'MA';
  Registros := FDao.ConsultaTab(FCidade, ['UF']);
  CheckNotNull(Registros,'Dataset nulo!');
  CheckTrue(Registros.RecordCount>0, 'Nenhum dado retornado!');
end;

procedure TestTDaoIBX.TestConsultaTabPorCampoEspecificoOrdenadoPorNome;
var
  Registros: TDataset;
begin
  FDao.Limpar(FCidade);
  FCidade.UF := 'MA';
  Registros := FDao.ConsultaTab(FCidade, [], ['UF'],['nome']);
  CheckNotNull(Registros,'Dataset nulo!');
  CheckTrue(Registros.RecordCount>0, 'Nenhum dado retornado!');
end;

procedure TestTDaoIBX.TestConsultaTabRetornandoApenasUmCampo;
var
  Registros: TDataset;
begin
  FDao.Limpar(FCidade);
  FCidade.UF := 'MA';
  Registros := FDao.ConsultaTab(FCidade, ['nome'], ['UF'],['nome']);
  CheckNotNull(Registros,'Dataset nulo!');
  CheckTrue(Registros.RecordCount>0, 'Nenhum dado retornado!');
  CheckNotEquals(Registros.FieldByName('nome').AsString, '', 'Campo nome em branco!');
  CheckTrue(Registros.Fields.Count=1, 'N�o devolveu apenas o campo nome! ' + Registros.Fields.Count.ToString());
end;

procedure TestTDaoIBX.TestExcluirCidade;
var
  Resultado: Integer;
begin
  FDao.StartTransaction;
  try
    FCidade.ID := 1;
    Resultado := FDao.Excluir(FCidade);

    FDao.Commit;
  except
    on e:Exception do
    begin
      FDao.RollBack;
      ShowMessage(e.Message);
    end;
  end;

  CheckTrue(Resultado>0,'Nenhuma cidade inserida!');
end;

procedure TestTDaoIBX.TestInserirCidade;
var
  Resultado: Integer;
begin
  FDao.StartTransaction;
  try
    FCidade.ID := 1;
    Resultado := FDao.Buscar(FCidade);

    if Resultado>0 then
      Exit;

    FCidade.Nome := 'Balsas';
    FCidade.UF := 'MA';
    FCidade.IBGE := 2101401;
    FCidade.DataCad := Date;

    Resultado := FDao.Inserir(FCidade);

    FDao.Commit;
  except
    on e:Exception do
    begin
      FDao.RollBack;
      ShowMessage(e.Message);
    end;
  end;

  CheckTrue(Resultado>0,'Nenhuma cidade inserida!');
end;

procedure TestTDaoIBX.TestLimparDadosDoObjetoCidade;
begin
  FDao.Limpar(FCidade);
  CheckTrue(FCidade.ID=0,'Dados do objeto cidade n�o foram limpos');
end;

procedure TestTDaoIBX.TestRecordCount;
begin
  FCidade.UF := 'MA';
  CheckTrue(FDao.GetRecordCount(FCidade, ['uf'])>0, 'Recordcount retornou 0!');
end;

procedure TestTDaoIBX.TestRecordCountComChaveComposta;
begin
  FCidade.UF := 'MA';
  FCidade.IBGE := 2101400;
  CheckTrue(FDao.GetRecordCount(FCidade, ['uf', 'ibge'])>0, 'Recordcount retornou 0!');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTDaoIBX.Suite);
end.

