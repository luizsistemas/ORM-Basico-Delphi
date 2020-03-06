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

uses Db, Lca.Orm.Base, Rtti, Lca.Orm.Atributos, System.SysUtils, System.Classes,
  IBX.IB, IBX.IBQuery, IBX.IBDatabase, System.Generics.Collections;

type
  TParamsIBX = class(TInterfacedObject, IQueryParams)
  public
    procedure SetParamInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamVariant(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);

    procedure SetCamposInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetCamposString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetCamposDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetCamposCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
  end;

  TQueryIBX = class(TInterfacedObject, IQuery)
  private
    FQuery: TIBQuery;
    FSql: TStrings;
    procedure Abrir;
    function RecordCount: Integer;
  public
    constructor Create(Conexao: TIBDatabase; Transacao: TIBTransaction);
    destructor Destroy; override;
    function Sql: TStrings;
    function Dataset: TDataset;
    function RowsAffected: Integer;
    procedure Executar;
  end;

  TDaoIBX = class(TDaoBase, IDaoBaseComandos)
  private
    FConexao: TIBDatabase;
    FTransacao: TIBTransaction;
  protected
    procedure AtualizarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
      Relacionamento: TCustomAttribute; AQuery: TDataSet); override;

    procedure BuscarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
      Relacionamento: TCustomAttribute; AQuery: TDataSet); override;
  public
    constructor Create(Conexao: TIBDatabase; Transacao: TIBTransaction);
    function GerarClasse(ATabela, ANomeUnit, ANomeClasse: string): string;
    function ConsultaAll(ATabela: TTabela; AOwner: TComponent = nil): TDataSet;
    function ConsultaSql(ASql: string; AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaSql(ASql: string; const ParamList: Array of Variant;
      AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaSql(ATabela: string; AWhere: string;
      AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACamposWhere: array of string;
      AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string;
      AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere,
      AOrdem: array of string; TipoOrdem: Integer = 0; AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaGen<T: TTabela>(ATabela: TTabela; ACamposWhere: array of string): TObjectList<T>;
    function GetID(ATabela: TTabela; ACampo: string): Integer; overload;
    function GetID(Generator: string): Integer; overload;
    function GetMax(ATabela: TTabela; ACampo: string;
      ACamposChave: array of string): Integer;
    function GetRecordCount(ATabela: TTabela;
      ACamposWhere: array of string): Integer; overload;
    function GetRecordCount(ATabela: string; AWhere: string): Integer; overload;
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
    procedure ExecSQL(ASQL: string; const ParamList: Array of Variant);
    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function  InTransaction: Boolean;
  end;

implementation

uses Dialogs, System.TypInfo, System.Variants,
  Lca.Orm.GerarClasseIBX, Lca.Orm.GerarClasse.BancoFirebird;

{ TParamsIBX }

procedure TParamsIBX.SetParamCurrency(AProp: TRttiProperty; ACampo: string;
  ATabela: TTabela; AQry: TDataSet);
begin
  TIBQuery(AQry).ParamByName(ACampo).AsCurrency := AProp.GetValue(ATabela).AsCurrency;
end;

procedure TParamsIBX.SetParamDate(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  inherited;
  if AProp.GetValue(ATabela).AsType<TDateTime> = 0 then
    TIBQuery(AQry).ParamByName(ACampo).Clear
  else
    TIBQuery(AQry).ParamByName(ACampo).AsDateTime := AProp.GetValue(ATabela).AsType<TDateTime>;
end;

procedure TParamsIBX.SetParamInteger(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TIBQuery(AQry).ParamByName(ACampo).AsInteger := AProp.GetValue(ATabela).AsInteger;
end;

procedure TParamsIBX.SetParamString(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TIBQuery(AQry).ParamByName(ACampo).AsString := AProp.GetValue(ATabela).AsString;
end;

procedure TParamsIBX.SetParamVariant(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TIBQuery(AQry).ParamByName(ACampo).Value := AProp.GetValue(ATabela).AsVariant;
end;

procedure TParamsIBX.SetCamposCurrency(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TIBQuery(AQry).FieldByName(ACampo).AsCurrency);
end;

procedure TParamsIBX.SetCamposDate(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TIBQuery(AQry).FieldByName(ACampo).AsDateTime);
end;

procedure TParamsIBX.SetCamposInteger(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TIBQuery(AQry).FieldByName(ACampo).AsInteger);
end;

procedure TParamsIBX.SetCamposString(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TIBQuery(AQry).FieldByName(ACampo).AsString);
end;

{ TDaoIBX }

constructor TDaoIBX.Create(Conexao: TIBDatabase; Transacao: TIBTransaction);
begin
  inherited Create;
  FParams := TParamsIBX.Create;
  FConexao := Conexao;
  FTransacao := Transacao;
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

procedure TDaoIBX.BuscarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
  Relacionamento: TCustomAttribute; AQuery: TDataSet);
var
  Contexto: TRttiContext;
  Objeto: TTabela;
  RttiType: TRttiType;
  Prop: TRttiProperty;
  KeyLocalized: Boolean;
begin
  KeyLocalized := False;
  if (APropRtti.GetValue(ATabela).AsObject is TTabela) then
  begin
    Contexto := TRttiContext.Create;
    try
      Objeto := (APropRtti.GetValue(ATabela).AsObject as TTabela);
      RttiType := Contexto.GetType(Objeto.ClassType);
      for Prop in RttiType.GetProperties do
      begin
        if CompareText(Prop.Name, AttFk(Relacionamento).Pk) = 0 then
        begin
          TAtributos.Get.SetarDadosTabela(Prop, AttFk(Relacionamento).CampoFk, Objeto, AQuery, FParams);
          KeyLocalized := True;
          Break;
        end;
      end;
      if KeyLocalized then
        Buscar(Objeto);
    finally
      Contexto.Free;
    end;
  end;
end;

function TDaoIBX.ConsultaGen<T>(ATabela: TTabela; ACamposWhere: array of string): TObjectList<T>;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Query: IQuery;
  Objeto: TValue;
  AtribFk: AttFk;
begin
  Contexto := TRttiContext.Create;
  try
    Result := TObjectList<T>.Create;
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Query := TQueryIBX.Create(FConexao, FConexao.DefaultTransaction);
    Query.SQL.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);
    for Campo in ACamposWhere do
    begin
      if not TAtributos.Get.PropExiste(Campo, PropRtti, TipoRtti) then
        raise Exception.Create('Campo ' + Campo + ' não existe no objeto!');
      for PropRtti in TipoRtti.GetProperties do
      begin
        if CompareText(PropRtti.Name, Campo) = 0 then
        begin
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.Dataset, FParams);
          Break;
        end;
      end;
    end;
    Query.Abrir;
    while not Query.Dataset.Eof do
    begin
      Objeto := TObjectFactory<T>.Get.CriarInstancia;
      TipoRtti := Contexto.GetType(ATabela.ClassType);
      for PropRtti in TipoRtti.GetProperties do
      begin
        AtribFk := TAtributos.Get.GetAtribFk(PropRtti);
        if Assigned(AtribFk) then
          BuscarRelacionamento(Objeto.AsType<T>, PropRtti, AtribFk, Query.Dataset)
        else
          SetarDadosFromDataset(Query.Dataset, PropRtti, Objeto.AsType<T>, PropRtti.Name);
      end;
      Result.Add(Objeto.AsType<T>);
      Query.Dataset.Next;
    end;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.ConsultaAll(ATabela: TTabela; AOwner: TComponent): TDataSet;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(GetOwner(AOwner));
  Query.Database := FConexao;
  Query.Sql.Text := 'Select * from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Query.Open;
  Result := Query;
end;

function TDaoIBX.ConsultaSql(ASql: string; AOwner: TComponent): TDataSet;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(GetOwner(AOwner));
  Query.Database := FConexao;
  Query.Sql.Text := ASql;
  Query.Open;
  Result := Query;
end;

function TDaoIBX.ConsultaSql(ASql: string; const ParamList: array of Variant;
  AOwner: TComponent): TDataSet;
var
  I: Integer;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(GetOwner(AOwner));
  Query.Database := FConexao;
  Query.Sql.Text := ASql;
  if (Length(ParamList) > 0) and (TIBQuery(Query).Params.Count > 0) then
   for I := 0 to TIBQuery(Query).Params.Count -1 do
     if (I < Length(ParamList)) then
       if VarIsType(ParamList[I], varDate) then
         TIBQuery(Query).Params[I].AsDateTime := VarToDateTime(ParamList[I])
       else
         TIBQuery(Query).Params[I].Value := ParamList[I];
  Query.Open;
  Result := Query;
end;

function TDaoIBX.ConsultaSql(ATabela, AWhere: string; AOwner: TComponent): TDataSet;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(GetOwner(AOwner));
  Query.Database := FConexao;
  Query.Sql.Text := 'select * from ' + ATabela;
  if AWhere <> '' then
    Query.Sql.Add('where ' + AWhere);
  Query.Open;
  Result := Query;
end;

function TDaoIBX.ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere,
  AOrdem: array of string; TipoOrdem: Integer; AOwner: TComponent): TDataSet;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Separador: string;
  Query: TIBQuery;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Query := TIBQuery.Create(GetOwner(AOwner));
    Query.Database := FConexao;
    Query.Sql.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);
    if Length(AOrdem)>0 then
    begin
      Separador := '';
      Query.Sql.Add('order by');
      for Campo in AOrdem do
      begin
        if TipoOrdem = 1 then
          Query.Sql.Add(Separador + Campo + ' Desc')
        else
          Query.Sql.Add(Separador + Campo);
        Separador := ',';
      end;
    end;
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query, FParams);
      end;
    end;
    Query.Open;
    Result := Query;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string;
  AOwner: TComponent): TDataSet;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Query: TIBQuery;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Query := TIBQuery.Create(GetOwner(AOwner));
    Query.Database := FConexao;
    Query.Sql.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query, FParams);
      end;
    end;
    Query.Open;
    Result := Query;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.ConsultaTab(ATabela: TTabela;
  ACamposWhere: array of string; AOwner: TComponent): TDataSet;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Query: TIBQuery;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Query := TIBQuery.Create(GetOwner(AOwner));
    Query.Database := FConexao;
    Query.Sql.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
          begin
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query, FParams);
            Break;
          end;
      end;
    end;
    Query.Open;
    Result := Query;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.GetID(ATabela: TTabela; ACampo: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryIBX.Create(FConexao, FConexao.DefaultTransaction);
  Query.Sql.Text := 'select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Query.Abrir;
  Result := Query.Dataset.Fields[0].AsInteger + 1;
end;

function TDaoIBX.GetID(Generator: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryIBX.Create(FConexao, FConexao.DefaultTransaction);
  Query.Sql.Text := 'SELECT * FROM SP_GERADOR(' + quotedstr(Generator) + ')';
  Query.Abrir;
  Result := Query.Dataset.Fields[0].AsInteger;
end;

function TDaoIBX.GetMax(ATabela: TTabela; ACampo: string;
  ACamposChave: array of string): Integer;
var
  Campo: string;
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Separador: string;
  Query: IQuery;
begin
  Query := TQueryIBX.Create(FConexao, FConexao.DefaultTransaction);
  Query.Sql.Text := 'select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Query.Sql.Add('Where');
  Separador := '';
  for Campo in ACamposChave do
  begin
    Query.Sql.Add(Separador + Campo + '= :' + Campo);
    Separador := ' and ';
  end;
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    for Campo in ACamposChave do
    begin
      for PropRtti in TipoRtti.GetProperties do
        if CompareText(PropRtti.Name, Campo) = 0 then
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.Dataset, FParams);
    end;
    Query.Abrir;
    Result := Query.Dataset.Fields[0].AsInteger;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.GetRecordCount(ATabela, AWhere: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryIBX.Create(FConexao, FConexao.DefaultTransaction);
  Query.Sql.Text := 'select count(*) from ' + ATabela;
  if AWhere <> '' then
    Query.Sql.Add('where ' + AWhere);
  Query.Abrir;
  Result := Query.Dataset.Fields[0].AsInteger;
end;

function TDaoIBX.GetRecordCount(ATabela: TTabela;
  ACamposWhere: array of string): Integer;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Query: IQuery;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Query := TQueryIBX.Create(FConexao, FConexao.DefaultTransaction);
    Query.Sql.Text := 'select count(*) from ' + TAtributos.Get.PegaNomeTab(ATabela);
    if High(ACamposWhere) >= 0 then
      Query.Sql.Add('where 1=1');
    for Campo in ACamposWhere do
      Query.Sql.Add('and ' + Campo + '=:' + Campo);
    for Campo in ACamposWhere do
    begin
      for PropRtti in TipoRtti.GetProperties do
        if CompareText(PropRtti.Name, Campo) = 0 then
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.Dataset, FParams);
    end;
    Query.Abrir;
    Result := Query.Dataset.Fields[0].AsInteger;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.Excluir(ATabela: TTabela): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  Comando: IQuery;
begin
  Comando := TQueryIBX.Create(FConexao, FTransacao);
  Comando.Sql.Text := FSql.GerarSqlDelete(ATabela);
  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
  for Campo in TAtributos.Get.PegaPks(ATabela) do
  begin
    for PropRtti in RttiType.GetProperties do
      if CompareText(PropRtti.Name, Campo) = 0 then
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Comando.Dataset, FParams);
  end;
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

