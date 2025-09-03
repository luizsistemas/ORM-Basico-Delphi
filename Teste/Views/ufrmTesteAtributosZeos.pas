unit ufrmTesteAtributosZeos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Cidade, Vcl.ExtCtrls,
  Lca.Orm.Comp.Zeos;

type
  TfrmTesteAtributosZeos = class(TForm)
    Memo1: TMemo;
    pnl1: TPanel;
    btnExcluir: TButton;
    btnInserir: TButton;
    btnSalvar: TButton;
    btnBuscar: TButton;
    btnDataSet: TButton;
    Button1: TButton;
    Button2: TButton;
    btnSalvarUF: TButton;
    Button3: TButton;
    Button4: TButton;
    btn1: TButton;
    btn2: TButton;
    Button5: TButton;
    btnLimpar: TButton;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnDataSetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnSalvarUFClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Dao: TDaoZeos;

    procedure CarregaMemo(Tabela: TCidade);
  public
  end;

var
  frmTesteAtributosZeos: TfrmTesteAtributosZeos;

implementation

{$R *.dfm}

uses
  udmPrin, Data.DB, System.Generics.Collections, Lca.Orm.Base;

procedure TfrmTesteAtributosZeos.btnInserirClick(Sender: TObject);
var
  ATab: TCidade;
  Registros: Integer;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método Inserir.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    with ATab do
    begin
      id := 1;
      UF := 'MA';
      Nome := 'MARANHÃO';
      IBGE := 2100000;
    end;

    dmPrin.Dao.StartTransaction;
    try
      Registros := dmPrin.Dao.Inserir(ATab);

      dmPrin.Dao.Commit;

      Memo1.Lines.Add(Format('Registro inserido: %d', [Registros]));
      carregaMemo(ATab);
    except
      on E: Exception do
      begin
        if dmPrin.Dao.InTransaction then
          dmPrin.Dao.RollBack;
        ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
      end;
    end;
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.btnSalvarClick(Sender: TObject);
var
  ATab: TCidade;
  Registros: Integer;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método Salvar, alterando todos os campos da tabela.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    with ATab do
    begin
      id := 1;
      UF := 'MA';
      Nome := 'BALSAS2';
      IBGE := 2100000;
    end;
    dmPrin.Dao.StartTransaction;
    try
      Registros := dmPrin.Dao.Salvar(ATab);

      dmPrin.Dao.Commit;

      Memo1.Lines.Add(Format('Registro alterado: %d', [Registros]));
      CarregaMemo(ATab);
    except
      on E: Exception do
      begin
        if dmPrin.Dao.InTransaction then
          dmPrin.Dao.RollBack;
        ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
      end;
    end;
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.btnSalvarUFClick(Sender: TObject);
var
  ATab: TCidade;
  Registros: Integer;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método Salvar, alterando apenas campo UF da tabela.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    with ATab do
    begin
      id := 1;
      UF := 'PR';
    end;

    dmPrin.Dao.StartTransaction;
    try
      Registros := dmPrin.Dao.Salvar(ATab,['UF']);

      dmPrin.Dao.Commit;

      dmPrin.Dao.Buscar(ATab);

      Memo1.Lines.Add(Format('Registro alterado: %d', [Registros]));

      CarregaMemo(ATab);
    except
      on E: Exception do
      begin
        if dmPrin.Dao.InTransaction then
          dmPrin.Dao.RollBack;
        ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
      end;
    end;
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.Button1Click(Sender: TObject);
var
  ATab: TCidade;
  Lista: TObjectList<TCidade>;
  I: Integer;
begin
  ATab := TCidade.Create;
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Teste do método ConsultaGen, obtendo como retorno objeto(s) do tipo especificado: TCidade.');
  Memo1.Lines.Add('');
  try
    ATab.ID := 1;
    ATab.UF := 'MA';
    Lista := dmPrin.dao.ConsultaGen<TCidade>(ATab, ['UF']);
    try
      for I := 0 to Lista.Count - 1 do
      begin
        ATab.ID   := Lista.Items[i].ID;
        ATab.Nome := Lista.Items[i].Nome;
        ATab.UF   := Lista.Items[i].UF;
        ATab.IBGE := Lista.Items[i].IBGE;
        Memo1.Lines.Add('Registro no DataSet: ' + IntToStr(ATab.ID));
        CarregaMemo(ATab);
        Memo1.Lines.Add('');
      end;
    finally
      lista.Free;
    end;
  finally
    ATab.free;
  end;
