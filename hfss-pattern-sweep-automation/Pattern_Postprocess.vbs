' ----------------------------------------------
' Script Recorded by Ansys Electronics Desktop Version 2022.1.0
' Generate gain/axial ratio radiation patterns iteratively across multiple frequency points.
'   First loop set: Phi = 0 deg, scan variable dx, element spacing 5.9 mm (boresight + theta = 60 deg scan).
'   Second loop set: Phi = 90 deg, scan variable dy, element spacing 10.2 mm (boresight + theta = 60 deg scan).
' ----------------------------------------------
Dim oAnsoftApp
Dim oDesktop
Dim oProject
Dim oDesign
Dim oEditor
Dim oModule
Set oAnsoftApp = CreateObject("Ansoft.ElectronicsDesktop")
Set oDesktop = oAnsoftApp.GetAppDesktop()
oDesktop.RestoreWindow
Set oProject = oDesktop.SetActiveProject("Project_Name")
Set oDesign = oProject.SetActiveDesign("HFSSDesign_Name")
Set oModule = oDesign.GetModule("ReportSetup")

' ---------- Constants: Scan angle, speed of light (mm*GHz) ----------
Const PI = 3.14159265358979
Const c0 = 299.792458       ' mm*GHz
Const thetaScan = 60        ' deg, scan angle
Const dSpacingX = 5.9       ' mm, element spacing in x-direction (dx)
Const dSpacingY = 10.2      ' mm, element spacing in y-direction (dy)

' ---------- Frequency list: 10.5 : 0.5 : 14.5 GHz ----------
Dim freqList(8)
freqList(0) = 10.5
freqList(1) = 11
freqList(2) = 11.5
freqList(3) = 12
freqList(4) = 12.5
freqList(5) = 13
freqList(6) = 13.5
freqList(7) = 14
freqList(8) = 14.5

Dim i

' ================= First loop set: Phi = 0 deg, scanning in x-direction (dx), Plots 1~9 =================
For i = 0 To UBound(freqList)
    GeneratePatternPair freqList(i), i + 1, "0deg", "dx", dSpacingX
Next

' ================= Second loop set: Phi = 90 deg, scanning in y-direction (dy), Plots 10~18 =================
For i = 0 To UBound(freqList)
    GeneratePatternPair freqList(i), i + 1 + (UBound(freqList) + 1), "90deg", "dy", dSpacingY
Next


