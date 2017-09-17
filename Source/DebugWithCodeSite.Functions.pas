(**

  This module contains OTA functions for use throughout the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    17 Sep 2017

**)
Unit DebugWithCodeSite.Functions;

Interface

Uses
  ToolsAPI;

{$INCLUDE CompilerDefinitions.Inc}

  Function  GetIdentifierAtCursor : String;
  Procedure CheckCodeSiteLogging;
  Procedure CheckDebuggingDCUs;
  Procedure CheckLibraryPath;

Implementation

Uses
  {$IFDEF DEBUG}
  CodeSiteLogging,
  {$ENDIF}
  Classes,
  SysUtils,
  RegularExpressions,
  Variants;

(**

  This method returns the editor code as a string from the given source editor
  reference.

  @precon  SourceEditor must be a valid instance.
  @postcon returns the editor code as a string from the given source editor
           reference.

  @param   SourceEditor as an IOTASourceEditor
  @return  a String

**)
Function EditorAsString(SourceEditor : IOTASourceEditor) : String;

Const
  iBufferSize : Integer = 1024;

Var
  Reader : IOTAEditReader;
  iRead : Integer;
  iPosition : Integer;
  strBuffer : AnsiString;

Begin
  Result := '';
  Reader := SourceEditor.CreateReader;
  Try
    iPosition := 0;
    Repeat
      SetLength(strBuffer, iBufferSize);
      iRead := Reader.GetText(iPosition, PAnsiChar(strBuffer), iBufferSize);
      SetLength(strBuffer, iRead);
      Result := Result + String(strBuffer);
      Inc(iPosition, iRead);
    Until iRead < iBufferSize;
  Finally
    Reader := Nil;
  End;
End;

(**

  This method returns the source editor for the given module.

  @precon  Module must be a valid instance.
  @postcon Returns the source editor for the given module.

  @param   Module as an IOTAMOdule
  @return  an IOTASourceEditor

**)
Function SourceEditor(Module : IOTAMOdule) : IOTASourceEditor;

Var
  iFileCount : Integer;
  i : Integer;

Begin
  Result := Nil;
  If Module = Nil Then Exit;
  With Module Do
    Begin
      iFileCount := GetModuleFileCount;
      For i := 0 To iFileCount - 1 Do
        If GetModuleFileEditor(i).QueryInterface(IOTASourceEditor,
          Result) = S_OK Then
          Break;
    End;
End;

(**

  This method returns the Source Editor interface for the active source editor
  else returns nil.

  @precon  None.
  @postcon Returns the Source Editor interface for the active source editor
           else returns nil.

  @return  an IOTASourceEditor

**)
Function ActiveSourceEditor : IOTASourceEditor;

Var
  CM : IOTAModule;

Begin
  Result := Nil;
  If BorlandIDEServices = Nil Then
    Exit;
  CM := (BorlandIDEServices as IOTAModuleServices).CurrentModule;
  Result := SourceEditor(CM);
End;

(**

  This method returns the identifier at the cursor position in the editor.

  @precon  SourceEditor must be a valid instance.
  @postcon Returns the identifier at the cursor position in the editor if found else returns null.

  @param   SourceEditor as an IOTASourceEditor as a constant
  @param   EditPos      as a TOTAEditPos as a constant
  @return  a String

**)
Function IdentifierAtCursor(Const SourceEditor : IOTASourceEditor; Const EditPos : TOTAEditPos) : String;

Const
  strValidIdentChars = ['a'..'z', 'A'..'Z', '_'];

Var
  slSrcCode : TStringList;
  iLine : Integer;
  iStart, iEnd : Integer;
  strLine : String;

Begin
  Result := '';
  slSrcCode := TStringList.Create;
  Try
    slSrcCode.Text := EditorAsString(SourceEditor);
    iLine := EditPos.Line - 1;
    If (iLine <= slSrcCode.Count - 1) And (EditPos.Col <= Length(slSrcCode[iLine])) Then
      Begin
        strLine := slSrcCode[iLine];
        iStart := EditPos.Col;
        // Search backwards for the start of a qualitied identifier
        While (iStart > 0) And CharInSet(strLine[iStart], strValidIdentChars + ['.']) Do
          Dec(iStart);
        Inc(iStart);
        iEnd := EditPos.Col;
        // Search forwards for the end of the current identifier
        While (iEnd < Length(strLine)) And CharInSet(strLine[iEnd], strValidIdentChars) Do
          Inc(iEnd);
        Result := Copy(strLine, iStart, iEnd - iStart);
      End;
  Finally
    slSrcCode.Free;
  End;
