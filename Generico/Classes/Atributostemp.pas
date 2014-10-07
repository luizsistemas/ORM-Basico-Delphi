unit Atributos;

interface

uses
  Base, Rtti, System.Classes;

type
  TTipoCampo = (tcNormal, tcPK, tcRequerido);

  TCamposAnoni = record
    NomeTabela: string;
    Sep: string;
    PKs: TResultArray;
    TipoRtti: TRttiType;
  end;

  TFuncReflexao = reference to function(ACampos: TCamposAnoni): Integer;

  TNomeTabela = class(TCustomAttribute)
  private
    FNomeTabela: string;
  public
    constructor Create(ANomeTabela: string);
    property NomeTabela: string read FNomeTabela write FNomeTabela;
  end;

  TCampo = class(TCustomAttribute)
  private
    FDescricao: string;
    FTipoCampo: TTipoCampo;
    procedure SetDescricao(const Value: string);
    procedure SetTipoCampo(const Value: TTipoCampo);
  public
    constructor Create(ANome: string; ATipo: TTipoCampo = tcNormal);

    property Descricao: string read FDescricao write SetDescricao;
    property TipoCampo: TTipoCampo read FTipoCampo write SetTipoCampo;
  end;

  //Reflection para os comandos Sql
  function ReflexaoSQL(ATabela: TTabela; AnoniComando: TFuncReflexao): Integer;

  function PegaNomeTab(ATabela : TTabela): string;
  function PegaPks(ATabela : TTabela): TResultArray;
  function ValidaTabela(ATabela : TTabela): Boolean;


implementation

uses
  System.TypInfo, System.SysUtils, Forms, Winapi.Windows;

function ReflexaoSQL(ATabela: TTabela; AnoniComando: TFuncReflexao): Integer;
var
  ACampos: TCamposAnoni;
  Contexto  : TRttiContext;
begin
  ACampos.NomeTabela := PegaNomeTab(ATabela);

  if ACampos.NomeTabela = EmptyStr then
    raise Exception.Create('Informe o Atributo NomeTabela na classe ' +
      ATabela.ClassName);

  ACampos.PKs   := PegaPks(ATabela);

  if Length(ACampos.PKs) = 0 then
    raise Exception.Create('Informe campos da chave primária na classe ' +
      ATabela.ClassName);

  Contexto  := TRttiContext.Create;
  try
    ACampos.TipoRtti := Contexto.GetType(ATabela.ClassType);

    //executamos os comandos Sql através do método anônimo
    ACampos.Sep := '';
    Result := AnoniComando(ACampos);

  finally
    Contexto.free;
  end;
end;

function PegaNomeTab(ATabela : TTabela): string;
var
  Contexto  : TRttiContext;
  TipoRtti : TRttiType;
  AtribRtti : TCustomAttribute;
begin
  Contexto := TRttiContext.Create;
  TipoRtti := Contexto.GetType(ATabela.ClassType);
  try
    for AtribRtti in TipoRtti.GetAttributes do
      if AtribRtti Is TNomeTabela then
        begin
          Result := (AtribRtti as TNomeTabela).NomeTabela;
          Break;
        end;
  finally
    Contexto.Free;
  end;
end;

function ValidaTabela(ATabela : TTabela): Boolean;
var
  Contexto  : TRttiContext;
  TipoRtti  : TRttiType;
  PropRtti  : TRttiProperty;
  AtribRtti : TCustomAttribute;
  ValorNulo : Boolean;
  Erro      : TStringList;
begin
  Result    := True;
  ValorNulo := false;
  Erro      := TStringList.Create;
  try
    Contexto := TRttiContext.Create;
    try
      TipoRtti := Contexto.GetType(ATabela.ClassType);
      for PropRtti in TipoRtti.GetProperties do
      begin
        case PropRtti.PropertyType.TypeKind of
          tkInt64, tkInteger: ValorNulo := PropRtti.GetValue(ATabela).AsInteger <= 0;
          tkChar, tkString, tkUString: ValorNulo := Trim(PropRtti.GetValue(ATabela).AsString) = '';
          tkFloat : ValorNulo := PropRtti.GetValue(ATabela).AsCurrency <= 0;
        end;

        for AtribRtti in PropRtti.GetAttributes do
        begin
          if AtribRtti Is TCampo then
          begin
            if ((AtribRtti as TCampo).TipoCampo in [tcPK, tcRequerido]) and (ValorNulo) then
            begin
              Erro.Add('Campo ' + (AtribRtti as TCampo).Descricao + ' não informado.');
            end;
          end;
        end;
      end;
    finally
      Contexto.Free;
    end;
    if Erro.Count>0 then
    begin
      Result := False;
      Application.MessageBox(PChar(Erro.Text),'Erros foram detectados:',
      mb_ok+MB_ICONERROR);
      Exit;
    end;
  finally
    Erro.Free;
  end;
end;

function PegaPks(ATabela : TTabela): TResultArray;
var
  Contexto  : TRttiContext;
  TipoRtti  : TRttiType;
  PropRtti  : TRttiProperty;
  AtribRtti : TCustomAttribute;
  i: Integer;
begin
  Contexto := TRttiContext.Create;
  try
    TipoRtti := Contexto.GetType(ATabela.ClassType);
    i:=0;
    for PropRtti in TipoRtti.GetProperties do
      for AtribRtti in PropRtti.GetAttributes do
        if AtribRtti Is TCampo then
          if (AtribRtti as TCampo).TipoCampo=tcPK then
          begin
            SetLength(Result, i+1);
            Result[i] := PropRtti.Name;
            inc(i);
          end;
  finally
    Contexto.Free;
  end;
end;

{ TCampo }

constructor TCampo.Create(ANome: string; ATipo: TTipoCampo);
begin
  FDescricao      := ANome;
  FTipoCampo := ATipo;
end;

procedure TCampo.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TCampo.SetTipoCampo(const Value: TTipoCampo);
begin
  FTipoCampo := Value;
end;

{ TNomeTabela }

constructor TNomeTabela.Create(ANomeTabela: string);
begin
  FNomeTabela := ANomeTabela;
end;

end.
