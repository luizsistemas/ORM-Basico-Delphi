unit PrsBase;

interface

uses DB, SysUtils, Classes, Rtti, System.TypInfo,
  System.Generics.Collections;

type
  TResultArray = array of string;

  TTabela = class(TObject)
  end;

  TRecParams = record
    Prop: TRttiProperty;
    Campo: string;
    Tabela: TTabela;
    Qry: TObject;
  end;

  TConexaoBase = class
  private
    FSenha: string;
    FPorta: string;
    FUsuario: string;
    FLocalBD: string;
    procedure SetPorta(const Value: string);
    procedure SetSenha(const Value: string);
    procedure SetUsuario(const Value: string);
    procedure SetLocalBD(const Value: string);
  public
    function Conectado: Boolean; virtual; abstract;
    procedure Conecta; virtual; abstract;

    property LocalBD: string read FLocalBD write SetLocalBD;
    property Usuario: string read FUsuario write SetUsuario;
    property Senha: string read FSenha write SetSenha;
    property Porta: string read FPorta write SetPorta;
  end;

  TTransacaoBase = class
  public
    function InTransaction: Boolean; virtual; abstract;

    procedure StartTransaction; virtual; abstract;
    procedure Commit; virtual; abstract;
    procedure RollBack; virtual; abstract;
  end;

  TDaoBase = class(TObject)
  private
    procedure SetDataSet(const Value: TDataSet);
  protected
    FDataSet: TDataSet;

    function PropExiste(ACampo: string; Prop: TRttiProperty; RttiType: TRttiType): Boolean;

    // geração do sql padrao
    function GerarSqlInsert(ATabela: TTabela; TipoRtti: TRttiType)
      : string; virtual;
    function GerarSqlUpdate(ATabela: TTabela; TipoRtti: TRttiType)
      : string; virtual;
    function GerarSqlDelete(ATabela: TTabela): string; virtual;
    function GerarSqlSelect(ATabela: TTabela): string; overload; virtual;
    function GerarSqlSelect(ATabela: TTabela; ACampos: array of string): string;
       overload; virtual;

    // métodos abstrados para os tipos de campos a serem utilizados nas classes filhas
    procedure QryParamInteger(ARecParams: TRecParams); virtual; abstract;
    procedure QryParamString(ARecParams: TRecParams); virtual; abstract;
    procedure QryParamDate(ARecParams: TRecParams); virtual; abstract;
    procedure QryParamCurrency(ARecParams: TRecParams); virtual; abstract;
    procedure QryParamVariant(ARecParams: TRecParams); virtual; abstract;

    // métodos para setar os variados tipos de campos
    procedure SetaCamposInteger(ARecParams: TRecParams); virtual; abstract;
    procedure SetaCamposString(ARecParams: TRecParams); virtual; abstract;
    procedure SetaCamposDate(ARecParams: TRecParams); virtual; abstract;
    procedure SetaCamposCurrency(ARecParams: TRecParams); virtual; abstract;

    function ExecutaQuery: Integer; virtual; abstract;

    // configura parâmetros da query
    procedure ConfiguraParametro(AProp: TRttiProperty; ACampo: string;
      ATabela: TTabela; AQry: TObject); virtual;

    // seta os dados da query em TTabela
    procedure SetaDadosTabela(AProp: TRttiProperty; ACampo: string;
      ATabela: TTabela; AQry: TObject);
  public
    // PKs
    function CamposPK(ATabela: TTabela): TResultArray;

    // dataset para as consultas
    function ConsultaSql(ASql: string): TDataSet; virtual; abstract;
    function ConsultaTab(ATabela: TTabela; ACampos: array of string): TDataSet;
      virtual; abstract;


    // pega campo autoincremento
    function GetID(ATabela:TTabela; ACampo: string): Integer;
      virtual; abstract;

    // recordcount
    function GetRecordCount(ATabela: TTabela; ACampos: array of string):
      Integer; virtual; abstract;

    // crud
    function Inserir(ATabela: TTabela): Integer; virtual; abstract;
    function Salvar(ATabela: TTabela): Integer; virtual; abstract;
    function Excluir(ATabela: TTabela): Integer; virtual; abstract;
    function Buscar(ATabela: TTabela): Integer; virtual; abstract;

    property DataSet: TDataSet read FDataSet write SetDataSet;
  end;

implementation

uses PrsAtributos;

{ TConexaoBase }

procedure TConexaoBase.SetLocalBD(const Value: string);
begin
  FLocalBD := Value;
end;

