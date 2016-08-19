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

unit Lca.Orm.Comp.IBX;

interface

uses Db, Lca.Orm.Base, Rtti, Lca.Orm.Atributos, system.SysUtils, system.Classes,
  ibx.IB, ibx.IBQuery, ibx.IBDatabase, system.Generics.Collections;

type
  TQueryIBX = class(TInterfacedObject, IQueryParams)
  public
    // métodos responsáveis por setar os parâmetros
    procedure SetParamInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamVariant(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);

    // métodos para setar os variados tipos de campos
    procedure SetCamposInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetCamposString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetCamposDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetCamposCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
  end;

  TDaoIBX = class(TInterfacedObject, IDaoBase)
  private
    FConexao: TIBDatabase;
    FTransacao: TIBTransaction;

    FQuery: TIBQuery;
    FSql: IBaseSql;
    FDataSet: TDataSet;
    FParams: IQueryParams;

    Function DbToTabela<T: TTabela>(ATabela: TTabela; ADataSet: TDataSet)
      : TObjectList<T>;

    procedure SetDataSet(const Value: TDataSet);
  protected
    function ExecutaQuery: Integer;
  public
    constructor Create(Conexao: TIBDatabase; Transacao: TIBTransaction);
    destructor Destroy; override;

    function GerarClasse(ATabela, ANomeUnit, ANomeClasse: string): string;

    // dataset para as consultas
    function ConsultaAll(ATabela: TTabela): TDataSet;
    function ConsultaSql(ASql: string): TDataSet; overload;
    function ConsultaSql(ASql: string; const ParamList: Array of Variant): TDataSet; overload;
    function ConsultaSql(ATabela: string; AWhere: string): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACamposWhere: array of string): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere, AOrdem: array of string; TipoOrdem: Integer = 0): TDataSet; overload;
    function ConsultaGen<T: TTabela>(ATabela: TTabela; ACamposWhere: array of string): TObjectList<T>;

    // limpar campos da tabela
    procedure Limpar(ATabela: TTabela);

    // pega campo autoincremento
    function GetID(ATabela: TTabela; ACampo: string): Integer;
    function GetMax(ATabela: TTabela; ACampo: string;
      ACamposChave: array of string): Integer;

    // recordcount
    function GetRecordCount(ATabela: TTabela; ACamposWhere: array of string)
      : Integer; overload;
    function GetRecordCount(ATabela: string; AWhere: string): Integer; overload;

    // crud
    function Inserir(ATabela: TTabela): Integer; overload;
    function Inserir(ATabela: TTabela; ACampos: array of string;
      AFlag: TFlagCampos = fcIgnore): Integer; overload;

    function Salvar(ATabela: TTabela): Integer; overload;
    function Salvar(ATabela: TTabela; ACampos: array of string;
      AFlag: TFlagCampos = fcAdd): Integer; overload;

    function Excluir(ATabela: TTabela): Integer; overload;
    function Excluir(ATabela: TTabela; AWhere: array of string): Integer; overload;
    function Excluir(ATabela: string; AWhereValue: string): Integer; overload;
    function ExcluirTodos(ATabela: TTabela): Integer; overload;

    function Buscar(ATabela: TTabela): Integer;

    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function  InTransaction: Boolean;

    property DataSet: TDataSet read FDataSet write SetDataSet;
  end;

implementation

uses Vcl.forms, dialogs, system.TypInfo, System.Variants,
  Lca.Orm.GerarClasseIBX, Lca.Orm.GerarClasse.BancoFirebird;

{ TQueryIBX }

procedure TQueryIBX.SetParamCurrency(AProp: TRttiProperty; ACampo: string;
  ATabela: TTabela; AQry: TObject);
begin
  TIBQuery(AQry).ParamByName(ACampo).AsCurrency := AProp.GetValue(ATabela).AsCurrency;
end;

procedure TQueryIBX.SetParamDate(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TObject);
begin
  inherited;
  if AProp.GetValue(ATabela).AsType<TDateTime> = 0 then
    TIBQuery(AQry).ParamByName(ACampo).Clear
  else
    TIBQuery(AQry).ParamByName(ACampo).AsDateTime := AProp.GetValue(ATabela).AsType<TDateTime>;
end;

procedure TQueryIBX.SetParamInteger(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TObject);
begin
  TIBQuery(AQry).ParamByName(ACampo).AsInteger := AProp.GetValue(ATabela).AsInteger;
end;

