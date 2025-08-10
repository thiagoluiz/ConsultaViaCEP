object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  ActiveControl = mskedtCEP
  BorderStyle = bsSingle
  Caption = 'Consulta de Endere'#231'os Utilizando ViaCEP'
  ClientHeight = 482
  ClientWidth = 1093
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object statusBarPrincipal: TStatusBar
    Left = 0
    Top = 463
    Width = 1093
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object pnlDadosEndereco: TPanel
    Left = 0
    Top = 0
    Width = 1093
    Height = 463
    Align = alClient
    TabOrder = 1
    object dbNavEnderecos: TDBNavigator
      Left = 1
      Top = 429
      Width = 1091
      Height = 33
      DataSource = dsPrincipal
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh]
      Align = alBottom
      TabOrder = 0
    end
    object gbDadosPesquisa: TGroupBox
      Left = 1
      Top = 1
      Width = 1091
      Height = 184
      Align = alTop
      Caption = 'Dados Pesquisa'
      TabOrder = 1
      object lblLogradouro: TLabel
        Left = 15
        Top = 81
        Width = 62
        Height = 15
        Caption = 'Logradouro'
      end
      object lblLocalidade: TLabel
        Left = 15
        Top = 128
        Width = 37
        Height = 15
        Caption = 'Cidade'
      end
      object lblUF: TLabel
        Left = 264
        Top = 127
        Width = 35
        Height = 15
        Caption = 'Estado'
      end
      object lblCEP: TLabel
        Left = 15
        Top = 27
        Width = 21
        Height = 15
        Caption = 'CEP'
      end
      object edtLogradouro: TEdit
        Left = 15
        Top = 100
        Width = 617
        Height = 23
        CharCase = ecUpperCase
        Color = clInfoBk
        TabOrder = 1
        OnKeyPress = EditKeyPress
      end
      object edtCidade: TEdit
        Left = 15
        Top = 146
        Width = 243
        Height = 23
        CharCase = ecUpperCase
        Color = clInfoBk
        TabOrder = 2
        OnKeyPress = EditKeyPress
      end
      object edtUF: TEdit
        Left = 264
        Top = 146
        Width = 49
        Height = 23
        CharCase = ecUpperCase
        Color = clInfoBk
        MaxLength = 2
        TabOrder = 3
        OnKeyPress = EditKeyPress
      end
      object mskedtCEP: TMaskEdit
        Left = 15
        Top = 48
        Width = 65
        Height = 23
        Color = clInfoBk
        EditMask = '00000\-999;1;_'
        MaxLength = 9
        TabOrder = 0
        Text = '     -   '
        OnKeyPress = EditKeyPress
      end
      object rgConsultaPor: TRadioGroup
        Left = 102
        Top = 18
        Width = 169
        Height = 76
        Caption = 'Consulta por:'
        ItemIndex = 0
        Items.Strings = (
          'CEP'
          'Endereco Completo')
        TabOrder = 5
      end
      object rgResultadoConsulta: TRadioGroup
        Left = 277
        Top = 18
        Width = 161
        Height = 76
        Caption = 'Resultado da Consulta via:'
        ItemIndex = 0
        Items.Strings = (
          'JSON'
          'XML')
        TabOrder = 6
      end
      object btnConsultar: TBitBtn
        Left = 514
        Top = 129
        Width = 118
        Height = 42
        Caption = 'Consultar'
        TabOrder = 4
        OnClick = btnConsultarClick
      end
    end
    object gbConsultasRealizadas: TGroupBox
      Left = 1
      Top = 185
      Width = 1091
      Height = 225
      Align = alTop
      Caption = 'Consultas Realizadas'
      TabOrder = 2
      object DBGrid1: TDBGrid
        Left = 2
        Top = 17
        Width = 1087
        Height = 206
        Align = alClient
        DataSource = dsPrincipal
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CODIGO'
            ReadOnly = True
            Title.Caption = 'C'#243'digo'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CEP'
            ReadOnly = True
            Width = 73
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LOGRADOURO'
            ReadOnly = True
            Title.Caption = 'Logradouro'
            Width = 253
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COMPLEMENTO'
            ReadOnly = True
            Title.Caption = 'Complemento'
            Width = 216
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BAIRRO'
            ReadOnly = True
            Title.Caption = 'Bairro'
            Width = 164
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LOCALIDADE'
            ReadOnly = True
            Title.Caption = 'Localidade'
            Width = 229
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UF'
            ReadOnly = True
            Width = 46
            Visible = True
          end>
      end
    end
  end
  object dsPrincipal: TDataSource
    DataSet = dmMaster.qryPrincipal
    Left = 409
    Top = 257
  end
  object FDStanStorageJSONLink: TFDStanStorageJSONLink
    Left = 793
    Top = 273
  end
  object FDStanStorageXMLLink: TFDStanStorageXMLLink
    Left = 793
    Top = 337
  end
end
