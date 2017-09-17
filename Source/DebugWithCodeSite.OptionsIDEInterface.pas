(**

  This module contains an a class to handle the installation of the options frame into the IDEs
  options dialogue.

  @Author  David Hoyle
  @Version 1.0
  @Date    17 Sep 2017

**)
Unit DebugWithCodeSite.OptionsIDEInterface;

Interface

{$INCLUDE CompilerDefinitions.inc}

{$IFDEF DXE00}

Uses
  ToolsAPI,
  DebugWithCodeSite.OptionsFrame,
  Forms,
  DebugWithCodeSite.Interfaces;

Type
  (** A class which implements the INTAAddingOptions interface to added options frames
      to the IDEs options dialogue. **)
  TDWCSIDEOptionsHandler = Class(TInterfacedObject, IUnknown, INTAAddInOptions)
  Strict Private
    Class Var
      (** A class variable to hold the instance reference for this IDE options handler. **)
      FDWCSIDEOptions : TDWCSIDEOptionsHandler;
  Strict Private
    FDWCSOptionsFrame  : TframeDWCSOptions;
    FDWCSPluginOptions : IDWCSPluginOptions;
  Strict Protected
    Procedure DialogClosed(Accepted: Boolean);
    Procedure FrameCreated(AFrame: TCustomFrame);
    Function  GetArea: String;
    Function  GetCaption: String;
    Function  GetFrameClass: TCustomFrameClass;
    Function  GetHelpContext: Integer;
    Function  IncludeInIDEInsight: Boolean;
    Function  ValidateContents: Boolean;
  Public
    Constructor Create(Const PluginOptions : IDWCSPluginOptions);
    Class Procedure AddOptionsFrameHandler(Const PluginOptions : IDWCSPluginOptions);
    Class Procedure RemoveOptionsFrameHandler;
  End;
{$ENDIF}

Implementation

{$IFDEF DXE00}

Uses
  {$IFDEF DEBUG}
  CodeSiteLogging,
  {$ENDIF}
  {$IFDEF DXE20}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  DebugWithCodeSite.Types;

(**

  This is a class method to add the options frame handler to the IDEs options dialogue.

  @precon  None.
  @postcon The IDE options handler is installed into the IDE.

  @param   PluginOptions as an IDWCSPluginOptions as a constant

**)
Class Procedure TDWCSIDEOptionsHandler.AddOptionsFrameHandler(Const PluginOptions : IDWCSPluginOptions);

Var
  EnvironmentOptionsServices : INTAEnvironmentOptionsServices;

Begin
  FDWCSIDEOptions := TDWCSIDEOptionsHandler.Create(PluginOptions);
  If Supports(BorlandIDEServices, INTAEnvironmentOptionsServices, EnvironmentOptionsServices) Then
    EnvironmentOptionsServices.RegisterAddInOptions(FDWCSIDEOptions);
End;

(**

  A constructor for the TDWVSIDEOptionsHandler class.

  @precon  None.
  @postcon Stores the Options Read Wrtier interface reference.

  @param   PluginOptions as an IDWCSPluginOptions as a constant

**)
Constructor TDWCSIDEOptionsHandler.Create(Const PluginOptions : IDWCSPluginOptions);

Begin
  Inherited Create;
  FDWCSPluginOptions := PluginOptions;
End;

(**

  This method is called by the IDE when the IDEs options dialogue is closed.

  @precon  None.
  @postcon If the dialogue was accepted and the frame supports the interface then it saves
           the frame settings.

  @param   Accepted as a Boolean

**)
Procedure TDWCSIDEOptionsHandler.DialogClosed(Accepted: Boolean);

Var
  I   : IDWCSOptions;
  Ops : TDWCSChecks;
  strCodeSiteMsg: String;

Begin
  If Accepted Then
    If Supports(FDWCSOptionsFrame, IDWCSOptions, I) Then
      Begin
        I.SaveOptions(Ops, strCodeSiteMsg);
        FDWCSPluginOptions.CodeSiteTemplate := strCodeSiteMsg;
        FDWCSPluginOptions.CheckOptions := Ops;
        FDWCSPluginOptions.SaveSettings;
      End;
End;

(**

  This method is called by the IDe when the frame is created.

  @precon  None.
  @postcon If the frame supports the interface its settings are loaded.

  @param   AFrame as a TCustomFrame

**)
Procedure TDWCSIDEOptionsHandler.FrameCreated(AFrame: TCustomFrame);

Var
  I : IDWCSOptions;
  Options : TDWCSChecks;
  strCodeSiteMsg : String;

Begin
  FDWCSOptionsFrame := AFrame As TframeDWCSOptions;
  If Supports(FDWCSOptionsFrame, IDWCSOptions, I) Then
    Begin
      Options := FDWCSPluginOptions.CheckOptions;
      strCodeSiteMsg := FDWCSPluginOptions.CodeSiteTemplate;
      I.LoadOptions(Options, strCodeSiteMsg);
    End;
End;

(**

  This is a getter method for the Area property.

  @precon  None.
  @postcon Called by the IDE. NULL string is returned to place the options frame under the
           third party node.

  @return  a String

**)
Function TDWCSIDEOptionsHandler.GetArea: String;

Begin
  Result := '';
End;

(**

  This is a getter method for the Caption property.

  @precon  None.
  @postcon This is called by the IDe to get the caption of the options frame in the IDEs
           options dialogue in the left treeview.

  @return  a String

**)
Function TDWCSIDEOptionsHandler.GetCaption: String;

Begin
  Result := 'Debug With CodeSite';
End;

(**

  This is a getter method for the FrameClass property.

  @precon  None.
  @postcon This is called by the IDE to get the frame class to create when displaying the
           options dialogue.

  @return  a TCustomFrameClass

**)
Function TDWCSIDEOptionsHandler.GetFrameClass: TCustomFrameClass;

Begin
  Result := TframeDWCSOptions;
End;

(**

  This is a getter method for the HelpContext property.

  @precon  None.
  @postcon This is called by the IDe and returns 0 to signify no help.

  @return  an Integer

**)
Function TDWCSIDEOptionsHandler.GetHelpContext: Integer;

Begin
  Result := 0;
End;

(**

  This is called by the IDE to determine whether the controls on the options frame are
  displayed in the IDE Insight search.

  @precon  None.
  @postcon Returns true to be include in IDE Insight.

  @return  a Boolean

**)
Function TDWCSIDEOptionsHandler.IncludeInIDEInsight: Boolean;

Begin
  Result := True;
End;

(**

  This is a class method to remove the options frame handler from the IDEs options dialogue.

  @precon  None.
  @postcon The IDE options handler is removed from the IDE.

**)
Class Procedure TDWCSIDEOptionsHandler.RemoveOptionsFrameHandler;

Var
  EnvironmentOptionsServices : INTAEnvironmentOptionsServices;

Begin
  If Supports(BorlandIDEServices, INTAEnvironmentOptionsServices, EnvironmentOptionsServices) Then
    EnvironmentOptionsServices.UnregisterAddInOptions(FDWCSIDEOptions);
End;

(**

  This method is called by the IDE to validate the frame.

  @precon  None.
  @postcon Not used so returns true.

  @return  a Boolean

**)
Function TDWCSIDEOptionsHandler.ValidateContents: Boolean;

Begin
  Result := True;
End;

{$ENDIF}

End.


