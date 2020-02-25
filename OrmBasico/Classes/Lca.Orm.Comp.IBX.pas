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

unit Lca.Orm.Comp.IBX;

interface

uses Db, Lca.Orm.Base, Rtti, Lca.Orm.Atributos, System.SysUtils, System.Classes,
  IBX.IB, IBX.IBQuery, IBX.IBDatabase, System.Generics.Collections;

type
  TQueryIBX = class(TInterfacedObject, IQueryParams)
  public
    // m�todos respons�veis por setar os par�metros
    procedure SetParamInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamVariant(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);

    // m�todos para setar os variados tipos de campos
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

    Function DbToTabela<T: TTabela>(ATabela: TTabela; ADataSet: TDataSet): TObjectList<T>;

    procedure SetDataSet(const Value: TDataSet);
  protected
    function ExecutaQuery: Integer;
  public
    constructor Create(Conexao: TIBDatabase; Transacao: TIBTransaction);

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

    // pega campo autoincremento
    function GetID(ATabela: TTabela; ACampo: string): Integer; overload;
    function GetID(Generator: string): Integer; overload;

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

uses Vcl.forms, Dialogs, System.TypInfo, System.Variants,
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
  FSql := TPadraoSql.Create;
  FParams := TQueryIBX.Create;
  FConexao := Conexao;
  FTransacao := Transacao;
  FQuery := TIBQuery.Create(Application);
  FQuery.Database := FConexao;
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
        raise Exception.Create('Tipo de campo n�o conhecido: ' +
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
      Dados.Database := FConexao;
      Dados.SQL.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);
      for Campo in ACamposWhere do
      begin
        if not TAtributos.Get.PropExiste(Campo, PropRtti, TipoRtti) then
          raise Exception.Create('Campo ' + Campo + ' n�o existe no objeto!');

        // setando os par�metros
        for PropRtti in TipoRtti.GetProperties do
        begin
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
        end;
      end;
      Dados.Open;
      Result := DbToTabela<T>(ATabela, Dados);
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
  AQry.Database := FConexao;
  AQry.SQL.Clear;
  AQry.SQL.Add('Select * from ' + TAtributos.Get.PegaNomeTab(ATabela));
  AQry.Open;
  Result := AQry;
end;

function TDaoIBX.ConsultaSql(ASql: string): TDataSet;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(Application);
  AQry.Database := FConexao;
  AQry.SQL.Clear;
  AQry.SQL.Add(ASql);
  AQry.Open;
  Result := AQry;
end;

function TDaoIBX.ConsultaSql(ASql: string; const ParamList: array of Variant): TDataSet;
var
  AQry: TIBQuery;
  I: Integer;
begin
  AQry := TIBQuery.Create(Application);
  AQry.Database := FConexao;
  AQry.SQL.Clear;
  AQry.SQL.Add(ASql);
  if (Length(ParamList) > 0) and (AQry.Params.Count > 0) then
   for I := 0 to AQry.Params.Count -1 do
     if (I < Length(ParamList)) then
       if VarIsType(ParamList[I], varDate) then
         AQry.Params[I].AsDateTime := VarToDateTime(ParamList[I])
       else
         AQry.Params[I].Value := ParamList[I];
  AQry.Open;
  Result := AQry;
end;

function TDaoIBX.ConsultaSql(ATabela, AWhere: string): TDataSet;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(Application);
  AQry.Database := FConexao;
  AQry.SQL.Clear;
  AQry.SQL.Add('select * from ' + ATabela);
  if AWhere <> '' then
    AQry.SQL.Add('where ' + AWhere);
  AQry.Open;
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
    Dados.Database := FConexao;
    Dados.SQL.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);
    if Length(AOrdem)>0 then
    begin
      Separador := '';
      Dados.SQL.Add('order by');
      for Campo in AOrdem do
      begin
        if TipoOrdem = 1 then
          Dados.SQL.Add(Separador + Campo + ' Desc')
        else
          Dados.SQL.Add(Separador + Campo);
        Separador := ',';
      end;
    end;
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        // setando os par�metros
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
      end;
    end;
    Dados.Open;
    Result := Dados;
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
    Dados.Database := FConexao;
    Dados.SQL.Text := FSql.GerarSqlSelect(ATabela, ACampos, ACamposWhere);
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        // setando os par�metros
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
      end;
    end;
    Dados.Open;
    Result := Dados;
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
    Dados.Database := FConexao;
    Dados.SQL.Text := FSql.GerarSqlSelect(ATabela, ACamposWhere);
    if Length(ACamposWhere)>0 then
    begin
      for Campo in ACamposWhere do
      begin
        // setando os par�metros
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
          begin
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
            Break;
          end;
      end;
    end;
    Dados.Open;
    Result := Dados;
  finally
    Contexto.Free;
  end;
end;