end;

procedure TfrmTesteAtributosZeos.Button2Click(Sender: TObject);
var
  Tab: TCidade;
begin
  tab := tcidade.create;
  try
    Memo1.Clear;
    tab.UF := 'MA';
    Memo1.Lines.Add('Cidades Cadastradas MA: ' +
      IntToStr(dmprin.Dao.GetRecordCount(Tab, ['uf'])));
  finally
    tab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.Button3Click(Sender: TObject);
var
  ATab: TCidade;
  Registros: TDataSet;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método ConsultaTab, todos os campos da tabela, filtro pelo campo UF=MA e sem ordenação.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    ATab.Id := 1;
    Registros := dmPrin.Dao.ConsultaTab(ATab, ['id']).DataSet;
    while not Registros.Eof do
    begin
      ATab.Nome := Registros.FieldByName('nome').AsString;
      ATab.UF   := Registros.FieldByName('Uf').AsString;
      ATab.IBGE := Registros.FieldByName('ibge').AsInteger;
      Memo1.Lines.Add('Registro no DataSet: ' + IntToStr(ATab.ID));
      CarregaMemo(ATab);
      Memo1.Lines.Add('');
      Registros.Next;
    end;
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.Button4Click(Sender: TObject);
var
  ATab: TCidade;
  Registros: TDataSet;
  Lista: TStringList;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método ConsultaTab, pegando apenas o campo nome da tabela e filtro pelo campo UF=MA.');
  Memo1.Lines.Add('');
  Lista.Add('');
  ATab := TCidade.Create;
  try
    ATab.UF := 'MA';
    Registros := dmPrin.Dao.ConsultaTab(ATab, ['nome'], ['uf']).Dataset;
    while not Registros.Eof do
    begin
      ATab.Nome := Registros.FieldByName('nome').AsString;
      Memo1.Lines.Add('Registro no DataSet: ' + IntToStr(ATab.ID));
      CarregaMemo(ATab);
      Memo1.Lines.Add('');
      Registros.Next;
    end;
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.Button5Click(Sender: TObject);
var
  Tab: TCidade;
begin
  tab := tcidade.create;
  try
    Memo1.Clear;
    tab.UF := 'MA';
    Tab.IBGE := 2200000;
    Memo1.Lines.Add('Cidades Cadastradas MA com IBGE 2100000: ' +
      IntToStr(dmprin.Dao.GetRecordCount(Tab, ['uf', 'ibge'])));
  finally
    tab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.btnLimparClick(Sender: TObject);
var
  ATab: TCidade;
begin
  ATab := TCidade.Create;
  try
    ATab.ID := 1;
    dmPrin.Dao.Buscar(ATab);

    ATab.Limpar;

    CarregaMemo(ATab);
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.btnDataSetClick(Sender: TObject);
var
  ATab: TCidade;
  Registros: TDataSet;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método ConsultaSQL, todos os campos da tabela, sem filtro e ordenado por id.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    Registros := dmPrin.Dao.ConsultaSql('Select * from Cidade order by id').Dataset;
    while not Registros.Eof do
    begin
      ATab.Id   := Registros.FieldByName('id').AsInteger;
      ATab.Nome := Registros.FieldByName('nome').AsString;
      ATab.UF   := Registros.FieldByName('Uf').AsString;
      ATab.IBGE := Registros.FieldByName('ibge').AsInteger;
      Memo1.Lines.Add('Registro no DataSet: ' + IntToStr(ATab.ID));
      CarregaMemo(ATab);
      Memo1.Lines.Add('');
      Registros.Next;
    end;
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.CarregaMemo(Tabela: TCidade);
begin
  Memo1.Lines.Add(Format('Cidade.: %s' , [Tabela.Nome]));
  Memo1.Lines.Add(Format('UF.....: %s' , [Tabela.UF]));
  Memo1.Lines.Add(Format('IBGE...: %d' , [Tabela.IBGE]));
