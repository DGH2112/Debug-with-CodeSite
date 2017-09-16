(**

  This module contains interfaces for use within the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    16 Sep 2017

**)
Unit DebugWithCodeSite.Interfaces;

Interface

Uses
  DebugWithCodeSite.Types;

Type
  (** An interface for loading and save options from the Options frame. **)
  IDWCSOptions = Interface
  ['{2C30AC8E-9C54-4544-A6AD-394DA361341F}']
    Procedure LoadOptions(Const CheckOptions : TDWCSChecks);
    Procedure SaveOptions(Var CheckOptions : TDWCSChecks);
  End;

  (** An interface to be implemented to allow the options interface to get optiosn from the wizard. **)
  IDWCSOptionsReadWriter = Interface
  ['{842A8FBB-A94E-430B-8A13-F1191D72C98D}']
    Function  ReadOptions : TDWCSChecks;
    Procedure WriteOptions(Const Options : TDWCSChecks);
  End;

Implementation

End.
