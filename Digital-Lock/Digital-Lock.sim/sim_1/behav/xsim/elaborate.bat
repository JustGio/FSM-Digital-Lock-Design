@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Fri Jan 28 16:05:28 -0800 2022
REM SW Build 2552052 on Fri May 24 14:49:42 MDT 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 514212cb5a514440b4aec704172b71ea --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot fsm_tb_behav xil_defaultlib.fsm_tb -log elaborate.log"
call xelab  -wto 514212cb5a514440b4aec704172b71ea --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot fsm_tb_behav xil_defaultlib.fsm_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
