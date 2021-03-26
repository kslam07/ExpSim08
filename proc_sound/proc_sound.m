%% POST-PROCESSING SOUND

clear all
close all
clc

%% TO BE IMPLEMENTED

% Strouhal
% Distance correction
% Check windmilling second engine

%% LOAD data

load('on_poff_side.mat');
load('jprop.mat');
load('stab_r0.mat');
load('stab_r5.mat');
load('stab_r10.mat');
load('stab_r0_both.mat');
load('stab_r5_both.mat');
load('stab_r10_both.mat');
load('thrust2.mat');

%% SORT THRUST DATA - Rudder 0deg

% Thrust2
T_c_list = table2array(t.i1.rud0(:,7));
T_vInf = table2array(t.i1.rud0(:,19));
T_AoS = table2array(t.i1.rud0(:,6));
T_rEng = table2array(t.i1.rud0(:,24));
T_J = table2array(t.i1.rud0(:,28));

% copy jprop measurements
Tj = T_c_list(34:36);
Tj_vInf = T_vInf(34:36);
Tj_J = T_J(34:36);

% Remove jprop measurements and 13th measurement
T_c_list(34:36) = [];
T_vInf(34:36) = [];
T_AoS(34:36) = [];
T_rEng(34:36) = [];

T_c_list(13) = [];
T_vInf(13) = [];
T_AoS(13) = [];
T_rEng(13) = [];

left_idx = find(T_rEng == 0);
both_idx = find(T_rEng ~= 0);

left_T = T_c_list(left_idx);
both_T = T_c_list(both_idx);
left_T_vInf = T_vInf(left_idx);
both_T_vInf = T_vInf(both_idx);
left_T_AoS = T_AoS(left_idx);
both_T_AoS = T_AoS(both_idx);

% sort for windtunnel speed
% and keep the sort index in "sortIdx"
[left_T_vInf, sortIdx1] = sort(left_T_vInf,'ascend');
[both_T_vInf, sortIdx2] = sort(both_T_vInf,'ascend');

% sort variables according to windtunnel speed
left_T = left_T(sortIdx1);
left_T_AoS = left_T_AoS(sortIdx1);
both_T = both_T(sortIdx2);
both_T_AoS = both_T_AoS(sortIdx2);

% split measurements
lidx1 = find(left_T_vInf == 20);
lidx2 = find(left_T_vInf == 40);
bidx1 = find(both_T_vInf == 20);
bidx2 = find(both_T_vInf == 40);

% sort slideslip for Vinf = 20 in ascending order
% and keep the sort index in "sortIdx"
[left_T_AoS(lidx1), sortIdx1] = sort(left_T_AoS(lidx1),'ascend');
[both_T_AoS(bidx1), sortIdx2] = sort(both_T_AoS(bidx1),'ascend');

% sort sound according to Vinf = 20 and sideslip
left_T(lidx1) = left_T(sortIdx1);
both_T(bidx1) = both_T(sortIdx2);

% sort slideslip for Vinf = 40 in ascending order
% and keep the sort index in "sortIdx"
[left_T_AoS(lidx2), sortIdx3] = sort(left_T_AoS(lidx2),'ascend');
[both_T_AoS(bidx2), sortIdx4] = sort(both_T_AoS(bidx2),'ascend');

% sort sound according to Vinf = 40 and sideslip
left_T(lidx2) = left_T(length(sortIdx1)+sortIdx3);
both_T(bidx2) = both_T(length(sortIdx2)+sortIdx4);

Tc_r0 = left_T;
Tc_r0_both = both_T;
T_vInf_r0 = left_T_vInf;
T_vInf_r0_both = both_T_vInf;
T_AoS_r0 = left_T_AoS;
T_AoS_r0_both = both_T_AoS;

%% SORT THRUST DATA - Rudder 5deg

% Thrust2
T_c_list = table2array(t.i1.rud5(:,7));
T_vInf = table2array(t.i1.rud5(:,19));
T_AoS = table2array(t.i1.rud5(:,6));
T_rEng = table2array(t.i1.rud5(:,24));

left_idx = find(T_rEng == 0);
both_idx = find(T_rEng ~= 0);

left_T = T_c_list(left_idx);
both_T = T_c_list(both_idx);
left_T_vInf = T_vInf(left_idx);
both_T_vInf = T_vInf(both_idx);
left_T_AoS = T_AoS(left_idx);
both_T_AoS = T_AoS(both_idx);