procedure TQueryIBX.SetParamString(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TObject);
begin
  TIBQuery(AQry).ParamByName(ACampo).AsString := AProp.GetValue(ATabela).AsString;
end;

procedure TQueryIBX.SetParamVariant(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TObject);
begin
  TIBQuery(AQry).ParamByName(ACampo).Value := AProp.GetValue(ATabela).AsVariant;
end;

procedure TQueryIBX.SetCamposCurrency(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TObject);
begin
  AProp.SetValue(ATabela, TIBQuery(AQry).FieldByName(ACampo).AsCurrency);
end;

procedure TQueryIBX.SetCamposDate(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TObject);
begin
  AProp.SetValue(ATabela, TIBQuery(AQry).FieldByName(ACampo).AsDateTime);
end;

procedure TQueryIBX.SetCamposInteger(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TObject);
begin
  AProp.SetValue(ATabela, TIBQuery(AQry).FieldByName(ACampo).AsInteger);
end;

procedure TQueryIBX.SetCamposString(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TObject);
begin
  AProp.SetValue(ATabela, TIBQuery(AQry).FieldByName(ACampo).AsString);
end;

{ TDaoIBX }

constructor TDaoIBX.Create(Conexao: TIBDatabase;
  Transacao: TIBTransaction);
begin
  inherited Create;
  FSql := TPadraoSql.create;
  FParams := TQueryIBX.create;
  FConexao := Conexao;
  FTransacao := Transacao;

  FQuery := TIBQuery.Create(Application);
  FQuery.Database := FConexao;
end;

destructor TDaoIBX.Destroy;
begin
  inherited;
end;

function TDaoIbx.GerarClasse(ATabela, ANomeUnit, ANomeClasse: string): string;
var
  NovaClasse: TGerarClasseIBX;
begin
  NovaClasse := TGerarClasseIBX.Create(TGerarClasseBancoFirebird.Create, Self);
  try
    Result := NovaClasse.Gerar(ATabela, ANomeUnit, ANomeClasse);
  finally
    NovaClasse.Free;
  end;
end;

procedure TDaoIBX.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

procedure TDaoIBX.StartTransaction;
begin
  FTransacao.StartTransaction;
end;

procedure TDaoIBX.Commit;
begin
  FTransacao.Commit;
end;

procedure TDaoIBX.RollBack;
begin
  FTransacao.RollBack;
end;

function TDaoIBX.InTransaction: Boolean;
begin
  Result := FTransacao.InTransaction;
end;

procedure TDaoIBX.Limpar(ATabela: TTabela);
begin
  TAtributos.Get.LimparCampos(ATabela);
end;

function TDaoIBX.DbToTabela<T>(ATabela: TTabela; ADataSet: TDataSet)
  : TObjectList<T>;
var
  AuxValue: TValue;
  TipoRtti: TRttiType;
  Contexto: TRttiContext;
  PropRtti: TRttiProperty;
  DataType: TFieldType;
  Campo: String;
begin
  Result := TObjectList<T>.Create;

  while not ADataSet.Eof do
  begin
    AuxValue := GetTypeData(PTypeInfo(TypeInfo(T)))^.ClassType.Create;
    TipoRtti := Contexto.GetType(AuxValue.AsObject.ClassInfo);
    for PropRtti in TipoRtti.GetProperties do
    begin
      Campo := PropRtti.Name;
      DataType := ADataSet.FieldByName(Campo).DataType;

      case DataType of
        ftInteger:
          begin
            PropRtti.SetValue(AuxValue.AsObject,
              TValue.FromVariant(ADataSet.FieldByName(Campo).AsInteger));
          end;
        ftString, ftWideString, ftWideMemo:
          begin
            PropRtti.SetValue(AuxValue.AsObject,
              TValue.FromVariant(ADataSet.FieldByName(Campo).AsString));
          end;
        ftBCD, ftFloat:
          begin
            PropRtti.SetValue(AuxValue.AsObject,
              TValue.FromVariant(ADataSet.FieldByName(Campo).AsFloat));
          end;
        ftDate, ftDateTime:
          begin
            PropRtti.SetValue(AuxValue.AsObject,
              TValue.FromVariant(ADataSet.FieldByName(Campo).AsDateTime));
          end;
      else
        raise Exception.Create('Tipo de campo não conhecido: ' +
          PropRtti.PropertyType.ToString);
      end;
    end;
    Result.Add(AuxValue.AsType<T>);

    ADataSet.Next;
  end;
