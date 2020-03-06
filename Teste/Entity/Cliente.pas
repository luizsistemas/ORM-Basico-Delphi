unit Cliente;

interface

uses Lca.Orm.Base, Lca.Orm.Atributos;

type
  [AttTabela('Cliente')]
  TCliente = class(TTabela)
  private
    FId: Integer;
    FNome: string;
    FCidadeid: Integer;
  public
    [AttPk]
    [AttNotNull('Código do cliente')]
    property Id : Integer read FId write FId;
    [AttNotNull('Nome do cliente')]
    property Nome : string read FNome write FNome;
    [AttNotNull('Código da cidade')]
    property CidadeId: Integer read FCidadeid write FCidadeid;
  end;

implementation

end.
