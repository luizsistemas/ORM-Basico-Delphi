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

unit Lca.Orm.Comp.Zeos;

interface

uses Db, Lca.Orm.Base, Rtti, Lca.Orm.Atributos, System.SysUtils, System.Classes, System.Generics.Collections,
  ZDataset, ZConnection;

type
  TParamsZeos = class(TInterfacedObject, IQueryParams)
  public
    procedure SetParamInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamTime(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetParamVariant(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);

    procedure SetCamposInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetCamposString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetCamposDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetCamposTime(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
    procedure SetCamposCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
  end;

  TQueryZeos = class(TInterfacedObject, IQuery)
  private
    FQuery: TZQuery;
    FSql: TStrings;
    procedure Abrir;
    function RecordCount: Integer;
  public
    constructor Create(Conexao: TZConnection);
    destructor Destroy; override;
    function Sql: TStrings;
    function DataSet: TDataSet;
    function RowsAffected: Integer;
    procedure Executar;
  end;

  TDaoZeos = class(TDaoBase, IDaoBaseComandos)
  private
    FConexao: TZConnection;
  protected
    procedure AtualizarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
      Relacionamento: TCustomAttribute; AQuery: TDataSet); override;

    procedure BuscarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
      Relacionamento: TCustomAttribute; AQuery: TDataSet); override;
  public
    constructor Create(Conexao: TZConnection);
    function GerarClasse(ATabela, ANomeUnit, ANomeClasse: string): string;
    function ConsultaAll(ATabela: TTabela): IQuery;
    function ConsultaSql(ASql: string): IQuery; overload;
    function ConsultaSql(ASql: string; const ParamList: Array of Variant): IQuery; overload;
    function ConsultaSql(ATabela: string; AWhere: string): IQuery; overload;
    function ConsultaTab(ATabela: TTabela; ACamposWhere: array of string): IQuery; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string): IQuery; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere, AOrdem: array of string; TipoOrdem: Integer = 0): IQuery; overload;
    function ConsultaGen<T: TTabela>(ATabela: TTabela; ACamposWhere: array of string): TObjectList<T>;
    function GetID(ATabela: TTabela; ACampo: string): Integer; overload;
    function GetID(NomeTabela: string; ACampo: string): Integer; overload;
    function GetID(Generator: string): Integer; overload;
    function GetMax(ATabela: TTabela; ACampo: string;
      ACamposChave: array of string): Integer;
    function GetRecordCount(ATabela: TTabela; ACamposWhere: array of string): Integer; overload;
    function GetRecordCount(ATabela: string; AWhere: string): Integer; overload;
    function GetRecordCount(ATabela, AWhere: string; Params: Array of Variant): Integer; overload;
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

    function TabelaDifDB(ATabela: TTabela): Boolean;

    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function  InTransaction: Boolean;
    function Connected: Boolean;
  end;

implementation

uses System.TypInfo, System.Variants,
  Lca.Orm.GerarClasseZeos, Lca.Orm.GerarClasse.BancoFirebird;

{ TParamsZeos }

procedure TParamsZeos.SetParamCurrency(AProp: TRttiProperty; ACampo: string;
  ATabela: TTabela; AQry: TDataSet);
begin
  TZQuery(AQry).ParamByName(ACampo).AsCurrency := AProp.GetValue(ATabela).AsCurrency;
end;

