#SingleInstance force

;Checking to see if a list already exist, if not creates one with a default entry.

if !fileexist("list")
{
 FileAppend , Take a nap, list
}



   Menu, Tray, Click, 1
   Menu, Tray, NoStandard
   Menu, Tray, Add, View, DoubleClick
   Menu, Tray, Default, View
   Menu, Tray, Add, Exit


;finding the x cord for the done button
buttonx:=207/2
buttonx:=buttonx-30

obuttonx:=buttonx-40 ;and for the save button, and in more recent versions this is also the cord for the done button.

text1:=obuttonx+68 ; position for the or text
text2:=text1+20 ; position for the cancel and skip button

;reads the first line in the todo list, if its empty then it states that the user is all done.
FileReadLine, start, list, 1
if start=
{
start=All Done!
}

gui,color,black
Gui, Add, Edit,velist x12 y12 w180 h160 , 
gui, font, s20
Gui, Add, Text, x0 y85 w207 cwhite h160 center, %start%

gui, font, s10
Gui, Add, Button, x%obuttonx% y182 w60 h20 gdone,Done

Gui, Add, Button, x%obuttonx% y182 w60 h20 gsave, Save
Gui, Add, text, x%text1% y182 w20 h20 cwhite, or
Gui, Add, text, x%text2% y182 w60 h20 cwhite gcancel, cancel
Gui, Add, Text, x0 y212 w207 h20 center geditlist cwhite, edit list


Gui, Add, text, x%text1% y182 w20 h20 cwhite, or
Gui, Add, text, x%text2% y182 w60 h20 cwhite gskip, skip

Gui, Show, x311 y86 h246 w207, YATL

;hides the controls for the todolist editing.
Control, hide ,,Edit1, YATL
Control, hide ,,Button2, YATL
Control, hide ,,Static2, YATL
Control, hide ,,Static3, YATL


Return



skip:
newfile=

;in this part its checking to see if there is another entry so it won't skip the last one.
FileReadLine, tester, list, 2

if tester=
{
elist=
return
}

;puts the first entry at the end of the file.

fileread, list,list
filedelete, list

Loop, Parse, list , `n
{
if A_LoopField=
{
Continue
}
if a_index=1
{
last=%A_LoopField%
}
else
{
newfile=%newfile%%A_LoopField%`n
}

}
newfile=%newfile%%last%`n
fileappend,%newfile%,list
FileReadLine, start, list, 1
ControlSetText , Static1,%start%, YATL
WinSet, redraw,, YATL

return

editlist:
elist=
Control, hide ,,Static1 , YATL
Control, hide ,,Static4, YATL
Control, hide ,,Button1 , YATL
Control, hide ,,Static5, YATL
Control, hide ,,Static6 , YATL
Control, show ,,Edit1 , YATL
Control, show ,,Button2, YATL
Control, show ,,Static2, YATL
Control, show ,,Static3, YATL

FileRead, list, list

ControlSetText , Edit1,%list%, YATL

return


done:
elist=
newfile=
FileRead, list, list
FileReadLine, tester, list, 2
if tester=
{
ControlSetText , Static1,All Done!, YATL
WinSet, redraw,, YATL
filedelete, list
elist=
return
}
filedelete, list
Loop, Parse, list , `n
{


if a_index!=1
{
newfile=%newfile%%A_LoopField%`n
}

}
fileappend,%newfile%,list
FileReadLine, start, list, 1
ControlSetText , Static1,%start%, YATL
WinSet, redraw,, YATL

return

cancel:
Control, hide ,,Edit1 , YATL
Control, hide ,,Button2, YATL
Control, hide ,,Static2, YATL
Control, hide ,,Static3, YATL
Control, show ,,Static1 , YATL
Control, show ,,Static4, YATL
Control, show ,,Button1 , YATL
Control, show ,,Static5, YATL
Control, show ,,Static6 , YATL

return

save:
elist=
gui,submit,nohide
Control, hide ,,Edit1 , YATL
Control, hide ,,Button2, YATL
Control, hide ,,Static2, YATL
Control, hide ,,Static3, YATL
Control, show ,,Static1 , YATL
Control, show ,,Static4, YATL
Control, show ,,Button1 , YATL
Control, show ,,Static5, YATL
Control, show ,,Static6 , YATL
filedelete,list
fileappend,%elist%,list
FileReadLine, start, list, 1
ControlSetText , Static1,%start%, YATL
WinSet, redraw,, YATL
return

DoubleClick:
   MouseGetPos, , , WhichWindow, WhichControl
   WinGetClass, WhichClass, ahk_id %WhichWindow%
   If WhichClass = Shell_TrayWnd
      {
         IfInString, WhichControl, ToolbarWindow32
            {
               If Clicks =
                  {
                     SetTimer, SingleClick, 500
                     Clicks = 1
                     Return
                  }
            }
      }
   SetTimer, SingleClick, Off
   Sleep, 500   
  gui show
   Clicks =
   Return

SingleClick:   
   SetTimer, SingleClick, Off

   Clicks =
   Return
   
exit:

exitapp

GuiClose:

Control, hide ,,Edit1 , YATL
Control, hide ,,Button2, YATL
Control, hide ,,Static2, YATL
Control, hide ,,Static3, YATL
Control, show ,,Static1 , YATL
Control, show ,,Static4, YATL
Control, show ,,Button1 , YATL
Control, show ,,Static5, YATL
Control, show ,,Static6 , YATL
gui hide
return
