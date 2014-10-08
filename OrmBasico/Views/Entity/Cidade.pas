unit Cidade;

interface

uses PrsBase, PrsAtributos;

type
  [AttTabela('Cidade')]
  TCidade = class (TTabela)
  private
    FIBGE: integer;
    FUF: string;
    FID: Integer;
    FNome: string;
    FDataCad: TDateTime;
    procedure SetIBGE(const Value: integer);
    procedure SetID(const Value: Integer);
    procedure SetNome(const Value: string);
    procedure SetUF(const Value: string);
    procedure SetDataCad(const Value: TDateTime);
  public
    [AttPK]
    [AttNotNull('Código da cidade')]
    property ID: Integer read FID write SetID;
    [AttNotNull('Nome da cidade')]
    property Nome: string read FNome write SetNome;
    [AttNotNull('UF')]
    property UF: string read FUF write SetUF;
    [AttNotNull('Código IBGE')]
    property IBGE: integer read FIBGE write SetIBGE;
    property DataCad: TDateTime read FDataCad write SetDataCad;
  end;

implementation

{ TCidade }

procedure TCidade.SetDataCad(const Value: TDateTime);
begin
  FDataCad := Value;
end;

procedure TCidade.SetIBGE(const Value: integer);
begin
  FIBGE := Value;
end;

procedure TCidade.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TCidade.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TCidade.SetUF(const Value: string);
begin
  FUF := Value;
end;

end.
