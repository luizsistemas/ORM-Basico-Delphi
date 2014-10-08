object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 243
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object IBTransaction1: TIBTransaction
    DefaultDatabase = IBDatabase1
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 176
    Top = 56
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = 
      'C:\Users\Luiz\Documents\RAD Studio\Projects\Persistencia\Bd\BANC' +
      'OTESTE.FDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    ServerType = 'IBServer'
    Left = 272
    Top = 48
  end
end
