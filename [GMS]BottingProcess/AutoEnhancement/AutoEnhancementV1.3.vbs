'Please Note that this file should run in ".Q" file extension, I just copy all my code into this ".vbs" file in order to read
'Even QMacro uses language that based on VBS, we could still use '//' to comment out lanes
'Editor: Yibin Gu
'Upload Date: 2020/9/27


///////////////////////////////////////////////////////////////////////////////////
//Main 
Form1.ListBox1.List = ""
Form1.ListBox1.AddItem ("脚本开始于:" & now)
Call Lib.GMSR.乐玩注册()
Form1.ListBox1.AddItem ("插件注册成功")
Form1.ListBox1.AddItem ("游戏进程: " & Lib.GMSR.绑定GS窗口())
禁止外部输入 = lw.LockInput(2)
Form1.ListBox1.AddItem ("前台鼠标禁止触碰开启")
Form1.ListBox1.AddItem ("=================================")
//获得用户目标星数并寻找强化窗口
Dim target, location, protectnum, locProtect,HotKey
Global Pflag, starText                     //定义全局变量 Pflag: true = 保护开启中, false = 保护关闭中
Pflag = false
starText = ""
target = getStar() + 0
HotKey = Form1.Label8.Caption
Form1.Label8.Caption = HotKey
If target > 12 Then 
    Call familyCheck(HotKey)
    TracePrint "家族识别通过"
    Form1.ListBox1.AddItem ("家族识别通过")
    lw.KeyPress(HotKey)
End If
protectnum = split(getProt(), "|")
location = locateWindow()
Call 随机延迟()
Call checkStarCatching(location)//初始关闭星星抓取
Call 随机延迟()
Call 随机延迟()
locProtect = turnSafe(location, 0)//初始关闭保护
Dim numBreak, numCount
numBreak = 1
numCount = 1
If checkSafe(target, location, protectnum, locProtect) Then //主程序, Do-While循环
    Do
    	If numBreak / 10 > 1 Then 
    		Form1.ListBox1.AddItem ("已强化"&numCount&"次, 为避免掉线将随机移动数秒")
    		numBreak = 0
    		lw.KeyDown 37
    		lw.Delay 2500
    		lw.KeyUp 37
    		
    		lw.keyDown 39
    		lw.Delay 2500
    		lw.KeyUp 39
    		
    	End If
        Call 上星循环(location)
        numCount = numCount + 1
        numBreak = numBreak + 1
    Loop While checkSafe(target, location, protectnum, locProtect)
    If numCount > 0 Then 
    Form1.ListBox1.AddItem("已强化"&numCount&"次")
    End If
    Call ErMsg("上星完成!恭喜你![此处应有狗叫但是暂时还没做]")
Else 
    Call ErMsg ("目标星数 < 当前装备星数, 脚本结束")
End If
///////////////////////////////////////////////////////////////////////////////////
//用于将用户在UI中确定的星数返回给程序,
Function getStar()
    If Form1.OptionBox10.Value = 1 Then
        getStar = 10
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox11.Value = 1 Then
        getStar = 11
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox12.Value = 1 Then
        getStar = 12
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox13.Value = 1 Then
        getStar = 13
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox14.Value = 1 Then
        getStar = 14
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox15.Value = 1 Then
        getStar = 15
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox16.Value = 1 Then
        getStar = 16
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox17.Value = 1 Then
        getStar = 17
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox18.Value = 1 Then
        getStar = 18
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox19.Value = 1 Then
        getStar = 19
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox20.Value = 1 Then
        getStar = 20
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox21.Value = 1 Then
        getStar = 21
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox22.Value = 1 Then
        getStar = 22
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox6.Value = 1 Then
        getStar = 6
        Call showTarget(getStar)
        Exit Function
    ElseIf Form1.OptionBox7.Value = 1 Then
        getStar = 7
        Call showTarget(getStar)
        Exit Function
    Else 
        getStar = 0
        MsgBox "未选择目标星数量", 4096
        EndScript
    End If	
End Function
//用于将用户在UI中确定的保护星数返回给程序
Function getProt()
    Text = ""
    If Form1.CheckBox1.Value = 1 Then 
        Text = 12
        Call showProtect(12)
    End If
    If Form1.CheckBox2.Value = 1 Then
        Text = Text & "|" & 13
        Call showProtect(13)
    End If
    If Form1.CheckBox3.Value = 1 Then
        Text = Text & "|" & 14
        Call showProtect(14)
    End If
    If Form1.CheckBox4.Value = 1 Then
        Text = Text & "|" & 15
        Call showProtect(15)
    End If
    If Form1.CheckBox5.Value = 1 Then
        Text = Text & "|" & 16
        Call showProtect(16)
    End If
    getProt = Text
