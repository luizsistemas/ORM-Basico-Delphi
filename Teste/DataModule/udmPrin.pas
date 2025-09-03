unit udmPrin;

interface

uses
  System.SysUtils, System.Classes, Lca.Orm.Base, Lca.Orm.Comp.FireDac,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Comp.Client, Data.DB,
  FireDAC.Phys.IBBase, FireDAC.VCLUI.Wait, IBX.IBDatabase, IBX.IBSQL,
  Lca.Orm.Comp.IBX, FireDAC.ConsoleUI.Wait;

type
  TdmPrin = class(TDataModule)
    FDConnection1: TFDConnection;
    Comandos: TFDTransaction;
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

uses
  Vcl.Forms;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmPrin.DataModuleCreate(Sender: TObject);
var
  Path: string;
begin
  Path := ExpandFileName(ExtractFileDir(Application.ExeName) + '\..\..\');
  FDConnection1.Connected := False;
  FDConnection1.Params.Database := Path + '\Bd\BANCOTESTE.FDB';
  FDConnection1.Params.UserName := 'SYSDBA';
  FDConnection1.Params.Password := 'masterkey';
  TFDPhysFBConnectionDefParams(FDConnection1.Params).Server := 'localhost';
  FDConnection1.Connected := True;
  Dao := TDaoFiredac.Create(FDConnection1, Comandos);
end;

procedure TdmPrin.DataModuleDestroy(Sender: TObject);
begin
  Dao.Free;
end;

end.
