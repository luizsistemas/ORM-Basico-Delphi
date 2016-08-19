unit TestPrsDaoFireDac;

interface

uses
  TestFramework, system.Generics.Collections, Lca.Orm.Base, FireDAC.Stan.Error,
  FireDAC.Stan.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait, Rtti, FireDAC.Stan.Async,
  FireDAC.DatS, FireDAC.UI.Intf, Lca.Orm.Comp.FireDac, FireDAC.Stan.Param,
  FireDAC.Comp.Client, FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Stan.Option,
  system.Classes, Lca.Orm.Atributos, FireDAC.Comp.DataSet, FireDAC.Stan.Def,
  FireDAC.DApt.Intf, Db, FireDAC.Phys.FB, system.SysUtils, FireDAC.Phys.FBDef,
  FireDAC.Phys.Intf, Cidade, udmPrin;

type
  TestTDaoFireDac = class(TTestCase)
  strict private
    FDao: TDaoFireDac;
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

uses Vcl.Dialogs;


procedure TestTDaoFireDac.SetUp;
begin
  FDm := TdmPrin.Create(nil);
  FDm.FDConnection1.Connected := true;
  FDao := TDaoFireDac.Create(FDm.FDConnection1, FDm.ttt);
  FCidade := TCidade.Create;
end;

procedure TestTDaoFireDac.TearDown;
begin
  FDm.Free;
  FDm := nil;
  FDao.Free;
  FDao := nil;
  FCidade.free;
end;

procedure TestTDaoFireDac.TestAlterarCidade;
var
  Resultado: Integer;
begin
  FDao.StartTransaction;
  try
    FCidade.ID := 1;
    Resultado := FDao.Buscar(FCidade);

    CheckTrue(Resultado>0, 'Cidade com ID ' + FCidade.ID.ToString + ' não encontrada');

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

procedure TestTDaoFireDac.TestAlterarSomenteCampoIBGEDaCidade;
var
  Resultado: Integer;
begin
  FDao.StartTransaction;
  try
    FCidade.ID := 1;
    Resultado := FDao.Buscar(FCidade);

    CheckTrue(Resultado>0, 'Cidade com ID ' + FCidade.ID.ToString + ' não encontrada');

    FCidade.IBGE := 2101400;

    Resultado := FDao.Salvar(FCidade);

    FDao.Commit;

    FDao.Buscar(FCidade);

    CheckEquals(2101400, FCidade.IBGE, 'Campo IBGE não Alterado!');
  except
    on e:Exception do
    begin
      FDao.RollBack;
      ShowMessage(e.Message);
    end;
  end;

  CheckTrue(Resultado>0,'Nenhuma cidade alterada!');
end;

procedure TestTDaoFireDac.TestConexaoComBanco;
begin
  CheckTrue(FDm.FDConnection1.Connected, 'Erro, banco não conectado! Configure o DM.');
end;

procedure TestTDaoFireDac.TestConsultaGenerica;
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

procedure TestTDaoFireDac.TestConsultaSQLComRetornoDeDataSet;
var
  Registros: TDataset;
begin
  Registros := FDao.ConsultaSql('Select * from Cidade order by id');
  CheckNotNull(Registros,'Dataset nulo!');
  CheckTrue(Registros.RecordCount>0, 'Nenhum dado retornado!');
//
//  while not Registros.Eof do
//  begin
//    FCidade.Id   := Registros.FieldByName('id').AsInteger;
//    FCidade.Nome := Registros.FieldByName('nome').AsString;
//    FCidade.UF   := Registros.FieldByName('Uf').AsString;
//    FCidade.IBGE := Registros.FieldByName('ibge').AsInteger;
//    Memo1.Lines.Add('Registro no DataSet: ' + IntToStr(FCidade.ID));
//    CarregaMemo(FCidade);
//    Memo1.Lines.Add('');
//    Registros.Next;
//  end;
end;

procedure TestTDaoFireDac.TestConsultaTabPorCampoEspecifico;
var
  Registros: TDataset;
begin
  FDao.Limpar(FCidade);
  FCidade.UF := 'MA';
  Registros := FDao.ConsultaTab(FCidade, ['UF']);
  CheckNotNull(Registros,'Dataset nulo!');
  CheckTrue(Registros.RecordCount>0, 'Nenhum dado retornado!');
end;

procedure TestTDaoFireDac.TestConsultaTabPorCampoEspecificoOrdenadoPorNome;
var
  Registros: TDataset;
begin
  FDao.Limpar(FCidade);
  FCidade.UF := 'MA';
  Registros := FDao.ConsultaTab(FCidade, [], ['UF'],['nome']);
  CheckNotNull(Registros,'Dataset nulo!');
  CheckTrue(Registros.RecordCount>0, 'Nenhum dado retornado!');
end;

procedure TestTDaoFireDac.TestConsultaTabRetornandoApenasUmCampo;
var
  Registros: TDataset;
begin
  FDao.Limpar(FCidade);
  FCidade.UF := 'MA';
  Registros := FDao.ConsultaTab(FCidade, ['nome'], ['UF'],['nome']);
  CheckNotNull(Registros,'Dataset nulo!');
  CheckTrue(Registros.RecordCount>0, 'Nenhum dado retornado!');
  CheckNotEquals(Registros.FieldByName('nome').AsString, '', 'Campo nome em branco!');
  CheckTrue(Registros.Fields.Count=1, 'Não devolveu apenas o campo nome! ' + Registros.Fields.Count.ToString());
end;

procedure TestTDaoFireDac.TestExcluirCidade;
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

procedure TestTDaoFireDac.TestInserirCidade;
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

procedure TestTDaoFireDac.TestLimparDadosDoObjetoCidade;
begin
  FDao.Limpar(FCidade);
  CheckTrue(FCidade.ID=0,'Dados do objeto cidade não foram limpos');
end;

procedure TestTDaoFireDac.TestRecordCount;
begin
  FCidade.UF := 'MA';
  CheckTrue(FDao.GetRecordCount(FCidade, ['uf'])>0, 'Recordcount retornou 0!');
end;

procedure TestTDaoFireDac.TestRecordCountComChaveComposta;
begin
  FCidade.UF := 'MA';
  FCidade.IBGE := 2101400;
  CheckTrue(FDao.GetRecordCount(FCidade, ['uf', 'ibge'])>0, 'Recordcount retornou 0!');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTDaoFireDac.Suite);
end.

