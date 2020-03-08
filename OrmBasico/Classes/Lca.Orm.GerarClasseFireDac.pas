unit Lca.Orm.GerarClasseFireDac;

interface

uses
  Lca.Orm.Base, Lca.Orm.GerarClasse, DB, Lca.Orm.Comp.FireDac, SysUtils;

type
  TGerarClasseFireDac = class(TGerarClasse)
  private
    FDao: TDaoFireDac;
  protected
    function GetCamposPK: string; override;

    procedure GerarFieldsProperties; override;

  public
    constructor Create(AClasseBanco: IBaseGerarClasseBanco; ADao: TDaoFireDac);
  end;

implementation

{ TDaoFireDac }

constructor TGerarClasseFireDac.Create(AClasseBanco: IBaseGerarClasseBanco;
  ADao: TDaoFireDac);
begin
  inherited Create(AClasseBanco);

  FDao := ADao;
end;

procedure TGerarClasseFireDac.GerarFieldsProperties;
var
  Ds: TDataSet;
begin
  inherited;
  Ds := FDao.ConsultaSql(GerarClasseBanco.GetSQLCamposTabela(FTabela)).Dataset;
  try
    GerarClasseBanco.GerarFields(Ds, Resultado);
    GerarClasseBanco.GerarProperties(Ds, Resultado, GetCamposPK);
  finally
    Ds.Free;
  end;
end;

function TGerarClasseFireDac.GetCamposPK: string;
var
  Sep: string;
  Ds: TDataSet;
begin
  Sep := '';
  Ds := FDao.ConsultaSql(GerarClasseBanco.GetSQLCamposPK(FTabela)).Dataset;
  try
    while not Ds.Eof do
    begin
      if Result <> '' then
        Sep := ',';
      Result := Result + Sep + Trim(Ds.FieldByName('CAMPO').AsString);
      Ds.Next;
    end;
  finally
    Ds.Free;
  end;
end;

end.
