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

uses DB, SysUtils, Classes, Rtti, System.TypInfo,
  System.Generics.Collections;

type
  TCamposArray = array of string;
  TFlagCampos = (fcAdd, fcIgnore);

  TTabela = class
  end;

  IBaseSql = interface
    ['{3890762A-9CF2-46C3-A75C-62947D3DAD7B}']

    // geração do sql padrao
    function GerarSqlInsert(ATabela: TTabela; TipoRtti: TRttiType;
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
    function GerarSqlInsert(ATabela: TTabela; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;

    function GerarSqlUpdate(ATabela: TTabela; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;

    function GerarSqlDelete(ATabela: TTabela): string; virtual;

    function GerarSqlSelect(ATabela: TTabela): string; overload;

    function GerarSqlSelect(ATabela: TTabela; ACamposWhere: array of string): string;
       overload;

    function GerarSqlSelect(ATabela: TTabela; ACampos: array of string;
      ACamposWhere: array of string): string; overload;
  end;

  IQueryParams = interface
  ['{FBE0114E-931B-44FB-8325-45A68D2DE4E3}']
  // configura parâmentro para cada tipo de dado
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

  IDaoBase = interface
  ['{6E2AFB66-465B-4924-9221-88E283E81EA7}']
  // configura e executa a query
    function ExecutaQuery: Integer;

  // gerar classe
    function GerarClasse(ATabela, ANomeUnit: string; ANomeClasse: string = ''): string;

  // pega campo autoincremento
    function GetID(ATabela:TTabela; ACampo: string): Integer;

  // comandos crud
    function Inserir(ATabela: TTabela): Integer; overload;
    function Inserir(ATabela: TTabela; ACampos: array of string;
      AFlag: TFlagCampos = fcIgnore): Integer; overload;

    function Salvar(ATabela: TTabela): Integer; overload;
    function Salvar(ATabela: TTabela; ACampos: array of string; AFlag: TFlagCampos = fcAdd): Integer; overload;

    function Excluir(ATabela: TTabela): Integer; overload;
    function Excluir(ATabela: TTabela; AWhere: array of string): Integer; overload;
    function Excluir(ATabela: string; AWhereValue: string): Integer; overload;
    function ExcluirTodos(ATabela: TTabela): Integer; overload;

    function Buscar(ATabela: TTabela): Integer;

    // dataset para as consultas
    function ConsultaAll(ATabela: TTabela): TDataSet;
    function ConsultaSql(ASql: string): TDataSet; overload;
    function ConsultaSql(ASql: string; const ParamList: Array of Variant): TDataSet; overload;
    function ConsultaSql(ATabela: string; AWhere: string): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACamposWhere: array of string): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string): TDataSet; overload;
    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere, AOrdem: array of string; TipoOrdem: Integer = 0): TDataSet; overload;

    // limpar campos da tabela
    procedure Limpar(ATabela: TTabela);

    // comandos transação
    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function  InTransaction: Boolean;
  end;

  IBaseGerarClasseBanco = Interface
  ['{D82EC768-996A-4E06-A59E-0C87CB305D0E}']

     //obtem sql com nome, tamanho e tipo dos campos
    function GetSQLCamposTabela(ATabela: string): string;

    //obtem sql com chave primárias
    function GetSQLCamposPK(ATabela: string): string;

    procedure GerarFields(Ads: TDataSet; AResult: TStrings);
    procedure GerarProperties(Ads: TDataSet; AResult: TStrings; ACamposPK: string);
  End;

implementation

uses Lca.Orm.Atributos;

{ PadraoSql}
function TPadraoSql.GerarSqlDelete(ATabela: TTabela): string;
var
  Campo, Separador: string;
  ASql: TStringList;
  Atributos: IAtributos;
begin
  Atributos := TAtributos.Create;
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Delete from ' + Atributos.PegaNomeTab(ATabela));
      Add('Where');
      Separador := '';
      for Campo in Atributos.PegaPks(ATabela) do
      begin
        Add(Separador + Campo + '= :' + Campo);
        Separador := ' and ';
      end;
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlInsert(ATabela: TTabela; TipoRtti: TRttiType;
  ACampos: array of string; AFlag: TFlagCampos): string;
var
  Separador: string;
  ASql: TStringList;
  PropRtti: TRttiProperty;
  Atributos: IAtributos;
begin
  Atributos := TAtributos.Create;
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Insert into ' + Atributos.PegaNomeTab(ATabela));
      Add('(');

      // campos da tabela
      Separador := '';
      for PropRtti in TipoRtti.GetProperties do
      begin
        if Length(ACampos) > 0 then
          if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
            ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
            continue;

        Add(Separador + PropRtti.Name);
        Separador := ',';
      end;
      Add(')');

      // parâmetros
      Add('Values (');
      Separador := '';

      for PropRtti in TipoRtti.GetProperties do
      begin
        if Length(ACampos) > 0 then
          if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
            ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
            continue;

        Add(Separador + ':' + PropRtti.Name);
        Separador := ',';
      end;
      Add(')');
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
    with ASql do
    begin
      Add('Select * from ' + Atributos.PegaNomeTab(ATabela));
      Add('Where');
      Separador := '';
      for Campo in Atributos.PegaPks(ATabela) do
      begin
        Add(Separador + Campo + '= :' + Campo);
        Separador := ' and ';
      end;
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlSelect(ATabela: TTabela; ACamposWhere: array of string): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Select * from ' + TAtributos.Get.PegaNomeTab(ATabela));
      Add('Where 1=1');
      Separador := ' and ';
      for Campo in ACamposWhere do
        Add(Separador + Campo + '= :' + Campo);
    end;
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
    with ASql do
    begin
      Add('Select ');

      if Length(ACampos)>0 then
      begin
        Separador := '';
        for Campo in ACampos do
        begin
          Add(Separador + Campo);
          Separador := ',';
        end;
      end
      else
        Add('*');

      Add(' from ' + TAtributos.Get.PegaNomeTab(ATabela));

      Add('Where 1=1');

      Separador := ' and ';

      for Campo in ACamposWhere do
        Add(Separador + Campo + '= :' + Campo);
    end;
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
begin
  Atributos := TAtributos.Create;
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Update ' + Atributos.PegaNomeTab(ATabela));
      Add('set');

      // campos da tabela
      Separador := '';
      for PropRtti in TipoRtti.GetProperties do
      begin
        if Length(ACampos) > 0 then
          if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
            ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
            continue;

        Add(Separador + PropRtti.Name + '=:' + PropRtti.Name);
        Separador := ',';
      end;
      Add('where');

      // parâmetros da cláusula where
      Separador := '';
      for Campo in Atributos.PegaPks(ATabela) do
      begin
        Add(Separador + Campo + '= :' + Campo);
        Separador := ' and ';
      end;
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

end.