% sort for windtunnel speed
% and keep the sort index in "sortIdx"
[left_T_vInf, sortIdx1] = sort(left_T_vInf,'ascend');
[both_T_vInf, sortIdx2] = sort(both_T_vInf,'ascend');

% sort variables according to windtunnel speed
left_T = left_T(sortIdx1);
left_T_AoS = left_T_AoS(sortIdx1);
both_T = both_T(sortIdx2);
both_T_AoS = both_T_AoS(sortIdx2);

% split measurements
lidx1 = find(left_T_vInf == 20);
lidx2 = find(left_T_vInf == 40);
bidx1 = find(both_T_vInf == 20);
bidx2 = find(both_T_vInf == 40);

% sort slideslip for Vinf = 20 in ascending order
% and keep the sort index in "sortIdx"
[left_T_AoS(lidx1), sortIdx1] = sort(left_T_AoS(lidx1),'ascend');
[both_T_AoS(bidx1), sortIdx2] = sort(both_T_AoS(bidx1),'ascend');

% sort sound according to Vinf = 20 and sideslip
left_T(lidx1) = left_T(sortIdx1);
both_T(bidx1) = both_T(sortIdx2);

% sort slideslip for Vinf = 40 in ascending order
% and keep the sort index in "sortIdx"
[left_T_AoS(lidx2), sortIdx3] = sort(left_T_AoS(lidx2),'ascend');
[both_T_AoS(bidx2), sortIdx4] = sort(both_T_AoS(bidx2),'ascend');

% sort sound according to Vinf = 40 and sideslip
left_T(lidx2) = left_T(length(sortIdx1)+sortIdx3);
both_T(bidx2) = both_T(length(sortIdx2)+sortIdx4);

Tc_r5 = left_T;
Tc_r5_both = both_T;
T_vInf_r5 = left_T_vInf;
T_vInf_r5_both = both_T_vInf;
T_AoS_r5 = left_T_AoS;
T_AoS_r5_both = both_T_AoS;

%% SORT THRUST DATA - Rudder 10deg

% Thrust2
T_c_list = table2array(t.i1.rud10(:,7));
T_vInf = table2array(t.i1.rud10(:,19));
T_AoS = table2array(t.i1.rud10(:,6));
T_rEng = table2array(t.i1.rud10(:,24));

% copy 19th measurement to 1 and delete
T_c_list(1) = T_c_list(19);
T_vInf(1) = T_vInf(19);
T_AoS(1) = T_AoS(19);
T_rEng(1) = T_rEng(19);

T_c_list(19) = [];
T_vInf(19) = [];
T_AoS(19) = [];
T_rEng(19) = [];

left_idx = find(T_rEng == 0);
both_idx = find(T_rEng ~= 0);

left_T = T_c_list(left_idx);
both_T = T_c_list(both_idx);
left_T_vInf = T_vInf(left_idx);
both_T_vInf = T_vInf(both_idx);
left_T_AoS = T_AoS(left_idx);
both_T_AoS = T_AoS(both_idx);

% sort for windtunnel speed
% and keep the sort index in "sortIdx"
[left_T_vInf, sortIdx1] = sort(left_T_vInf,'ascend');
[both_T_vInf, sortIdx2] = sort(both_T_vInf,'ascend');

% sort variables according to windtunnel speed
left_T = left_T(sortIdx1);
left_T_AoS = left_T_AoS(sortIdx1);
both_T = both_T(sortIdx2);
both_T_AoS = both_T_AoS(sortIdx2);

% split measurements
lidx1 = find(left_T_vInf == 20);
lidx2 = find(left_T_vInf == 40);
bidx1 = find(both_T_vInf == 20);
bidx2 = find(both_T_vInf == 40);

% sort slideslip for Vinf = 20 in ascending order
% and keep the sort index in "sortIdx"
[left_T_AoS(lidx1), sortIdx1] = sort(left_T_AoS(lidx1),'ascend');
[both_T_AoS(bidx1), sortIdx2] = sort(both_T_AoS(bidx1),'ascend');

% sort sound according to Vinf = 20 and sideslip
left_T(lidx1) = left_T(sortIdx1);
both_T(bidx1) = both_T(sortIdx2);

% sort slideslip for Vinf = 40 in ascending order
% and keep the sort index in "sortIdx"
[left_T_AoS(lidx2), sortIdx3] = sort(left_T_AoS(lidx2),'ascend');
[both_T_AoS(bidx2), sortIdx4] = sort(both_T_AoS(bidx2),'ascend');

