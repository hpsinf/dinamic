object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Form2'
  ClientHeight = 336
  ClientWidth = 571
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    571
    336)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 201
    Top = 142
    Width = 104
    Height = 19
    Anchors = [akTop, akRight]
    Caption = 'Status Code:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 8
    Top = 45
    Width = 75
    Height = 25
    Caption = 'Get'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid2: TDBGrid
    Left = 0
    Top = 167
    Width = 571
    Height = 169
    Align = alBottom
    DataSource = DataSource2
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'nome'
        Title.Caption = 'Nome'
        Width = 72
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'genero'
        Title.Caption = 'Genero'
        Width = 74
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'status'
        Title.Caption = 'Status'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'data_nascimento'
        Title.Caption = 'Data Nascimento'
        Width = 99
        Visible = True
      end>
  end
  object Button2: TButton
    Left = 8
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Post'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 110
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 120
    Top = 120
    Width = 75
    Height = 41
    Caption = 'Update'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Edit1: TLabeledEdit
    Left = 120
    Top = 86
    Width = 89
    Height = 21
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Nome'
    TabOrder = 5
  end
  object DBGrid1: TDBGrid
    Left = 128
    Top = 33
    Width = 441
    Height = 37
    DataSource = DataSource1
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button5: TButton
    Left = 488
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Ativar'
    TabOrder = 7
    OnClick = Button5Click
  end
  object DataSource2: TDataSource
    Left = 24
    Top = 8
  end
  object DataSource1: TDataSource
    Left = 136
  end
end
