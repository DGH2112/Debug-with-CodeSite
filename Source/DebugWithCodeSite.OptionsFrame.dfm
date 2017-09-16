object frameDWCSOptions: TframeDWCSOptions
  Left = 0
  Top = 0
  Width = 490
  Height = 327
  TabOrder = 0
  object lvOptions: TListView
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 484
    Height = 321
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
end