procedure TParamsZeos.SetParamDate(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  inherited;
  if AProp.GetValue(ATabela).AsType<TDateTime> = 0 then
    TZQuery(AQry).ParamByName(ACampo).Clear
  else
    TZQuery(AQry).ParamByName(ACampo).AsDateTime := AProp.GetValue(ATabela).AsType<TDateTime>;
end;

procedure TParamsZeos.SetParamInteger(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TZQuery(AQry).ParamByName(ACampo).AsInteger := AProp.GetValue(ATabela).AsInteger;
end;

procedure TParamsZeos.SetParamString(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TZQuery(AQry).ParamByName(ACampo).AsString := AProp.GetValue(ATabela).AsString;
end;

procedure TParamsZeos.SetParamTime(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  if AProp.GetValue(ATabela).AsType<TTime> = 0 then
    TZQuery(AQry).ParamByName(ACampo).Clear
  else
    TZQuery(AQry).ParamByName(ACampo).AsTime := AProp.GetValue(ATabela).AsType<TTime>;
end;

procedure TParamsZeos.SetParamVariant(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TZQuery(AQry).ParamByName(ACampo).Value := AProp.GetValue(ATabela).AsVariant;
end;

procedure TParamsZeos.SetCamposCurrency(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TZQuery(AQry).FieldByName(ACampo).AsCurrency);
end;

procedure TParamsZeos.SetCamposDate(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TZQuery(AQry).FieldByName(ACampo).AsDateTime);
end;

procedure TParamsZeos.SetCamposInteger(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TZQuery(AQry).FieldByName(ACampo).AsInteger);
end;

procedure TParamsZeos.SetCamposString(AProp: TRttiProperty;
  ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TZQuery(AQry).FieldByName(ACampo).AsString);
end;

procedure TParamsZeos.SetCamposTime(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TZQuery(AQry).FieldByName(ACampo).AsDateTime);
end;

{ TDaoZeos }
constructor TDaoZeos.Create(Conexao: TZConnection);
begin
  inherited Create;
  FParams := TParamsZeos.Create;
  FConexao := Conexao;
end;

function TDaoZeos.GerarClasse(ATabela, ANomeUnit, ANomeClasse: string): string;
var
  NovaClasse: TGerarClasseZeos;
begin
  NovaClasse := TGerarClasseZeos.Create(TGerarClasseBancoFirebird.Create, Self);
  try
    Result := NovaClasse.Gerar(ATabela, ANomeUnit, ANomeClasse);
  finally
    NovaClasse.Free;
  end;
end;

procedure TDaoZeos.StartTransaction;
begin
  FConexao.StartTransaction;
end;

function TDaoZeos.TabelaDifDB(ATabela: TTabela): Boolean;
var
  Campo: string;
  ValueTab,
  ValueDB: Variant;
  Query: IQuery;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Contexto: TRttiContext;
  ValuePropTime,
  ValueDBTime: TTime;
  Field: TFieldType;
begin
  Result := False;
  Query := TQueryZeos.Create(FConexao);
  Contexto := TRttiContext.Create;
  try
    Query.Sql.Text := 'select * from ' + TAtributos.Get.PegaNomeTab(ATabela) + ' Where 1=1';
    for Campo in TAtributos.Get.PegaPks(ATabela) do
      Query.Sql.Add(' and ' + Campo +' = :' + Campo);

    TipoRtti := Contexto.GetType(ATabela.ClassType);
    for Campo in TAtributos.Get.PegaPks(ATabela) do
    begin
      for PropRtti in TipoRtti.GetProperties do
        if CompareText(PropRtti.Name, Campo) = 0 then
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.DataSet, FParams);
    end;
    Query.Abrir;
    for PropRtti in TipoRtti.GetProperties do
    begin
      if SameText(PropRtti.PropertyType.Name, 'TTime') then
      begin
        ValuePropTime := PropRtti.GetValue(Atabela).AsVariant;
        ValueDBTime := Query.DataSet.FieldbyName(PropRtti.Name).AsDateTime;
        if ValuePropTime<>ValueDBTime then
        begin
          Result := True;
          Break;
        end;
      end
      else
      begin
        ValueTab := PropRtti.GetValue(Atabela).AsVariant;
        ValueDB := Query.DataSet.FieldbyName(PropRtti.Name).asVariant;
        if ValueDB = null then
        begin
          Field := Query.DataSet.FieldByName(PropRtti.Name).DataType;
          case Query.DataSet.FieldByName(PropRtti.Name).DataType of
            ftString, ftWideString, ftWideMemo: ValueDB := '';
            ftBCD, ftFMTBcd, ftFloat, DB.TFieldType.ftExtended,
            ftInteger, ftTime,
            ftDate, ftDateTime: ValueDB := 0;
          end;
        end;
        if ValueTab <> ValueDB then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  finally
    Contexto.Free;
  end;
end;

procedure TDaoZeos.Commit;
begin
  FConexao.Commit;
end;

procedure TDaoZeos.RollBack;
begin
  FConexao.RollBack;
end;

function TDaoZeos.InTransaction: Boolean;
begin
  Result := FConexao.InTransaction;
end;

procedure TDaoZeos.BuscarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
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

function TDaoZeos.ConsultaGen<T>(ATabela: TTabela; ACamposWhere: array of string): TObjectList<T>;
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
    Query := TQueryZeos.Create(FConexao);
    Query.SQL.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);
    for Campo in ACamposWhere do
    begin
      if not TAtributos.Get.PropExiste(Campo, PropRtti, TipoRtti) then
        raise Exception.Create('Campo ' + Campo + ' não existe no objeto!');
      for PropRtti in TipoRtti.GetProperties do
      begin
        if CompareText(PropRtti.Name, Campo) = 0 then
        begin
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.DataSet, FParams);
          Break;
        end;
      end;
    end;
    Query.Abrir;
    while not Query.DataSet.Eof do
    begin
      Objeto := TObjectFactory<T>.Get.CriarInstancia;
      TipoRtti := Contexto.GetType(ATabela.ClassType);
      for PropRtti in TipoRtti.GetProperties do
      begin
        AtribFk := TAtributos.Get.GetAtribFk(PropRtti);
        if Assigned(AtribFk) then
          BuscarRelacionamento(Objeto.AsType<T>, PropRtti, AtribFk, Query.DataSet)
        else
          SetarDadosFromDataSet(Query.DataSet, PropRtti, Objeto.AsType<T>, PropRtti.Name);
      end;
      Result.Add(Objeto.AsType<T>);
      Query.DataSet.Next;
    end;
  finally
    Contexto.Free;
  end;
end;

function TDaoZeos.Connected: Boolean;
begin
  Result := FConexao.Connected;
end;

function TDaoZeos.ConsultaAll(ATabela: TTabela): IQuery;
begin
  Result := TQueryZeos.Create(FConexao);
  Result.Sql.Text := 'Select * from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Result.Abrir;
end;

function TDaoZeos.ConsultaSql(ASql: string): IQuery;
begin
  Result := TQueryZeos.Create(FConexao);
  Result.Sql.Text := ASql;
  Result.Abrir;
end;

function TDaoZeos.ConsultaSql(ASql: string; const ParamList: array of Variant): IQuery;
var
  I: Integer;
begin
  Result := TQueryZeos.Create(FConexao);
  Result.Sql.Text := ASql;
  if (Length(ParamList) > 0) and (TZQuery(Result.DataSet).Params.Count > 0) then
   for I := 0 to TZQuery(Result.DataSet).Params.Count -1 do
     if (I < Length(ParamList)) then
       if VarIsType(ParamList[I], varDate) then
         TZQuery(Result.DataSet).Params[I].AsDateTime := VarToDateTime(ParamList[I])
       else
         TZQuery(Result.DataSet).Params[I].Value := ParamList[I];
  Result.Abrir;
end;

function TDaoZeos.ConsultaSql(ATabela, AWhere: string): IQuery;
begin
  Result := TQueryZeos.Create(FConexao);
  Result.Sql.Text := 'select * from ' + ATabela;
  if AWhere <> '' then
    Result.Sql.Add('where ' + AWhere);
  Result.Abrir;
end;

function TDaoZeos.ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere,
  AOrdem: array of string; TipoOrdem: Integer): IQuery;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Separador: string;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Result := TQueryZeos.Create(FConexao);
    Result.Sql.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);
    if Length(AOrdem)>0 then
    begin
      Separador := '';
      Result.Sql.Add('order by');
      for Campo in AOrdem do
      begin
        if TipoOrdem = 1 then
          Result.Sql.Add(Separador + Campo + ' Desc')
        else
          Result.Sql.Add(Separador + Campo);
        Separador := ',';
      end;
    end;
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Result.DataSet, FParams);
      end;
    end;
    Result.Abrir;
  finally
    Contexto.Free;
  end;