end;

function TDaoIBX.ConsultaGen<T>(ATabela: TTabela; ACamposWhere: array of string)
  : TObjectList<T>;
var
  Dados: TIBQuery;
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Dados := TIBQuery.Create(Application);
  try
    Contexto := TRttiContext.Create;
    try
      TipoRtti := Contexto.GetType(ATabela.ClassType);
      with Dados do
      begin
        Database := FConexao;
        sql.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);

        for Campo in ACamposWhere do
        begin
          if not TAtributos.Get.PropExiste(Campo, PropRtti, TipoRtti) then
            raise Exception.Create('Campo ' + Campo + ' não existe no objeto!');

          // setando os parâmetros
          for PropRtti in TipoRtti.GetProperties do
          begin
            if CompareText(PropRtti.Name, Campo) = 0 then
              TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
          end;
        end;

        Open;

        Result := DbToTabela<T>(ATabela, Dados);
      end;
    finally
      Contexto.Free;
    end;
  finally
    Dados.Free;
  end;
end;

function TDaoIBX.ConsultaAll(ATabela: TTabela): TDataSet;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(Application);
  with AQry do
  begin
    Database := FConexao;
    sql.Clear;
    sql.Add('Select * from ' + TAtributos.Get.PegaNomeTab(ATabela));
    Open;
  end;
  Result := AQry;
end;

function TDaoIBX.ConsultaSql(ASql: string): TDataSet;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(Application);
  with AQry do
  begin
    Database := FConexao;
    sql.Clear;
    sql.Add(ASql);
    Open;
  end;
  Result := AQry;
end;

function TDaoIBX.ConsultaSql(ASql: string; const ParamList: array of Variant): TDataSet;
var
  AQry: TIBQuery;
  i: integer;
begin
  AQry := TIBQuery.Create(Application);
  with AQry do
  begin
    Database := FConexao;
    sql.Clear;
    sql.Add(ASql);

    if (Length(ParamList) > 0) and (Params.Count > 0) then
     for i := 0 to Params.Count -1 do
       if (i < Length(ParamList)) then
         if VarIsType(ParamList[i], varDate) then
           Params[i].AsDateTime := VarToDateTime(ParamList[i])
         else
           Params[i].Value := ParamList[i];
    Open;
  end;
  Result := AQry;
end;

function TDaoIBX.ConsultaSql(ATabela, AWhere: string): TDataSet;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(Application);
  with AQry do
  begin
    Database := FConexao;
    sql.Clear;
    sql.Add('select * from ' + ATabela);
    if AWhere <> '' then
      sql.Add('where ' + AWhere);
    Open;
  end;
  Result := AQry;
end;

function TDaoIBX.ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere,
  AOrdem: array of string; TipoOrdem: Integer): TDataSet;
var
  Dados: TIBQuery;
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Separador: string;
begin
  Dados := TIBQuery.Create(Application);
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);

    with Dados do
    begin
      Database := FConexao;
      sql.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);

      if Length(AOrdem)>0 then
      begin
        Separador := '';
        SQL.Add('order by');
        for Campo in AOrdem do
        begin
          if TipoOrdem = 1 then
            sql.Add(Separador + Campo + ' Desc')
          else
            sql.Add(Separador + Campo);
          Separador := ',';
        end;
      end;

      if Length(ACamposWhere)>0 then
      begin
        for Campo in ACamposWhere do
        begin
          // setando os parâmetros
          for PropRtti in TipoRtti.GetProperties do
            if CompareText(PropRtti.Name, Campo) = 0 then
              TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
        end;
      end;
      Open;
      Result := Dados;
    end;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string): TDataSet;
var
  Dados: TIBQuery;
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Dados := TIBQuery.Create(Application);
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);

    with Dados do
    begin
      Database := FConexao;
      sql.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);

      if Length(ACamposWhere)>0 then
      begin
        for Campo in ACamposWhere do
        begin
          // setando os parâmetros
          for PropRtti in TipoRtti.GetProperties do
            if CompareText(PropRtti.Name, Campo) = 0 then
              TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
        end;
      end;

      Open;

      Result := Dados;
    end;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.ConsultaTab(ATabela: TTabela;
  ACamposWhere: array of string): TDataSet;
