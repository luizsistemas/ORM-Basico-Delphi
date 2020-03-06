unit Depto;

interface

uses
  Lca.Orm.Base, Lca.Orm.Atributos;

type
  [AttTabela('DEPTO')]
  TDepto = class(TTabela)
  private
    FId: Integer;
    FNome: string;
  public
    [AttPK]
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
  end;

implementation

end.
