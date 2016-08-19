unit udmPrin;

interface

uses
  System.SysUtils, System.Classes, Lca.Orm.Base, Lca.Orm.Comp.FireDac,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Comp.Client, Data.DB,
  FireDAC.Phys.IBBase, FireDAC.VCLUI.Wait, IBX.IBDatabase, IBX.IBSQL,
  Lca.Orm.Comp.IBX;

type
  TdmPrin = class(TDataModule)
    FDConnection1: TFDConnection;
    ttt: TFDTransaction;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    IBDatabase1: TIBDatabase;
    tnormal: TIBTransaction;
    texec: TIBTransaction;
    IBSQL1: TIBSQL;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Dao: TDaoIbx;
  end;

var
  dmPrin: TdmPrin;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmPrin.DataModuleCreate(Sender: TObject);
begin
//   configuração da conexão - utilizando FireDac
//  with FDConnection1 do
//  begin
//    Connected := False;
//    Params.Database := BancoDados;
//    Params.UserName := Usuario;
//    Params.Password := senha;
//    TFDPhysFBConnectionDefParams(FDConnection1.Params).Server := Server;
//    dbSeguros.Connected := True;
//  end;
  Dao := TDaoIBX.Create(ibdatabase1, texec);
end;

procedure TdmPrin.DataModuleDestroy(Sender: TObject);
begin
  Dao.Free;
end;

end.