End Function
//解除绑定窗口
Sub OnScriptExit()
    ret = lw.UnBindWindow()
    lw.lockInput(0)
    TracePrint "脚本停止了"
    Form1.ListBox1.AddItem ("脚本停止于: "& now& ", 欢迎再次使用 -- 古古")
End Sub
//随机延迟
Function 随机延迟()
    Randomize
    延迟 = Int(rnd() * 100 + 450)
    lw.Delay 延迟
End Function
//报错声明
Sub ErMsg(str)
    Form1.ListBox1.AddItem (str)
    MsgBox str, 4096
    EndScript
End Sub
//识别数字
Function getStarNum(x, y)
    count = 1
    Do
        Call 随机延迟()
        num = Left(lw.Ocr(x, y, x + 70, y + 30, "ADADAD-555555", 0.8), 2)
        count = count + 1
    Loop Until count > 5 or len(num)>0
    If IsNumeric(Mid(num,2,1)) Then 
        getStarNum = num
        Exit Function
    ElseIf IsNumeric(Mid(num, 1, 1)) Then
        getStarNum = Mid(num, 1, 1)
        Exit Function
    Else 
        ErMsg ("抓取当前装备星数失败或装备破碎, 请重新开启脚本")
    End If
End Function
//定位上星窗口
Function locateWindow()
    Dim ZT
    For 3
        ZT = lw.findpic(0, 0, 1366, 768, "StarForce定位.bmp", "0", 0.9)
        If ZT = 1 Then 
            TracePrint "已经定位到了强化窗口,横向坐标为：" & lw.x & " 纵向坐标为：" & lw.y
            Dim loc(2)
            loc(0) = lw.x
            loc(1) = lw.y
            locateWindow = loc
            Exit Function
        End If
    Next
    ErMsg("未定位到强化窗口, 请确保开启强化并重新启动脚本")
End Function
//检查目标星数是否小于当前装备星数, 并且检查保护开启/关闭
Function checkSafe(star, location, protect, locProtect)
    cur = getStarNum(location(0) + 50, location(1) + 60) - 1
    starText = cur & "|" & starText
    Form1.ListBox1.AddItem ("当前装备星数: " & cur)
    TracePrint "当前装备星数: " & cur
    Dim x, y
    x = locProtect(0)
    y = locProtect(1)
    
    //加入一个额外的判断来判定是否连续失败2次(连续失败2次如果退回11星再次上星 保护检测会失效)
    If len(starText) > 11 and cur > 10 Then 
   		
   		Dim L1,L2,L3,L4
   		L1 = Mid(starText, 1,2)
   		L2 = Mid(starText, 4,2)
   		L3 = Mid(starText, 7,2)
   		L4 = Mid(starText, 10, 2)
   		
   		//TracePrint "检测到了4组数字: "&L1&L2&L3&L4
   		starText = Mid(starText, 1, 12)
   		
   		If L1 = L3 and L4 - L2 = 2 Then 
   			Pflag = false
   			//TracePrint "检测到了必成bug,现将保护flag调整为flase"
   		End If
   	End If
    
    
    If cur < 12 or cur > 17 Then 
        Pflag = false  
    ElseIf UBound(Filter(protect, cur)) + 1 = 1 and Pflag = false Then 
        lw.moveto x + 1, y+1
        lw.LeftClick 
        Pflag = true
    ElseIf UBound(Filter(protect, cur)) + 1 = 0 and Pflag = true Then
        lw.moveto x+1, y + 1
        lw.LeftClick 
        Pflag = false
    End If
    If star > cur Then 
        checkSafe = true
    Else 
        checkSafe = false
    End If
End Function
//上星循环, 完成一次上星操作
Sub 上星循环(location)
    count1 = 1
    count2 = 1
    Dim EH
    Do
        Call 随机延迟()
        lw.moveto location(0), location(1) + 230
        lw.LeftClick 
        EH = lw.findpic(0, 300, 1350, 570, "OK.bmp", "0", 0.9)
        count1 = count1 + 1	
    Loop Until EH = 1 or count1 > 5
    If EH = 1 Then 
        TracePrint "成功识别OK窗口"
        lw.moveto lw.x, lw.y
        lw.LeftClick 
        lw.delay 3700
        Do
            Call 随机延迟()
            EH = lw.findpic(0, 300, 1350, 570, "OK.bmp", "0", 0.9)
            count2 = count2 + 1	
        Loop Until EH = 1 or count2 > 5
        If EH = 1 Then 
            TracePrint "成功完成一次上星循环"
            lw.moveto lw.x, lw.y
            lw.LeftClick 
        Else 
            Call ErMsg( "未能正确完成上星循环, 脚本关闭")
        End If
    Else
        Call ErMsg( "未找到强化按钮, 请勿遮挡." & Chr(13) & "脚本关闭, 请重试")	
    End If