% sort sound according to Vinf = 40 and sideslip
left_T(lidx2) = left_T(length(sortIdx1)+sortIdx3);
both_T(bidx2) = both_T(length(sortIdx2)+sortIdx4);

Tc_r10 = left_T;
Tc_r10_both = both_T;
T_vInf_r10 = left_T_vInf;
T_vInf_r10_both = both_T_vInf;
T_AoS_r10 = left_T_AoS;
T_AoS_r10_both = both_T_AoS;

%% SORT NOISE DATA - Prop off

% sort for windtunnel speed
% and keep the sort index in "sortIdx"
[opp_on_poff_side.vInf, sortIdx] = sort(opp_on_poff_side.vInf,'ascend');

% sort variables according to windtunnel speed
opp_on_poff_side.AoS = opp_on_poff_side.AoS(sortIdx);
SPL_zero = SPL_on_poff_side(sortIdx);
f_zero = f_on_poff_side(sortIdx);
PXX_zero = PXX_on_poff_side(sortIdx);

% split measurements
widx1 = find(opp_on_poff_side.vInf == 20);
widx2 = find(opp_on_poff_side.vInf == 40);

% sort slideslip for Vinf = 20 in ascending order
% and keep the sort index in "sortIdx"
[opp_on_poff_side.AoS(widx1), sortIdx1] = sort(opp_on_poff_side.AoS(widx1),'ascend');

% sort sound according to Vinf = 20 and sideslip
SPL_zero(widx1) = SPL_zero(sortIdx1);
f_zero(widx1) = f_zero(sortIdx1);
PXX_zero(widx1) = PXX_zero(sortIdx1);

% sort slideslip for Vinf = 40 in ascending order
% and keep the sort index in "sortIdx"
[opp_on_poff_side.AoS(widx2), sortIdx2] = sort(opp_on_poff_side.AoS(widx2),'ascend');

% sort sound according to Vinf = 40 and sideslip
SPL_zero(widx2) = SPL_zero(length(sortIdx1)+sortIdx2);
f_zero(widx2) = f_zero(length(sortIdx1)+sortIdx2);
PXX_zero(widx2) = PXX_zero(sortIdx2);

%% SORT NOISE DATA - Rudder 0deg

% sort for windtunnel speed
% and keep the sort index in "sortIdx"
[opp_stab_r0.vInf, sortIdx] = sort(opp_stab_r0.vInf,'ascend');
[opp_stab_r0_both.vInf, sortIdx_b] = sort(opp_stab_r0_both.vInf,'ascend');

% sort variables according to windtunnel speed
opp_stab_r0.AoS = opp_stab_r0.AoS(sortIdx);
SPL = SPL_stab_r0(sortIdx);
f = f_stab_r0(sortIdx);
PXX = PXX_stab_r0(sortIdx);
RPS_M1 = opp_stab_r0.RPS_M1(sortIdx);
RPS_M2 = opp_stab_r0.RPS_M2(sortIdx);

opp_stab_r0_both.AoS = opp_stab_r0_both.AoS(sortIdx_b);
SPL_both = SPL_stab_r0_both(sortIdx_b);
f_both = f_stab_r0_both(sortIdx_b);
PXX_both = PXX_stab_r0_both(sortIdx_b);
RPS_M1_both = opp_stab_r0_both.RPS_M1(sortIdx_b);
RPS_M2_both = opp_stab_r0_both.RPS_M2(sortIdx_b);

% split measurements
widx1 = find(opp_stab_r0.vInf == 20);
widx2 = find(opp_stab_r0.vInf == 40);

widx1_b = find(opp_stab_r0_both.vInf == 20);
widx2_b = find(opp_stab_r0_both.vInf == 40);

% sort slideslip for Vinf = 20 in ascending order
% and keep the sort index in "sortIdx"
[opp_stab_r0.AoS(widx1), sortIdx1] = sort(opp_stab_r0.AoS(widx1),'ascend');
[opp_stab_r0_both.AoS(widx1_b), sortIdx1_b] = sort(opp_stab_r0_both.AoS(widx1_b),'ascend');

% sort sound according to Vinf = 20 and sideslip
SPL(widx1) = SPL(sortIdx1);
f(widx1) = f(sortIdx1);
PXX(widx1) = PXX(sortIdx1);
RPS_M1(widx1) = RPS_M1(sortIdx1);
RPS_M2(widx1) = RPS_M2(sortIdx1);