End;

(**

  This method returns the selected text in the editor.

  @precon  SourceEditor must be a valid instance.
  @postcon Returns the selected text in the editor.

  @param   SourceEditor as an IOTASourceEditor as a constant
  @return  a String

**)
Function SelectedText(Const SourceEditor : IOTASourceEditor) : String;

Var
  R: IOTAEditReader;
  iStart, iEnd : Integer;
  strAnsiBuffer : AnsiString;

Begin
  iStart := SourceEditor.EditViews[0].CharPosToPos(SourceEditor.BlockStart);
  iEnd := SourceEditor.EditViews[0].CharPosToPos(SourceEditor.BlockAfter);
  R := SourceEditor.CreateReader;
  SetLength(strAnsiBuffer, iEnd - iStart);
  R.GetText(
    iStart,
    PAnsiChar(strAnsiBuffer),
    iEnd - iStart
  );
  Result := String(strAnsiBuffer);
End;

(**

  This method returns the identifier at the cursor position in the passed module.

  @precon  Module must be a valid instance.
  @postcon The identifier at the module cursor position is returned if found.

  @return  a String

**)
Function GetIdentifierAtCursor : String;

Var
  SourceEditor : IOTASourceEditor;
  EditPos: TOTAEditPos;

Begin
  Result := '';
  SourceEditor := ActiveSourceEditor;
  EditPos := SourceEditor.EditViews[0].CursorPos;
  If Assigned(SourceEditor) Then
    Begin
      If SourceEditor.EditViews[0].CharPosToPos(SourceEditor.BlockStart) < SourceEditor.EditViews[0].CharPosToPos(SourceEditor.BlockAfter) Then
        Result := SelectedText(SourceEditor)
      Else
        Result := IdentifierAtCursor(SourceEditor, EditPos);
    End;
End;

(**

  This method outputs a tool message to the message view.

  @precon  None.
  @postcon A message is output the the message view.

  @param   strMsg as a String as a constant

**)
Procedure OutputMsg(Const strMsg : String);

Var
  ModS : IOTAModuleServices;
  MsgS : IOTAMessageServices;
  SE   : IOTASourceEditor;
  Ptr  : Pointer;

Begin
  If Supports(BorlandIDEServices, IOTAModuleServices, ModS) Then
    Begin
      SE := SourceEditor(ModS.CurrentModule);
      Ptr := Nil;
      If Supports(BorlandIDEServices, IOTAMessageServices, MsgS) Then
        Begin
          MsgS.AddToolMessage(
            ModS.CurrentModule.FileName,
            strMsg,
            'DebugWithCodeSite',
            SE.EditViews[0].CursorPos.Line,
            SE.EditViews[0].CursorPos.Col,
            Nil,
            Ptr
          );
          MsgS.ShowMessageView(Nil);
        End;
    End;
End;

(**

  This method returns the current project group reference or nil if there is no
  project group open.

  @precon  None.
  @postcon Returns the current project group reference or nil if there is no
           project group open.

  @return  an IOTAProjectGroup

**)
Function ProjectGroup: IOTAProjectGroup;

Var
  AModuleServices: IOTAModuleServices;
  AModule: IOTAModule;
  i: integer;
  AProjectGroup: IOTAProjectGroup;

Begin
  Result := Nil;
  AModuleServices := (BorlandIDEServices as IOTAModuleServices);
  For i := 0 To AModuleServices.ModuleCount - 1 Do
    Begin
      AModule := AModuleServices.Modules[i];
      If (AModule.QueryInterface(IOTAProjectGroup, AProjectGroup) = S_OK) Then
       Break;
    End;
  Result := AProjectGroup;
end;

(**

  This method returns the active project in the IDE else returns Nil if there is
  no active project.

  @precon  None.
  @postcon Returns the active project in the IDE else returns Nil if there is
           no active project.

  @return  an IOTAProject

**)
Function ActiveProject : IOTAProject;

