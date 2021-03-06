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
unit Lca.Orm.Atributos;

interface

uses
  Lca.Orm.Base, Rtti, System.Classes, Data.DB;

type
  AttTabela = class(TCustomAttribute)
  private
    FNome: string;
  public
    constructor Create(ANomeTabela: string);
    property Nome: string read FNome write FNome;
  end;

  AttPK = class(TCustomAttribute)
  end;

  AttFk = class(TCustomAttribute)
  private
    FCampoFk,
    FTabela,
    FPk: string;
    FTipo: TTypeKind;
  public
    constructor Create(CampoFk, Tabela, Pk: string; Tipo: TTypeKind = tkInteger);
    property CampoFk: string read FCampoFk;
    property Tabela: string read FTabela;
    property Pk: string read FPk;
  end;

  AttBaseValidacao = class(TCustomAttribute)
  private
    FMensagemErro: string;
    procedure SetMessagemErro(const Value: string);
  public
    property MessagemErro: string read FMensagemErro write SetMessagemErro;
  end;

  AttNotNull = class(AttBaseValidacao)
  public
    constructor Create(const ANomeCampo: string);
    function ValidarString(Value: string): Boolean;
    function ValidarInteger(Value: Integer): Boolean;
    function ValidarFloat(Value: Double): Boolean;
    function ValidarData(Value: Double): Boolean;
  end;

  AttMinValue = class(AttBaseValidacao)
  private
    FValorMinimo: Double;
  public
    constructor Create(ValorMinimo: Double; const ANomeCampo: string);
    function Validar(Value: Double): Boolean;
  end;

  AttMaxValue = class(AttBaseValidacao)
  private
    FValorMaximo: Double;
  public
    constructor Create(ValorMaximo: Double; const ANomeCampo: string);
    function Validar(Value: Double): Boolean;
  end;

  IAtributos = interface
    ['{26CCA2DF-174A-48BE-A48D-7758294159A6}']
    function PropExiste(ACampo: string; Prop: TRttiProperty;
      RttiType: TRttiType): Boolean;

    function GetAtribFK(PropRtti: TRttiProperty): AttFk;

    function PegaNomeTab(ATabela: TTabela): string;
    function PegaPks(ATabela: TTabela): TCamposArray;
    function LocalizaCampo(ACampo: string; ACampos: array of string): Boolean;

    procedure ValidaTabela(ATabela: TTabela; ACampos: array of string;
      AFlag: TFlagCampos = fcAdd);

    procedure SetarPropriedade(AObj: TDataSet; AProp: string; AValor: Variant);
    procedure SetarDadosTabela(AProp: TRttiProperty; ACampo: string;
      ATabela: TTabela; AQry: TDataSet; AParams: IQueryParams);

    procedure ConfiguraParametro(AProp: TRttiProperty; ACampo: string;
      ATabela: TTabela; AQry: TDataSet; AParams: IQueryParams);

    procedure LimparCampos(ATabela: TTabela);
  end;

  TAtributos = class(TInterfacedObject, IAtributos)
  private
  public
    class function Get: IAtributos;

    function GetAtribFK(PropRtti: TRttiProperty): AttFk;

    function PropExiste(ACampo: string; Prop: TRttiProperty;
      RttiType: TRttiType): Boolean;

    function PegaNomeTab(ATabela: TTabela): string;
    function PegaPks(ATabela: TTabela): TCamposArray;
    function LocalizaCampo(ACampo: string; ACampos: array of string): Boolean;

    procedure ValidaTabela(ATabela: TTabela; ACampos: array of string;
      AFlag: TFlagCampos = fcAdd);

    procedure SetarPropriedade(AObj: TDataSet; AProp: string; AValor: Variant);
    procedure SetarDadosTabela(AProp: TRttiProperty; ACampo: string;
      ATabela: TTabela; AQry: TDataSet; AParams: IQueryParams);

    procedure ConfiguraParametro(AProp: TRttiProperty; ACampo: string;
      ATabela: TTabela; AQry: TDataSet; AParams: IQueryParams);

    procedure LimparCampos(ATabela: TTabela);
  end;

implementation

uses
  System.TypInfo, System.SysUtils, Vcl.Forms, Winapi.Windows, System.Variants;

{ DaoBase }

procedure TAtributos.ConfiguraParametro(AProp: TRttiProperty; ACampo: string;
  ATabela: TTabela; AQry: TDataSet; AParams: IQueryParams);
