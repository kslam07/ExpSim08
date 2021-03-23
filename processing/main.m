% script to iterate over correction-thrust
% thrust loop finds the thrust for the given aero coeffs.
% the thrust affects the aero coeff. as well and latter must be corrected
% due to blockage and wind tunnel b.c.
% For both the aero coeff and thrust to converge, these sequences must be
% iterated

%% clear all; close all stuff related to command window
clear
close all
clc

%% load OUTPUT.xlsx file (output of preprocessing)
measPath = "OUTPUT.xls";
tailOffPath = "./DATA/TailOffData.xlsx";
data = load2Struct(measPath, tailOffPath);

nIter = 10;                     % number of iterations
res   = 1;                      % residual
resThrust = 1;

%% correct prop. off data using wall corrections
data = corrPropoff(data);

%% Correct model off data
i0_org = data.i0;

%% Run corrections
% i0: starting and final test matrix
% i1: test matrix with thrust
% i2: test matrix with TC=0 values (Eckert)

% The original data (i0) is retrieved from load2Struct in which useful /
% common parameters are also stored. To perform the corrections, first the
% thrust was computed based on an iterative Eckert process. The process is
% looped until the CT of the previous iteration and the current estimate is
% more or less the same (should take less than 10 iterations). This gives
% us i1!
% Afterwards, Eckert method is applied to compute the CL_{TC=0} and 
% CD_{TC=0} values. These values are needed to obtain the "thrust-free"
% aero. coeffs. since the actual measurements violate the assumptions of
% some wall corrections (energy applied to the flow).
% This results in i2. Finally we can compute the wall corrections which
% uses i2. However, the corrections d(Coefficient) are applied to the
% original matrix i0 because I like to be convoluted.

fieldNames = fieldnames(data.i0);               % get names of tables
% compute thrust and input them in iterative matrix "i1"
data = removeThrustUpdate.mainFunction(data);

% compute TC=0 CL and CD based on Eckert method
data = eckertMethod(data, "i1");

% get correction factors based on values in matrix "i1"
% wake blockage
epsWB = corrWakeblockage(data, "i2");

% streamline curvature
[dalpha, dCmSC, dCdSC] = corrStreamlines(data, "i2");

% slipstream; can take i1 since it doesn't matter
epsSS = corrSlipstream(data, "i1");

% APPLY CORRECTIONS
for iName = 2:4
    nameMeas = cell2mat(fieldNames(iName));
    % sum all blockage + slipstream eps
    epsToti = epsSS.(nameMeas) + data.epsSB + epsWB.(nameMeas);
    velCorr = (1+epsToti).*data.i2.(nameMeas).V;
    dV      = epsToti .* data.i2.(nameMeas).V;

    % update coefficients coefficients in aero reference frame
    dVuc_Vc = (data.i2.(nameMeas).V.^2 ./ velCorr.^2 - 1);
    dCL     = data.i2.(nameMeas).CL .* dVuc_Vc;
    dCD     = data.i2.(nameMeas).CD .* dVuc_Vc;
    dCYaw   = data.i2.(nameMeas).CYaw .* dVuc_Vc;
    dCY     = data.i2.(nameMeas).CY .* dVuc_Vc;
    dCMr    = data.i2.(nameMeas).CMr .* dVuc_Vc;
    dCMp    = data.i2.(nameMeas).CMp .* dVuc_Vc;
    dCMp25c = data.i2.(nameMeas).CMp25c .* dVuc_Vc;
    dCMy    = data.i2.(nameMeas).CMy .* dVuc_Vc;
    dCT     = data.i2.(nameMeas).CT .* dVuc_Vc;
    ddPb    = data.i2.(nameMeas).dPb .* dVuc_Vc;

    % correct coefficients due to lift interference
    % correct drag coefficient
    dCD = dCD + dCdSC.(nameMeas);
    % correct pitching moment coefficient
    dCMp25c = dCMp25c + dCmSC.(nameMeas);

    % Rewrite values in "i0" matrix; repeat
    data.i0.(nameMeas).CL       = data.i0.(nameMeas).CL + dCL;
    data.i0.(nameMeas).CD       = data.i0.(nameMeas).CD + dCD;
    data.i0.(nameMeas).CYaw     = data.i0.(nameMeas).CYaw + dCYaw;
    data.i0.(nameMeas).CY       = data.i0.(nameMeas).CY + dCY;
    data.i0.(nameMeas).CMr      = data.i0.(nameMeas).CMr + dCMr;
    data.i0.(nameMeas).CMp      = data.i0.(nameMeas).CMp + dCMp;
    data.i0.(nameMeas).CMp25c   = data.i0.(nameMeas).CMp25c + dCMp25c;
    data.i0.(nameMeas).CMy      = data.i0.(nameMeas).CMy + dCMy;
    data.i0.(nameMeas).CT       = data.i0.(nameMeas).CT + dCT;
    data.i0.(nameMeas).V        = velCorr;
    data.i0.(nameMeas).AoA      = data.i0.(nameMeas).AoA + dalpha.(nameMeas);
    data.i0.(nameMeas).dPb      = data.i1.(nameMeas).dPb + ddPb; % THRUST!
