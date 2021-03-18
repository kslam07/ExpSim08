%% POST-PROCESSING SOUND

% Fan rpm equals 12 x Vinf: 242-245 or 470-475
% Fan BPF = 25-50 Hz

n_blades = 6;
BPF_20 = (245/60)*n_blades;
BPF_40 = (475/60)*n_blades;

%% TO BE IMPLEMENTED

%% LOAD data

load('zero_side.mat');
load('zero_pon.mat');
load('zero_alf.mat');
load('on_poff_slide.mat');
load('jprop.mat');
load('stab_r0.mat');
load('stab_r5.mat');
load('stab_r10.mat');
load('stab_r0_b.mat');
load('stab_r10_b.mat');

%% SORT DATA

% sort for windtunnel speed
% and keep the sort index in "sortIdx"
[opp_stab_r0.vInf, sortIdx] = sort(opp_stab_r0.vInf,'ascend');

% sort variables according to windtunnel speed
opp_stab_r0.AoS = opp_stab_r0.AoS(sortIdx);
SPL = SPL_stab_r0(sortIdx);
f = f_stab_r0(sortIdx);

% split measurements
widx1 = find(opp_stab_r0.vInf == 20);
widx2 = find(opp_stab_r0.vInf == 40);

% sort slideslip for Vinf = 20 in ascending order
% and keep the sort index in "sortIdx"
[opp_stab_r0.AoS(widx1), sortIdx1] = sort(opp_stab_r0.AoS(widx1),'ascend');

% sort sound according to Vinf = 20 and sideslip
SPL(widx1) = SPL(sortIdx1);
f(widx1) = f(sortIdx1);

% sort slideslip for Vinf = 40 in ascending order
% and keep the sort index in "sortIdx"
[opp_stab_r0.AoS(widx2), sortIdx2] = sort(opp_stab_r0.AoS(widx2),'ascend');

% sort sound according to Vinf = 40 and sideslip
SPL(widx2) = SPL(length(sortIdx1)+sortIdx2);
f(widx2) = f(length(sortIdx1)+sortIdx2);

%% CORRECTIONS


%% VISUALIZE

close all
clc
colors = ["r", "g", "b", "c", "m", "y", "k"];

figure('Name','Spectra')
for i= 1:6
    subplot(2,3,i), box on, hold on
    plot(f{5}./BPF_20,SPL{5}(:,i),'r')
    plot(f{14}./BPF_40,SPL{14}(:,i),'b')
    xlim([0 10])
    xlabel('Frequency f [Hz]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
    ylim([50 120])
end

figure('Name','Spectra V=40')
for i= 1:6
    subplot(2,3,i), box on, hold on
    ci = 1;
    for state = 10:2:18
        plot(f{state}./BPF_40,SPL{state}(:,i),colors(ci))
        if i == 1
            disp(opp_stab_r0.AoS(state))
        end
        ci = ci + 1;
    end
    xlim([0 10])
    xlabel('Frequency f [Hz]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
    ylim([50 120])
end

figure('Name','Spectra V=20')
for i= 1:6
    subplot(2,3,i), box on, hold on
    ci = 1;
    for state = 1:2:9
        plot(f{state}./BPF_20,SPL{state}(:,i),colors(ci))
        if i == 1
            disp(opp_stab_r0.AoS(state))
        end
        ci = ci + 1;
    end
    xlim([0 10])
    xlabel('Frequency f [Hz]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
    ylim([50 120])
end