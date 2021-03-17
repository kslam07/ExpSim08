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

nIter = 100;                    % number of iterations
res   = 1;                      % residual

%% Run loop
for i = 1:nIter
    % compute thrust and input them in iterative matrix "i1"
    data = removeThrustUpdate.mainFunction(data);
    
    % get correction factors based on values in matrix "i1"
    
    % wake blockage - TODO
    
    % streamline curvature
    [dalphaSC, dCmSC, dCdSC] = corrStreamlines(data);
    
    % slipstream
    epsSS = corrSlipstream(data);
    
    % apply corrections
    fieldNames = fieldnames(data.i0);               % get names of tables
    for iName = 2:4
        nameMeas = cell2mat(fieldNames(iName));
        % sum all blockage + slipstream eps
        epsToti = epsSS.(nameMeas) + data.epsSB;
        velCorr = (1+epsToti).*data.i1.(nameMeas).V;
        
        % update coefficients coefficients in aero reference frame
        CL = data.i1.(nameMeas).CL .* data.i1.(nameMeas).V.^2 ./ velCorr.^2;
        CD = data.i1.(nameMeas).CD .* data.i1.(nameMeas).V.^2 ./ velCorr.^2;
        CYaw = data.i1.(nameMeas).CYaw .* data.i1.(nameMeas).V.^2 ./ velCorr.^2;
        CMr = data.i1.(nameMeas).CMr .* data.i1.(nameMeas).V.^2 ./ velCorr.^2;
        CMp = data.i1.(nameMeas).CMp .* data.i1.(nameMeas).V.^2 ./ velCorr.^2;
        CMp25c = data.i1.(nameMeas).CMp25c .* data.i1.(nameMeas).V.^2 ./ velCorr.^2;
        CMy = data.i1.(nameMeas).CMy .* data.i1.(nameMeas).V.^2 ./ velCorr.^2;
        
        % correct alpha
        alpha = data.i1.(nameMeas).AoA + dalphaSC.(nameMeas);
        % correct drag coefficient
        CD = CD + dCdSC.(nameMeas);
        % correct pitching moment coefficient
        CMp25c = CMp25c + dCmSC.(nameMeas);
        
        % Rewrite values in "i0" matrix; repeat
        data.i0.(nameMeas).CL = CL;
        data.i0.(nameMeas).CD = CD;
        data.i0.(nameMeas).CYaw = CYaw;
        data.i0.(nameMeas).CMr = CMr;
        data.i0.(nameMeas).CMp = CMp;
        data.i0.(nameMeas).CMp25c = CMp25c;
        data.i0.(nameMeas).CMp = CMp25c;                % identical to 25c
        data.i0.(nameMeas).CMy = CMy;
        data.i0.(nameMeas).V = velCorr;
        data.i0.(nameMeas).AoA = alpha;
    end
end
        
        