var
  Dados: TIBQuery;
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Dados := TIBQuery.Create(Application);
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);

    with Dados do
    begin
      Database := FConexao;
      sql.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);

      if Length(ACamposWhere)>0 then
      begin
        for Campo in ACamposWhere do
        begin
          // setando os parâmetros
          for PropRtti in TipoRtti.GetProperties do
            if CompareText(PropRtti.Name, Campo) = 0 then
            begin
              TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
              Break;
            end;
        end;
      end;

      Open;

      Result := Dados;
    end;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.GetID(ATabela: TTabela; ACampo: string): Integer;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(Application);
  with AQry do
  begin
    Database := FConexao;
    sql.Clear;
    sql.Add('select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela));
    Open;
    Result := fields[0].AsInteger + 1;
  end;
end;

function TDaoIBX.GetMax(ATabela: TTabela; ACampo: string;
  ACamposChave: array of string): Integer;
var
  AQry: TIBQuery;
  Campo: string;
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Separador: string;
  NumMax: Integer;
begin
  AQry := TIBQuery.Create(Application);
  try
    with AQry do
    begin
      Database := FConexao;
      sql.Clear;
      sql.Add('select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela));
      sql.Add('Where');
      Separador := '';
      for Campo in ACamposChave do
      begin
        sql.Add(Separador + Campo + '= :' + Campo);
        Separador := ' and ';
      end;

      Contexto := TRttiContext.Create;
      try
        TipoRtti := Contexto.GetType(ATabela.ClassType);

        for Campo in ACamposChave do
        begin
          // setando os parâmetros
          for PropRtti in TipoRtti.GetProperties do
            if CompareText(PropRtti.Name, Campo) = 0 then
              TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, AQry, FParams);
        end;

        Open;

        NumMax := Fields[0].AsInteger;

        Result := NumMax;
      finally
        Contexto.Free;
      end;
    end;
  finally
    AQry.Free;
  end;
end;

function TDaoIBX.GetRecordCount(ATabela, AWhere: string): Integer;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(nil);
  try
    with AQry do
    begin
      Database := FConexao;
      sql.Clear;
      sql.Add('select count(*) from ' + ATabela);
      if AWhere <> '' then
        sql.Add('where ' + AWhere);
      Open;
    end;

    Result := AQry.Fields[0].AsInteger;
  finally
    AQry.Free;
  end;
end;

function TDaoIBX.GetRecordCount(ATabela: TTabela;
  ACamposWhere: array of string): Integer;
var
  AQry: TIBQuery;
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  AQry := TIBQuery.Create(nil);
  try
    with AQry do
    begin
      Contexto := TRttiContext.Create;
      try
        TipoRtti := Contexto.GetType(ATabela.ClassType);
        Database := FConexao;

        sql.Clear;

        sql.Add('select count(*) from ' + TAtributos.Get.PegaNomeTab(ATabela));

        if High(ACamposWhere) >= 0 then
          sql.Add('where 1=1');

        for Campo in ACamposWhere do
          sql.Add('and ' + Campo + '=:' + Campo);

        for Campo in ACamposWhere do
        begin
          for PropRtti in TipoRtti.GetProperties do
            if CompareText(PropRtti.Name, Campo) = 0 then
              TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, AQry, FParams);
        end;

        Open;

        Result := fields[0].AsInteger;
      finally
        Contexto.Free;
      end;
    end;
  finally
    AQry.Free;
  end;
end;

function TDaoIBX.ExecutaQuery: Integer;
begin
  with FQuery do
  begin
    Prepare();
    ExecSQL;
    Result := RowsAffected;
  end;
end;

function TDaoIBX.Excluir(ATabela: TTabela): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
begin
  FQuery.close;
  FQuery.sql.Clear;
  FQuery.sql.Text := FSql.GerarSqlDelete(ATabela);

  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);

  // percorrer todos os campos da chave primária
  for Campo in TAtributos.Get.PegaPks(ATabela) do
  begin
    // setando os parâmetros
    for PropRtti in RttiType.GetProperties do
      if CompareText(PropRtti.Name, Campo) = 0 then
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, FQuery, FParams);
  end;

  Result := ExecutaQuery;
end;

function TDaoIBX.Excluir(ATabela: TTabela; AWhere: array of string): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  Sep: string;
begin
  if Length(AWhere) = 0 then
    raise Exception.Create('Campos AWhere não selecionados!');

  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);

  FQuery.close;
  FQuery.sql.Clear;
  FQuery.sql.Add('Delete from ' + TAtributos.Get.PegaNomeTab(ATabela));
  FQuery.SQL.Add('Where');

  Sep := '';

  for Campo in AWhere do
  begin
    FQuery.SQL.Add(Sep + Campo + '= :' + Campo);
    Sep := ' and ';
  end;

  // percorrer todos os campos da chave primária
  for Campo in AWhere do
  begin
    // setando os parâmetros
    for PropRtti in RttiType.GetProperties do
      if CompareText(PropRtti.Name, Campo) = 0 then
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, FQuery, FParams);
  end;

  Result := ExecutaQuery;
