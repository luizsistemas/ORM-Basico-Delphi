{******************************************************************************}
{ Projeto: ORM - B�sico do Blog do Luiz                                        }
{ Este projeto busca agilizar o processo de manipula��o de dados (DAO/CRUD),   }
{ ou seja,  gerar inserts, updates, deletes nas tabelas de forma autom�tica,   }
{ sem a necessidade de criarmos classes DAOs para cada tabela. Tamb�m visa     }
{ facilitar a transi��o de uma suite de componentes de acesso a dados para     }
{ outra.                                                                       }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Luiz Carlos Alves                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{    Luiz Carlos Alves - contato@luizsistemas.com.br                           }
{                                                                              }
{ Voc� pode obter a �ltima vers�o desse arquivo no reposit�rio                 }
{ https://github.com/luizsistemas/ORM-Basico-Delphi                            }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{ Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Luiz Carlos Alves - contato@luizsistemas.com.br -  www.luizsistemas.com.br   }
{                                                                              }
{******************************************************************************}

unit Lca.Orm.Comp.FireDac;

interface

uses
  Db, Lca.Orm.Base, Rtti, Lca.Orm.Atributos, System.SysUtils, System.Classes,
  System.Generics.Collections, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TParamsFireDac = class(TInterfacedObject, IQueryParams)
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

  TQueryFD = class(TInterfacedObject, IQuery)
  private
    FQuery: TFDQuery;
    FSql: TStrings;
    function RecordCount: Integer;
    procedure Abrir;
  public
    constructor Create(Conexao: TFDConnection; Transacao: TFDTransaction);
    destructor Destroy; override;
    function Sql: TStrings;
    function DataSet: TDataSet;
    function RowsAffected: Integer;
    procedure Executar;
  end;

  TDaoFireDac = class(TDaoBase, IDaoBaseComandos)
  private
    FConexao: TFDConnection;
    FTransacao: TFDTransaction;
  protected
    procedure AtualizarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
      Relacionamento: TCustomAttribute; AQuery: TDataSet); override;
    procedure BuscarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
      Relacionamento: TCustomAttribute; AQuery: TDataSet); override;
  public
    constructor Create(Conexao: TFDConnection; Transacao: TFDTransaction);
    function GerarClasse(ATabela, ANomeUnit, ANomeClasse: string): string;
    function ConsultaAll(ATabela: TTabela): IQuery;
    function ConsultaSql(ASql: string): IQuery; overload;
    function ConsultaSql(ASql: string; const ParamList: array of Variant): IQuery; overload;
    function ConsultaSql(ATabela: string; AWhere: string): IQuery; overload;
    function ConsultaTab(ATabela: TTabela; ACamposWhere: array of string): IQuery; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string): IQuery; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere, AOrdem: array of string; TipoOrdem: Integer = 0): IQuery; overload;
    function ConsultaGen<T: TTabela>(ATabela: TTabela; ACamposWhere: array of string): TObjectList<T>;
    function GetID(ATabela: TTabela; ACampo: string): Integer; overload;
    function GetID(NomeTabela: string; ACampo: string): Integer; overload;
    function GetID(Generator: string): Integer; overload;
    function GetMax(ATabela: TTabela; ACampo: string; ACamposChave: array of string): Integer;
    function GetRecordCount(ATabela: TTabela; ACamposWhere: array of string): Integer; overload;
    function GetRecordCount(ATabela: string; AWhere: string): Integer; overload;
    function GetRecordCount(ATabela, AWhere: string; Params: Array of Variant): Integer; overload;

    function Inserir(ATabela: TTabela): Integer; overload;
    function Inserir(ATabela: TTabela; ACampos: array of string; AFlag: TFlagCampos = fcIgnore): Integer; overload;
    function Salvar(ATabela: TTabela): Integer; overload;
    function Salvar(ATabela: TTabela; ACampos: array of string; AFlag: TFlagCampos = fcAdd): Integer; overload;
    function Excluir(ATabela: TTabela): Integer; overload;
    function Excluir(ATabela: TTabela; AWhere: array of string): Integer; overload;
    function Excluir(ATabela: string; AWhereValue: string): Integer; overload;
    function ExcluirTodos(ATabela: TTabela): Integer; overload;
    function Buscar(ATabela: TTabela): Integer;

    function TabelaDifDB(ATabela: TTabela): Boolean;

    procedure ExecSQL(ASQL: string; const ParamList: array of Variant);
    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function InTransaction: Boolean;
  end;

implementation

uses
  System.TypInfo, System.Variants,
  Lca.Orm.GerarClasseFireDac, Lca.Orm.GerarClasse.BancoFirebird, Vcl.Forms;

{ TParamsFireDac }

