# [GMS]BottingProcess

In this folder is my attempt to automate the operation of the **MapleStory[Global.ver]**(GMS)

> **Notice that**: This project was created solely for research and learning purposes. The usage of this project for malicious purposes in-game is against Nexon's terms of service and, thus, *discouraged*.

## Introduction
Arrding to [Wiki](<https://en.wikipedia.org/wiki/MapleStory>), **MapleStory** is a free-to-play, 2D, side-scrolling massively multiplayer online role-playing game, developed by South Korean company Wizet. Several versions of the game are available for specific countries or regions, and each is published by various companies such as Nexon.

**Why GMS?** 

**MapleStory** global version is using DirectX mode in window framing, which means if the game is running in this window mode, it cannot(or they did not do it) block the virtual input based on DX mode. According to this fact, we could use some programs that simulates key/mouse input into the game window. 

## What tool I use?
QMacro is the tool that is a simulation of mouse keyboard action software. By making a script, you can make the program instead of your hands to automatically execute a series of mouse and keyboard actions. This tool use their own coding language based on **VB**.

>**Note that**: This is a Chinese language based tool and for more information can be found here: [QMacro Desprition(in Chinese)](<https://baike.baidu.com/item/%E6%8C%89%E9%94%AE%E7%B2%BE%E7%81%B5>)

The advantage of using this software is that it is free, convenient and can consult a lot of materials. Moreover, since this software has been used by the public for nearly 10 years, the development and use of plug-ins are very mature.


## What is the challenge?
I think the biggest problem so far is how to effectively bypass the script detection built into the game.

At present, I have observed two phenomena:

1. When a series of instructions are repeatedly operated for more than a certain number of times in a short period of time (such as mouse click + move back and forth), the game will automatically flash back to the channel selection interface.

2. When the game window is captured with high frequency, the game will be forced to close and a hacker warning will pop up.

>**How to solve those issues will be present in my following program/codes**

## What I did so far?

By using QMacro, I can package my script into an independent program. These kind of programs are called **Mini-QMacro**.

### Auto Enchancement Program
This program is for auto enchancement/reinforcement(as the name says). Equipment reinforcement is a very painful process in GMS. In the later reinforcement, the success rate of equipment reinforcement is less than 40%, and the failure of reinforcement will reduce the reinforcement stage by an additional level (and there is a small chance to damage the equipment).
>For more information about **GMS Star Force Enhancement System** can be found here: [Star Force Enhancement](<https://strategywiki.org/wiki/MapleStory/Spell_Trace_and_Star_Force#Star_Force_Enhancement>)

Thus, I came up with a tool that would help me do the enchancement process and stop at a given enhancement level.
>For more information, see the folder under the name [AutoEnhancement]
