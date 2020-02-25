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
    Dao: TDaoFiredac;
  end;

var
  dmPrin: TdmPrin;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmPrin.DataModuleCreate(Sender: TObject);
begin
  FDConnection1.Connected := False;
  FDConnection1.Params.Database := 'F:\Delphi10\Projetos\Persistencia\Teste\Bd\BANCOTESTE.FDB';
  FDConnection1.Params.UserName := 'SYSDBA';
  FDConnection1.Params.Password := '02025626';
  TFDPhysFBConnectionDefParams(FDConnection1.Params).Server := 'localhost';
  FDConnection1.Connected := True;
  Dao := TDaoFiredac.Create(FDConnection1, ttt);
end;

procedure TdmPrin.DataModuleDestroy(Sender: TObject);
begin
  Dao.Free;
end;

end.
