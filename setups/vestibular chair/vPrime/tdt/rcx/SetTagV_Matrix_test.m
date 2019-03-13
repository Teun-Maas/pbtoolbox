a1 = [0	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21];
a2 = [1 2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	21];
a3 = [0	1	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20];
a4 = [0	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21];
a5 = [0	0	1	1	2	2	3	3	4	4	5	5	6	6	7	7	8	8	9	9	10	9];
a6 = [0	2	3	2	3	2	3	2	3	2	3	2	3	2	3	2	3	2	3	2	3	2];
a7 = [0	0	0	0	1	1	2	2	3	3	4	4	5	5	6	6	7	7	8	8	9	9];
a8 = [0	2	3	2	3	2	3	2	3	2	3	2	3	2	3	2	3	2	3	2	3	2];

A = [a1;a2;a3;a4;a5;a6;a7;a8];

%Connects to RZ6 #1 via Optical Gigabit
RP=actxcontrol('RPco.x',[5 5 26 26]);
if RP.ConnectRZ6('GB',1)
 e='connected'
else
 e='Unable to connect'
end

RP.LoadCOF('U:\##BIOFYSICA\#P075 Moving sound\SetTagV_Matrix_test2.rcx');
RP.Run;

if RP.WriteTagVEX('STM_Data', 0, 'F32', A)
 e='WriteTagVEX OK'
else
 e='WriteTagVEX error'
end

Matrix = RP.ReadTagVEX('STM_Data',0,22,'F32','F64',8)