end;

function TDaoIBX.Excluir(ATabela: string; AWhereValue: string): Integer;
begin
  if Trim(AWhereValue) = '' then
    raise Exception.Create('Campo/Valor para a exclusão não informado');

  FQuery.close;
  FQuery.sql.Clear;
  FQuery.sql.Add('Delete from ' + ATabela);
  FQuery.SQL.Add('Where ' + AwhereValue);

  Result := ExecutaQuery;
end;

function TDaoIBX.ExcluirTodos(ATabela: TTabela): Integer;
begin
  FQuery.close;
  FQuery.sql.Clear;
  FQuery.sql.Text := 'Delete from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Result := ExecutaQuery;
end;

function TDaoIBX.Inserir(ATabela: TTabela): Integer;
begin
  Result := Self.Inserir(ATabela, []);
end;

function TDaoIBX.Inserir(ATabela: TTabela; ACampos: array of string;
  AFlag: TFlagCampos): Integer;
var
  Atributos: IAtributos;
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
begin
  Atributos := TAtributos.Create;
  try
    Atributos.ValidaTabela(ATabela, ACampos, AFlag);
    RttiType := TRttiContext.Create.GetType(ATabela.ClassType);

    with FQuery do
    begin
      close;
      sql.Clear;
      sql.Text := FSql.GerarSqlInsert(ATabela, RttiType, ACampos, AFlag);
      // valor dos parâmetros
      for PropRtti in RttiType.GetProperties do
      begin
        if (Length(ACampos) > 0) then
          if not (Atributos.LocalizaCampo(PropRtti.Name, Atributos.PegaPks(ATabela))) then
          begin
            if ((AFlag=fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
              ((AFlag=fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
              Continue;
          end;

        Campo := PropRtti.Name;
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, FQuery, FParams);
      end;
    end;
    Result := ExecutaQuery;
  except
    raise;
  end;
end;

function TDaoIBX.Salvar(ATabela: TTabela): Integer;
begin
  Result := Self.Salvar(ATabela, []);
end;

function TDaoIBX.Salvar(ATabela: TTabela; ACampos: array of string;
  AFlag: TFlagCampos): Integer;
var
  Atributos: IAtributos;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
begin
  Atributos := TAtributos.Create;
  try
    Atributos.ValidaTabela(ATabela, ACampos, AFlag);
    RttiType := TRttiContext.Create.GetType(ATabela.ClassType);

    with FQuery do
    begin
      close;
      sql.Clear;
      sql.Text := FSql.GerarSqlUpdate(ATabela, RttiType, ACampos, AFlag);
      // valor dos parâmetros
      for PropRtti in RttiType.GetProperties do
      begin
        if (Length(ACampos) > 0) and not (Atributos.LocalizaCampo(
          PropRtti.Name, Atributos.PegaPks(ATabela))) then
        begin
          if ((AFlag=fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
            ((AFlag=fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
            Continue;
        end;
        TAtributos.Get.ConfiguraParametro(PropRtti, PropRtti.Name, ATabela, FQuery, FParams);
      end;
    end;
    Result := ExecutaQuery;
  except
    raise;
  end;
end;

function TDaoIBX.Buscar(ATabela: TTabela): Integer;
var
  Dados: TIBQuery;
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
begin
  Dados := TIBQuery.Create(nil);
  try
    RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
    with Dados do
    begin
      Database := FConexao;
      sql.Text := FSql.GerarSqlSelect(ATabela);

      for Campo in TAtributos.Get.PegaPks(ATabela) do
      begin
        // setando os parâmetros
        for PropRtti in RttiType.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
          begin
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
          end;
      end;
      Open;
      Result := RecordCount;
      if Result > 0 then
      begin
        for PropRtti in RttiType.GetProperties do
        begin
          Campo := PropRtti.Name;
          TAtributos.Get.SetarDadosTabela(PropRtti, Campo, ATabela, Dados, FParams);
        end;
      end;
    end;
  finally
    Dados.Free;
  end;
end;

end.