procedure TParamsFireDac.SetParamCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TFDQuery(AQry).ParamByName(ACampo).AsCurrency := AProp.GetValue(ATabela).AsCurrency;
end;

procedure TParamsFireDac.SetParamDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  inherited;
  if AProp.GetValue(ATabela).AsType<TDateTime> = 0 then
    TFDQuery(AQry).ParamByName(ACampo).Clear
  else
    TFDQuery(AQry).ParamByName(ACampo).AsDateTime := AProp.GetValue(ATabela).AsType<TDateTime>;
end;

procedure TParamsFireDac.SetParamInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TFDQuery(AQry).ParamByName(ACampo).AsInteger := AProp.GetValue(ATabela).AsInteger;
end;

procedure TParamsFireDac.SetParamString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TFDQuery(AQry).ParamByName(ACampo).AsString := AProp.GetValue(ATabela).AsString;
end;

procedure TParamsFireDac.SetParamTime(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  if AProp.GetValue(ATabela).AsType<TTime> = 0 then
    TFDQuery(AQry).ParamByName(ACampo).Clear
  else
    TFDQuery(AQry).ParamByName(ACampo).AsDateTime := AProp.GetValue(ATabela).AsType<TTime>;
end;

procedure TParamsFireDac.SetParamVariant(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  TFDQuery(AQry).ParamByName(ACampo).Value := AProp.GetValue(ATabela).AsVariant;
end;

procedure TParamsFireDac.SetCamposCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TFDQuery(AQry).FieldByName(ACampo).AsCurrency);
end;

procedure TParamsFireDac.SetCamposDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TFDQuery(AQry).FieldByName(ACampo).AsDateTime);
end;

procedure TParamsFireDac.SetCamposInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TFDQuery(AQry).FieldByName(ACampo).AsInteger);
end;

procedure TParamsFireDac.SetCamposString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TFDQuery(AQry).FieldByName(ACampo).AsString);
end;

procedure TParamsFireDac.SetCamposTime(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TDataSet);
begin
  AProp.SetValue(ATabela, TFDQuery(AQry).FieldByName(ACampo).AsDateTime);
end;

{ TDaoFireDac }

constructor TDaoFireDac.Create(Conexao: TFDConnection; Transacao: TFDTransaction);
begin
  inherited Create;
  FParams := TParamsFireDac.Create;
  FConexao := Conexao;
  FTransacao := Transacao;
end;

function TDaoFireDac.GerarClasse(ATabela, ANomeUnit, ANomeClasse: string): string;
var
  NovaClasse: TGerarClasseFireDac;
begin
  NovaClasse := TGerarClasseFireDac.Create(TGerarClasseBancoFirebird.Create, Self);
  try
    Result := NovaClasse.Gerar(ATabela, ANomeUnit, ANomeClasse);
  finally
    NovaClasse.Free;
  end;
end;

procedure TDaoFireDac.StartTransaction;
begin
  FTransacao.StartTransaction;
end;

function TDaoFireDac.TabelaDifDB(ATabela: TTabela): Boolean;
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
begin
  Result := False;
  Query := TQueryFD.Create(FConexao, nil);
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
          case Query.DataSet.FieldByName(PropRtti.Name).DataType of
            ftString, ftWideString, ftWideMemo: ValueDB := '';
            ftBCD, ftFMTBcd, ftFloat,
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

procedure TDaoFireDac.Commit;
begin
  FTransacao.Commit;
end;

procedure TDaoFireDac.RollBack;
begin
  FTransacao.RollBack;
end;

function TDaoFireDac.InTransaction: Boolean;
begin
  Result := FConexao.InTransaction;
end;

function TDaoFireDac.ConsultaGen<T>(ATabela: TTabela; ACamposWhere: array of string): TObjectList<T>;
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
    Query := TQueryFD.Create(FConexao, nil);
    Query.SQL.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);
    for Campo in ACamposWhere do
    begin
      if not TAtributos.Get.PropExiste(Campo, PropRtti, TipoRtti) then
        raise Exception.Create('Campo ' + Campo + ' n�o existe no objeto!');
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

function TDaoFireDac.ConsultaAll(ATabela: TTabela): IQuery;
begin
  Result := TQueryFD.Create(FConexao, nil);
  Result.Sql.Text := 'Select * from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Result.Abrir;
end;

function TDaoFireDac.ConsultaSql(ASql: string): IQuery;
begin
  Result := TQueryFD.Create(FConexao, nil);
  Result.Sql.Text := ASql;
  Result.Abrir
end;

function TDaoFireDac.ConsultaSql(ASql: string; const ParamList: array of Variant): IQuery;
var
  I: Integer;
