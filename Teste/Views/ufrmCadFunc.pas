unit ufrmCadFunc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList;

type
  TfrmCadFunc = class(TForm)
    Label1: TLabel;
    edMatricula: TEdit;
    edNome: TEdit;
    Label2: TLabel;
    edCpf: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    edCidade: TButtonedEdit;
    ImageList1: TImageList;
    Label5: TLabel;
    Label6: TLabel;
    ButtonedEdit1: TButtonedEdit;
    Label7: TLabel;
    ButtonedEdit2: TButtonedEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label8: TLabel;
    edSalario: TEdit;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ActionList1: TActionList;
    actSalvar: TAction;
    actCancelar: TAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadFunc: TfrmCadFunc;

implementation

{$R *.dfm}

end.