function TDaoIBX.GetID(ATabela: TTabela; ACampo: string): Integer;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(Application);
  AQry.Database := FConexao;
  AQry.SQL.Clear;
  AQry.SQL.Add('select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela));
  AQry.Open;
  Result := AQry.Fields[0].AsInteger + 1;
end;

function TDaoIBX.GetID(Generator: string): Integer;
var
  AQry: TIBQuery;
begin
  AQry := TIBQuery.Create(Application);
  AQry.Database := FConexao;
  AQry.SQL.Clear;
  AQry.SQL.Add('SELECT * FROM SP_GERADOR(' + quotedstr(Generator) + ')');
  AQry.Open;
  Result := AQry.Fields[0].AsInteger;
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
begin
  AQry := TIBQuery.Create(Application);
  try
    AQry.Database := FConexao;
    AQry.SQL.Clear;
    AQry.SQL.Add('select max(' + ACampo + ') from ' + TAtributos.Get.PegaNomeTab(ATabela));
    AQry.SQL.Add('Where');
    Separador := '';
    for Campo in ACamposChave do
    begin
      AQry.SQL.Add(Separador + Campo + '= :' + Campo);
      Separador := ' and ';
    end;
    Contexto := TRttiContext.Create;
    try
      TipoRtti := Contexto.GetType(ATabela.ClassType);
      for Campo in ACamposChave do
      begin
        // setando os par�metros
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, AQry, FParams);
      end;
      AQry.Open;
      Result := AQry.Fields[0].AsInteger;
    finally
      Contexto.Free;
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
    AQry.Database := FConexao;
    AQry.SQL.Clear;
    AQry.SQL.Add('select count(*) from ' + ATabela);
    if AWhere <> '' then
      AQry.SQL.Add('where ' + AWhere);
    AQry.Open;
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
    Contexto := TRttiContext.Create;
    try
      TipoRtti := Contexto.GetType(ATabela.ClassType);
      AQry.Database := FConexao;
      AQry.SQL.Clear;
      AQry.SQL.Add('select count(*) from ' + TAtributos.Get.PegaNomeTab(ATabela));
      if High(ACamposWhere) >= 0 then
        AQry.SQL.Add('where 1=1');
      for Campo in ACamposWhere do
        AQry.SQL.Add('and ' + Campo + '=:' + Campo);
      for Campo in ACamposWhere do
      begin
        for PropRtti in TipoRtti.GetProperties do
          if CompareText(PropRtti.Name, Campo) = 0 then
            TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, AQry, FParams);
      end;
      AQry.Open;
      Result := AQry.Fields[0].AsInteger;
    finally
      Contexto.Free;
    end;
  finally
    AQry.Free;
  end;
end;

function TDaoIBX.ExecutaQuery: Integer;
begin
  FQuery.Prepare();
  FQuery.ExecSQL;
  Result := FQuery.RowsAffected;
end;

function TDaoIBX.Excluir(ATabela: TTabela): Integer;
var
  Campo: string;
  PropRtti: TRttiProperty;
  RttiType: TRttiType;
begin
  FQuery.close;
  FQuery.SQL.Clear;
  FQuery.SQL.Text := FSql.GerarSqlDelete(ATabela);
  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
  // percorrer todos os campos da chave prim�ria
  for Campo in TAtributos.Get.PegaPks(ATabela) do
  begin
    // setando os par�metros
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
    raise Exception.Create('Campos AWhere n�o selecionados!');
  RttiType := TRttiContext.Create.GetType(ATabela.ClassType);
  FQuery.close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('Delete from ' + TAtributos.Get.PegaNomeTab(ATabela));
  FQuery.SQL.Add('Where');
  Sep := '';
  for Campo in AWhere do
  begin
    FQuery.SQL.Add(Sep + Campo + '= :' + Campo);
    Sep := ' and ';
  end;
  // percorrer todos os campos da chave prim�ria
  for Campo in AWhere do
  begin
    // setando os par�metros
    for PropRtti in RttiType.GetProperties do
      if CompareText(PropRtti.Name, Campo) = 0 then
        TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, FQuery, FParams);
  end;
  Result := ExecutaQuery;
end;

function TDaoIBX.Excluir(ATabela: string; AWhereValue: string): Integer;
begin
  if Trim(AWhereValue) = '' then
    raise Exception.Create('Campo/Valor para a exclus�o n�o informado');
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('Delete from ' + ATabela);
  FQuery.SQL.Add('Where ' + AwhereValue);
  Result := ExecutaQuery;
end;

function TDaoIBX.ExcluirTodos(ATabela: TTabela): Integer;
begin
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Text := 'Delete from ' + TAtributos.Get.PegaNomeTab(ATabela);
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
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Text := FSql.GerarSqlInsert(ATabela, RttiType, ACampos, AFlag);
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
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Text := FSql.GerarSqlUpdate(ATabela, RttiType, ACampos, AFlag);
    // valor dos par�metros
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
    FQuery.Database := FConexao;
    FQuery.SQL.Text := FSql.GerarSqlSelect(ATabela);
    for Campo in TAtributos.Get.PegaPks(ATabela) do
    begin
      // setando os par�metros
      for PropRtti in RttiType.GetProperties do
        if CompareText(PropRtti.Name, Campo) = 0 then
        begin
          TAtributos.Get.ConfiguraParametro(PropRtti, Campo, ATabela, Dados, FParams);
        end;
    end;
    FQuery.Open;
    Result := FQuery.RecordCount;
    if Result > 0 then
    begin
      for PropRtti in RttiType.GetProperties do
      begin
        Campo := PropRtti.Name;
        TAtributos.Get.SetarDadosTabela(PropRtti, Campo, ATabela, Dados, FParams);
      end;
    end;
  finally
    Dados.Free;
  end;
end;

end.
