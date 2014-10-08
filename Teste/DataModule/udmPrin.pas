unit udmPrin;

interface

uses
  System.SysUtils, System.Classes, prsDaoIBX;

type
  TdmPrin = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Conexao: TConexaoIbx;
    Dao: TDaoIBX;
    Transacao: TTransacaoIbx;
  end;

var
  dmPrin: TdmPrin;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmPrin.DataModuleCreate(Sender: TObject);
begin
  // configuração da conexão - utilizando IBX
  Conexao := TConexaoIbx.Create;
  Transacao := TTransacaoIbx.Create(Conexao.Database);

  with Conexao do
  begin
    LocalBD := ExtractFilePath(ParamStr(0)) + '..\..\Bd\BANCOTESTE.FDB';
    Usuario := 'sysdba';
    Senha   := '02025626';
    Conecta;
//    MyTrans := Transaction;
  end;

  Dao := TDaoIBX.Create(Conexao, Transacao);
end;

procedure TdmPrin.DataModuleDestroy(Sender: TObject);
begin
  Transacao.Free;
  Conexao.Free;
  Dao.Free;
end;

end.
