unit PrsAtributos;

interface

uses
  PrsBase, Rtti, System.Classes;

type
  // TTipoCampo = (tcNormal, tcPK, tcRequerido);

  TCamposAnoni = record
    NomeTabela: string;
    Sep: string;
    PKs: TResultArray;
    TipoRtti: TRttiType;
  end;

  TFuncReflexao = reference to function(ACampos: TCamposAnoni): Integer;

  AttTabela = class(TCustomAttribute)
  private
    FNome: string;
  public
    constructor Create(ANomeTabela: string);
    property Nome: string read FNome write FNome;
  end;

  /// <summary>
  /// Atributos de Chave Primaria e Relacionamentos
  /// </summary>

  AttPK = class(TCustomAttribute)
  end;

  /// <summary>
  /// Atributos de Validação
  /// </summary>

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

  // Reflection para os comandos Sql
function ReflexaoSQL(ATabela: TTabela; AnoniComando: TFuncReflexao): Integer;

function PegaNomeTab(ATabela: TTabela): string;
function PegaPks(ATabela: TTabela): TResultArray;
procedure ValidaTabela(ATabela: TTabela);
procedure SetarPropriedade(AObj: TObject; AProp: string; AValor: Variant);

implementation

uses
  System.TypInfo, System.SysUtils, Forms, Winapi.Windows, System.Variants;

procedure SetarPropriedade(AObj: TObject; AProp: string; AValor: Variant);
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
    Contexto.free;
  end;
end;

function ReflexaoSQL(ATabela: TTabela; AnoniComando: TFuncReflexao): Integer;
var
  ACampos: TCamposAnoni;
  Contexto: TRttiContext;
begin
  ACampos.NomeTabela := PegaNomeTab(ATabela);

  if ACampos.NomeTabela = EmptyStr then
    raise Exception.Create('Informe o Atributo NomeTabela na classe ' +
      ATabela.ClassName);

  ACampos.PKs := PegaPks(ATabela);

  if Length(ACampos.PKs) = 0 then
    raise Exception.Create('Informe campos da chave primária na classe ' +
      ATabela.ClassName);

  Contexto := TRttiContext.Create;
  try
    ACampos.TipoRtti := Contexto.GetType(ATabela.ClassType);

    // executamos os comandos Sql através do método anônimo
    ACampos.Sep := '';
    Result := AnoniComando(ACampos);

  finally
    Contexto.free;
  end;
end;

function PegaNomeTab(ATabela: TTabela): string;
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
    Contexto.free;
  end;
end;

procedure ValidaTabela(ATabela: TTabela);
var
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  AtribRtti: TCustomAttribute;
  ListaErros: TStrings;
begin
  try
    if not Assigned(ATabela) then
      raise Exception.Create('Tabela não foi passada no parâmetro!');

    ListaErros := TStringList.Create;
    try
      Contexto := TRttiContext.Create;
      try
        TipoRtti := Contexto.GetType(ATabela.ClassType);
        for PropRtti in TipoRtti.GetProperties do
        begin
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
      finally
        Contexto.free;
      end;

      if ListaErros.Count > 0 then
        raise Exception.Create(PChar(ListaErros.Text));
    finally
      ListaErros.free;
    end;
  except
    raise;
  end;
end;

function PegaPks(ATabela: TTabela): TResultArray;
var
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropRtti: TRttiProperty;
  AtribRtti: TCustomAttribute;
  i: Integer;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    i := 0;
    for PropRtti in TipoRtti.GetProperties do
      for AtribRtti in PropRtti.GetAttributes do
        if AtribRtti Is AttPK then
        begin
          SetLength(Result, i + 1);
          Result[i] := PropRtti.Name;
          inc(i);
        end;
  finally
    Contexto.free;
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
  FMensagemErro := 'Campo ' + ANomeCampo + ' com valor inválido!';
end;

function AttMinValue.Validar(Value: Double): Boolean;
begin
  Result := Value >= FValorMinimo;
end;

constructor AttMaxValue.Create(ValorMaximo: Double; const ANomeCampo: string);
begin
  FValorMaximo := ValorMaximo;
  FMensagemErro := 'Campo ' + ANomeCampo + ' com valor inválido!';
end;

function AttMaxValue.Validar(Value: Double): Boolean;
begin
  Result := Value <= FValorMaximo;
end;

{ TValidaStringNaoNulo }

constructor AttNotNull.Create(const ANomeCampo: string);
begin
  FMensagemErro := 'Campo obrigatório não informado: ' + ANomeCampo ;
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

end.
