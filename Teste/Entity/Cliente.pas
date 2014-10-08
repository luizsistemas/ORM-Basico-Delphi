unit Cliente;

interface

uses PrsBase, PrsAtributos, Cidade;

type
  [AttTabela('Cliente')]
  TCliente = class(TTabela)
  private
    FID: Integer;
    FNOME: string;
    FCIDADEID: Integer;
    procedure SetID(const Value: Integer);
    procedure SetNOME(const Value: string);
    procedure SetCIDADEID(const Value: Integer);
  public
    [AttPk]
    [AttNotNull('Código do cliente')]
    property ID : Integer read FID write SetID;
    [AttNotNull('Nome do Cliente')]
    property NOME : string read FNOME write SetNOME;
    [AttNotNull('Código da Cidade')]
    property CIDADEID: Integer read FCIDADEID write SetCIDADEID;
  end;

implementation

{ TCliente }

procedure TCliente.SetCIDADEID(const Value: Integer);
begin
  FCIDADEID := Value;
end;

procedure TCliente.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TCliente.SetNOME(const Value: string);
begin
  FNOME := Value;
end;

end.