SPL_both(widx1_b) = SPL_both(sortIdx1_b);
f_both(widx1_b) = f_both(sortIdx1_b);
PXX_both(widx1_b) = PXX_both(sortIdx1_b);
RPS_M1_both(widx1_b) = RPS_M1_both(sortIdx1_b);
RPS_M2_both(widx1_b) = RPS_M2_both(sortIdx1_b);

% sort slideslip for Vinf = 40 in ascending order
% and keep the sort index in "sortIdx"
[opp_stab_r0.AoS(widx2), sortIdx2] = sort(opp_stab_r0.AoS(widx2),'ascend');
[opp_stab_r0_both.AoS(widx2_b), sortIdx2_b] = sort(opp_stab_r0_both.AoS(widx2_b),'ascend');

% sort sound according to Vinf = 40 and sideslip
SPL(widx2) = SPL(length(sortIdx1)+sortIdx2);
f(widx2) = f(length(sortIdx1)+sortIdx2);
PXX(widx2) = PXX(length(sortIdx1)+sortIdx2);
RPS_M1(widx2) = RPS_M1(length(sortIdx1)+sortIdx2);
RPS_M2(widx2) = RPS_M2(length(sortIdx1)+sortIdx2);

SPL_both(widx2_b) = SPL_both(length(sortIdx1_b)+sortIdx2_b);
f_both(widx2_b) = f_both(length(sortIdx1_b)+sortIdx2_b);
PXX_both(widx2_b) = PXX_both(length(sortIdx1_b)+sortIdx2_b);
RPS_M1_both(widx2_b) = RPS_M1_both(length(sortIdx1_b)+sortIdx2_b);
RPS_M2_both(widx2_b) = RPS_M2_both(length(sortIdx1_b)+sortIdx2_b);

%% SORT NOISE DATA - Rudder 5deg

% sort for windtunnel speed
% and keep the sort index in "sortIdx"
[opp_stab_r5.vInf, sortIdx] = sort(opp_stab_r5.vInf,'ascend');
[opp_stab_r5_both.vInf, sortIdx_b] = sort(opp_stab_r5_both.vInf,'ascend');

% sort variables according to windtunnel speed
opp_stab_r5.AoS = opp_stab_r5.AoS(sortIdx);
SPL_r5 = SPL_stab_r5(sortIdx);
f_r5 = f_stab_r5(sortIdx);
PXX_r5 = PXX_stab_r5(sortIdx);
RPS_M1_r5 = opp_stab_r5.RPS_M1(sortIdx);
RPS_M2_r5 = opp_stab_r5.RPS_M2(sortIdx);

opp_stab_r5_both.AoS = opp_stab_r5_both.AoS(sortIdx_b);
SPL_r5_both = SPL_stab_r5_both(sortIdx_b);
f_r5_both = f_stab_r5_both(sortIdx_b);
PXX_r5_both = PXX_stab_r5_both(sortIdx_b);
RPS_M1_r5_both = opp_stab_r5_both.RPS_M1(sortIdx_b);
RPS_M2_r5_both = opp_stab_r5_both.RPS_M2(sortIdx_b);

% split measurements
widx1 = find(opp_stab_r5.vInf == 20);
widx2 = find(opp_stab_r5.vInf == 40);

widx1_b = find(opp_stab_r5_both.vInf == 20);
widx2_b = find(opp_stab_r5_both.vInf == 40);

% sort slideslip for Vinf = 20 in ascending order
% and keep the sort index in "sortIdx"
[opp_stab_r5.AoS(widx1), sortIdx1] = sort(opp_stab_r5.AoS(widx1),'ascend');
[opp_stab_r5_both.AoS(widx1_b), sortIdx1_b] = sort(opp_stab_r5_both.AoS(widx1_b),'ascend');

% sort sound according to Vinf = 20 and sideslip
SPL_r5(widx1) = SPL_r5(sortIdx1);
f_r5(widx1) = f_r5(sortIdx1);
PXX_r5(widx1) = PXX_r5(sortIdx1);
RPS_M1_r5(widx1) = RPS_M1_r5(sortIdx1);
RPS_M2_r5(widx1) = RPS_M2_r5(sortIdx1);

SPL_r5_both(widx1_b) = SPL_r5_both(sortIdx1_b);
f_r5_both(widx1_b) = f_r5_both(sortIdx1_b);
PXX_r5_both(widx1_b) = PXX_r5_both(sortIdx1_b);
RPS_M1_r5_both(widx1_b) = RPS_M1_r5_both(sortIdx1_b);
RPS_M2_r5_both(widx1_b) = RPS_M2_r5_both(sortIdx1_b);

