unit ufrmTesteRelacionamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Funcionario, Cidade, Depto, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Lca.Orm.Comp.FireDac;

type
  TfrmTesteRelacionamento = class(TForm)
    Memo: TMemo;
    pnl1: TPanel;
    Panel1: TPanel;
    btnInserir: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    Label1: TLabel;
    edCodFunc: TEdit;
    Label2: TLabel;
    edNomeFunc: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edCpf: TEdit;
    edEndereco: TEdit;
    Label5: TLabel;
    edBairro: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edNomeCidade: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edUF: TEdit;
    Label11: TLabel;
    edIbge: TEdit;
    Label12: TLabel;
    edNomeDep: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edSalario: TEdit;
    btnBuscar: TButton;
    img16: TImageList;
    edCodCidade: TButtonedEdit;
    edCodDep: TButtonedEdit;
    btnBuscaGen: TButton;
    procedure btnExcluirClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edCodCidadeExit(Sender: TObject);
    procedure edCodDepExit(Sender: TObject);
    procedure btnBuscaGenClick(Sender: TObject);
  private
    Funcionario: TFuncionario;
    Depto: TDepto;
    Cidade: TCidade;
    Dao: TDaoFireDac;

    procedure AtualizaForm;
    procedure LimpaForm;
    procedure FormToObjetos;
  public
  end;

var
  frmTesteRelacionamento: TfrmTesteRelacionamento;

implementation

{$R *.dfm}

uses
  udmPrin, Data.DB, System.Generics.Collections, Lca.Orm.Base;

procedure TfrmTesteRelacionamento.btnInserirClick(Sender: TObject);
var
  Registros: Integer;
begin
  Memo.Clear;
  Memo.Lines.Add('Teste do método Inserir.');
  Memo.Lines.Add('');
  FormToObjetos;
  Dao.StartTransaction;
  try
    Funcionario.Id := Dao.GetID(Funcionario, 'Id');
    Registros := Dao.Inserir(Funcionario);
    Dao.Commit;
    AtualizaForm;
    Memo.Lines.Add(Format('Registro inserido: %d', [Registros]));
  except
    on E: Exception do
    begin
      Dao.RollBack;
      ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
    end;
  end;
end;

procedure TfrmTesteRelacionamento.btnSalvarClick(Sender: TObject);
var
  Registros: Integer;
begin
  Memo.Clear;
  Memo.Lines.Add('Teste do método Salvar, alterando todos os campos da tabela.');
  Memo.Lines.Add('');
  FormToObjetos;
  Dao.StartTransaction;
  try
    Registros := Dao.Salvar(Funcionario);
    Dao.Commit;
    AtualizaForm;
    Memo.Lines.Add(Format('Registro alterado: %d', [Registros]));
  except
    on E: Exception do
    begin
      Dao.RollBack;
      ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
    end;
  end;
end;

procedure TfrmTesteRelacionamento.edCodCidadeExit(Sender: TObject);
var
  Cidade: TCidade;
begin
  if Trim(edCodCidade.Text).IsEmpty then
    Exit;
  Cidade := TCidade.Create;
  try
    Cidade.Id := StrToIntDef(edCodCidade.Text, 0);
    if Dao.Buscar(Cidade) > 0 then
    begin
      edNomeCidade.Text := Cidade.Nome;
      edUF.Text := Cidade.Uf;
      edIbge.Text := Cidade.Ibge.ToString;
    end;
  finally
    Cidade.Free;
  end;
end;

procedure TfrmTesteRelacionamento.edCodDepExit(Sender: TObject);
var
  Depto: TDepto;
begin
  if Trim(edCodDep.Text).IsEmpty then
    Exit;
  Depto := TDepto.Create;
  try
    Depto.Id := StrToIntDef(edCodDep.Text, 0);
    if Dao.Buscar(Depto) > 0 then
      edNomeDep.Text := Depto.Nome;
  finally
    Depto.Free;
  end;
end;

procedure TfrmTesteRelacionamento.AtualizaForm;
begin
  edCodFunc.Text := Funcionario.Id.ToString;
  edNomeFunc.Text := Funcionario.Nome;
  edCpf.Text := Funcionario.Cpf;
  edEndereco.Text := Funcionario.Endereco;
  edBairro.Text := Funcionario.Bairro;
  edCodCidade.Text := Funcionario.Cidade.Id.ToString;
  edNomeCidade.Text := Funcionario.Cidade.Nome;
  edUF.Text := Funcionario.Cidade.Uf;
  edIbge.Text := Funcionario.Cidade.Ibge.ToString;
  edCodDep.Text := Funcionario.Depto.Id.ToString;
  edNomeDep.Text := Funcionario.Depto.Nome;
  edSalario.Text := FormatFloat(',0.00', Funcionario.Salario);
