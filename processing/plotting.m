function plotting(dataStruct, nameMeas)
    
    dataOrig = dataStruct.i0_org;
    % tail or measurements
    dataMeas = dataStruct.(nameMeas);
    if nameMeas == "tailStruct"
        dataStruct = translateMoments(dataStruct, [0.48 0 0], "tailStruct");
    end
    %% Get data indices to efficiently sort row
    idx020 = dataOrig.rud0.V==20 & dataStruct.i0.rud0.iM2==0 & dataOrig.rud0.J_M1>2;
    idx020b = dataOrig.rud0.V==20 & dataOrig.rud0.iM2~=0 & dataOrig.rud0.J_M1>2;
    idx040 = dataOrig.rud0.V==40 & dataOrig.rud0.iM2==0 & dataOrig.rud0.J_M1>2;
    idx040b = dataOrig.rud0.V==40 & dataOrig.rud0.iM2~=0 & dataOrig.rud0.J_M1>2;
    idxJVar = dataOrig.rud0.iM2~=0 & abs(dataOrig.rud0.AoS)<1.5;
    
    idx520 = dataOrig.rud5.V==20 & dataOrig.rud5.iM2==0;
    idx520b = dataOrig.rud5.V==20 & dataOrig.rud5.iM2~=0;
    idx540 = dataOrig.rud5.V==40 & dataOrig.rud5.iM2==0;
    idx540b = dataOrig.rud5.V==40 & dataOrig.rud5.iM2~=0;

    idx1020 = dataOrig.rud10.V==20 & dataOrig.rud10.iM2==0;
    idx1020b = dataOrig.rud10.V==20 & dataOrig.rud10.iM2~=0;
    idx1040 = dataOrig.rud10.V==40 & dataOrig.rud10.iM2==0;
    idx1040b = dataOrig.rud10.V==40 & dataOrig.rud10.iM2~=0;
    
    %% Sort rows based on indices
    jVar=sortrows(dataMeas.rud0(idxJVar,:),'AoS');
    
    rud020=sortrows(dataMeas.rud0(idx020,:),'AoS');
    rud020b=sortrows(dataMeas.rud0(idx020b,:),'AoS');
    rud040=sortrows(dataMeas.rud0(idx040,:),'AoS');
    rud040b=sortrows(dataMeas.rud0(idx040b,:),'AoS');
    
    rud520=sortrows(dataMeas.rud5(idx520,:),'AoS');
    rud520b=sortrows(dataMeas.rud5(idx520b,:),'AoS');
    rud540=sortrows(dataMeas.rud5(idx540,:),'AoS');
    rud540b=sortrows(dataMeas.rud5(idx540b,:),'AoS');
    
    rud1020=sortrows(dataMeas.rud10(idx1020,:),'AoS');
    rud1020b=sortrows(dataMeas.rud10(idx1020b,:),'AoS');
    rud1040=sortrows(dataMeas.rud10(idx1040,:),'AoS');
    rud1040b=sortrows(dataMeas.rud10(idx1040b,:),'AoS');

    err=0.05;
    CYArr20 = [];
    CYArr20b = [];
    CYArr40 = [];
    CYArr40b = [];
    
    AOS = [-10 -6:2:6 10];
    for iAOS = 1:length(AOS)
        
        %% get the data
        CY020 = rud020(abs(AOS(iAOS)-rud020.AoS)<err, :);
        CY520 = rud520(abs(AOS(iAOS)-rud520.AoS)<err, :);
        CY1020 = rud1020(abs(AOS(iAOS)-rud1020.AoS)<err, :);
        CYArr20(iAOS,:) = [CY020.CY CY520.CY CY1020.CY];
        
        %% screen data
        % exceptions; multiple data points @ aos = -2
        if AOS(iAOS)==-2
            CY020b = rud020b(abs(AOS(iAOS)-rud020b.AoS)<err, :);
            CY520b = rud520b(abs(AOS(iAOS)-rud520b.AoS)<err, :);
            CY1020b = rud1020b(abs(AOS(iAOS)-rud1020b.AoS)<err, :);
            temp = [AOS(iAOS) mean(CY020b.CY) CY520b.CY CY1020b.CY];
            CYArr20b = [CYArr20b; temp];
        elseif AOS(iAOS)==0
            % do nothing
        else
            CY020b = rud020b(abs(AOS(iAOS)-rud020b.AoS)<err, :);
            CY520b = rud520b(abs(AOS(iAOS)-rud520b.AoS)<err, :);
            CY1020b = rud1020b(abs(AOS(iAOS)-rud1020b.AoS)<err, :);
            temp = [AOS(iAOS) CY020b.CY CY520b.CY CY1020b.CY];
            CYArr20b = [CYArr20b; temp];
        end
        
        if AOS(iAOS)==-10
            CY040 = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CY540 = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CY1040 = rud1040(abs(AOS(iAOS)-rud1040.AoS)<err, :);
            CYArr40(iAOS,:) = [mean(CY040.CY) CY540.CY CY1040.CY];
        else
            CY040 = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CY540 = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CY1040 = rud1040(abs(AOS(iAOS)-rud1040.AoS)<err, :);
            CYArr40(iAOS,:) = [CY040.CY CY540.CY mean(CY1040.CY)];
        end
        
        if AOS(iAOS)==-4
            CY040b = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CY540b = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CY1040b = rud1040(3, :);
            CYArr40b(iAOS,:) = [CY040b.CY CY540b.CY CY1040b.CY];
        else
            CY040b = rud040(abs(AOS(iAOS)-rud040b.AoS)<err, :);
            CY540b = rud540(abs(AOS(iAOS)-rud540b.AoS)<err, :);
            CY1040b = rud1040(abs(AOS(iAOS)-rud1040b.AoS)<err, :);
            CYArr40b(iAOS,:) = [CY040b.CY CY540b.CY CY1040b.CY];
        end
    end
    
    CT=rud040b.dPb.*rud040b.J_M1.^2*pi/8;
    CP=CT.*rud040b.V./rud040b.rpsM1/0.2032;
    e=CT./CP.*rud040b.J_M1;
    
    %% compute the 1st order derivatives
    dCYddelta20 = [];                       % dCY/d(delta_r) @ V=20 OEI
    dCYddelta20b = [];                      % dCY/d(delta_r) @ V=20
    dCYddelta40 = [];                       % dCY/d(delta_r) @ V=40 OEI
    dCYddelta40b = [];                      % dCY/d(delta_r) @ V=40
    
    % looping through sideslips
    % for each sideslip, we compute dCy/d(delta_r)|beta
    for idx=1:length(CYArr20) % fit dCyddelta for different delta
        fit=polyfit([0 5 10], CYArr20(idx,:),1);
        dCYddelta20(idx)=fit(1);                    % 1st derivative
        CY0d20(idx)=fit(2);                         % cst. term
    end
    for idx=1:length(CYArr20b)
        fit=polyfit([0 5 10], CYArr20b(idx,2:end),1);
        dCYddelta20b(idx)=fit(1);
        CY0d20b(idx)=fit(2);
    end    
    for idx=1:length(CYArr40)
        fit=polyfit([0 5 10], CYArr40(idx,:),1);
        dCYddelta40(idx)=fit(1);
        CY0d40(idx)=fit(2);
    end
    for idx=1:length(CYArr40b)
        fit=polyfit([0 5 10], CYArr40b(idx,:),1);
        dCYddelta40b(idx)=fit(1);
        CY0d40b(idx)=fit(2);
    end
    
    % average value of dCy/d(delta_r) for varying sideslips
    % assumption: dCy/d(delta_r) does not vary that much for -10<beta<10
    