% sort slideslip for Vinf = 40 in ascending order
% and keep the sort index in "sortIdx"
[opp_stab_r5.AoS(widx2), sortIdx2] = sort(opp_stab_r5.AoS(widx2),'ascend');
[opp_stab_r5_both.AoS(widx2_b), sortIdx2_b] = sort(opp_stab_r5_both.AoS(widx2_b),'ascend');

% sort sound according to Vinf = 40 and sideslip
SPL_r5(widx2) = SPL_r5(length(sortIdx1)+sortIdx2);
f_r5(widx2) = f_r5(length(sortIdx1)+sortIdx2);
PXX_r5(widx2) = PXX_r5(length(sortIdx1)+sortIdx2);
RPS_M1_r5(widx2) = RPS_M1_r5(length(sortIdx1)+sortIdx2);
RPS_M2_r5(widx2) = RPS_M2_r5(length(sortIdx1)+sortIdx2);

SPL_r5_both(widx2_b) = SPL_r5_both(length(sortIdx1_b)+sortIdx2_b);
f_r5_both(widx2_b) = f_r5_both(length(sortIdx1_b)+sortIdx2_b);
PXX_r5_both(widx2_b) = PXX_r5_both(length(sortIdx1_b)+sortIdx2_b);
RPS_M1_r5_both(widx2_b) = RPS_M1_r5_both(length(sortIdx1_b)+sortIdx2_b);
RPS_M2_r5_both(widx2_b) = RPS_M2_r5_both(length(sortIdx1_b)+sortIdx2_b);

%% SORT NOISE DATA - Rudder 10deg

% sort for windtunnel speed
% and keep the sort index in "sortIdx"
[opp_stab_r10.vInf, sortIdx] = sort(opp_stab_r10.vInf,'ascend');
[opp_stab_r10_both.vInf, sortIdx_b] = sort(opp_stab_r10_both.vInf,'ascend');

% sort variables according to windtunnel speed
opp_stab_r10.AoS = opp_stab_r10.AoS(sortIdx);
SPL_r10 = SPL_stab_r10(sortIdx);
f_r10 = f_stab_r10(sortIdx);
PXX_r10 = PXX_stab_r10(sortIdx);
RPS_M1_r10 = opp_stab_r10.RPS_M1(sortIdx);
RPS_M2_r10 = opp_stab_r10.RPS_M2(sortIdx);

opp_stab_r10_both.AoS = opp_stab_r10_both.AoS(sortIdx_b);
SPL_r10_both = SPL_stab_r10_both(sortIdx_b);
f_r10_both = f_stab_r10_both(sortIdx_b);
PXX_r10_both = PXX_stab_r10_both(sortIdx_b);
RPS_M1_r10_both = opp_stab_r10_both.RPS_M1(sortIdx_b);
RPS_M2_r10_both = opp_stab_r10_both.RPS_M2(sortIdx_b);

% split measurements
widx1 = find(opp_stab_r10.vInf == 20);
widx2 = find(opp_stab_r10.vInf == 40);

widx1_b = find(opp_stab_r10_both.vInf == 20);
widx2_b = find(opp_stab_r10_both.vInf == 40);

% sort slideslip for Vinf = 20 in ascending order
% and keep the sort index in "sortIdx"
[opp_stab_r10.AoS(widx1), sortIdx1] = sort(opp_stab_r10.AoS(widx1),'ascend');
[opp_stab_r10_both.AoS(widx1_b), sortIdx1_b] = sort(opp_stab_r10_both.AoS(widx1_b),'ascend');

% sort sound according to Vinf = 20 and sideslip
SPL_r10(widx1) = SPL_r10(sortIdx1);
f_r10(widx1) = f_r10(sortIdx1);
PXX_r10(widx1) = PXX_r10(sortIdx1);
RPS_M1_r10(widx1) = RPS_M1_r10(sortIdx1);
RPS_M2_r10(widx1) = RPS_M2_r10(sortIdx1);

SPL_r10_both(widx1_b) = SPL_r10_both(sortIdx1_b);
f_r10_both(widx1_b) = f_r10_both(sortIdx1_b);
PXX_r10_both(widx1_b) = PXX_r10_both(sortIdx1_b);
RPS_M1_r10_both(widx1_b) = RPS_M1_r10_both(sortIdx1_b);
RPS_M2_r10_both(widx1_b) = RPS_M2_r10_both(sortIdx1_b);