function TDaoIBX.Excluir(ATabela: TTabela; AWhere: array of string): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  Sep: string;
  Comando: IQuery;
begin
  if Length(AWhere) = 0 then
    raise Exception.Create('Campos AWhere não selecionados!');
  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
  Comando := TQueryIBX.Create(FConexao, FTransacao);
  Comando.Sql.Add('Delete from ' + TAtributos.Get.PegaNomeTab(ATabela));
  Comando.Sql.Add('Where');
  Sep := '';
  for Campo in AWhere do
  begin
    Comando.Sql.Add(Sep + Campo + '= :' + Campo);
    Sep := ' and ';
  end;
  for Campo in AWhere do
  begin
    for PropRtti in RttiType.GetProperties do
      if CompareText(PropRtti.Name, Campo) = 0 then
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Comando.Dataset, FParams);
  end;
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

function TDaoIBX.Excluir(ATabela: string; AWhereValue: string): Integer;
var
  Comando: IQuery;
begin
  if Trim(AWhereValue) = '' then
    raise Exception.Create('Campo/Valor para a exclusão não informado');
  Comando := TQueryIBX.Create(FConexao, FTransacao);
  Comando.Sql.Clear;
  Comando.Sql.Add('Delete from ' + ATabela);
  Comando.Sql.Add('Where ' + AwhereValue);
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

