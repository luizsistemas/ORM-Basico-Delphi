unit Lca.Orm.GerarClasseZeos;

interface

uses
  Lca.Orm.Base, Lca.Orm.GerarClasse, DB, Lca.Orm.Comp.Zeos, SysUtils;

type
  TGerarClasseZeos = class(TGerarClasse)
  private
    FDao: TDaoZeos;
  protected
    function GetCamposPK: string; override;
    procedure GerarFieldsProperties; override;
  public
    constructor Create(AClasseBanco: IBaseGerarClasseBanco; ADao: TDaoZeos);
  end;

implementation

{ TGerarClasseZeos }

constructor TGerarClasseZeos.Create(AClasseBanco: IBaseGerarClasseBanco;
  ADao: TDaoZeos);
begin
  inherited Create(AClasseBanco);
  FDao := ADao;
end;

procedure TGerarClasseZeos.GerarFieldsProperties;
var
  Ds: TDataSet;
begin
  inherited;
  Ds := FDao.ConsultaSql(GerarClasseBanco.GetSQLCamposTabela(FTabela)).Dataset;
  GerarClasseBanco.GerarFields(Ds, Resultado);
  GerarClasseBanco.GerarProperties(Ds, Resultado, GetCamposPK);
end;

function TGerarClasseZeos.GetCamposPK: string;
var
  Sep: string;
  Ds: TDataSet;
begin
  Sep := '';
  Ds := FDao.ConsultaSql(GerarClasseBanco.GetSQLCamposPK(FTabela)).Dataset;
  while not Ds.Eof do
  begin
    if Result <> '' then
      Sep := ',';
    Result := Result + Sep + Trim(Ds.FieldByName('CAMPO').AsString);
    Ds.Next;
  end;
end;

end.