% sort slideslip for Vinf = 40 in ascending order
% and keep the sort index in "sortIdx"
[opp_stab_r10.AoS(widx2), sortIdx2] = sort(opp_stab_r10.AoS(widx2),'ascend');
[opp_stab_r10_both.AoS(widx2_b), sortIdx2_b] = sort(opp_stab_r10_both.AoS(widx2_b),'ascend');

% sort sound according to Vinf = 40 and sideslip
SPL_r10(widx2) = SPL_r10(length(sortIdx1)+sortIdx2);
f_r10(widx2) = f_r10(length(sortIdx1)+sortIdx2);
PXX_r10(widx2) = PXX_r10(length(sortIdx1)+sortIdx2);
RPS_M1_r10(widx2) = RPS_M1_r10(length(sortIdx1)+sortIdx2);
RPS_M2_r10(widx2) = RPS_M2_r10(length(sortIdx1)+sortIdx2);

SPL_r10_both(widx2_b) = SPL_r10_both(length(sortIdx1_b)+sortIdx2_b);
f_r10_both(widx2_b) = f_r10_both(length(sortIdx1_b)+sortIdx2_b);
PXX_r10_both(widx2_b) = PXX_r10_both(length(sortIdx1_b)+sortIdx2_b);
RPS_M1_r10_both(widx2_b) = RPS_M1_r10_both(length(sortIdx1_b)+sortIdx2_b);
RPS_M2_r10_both(widx2_b) = RPS_M2_r10_both(length(sortIdx1_b)+sortIdx2_b);

%% SCALING

% Fan rpm equals 12 x Vinf: 242-245 or 470-475
% Fan BPF = 25-50 Hz

n_blades = 6;
D_p = 0.2032;   % propeller diameter [m]

wtBPF_20 = (245/60)*n_blades;
wtBPF_40 = (475/60)*n_blades;

density = 1.225;

T_r0 = transpose(Tc_r0).*(pi/4)*(D_p^2).*(0.5*density.*opp_stab_r0.vInf.^2);
T_r0_both = transpose(Tc_r0_both).*(pi/4)*(D_p^2).*(0.5*density.*opp_stab_r0.vInf.^2);
T_r5 = transpose(Tc_r5).*(pi/4)*(D_p^2).*(0.5*density.*opp_stab_r5.vInf.^2);
T_r5_both = transpose(Tc_r5_both).*(pi/4)*(D_p^2).*(0.5*density.*opp_stab_r5.vInf.^2);
T_r10 = transpose(Tc_r10).*(pi/4)*(D_p^2).*(0.5*density.*opp_stab_r10.vInf.^2);
T_r10_both = transpose(Tc_r10_both).*(pi/4)*(D_p^2).*(0.5*density.*opp_stab_r10.vInf.^2);

%% TEST VISUALIZE

set(0,'DefaultFigureVisible','on');