function TDaoIBX.ExcluirTodos(ATabela: TTabela): Integer;
var
  Comando: IQuery;
begin
  Comando := TQueryIBX.Create(FConexao, FTransacao);
  Comando.Sql.Clear;
  Comando.Sql.Text := 'Delete from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

procedure TDaoIBX.ExecSQL(ASQL: string; const ParamList: array of Variant);
var
  Comando: IQuery;
  procedure ConfigParams;
  var
    I: Integer;
  begin
    if Length(ParamList)>0 then
    begin
      for I := 0 to Length(ParamList) - 1 do
        if VarIsType(ParamList[I], varDate) then
          TIBQuery(Comando.Dataset).Params[I].AsDateTime := VarToDateTime(ParamList[I])
        else
          TIBQuery(Comando.Dataset).Params[I].Value := ParamList[I];
    end;
  end;
begin
  Comando.Sql.Text := ASql;
  ConfigParams;
  Comando.Executar;
end;

function TDaoIBX.Inserir(ATabela: TTabela): Integer;
begin
  Result := Self.Inserir(ATabela, []);
end;

function TDaoIBX.Inserir(ATabela: TTabela; ACampos: array of string;
  AFlag: TFlagCampos): Integer;
var
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  AtribFk: AttFk;
  NomeTabela: string;
  Comando: IQuery;