end

% TODO remove model off data from measurements
data = removeModelOff(data, "i0");

% Cn and Cy

% dCn/dbeta for all sideslip angles
% dCn/ddelta_r for all sideslip angles


%OEI condition
rud0_OEI(:,1) = data.i0.rud0.V(data.i1.rud0.iM2 == 0);
rud0_OEI(:,2) = data.i0.rud0.AoS(data.i1.rud0.iM2 == 0);
rud0_OEI(:,3) = data.i0.rud0.CN(data.i1.rud0.iM2 == 0);
rud0_OEI(:,4) = data.i0.rud0.CY(data.i1.rud0.iM2 == 0);
rud0_OEI_V40 = rud0_OEI(rud0_OEI(:,1) == 40,:);
rud0_OEI_V20 = rud0_OEI(rud0_OEI(:,1) == 20,:);

rud5_OEI(:,1) = data.i0.rud5.V(data.i1.rud5.iM2 == 0);
rud5_OEI(:,2) = data.i0.rud5.AoS(data.i1.rud5.iM2 == 0);
rud5_OEI(:,3) = data.i0.rud5.CN(data.i1.rud5.iM2 == 0);
rud5_OEI(:,4) = data.i0.rud5.CY(data.i1.rud5.iM2 == 0);
rud5_OEI_V40 = rud5_OEI(rud5_OEI(:,1) == 40,:);
rud5_OEI_V20 = rud5_OEI(rud5_OEI(:,1) == 20,:);

rud10_OEI(:,1) = data.i0.rud10.V(data.i1.rud10.iM2 == 0);
rud10_OEI(:,2) = data.i0.rud10.AoS(data.i1.rud10.iM2 == 0);
rud10_OEI(:,3) = data.i0.rud10.CN(data.i1.rud10.iM2 == 0);
rud10_OEI(:,4) = data.i0.rud10.CY(data.i1.rud10.iM2 == 0);
rud10_OEI_V40 = rud10_OEI(rud10_OEI(:,1) == 40,:);
rud10_OEI_V20 = rud10_OEI(rud10_OEI(:,1) == 20,:);

figure;
plot(rud0_OEI_V40(:,2), rud0_OEI_V40(:,3),'o');
hold on
plot(rud0_OEI_V20(:,2), rud0_OEI_V20(:,3),'x');
legend('40m/s', '20m/s');
xlabel('\beta');
ylabel('C_{N}');
title('\delta_{r} = 0');

figure;
plot(rud5_OEI_V40(:,2), rud5_OEI_V40(:,3),'o');
hold on
plot(rud5_OEI_V20(:,2), rud5_OEI_V20(:,3),'x');
legend('40m/s', '20m/s');
xlabel('\beta');
ylabel('C_{N}');
title('\delta_{r} = 5');

figure;
plot(rud10_OEI_V40(:,2), rud10_OEI_V40(:,3),'o');
hold on
plot(rud10_OEI_V20(:,2), rud10_OEI_V20(:,3),'x');
legend('40m/s', '20m/s');
xlabel('\beta');
ylabel('C_{N}');
title('\delta_{r} = 10');