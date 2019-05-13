fsRZ6               = 48828;

%TRGsel:
%Bit 0 = ZBusB
%Bit 1 = External
%Bit 2 = Software

%SNDsel

%N.B. in case of WAV only two different WAV files (WAV-A for channel A and WAV-B for channel B) can be played during a trial. But they can be played multiple times.
%N.B. in case of A=B the SND-A or WAV-A is played at channel A and channel B

%ACQsel:
%Bit 0..7 = Acquisition Ch0..Ch7



MUX0                = int32(0*16);
MUX1                = int32(1*16);
MUX2                = int32(2*16);
MUX3                = int32(3*16);
MUX_Set             = int32(64);
MUX_Rst             = int32(128);

SPKMOV(1)           = MUX0 + 0;  %mux + index
SPKMOV(2)           = MUX1 + 0;
SPKMOV(3)           = MUX0 + 1;
SPKMOV(4)           = MUX1 + 1;
SPKMOV(5)           = MUX0 + 2;
SPKMOV(6)           = MUX1 + 2;
SPKMOV(7)           = MUX0 + 3;
SPKMOV(8)           = MUX1 + 3;
SPKMOV(9)           = MUX0 + 4;
SPKMOV(10)          = MUX1 + 4;
SPKMOV(11)          = MUX0 + 5;
SPKMOV(12)          = MUX1 + 5;
SPKMOV(13)          = MUX0 + 6;
SPKMOV(14)          = MUX1 + 6;
SPKMOV(15)          = MUX0 + 7;
SPKMOV(16)          = MUX1 + 7;
SPKMOV(17)          = MUX0 + 8;
SPKMOV(18)          = MUX1 + 8;
SPKMOV(19)          = MUX0 + 9;
SPKMOV(20)          = MUX1 + 9;
SPKMOV(21)          = MUX0 + 10;

MOV_Nr_of_Ch        = 21;
MOV_Sp0_is_A        = 1;

start               = 1;
stop                = 0;

A0                  = int32(1);
A1                  = int32(2);
A2                  = int32(4);
A3                  = int32(8);
A4                  = int32(16);
A5                  = int32(32);
A6                  = int32(64);
A7                  = int32(128);

B0                  = int32(1);
B1                  = int32(2);
B2                  = int32(4);
B3                  = int32(8);
B4                  = int32(16);
B5                  = int32(32);
B6                  = int32(64);
B7                  = int32(128);

STM_nTrials         = 5;
STM_nPars           = 7;

LPfreq              = int32(4000);
HPfreq              = int32(300);

TRG_AUTO            = int32(0);
TRG_ZBus            = int32(1);
INP_EVT             = int32(2);
TRG_Soft            = int32(4);

ACT_Wait_For_TRG    = int32(0);
ACT_SND_A           = int32(1);
ACT_SND_B           = int32(2);
ACT_MUX             = int32(3);
ACT_Signaling       = int32(4);
ACT_MOV             = int32(5);
ACT_ACQ             = int32(6);
ACT_DIO_out         = int32(7);
ACT_TRG_Out         = int32(8);

SND_None            = int32(0);
SND_Stop            = int32(1);
SND_Tone            = int32(2);
SND_Sweep           = int32(3);
SND_Noise           = int32(4);
SND_Ripple          = int32(5);
SND_WAV             = int32(6);
SND_B_is_A          = int32(7);



% construction of STM data matrix
STM_1(1)            = ACT_Wait_For_TRG; % action type
STM_2(1)            = int32(0);         % sound type none
STM_3(1)            = int32(0);         %delay in milisecs
STM_4(1)            = int32(INP_EVT);   %Par1
STM_5(1)            = int32(A4);        %Par2
STM_6(1)            = int32(0);         %Par3
STM_7(1)            = int32(0);         %Par4 %attenuation A&B