% ====================== COMPUTE dCy/d(beta) ==============================
    dcydb020=polyfit(rud020.AoS,rud020.CY,3); % polyfit for CY
    dcydb020b=polyfit(rud020b.AoS,rud020b.CY,3);
    dcydb040=polyfit(rud040.AoS,rud040.CY,3);
    dcydb040b=polyfit(rud040b.AoS,rud040b.CY,3);
    
    dcydb520=polyfit(rud520.AoS,rud520.CY,3);
    dcydb520b=polyfit(rud520b.AoS,rud520b.CY,3);
    dcydb540=polyfit(rud540.AoS,rud540.CY,3);
    dcydb540b=polyfit(rud540b.AoS,rud540b.CY,3);
    
    dcydb1020=polyfit(rud1020.AoS,rud1020.CY,3);
    dcydb1020b=polyfit(rud1020b.AoS,rud1020b.CY,3);
    dcydb1040=polyfit(rud1040.AoS,rud1040.CY,3);
    dcydb1040b=polyfit(rud1040b.AoS,rud1040b.CY,3);
    
    % average dCydbeta for varying rudder angles
    dcydb20=mean([dcydb020(3) dcydb520(3) dcydb1020(3)]);
    dcydb20b=mean([dcydb020b(3) dcydb520b(3) dcydb1020b(3)]);
    dcydb40=mean([dcydb040(3) dcydb540(3) dcydb1040(3)]);
    dcydb40b=mean([dcydb040b(3) dcydb540b(3) dcydb1040b(3)]);
    
    % average dCydbeta for varying rudder angles
    CY0b20=mean([dcydb020(4) dcydb520(4) dcydb1020(4)]);
    CY0b20b=mean([dcydb020b(4) dcydb520b(4) dcydb1020b(4)]);
    CY0b40=mean([dcydb040(4) dcydb540(4) dcydb1040(4)]);
    CY0b40b=mean([dcydb040b(4) dcydb540b(4) dcydb1040b(4)]);
    
%     plot(AOS,dcydb40.*AOS+dCYddelta40*10)
    
