unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    btnTeste: TButton;
    procedure btnTesteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses ufrmTesteAtributos;

procedure TfrmMain.btnTesteClick(Sender: TObject);
begin
  frmTesteAtributos := TfrmTesteAtributos.create(self);
  try
    frmTesteAtributos.showmodal;
  finally
    FreeAndNil(frmTesteAtributos);
  end;
end;

end.