begin
  try
    TAtributos.Get.ValidaTabela(ATabela, ACampos, AFlag);
    RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
    NomeTabela := TAtributos.Get.PegaNomeTab(ATabela);
    Comando := TQueryIBX.Create(FConexao, FTransacao);
    Comando.Sql.Text := FSql.GerarSqlInsert(NomeTabela, RttiType, ACampos, AFlag);
    for PropRtti in RttiType.GetProperties do
    begin
      if (Length(ACampos) > 0) then
      begin
        if not (TAtributos.Get.LocalizaCampo(PropRtti.Name, TAtributos.Get.PegaPks(ATabela))) then
        begin
          if ((AFlag = fcIgnore) and (TAtributos.Get.LocalizaCampo(PropRtti.Name, ACampos))) or
             ((AFlag = fcAdd) and (not TAtributos.Get.LocalizaCampo(PropRtti.Name, ACampos))) then
            Continue;
        end;
      end;
      AtribFk := TAtributos.Get.GetAtribFk(PropRtti);
      if Assigned(AtribFk) then
        AtualizarRelacionamento(ATabela, PropRtti, AtribFk, Comando.Dataset)
      else
        TAtributos.Get.ConfiguraParametro(PropRtti, PropRtti.Name, ATabela, Comando.Dataset, FParams);
    end;
    Comando.Executar;
    Result := Comando.RowsAffected;
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
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  Comando: IQuery;
  AtribFk: AttFk;