%     subplot(2,2,1) % plot for cy, beta
%     scatter(rud020.AoS,rud020.CY)
%     xlabel('\beta')
%     ylabel('dC_Y/d\beta')
%     title('v=20, OEI')
%     hold on
%     yline(dcydb20(3))
%     subplot(2,2,2)
%     scatter(rud020b.AoS,rud020b.CY)
%     yline(dcydb20b(3))
%     xlabel('\beta')
%     ylabel('dC_Y/d\beta')
%     title('v=20')
%     subplot(2,2,3)
%     scatter(rud040.AoS,rud040.CY)
%     yline(dcydb40(3))
%     xlabel('\beta')
%     ylabel('dC_Y/d\beta')
%     title('v=40, OEI')
%     subplot(2,2,4)
%     scatter(rud040b.AoS,rud040b.CY)
%     yline(dcydb40b(3))
%      xlabel('\beta')
%     ylabel('dC_Y/d\beta')
%     title('v=40')
%     sgtitle('dC_Y/d\beta')
    
    figure("defaultAxesFontSize", 16)
    subplot(2,2,1)
    lim=11;
    plot([-10 -6:2:6 10],dCYddelta20,'LineStyle','--','Marker','o','MarkerSize',10,'Color','black')
    xlabel('\beta [\circ]')
    ylabel('dC_Y/d\delta_r [-]')
    title('U_{\infty} = 20, OEI')
    xlim([-lim lim])
    ylim([min(dCYddelta20)*0.95 max(dCYddelta20)*1.05])
    grid on
    hold on
%     yline(dcydd20)
    subplot(2,2,2)
    plot(unique(rud020b.AoS),dCYddelta20b,'LineStyle','--','Marker','o','MarkerSize',10,'Color','black')
%     yline(dcydd20b)
    xlabel('\beta [\circ]')
    ylabel('dC_Y/d\delta_r [-]')
    title('U_{\infty} = 20')
    xlim([-lim lim])
    ylim([min(dCYddelta20b)*1.15 max(dCYddelta20b)*1.2])
    grid on
    subplot(2,2,3)
    plot(unique(rud040.AoS),dCYddelta40,'LineStyle','--','Marker','o','MarkerSize',10,'Color','black')
%     yline(dcydd40)
    xlabel('\beta [\circ]')
    ylabel('dC_Y/d\delta_r [-]')
    title('U_{\infty} = 40, OEI')
    xlim([-lim lim])
    ylim([min(dCYddelta40)*0.95 max(dCYddelta40)*1.05])
    grid on
    subplot(2,2,4)
    plot(unique(rud040b.AoS),dCYddelta40b,'LineStyle','--','Marker','o','MarkerSize',10,'Color','black')
%     yline(dcydd40b)
     xlabel('\beta [\circ]')
    ylabel('dC_Y/d\delta_r [-]')
    title('U_{\infty} = 40')
    xlim([-lim lim])
    ylim([min(dCYddelta40b)*0.75 max(dCYddelta40b)*1.05])
    grid on
    set(gcf,'color','w')

%% Start block computation Cmr derivatives and trim angle
    err=0.05;
    CMyArr20 = [];  % setup arrays for CMy for each engine and velocity setting
    CMyArr20b = [];
    CMyArr40 = [];
    CMyArr40b = [];

%% Sort and order the CMy values of each configuration
    AOS = [-10 -6:2:6 10];
    for iAOS = 1:length(AOS)
        
        % Put AoS values for different rudder deflection in same row
        % dataset for V=20 OEI
        CMy020 = rud020(abs(AOS(iAOS)-rud020.AoS)<err, :);
        CMy520 = rud520(abs(AOS(iAOS)-rud520.AoS)<err, :);
        CMy1020 = rud1020(abs(AOS(iAOS)-rud1020.AoS)<err, :);
        CMyArr20(iAOS,:) = [CMy020.CMy CMy520.CMy CMy1020.CMy];
        
        % code for both engine on dataset
        if AOS(iAOS)==-2
            CMy020b = rud020b(4, :);
            CMy520b = rud520b(abs(AOS(iAOS)-rud520b.AoS)<err, :);
            CMy1020b = rud1020b(abs(AOS(iAOS)-rud1020b.AoS)<err, :);
            temp = [AOS(iAOS) CMy020b.CMy CMy520b.CMy CMy1020b.CMy];
            CMyArr20b = [CMyArr20b; temp];
            
        elseif AOS(iAOS)==0
            % do nothing
        else
            CMy020b = rud020b(abs(AOS(iAOS)-rud020b.AoS)<err, :);
            CMy520b = rud520b(abs(AOS(iAOS)-rud520b.AoS)<err, :);
            CMy1020b = rud1020b(abs(AOS(iAOS)-rud1020b.AoS)<err, :);
            temp = [AOS(iAOS) CMy020b.CMy CMy520b.CMy CMy1020b.CMy];
            CMyArr20b = [CMyArr20b; temp];
        end
        
        % code for both V=40 dataset
        if AOS(iAOS)==-10
            CMy040 = rud040(1, :);
            CMy540 = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CMy1040 = rud1040(abs(AOS(iAOS)-rud1040.AoS)<err, :);
            CMyArr40(iAOS,:) = [CMy040.CMy CMy540.CMy CMy1040.CMy];
        else
            CMy040 = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CMy540 = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CMy1040 = rud1040(abs(AOS(iAOS)-rud1040.AoS)<err, :);
            CMyArr40(iAOS,:) = [CMy040.CMy CMy540.CMy mean(CMy1040.CMy)];
        end
        
        if AOS(iAOS)==-4
            CMy040b = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CMy540b = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CMy1040b = rud1040(3, :);
            CMyArr40b(iAOS,:) = [CMy040b.CMy CMy540b.CMy CMy1040b.CMy];
        end
            CMy040b = rud040(abs(AOS(iAOS)-rud040b.AoS)<err, :);
            CMy540b = rud540(abs(AOS(iAOS)-rud540b.AoS)<err, :);
            CMy1040b = rud1040(abs(AOS(iAOS)-rud1040b.AoS)<err, :);
            CMyArr40b(iAOS,:) = [CMy040b.CMy CMy540b.CMy CMy1040b.CMy];
        
    end
    
    dCMyddelta20    = [];  % empty array for dCMyddelta
    dCMyddelta20b   = [];
    dCMyddelta40    = [];
    dCMyddelta40b   = [];
    CMy0d20b        = [];
    
