(**

  This module contains the main project code for a RAD Studio IDE plug-in for adding CodeSite
  debugging messages via a breakpoint.

  @Author  David Hoyle
  @Version 1.0
  @date    17 Sep 2017

**)
Library DebugWithCodeSiteXE4;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$R 'DWCSITHVerInfo.res' 'DWCSITHVerInfo.RC'}
{$R 'DebugWithCodeSiteImages.res' '..\Images\DebugWithCodeSiteImages.rc'}

Uses
  DebugWithCodeSite.InterfaceInitialisation in '..\Source\DebugWithCodeSite.InterfaceInitialisation.pas',
  DebugWithCodeSite.Wizard in '..\Source\DebugWithCodeSite.Wizard.pas',
  DebugWithCodeSite.Functions in '..\Source\DebugWithCodeSite.Functions.pas',
  DebugWithCodeSite.AboutBox in '..\Source\DebugWithCodeSite.AboutBox.pas',
  DebugWithCodeSite.Common in '..\Source\DebugWithCodeSite.Common.pas',
  DebugWithCodeSite.SplashScreen in '..\Source\DebugWithCodeSite.SplashScreen.pas',
  DebugWithCodeSite.OptionsIDEInterface in '..\Source\DebugWithCodeSite.OptionsIDEInterface.pas',
  DebugWithCodeSite.OptionsFrame in '..\Source\DebugWithCodeSite.OptionsFrame.pas' {frameDWCSOptions: TFrame},
  DebugWithCodeSite.Types in '..\Source\DebugWithCodeSite.Types.pas',
  DebugWithCodeSite.Interfaces in '..\Source\DebugWithCodeSite.Interfaces.pas',
  DebugWithCodeSite.PluginOptions in '..\Source\DebugWithCodeSite.PluginOptions.pas';

{$R *.res}

Begin

End.