begin
  Result := TQueryFD.Create(FConexao, nil);
  Result.Sql.Text := ASql;
  if (Length(ParamList) > 0) and (TFDQuery(Result.DataSet).Params.Count > 0) then
    for I := 0 to TFDQuery(Result.DataSet).Params.Count - 1 do
      if (I < Length(ParamList)) then
        if VarIsType(ParamList[I], varDate) then
          TFDQuery(Result.DataSet).Params[I].AsDateTime := VarToDateTime(ParamList[I])
        else
          TFDQuery(Result.DataSet).Params[I].Value := ParamList[I];
  Result.Abrir;
end;

function TDaoFireDac.ConsultaSql(ATabela, AWhere: string): IQuery;
begin
  Result := TQueryFD.Create(FConexao, nil);
  Result.Sql.Text := 'select * from ' + ATabela;
  if AWhere <> '' then
    Result.SQL.Add('where ' + AWhere);
  Result.Abrir
end;

function TDaoFireDac.ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere,
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
    Result := TQueryFD.Create(FConexao, nil);
    Result.Sql.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);
    if Length(AOrdem) > 0 then
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
    if Length(ACamposWhere) > 0 then
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

function TDaoFireDac.ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string): IQuery;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Result := TQueryFD.Create(FConexao, nil);
    Result.Sql.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);
    if Length(ACamposWhere) > 0 then
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

function TDaoFireDac.ConsultaTab(ATabela: TTabela; ACamposWhere: array of string): IQuery;
var
  Contexto: TRttiContext;
  Campo: string;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    Result := TQueryFD.Create(FConexao, nil);
    Result.SQL.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);
    if Length(ACamposWhere) > 0 then
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