%% compute dCMy/d(delta_r)|beta
    for idx=1:length(CMyArr20) % fit dCMyddelta for different delta
        fit=polyfit([0 5 10], CMyArr20(idx,:),1);
        dCMyddelta20 = [dCMyddelta20 fit(1)];      % value for dCMy/d(delta_r)
    end
    for idx=1:length(CMyArr20b)
        fit=polyfit([0 5 10], CMyArr20b(idx,2:end),1);
        dCMyddelta20b = [dCMyddelta20b fit(1)];
        CMy0d20b = [CMy0d20b fit(2)];
    end    
    for idx=1:length(CMyArr40)
        fit=polyfit([0 5 10], CMyArr40(idx,:),1);
        dCMyddelta40 = [dCMyddelta40 fit(1)];
    end
    for idx=1:length(CMyArr40b)
        fit=polyfit([0 5 10], CMyArr40b(idx,:),1);
        dCMyddelta40b = [dCMyddelta40b fit(1)];
    end
    
    % take the average of dCMy/d(delta_r) for varying sideslip angles
    dCMydd20=mean(dCMyddelta20); % average value for different delta_r
    dCMydd20b=mean(dCMyddelta20b);
    dCMydd40=mean(dCMyddelta40);
    dCMydd40b=mean(dCMyddelta40b);
    
    %% compute dCMy/d(beta)
    dCMydb020=polyfit(rud020.AoS,rud020.CMy,3); % polyfit for CMy
    dCMydb020b=polyfit(rud020b.AoS,rud020b.CMy,3);
    dCMydb040=polyfit(rud040.AoS,rud040.CMy,3);
    dCMydb040b=polyfit(rud040b.AoS,rud040b.CMy,3);
    
    dCMydb520=polyfit(rud520.AoS,rud520.CMy,3);
    dCMydb520b=polyfit(rud520b.AoS,rud520b.CMy,3);
    dCMydb540=polyfit(rud540.AoS,rud540.CMy,3);
    dCMydb540b=polyfit(rud540b.AoS,rud540b.CMy,3);
    
    dCMydb1020=polyfit(rud1020.AoS,rud1020.CMy,3);
    dCMydb1020b=polyfit(rud1020b.AoS,rud1020b.CMy,3);
    dCMydb1040=polyfit(rud1040.AoS,rud1040.CMy,3);
    dCMydb1040b=polyfit(rud1040b.AoS,rud1040b.CMy,3);
    
    % average dCMydbeta for different delta_r
    dCMydb20    = mean([dCMydb020(3) dCMydb520(3) dCMydb1020(3)]);
    dCMydb20b   = mean([dCMydb020b(3) dCMydb520b(3) dCMydb1020b(3)]);
    dCMydb40    = mean([dCMydb040(3) dCMydb540(3) dCMydb1040(3)]);
    dCMydb40b   = mean([dCMydb040b(3) dCMydb540b(3) dCMydb1040b(3)]);
    
    % dCMydbeta|0 for different delta_r
    CMy0b20     = rud020(abs(rud020.AoS) < 0.2, end).CMy;%dCMydb020(4) + CMy0d20;
    CMy0b20b    = (mean(rud020b.CMy(4:6))+rud020b.CMy(7))/2;%dCMydb020b(4)+ CMy0d20b;
    CMy0b40     = rud040(abs(rud040.AoS) < 0.2, end).CMy;%dCMydb040(4) + CMy0d40;
    CMy0b40b    = rud040b(abs(rud040b.AoS) < 0.2, end).CMy;%dCMydb040b(4)+ CMy0d40b;
    
    % compute the corresponding sideslip for the given rudder angle and
    % configuration. You want to find the trim based on the steady-state
    % condition which we define to be delta_r=0 and beta=0. Then, the
    % CMy0 should be obtained from CMy0|beta=0 and CMy0|delta_r=0
    
    % only compute OEI states, why do we even want to do it for both
    % engines on?
    aosspace = linspace(-5, 5, 11);
    
    AoSTrim20 = findTrimAngle(CMy0b20, aosspace, dCMydd20, dCMydb20);
    AoSTrim40 = findTrimAngle(CMy0b40, aosspace, dCMydd40, dCMydb40);
    % if you actually insert the const. term, then both engines on require
    % more trimming then OEI. Noise?
    AoSTrim20b = findTrimAngle(CMy0b20b, aosspace, dCMydd20b, dCMydb20b); 
    AoSTrim40b = findTrimAngle(CMy0b40b, aosspace, dCMydd40b, dCMydb40b);
    
    figure("defaultAxesFontSize", 14)
    hold on
    plot(aosspace, AoSTrim20, "DisplayName", "V20 - OEI",'LineStyle','--','Color',[0, 0.4470, 0.7410])
    plot(aosspace, AoSTrim40, "DisplayName", "V40 - OEI",'LineStyle','--','Color',[0.8500, 0.3250, 0.0980])
    plot(aosspace, AoSTrim40b, "DisplayName", "V40",'Color',[0.8500, 0.3250, 0.0980])
    plot(aosspace, AoSTrim20b, "DisplayName", "V20",'Color',[0, 0.4470, 0.7410])
    xlabel("\beta [-]")
    ylabel("\delta_{r,trim} [\circ]")
    legend
    grid
    
    %% plots for trimming

    