begin
  case AProp.PropertyType.TypeKind of
    tkInt64, tkInteger:  AParams.SetParamInteger(AProp, ACampo, ATabela, AQry);
    tkChar, tkString, tkUString: AParams.SetParamString(AProp, ACampo, ATabela, AQry);
    tkFloat:
      begin
        if (SameText(AProp.PropertyType.Name, 'TDateTime') or SameText(AProp.PropertyType.Name, 'TDate')) then
          AParams.SetParamDate(AProp, ACampo, ATabela, AQry)
        else if CompareText(AProp.PropertyType.Name, 'TTime') = 0 then
          AParams.SetParamTime(AProp, ACampo, ATabela, AQry)
        else
          AParams.SetParamCurrency(AProp, ACampo, ATabela, AQry);
      end;
    tkVariant: AParams.SetParamVariant(AProp, ACampo, ATabela, AQry);
  else
    raise Exception.Create('Tipo de campo n�o conhecido: ' +
      AProp.PropertyType.ToString);
  end;
end;

function TAtributos.PropExiste(ACampo: string; Prop: TRttiProperty;
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

procedure TAtributos.LimparCampos(ATabela: TTabela);
var
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    for PropRtti in TipoRtti.GetProperties do
    begin
       case PropRtti.PropertyType.TypeKind of
         tkFloat,
         tkInteger: PropRtti.SetValue(ATabela, 0);
         tkClass:
           begin
             if not (PropRtti.GetValue(ATabela).AsObject is TTabela)  then
               Continue;
             LimparCampos((PropRtti.GetValue(ATabela).AsObject as TTabela));
           end
       else
         PropRtti.SetValue(ATabela, '');
       end;
    end;
  finally
    Contexto.Free;
  end;
end;

procedure TAtributos.SetarDadosTabela(AProp: TRttiProperty; ACampo: string;
  ATabela: TTabela; AQry: TDataSet; AParams: IQueryParams);
begin
  case AProp.PropertyType.TypeKind of
    tkInt64, tkInteger:
      begin
        AParams.SetCamposInteger(AProp, ACampo, ATabela, AQry);
      end;
    tkChar, tkString, tkUString:
      begin
        AParams.SetCamposString(AProp, ACampo, ATabela, AQry);
      end;
    tkFloat:
      begin
        if SameText(AProp.PropertyType.Name, 'TDateTime') then
          AParams.SetCamposDate(AProp, ACampo, ATabela, AQry)
        else
        if SameText(AProp.PropertyType.Name, 'TTime') then
          AParams.SetCamposTime(AProp, ACampo, ATabela, AQry)
        else
          AParams.SetCamposCurrency(AProp, ACampo, ATabela, AQry);
      end;
  else
    raise Exception.Create('Tipo de campo n�o conhecido: ' +
      AProp.PropertyType.ToString);
  end;
end;

procedure TAtributos.SetarPropriedade(AObj: TDataSet; AProp: string; AValor: Variant);
var
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(AObj.ClassType);
    for PropRtti in TipoRtti.GetProperties do
    begin
      if CompareText(PropRtti.Name, AProp) = 0 then
      begin
        PropRtti.SetValue(AObj, System.Variants.VarToStr(AValor));
      end;
    end;
  finally
    Contexto.Free;
  end;
end;

function TAtributos.PegaNomeTab(ATabela: TTabela): string;
var
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  AtribRtti: TCustomAttribute;
begin
  Contexto := TRttiContext.Create;
  TipoRtti := Contexto.GetType(ATabela.ClassType);
  try
    for AtribRtti in TipoRtti.GetAttributes do
      if AtribRtti Is AttTabela then
      begin
        Result := (AtribRtti as AttTabela).Nome;
        Break;
      end;
  finally
    Contexto.Free;
  end;
end;

function TAtributos.GetAtribFK(PropRtti: TRttiProperty): AttFk;
var
  AtribRtti: TCustomAttribute;
begin
  Result := nil;
  for AtribRtti in PropRtti.GetAttributes do
    if AtribRtti Is AttFk then
    begin
      Result := AtribRtti as AttFk;
      Break;
    end;
end;

function TAtributos.LocalizaCampo(ACampo: string; ACampos: array of string): Boolean;
var
 _Campo: string;
begin
  Result := false;
  for _Campo in ACampos do
  begin
    if LowerCase(ACampo) = LowerCase(_Campo)  then
    begin
      Result := true;
      Break;
    end;
  end;
end;

class function TAtributos.Get: IAtributos;
begin
  Result := TAtributos.Create;
end;

procedure TAtributos.ValidaTabela(ATabela: TTabela; ACampos: array of string;
  AFlag: TFlagCampos);
var
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  AtribRtti: TCustomAttribute;
  ListaErros: TStrings;
begin
  try
    if not Assigned(ATabela) then
      raise Exception.Create('Tabela n�o foi passada no par�metro!');
    ListaErros := TStringList.Create;
    try
      Contexto := TRttiContext.Create;
      try
        TipoRtti := Contexto.GetType(ATabela.ClassType);
        for PropRtti in TipoRtti.GetProperties do
        begin
          if Length(ACampos) > 0 then
          begin
            if ((AFlag=fcAdd) and (not LocalizaCampo(PropRtti.Name, ACampos))) or
              ((AFlag=fcIgnore) and (LocalizaCampo(PropRtti.Name, ACampos))) then
              Continue;
          end;
          for AtribRtti in PropRtti.GetAttributes do
          begin
            PropRtti.PropertyType.TypeKind;
            if AtribRtti is AttMinValue then
            begin
              if not AttMinValue(AtribRtti)
                .Validar(PropRtti.GetValue(ATabela).AsExtended) then
                ListaErros.Add(AttBaseValidacao(AtribRtti).MessagemErro);
            end;
            if AtribRtti is AttMaxValue then
            begin
              if not AttMinValue(AtribRtti)
                .Validar(PropRtti.GetValue(ATabela).AsExtended) then
                ListaErros.Add(AttBaseValidacao(AtribRtti).MessagemErro);
            end;
            if AtribRtti is AttNotNull then
            begin
              if not (PropRtti.PropertyType.TypeKind = tkClass) then
              begin
                case PropRtti.PropertyType.TypeKind of
                  tkFloat:
                    begin
                      if CompareText(PropRtti.PropertyType.Name, 'TDateTime') = 0
                      then
                      begin
                        if not AttNotNull(AtribRtti)
                          .ValidarData(PropRtti.GetValue(ATabela).AsExtended) then
                          ListaErros.Add(AttBaseValidacao(AtribRtti).MessagemErro);
                      end
                      else
                      begin
                        if not AttNotNull(AtribRtti)
                          .ValidarFloat(PropRtti.GetValue(ATabela).AsExtended) then
                          ListaErros.Add(AttBaseValidacao(AtribRtti).MessagemErro);
                      end;
                    end;
                  tkInteger:
                    begin
                      if not AttNotNull(AtribRtti)
                        .ValidarInteger(PropRtti.GetValue(ATabela).AsInteger) then
                        ListaErros.Add(AttBaseValidacao(AtribRtti).MessagemErro);
                    end;
                else
                  begin
                    if not AttNotNull(AtribRtti)
                      .ValidarString(PropRtti.GetValue(ATabela).AsString) then
                      ListaErros.Add(AttBaseValidacao(AtribRtti).MessagemErro);
                  end;
                end;
              end;
            end;
          end;
        end;
      finally
        Contexto.Free;
      end;
      if ListaErros.Count > 0 then
        raise Exception.Create(PChar(ListaErros.Text));
    finally
      ListaErros.Free;
    end;
  except
    raise;
  end;
end;

function TAtributos.PegaPks(ATabela: TTabela): TCamposArray;
var
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  AtribRtti: TCustomAttribute;
  I: Integer;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    I := 0;
    for PropRtti in TipoRtti.GetProperties do
      for AtribRtti in PropRtti.GetAttributes do
        if AtribRtti Is AttPK then
        begin
          SetLength(Result, I + 1);
          Result[I] := PropRtti.Name;
          Inc(I);
        end;
  finally
    Contexto.Free;
  end;
end;

{ TNomeTabela }

constructor AttTabela.Create(ANomeTabela: string);
begin
  FNome := ANomeTabela;
end;

{ TBaseValidacao }

procedure AttBaseValidacao.SetMessagemErro(const Value: string);
begin
  FMensagemErro := Value;
end;

{ TValidaIntegerMinimo }

constructor AttMinValue.Create(ValorMinimo: Double; const ANomeCampo: string);
begin
  FValorMinimo := ValorMinimo;
  FMensagemErro := 'Campo ' + ANomeCampo + ' com valor inv�lido!';
end;

function AttMinValue.Validar(Value: Double): Boolean;
begin
  Result := Value >= FValorMinimo;
end;

constructor AttMaxValue.Create(ValorMaximo: Double; const ANomeCampo: string);
begin
  FValorMaximo := ValorMaximo;
  FMensagemErro := 'Campo ' + ANomeCampo + ' com valor inv�lido!';
end;

function AttMaxValue.Validar(Value: Double): Boolean;
begin
  Result := Value <= FValorMaximo;
end;

{ TValidaStringNaoNulo }

constructor AttNotNull.Create(const ANomeCampo: string);
begin
  FMensagemErro := 'Campo obrigat�rio n�o informado: ' + ANomeCampo ;
end;

function AttNotNull.ValidarString(Value: string): Boolean;
begin
  Result := not(Value = EmptyStr);
end;

function AttNotNull.ValidarInteger(Value: Integer): Boolean;
begin
  Result := not(Value <= 0);
end;

function AttNotNull.ValidarFloat(Value: Double): Boolean;
begin
  Result := not(Value <= 0);
end;

function AttNotNull.ValidarData(Value: Double): Boolean;
begin
  Result := not(Value = 0);
end;

{ AttFk }

constructor AttFk.Create(CampoFk, Tabela, Pk: string; Tipo: TTypeKind);
begin
  FCampoFk := CampoFk;
  FTabela := Tabela;
  FPk := Pk;
  FTipo := Tipo;
end;

end.
