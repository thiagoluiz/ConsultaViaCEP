object dmMaster: TdmMaster
  Height = 480
  Width = 640
  object ConexaoPrincipal: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'CharacterSet=ISO8859_1'
      'Database=C:\Fontes\DesafioSoftplan\DB\GERAL.FDB'
      'DriverID=Firebird')
    LoginPrompt = False
    Transaction = FDTransaction
    Left = 64
    Top = 32
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    DriverID = 'Firebird'
    VendorLib = 'C:\Fontes\DesafioSoftplan\dlls\fbclient.dll'
    Left = 184
    Top = 32
  end
  object FDTransaction: TFDTransaction
    Connection = ConexaoPrincipal
    Left = 296
    Top = 32
  end
  object spViaCep: TspViaCepComponent
    FormatoRetorno = fraJSON
    ConsultarPorEnderecoCompleto = False
    Left = 64
    Top = 104
  end
  object FDMemTablePrincipal: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvStoreItems, rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 177
    Top = 113
  end
  object qryPrincipal: TFDQuery
    Connection = ConexaoPrincipal
    Transaction = FDTransaction
    SQL.Strings = (
      
        'SELECT ED.CODIGO, ED.CEP, ED.LOGRADOURO, ED.COMPLEMENTO, ED.BAIR' +
        'RO, ED.LOCALIDADE, ED.UF'
      'FROM ENDERECO ED'
      'ORDER BY CODIGO DESC')
    Left = 376
    Top = 113
  end
end