%     plot(AOS,dcydb40.*AOS+dCYddelta40*10)
    
%     subplot(2,2,1) % plot for cy, beta
%     scatter(rud020.AoS,rud020.CY)
%     xlabel('\beta')
%     ylabel('dC_Y/d\beta')
%     title('v=20, OEI')
%     hold on
%     yline(dcydb20(3))
%     subplot(2,2,2)
%     scatter(rud020b.AoS,rud020b.CY)
%     yline(dcydb20b(3))
%     xlabel('\beta')
%     ylabel('dC_Y/d\beta')
%     title('v=20')
%     subplot(2,2,3)
%     scatter(rud040.AoS,rud040.CY)
%     yline(dcydb40(3))
%     xlabel('\beta')
%     ylabel('dC_Y/d\beta')
%     title('v=40, OEI')
%     subplot(2,2,4)
%     scatter(rud040b.AoS,rud040b.CY)
%     yline(dcydb40b(3))
%      xlabel('\beta')
%     ylabel('dC_Y/d\beta')
%     title('v=40')
%     sgtitle('dC_Y/d\beta')

    figure("defaultAxesFontSize", 16)
    subplot(2,2,1)
    plot([-10 -6:2:6 10],dCMyddelta20,'LineStyle','--','Marker','o','MarkerSize',10,'Color','black')
    xlabel('\beta [\circ]')
    ylabel('dC_N/d\delta_r [-]')
    title('U_{\infty} = 20, OEI')
    xlim([-lim lim])
    ylim([min(dCMyddelta20)*1.05 max(dCMyddelta20)*0.95])
    grid on
    hold on
%     yline(dcydd20)
    subplot(2,2,2)
    plot(unique(rud020b.AoS),dCMyddelta20b,'LineStyle','--','Marker','o','MarkerSize',10,'Color','black')
%     yline(dcydd20b)
    xlabel('\beta [\circ]')
    ylabel('dC_N/d\delta_r [-]')
    title('U_{\infty} = 20')
    grid on
    xlim([-lim lim])
    ylim([min(dCMyddelta20b)*1.15 max(dCMyddelta20b)*1.15])
    subplot(2,2,3)
    plot(unique(rud040.AoS),dCMyddelta40,'LineStyle','--','Marker','o','MarkerSize',10,'Color','black')
%     yline(dcydd40)
    xlabel('\beta [\circ]')
    ylabel('dC_N/d\delta_r [-]')
    title('U_{\infty} = 40, OEI')
    grid on
    xlim([-lim lim])
    ylim([min(dCMyddelta40)*1.05 max(dCMyddelta40)*0.95])
    subplot(2,2,4)
     plot([-10 -6:2:6 10],dCMyddelta40b,'LineStyle','--','Marker','o','MarkerSize',10,'Color','black')
%     yline(dcydd40b)
     xlabel('\beta [\circ]')
    ylabel('dC_N/d\delta_r [-]')
    title('U_{\infty} = 40')
    xlim([-lim lim])
    ylim([min(dCMyddelta40b)*1.05 max(dCMyddelta40b)*0.85])
    grid on
    set(gcf,'color','w')
    
    x=1;