procedure TConexaoBase.SetPorta(const Value: string);
begin
  FPorta := Value;
end;

procedure TConexaoBase.SetSenha(const Value: string);
begin
  FSenha := Value;
end;

procedure TConexaoBase.SetUsuario(const Value: string);
begin
  FUsuario := Value;
end;

{ DaoBase }
procedure TDaoBase.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

function TDaoBase.CamposPK(ATabela: TTabela): TResultArray;
begin
  Result := PegaPks(ATabela);
end;

procedure TDaoBase.ConfiguraParametro(AProp: TRttiProperty; ACampo: string;
  ATabela: TTabela; AQry: TObject);
var
  Params: TRecParams;
begin
  Params.Prop := AProp;
  Params.Campo := ACampo;
  Params.Tabela := ATabela;
  Params.Qry := AQry;

  case AProp.PropertyType.TypeKind of
    tkInt64, tkInteger:
      QryParamInteger(Params);
    tkChar, tkString, tkUString:
      QryParamString(Params);
    tkFloat:
      begin
        if CompareText(AProp.PropertyType.Name, 'TDateTime') = 0 then
          QryParamDate(Params)
        else
          QryParamCurrency(Params);
      end;
    tkVariant:
      QryParamVariant(Params);
  else
    raise Exception.Create('Tipo de campo não conhecido: ' +
      AProp.PropertyType.ToString);
  end;
end;

function TDaoBase.GerarSqlDelete(ATabela: TTabela): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Delete from ' + PegaNomeTab(ATabela));
      Add('Where');
      Separador := '';
      for Campo in PegaPks(ATabela) do
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

function TDaoBase.GerarSqlInsert(ATabela: TTabela; TipoRtti: TRttiType): string;
var
  Separador: string;
  ASql: TStringList;
  PropRtti: TRttiProperty;
begin
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Insert into ' + PegaNomeTab(ATabela));
      Add('(');

      // campos da tabela
      Separador := '';
      for PropRtti in TipoRtti.GetProperties do
      begin
        Add(Separador + PropRtti.Name);
        Separador := ',';
      end;
      Add(')');

      // parâmetros
      Add('Values (');
      Separador := '';
      for PropRtti in TipoRtti.GetProperties do
      begin
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

function TDaoBase.GerarSqlSelect(ATabela: TTabela): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Select * from ' + PegaNomeTab(ATabela));
      Add('Where');
      Separador := '';
      for Campo in PegaPks(ATabela) do
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

function TDaoBase.GerarSqlSelect(ATabela: TTabela; ACampos: array of string): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Select * from ' + PegaNomeTab(ATabela));
      Add('Where 1=1');
      Separador := ' and ';
      for Campo in ACampos do
        Add(Separador + Campo + '= :' + Campo);
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TDaoBase.GerarSqlUpdate(ATabela: TTabela; TipoRtti: TRttiType): string;
var
  Campo, Separador: string;
  ASql: TStringList;
  PropRtti: TRttiProperty;
begin
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Update ' + PegaNomeTab(ATabela));
      Add('set');

      // campos da tabela
      Separador := '';
      for PropRtti in TipoRtti.GetProperties do
      begin
        Add(Separador + PropRtti.Name + '=:' + PropRtti.Name);
        Separador := ',';
      end;
      Add('where');

      // parâmetros da cláusula where
      Separador := '';
      for Campo in PegaPks(ATabela) do
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

function TDaoBase.PropExiste(ACampo: string; Prop: TRttiProperty;
  RttiType: TRttiType): Boolean;
begin
  Result := False;
  for Prop in RttiType.GetProperties do
  begin
    if CompareText(Prop.Name, ACampo) = 0 then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TDaoBase.SetaDadosTabela(AProp: TRttiProperty; ACampo: string;
  ATabela: TTabela; AQry: TObject);
var
  Params: TRecParams;
begin
  Params.Prop := AProp;
  Params.Campo := ACampo;
  Params.Tabela := ATabela;
  Params.Qry := AQry;

  case AProp.PropertyType.TypeKind of
    tkInt64, tkInteger:
      begin
        SetaCamposInteger(Params);
      end;
    tkChar, tkString, tkUString:
      begin
        SetaCamposString(Params);
      end;
    tkFloat:
      begin
        if CompareText(AProp.PropertyType.Name, 'TDateTime') = 0 then
          SetaCamposDate(Params)
        else
          SetaCamposCurrency(Params);
      end;
  else
    raise Exception.Create('Tipo de campo não conhecido: ' +
      AProp.PropertyType.ToString);
  end;
end;

end.
