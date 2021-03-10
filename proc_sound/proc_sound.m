%% POST-PROCESSING SOUND

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

%% CORRECTIONS

%% VISUALIZE

close all
clc

colors = ["r", "g", "b", "c", "m", "y", "k"];

% sort slideslip in ascending order
% and keep the sort index in "sortIdx"
opp_stab_r0.AoS(13) = [];
[opp_stab_r0.AoS, sortIdx] = sort(opp_stab_r0.AoS,'ascend');

% sort sound using the sorting index
SPL = SPL_stab_r0(sortIdx);
f = f_stab_r0(sortIdx);

figure('Name','Spectra')
for i= 1:6
    subplot(2,3,i), box on, hold on
    ci = 1;
    for state = 1:3:18
        plot(f{state},SPL{state}(:,i),colors(ci))
        if i == 1
            disp(opp_stab_r0.AoS(state))
        end
        ci = ci + 1;
    end
    xlim([0 1500])
    xlabel('Frequency f [Hz]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
    ylim([50 120])
end