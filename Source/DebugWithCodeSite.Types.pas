(**

  This method contains simple types to be used throughout the application.

  @Author  David Hoyle
  @Version 1.0
  @Date    16 Sep 2017

**)
Unit DebugWithCodeSite.Types;

Interface

Type
  (** An enumerate to describe the boolean options for the plug-in. **)
  TDWCSCheck = (
    dwcscCodeSiteLogging,  // Check that CodeSiteLogging is in the DPR/DPK unit list.
    dwcscDebuggingDCUs,    // Check that the project has Debugging DCUs checked
    dwcscLibraryPath,      // Check that CodeSite path is in the library
    dwcscLogResult,        // Log the Result of the CodeSite breakpoint to the event log
    dwcscBreak,            // Break at the CodeSite breakpoint
    dwcscEditBreakpoint    // Edit the breakpoint after its added
  );
  (** A set of the above enumerates to describe the options for the plug-in. **)
  TDWCSChecks = Set Of TDWCSCheck;

Implementation

End.
