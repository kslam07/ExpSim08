function dataStruct = corrPropoff(dataStruct)
% Corrects the prop-off dataStruct using potential flow theory

    % wake blockage
    epsWB = corrWakeblockage(dataStruct, "i0");

    % streamline curvature
    [dalpha, dCmSC, dCdSC] = corrStreamlines(dataStruct, "i0");

    % sum all blockage + slipstream eps
    epsToti = dataStruct.epsSB + epsWB.propoff;
    velCorr = (1+epsToti).*dataStruct.i0.propoff.V;
%     dV      = epsToti.*dataStruct.i0.propoff.V;

    % update coefficients coefficients in aero reference frame
    dVuc_Vc = (dataStruct.i0.propoff.V.^2 ./ velCorr.^2 - 1);
    dCL = dataStruct.i0.propoff.CL .* dVuc_Vc;
    dCD = dataStruct.i0.propoff.CD .* dVuc_Vc;
    dCYaw = dataStruct.i0.propoff.CYaw .* dVuc_Vc;
    dCMr = dataStruct.i0.propoff.CMr .* dVuc_Vc;
    dCMp = dataStruct.i0.propoff.CMp .* dVuc_Vc;
    dCMp25c = dataStruct.i0.propoff.CMp25c .* dVuc_Vc;
    dCMy = dataStruct.i0.propoff.CMy .* dVuc_Vc;
    dCT = dataStruct.i0.propoff.CT .* dVuc_Vc;
    
    % correct coefficients due to lift interference
    % correct drag coefficient
    dCD = dCD + dCdSC.propoff;
    % correct pitching moment coefficient
    dCMp25c = dCMp25c + dCmSC.propoff;
    
    % Rewrite values in "i0" matrix; repeat
    dataStruct.i0.propoff.CL = dataStruct.i0.propoff.CL + dCL;
    dataStruct.i0.propoff.CD = dataStruct.i0.propoff.CD + dCD;
    dataStruct.i0.propoff.CYaw = dataStruct.i0.propoff.CYaw + dCYaw;
    dataStruct.i0.propoff.CMr = dataStruct.i0.propoff.CMr + dCMr;
    dataStruct.i0.propoff.CMp = dataStruct.i0.propoff.CMp + dCMp;
    dataStruct.i0.propoff.CMp25c = dataStruct.i0.propoff.CMp25c + dCMp25c;
    dataStruct.i0.propoff.CMy = dataStruct.i0.propoff.CMy + dCMy;
    dataStruct.i0.propoff.CT = dataStruct.i0.propoff.CT + dCT;
    dataStruct.i0.propoff.V = velCorr;
    dataStruct.i0.propoff.AoA = dataStruct.i0.propoff.AoA + dalpha.propoff;
end

