object Form1: TForm1
  Left = 112
  Top = 262
  Width = 1024
  Height = 740
  Caption = 'MultiWaveMed'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 321
    Height = 694
    Align = alLeft
    TabOrder = 0
    object Imagem: TImage
      Left = 16
      Top = 24
      Width = 257
      Height = 257
      Stretch = True
    end
    object Label1: TLabel
      Left = 6
      Top = 355
      Width = 40
      Height = 13
      Caption = 'Wavelet'
    end
    object Label2: TLabel
      Left = 107
      Top = 355
      Width = 36
      Height = 13
      Caption = 'Feature'
    end
    object Label3: TLabel
      Left = 206
      Top = 355
      Width = 42
      Height = 13
      Caption = 'Distance'
    end
    object Label4: TLabel
      Left = 7
      Top = 454
      Width = 94
      Height = 13
      Caption = 'Feature Vectors File'
    end
    object Label5: TLabel
      Left = 16
      Top = 405
      Width = 72
      Height = 13
      Caption = 'Scales Number'
    end
    object Label6: TLabel
      Left = 16
      Top = 431
      Width = 96
      Height = 13
      Caption = 'Orientations Number'
    end
    object Label7: TLabel
      Left = 8
      Top = 283
      Width = 63
      Height = 13
      Caption = 'Image Name:'
    end
    object Label8: TLabel
      Left = 9
      Top = 300
      Width = 3
      Height = 13
    end
    object Button1: TButton
      Left = 17
      Top = 323
      Width = 145
      Height = 25
      Caption = 'Search for Similar Images'
      TabOrder = 0
      OnClick = Button1Click
    end
    object ComboBox1: TComboBox
      Left = 6
      Top = 371
      Width = 89
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'Haar'
        'Daubechies'
        'Gabor')
    end
    object ComboBox2: TComboBox
      Left = 103
      Top = 371
      Width = 81
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Mean'
        'Energy'
        'Entropy'
        'Moments'
        'Mixture')
    end
    object ComboBox3: TComboBox
      Left = 190
      Top = 371
      Width = 97
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        'Euclidean'
        'Euclidean Normalized'
        '')
    end
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 504
      Width = 297
      Height = 16
      Enabled = False
      Min = 0
      Max = 100
      TabOrder = 4
    end
    object Edit1: TEdit
      Left = 6
      Top = 470
      Width = 281
      Height = 21
      TabOrder = 5
    end
    object EditEscalas: TEdit
      Left = 120
      Top = 401
      Width = 73
      Height = 21
      TabOrder = 6
      Text = '2'
    end
    object EditOrientacoes: TEdit
      Left = 120
      Top = 427
      Width = 73
      Height = 21
      TabOrder = 7
      Text = '6'
    end
    object FileListBox2: TFileListBox
      Left = 0
      Top = 536
      Width = 321
      Height = 145
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 8
      OnClick = FileListBox2Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object NovaConsulta1: TMenuItem
        Caption = 'New Query'
        OnClick = NovaConsulta1Click
      end
      object Abrir1: TMenuItem
        Caption = 'Open'
        OnClick = Abrir1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Escolha: TMenuItem
        Caption = 'Select Feature Vector File'
        OnClick = EscolhaClick
      end
      object Sair1: TMenuItem
        Caption = '-'
      end
      object Sair: TMenuItem
        Caption = 'Exit'
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object AutoLevelOption: TMenuItem
        Caption = 'Automatic Auto level '
        OnClick = AutoLevelOptionClick
      end
      object DicomImage1: TMenuItem
        Caption = 'Dicom Image'
        Checked = True
        OnClick = DicomImage1Click
      end
    end
    object Miscelaneas1: TMenuItem
      Caption = 'Miscelaneous'
      object GeraVetordeCaractersticas1: TMenuItem
        Caption = 'Feature Vector Generation'
        OnClick = GeraVetordeCaractersticas1Click
      end
      object GeraGaborFeatures1: TMenuItem
        Caption = 'Gabor Features Generation'
        OnClick = GeraGaborFeatures1Click
      end
      object AbrirJanelaGabor1: TMenuItem
        Caption = 'Open Gabor Window'
        OnClick = AbrirJanelaGabor1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About...'
      end
    end
  end
  object OpenDialog: TOpenDialog
    FilterIndex = 2
    Left = 64
    Top = 16
  end
  object OpenFeatureFile: TOpenDialog
    Filter = '*.*'
    Left = 104
    Top = 16
  end
end