function TDaoFireDac.GetID(ATabela: TTabela; ACampo: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryFD.Create(FConexao, nil);
  Query.Sql.Text := 'select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger + 1;
end;

function TDaoFireDac.GetID(NomeTabela: string; ACampo: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryFD.Create(FConexao, nil);
  Query.Sql.Add('select max(' + ACampo + ') from ' + NomeTabela);
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger + 1;
end;

function TDaoFireDac.GetID(Generator: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryFD.Create(FConexao, nil);
  Query.Sql.Text := 'SELECT * FROM SP_GERADOR(' + quotedstr(Generator) + ')';
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger;
end;

function TDaoFireDac.GetMax(ATabela: TTabela; ACampo: string; ACamposChave: array of string): Integer;
var
  Campo: string;
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  Separador: string;
  Query: IQuery;
begin
  Query := TQueryFD.Create(FConexao, nil);
  Query.Sql.Add('select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela));
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

function TDaoFireDac.GetRecordCount(ATabela, AWhere: string; Params: array of Variant): Integer;
var
  Query: IQuery;
  procedure ConfigParams;
  var
    I: Integer;
  begin
    if Length(Params)>0 then
     for I := 0 to Length(Params) - 1 do
         if VarIsType(Params[I], varDate) then
           TFDQuery(Query.DataSet).Params[I].AsDateTime := VarToDateTime(Params[I])
         else
           TFDQuery(Query.DataSet).Params[I].Value := Params[I];
  end;
begin
  Query := TQueryFD.Create(FConexao, nil);
  Query.Sql.Text := 'SELECT COUNT(*) FROM ' + ATabela;
  if not Trim(AWhere).IsEmpty then
  begin
    Query.Sql.Add('WHERE ' + AWhere);
    ConfigParams;
  end;
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger;
end;

function TDaoFireDac.GetRecordCount(ATabela, AWhere: string): Integer;
var
  Query: IQuery;
begin
  Query := TQueryFD.Create(FConexao, nil);
  Query.Sql.Add('select count(*) from ' + ATabela);
  if AWhere <> '' then
    Query.Sql.Add('where ' + AWhere);
  Query.Abrir;
  Result := Query.DataSet.Fields[0].AsInteger;
end;

function TDaoFireDac.GetRecordCount(ATabela: TTabela; ACamposWhere: array of string): Integer;
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
    Query := TQueryFD.Create(FConexao, nil);
    Query.Sql.Add('select count(*) from ' + TAtributos.Get.PegaNomeTab(ATabela));
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

function TDaoFireDac.Excluir(ATabela: TTabela): Integer;
var
  Contexto: TRttiContext;
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  Comando: IQuery;
begin
  Contexto := TRttiContext.Create;
  try
    Comando := TQueryFD.Create(FConexao, FTransacao);
    Comando.Sql.Text := FSql.GerarSqlDelete(ATabela);
    RttiType := Contexto.GetType(ATabela.ClassType);
    for Campo in TAtributos.Get.PegaPks(ATabela) do
    begin
      for PropRtti in RttiType.GetProperties do
        if CompareText(PropRtti.Name, Campo) = 0 then
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Comando.DataSet, FParams);
    end;
    Comando.Executar;
    Result := Comando.RowsAffected;
  finally
    Contexto.Free;
  end;
end;

function TDaoFireDac.Excluir(ATabela: TTabela; AWhere: array of string): Integer;
var
  Contexto: TRttiContext;
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  Sep: string;
  Comando: IQuery;
begin
  if Length(AWhere) = 0 then
    raise Exception.Create('Campos AWhere n�o selecionados!');
  Contexto := TRttiContext.Create;
  try
    RttiType := Contexto.GetType(ATabela.ClassType);
    Comando := TQueryFD.Create(FConexao, FTransacao);
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
  finally
    Contexto.Free;
  end;
end;

function TDaoFireDac.Excluir(ATabela: string; AWhereValue: string): Integer;
var
  Comando: IQuery;
begin
  if Trim(AWhereValue) = '' then
    raise Exception.Create('Campo/Valor para a exclus�o n�o informado');
  Comando := TQueryFD.Create(FConexao, FTransacao);
  Comando.Sql.Clear;
  Comando.Sql.Add('Delete from ' + ATabela);
  Comando.Sql.Add('Where ' + AWhereValue);
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

function TDaoFireDac.ExcluirTodos(ATabela: TTabela): Integer;
var
  Comando: IQuery;
begin
  Comando := TQueryFD.Create(FConexao, FTransacao);
  Comando.Sql.Clear;
  Comando.Sql.Text := 'Delete from ' + TAtributos.Get.PegaNomeTab(ATabela);
  Comando.Executar;
  Result := Comando.RowsAffected;
end;

procedure TDaoFireDac.ExecSQL(ASQL: string; const ParamList: array of Variant);
var
  Comando: IQuery;
  procedure ConfigParams;
  var
    I: Integer;
  begin
    if Length(ParamList) > 0 then
    begin
      for I := 0 to Length(ParamList) - 1 do
        if VarIsType(ParamList[I], varDate) then
          TFDQuery(Comando.DataSet).Params[I].AsDateTime := VarToDateTime(ParamList[I])
        else
          TFDQuery(Comando.DataSet).Params[I].Value := ParamList[I];
    end;
  end;
begin
  Comando := TQueryFD.Create(FConexao, FTransacao);
  Comando.Sql.Text := ASQL;
  ConfigParams;
  Comando.Executar;
end;

procedure TDaoFireDac.BuscarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
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

function TDaoFireDac.Buscar(ATabela: TTabela): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  AtribFk: AttFk;
  Query: IQuery;
begin
  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
  Query := TQueryFD.Create(FConexao, nil);
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
        BuscarRelacionamento(ATabela, PropRtti, AtribFk, TFDQuery(Query.DataSet))
      else
        TAtributos.Get.SetarDadosTabela(PropRtti, PropRtti.Name, ATabela, Query.DataSet, FParams);
    end;
  end;
end;

procedure TDaoFireDac.AtualizarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
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

function TDaoFireDac.Inserir(ATabela: TTabela): Integer;
begin
  Result := Self.Inserir(ATabela, []);
end;

function TDaoFireDac.Inserir(ATabela: TTabela; ACampos: array of string; AFlag: TFlagCampos): Integer;
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
    Comando := TQueryFD.Create(FConexao, FTransacao);
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

function TDaoFireDac.Salvar(ATabela: TTabela): Integer;
begin
  Result := Self.Salvar(ATabela, []);
end;

function TDaoFireDac.Salvar(ATabela: TTabela; ACampos: array of string; AFlag: TFlagCampos): Integer;
var
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
  Comando: IQuery;
  AtribFk: AttFk;
begin
  try
    TAtributos.Get.ValidaTabela(ATabela, ACampos, AFlag);
    RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
    Comando := TQueryFD.Create(FConexao, FTransacao);
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

{ TQueryFireDac }

constructor TQueryFD.Create(Conexao: TFDConnection; Transacao: TFDTransaction);
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := Conexao;
  FQuery.Transaction := Transacao;
  FSql := FQuery.SQL;
end;

destructor TQueryFD.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TQueryFD.Executar;
begin
  FQuery.Prepare;
  FQuery.ExecSQL;
end;

procedure TQueryFD.Abrir;
begin
  FQuery.Open;
end;

function TQueryFD.DataSet: TDataSet;
begin
  Result := FQuery;
end;

function TQueryFD.RowsAffected: Integer;
begin
  Result := FQuery.RowsAffected;
end;

function TQueryFD.RecordCount: Integer;
begin
  Result := FQuery.RecordCount;
end;

function TQueryFD.Sql: TStrings;
begin
  Result := FSql;
end;

end.

