unit Funcionario;

interface

uses
  Lca.Orm.Atributos, Lca.Orm.Base, Cidade, Depto;

type
  [AttTabela('FUNCIONARIO')]
  TFuncionario = class(TTabela)
  private
    FBairro: string;
    FSalario: Currency;
    FId: Integer;
    FDepto: TDepto;
    FNome: string;
    FCidade: TCidade;
    FEndereco: string;
    FCpf: string;
  public
    constructor Create;
    destructor Destroy; override;
    [AttPK]
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property Cpf: string read FCpf write FCpf;
    property Endereco: string read FEndereco write FEndereco;
    property Bairro: string read FBairro write FBairro;
    [AttNotNull('Cidade')]
    [AttFk('IDCIDADE', 'CIDADE', 'ID')]
    property Cidade: TCidade read FCidade write FCidade;
    [AttNotNull('Departamento')]
    [AttFk('IDDEPTO', 'DEPTO', 'ID')]
    property Depto: TDepto read FDepto write FDepto;
    property Salario: Currency read FSalario write FSalario;
  end;

implementation

{ TFuncionario }

constructor TFuncionario.Create;
begin
  FCidade := TCidade.Create;
  FDepto := TDepto.Create;
end;

destructor TFuncionario.Destroy;
begin
  FCidade.Free;
  FDepto.Free;
  inherited;
end;

end.
