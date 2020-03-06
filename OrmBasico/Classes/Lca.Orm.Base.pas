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
unit Lca.Orm.Base;

interface

uses DB, SysUtils, Classes, Rtti, System.TypInfo;

type
  TCamposArray = array of string;
  TFlagCampos = (fcAdd, fcIgnore);

  TTabela = class
  public
    procedure Limpar;
    procedure CopyProps(From: TTabela);
  end;

  IQuery = interface
    ['{52E7E2A0-C3E7-41FC-86B1-50A50220C474}']
    function Sql: TStrings;
    function Dataset: TDataset;
    function RowsAffected: Integer;
    function RecordCount: Integer;
    procedure Executar;
    procedure Abrir;
  end;

  IBaseSql = interface
    ['{3890762A-9CF2-46C3-A75C-62947D3DAD7B}']
    function GerarSqlInsert(ATabela: string; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;
    function GerarSqlUpdate(ATabela: TTabela; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;
    function GerarSqlDelete(ATabela: TTabela): string;
    function GerarSqlSelect(ATabela: TTabela): string; overload;
    function GerarSqlSelect(ATabela: TTabela; ACamposWhere: array of string): string;
       overload;
    function GerarSqlSelect(ATabela: TTabela; ACampos: array of string;
      ACamposWhere: array of string): string; overload;
  end;

  TPadraoSql = class(TInterfacedObject, IBaseSql)
  public
    function GerarSqlInsert(ATabela: string; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;
    function GerarSqlUpdate(ATabela: TTabela; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;
    function GerarSqlDelete(ATabela: TTabela): string; virtual;
    function GerarSqlSelect(ATabela: TTabela): string; overload;
    function GerarSqlSelect(ATabela: TTabela; ACamposWhere: array of string): string; overload;
    function GerarSqlSelect(ATabela: TTabela; ACampos: array of string;
      ACamposWhere: array of string): string; overload;
  end;

  IQueryParams = interface
    ['{FBE0114E-931B-44FB-8325-45A68D2DE4E3}']
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

  IDaoBaseComandos = interface
    ['{6E2AFB66-465B-4924-9221-88E283E81EA7}']
    function GerarClasse(ATabela, ANomeUnit: string; ANomeClasse: string = ''): string;
    function GetID(ATabela:TTabela; ACampo: string): Integer; overload;
    function GetID(Generator: string): Integer; overload;
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
    function ConsultaAll(ATabela: TTabela; AOwner: TComponent = nil): TDataSet;
    function ConsultaSql(ASql: string; AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaSql(ASql: string; const ParamList: Array of Variant;
      AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaSql(ATabela: string; AWhere: string;
      AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACamposWhere: array of string;
      AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACampos,
      ACamposWhere: array of string; AOwner: TComponent = nil): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere,
      AOrdem: array of string; TipoOrdem: Integer = 0;
      AOwner: TComponent = nil): TDataSet; overload;
    procedure ExecSQL(ASQL: string; const ParamList: Array of Variant);
    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function  InTransaction: Boolean;
  end;

  TDaoBase = class(TInterfacedObject)
  private
  protected
    FSql: IBaseSql;
    FDataSet: TDataSet;
    FParams: IQueryParams;
    procedure SetDataSet(const Value: TDataSet);
    procedure BuscarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
      Relacionamento: TCustomAttribute; AQuery: TDataSet); virtual; abstract;
    procedure AtualizarRelacionamento(ATabela: TTabela; APropRtti: TRttiProperty;
      Relacionamento: TCustomAttribute; AQuery: TDataSet); virtual; abstract;
    procedure SetarDadosFromDataSet(ADataset: TDataset; PropRtti: TRttiProperty;
      Objeto: TValue; Campo: string);
    function GetOwner(AOwner: TComponent): TComponent;
  public
    constructor Create;
    property DataSet: TDataSet read FDataSet write SetDataSet;
  end;

  IBaseGerarClasseBanco = Interface
    ['{D82EC768-996A-4E06-A59E-0C87CB305D0E}']
    function GetSQLCamposTabela(ATabela: string): string;
    function GetSQLCamposPK(ATabela: string): string;
    procedure GerarFields(Ads: TDataSet; AResult: TStrings);
    procedure GerarProperties(Ads: TDataSet; AResult: TStrings; ACamposPK: string);
  End;

  IObjectFactory<T:TTabela> = interface
    ['{50ACF26D-52D9-490A-B22D-F672B344AB94}']
    function CriarInstancia: T;
  end;

  TObjectFactory<T:TTabela> = class (TInterfacedObject, IObjectFactory<T>)
  public
    class function Get: IObjectFactory<T>;
    function CriarInstancia: T;
  end;

implementation

uses Lca.Orm.Atributos, Vcl.Forms;

{ PadraoSql}
function TPadraoSql.GerarSqlDelete(ATabela: TTabela): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    ASql.Add('Delete from ' + TAtributos.Get.PegaNomeTab(ATabela));
    ASql.Add('Where');
    Separador := '';
    for Campo in TAtributos.Get.PegaPks(ATabela) do
    begin
      ASql.Add(Separador + Campo + '= :' + Campo);
      Separador := ' and ';
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlInsert(ATabela: string; TipoRtti: TRttiType;
  ACampos: array of string; AFlag: TFlagCampos): string;
var
  Separador: string;
  ASql: TStringList;
  PropRtti: TRttiProperty;
  Atributos: IAtributos;
  AtribFk: AttFk;
  function GetCampo: string;
  begin
    AtribFk := Atributos.GetAtribFk(PropRtti);
    if Assigned(AtribFk) then
      Result := AtribFk.CampoFk
    else
      Result := PropRtti.Name;
  end;
begin
  ASql := TStringList.Create;
  try
    Atributos := TAtributos.Create;
    ASql.Add('Insert into ' + ATabela);
    ASql.Add('(');
    Separador := '';
    for PropRtti in TipoRtti.GetProperties do
    begin
      if Length(ACampos) > 0 then
        if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
          ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
          Continue;
      ASql.Add(Separador + GetCampo);
      Separador := ',';
    end;
    ASql.Add(')');
    ASql.Add('Values (');
    Separador := '';
    for PropRtti in TipoRtti.GetProperties do
    begin
      if Length(ACampos) > 0 then
        if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
          ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
          Continue;
      ASql.Add(Separador + ':' + GetCampo);
      Separador := ',';
    end;
    ASql.Add(')');
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlUpdate(ATabela: TTabela;
  TipoRtti: TRttiType; ACampos: array of string; AFlag: TFlagCampos): string;
var
  Campo, Separador: string;
  ASql: TStringList;
  PropRtti: TRttiProperty;
  Atributos: IAtributos;
  AtribFk: AttFk;
  function GetCampo: string;
  begin
    AtribFk := Atributos.GetAtribFk(PropRtti);
    if Assigned(AtribFk) then
      Result := AtribFk.CampoFk
    else
      Result := PropRtti.Name;
  end;
begin
  ASql := TStringList.Create;
  try
    Atributos := TAtributos.Create;
    ASql.Add('update ' + Atributos.PegaNomeTab(ATabela));
    ASql.Add('set');
    Separador := '';
    for PropRtti in TipoRtti.GetProperties do
    begin
      if Length(ACampos) > 0 then
        if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
          ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
          Continue;
      ASql.Add(Separador + GetCampo + '=:' + GetCampo);
      Separador := ',';
    end;
    ASql.Add('where');
    Separador := '';
    for Campo in Atributos.PegaPks(ATabela) do
    begin
      ASql.Add(Separador + Campo + '= :' + Campo);
      Separador := ' and ';
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlSelect(ATabela: TTabela): string;
var
  Campo, Separador: string;
  ASql: TStringList;
  Atributos: IAtributos;
begin
  Atributos := TAtributos.Create;
  ASql := TStringList.Create;
  try
    ASql.Add('Select * from ' + Atributos.PegaNomeTab(ATabela));
    ASql.Add('Where');
    Separador := '';
    for Campo in Atributos.PegaPks(ATabela) do
    begin
      ASql.Add(Separador + Campo + '= :' + Campo);
      Separador := ' and ';
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlSelect(ATabela: TTabela;
  ACamposWhere: array of string): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    ASql.Add('Select * from ' + TAtributos.Get.PegaNomeTab(ATabela));
    ASql.Add('Where 1=1');
    Separador := ' and ';
    for Campo in ACamposWhere do
      ASql.Add(Separador + Campo + '= :' + Campo);
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlSelect(ATabela: TTabela; ACampos,
  ACamposWhere: array of string): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    ASql.Add('Select ');
    if Length(ACampos)>0 then
    begin
      Separador := '';
      for Campo in ACampos do
      begin
        ASql.Add(Separador + Campo);
        Separador := ',';
      end;
    end
    else
      ASql.Add('*');
    ASql.Add(' from ' + TAtributos.Get.PegaNomeTab(ATabela));
    ASql.Add('Where 1=1');
    Separador := ' and ';
    for Campo in ACamposWhere do
      ASql.Add(Separador + Campo + '= :' + Campo);
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

{ TTabela }

procedure TTabela.CopyProps(From: TTabela);
var
  Contexto: TRttiContext;
  TipoRtti, TipoFrom: TRttiType;
  PropRtti, PropFrom: TRttiProperty;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(Self.ClassType);
    TipoFrom := Contexto.GetType(From.ClassType);
    for PropRtti in TipoRtti.GetProperties do
    begin
      for PropFrom in TipoFrom.GetProperties do
        if SameText(PropFrom.Name, PropRtti.Name) then
        begin
          if PropRtti.PropertyType.TypeKind = tkClass then
          begin
            (PropRtti.GetValue(Self).AsObject as TTabela).CopyProps((PropFrom.GetValue(From).AsObject as TTabela));
          end
          else
            PropRtti.SetValue(Self, PropFrom.GetValue(From));
          Break;
        end;
    end;
  finally
    Contexto.Free;
  end;
end;

procedure TTabela.Limpar;
begin
  TAtributos.Get.LimparCampos(Self);
end;

{ TDaoBase }

constructor TDaoBase.Create;
begin
  FSql := TPadraoSql.Create;
end;

function TDaoBase.GetOwner(AOwner: TComponent): TComponent;
begin
  if Assigned(AOwner) then
    Result := AOwner
  else
    Result := Application;
end;

procedure TDaoBase.SetarDadosFromDataSet(ADataset: TDataset; PropRtti: TRttiProperty; Objeto: TValue; Campo: string);
var
  DataType: TFieldType;
begin
  DataType := ADataSet.FieldByName(Campo).DataType;
  case DataType of
    ftInteger:
      begin
        PropRtti.SetValue(Objeto.AsObject,
          TValue.FromVariant(ADataSet.FieldByName(Campo).AsInteger));
      end;
    ftString, ftWideString, ftWideMemo:
      begin
        PropRtti.SetValue(Objeto.AsObject,
          TValue.FromVariant(ADataSet.FieldByName(Campo).AsString));
      end;
    ftBCD, ftFMTBcd, ftFloat:
      begin
        PropRtti.SetValue(Objeto.AsObject,
          TValue.FromVariant(ADataSet.FieldByName(Campo).AsFloat));
      end;
    ftCurrency:
      begin
        PropRtti.SetValue(Objeto.AsObject,
          TValue.FromVariant(ADataSet.FieldByName(Campo).AsCurrency));
      end;
    ftDate, ftDateTime:
      begin
        PropRtti.SetValue(Objeto.AsObject,
          TValue.FromVariant(ADataSet.FieldByName(Campo).AsDateTime));
      end;
  else
    raise Exception.Create('Tipo de campo não conhecido: ' + PropRtti.PropertyType.ToString);
  end;
end;

procedure TDaoBase.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

{ TObjectFactory<T> }

function TObjectFactory<T>.CriarInstancia: T;
var
  AValue: TValue;
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  MetodoCriar: TRttiMethod;
  TipoInstancia: TRttiInstanceType;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(TypeInfo(T));
    MetodoCriar := TipoRtti.GetMethod('Create');
    if Assigned(MetodoCriar) and TipoRtti.IsInstance then
    begin
      TipoInstancia := TipoRtti.AsInstance;
      AValue := MetodoCriar.Invoke(TipoInstancia.MetaclassType, []);
      Result := AValue.AsType<T>;
    end;
  finally
    Contexto.Free;
  end;
end;

class function TObjectFactory<T>.Get: IObjectFactory<T>;
begin
  Result := TObjectFactory<T>.Create;
end;

end.