end;

procedure TfrmTesteRelacionamento.FormCreate(Sender: TObject);
begin
  Dao := dmPrin.Dao;
  Funcionario := TFuncionario.Create;
  Depto := TDepto.Create;
  Cidade := TCidade.Create;
end;

procedure TfrmTesteRelacionamento.FormDestroy(Sender: TObject);
begin
  Funcionario.Free;
  Depto.Free;
  Cidade.Free;
end;

procedure TfrmTesteRelacionamento.FormToObjetos;
var
  Fmt: TFormatSettings;
begin
  Funcionario.Id := StrToIntDef(edCodFunc.Text, 0);
  Funcionario.Nome := edNomeFunc.Text;
  Funcionario.Cpf := edCpf.Text;
  Funcionario.Endereco := edEndereco.Text;
  Funcionario.Bairro := edBairro.Text;
  Funcionario.Cidade.Id := StrToIntDef(edCodCidade.Text, 0);
  Funcionario.Cidade.Nome := edNomeCidade.Text;
  Funcionario.Cidade.Uf := edUF.Text;
  Funcionario.Cidade.Ibge := StrToIntDef(edIbge.Text, 0);
  Funcionario.Depto.Id := StrToIntDef(edCodDep.Text, 0);
  Funcionario.Depto.Nome := edNomeDep.Text;
  Fmt := TFormatSettings.Create;
  Fmt.DecimalSeparator := ',';
  Funcionario.Salario := StrToFloat(StringReplace(edSalario.Text, '.', '', [rfReplaceAll]), Fmt);
end;

procedure TfrmTesteRelacionamento.LimpaForm;
begin
  edCodfunc.Clear;
  edNomeFunc.Clear;
  edCpf.Clear;
  edEndereco.Clear;
  edBairro.Clear;
  edNomeCidade.Clear;
  edUF.Clear;
  edIbge.Clear;
  edCodCidade.Clear;
  edSalario.Clear;
  edCodDep.Clear;
  edNomeDep.Clear;
end;

procedure TfrmTesteRelacionamento.btnBuscaGenClick(Sender: TObject);
var
  Lista: TObjectList<TFuncionario>;
  I: Integer;
begin
  Memo.Lines.Clear;
  Memo.Lines.Add('Teste do método ConsultaGen, obtendo como retorno objeto(s) do tipo especificado.');
  Memo.Lines.Add('');
  Funcionario.Limpar;
  Funcionario.Id := StrToIntDef(edCodFunc.Text, 0);
  Lista := Dao.ConsultaGen<TFuncionario>(Funcionario, ['Id']);
  try
    for I := 0 to Lista.Count - 1 do
    begin
      Funcionario.CopyProps(Lista.Items[I]);
      Memo.Lines.Add('Registro no DataSet: ' + IntToStr(Funcionario.Id));
      Memo.Lines.Add('');
      AtualizaForm;
    end;
  finally
    Lista.Free;
  end;
end;

procedure TfrmTesteRelacionamento.btnBuscarClick(Sender: TObject);
var
  Registros: Integer;
begin
  Memo.Clear;
  Memo.Lines.Add('Teste do método Buscar.');
  Memo.Lines.Add('');
  Funcionario.Id := StrToIntDef(edCodFunc.Text, 0);
  Registros := Dao.Buscar(Funcionario);
  if Registros>0 then
  begin
    Memo.Lines.Add(Format('Registro localizado: %d', [Registros]));
    AtualizaForm;
  end
  else
  ShowMessage('Registro não encontrado!');
end;

procedure TfrmTesteRelacionamento.btnExcluirClick(Sender: TObject);
var
  Registros: Integer;
begin
  Memo.Clear;
  Memo.Lines.Add('Teste do método Excluir.');
  Memo.Lines.Add('');
  Funcionario.Id := StrToIntDef(edCodFunc.Text, 0);
  Dao.StartTransaction;
  try
    Registros := Dao.Excluir(Funcionario);
    Dao.Commit;
    Memo.Lines.Add(Format('Registro excluido: %d', [Registros]));
    LimpaForm;
  except
    on E: Exception do
    begin
      Dao.RollBack;
      ShowMessage('Ocorreu um problema ao executar operação: ' + e.Message);
    end;
  end;
end;

end.