end;

function TDaoZeos.ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string): IQuery;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Result := TQueryZeos.Create(FConexao);
    Result.Sql.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Result.DataSet, FParams);
      end;
    end;
    Result.Abrir;
  finally
    Contexto.Free;
  end;
end;

function TDaoZeos.ConsultaTab(ATabela: TTabela; ACamposWhere: array of string): IQuery;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Result := TQueryZeos.Create(FConexao);
    Result.Sql.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
          begin
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Result.DataSet, FParams);
            Break;
          end;
      end;
    end;
    Result.Abrir;
  finally
    Contexto.Free;
  end;
end;

function TDaoZeos.GetID(ATabela: TTabela; ACampo: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryZeos.Create(FConexao);
  Query.Sql.Text := 'select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger + 1;
end;

function TDaoZeos.GetID(NomeTabela: string; ACampo: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryZeos.Create(FConexao);
  Query.Sql.Add('select max(' + ACampo + ') from ' + NomeTabela);
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger + 1;
end;

function TDaoZeos.GetID(Generator: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryZeos.Create(FConexao);
  Query.Sql.Text := 'SELECT * FROM SP_GERADOR(' + quotedstr(Generator) + ')';
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger;
end;

function TDaoZeos.GetMax(ATabela: TTabela; ACampo: string;
  ACamposChave: array of string): Integer;
var
  Campo: string;
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Separador: string;
  Query: IQuery;
begin
  Query := TQueryZeos.Create(FConexao);
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
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.DataSet, FParams);
    end;
    Query.Abrir;
    Result := Query.DataSet.Fields[0].AsInteger;
  finally
    Contexto.Free;
  end;
end;

function TDaoZeos.GetRecordCount(ATabela, AWhere: string; Params: array of Variant): Integer;
var
  Query: IQuery;
  procedure ConfigParams;
  var
    I: Integer;
  begin
    if Length(Params)>0 then
     for I := 0 to Length(Params) - 1 do
         if VarIsType(Params[I], varDate) then
           TZQuery(Query.DataSet).Params[I].AsDateTime := VarToDateTime(Params[I])
         else
           TZQuery(Query.DataSet).Params[I].Value := Params[I];
  end;
begin
  Query := TQueryZeos.Create(FConexao);
  Query.Sql.Text := 'SELECT COUNT(*) FROM ' + ATabela;
  if not Trim(AWhere).IsEmpty then
  begin
    Query.Sql.Add('WHERE ' + AWhere);
    ConfigParams;
  end;
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger;
end;

function TDaoZeos.GetRecordCount(ATabela, AWhere: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryZeos.Create(FConexao);
  Query.Sql.Text := 'select count(*) from ' + ATabela;
  if AWhere <> '' then
    Query.Sql.Add('where ' + AWhere);
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger;
end;

function TDaoZeos.GetRecordCount(ATabela: TTabela;
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
    Query := TQueryZeos.Create(FConexao);
    Query.Sql.Text := 'select count(*) from ' + TAtributos.Get.PegaNomeTab(ATabela);
    if High(ACamposWhere) >= 0 then
      Query.Sql.Add('where 1=1');
    for Campo in ACamposWhere do
      Query.Sql.Add('and ' + Campo + '=:' + Campo);
    for Campo in ACamposWhere do
    begin
      for PropRtti in TipoRtti.GetProperties do
        if CompareText(PropRtti.Name, Campo) = 0 then
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.DataSet, FParams);
    end;
    Query.Abrir;
    Result := Query.DataSet.Fields[0].AsInteger;
  finally
    Contexto.Free;
  end;
end;

function TDaoZeos.Excluir(ATabela: TTabela): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  Comando: IQuery;
begin
  Comando := TQueryZeos.Create(FConexao);
  Comando.Sql.Text := FSql.GerarSqlDelete(ATabela);
  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
  for Campo in TAtributos.Get.PegaPks(ATabela) do
  begin
    for PropRtti in RttiType.GetProperties do
      if CompareText(PropRtti.Name, Campo) = 0 then
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Comando.DataSet, FParams);
  end;
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

function TDaoZeos.Excluir(ATabela: TTabela; AWhere: array of string): Integer;
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
  Comando := TQueryZeos.Create(FConexao);
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
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Comando.DataSet, FParams);
  end;
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

function TDaoZeos.Excluir(ATabela: string; AWhereValue: string): Integer;
var
  Comando: IQuery;
begin
  if Trim(AWhereValue) = '' then
    raise Exception.Create('Campo/Valor para a exclusão não informado');
  Comando := TQueryZeos.Create(FConexao);
  Comando.Sql.Clear;
  Comando.Sql.Add('Delete from ' + ATabela);
  Comando.Sql.Add('Where ' + AwhereValue);
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

function TDaoZeos.ExcluirTodos(ATabela: TTabela): Integer;
var
  Comando: IQuery;
begin
  Comando := TQueryZeos.Create(FConexao);
  Comando.Sql.Clear;
  Comando.Sql.Text := 'Delete from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

procedure TDaoZeos.ExecSQL(ASQL: string; const ParamList: array of Variant);
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
          TZQuery(Comando.DataSet).Params[I].AsDateTime := VarToDateTime(ParamList[I])
        else
          TZQuery(Comando.DataSet).Params[I].Value := ParamList[I];
    end;
  end;
begin
  Comando := TQueryZeos.Create(FConexao);
  Comando.Sql.Text := ASql;
  ConfigParams;
  Comando.Executar;
end;

function TDaoZeos.Inserir(ATabela: TTabela): Integer;
begin
  Result := Self.Inserir(ATabela, []);
end;

function TDaoZeos.Inserir(ATabela: TTabela; ACampos: array of string;
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
    Comando := TQueryZeos.Create(FConexao);
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
        AtualizarRelacionamento(ATabela, PropRtti, AtribFk, Comando.DataSet)
      else
        TAtributos.Get.ConfiguraParametro(PropRtti, PropRtti.Name, ATabela, Comando.DataSet, FParams);
    end;
    Comando.Executar;
    Result := Comando.RowsAffected;
  except
    raise;
  end;
end;

function TDaoZeos.Salvar(ATabela: TTabela): Integer;
begin
  Result := Self.Salvar(ATabela, []);
end;

function TDaoZeos.Salvar(ATabela: TTabela; ACampos: array of string;
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
    Comando := TQueryZeos.Create(FConexao);
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
        AtualizarRelacionamento(ATabela, PropRtti, AtribFk, Comando.DataSet)
      else
        TAtributos.Get.ConfiguraParametro(PropRtti, PropRtti.Name, ATabela, Comando.DataSet, FParams);
    end;
    Comando.Executar;
    Result := Comando.RowsAffected;
  except
    raise;
  end;
end;

procedure TDaoZeos.AtualizarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
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

function TDaoZeos.Buscar(ATabela: TTabela): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  AtribFk: AttFk;
  Query: IQuery;
begin
  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
  Query := TQueryZeos.Create(FConexao);
  Query.Sql.Text := FSql.GerarSqlSelect(ATabela);
  for Campo in TAtributos.Get.PegaPks(ATabela) do
  begin
    for PropRtti in RttiType.GetProperties do
    begin
      if CompareText(PropRtti.Name, Campo) = 0 then
      begin
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Query.DataSet, FParams);
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
        BuscarRelacionamento(ATabela, PropRtti, AtribFk, Query.DataSet)
      else
        TAtributos.Get.SetarDadosTabela(PropRtti, PropRtti.Name, ATabela, Query.DataSet, FParams);
    end;
  end;
end;

{ TQueryZeos }

constructor TQueryZeos.Create(Conexao: TZConnection);
begin
  FQuery := TZQuery.Create(nil);
  FQuery.Connection := Conexao;
  FSql := FQuery.SQL;
end;

destructor TQueryZeos.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TQueryZeos.Executar;
begin
  FQuery.Prepare;
  FQuery.ExecSQL;
end;

procedure TQueryZeos.Abrir;
begin
  FQuery.Open;
end;

function TQueryZeos.DataSet: TDataSet;
begin
  Result := FQuery;
end;

function TQueryZeos.RowsAffected: Integer;
begin
  Result := FQuery.RowsAffected;
end;

function TQueryZeos.RecordCount: Integer;
begin
  Result := FQuery.RecordCount;
end;

function TQueryZeos.Sql: TStrings;
begin
  Result := FSql;
end;

end.