' =========================================================================
' Subroutine: For a specified frequency and Phi plane, initially generate and freeze the gain and axial ratio patterns at dx=dy=0 (boresight).
'      Subsequently, set scanVarName (dx or dy) to the corresponding phase difference for a theta = 60 deg scan given the element spacing,
'      freeze the second trace, and finally delete the original dynamic traces that update with the variables.
' Parameters:
'   freq          - Frequency value (GHz)
'   plotIdx       - Index of the currently generated plot
'   phiStr        - "0deg" or "90deg"
'   scanVarName   - "dx" or "dy", phase variable involved in the current scan loop
'   spacing       - Element spacing in the corresponding direction (mm)
' =========================================================================
Sub GeneratePatternPair(freq, plotIdx, phiStr, scanVarName, spacing)

    Dim freqStr, gainPlotName, arPlotName, sweepArgs, scanPhase, scanStr

    freqStr = Replace(CStr(freq), ",", ".") & "GHz"
    gainPlotName = "Realized Gain Plot " & plotIdx
    arPlotName   = "Axial Ratio Plot " & plotIdx

    ' ---- Step 1: Initialize dx and dy to zero to ensure a boresight pattern is generated. ----
    oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
      "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:dx", "Value:=", "0deg"))))
    oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
      "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:dy", "Value:=", "0deg"))))

    ' Common sweep/variable parameters for this frequency and Phi plane.
    sweepArgs = Array("Theta:=", Array("All"), "Phi:=", Array( _
      phiStr), "Freq:=", Array(freqStr), "l:=", Array("Nominal"), "w:=", Array( _
      "Nominal"), "pp_h:=", Array("Nominal"), "p_co:=", Array("Nominal"), "qie_l:=", Array( _
      "Nominal"), "h6:=", Array("Nominal"), "h5:=", Array("Nominal"), "h4:=", Array( _
      "Nominal"), "qie_r:=", Array("Nominal"), "h3:=", Array("Nominal"), "h2:=", Array( _
      "Nominal"), "h1:=", Array("Nominal"), "ouhefeng_l1:=", Array("Nominal"), "ouhefeng_w1:=", Array( _
      "Nominal"), "ouhefeng_l2:=", Array("Nominal"), "ouhefeng_w2:=", Array("Nominal"), "para_l:=", Array( _
      "Nominal"), "patch_l:=", Array("Nominal"), "feed_huan_r:=", Array("Nominal"), "feedy_w:=", Array( _
      "Nominal"), "feedx_w:=", Array("Nominal"), "feedy_l1:=", Array("Nominal"), "feedy_l2:=", Array( _
      "Nominal"), "feedx_l1:=", Array("Nominal"), "feed_pad_r:=", Array("Nominal"), "feed_r:=", Array( _
      "Nominal"), "feed_qie_r:=", Array("Nominal"), "feed_feng:=", Array("Nominal"), "dianqiao_w50:=", Array( _
      "Nominal"), "dianqiao_l50:=", Array("Nominal"), "dianqiao_w35:=", Array( _
      "Nominal"), "dianqiao_l35:=", Array("Nominal"), "dianqiao50_x:=", Array( _
      "Nominal"), "dianqiao50_y:=", Array("Nominal"), "dianqiao35_x:=", Array( _
      "Nominal"), "dianqiao35_y:=", Array("Nominal"), "dianqiao_jinchukou_w:=", Array( _
      "Nominal"), "dianqiao35_qie:=", Array("Nominal"), "h_1:=", Array("Nominal"), "h_2:=", Array( _
      "Nominal"), "h_3:=", Array("Nominal"), "h_4:=", Array("Nominal"), "h_5:=", Array( _
      "Nominal"), "h_6:=", Array("Nominal"), "dx:=", Array("Nominal"), "dy:=", Array( _
      "Nominal"), "dtr:=", Array("Nominal"))

    ' ---- Step 2: Create gain and axial ratio radiation patterns at dx=dy=0 (boresight). ----
    oModule.CreateReport gainPlotName, "Far Fields", "Rectangular Plot", "Setup1 : Sweep", _
      Array("Context:=", "EH"), sweepArgs, Array("X Component:=", "Theta", "Y Component:=", Array( _
      "dB(RealizedGainLHCP)", "dB(RealizedGainRHCP)"))

    oModule.CreateReport arPlotName, "Far Fields", "Rectangular Plot", "Setup1 : Sweep", _
      Array("Context:=", "EH"), sweepArgs, Array("X Component:=", "Theta", "Y Component:=", Array( _
      "dB(AxialRatioValue)"))

    ' ---- Step 3: Copy and paste to freeze the snapshot of the boresight traces. ----
    oModule.CopyTracesData gainPlotName, Array("dB(RealizedGainLHCP)", "dB(RealizedGainRHCP)")
    oModule.PasteTraces gainPlotName
    oModule.CopyTracesData arPlotName, Array("dB(AxialRatioValue)")
    oModule.PasteTraces arPlotName

    ' ---- Step 4: Calculate the phase difference between adjacent elements corresponding to a theta = 60 deg scan for this frequency and spacing, and set scanVarName (dx or dy). ----
    scanPhase = 360 * spacing * Sin(thetaScan * PI / 180) * freq / c0
    scanPhase = Int(scanPhase * 100 + 0.5) / 100   ' Retain two decimal places
    scanStr = Replace(CStr(scanPhase), ",", ".") & "deg"

    oDesign.ChangeProperty Array("NAME:AllTabs", Array("NAME:LocalVariableTab", Array("NAME:PropServers",  _
      "LocalVariables"), Array("NAME:ChangedProps", Array("NAME:" & scanVarName, "Value:=", scanStr))))

    ' ---- Step 5: Copy and paste again to freeze the snapshot of the scanned angle traces (the original traces are now updated to the scan angle). ----
    oModule.CopyTracesData gainPlotName, Array("dB(RealizedGainLHCP)", "dB(RealizedGainRHCP)")
    oModule.PasteTraces gainPlotName
    oModule.CopyTracesData arPlotName, Array("dB(AxialRatioValue)")
    oModule.PasteTraces arPlotName

    ' ---- Step 6: Delete the original dynamic traces, retaining only the two frozen snapshots (boresight + scan angle). ----
    oModule.DeleteTraces Array(gainPlotName & ":=", Array( _
      "dB(RealizedGainLHCP)", "dB(RealizedGainRHCP)"))
    oModule.DeleteTraces Array(arPlotName & ":=", Array("dB(AxialRatioValue)"))

End Sub