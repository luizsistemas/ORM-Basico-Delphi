unit Lca.Orm.GerarClasseIBX;

interface

uses
  Lca.Orm.Base, Lca.Orm.GerarClasse, DB, Lca.Orm.Comp.IBX, SysUtils;

type
  TGerarClasseIBX = class(TGerarClasse)
  private
    FDao: TDaoIBX;
  protected
    function GetCamposPK: string; override;
    procedure GerarFieldsProperties; override;
  public
    constructor Create(AClasseBanco: IBaseGerarClasseBanco; ADao: TDaoIBX);
  end;

implementation

{ TGerarClasseIBX }

constructor TGerarClasseIBX.Create(AClasseBanco: IBaseGerarClasseBanco;
  ADao: TDaoIBX);
begin
  inherited Create(AClasseBanco);
  FDao := ADao;
end;

procedure TGerarClasseIBX.GerarFieldsProperties;
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

function TGerarClasseIBX.GetCamposPK: string;
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