begin
  try
    TAtributos.Get.ValidaTabela(ATabela, ACampos, AFlag);
    RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
    Comando := TQueryIBX.Create(FConexao, FTransacao);
    Comando.Sql.Text := FSql.GerarSqlUpdate(ATabela, RttiType, ACampos, AFlag);
    for PropRtti in RttiType.GetProperties do
    begin
      if (Length(ACampos) > 0) and not (TAtributos.Get.LocalizaCampo(PropRtti.Name, TAtributos.Get.PegaPks(ATabela))) then
      begin
        if ((AFlag = fcAdd) and (not TAtributos.Get.LocalizaCampo(PropRtti.Name, ACampos))) or ((AFlag = fcIgnore) and (TAtributos.Get.LocalizaCampo(PropRtti.Name, ACampos))) then
          Continue;
      end;
      AtribFk := TAtributos.Get.GetAtribFk(PropRtti);
      if Assigned(AtribFk) then
        AtualizarRelacionamento(ATabela, PropRtti, AtribFk, Comando.Dataset)
      else
        TAtributos.Get.ConfiguraParametro(PropRtti, PropRtti.Name, ATabela, Comando.Dataset, FParams);
    end;
    Comando.Executar;
    Result := Comando.RowsAffected;
  except
    raise;
  end;
end;

procedure TDaoIBX.AtualizarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
  Relacionamento: TCustomAttribute; AQuery: TDataSet);
var
  Objeto: TTabela;
  RttiType: TRttiType;
  Prop: TRttiProperty;
begin
  if (APropRtti.GetValue(ATabela).AsObject is TTabela) then
  begin
    Objeto := (APropRtti.GetValue(ATabela).AsObject as TTabela);
    RttiType := TRttiContext.Create.GetType(Objeto.ClassType);
    for Prop in RttiType.GetProperties do
    begin
      if CompareText(Prop.Name, AttFK(Relacionamento).Pk) = 0 then
      begin
        TAtributos.Get.ConfiguraParametro(Prop, AttFK(Relacionamento).CampoFk, Objeto, AQuery, FParams);
        Break;
      end;
    end;
    if GetRecordCount(Objeto, [AttFk(Relacionamento).Pk]) = 0 then
      Inserir(Objeto)
    else
      Salvar(Objeto);
  end;
end;

function TDaoIBX.Buscar(ATabela: TTabela): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  AtribFk: AttFk;
  Query: IQuery;
begin
  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
  Query := TQueryIBX.Create(FConexao, FConexao.DefaultTransaction);
  Query.Sql.Text := FSql.GerarSqlSelect(ATabela);
  for Campo in TAtributos.Get.PegaPks(ATabela) do
  begin
    for PropRtti in RttiType.GetProperties do
    begin
      if CompareText(PropRtti.Name, Campo) = 0 then
      begin
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.Dataset, FParams);
        Break;
      end;
    end;
  end;
  Query.Abrir;
  Result := Query.RecordCount;
  ATabela.Limpar;
  if Result > 0 then
  begin
    for PropRtti in RttiType.GetProperties do
    begin
      AtribFk := TAtributos.Get.GetAtribFk(PropRtti);
      if Assigned(AtribFk) then
        BuscarRelacionamento(ATabela, PropRtti, AtribFk, Query.Dataset)
      else
        TAtributos.Get.SetarDadosTabela(PropRtti, PropRtti.Name, ATabela, Query.Dataset, FParams);
    end;
  end;
end;

{ TQueryIBX }

constructor TQueryIBX.Create(Conexao: TIBDatabase; Transacao: TIBTransaction);
begin
  FQuery := TIBQuery.Create(nil);
  FQuery.Database := Conexao;
  FQuery.Transaction := Transacao;
  FSql := FQuery.SQL;
end;

destructor TQueryIBX.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TQueryIBX.Executar;
begin
  FQuery.Prepare;
  FQuery.ExecSQL;
end;

procedure TQueryIBX.Abrir;
begin
  FQuery.Open;
end;

function TQueryIBX.Dataset: TDataset;
begin
  Result := FQuery;
end;

function TQueryIBX.RowsAffected: Integer;
begin
  Result := FQuery.RowsAffected;
end;

function TQueryIBX.RecordCount: Integer;
begin
  Result := FQuery.RecordCount;
end;

function TQueryIBX.Sql: TStrings;
begin
  Result := FSql;
end;

end.