figure('Name','TEST SPL')
for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f{1},SPL{1}(:,i),'r')
    plot(f{10},SPL{10}(:,i),'b')
    xlim([0 1500])
    ylim([min(SPL{14}(1:100,i)) max(SPL{14}(1:100,i))+10])
    xlabel('Frequency f [Hz]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
end

set(0,'DefaultFigureVisible','on');

figure('Name','TEST PJ')
for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f{1}./(n_blades*RPS_M1(1)),sqrt(PXX{1}(:,i)).*(D_p^2)./T_r0(1),'r','DisplayName','AoS: '+string(opp_stab_r0.AoS(1)))
    plot(f{9}./(n_blades*RPS_M1(9)),sqrt(PXX{9}(:,i)).*(D_p^2)./T_r0(9),'g','DisplayName','AoS: '+string(opp_stab_r0.AoS(9)))
    plot(f{5}./(n_blades*RPS_M1(5)),sqrt(PXX{5}(:,i)).*(D_p^2)./T_r0(5),'b','DisplayName','AoS: '+string(opp_stab_r0.AoS(5)))
    xlim([0 4])
    %ylim([min(SPL{14}(1:100,i)) max(SPL{14}(1:100,i))+10])
    xlabel('Frequency f [Hz]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
    legend off
    legend show
end

%% VISUALIZE PROP ON/OFF

close all

set(0,'DefaultFigureVisible','on');

figure('Name','Prop on/off V=20')

for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f{5}./(n_blades*RPS_M1(5)),SPL{5}(:,i),'r','DisplayName','Prop on AoS: '+string(opp_stab_r0.AoS(5)))
    plot(f_zero{1}./(n_blades*RPS_M1(5)),SPL_zero{1}(:,i),'b','DisplayName','Prop off AoS: '+string(opp_on_poff_side.AoS(1)))
    xlim([0 4])
    %ylim([min(SPL{14}(1:100,i)) max(SPL{14}(1:100,i))+10])
    %freq_scale = (n_blades*RPS_M1(5))/wtBPF_20;
    tm = linspace(0,4,5);
    tm2 = linspace(0,1,7);
    %tm3 = linspace(0,4,(freq_scale+1)*4);
    %xline(tm3, '-.g','HandleVisibility','off')
    xline(tm2, ':k','HandleVisibility','off')
    xline(tm, '--r','HandleVisibility','off')
    xlabel('Frequency f [Hz]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
    legend off
    legend show
end

figure('Name','Prop on/off V=40')

for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f{14}./(n_blades*RPS_M1(14)),SPL{14}(:,i),'r','DisplayName','Prop on AoS: '+string(opp_stab_r0.AoS(14)))
    plot(f_zero{6}./(n_blades*RPS_M1(6)),SPL_zero{6}(:,i),'b','DisplayName','Prop off AoS: '+string(opp_on_poff_side.AoS(6)))
    xlim([0 4])
    %ylim([min(SPL{14}(1:100,i)) max(SPL{14}(1:100,i))+10])
    tm = linspace(0,4,5);
    tm2 = linspace(0,1,7);
    xline(tm2, ':','HandleVisibility','off')
    xline(tm, '--r','HandleVisibility','off')
    xlabel('Frequency f [Hz]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
    legend off
    legend show
end

%% VISUALIZE AXIAL DIRECTIVITY

close all

% Select case
cs = 5;

angles = [60, 75, 82.5, 90, 97.5];

OSPL_mic1 = 10*log10(sum(10.^(SPL{cs}(:,1)/10)));
OSPL_mic2 = 10*log10(sum(10.^(SPL{cs}(:,2)/10)));
OSPL_mic3 = 10*log10(sum(10.^(SPL{cs}(:,3)/10)));
OSPL_mic4 = 10*log10(sum(10.^(SPL{cs}(:,4)/10)));
OSPL_mic5 = 10*log10(sum(10.^(SPL{cs}(:,5)/10)));

OSPL = [OSPL_mic1, OSPL_mic2, OSPL_mic3, OSPL_mic4, OSPL_mic5];

set(0,'DefaultFigureVisible','on');

figure('Name','Axial Directivity')

box on
plot(angles, OSPL, '-or')
xlim([50 100])
%ylim()
xlabel('Axial Directivity [deg]')
ylabel('OSPL [dB]')
    
%% VISUALIZE ADVANCE RATIO

close all

[Tj_J, sortIdx] = sort(Tj_J,'ascend');

% sort advance ratio values
Tj = Tj(sortIdx);
SPL_j = SPL_jprop(sortIdx);
f_j = f_jprop(sortIdx);
PXX_j = PXX_jprop(sortIdx);
RPS_M1_j = opp_jprop.RPS_M1(sortIdx);
RPS_M2_j = opp_jprop.RPS_M2(sortIdx);

% compute thrust
Tj = Tj.*(pi/4)*(D_p^2).*(0.5*density.*40.^2);

set(0,'DefaultFigureVisible','on');

figure('Name','Different Advance Ratios')
for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f_j{1}./(n_blades*RPS_M1_j(1)),sqrt(PXX_j{1}(:,i)).*(D_p^2)./Tj(1),'DisplayName','J: '+string(Tj_J(1)))
    plot(f_j{2}./(n_blades*RPS_M1_j(2)),sqrt(PXX_j{2}(:,i)).*(D_p^2)./Tj(2),'DisplayName','J: '+string(Tj_J(2)))
    plot(f_j{3}./(n_blades*RPS_M1_j(3)),sqrt(PXX_j{3}(:,i)).*(D_p^2)./Tj(3),'DisplayName','J: '+string(Tj_J(3)))
    xlim([0 4])
    xlabel('Frequency f/BPF [-]')
    ylabel('Pj [-]')
    title(['Mic ',num2str(i)])
    legend off
    legend show
end

%% VISUALIZE DIFFERENT REYNOLDS

close all