end;

procedure TfrmTesteAtributosZeos.FormCreate(Sender: TObject);
var
  Path: string;
begin
  Path := ExpandFileName(ExtractFileDir(Application.ExeName) + '\..\..\');
  dmPrin.ZConnection1.Connected := False;
  dmPrin.ZConnection1.Database := Path + '\Bd\BANCOTESTE.FDB';
  dmPrin.ZConnection1.User := 'SYSDBA';
  dmPrin.ZConnection1.Password := '02025626';
  dmPrin.ZConnection1.Connected := True;
  Dao := TDaoZeos.Create(dmPrin.ZConnection1);
end;

procedure TfrmTesteAtributosZeos.FormDestroy(Sender: TObject);
begin
  Dao.Free;
end;

procedure TfrmTesteAtributosZeos.btn1Click(Sender: TObject);
var
  ATab: TCidade;
  Registros: TDataset;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método ConsultaTab, todos os campos da tabela, sem filtro e ordenado por UF e nome.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    Registros := Dao.ConsultaTab(ATab, [],[],['UF','Nome'], 0).DataSet;
    while not Registros.Eof do
    begin
      ATab.Id   := Registros.FieldByName('id').AsInteger;
      ATab.Nome := Registros.FieldByName('nome').AsString;
      ATab.Uf   := Registros.FieldByName('uf').AsString;
      ATab.Ibge := Registros.FieldByName('ibge').AsInteger;
      Memo1.Lines.Add('Registro no DataSet: ' + IntToStr(ATab.ID));
      CarregaMemo(ATab);
      Memo1.Lines.Add('');
      Registros.Next;
    end;
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.btn2Click(Sender: TObject);
var
  ATab: TCidade;
  Registros: TDataset;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método ConsultaTab, todos os campos da tabela, filtro pelo campo UF=MA e ordenado por nome.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    ATab.UF := 'MA';
    Registros := Dao.ConsultaTab(ATab, [], ['UF'], ['Nome'], 1).DataSet;
    while not Registros.Eof do
    begin
      ATab.ID   := Registros.FieldByName('id').AsInteger;
      ATab.Nome := Registros.FieldByName('nome').AsString;
      ATab.UF   := Registros.FieldByName('Uf').AsString;
      ATab.IBGE := Registros.FieldByName('ibge').AsInteger;
      Memo1.Lines.Add('Registro no DataSet: ' + IntToStr(ATab.ID));
      CarregaMemo(ATab);
      Memo1.Lines.Add('');
      Registros.Next;
    end;
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.btnBuscarClick(Sender: TObject);
var
  ATab: TCidade;
  Registros: Integer;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método Buscar.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    ATab.Id := 1;
      Registros := Dao.Buscar(ATab);
      if Registros>0 then
      begin
        Memo1.Lines.Add(Format('Registro localizado: %d', [Registros]));
        CarregaMemo(ATab);
      end
      else
      ShowMessage('Registro não encontrado!');
  finally
    ATab.Free;
  end;
end;

procedure TfrmTesteAtributosZeos.btnExcluirClick(Sender: TObject);
var
  ATab: TCidade;
  Registros: Integer;
begin
  Memo1.Clear;
  Memo1.Lines.Add('Teste do método Excluir.');
  Memo1.Lines.Add('');
  ATab := TCidade.Create;
  try
    ATab.Id := 1;
    Dao.StartTransaction;
    try
      Registros := Dao.Excluir(ATab);

      Dao.Commit;

      Memo1.Lines.Add(Format('Registro excluido: %d', [Registros]));

    except
      on E: Exception do
      begin
        if Dao.InTransaction then
          Dao.RollBack;
        ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
      end;
    end;
  finally
    ATab.Free;
  end;
end;

end.
