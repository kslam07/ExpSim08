function [dataStruct] = corrTailoff(dataStruct)
    %required parameters
    S = dataStruct.sRef;
    C = dataStruct.tunnelArea;
    
    diff_V = 0.5;
    diff_AoS = 0.2;
    
%     tailoffAoS = dataStruct.tailoffAoS;
   
%% 
    AoS = [-10:1:10];
    V = [20 30 40];
    for iV = 1:length(V)
        for iAoS = 1:length(AoS)
            idx_tmp = find(abs(dataStruct.tailoffAoS.AoS-AoS(iAoS))<diff_AoS &...
                abs(dataStruct.tailoffAoS.Vinf-V(iV))<diff_V);
            tmp = dataStruct.tailoffAoS(idx_tmp,:);
            
            %blockage
            p = polyfit(tmp.CL.^2,tmp.CD,1);
            Cdi = p(1);
            Cd0 = p(2);
            eps_wb0 = S/(4*C)*Cd0;
            Cds = tmp.CD - Cdi -Cd0;
            Cds(Cds<0) = 0;
            eps_wbs = (5*S)/(4*C).*Cds;
            eps_tot = eps_wb0+eps_wbs+dataStruct.epsSB;
            dataStruct.tailoffAoS.Vinf(idx_tmp) = dataStruct.tailoffAoS.Vinf(idx_tmp).*(1+eps_tot);
            dataStruct.tailoffAoS.CL(idx_tmp) = dataStruct.tailoffAoS.CL(idx_tmp).*((1+eps_tot).^2);
            dataStruct.tailoffAoS.CD(idx_tmp) = dataStruct.tailoffAoS.CD(idx_tmp).*((1+eps_tot).^2);
            dataStruct.tailoffAoS.CM25c(idx_tmp) = dataStruct.tailoffAoS.CM25c(idx_tmp).*((1+eps_tot).^2);
            dataStruct.tailoffAoS.CYaw(idx_tmp) = dataStruct.tailoffAoS.CYaw(idx_tmp).*((1+eps_tot).^2);
            dataStruct.tailoffAoS.CMy(idx_tmp) = dataStruct.tailoffAoS.CMy(idx_tmp).*((1+eps_tot).^2);
            dataStruct.tailoffAoS.CMr(idx_tmp) = dataStruct.tailoffAoS.CMr(idx_tmp).*((1+eps_tot).^2);
            %%lift interference
            %AoA
            dataStruct.tailoffAoS.AoA(idx_tmp) = dataStruct.tailoffAoS.AoA(idx_tmp) + ...
                dataStruct.delta.*(S/C).*dataStruct.tailoffAoS.CL(idx_tmp).*(1+dataStruct.tau2Wing);
            %Cd    
            dataStruct.tailoffAoS.CD(idx_tmp) = dataStruct.tailoffAoS.CD(idx_tmp) + ...
                dataStruct.delta.*(S/C).*dataStruct.tailoffAoS.CL(idx_tmp).^2;
            %Cm25c            
            tmp = dataStruct.tailoffAoS(idx_tmp,:);
            p = polyfit(tmp.AoA,tmp.CL,1);
            Cla = p(1);
            dataStruct.tailoffAoS.CM25c(idx_tmp) = dataStruct.tailoffAoS.CM25c(idx_tmp) + ...
                0.125.*dataStruct.tailoffAoS.AoA(idx_tmp).*Cla; 
            
            
        end
    end
end