%     figure(4)
%     subplot(2,2,1)
%     scatter([-10 -6:2:6 10],dCMydb20)
%     xlabel('\beta')
%     ylabel('dC_M/d\beta')
%     title('U_{\infty}=20, OEI')
%     hold on
% %     yline(dcydd20)
%     subplot(2,2,2)
%     scatter(unique(rud020b.AoS),dCMyddelta20b)
% %     yline(dcydd20b)
%     xlabel('\beta')
%     ylabel('dCM_Y/d\delta_r')
%     title('v=20')
%     subplot(2,2,3)
%     scatter(unique(rud040.AoS),dCMyddelta40)
% %     yline(dcydd40)
%     xlabel('\beta')
%     ylabel('dCM_Y/d\delta_r')
%     title('v=40, OEI')
%     subplot(2,2,4)
%     scatter([-10 -6:2:6 10],dCMyddelta40b)
% %     yline(dcydd40b)
%      xlabel('\beta')
%     ylabel('dCM_Y/d\delta_r')
%     title('v=40')
%     sgtitle('dCM_Y/d\delta_r')
    
    %% Plotting
    figure(1)
    t = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
    nexttile
    plot(rud040b.AoS,rud040b.CD,'o','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    hold on
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CD([1:4, 7:10]),'x','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    xlim([-10,10])
    xlabel('\beta [\circ]')
    ylabel('C_D [-]')
    grid on
    legend('U_{\infty} = 40','U_{\infty} = 20')
    nexttile
    plot(rud040b.AoS,rud040b.CY,'o','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    hold on
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CY([1:4, 7:10]),'x','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    xlim([-10,10])
    xlabel('\beta [\circ]')
    ylabel('C_Y [-]')
    grid on
    nexttile
    plot(rud040b.AoS,rud040b.CL,'o','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    hold on
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CL([1:4, 7:10]),'x','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    xlim([-10,10])
    xlabel('\beta [\circ]')
    ylabel('C_L [-]')
    grid on
    nexttile
    plot(rud040b.AoS,rud040b.CMr,'o','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    hold on
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CMr([1:4, 7:10]),'x','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    xlim([-10,10])   
    xlabel('\beta [\circ]')
    ylabel('C_{Mr} [-]')
    grid on
    nexttile
    plot(rud040b.AoS,rud040b.CMp25c,'o','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    hold on
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CMp25c([1:4, 7:10]),'x','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    xlim([-10,10])
    xlabel('\beta [\circ]')
    ylabel('C_{Mp25c} [-]')
    grid on
    nexttile
    plot(rud040b.AoS,rud040b.CMy,'o','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    hold on
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CMy([1:4, 7:10]),'x','MarkerSize',8,'LineStyle','--','LineWidth',1.2)
    xlim([-10,10])   
    xlabel('\beta [\circ]')
    ylabel('C_{My} [-]')
    grid on

    

%     figure(2)
%     t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
%     nexttile
%     plot(rud040.AoS,rud040.CY,'x')
%     hold on
%     plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CY,3),rud040.AoS))
%     plot(rud040b.AoS,rud040b.CY,'o')
%     plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CY,3),rud040b.AoS))
%     xlim([-10,10])
%     xlabel('\beta [\circ]')
%     ylabel('C_Y [-]')
%     grid on
%     nexttile
%     plot(rud040.AoS,rud040.CD,'x')
%     hold on
%     plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CD,3),rud040.AoS))
%     plot(rud040b.AoS,rud040b.CD,'o')
%     plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CD,3),rud040b.AoS))
%     xlim([-10,10])
%     xlabel('\beta [\circ]')
%     ylabel('C_D [-]')
%     grid on
%     nexttile
%     plot(rud040.AoS,rud040.CMr,'x')
%     hold on
%     plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CMr,3),rud040.AoS))
%     plot(rud040b.AoS,rud040b.CMr,'o')
%     plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CMr,3),rud040b.AoS))
%     xlim([-10,10])
%     xlabel('\beta [\circ]')
%     ylabel('C_{Mr} [-]')
%     grid on
%     nexttile
%     plot(rud040.AoS,rud040.CMp,'x')
%     hold on
%     plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CMp,3),rud040.AoS))
%     plot(rud040b.AoS,rud040b.CMp,'o')
%     plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CMp,3),rud040b.AoS))
%     xlim([-10,10])    
%     xlabel('\beta [\circ]')
%     ylabel('C_{My} [-]')
%     grid on
        
%     figure(3) % figure for rudder stability
%     order=1;
%     t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
%     nexttile
%     plot(rud020.AoS,rud020.CY,'x','HandleVisibility','off')
%     hold on
%     plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CY,order),rud020.AoS))
%     plot(rud520.AoS,rud520.CY,'o','HandleVisibility','off')
%     plot(rud520.AoS,polyval(polyfit(rud520.AoS,rud520.CY,order),rud520.AoS))
%     plot(rud1020.AoS,rud1020.CY,'d','HandleVisibility','off')
%     plot(rud1020.AoS,polyval(polyfit(rud1020.AoS,rud1020.CY,order),rud1020.AoS))
%     xlim([-10,10])
%     xlabel('\beta [deg]')
%     ylabel('C_Y [-]')
%     legend('\delta_r=0','\delta_r=5','\delta_r=10','Location','northwest')
%     nexttile
%     plot(rud020b.AoS,rud020b.CY,'x')
%     hold on
%     plot(rud020b.AoS,polyval(polyfit(rud020b.AoS,rud020b.CY,order),rud020b.AoS))
%     plot(rud520b.AoS,rud520b.CY,'o')
%     plot(rud520b.AoS,polyval(polyfit(rud520b.AoS,rud520b.CY,order),rud520b.AoS))
%     plot(rud1020b.AoS,rud1020b.CY,'d')
%     plot(rud1020b.AoS,polyval(polyfit(rud1020b.AoS,rud1020b.CY,order),rud1020b.AoS))
%     xlim([-10,10])
%     xlabel('\beta [\circ]')
%     ylabel('C_Y [-]')
%     
%     nexttile
%     plot(rud040.AoS,rud040.CY,'x')
%     hold on
%     plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CY,order),rud040.AoS))
%     plot(rud540.AoS,rud540.CY,'o')
%     plot(rud540.AoS,polyval(polyfit(rud540.AoS,rud540.CY,order),rud540.AoS))
%     plot(rud1040.AoS,rud1040.CY,'d')
%     plot(rud1040.AoS,polyval(polyfit(rud1040.AoS,rud1040.CY,order),rud1040.AoS))
%     xlim([-10,10])
%     xlabel('\beta [\circ]')
%     ylabel('C_Y [-]')
%     nexttile
%     plot(rud040b.AoS,rud040b.CY,'x')
%     hold on
%     plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CY,order),rud040b.AoS))
%     plot(rud540b.AoS,rud540b.CY,'o')
%     plot(rud540b.AoS,polyval(polyfit(rud540b.AoS,rud540b.CY,order),rud540b.AoS))
%     plot(rud1040b.AoS,rud1040b.CY,'d')
%     plot(rud1040b.AoS,polyval(polyfit(rud1040b.AoS,rud1040b.CY,order),rud1040b.AoS))
%     xlim([-10,10])
%     xlabel('\beta [\circ]')
%     ylabel('C_Y [-]')
    
