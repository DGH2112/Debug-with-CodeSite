(**

  This module contains a frame for editing the plug-ins options in the IDE options dialogue.

  @Author  David Hoyle
  @Version 1.0
  @date    16 Sep 2017

**)
Unit DebugWithCodeSite.OptionsFrame;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  DebugWithCodeSite.Types,
  DebugWithCodeSite.Interfaces,
  StdCtrls;

Type
  (** A frame to decsribe tand edit the plug-ins optins in the IDE. **)
  TframeDWCSOptions = Class(TFrame, IDWCSOptions)
    lvOptions: TListView;
    lblCodeSiteMsg: TLabel;
    edtCodeSiteMsg: TEdit;
    lblCodeSiteOptions: TLabel;
    procedure lvOptionsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
  Strict Private
    FChecks : TDWCSChecks;
  Strict Protected
    Procedure LoadOptions(Const CheckOptions : TDWCSChecks; Const strCodeSiteMsg : String);
    Procedure SaveOptions(Var CheckOptions : TDWCSChecks; Var strCodeSiteMsg : String);
  Public
    Constructor Create(AOwner: TComponent); Override;
  End;

Implementation

{$R *.dfm}


Const
  (** A constant array of strings to provide text for each check option. **)
  strDWCSCheck: Array [Low(TDWCSCheck) .. High(TDWCSCheck)] Of String = (
    'Check that CodeSiteLogging is in the DPR/DPK unit list',
    'Check that the project has Debugging DCUs checked',
    'Check that CodeSite path is in the library',
    'Log the Result of the CodeSite breakpoint to the event log',
    'Break at the CodeSite breakpoint',
    'Edit the breakpoint after its added'
    );

{ TframeDWCSOptions }

(**

  A constructor for the frameDWCSOptions class.

  @precon  None.
  @postcon Populates the list view with options.

  @param   AOwner as a TComponent

**)
Constructor TframeDWCSOptions.Create(AOwner: TComponent);

Var
  iOp: TDWCSCheck;
  Item: TListItem;

Begin
  Inherited Create(AOwner);
  For iOp := Low(TDWCSCheck) To High(TDWCSCheck) Do
    Begin
      Item := lvOptions.Items.Add;
      Item.Caption := strDWCSCheck[iOp];
    End;
End;

(**

  This method loads the given options into the list view.

  @precon  None.
  @postcon The checked status of the list view items is updated based on the given check set.

  @param   CheckOptions   as a TDWCSChecks as a constant
  @param   strCodeSiteMsg as a String as a constant

**)
Procedure TframeDWCSOptions.LoadOptions(Const CheckOptions : TDWCSChecks; Const strCodeSiteMsg : String);

Var
  iOp: TDWCSCheck;

Begin
  FChecks := CheckOptions;
  For iOp := Low(TDWCSCheck) To High(TDWCSCheck) Do
    lvOptions.Items[Ord(iOp)].Checked := iOp In CheckOptions;
  edtCodeSiteMsg.Text := strCodeSiteMsg;
End;

(**

  This is an on change event handler for the ListView control.

  @precon  None.
  @postcon Updates the internal check list with state changes.

  @param   Sender as a TObject
  @param   Item   as a TListItem
  @param   Change as a TItemChange

**)
Procedure TframeDWCSOptions.lvOptionsChange(Sender: TObject; Item: TListItem; Change: TItemChange);

Begin
  If Change = ctState Then
    If Item.Checked Then
      Include(FChecks, TDWCSCheck(Item.Index))
    Else
      Exclude(FChecks, TDWCSCheck(Item.Index));
End;

(**

  This method saves the options from the list view to the given options set.

  @precon  None.
  @postcon The given options set is updated with the selected options.

  @param   CheckOptions   as a TDWCSChecks as a reference
  @param   strCodeSiteMsg as a String as a reference

**)
Procedure TframeDWCSOptions.SaveOptions(Var CheckOptions : TDWCSChecks; Var strCodeSiteMsg : String);

Begin
  CheckOptions := FChecks;
  strCodeSiteMsg := edtCodeSiteMsg.Text;
End;

End.
