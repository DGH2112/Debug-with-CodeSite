(**

  This module contains a class to handle the plug-ins settings.

  @Author  David Hoyle
  @Version 1.0
  @Date    17 Sep 2017

**)
Unit DebugWithCodeSite.PluginOptions;

Interface

Uses
  DebugWithCodeSite.Types,
  DebugWithCodeSite.Interfaces;

Type
  (** A class to handle the plug-ins settings. **)
  TDWCSPluginOptions = Class(TInterfacedObject, IDWCSPluginOptions)
  Strict Private
    FChecksOptions: TDWCSChecks;
    FCodeSiteTemplate: String;
  Strict Protected
    Function  GetCheckOptions: TDWCSChecks;
    Function  GetCodeSiteTemplate: String;
    Procedure SetCheckOptions(Const setCheckOptions: TDWCSChecks);
    Procedure SetCodeSiteTemplate(Const strCodeSiteTemplate: String);
    Procedure LoadSettings;
    Procedure SaveSettings;
  Public
    Constructor Create;
  End;

Implementation

Uses
  {$IFDEF DEBUG}
  CodeSiteLogging,
  {$ENDIF}
  Registry;

Const
  (** The registry key under which the settings are stored. **)
  strRegKey = 'Software\Season''s Fall\Debug with CodeSite\';

{ TDWCSPluginOptions }

(**

  A constructor for the TDWCSPluginOptions class.

  @precon  None.
  @postcon Initialises the settings;

**)
Constructor TDWCSPluginOptions.Create;

Begin
  FChecksOptions := [dwcscCodeSiteLogging .. dwcscBreak];
  FCodeSiteTemplate := 'CodeSite.Send(''%s'', %s)';
  LoadSettings;
End;

(**

  This is a getter method for the CheckOptions property.

  @precon  None.
  @postcon Returns the check options.

  @return  a TDWCSChecks

**)
Function TDWCSPluginOptions.GetCheckOptions: TDWCSChecks;

Begin
  Result := FChecksOptions;
End;

(**

  This is a getter method for the CoedSiteTemplate property.

  @precon  None.
  @postcon Returns the CodeSite template.

  @return  a String

**)
Function TDWCSPluginOptions.GetCodeSiteTemplate: String;

Begin
  Result := FCodeSiteTemplate;
End;

(**

  This method loads the plug-ins settings from the regsitry.

  @precon  None.
  @postcon  The plug-ins settings are loaded.

**)
Procedure TDWCSPluginOptions.LoadSettings;

Var
  R : TRegIniFile;

Begin
  R := TRegIniFile.Create(strRegKey);
  Try
    FCodeSiteTemplate := R.ReadString('Setup', 'CodeSiteMsg', FCodeSiteTemplate);
    FChecksOptions := TDWCSChecks(Byte(R.ReadInteger('Setup', 'Options', Byte(FChecksOptions))));
  Finally
    R.Free;
  End;
End;

(**

  This method saves the settings to the registry.

  @precon  None.
  @postcon The settings are saved.

**)
Procedure TDWCSPluginOptions.SaveSettings;

Var
  R: TRegIniFile;

Begin
  R := TRegIniFile.Create(strRegKey);
  Try
    R.WriteString('Setup', 'CodeSiteMsg', FCodeSiteTemplate);
    R.WriteInteger('Setup', 'Options', Byte(FChecksOptions));
  Finally
    R.Free;
  End;
End;

(**

  This is a setter method for the CheckOptions property.

  @precon  None.
  @postcon Updates the check options.

  @param   setCheckOptions as a TDWCSChecks as a constant

**)
Procedure TDWCSPluginOptions.SetCheckOptions(Const setCheckOptions: TDWCSChecks);

Begin
  FChecksOptions := setCheckOptions;
End;

(**

  This is a setter method for the CodeSiteTemplate property.

  @precon  None.
  @postcon Updates the CodeSite template.

  @param   strCodeSiteTemplate as a String as a constant

**)
Procedure TDWCSPluginOptions.SetCodeSiteTemplate(Const strCodeSiteTemplate: String);

Begin
  FCodeSiteTemplate := strCodeSiteTemplate;
End;

End.


