{******************************************************************************}
{ Projeto: ORM - Básico do Blog do Luiz                                        }
{ Este projeto busca agilizar o processo de manipulação de dados (DAO/CRUD),   }
{ ou seja,  gerar inserts, updates, deletes nas tabelas de forma automática,   }
{ sem a necessidade de criarmos classes DAOs para cada tabela. Também visa     }
{ facilitar a transição de uma suite de componentes de acesso a dados para     }
{ outra.                                                                       }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Luiz Carlos Alves                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{    Luiz Carlos Alves - contato@luizsistemas.com.br                           }
{                                                                              }
{ Você pode obter a última versão desse arquivo no repositório                 }
{ https://github.com/luizsistemas/ORM-Basico-Delphi                            }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{ Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Luiz Carlos Alves - contato@luizsistemas.com.br -  www.luizsistemas.com.br   }
{                                                                              }
{******************************************************************************}

unit DaoUib;

interface

uses Lca.Orm.Base, Rtti, Lca.Orm.Atributos, uib, system.SysUtils, System.Classes, uibdataset,
  db;

type
  TDaoUib = class(TDaoBase)
  private
    // conexao com o banco de dados
    FDatabase: TUIBDataBase;
    // transação para crud
    FTransaction: TUIBTransaction;

  protected
    // métodos responsáveis por setar os parâmetros
    procedure QryParamInteger(ARecParams: TRecParams); override;
    procedure QryParamString(ARecParams: TRecParams); override;
    procedure QryParamDate(ARecParams: TRecParams); override;
    procedure QryParamCurrency(ARecParams: TRecParams); override;
    procedure QryParamVariant(ARecParams: TRecParams); override;

    //métodos para setar os variados tipos de campos
    procedure SetaCamposInteger(ARecParams: TRecParams); override;
    procedure SetaCamposString(ARecParams: TRecParams); override;
    procedure SetaCamposDate(ARecParams: TRecParams); override;
    procedure SetaCamposCurrency(ARecParams: TRecParams); override;

    function ExecutaQuery: Integer; override;
  public
    //query para execução dos comandos crud
    Qry: TUIBQuery;
    constructor Create();
    //dataset para as consultas
    function ConsultaSql(ASql: string): TDataSet; override;

    //pega campo autoincremento
    function GetAutoIncremento (ATabela, ACampo: string): integer; override;
    function Inserir(ATabela: TTabela): Integer; override;
    function Salvar(ATabela: TTabela): Integer;  override;
    function Excluir(ATabela: TTabela): Integer; override;
    function Buscar(ATabela:TTabela): Integer; override;

    function Conectado: Boolean; override;
    function InTransaction: Boolean; override;
    procedure Conecta; override;
    procedure StartTransaction; override;
    procedure Commit; override;
    procedure RollBack; override;
  end;

implementation

{ TDaoUib }

uses Vcl.forms, dialogs, System.TypInfo;

constructor TDaoUib.Create();
begin
  inherited Create;

  FDatabase := TUIBDataBase.Create(Application);
  //configurações iniciais da conexão
  with FDatabase do
  begin
    Params.Add('sql_dialect=3');
    Params.Add('lc_ctype=ISO8859_1');
  end;

  FTransaction := TUIBTransaction.Create(Application);
  //configurações iniciais da transacao
  with FTransaction do
  begin
    Database := FDatabase;
    DefaultAction := etmCommit;
  end;

  Qry := TUIBQuery.Create(Application);
  Qry.DataBase := FDatabase;
  Qry.Transaction := FTransaction;
end;

procedure TDaoUib.QryParamCurrency(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    TUIBQuery(Qry).Params.ByNameAsCurrency[Campo] := Prop.GetValue(Tabela).AsCurrency;
  end;
end;

procedure TDaoUib.QryParamDate(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    TUIBQuery(Qry).Params.ByNameAsDateTime[Campo] := Prop.GetValue(Tabela).AsType<TDateTime>;
  end;
end;

procedure TDaoUib.QryParamInteger(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
   TUIBQuery(Qry).Params.ByNameAsInteger[Campo] := Prop.GetValue(Tabela).AsInteger;
  end;
end;

procedure TDaoUib.QryParamString(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    TUIBQuery(Qry).Params.ByNameAsString[Campo] := Prop.GetValue(Tabela).AsString;
  end;
end;

procedure TDaoUib.QryParamVariant(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    TUIBQuery(Qry).Params.ByNameAsVariant[Campo] := Prop.GetValue(Tabela).AsVariant;
  end;
end;

procedure TDaoUib.SetaCamposCurrency(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    Prop.SetValue(Tabela, TUIBQuery(Qry).Fields.ByNameAsCurrency[Campo]);
  end;
end;

procedure TDaoUib.SetaCamposDate(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    Prop.SetValue(Tabela, TUIBQuery(Qry).Fields.ByNameAsDateTime[Campo]);
  end;
end;

procedure TDaoUib.SetaCamposInteger(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    Prop.SetValue(Tabela, TUIBQuery(Qry).Fields.ByNameAsInteger[Campo]);
  end;
end;

procedure TDaoUib.SetaCamposString(ARecParams: TRecParams);
begin
  inherited;
  with ARecParams do
  begin
    Prop.SetValue(Tabela, TUIBQuery(Qry).Fields.ByNameAsString[Campo]);
  end;
end;

function TDaoUib.InTransaction: Boolean;
begin
  Result := FTransaction.InTransaction;
end;

procedure TDaoUib.StartTransaction;
begin
  FTransaction.StartTransaction;
end;

procedure TDaoUib.RollBack;
begin
  FTransaction.RollBack;
end;

procedure TDaoUib.Commit;
begin
  FTransaction.Commit;
end;

function TDaoUib.Conectado: Boolean;
begin
  Result := FDatabase.Connected;
end;

function TDaoUib.ConsultaSql(ASql: string): TDataSet;
var
  AQry: TUIBDataSet;
begin
  AQry := TUIBDataSet.Create(Application);
  with AQry do
  begin
    DataBase := FDatabase;
    Transaction := FTransaction;
    sql.Clear;
    sql.Add(ASql);
    Open;
  end;
  Result := AQry;
end;

procedure TDaoUib.Conecta;
var
  ASenha, AUsuario: string;
begin
  inherited;
  if Usuario=EmptyStr then
    AUsuario := 'SYSDBA'
  else
    AUsuario := Usuario;

  if Senha = EmptyStr then
    ASenha := '02025626'
  else
    ASenha := Senha;

  with FDatabase do
  begin
    DatabaseName := LocalBD;
    Params.Clear;
    Params.Add('user_name=' + AUsuario);
    Params.Add('password=' + ASenha);
    Connected := True;
  end;
end;

function TDaoUib.GetAutoIncremento(ATabela, ACampo: string): integer;
var
  AQry: TUIBQuery;
begin
  AQry := TUIBQuery.Create(Application);
  with AQry do
  begin
    DataBase := FDatabase;
    Transaction := FTransaction;
    sql.Clear;
    sql.Add('select max('+ACampo+') from ' + ATabela);
    Open;
    Result := Fields.AsInteger[0] + 1;
  end;
end;

function TDaoUib.ExecutaQuery: Integer;
begin
  with Qry do
  begin
    Prepare();
    ExecSQL;
    Result := RowsAffected;
  end;
end;

function TDaoUib.Excluir(ATabela: TTabela): Integer;
var
  Comando: TFuncReflexao;
begin
  //crio uma variável do tipo TFuncReflexao - um método anônimo
  Comando := function(ACampos: TCamposAnoni): Integer
  var
    Campo: string;
    PropRtti: TRttiProperty;
  begin
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Text := GerarSqlDelete(ATabela);

    //percorrer todos os campos da chave primária
    for Campo in PegaPks(ATabela) do
    begin
      // setando os parâmetros
      for PropRtti in ACampos.TipoRtti.GetProperties do
        if CompareText(PropRtti.Name, Campo) = 0 then
          begin
            ConfiguraParametro(PropRtti, Campo, ATabela, Qry);
          end;
    end;
    Result := ExecutaQuery;
  end;

  //reflection da tabela e execução da query preparada acima.
  Result := ReflexaoSQL(ATabela, Comando);
end;

function TDaoUib.Inserir(ATabela: TTabela): Integer;
var
  Comando: TFuncReflexao;
begin
  Result := 0;

  if not ValidaTabela(ATabela) then
    exit;

  Comando := function(ACampos: TCamposAnoni): Integer
  var
    Campo: string;
    PropRtti: TRttiProperty;
  begin
    with Qry do
    begin
      close;
      SQL.clear;
      SQL.Text := GerarSqlInsert(ATabela, ACampos.TipoRtti);

      //valor dos parâmetros
      for PropRtti in ACampos.TipoRtti.GetProperties do
      begin
        Campo := PropRtti.Name;
        ConfiguraParametro(PropRtti, Campo, ATabela, Qry);
      end;
    end;
    Result := ExecutaQuery;
  end;

  //reflection da tabela e execução da query preparada acima.
  Result := ReflexaoSQL(ATabela, Comando);
end;

function TDaoUib.Salvar(ATabela: TTabela): Integer;
var
  Comando: TFuncReflexao;
begin
  Result := 0;

  if not ValidaTabela(ATabela) then exit;
  Comando := function(ACampos: TCamposAnoni): Integer
  var
    Campo: string;
    PropRtti: TRttiProperty;
  begin
    with Qry do
    begin
      close;
      sql.Clear;
      sql.Text := GerarSqlUpdate(ATabela, Acampos.TipoRtti);

      //valor dos parâmetros
      for PropRtti in ACampos.TipoRtti.GetProperties do
      begin
        Campo := PropRtti.Name;
        ConfiguraParametro(PropRtti, Campo, ATabela, Qry);
      end;
    end;
    Result := ExecutaQuery;
  end;

  //reflection da tabela e execução da query preparada acima.
  Result := ReflexaoSQL(ATabela, Comando);
end;

function TDaoUib.Buscar(ATabela: TTabela): Integer;
var
  Comando: TFuncReflexao;
  Dados: TUIBQuery;
begin
  Dados := TUIBQuery.Create(nil);
  try
    //crio uma variável do tipo TFuncReflexao - um método anônimo
    Comando := function(ACampos: TCamposAnoni): Integer
    var
      Campo: string;
      PropRtti: TRttiProperty;
    begin
      with Dados do
      begin
        Database := FDatabase;
        Transaction := FTransaction;
        sql.Text := GerarSqlSelect(ATabela);

        for Campo in ACampos.PKs do
        begin
          // setando os parâmetros
          for PropRtti in ACampos.TipoRtti.GetProperties do
            if CompareText(PropRtti.Name, Campo) = 0 then
              begin
                ConfiguraParametro(PropRtti, Campo, ATabela, Dados);
              end;
        end;
        Open;
        Result := Fields.RecordCount;
        if Result > 0 then
        begin
          for PropRtti in ACampos.TipoRtti.GetProperties do
          begin
            Campo := PropRtti.Name;
            SetaDadosTabela(PropRtti, Campo, ATabela, Dados);
          end;
        end;
      end;
    end;

    //reflection da tabela e abertura da query preparada acima.
    Result := ReflexaoSQL(ATabela, Comando);
  finally
    Dados.Free;
  end;
end;

end.
