@echo OFF
color 0a
Title Sunny-Ngrok�������� by Sunny
Mode con cols=109 lines=30
:START
ECHO.
Echo                  ==========================================================================
ECHO.
Echo                                         Sunny-Ngrok�ͻ�����������
ECHO.
Echo                                         ����: Sunny QQ��327388905
ECHO.
Echo                                         �ٷ�QQȺ��532387951��һ��Ⱥ������ 276155731������Ⱥ��
ECHO.
Echo                                         ������www.ngrok.cc
ECHO.
Echo                                         ���߲��ͣ�www.sunnyos.com
ECHO.
Echo                  ==========================================================================
Echo.
echo.
echo.
:TUNNEL
set /p clientid= ������Ҫ�����Ŀͻ���id������ͻ���id��ʹ��Ӣ�Ķ��ţ�,��������
echo.
sunny.exe clientid %clientid%
PAUSE
goto TUNNEL

