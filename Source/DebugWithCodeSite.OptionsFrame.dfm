object frameDWCSOptions: TframeDWCSOptions
  Left = 0
  Top = 0
  Width = 490
  Height = 327
  TabOrder = 0
  object lblCodeSiteMsg: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 484
    Height = 13
    Align = alTop
    Caption = 'Code Site Message (include at least 1 %s)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblCodeSiteOptions: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 46
    Width = 484
    Height = 13
    Align = alTop
    Caption = 'Debug with CodeSite Options'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lvOptions: TListView
    AlignWithMargins = True
    Left = 3
    Top = 62
    Width = 484
    Height = 262
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = 'Options'
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvOptionsChange
  end
  object edtCodeSiteMsg: TEdit
    AlignWithMargins = True
    Left = 3
    Top = 19
    Width = 484
    Height = 21
    Align = alTop
    TabOrder = 1
  end
end
