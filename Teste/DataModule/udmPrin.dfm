object dmPrin: TdmPrin
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 304
  Width = 783
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\ProjetosDelphi\OrmBasico\Teste\Bd\BANCOTESTE.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'Server=Luiz'
      'DriverID=FB')
    LoginPrompt = False
    Left = 40
    Top = 56
  end
  object Comandos: TFDTransaction
    Connection = FDConnection1
    Left = 48
    Top = 120
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 'C:\Program Files (x86)\Firebird\Firebird_4_0\fbclient.dll'
    Left = 184
    Top = 87
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = 'F:\Delphi10\Projetos\Persistencia\Teste\Bd\BANCOTESTE.FDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=02025626')
    LoginPrompt = False
    DefaultTransaction = tnormal
    ServerType = 'IBServer'
    Left = 312
    Top = 56
  end
  object tnormal: TIBTransaction
    DefaultDatabase = IBDatabase1
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 312
    Top = 112
  end
  object texec: TIBTransaction
    DefaultDatabase = IBDatabase1
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 312
    Top = 168
  end
  object IBSQL1: TIBSQL
    Left = 312
    Top = 224
  end
end