set(0,'DefaultFigureVisible','on');

v = 1.81*(10^(-5));
MAC = 0.165;

Re_20 = density*20*MAC/v;
Re_40 = density*40*MAC/v;

figure('Name','Different Reynolds Numbers')
for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f{5}./(n_blades*RPS_M1(5)),sqrt(PXX{1}(:,i)).*(D_p^2)./T_r0(5),'r')
    plot(f{14}./(n_blades*RPS_M1(5)),sqrt(PXX{5}(:,i)).*(D_p^2)./T_r0(14),'b')
    xlim([0 4])
    %ylim([min(SPL{14}(1:100,i)) max(SPL{14}(1:100,i))+10])
    xlabel('Frequency f/BPF [-]')
    ylabel('Pj [-]')
    title(['Mic ',num2str(i)])
    legend('Re: '+string(round(Re_20/(10^(5)),1))+'$\times 10^5$','Re: '+string(round(Re_40/(10^(5)),1))+'$\times 10^5$','Interpreter','latex')
end

%% VISUALIZE SIDESLIP VARIATION - V = 40

close all

set(0,'DefaultFigureVisible','on');

colors = ["r", "g", "b", "c", "m", "y", "k"];

figure('Name','Sideslip range V=40')
for i= 1:6
    subplot(2,3,i), box on, hold on
    ci = 1;
    for state = 10:2:18
        plot(f{state}./(n_blades*RPS_M1(state)),sqrt(PXX{state}(:,i)).*(D_p^2)./T_r0(state),colors(ci),'DisplayName','AoS: '+string(opp_stab_r0.AoS(state)))
        ci = ci + 1;
    end
    xlim([0 4])
    xlabel('Frequency f/BPF [-]')
    ylabel('Pj [-]')
    title(['Mic ',num2str(i)])
    legend off
    legend show
end

%% VISUALIZE SIDESLIP VARIATION - V = 20

set(0,'DefaultFigureVisible','on');

colors = ["r", "g", "b", "c", "m", "y", "k"];

figure('Name','Sideslip range V=20')
for i= 1:6
    subplot(2,3,i), box on, hold on
    ci = 1;
    for state = 1:2:9
        plot(f{state}./(n_blades*RPS_M1(state)),sqrt(PXX{state}(:,i)).*(D_p^2)./T_r0(state),colors(ci),'DisplayName','AoS: '+string(opp_stab_r0.AoS(state)))
        ci = ci + 1;
    end
    xlim([0 4])
    xlabel('Frequency f/BPF [-]')
    ylabel('Pj [-]')
    title(['Mic ',num2str(i)])
    legend off
    legend show
end

%% VISUALIZE DIFFERENT RUDDER ANGLE

close all

set(0,'DefaultFigureVisible','on');

figure('Name','Different Reynolds Numbers')
for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f{5}./(n_blades*RPS_M1(5)),PXX{1}(:,i).*(D_p^2)./T_r0(5),'r')
    plot(f_r5{5}./(n_blades*RPS_M1_r5(5)),sqrt(PXX_r5{5}(:,i)).*(D_p^2)./T_r5(5),'b')
    plot(f_r10{5}./(n_blades*RPS_M1_r5(5)),sqrt(PXX_r10{5}(:,i)).*(D_p^2)./T_r10(5),'g')
    xlim([0 4])
    %ylim([min(SPL{14}(1:100,i)) max(SPL{14}(1:100,i))+10])
    xlabel('Frequency f/BPF [-]')
    ylabel('Pj [-]')
    title(['Mic ',num2str(i)])
    legend('rudder: 0 deg','rudder: 5 deg','rudder: 10 deg','Interpreter','latex')
end

%% VISUALIZE ONE OR BOTH PROPS ON

close all

set(0,'DefaultFigureVisible','on');

figure('Name','Different Reynolds Numbers')
for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f{5}./(n_blades*RPS_M1(5)),sqrt(PXX{1}(:,i)).*(D_p^2)./T_r0(5),'r')
    plot(f_both{5}./(n_blades*RPS_M1(5)),sqrt(PXX_both{5}(:,i)).*(D_p^2)./T_r0_both(5),'b')
    xlim([0 4])
    %ylim([min(SPL{14}(1:100,i)) max(SPL{14}(1:100,i))+10])
    xlabel('Frequency f/BPF [-]')
    ylabel('Pj [-]')
    title(['Mic ',num2str(i)])
    legend('left prop','both prop','Interpreter','latex')
end