STM_1(2)            = ACT_SND_A;        % action type
STM_2(2)            = int32(SND_Noise);  % sound type
STM_3(2)            = int32(0);      %delay in milisecs
STM_4(2)            = int32(LPfreq);       %Par1
STM_5(2)            = int32(HPfreq);         %Par2
STM_6(2)            = int32(0);         %Par3
STM_7(2)            = int32(10);        %Par4 %attenuation A&B

STM_1(3)            = ACT_ACQ;        % action type
STM_2(3)            = int32(0);
STM_3(3)            = int32(500);      % delay
STM_4(3)            = int32(start);    % ACQ Ch1  ACQ start
STM_5(3)            = int32(1);       %Par2 ACQ time
STM_6(3)            = int32(1);     %Par3 ACQ Ch1
STM_7(3)            = int32(0);        %Par4 %attenuation A&B

STM_1(4)            = ACT_ACQ;        % action type
STM_2(4)            = int32(0);  % sound type
STM_3(4)            = int32(1000);      %delay in milisecs
STM_4(4)            = int32(stop);         %Par1
STM_5(4)            = int32(0);         %Par2
STM_6(4)            = int32(1);         %Par3  ACQ Ch1
STM_7(4)            = int32(0);        %Par4 %attenuation A&B

STM_1(5)            = ACT_SND_A;        % action type
STM_2(5)            = int32(SND_Stop);  % sound type
STM_3(5)            = int32(2000);      %delay in milisecs
STM_4(5)            = int32(0);         %Par1
STM_5(5)            = int32(0);         %Par2
STM_6(5)            = int32(0);         %Par3
STM_7(5)            = int32(0);        %Par4 %attenuation A&B

STM_data = [STM_1(1) STM_2(1) STM_3(1) STM_4(1) STM_5(1) STM_6(1) STM_7(1)
            STM_1(2) STM_2(2) STM_3(2) STM_4(2) STM_5(2) STM_6(2) STM_7(2)
            STM_1(3) STM_2(3) STM_3(3) STM_4(3) STM_5(3) STM_6(3) STM_7(3)
            STM_1(4) STM_2(4) STM_3(4) STM_4(4) STM_5(4) STM_6(4) STM_7(4)
            STM_1(5) STM_2(5) STM_3(5) STM_4(5) STM_5(5) STM_6(5) STM_7(5)];


% communication with RZ6

zBus = actxcontrol('ZBUS.x',[1 1 1 1]);

if zBus.ConnectZBUS('GB')
 e = 'ZBus connected';
else
 e = 'Unable to connect ZBus'
end  

%Connects to RZ6 #1 via Optical Gigabit
RZ6=actxcontrol('RPco.x',[5 5 26 26]);

if RZ6.ConnectRZ6('GB',1)
 e = 'RZ6 connected';
else
 e = 'Unable to connect RZ6'
end

if RZ6.LoadCOF('U:\##BIOFYSICA\#P078 Universal RCX program\RCX Uni 3C 50kHz V2.05.rcx')
 e='LoadCOF OK';
else
 e='LoadCOF error'
end

RZ6.Run;

if RZ6.WriteTagVEX('DataArray', 0, 'I32', transpose(STM_data)) %transpose to single column
 e='WriteTagV OK';
else
 e='WriteTagVEX1 error'
end

if RZ6.WriteTagVEX('MOV_Sp_Array', 0, 'I32', transpose(SPKMOV)) %transpose to single column
 e='WriteTagV OK';
else
 e='WriteTagVEX2 error'
end

if RZ6.SetTagVal('MOV_Sp0_is_A', MOV_Sp0_is_A ) %transpose to single column
 e='SetTagV OK';
else
 e='SetTagVal error'
end


pause(0.1);
zBus.zBusTrigA(0, 0, 5);

Matrix1 = RZ6.ReadTagVEX('DataArray',0, 1,'I32','I32',STM_nPars*STM_nTrials)
Matrix2 = RZ6.ReadTagVEX('MOV_Sp_Array',0, 1,'I32','I32',MOV_Nr_of_Ch)




