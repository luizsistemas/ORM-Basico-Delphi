object frmTesteAtributos: TfrmTesteAtributos
  Left = 0
  Top = 0
  Caption = 'Teste Atributos'
  ClientHeight = 307
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 353
    Height = 307
    Align = alLeft
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object pnl1: TPanel
    Left = 353
    Top = 0
    Width = 393
    Height = 307
    Align = alClient
    TabOrder = 1
    object btnExcluir: TButton
      Left = 8
      Top = 93
      Width = 183
      Height = 25
      Caption = 'D - Excluir c'#243'digo 1'
      TabOrder = 4
      TabStop = False
      OnClick = btnExcluirClick
    end
    object btnInserir: TButton
      Left = 8
      Top = 6
      Width = 183
      Height = 25
      Caption = 'C - Inserir c'#243'digo 1'
      TabOrder = 0
      TabStop = False
      OnClick = btnInserirClick
    end
    object btnSalvar: TButton
      Left = 8
      Top = 64
      Width = 183
      Height = 25
      Caption = 'U - Salvar c'#243'digo 1'
      TabOrder = 2
      TabStop = False
      OnClick = btnSalvarClick
    end
    object btnBuscar: TButton
      Left = 8
      Top = 35
      Width = 183
      Height = 25
      Caption = 'R - Buscar c'#243'digo 1'
      TabOrder = 1
      TabStop = False
      OnClick = btnBuscarClick
    end
    object btnDataSet: TButton
      Left = 8
      Top = 122
      Width = 183
      Height = 25
      Caption = 'ConstulaSql: DataSet'
      TabOrder = 5
      TabStop = False
      OnClick = btnDataSetClick
    end
    object Button1: TButton
      Left = 8
      Top = 210
      Width = 183
      Height = 25
      Caption = 'Consulta Gen'#233'rica: TTabela'
      TabOrder = 7
      TabStop = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 239
      Width = 183
      Height = 25
      Caption = 'Conta Registros'
      TabOrder = 8
      TabStop = False
      OnClick = Button2Click
    end
    object btnSalvarUF: TButton
      Left = 200
      Top = 64
      Width = 183
      Height = 25
      Caption = 'U - Salvar Campo UF em Cidade'
      TabOrder = 3
      TabStop = False
      OnClick = btnSalvarUFClick
    end
    object Button3: TButton
      Left = 8
      Top = 151
      Width = 183
      Height = 25
      Caption = 'ConsultaTab: Dataset'
      TabOrder = 6
      TabStop = False
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 200
      Top = 180
      Width = 183
      Height = 26
      Caption = 'ConsultaTab: Somente Nome'
      TabOrder = 9
      TabStop = False
      OnClick = Button4Click
    end
    object btn1: TButton
      Left = 200
      Top = 151
      Width = 183
      Height = 26
      Caption = 'ConsultaTab: Ordem UF/Nome'
      TabOrder = 10
      TabStop = False
      OnClick = btn1Click
    end
    object btn2: TButton
      Left = 8
      Top = 180
      Width = 183
      Height = 26
      Caption = 'ConsultaTab: Ordem Nome Desc'
      TabOrder = 11
      TabStop = False
      OnClick = btn2Click
    end
    object Button5: TButton
      Left = 8
      Top = 271
      Width = 183
      Height = 25
      Caption = 'Conta Registros (MA/2100000)'
      TabOrder = 12
      TabStop = False
      OnClick = Button5Click
    end
    object btnLimpar: TButton
      Left = 200
      Top = 6
      Width = 183
      Height = 25
      Caption = 'Limpar Objeto Tabela'
      TabOrder = 13
      TabStop = False
      OnClick = btnLimparClick
    end
  end
end
