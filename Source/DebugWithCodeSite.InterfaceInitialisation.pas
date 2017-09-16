(**

  This module contaisn the code to load the wizard in to the RAD Studio IDE.

  @Author  David Hoyle
  @Version 1.0
  @Date    16 Sep 2017

**)
Unit DebugWithCodeSite.InterfaceInitialisation;

Interface

Uses
  ToolsAPI;

Procedure Register;
Function InitWizard(Const BorlandIDEServices: IBorlandIDEServices;
  RegisterProc: TWizardRegisterProc;
  Var Terminate: TWizardTerminateProc): Boolean; StdCall;

Exports
  InitWizard Name WizardEntryPoint;

Implementation

Uses
  DebugWithCodeSite.Wizard;

(**

  This method is required by the RAD Studio IDE in order to load the plugin as a package.

  @precon  None.
  @postcon Creates the plugin wizard.

**)
Procedure Register;

Begin
  RegisterPackageWizard(TDWCSWizard.Create);
End;

(**

  This method is requested by the RAD Studio IDE in order to load the plugin as a DLL wizard.

  @precon  None.
  @postcon Creates the plugin.

  @param   BorlandIDEServices as an IBorlandIDEServices as a constant
  @param   RegisterProc       as a TWizardRegisterProc
  @param   Terminate          as a TWizardTerminateProc as a reference
  @return  a Boolean

**)
Function InitWizard(Const BorlandIDEServices: IBorlandIDEServices;
  RegisterProc: TWizardRegisterProc;
  Var Terminate: TWizardTerminateProc): Boolean; StdCall; //FI:O804

Begin
  Result := BorlandIDEServices <> Nil;
  RegisterProc(TDWCSWizard.Create);
End;

End.
