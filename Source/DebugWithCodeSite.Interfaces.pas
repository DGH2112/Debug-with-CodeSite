(**

  This module contains interfaces for use within the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    17 Sep 2017

**)
Unit DebugWithCodeSite.Interfaces;

Interface

Uses
  DebugWithCodeSite.Types;

Type
  (** An interface for loading and save options from the Options frame. **)
  IDWCSOptions = Interface
  ['{2C30AC8E-9C54-4544-A6AD-394DA361341F}']
    Procedure LoadOptions(Const CheckOptions : TDWCSChecks; Const strCodeSiteMsg : String);
    Procedure SaveOptions(Var CheckOptions : TDWCSChecks; Var strCodeSiteMsg : String);
  End;

  (** An interface for the Plugin Options **)
  IDWCSPluginOptions = Interface
  ['{C0C072B8-4F4C-4EE1-938A-333FF7BCE881}']
    Function  GetCodeSiteTemplate : String;
    Procedure SetCodeSiteTemplate(Const strCodeSiteTemplate : String);
    Function  GetCheckOptions : TDWCSChecks;
    Procedure SetCheckOptions(Const setCheckOptions : TDWCSChecks);
    Procedure LoadSettings;
    Procedure SaveSettings;
    (**
      This property gets and sets the CodeSite template that is used to fill the breakpoint evaluation
      expression.
      @precon  None.
      @postcon Gets and sets the CodeSite template that is used to fill the breakpoint evaluation
               expression.
      @return  a String
    **)
    Property CodeSiteTemplate : String Read GetCodeSiteTemplate Write SetCodeSiteTemplate;
    (**
      This property gets and sets the check options that is used to fill the breakpoint.
      @precon  None.
      @postcon Gets and sets the check options that is used to fill the breakpoint.
      @return  a TDWCSChecks
    **)
    Property CheckOptions : TDWCSChecks Read GetCheckOptions Write SetCheckOptions;
  End;

Implementation

End.
