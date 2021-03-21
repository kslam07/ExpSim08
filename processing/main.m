% script to iterate over correction-thrust
% thrust loop finds the thrust for the given aero coeffs.
% the thrust affects the aero coeff. as well and latter must be corrected
% due to blockage and wind tunnel b.c.
% For both the aero coeff and thrust to converge, these sequences must be
% iterated

%% clear all; close all stuff related to command window
% clear
% close all
% clc

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
%% Run loop
for i = 1:nIter
    fieldNames = fieldnames(data.i0);               % get names of tables
    % compute thrust and input them in iterative matrix "i1"
    data = removeThrustUpdate.mainFunction(data);
    
    % get correction factors based on values in matrix "i1"
    % wake blockage
    epsWB = corrWakeblockage(data, "i1");
    
    % streamline curvature
    [dalpha, dCmSC, dCdSC] = corrStreamlines(data, "i1");
    
    % slipstream
    epsSS = corrSlipstream(data, "i1");

    % overwrite with the original aero coeffs put keep thrust coeff.
    for j = 2:4    
        nameMeas = cell2mat(fieldNames(j));
        TC = data.i1.(nameMeas).dPb;
        data.i1.(nameMeas) = i0_org.(nameMeas);
        data.i1.(nameMeas).dPb = TC;
    end
    
    % error vec
    errThrust = max(abs(TC ./ resThrust));
    
    % APPLY CORRECTIONS
    for iName = 2:4
        nameMeas = cell2mat(fieldNames(iName));
        % sum all blockage + slipstream eps
        epsToti = epsSS.(nameMeas) + data.epsSB + epsWB.(nameMeas);
        velCorr = (1+epsToti).*data.i1.(nameMeas).V;
        dV      = epsToti .* data.i1.(nameMeas).V;
        
        % update coefficients coefficients in aero reference frame
        dVuc_Vc = (data.i1.(nameMeas).V.^2 ./ velCorr.^2 - 1);
        dCL = data.i1.(nameMeas).CL .* dVuc_Vc;
        dCD = data.i1.(nameMeas).CD .* dVuc_Vc;
        dCYaw = data.i1.(nameMeas).CYaw .* dVuc_Vc;
        dCMr = data.i1.(nameMeas).CMr .* dVuc_Vc;
        dCMp = data.i1.(nameMeas).CMp .* dVuc_Vc;
        dCMp25c = data.i1.(nameMeas).CMp25c .* dVuc_Vc;
        dCMy = data.i1.(nameMeas).CMy .* dVuc_Vc;
        dTC = data.i1.(nameMeas).CT .* dVuc_Vc;

        % correct coefficients due to lift interference
        % correct drag coefficient
        dCD = dCD + dCdSC.(nameMeas);
        % correct pitching moment coefficient
        dCMp25c = dCMp25c + dCmSC.(nameMeas);

        % Rewrite values in "i0" matrix; repeat
        data.i0.(nameMeas).CL = data.i1.(nameMeas).CL + dCL;
        data.i0.(nameMeas).CD = data.i1.(nameMeas).CD + dCD;
        data.i0.(nameMeas).CYaw = data.i1.(nameMeas).CYaw + dCYaw;
        data.i0.(nameMeas).CMr = data.i1.(nameMeas).CMr + dCMr;
        data.i0.(nameMeas).CMp = data.i1.(nameMeas).CMp + dCMp;
        data.i0.(nameMeas).CMp25c = data.i1.(nameMeas).CMp25c + dCMp25c;
        data.i0.(nameMeas).CMy = data.i1.(nameMeas).CMy + dCMy;
        data.i0.(nameMeas).CT = data.i1.(nameMeas).CT + dTC;
        data.i0.(nameMeas).V = velCorr;
        data.i0.(nameMeas).AoA = data.i1.(nameMeas).AoA + dalpha.(nameMeas);
    end
%     err = max(abs(dCL ./ res));
%     res = dCL;
%     resThrust = TC;
end

% write TC to i0
for i = 2:4
    nameMeas = cell2mat(fieldNames(i));
    data.i0.(nameMeas).dPb = data.i1.(nameMeas).dPb;
end