%     figure(4) % figure for thrust coefficient
%     t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
%     nexttile
%     plot(rud020b.AoS,rud020b.dPb,'o','LineStyle','-')
%     hold on
%     plot(rud520b.AoS,rud520b.dPb,'o','LineStyle','-')
%     plot(rud1020b.AoS,rud1020b.dPb,'o','LineStyle','-')
%     plot(rud020.AoS,rud020.dPb,'x','LineStyle','--')
%     hold on
%     plot(rud520.AoS,rud520.dPb,'x','LineStyle','--')
%     plot(rud1020.AoS,rud1020.dPb,'x','LineStyle','--')
%     legend('\delta_r=0','\delta_r=5','\delta_r=10','\delta_{r,OEI}=0','\delta_{r,OEI}=5','\delta_{r,OEI}=10','Location','north')
%     xlabel('\beta [\circ]')
%     ylabel('T_C [-]')
%     xlim([-10 10])
%     title('v = 20 m/s')
%     grid on
%     nexttile
%     plot(rud040b.AoS,rud040b.dPb,'o','LineStyle','-')
%     hold on
%     plot(rud540b.AoS,rud540b.dPb,'o','LineStyle','-')
%     plot(rud1040b.AoS,rud1040b.dPb,'o','LineStyle','-')
%     plot(rud040.AoS,rud040.dPb,'x','LineStyle','--')
%     hold on
%     plot(rud540.AoS,rud540.dPb,'x','LineStyle','--')
%     plot(rud1040.AoS,rud1040.dPb,'x','LineStyle','--')
%     legend('\delta_r=0','\delta_r=5','\delta_r=10','\delta_{r,OEI}=0','\delta_{r,OEI}=5','\delta_{r,OEI}=10','Location','north')
%     xlabel('\beta [\circ]')
%     ylabel('T_C [-]')
%     xlim([-10 10])
%     title('v = 40 m/s')
%     grid on
    
    figure("defaultAxesFontSize", 18) % figure for thrust coefficient
    t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
    lw=1.5;
    mw=2;
    nexttile
    plot(rud020b.AoS,rud020b.dPb,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
    hold on
    plot(rud020b.AoS,polyval(polyfit(rud020b.AoS,rud020b.dPb,3),rud020b.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
    plot(rud520b.AoS,rud520b.dPb,'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud520b.AoS,polyval(polyfit(rud520b.AoS,rud520b.dPb,3),rud520b.AoS),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud1020b.AoS,rud1020b.dPb,'o','LineWidth',mw,'Color',[0.9290, 0.6940, 0.1250])
    plot(rud1020b.AoS,polyval(polyfit(rud1020b.AoS,rud1020b.dPb,3),rud1020b.AoS),'--','LineWidth',lw,'Color',[0.9290, 0.6940, 0.1250])
%     legend('\delta_r=0','\delta_r=5','\delta_r=10','fit \delta_r=0','fit \delta_r=5','fit \delta_r=10','FontSize',14,'Location','eastoutside')
    xlabel('\beta [\circ]')
    ylabel('T_C [-]')
    xlim([-10 10])
    title('U_{\infty} = 20 m/s')
    grid on
    nexttile
    plot(rud040b.AoS,rud040b.dPb,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
    hold on
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.dPb,3),rud040b.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
    plot(rud540b.AoS,rud540b.dPb,'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud540b.AoS,polyval(polyfit(rud540b.AoS,rud540b.dPb,3),rud540b.AoS),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud1040b.AoS,rud1040b.dPb,'o','LineWidth',mw,'Color',[0.9290, 0.6940, 0.1250])
    plot(rud1040b.AoS,polyval(polyfit(rud1040b.AoS,rud1040b.dPb,3),rud1040b.AoS),'--','LineWidth',lw,'Color',[0.9290, 0.6940, 0.1250])
    legend('\delta_r=0','\delta_r=5','\delta_r=10','fit \delta_r=0','fit \delta_r=5','fit \delta_r=10','FontSize',14,'Location','northeast')
    xlabel('\beta [\circ]')
    ylabel('T_C [-]')
    xlim([-10 10])
    title('U_{\infty} = 40 m/s')
    grid on
%     set(gcf, 'Position', get(0, 'Screensize'));

%     figure("defaultAxesFontSize", 18) % figure for thrust coefficient
%     t = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
%     nexttile
%     plot(rud020.AoS,rud020.CY,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
%     hold on
%     plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CY,3),rud020.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
%     plot(rud020b.AoS([1:4, 7:10]),rud020b.CY([1:4, 7:10]),'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
%     plot(rud020b.AoS([1:4, 7:10]),polyval(polyfit(rud020b.AoS([1:4, 7:10]),rud020b.CY([1:4, 7:10]),3),rud020b.AoS([1:4, 7:10])),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
%     ylabel('C_Y')
%     xlabel('\beta')
%     xlim([-11 11])
%     legend('OEI','OEI fit','Both engines on','BEO fit')
%     nexttile
%     plot(rud020.AoS,rud020.CMy,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
%     hold on
%     plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CMy,3),rud020.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
%     plot(rud020b.AoS([1:4, 7:10]),rud020b.CMy([1:4, 7:10]),'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
%     plot(rud020b.AoS([1:4, 7:10]),polyval(polyfit(rud020b.AoS([1:4, 7:10]),rud020b.CMy([1:4, 7:10]),3),rud020b.AoS([1:4, 7:10])),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
%     ylabel('C_{My}')
%     xlabel('\beta')
%     xlim([-11 11])
%     nexttile
%     plot(rud040.AoS,rud040.CY,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
%     hold on
%     plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CY,3),rud040.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
%     plot(rud040b.AoS,rud040b.CY,'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
%     plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CY,3),rud040b.AoS),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
%     ylabel('C_Y')
%     xlabel('\beta')
%     xlim([-11 11])
%     nexttile
%     plot(rud040.AoS,rud040.CMy,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
%     hold on
%     plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CMy,3),rud040.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
%     plot(rud040b.AoS,rud040b.CMy,'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
%     plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CMy,3),rud040b.AoS),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
%     ylabel('C_{My}')
%     xlabel('\beta')
%     xlim([-11 11])

    figure("defaultAxesFontSize", 18) % figure for thrust coefficient
    t = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
    nexttile
    plot(rud020.AoS,rud020.CY,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CY,3),rud020.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CY([1:4, 7:10]),'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud020b.AoS([1:4, 7:10]),polyval(polyfit(rud020b.AoS([1:4, 7:10]),rud020b.CY([1:4, 7:10]),3),rud020b.AoS([1:4, 7:10])),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
    ylabel('C_Y [-]')
    xlabel('\beta [\circ]')
    xlim([-11 11])
    title('U_{\infty} = 20 m/s')
    grid on
    legend('OEI','OEI fit','BEO','BEO fit')
    nexttile
    plot(rud020.AoS,rud020.CMy,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CMy,3),rud020.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CMy([1:4, 7:10]),'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud020b.AoS([1:4, 7:10]),polyval(polyfit(rud020b.AoS([1:4, 7:10]),rud020b.CMy([1:4, 7:10]),3),rud020b.AoS([1:4, 7:10])),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
    ylabel('C_{My} [-]')
    xlabel('\beta [\circ]')
    xlim([-11 11])
    title('U_{\infty} = 20 m/s')
    grid on
    nexttile
    plot(rud020.AoS,rud020.CMr,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CMr,3),rud020.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
    plot(rud020b.AoS([1:4, 7:10]),rud020b.CMr([1:4, 7:10]),'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud020b.AoS([1:4, 7:10]),polyval(polyfit(rud020b.AoS([1:4, 7:10]),rud020b.CMr([1:4, 7:10]),3),rud020b.AoS([1:4, 7:10])),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
    ylabel('C_{Mr} [-]')
    xlabel('\beta [\circ]')
    xlim([-11 11])
    grid on
    title('U_{\infty} = 20 m/s')
    nexttile
    
    plot(rud040.AoS,rud040.CY,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CY,3),rud040.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
    plot(rud040b.AoS,rud040b.CY,'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CY,3),rud040b.AoS),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
    ylabel('C_Y [-]')
    xlabel('\beta [\circ]')
    xlim([-11 11])
    title('U_{\infty} = 40 m/s')
    grid on
    nexttile
    plot(rud040.AoS,rud040.CMy,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CMy,3),rud040.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
    plot(rud040b.AoS,rud040b.CMy,'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CMy,3),rud040b.AoS),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
    ylabel('C_{My} [-]')
    xlabel('\beta [\circ]')
    xlim([-11 11])
    title('U_{\infty} = 40 m/s')
    grid on
    nexttile
    plot(rud040.AoS,rud040.CMr,'o','LineWidth',mw,'Color',[0, 0.4470, 0.7410])
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CMr,3),rud040.AoS),'--','LineWidth',lw,'Color',[0, 0.4470, 0.7410])
    plot(rud040b.AoS,rud040b.CMr,'o','LineWidth',mw,'Color',[0.8500, 0.3250, 0.0980])
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CMr,3),rud040b.AoS),'--','LineWidth',lw,'Color',[0.8500, 0.3250, 0.0980])
    ylabel('C_{Mr} [-]')
    xlabel('\beta [\circ]')
    xlim([-11 11])
    title('U_{\infty} = 40 m/s')
    grid on
%     figure(5)
%     plot(jVar.J_M1,jVar.dPb.*jVar.J_M1.^2*pi/8,'x')
%     hold on
%     plot([2.1 1.8 1.6], [0.115 0.235 0.3073])
    
    function delta_r = findTrimAngle(cstLst, betaLst, dyddrLst, ...
            dydbetaLst)
       delta_r = (-dydbetaLst.*betaLst-cstLst)./(dyddrLst);
    end
    
end