var
  G : IOTAProjectGroup;

Begin
  Result := Nil;
  G := ProjectGroup;
  If G <> Nil Then
    Result := G.ActiveProject;
End;

(**

  This method returns the project module for the given project.

  @precon  Project must be a valid instance.
  @postcon Returns the project module for the given project.

  @param   Project as an IOTAProject
  @return  an IOTAModule

**)
Function ProjectModule(Project : IOTAProject) : IOTAModule;

Var
  AModuleServices: IOTAModuleServices;
  AModule: IOTAModule;
  i: integer;
  AProject: IOTAProject;

Begin
  Result := Nil;
  AModuleServices := (BorlandIDEServices as IOTAModuleServices);
  For i := 0 To AModuleServices.ModuleCount - 1 Do
    Begin
      AModule := AModuleServices.Modules[i];
      If (AModule.QueryInterface(IOTAProject, AProject) = S_OK) And
        (Project = AProject) Then
        Break;
    End;
  Result := AProject;
End;

(**

  This method checks the DPR or DPK file for CodeSiteLogging in the uses clause using regular
  expressions.

  @precon  None.
  @postcon A messages is output if CodeSiteLogging is not found between the Uses and the Begin of the
           project file.

**)
Procedure CheckCodeSiteLogging;

Const
  strUses                = '\bUses\b';
  strCodeSiteLoggingUses = '\bCodeSiteLogging\b';
  strBegin               = '\bBegin\b';

Var
  RegEx : TRegEx;
  strCode: String;
  SE: IOTASourceEditor;
  UsesMatch, CodeSiteLoggingMatch, BeginMatch: TMatch;

Begin
  SE := SourceEditor(ProjectModule(ActiveProject));
  If Assigned(SE) Then
    Begin
      strCode := EditorAsString(SE);
      RegEx := TRegEx.Create(strUses, [roIgnoreCase, roMultiLine, roCompiled]);
      UsesMatch := RegEx.Match(strCode);
      RegEx := TRegEx.Create(strCodeSiteLoggingUses, [roIgnoreCase, roMultiLine, roCompiled]);
      CodeSiteLoggingMatch := RegEx.Match(strCode);
      RegEx := TRegEx.Create(strBegin, [roIgnoreCase, roMultiLine, roCompiled]);
      BeginMatch := RegEx.Match(strCode);
      If Not(UsesMatch.Success And CodeSiteLoggingMatch.Success And BeginMatch.Success And
        (UsesMatch.Index < CodeSiteLoggingMatch.Index) And
        (CodeSiteLoggingMatch.Index < BeginMatch.Index)) Then
       OutputMsg('CodeSiteLogging NOT FOUND in the project file.');
    End;
End;

(**

  This method changes the active projects options to see if the Debugging DCUs is enabled. Outputs
  a message if they are not.

  @precon  None.
  @postcon Outputs a message if Debugging DCUs are not enabled.

**)
Procedure CheckDebuggingDCUs;

Var
  Options: TOTAOptionNameArray;
  iOp: Integer;
  V: Variant;
  AP: IOTAProject;

Begin
  AP := ActiveProject;
  If Assigned(AP) Then
    Begin
      Options := AP.ProjectOptions.GetOptionNames;
      For iOp := Low(options) To High(Options) Do
        If Pos('linkdebugvcl', LowerCase(Options[iOp].Name)) > 0 Then
          Begin
            V := ActiveProject.ProjectOptions.Values[Options[iOp].Name];
            If Not V Then
              OutputMsg('You need to build your project with debugging DCUs.');
          End;
    End;
End;

Procedure CheckLibraryPath;

//Var
//  i : Integer;
//  P : IOTAProjectOptionsConfigurations;
//  B : IOTABuildConfiguration;

Begin
  OutputMsg('Checking of LibrayrPath not currently implemented');
//  If Supports(ActiveProject.ProjectOptions, IOTAProjectOptionsConfigurations, P) Then
//    Begin
//      CodeSite.Send(P.ActiveConfigurationName);
//      CodeSite.Send(P.ActivePlatformName);
//      CodeSite.Send('LibraryPath', P.ActiveConfiguration.InheritedValue('LibraryPath'));
//    End;
End;

End.