End Sub
//加入目标星数进入log
Sub showTarget(num)
    Form1.ListBox1.AddItem ("用户选择目标装备星数为:" & num)
End Sub
//加入上星保护进入log
Sub showProtect(num)
    Form1.ListBox1.AddItem (num & "星装备保护已开启")
End Sub
//开启保护开关,(0: off, 1: on)
Function turnSafe(location, i)
    Dim locRes,answer, x, y
    x = location(0)
    y = location(1)
    locRes = ifChecked(x + 150, y + 160)
    x = locRes(0)
    y = locRes(1)
    turnSafe = locRes
    If locRes(2) = 3 Then 
        Exit Function		
    ElseIf locRes(2) = 1 Then 
        If i = 0 Then 
            Exit Function
        ElseIf i = 1 Then
            lw.moveto x+1, y+1
            lw.LeftClick 
            Exit Function
        Else 
            ErMsg("未正确选择保护开关, 请重试")
        End If
    ElseIf locRes(2) = 2 Then
        If i = 1 Then 
            Exit Function
        ElseIf i = 0 Then
            lw.moveto x+1, y+1
            lw.LeftClick 
            Exit Function
        Else 
            ErMsg("未正确选择保护开关, 请重试")
        End If	
    End If
End Function
//抓星星默认关
Function checkStarCatching(location)
    Dim x, y, result
    x = location(0)
    y = location(1)
    result = ifChecked(x - 10, y + 160)
    If result(2) = 1 Then 
        lw.moveto result(0) + 1, result(1) + 1
        lw.LeftClick 
        Form1.ListBox1.AddItem ("检测到抓星星选项开启, 现已关闭:")
        Exit Function
    End If	
End Function
//检查框选是否被选中, 1:Unmark, 2:marked, 3: Unable
Function ifChecked(x,y)
    count = 1
    Dim flag, result(3)
    Do
        Call 随机延迟()
        flag = lw.findpic(x, y, x+30, y+30, "UnCheckedMark.bmp", "0", 0.9)
        count = count + 1
    Loop Until count > 2 or flag = 1	
    If flag = 1 Then 
        result(0) = lw.x
        result(1) = lw.y
        result(2) = 1
        ifChecked = result
        Exit Function
    Else 
        count = 1
        Do
            Call 随机延迟()
            flag = lw.findpic(x, y, x + 30, y + 30, "CheckedMark.bmp", "0", 0.9)
            count = count + 1
        Loop Until count > 2 or flag = 1
        If flag = 1 Then 
            result(0) = lw.x
            result(1) = lw.y
            result(2) = 2
            ifChecked = result
            Exit Function
        Else 
            count = 1
            Do
                Call 随机延迟()
                flag = lw.findpic(x, y, x + 30, y + 30, "UnableMark.bmp", "0", 0.9)
                count = count + 1
            Loop Until count > 2 or flag = 1
            If flag = 1 Then 
                result(0) = lw.x
                result(1) = lw.y
                result(2) = 3
                ifChecked = result
                Exit Function
            Else 
                ErMsg ("未正确定位到框选窗口, 请重新开启脚本")
            End If
        End If
    End If
End Function
//检查是否为家族成员
Function familyCheck(HotKey)
    If isNumeric(Hotkey) and Hotkey <> "" Then 
        lw.KeyPress (HotKey)
        Dim guild, count
        count = 1
        Do
            Call 随机延迟()
            guild = lw.findpic(0, 0, 1366, 768, "FarmStory.bmp", "555555", 0.6)
            count = count + 1
        Loop Until guild = 1 or count > 3
        Call 随机延迟()
        count = 1
        Do
            Call 随机延迟()
            guild = lw.findpic(0, 0, 1366, 768, "UuccStory.bmp", "555555", 0.6)
            count = count + 1
        Loop Until guild = 1 or count > 3
        If guild <> 1 Then 
            ErMsg("未正确识别UsFs家族, 脚本关闭")
        End If
    Else 
        ErMsg("未正确识别家族按键, 脚本结束."&Chr(13)&"请在本窗口关闭后重新输入家族按键")
    End If
End Function
Event Form1.Button1.Click
    Dim myVar, Key
    Form1.Label8.Caption = "Waiting"
    myVar = MsgBox("12星或以上的强化必须要求用户角色在UsFs家族内!"&Chr(13)& "请在点击确认后输入开启家族面板对应按键: ", 0, "按键输入请求")
    Key = WaitKey()
    Form1.Label8.Caption = Key
End Event
