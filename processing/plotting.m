function [] = plotting(data)
    %% Get data indices to efficiently sort row
    idx020 = data.i2.rud0.V==20 & data.i0.rud0.iM2==0 & data.i0.rud0.J_M1>2;
    idx020b = data.i2.rud0.V==20 & data.i0.rud0.iM2~=0 & data.i0.rud0.J_M1>2;
    idx040 = data.i2.rud0.V==40 & data.i0.rud0.iM2==0 & data.i0.rud0.J_M1>2;
    idx040b = data.i2.rud0.V==40 & data.i0.rud0.iM2~=0 & data.i0.rud0.J_M1>2;
    idxJVar = data.i0.rud0.iM2~=0 & abs(data.i0.rud0.AoS)<1.5;
    
    idx520 = data.i2.rud5.V==20 & data.i0.rud5.iM2==0;
    idx520b = data.i2.rud5.V==20 & data.i0.rud5.iM2~=0;
    idx540 = data.i2.rud5.V==40 & data.i0.rud5.iM2==0;
    idx540b = data.i2.rud5.V==40 & data.i0.rud5.iM2~=0;

    idx1020 = data.i2.rud10.V==20 & data.i0.rud10.iM2==0;
    idx1020b = data.i2.rud10.V==20 & data.i0.rud10.iM2~=0;
    idx1040 = data.i2.rud10.V==40 & data.i0.rud10.iM2==0;
    idx1040b = data.i2.rud10.V==40 & data.i0.rud10.iM2~=0;
    
    %% Sort rows based on indices
    jVar=sortrows(data.i0.rud0(idxJVar,:),'AoS');
    
    rud020=sortrows(data.i0.rud0(idx020,:),'AoS');
    rud020b=sortrows(data.i0.rud0(idx020b,:),'AoS');
    rud040=sortrows(data.i0.rud0(idx040,:),'AoS');
    rud040b=sortrows(data.i0.rud0(idx040b,:),'AoS');
    
    rud520=sortrows(data.i0.rud5(idx520,:),'AoS');
    rud520b=sortrows(data.i0.rud5(idx520b,:),'AoS');
    rud540=sortrows(data.i0.rud5(idx540,:),'AoS');
    rud540b=sortrows(data.i0.rud5(idx540b,:),'AoS');
    
    rud1020=sortrows(data.i0.rud10(idx1020,:),'AoS');
    rud1020b=sortrows(data.i0.rud10(idx1020b,:),'AoS');
    rud1040=sortrows(data.i0.rud10(idx1040,:),'AoS');
    rud1040b=sortrows(data.i0.rud10(idx1040b,:),'AoS');

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
            CY020b = rud020b(4, :);
            CY520b = rud520b(abs(AOS(iAOS)-rud520b.AoS)<err, :);
            CY1020b = rud1020b(abs(AOS(iAOS)-rud1020b.AoS)<err, :);
            CYArr20b(iAOS,:) = [CY020b.CY CY520b.CY CY1020b.CY];
            
        elseif AOS(iAOS)==0
            CYArr20b(iAOS,:) = [0 0 0];
        else
            CY020b = rud020b(abs(AOS(iAOS)-rud020b.AoS)<err, :);
            CY520b = rud520b(abs(AOS(iAOS)-rud520b.AoS)<err, :);
            CY1020b = rud1020b(abs(AOS(iAOS)-rud1020b.AoS)<err, :);
            CYArr20b(iAOS,:) = [CY020b.CY CY520b.CY CY1020b.CY];
        end
        
        if AOS(iAOS)==-10
            CY040 = rud040(1, :);
            CY540 = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CY1040 = rud1040(abs(AOS(iAOS)-rud1040.AoS)<err, :);
            CYArr40(iAOS,:) = [CY040.CY CY540.CY CY1040.CY];
        elseif AOS(iAOS)==-4
            CY040b = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CY540b = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CY1040b = rud1040(3, :);
            CYArr40b(iAOS,:) = [CY040b.CY CY540b.CY CY1040b.CY];
        else
            CY040 = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CY540 = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CY1040 = rud1040(abs(AOS(iAOS)-rud1040.AoS)<err, :);
            CYArr40(iAOS,:) = [CY040.CY CY540.CY CY1040.CY];
        end
            CY040b = rud040(abs(AOS(iAOS)-rud040b.AoS)<err, :);
            CY540b = rud540(abs(AOS(iAOS)-rud540b.AoS)<err, :);
            CY1040b = rud1040(abs(AOS(iAOS)-rud1040b.AoS)<err, :);
            CYArr40b(iAOS,:) = [CY040b.CY CY540b.CY CY1040b.CY];
    end
    
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
        fit=polyfit([0 5 10], CYArr20b(idx,:),1);
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
    dcydd20=mean(dCYddelta20);
    dcydd20b=mean(dCYddelta20b);
    dcydd40=mean(dCYddelta40);
    dcydd40b=mean(dCYddelta40b);
    
    % take average of CY0 (cst. term) in TSE
    cy020=mean(CY0d20);
    cy020b=mean(CY0d20b);
    cy040=mean(CY0d40);
    cy040b=mean(CY0d40b);
    
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
    
    subplot(2,2,1)
    scatter([-10 -6:2:6 10],dCYddelta20)
    xlabel('\beta')
    ylabel('dC_Y/d\delta_r')
    title('v=20, OEI')
    hold on
    yline(dcydd20)
    subplot(2,2,2)
    scatter([-10 -6:2:6 10],dCYddelta20b)
    yline(dcydd20b)
    xlabel('\beta')
    ylabel('dC_Y/d\delta_r')
    title('v=20')
    subplot(2,2,3)
    scatter([-10 -6:2:6 10],dCYddelta40)
    yline(dcydd40)
    xlabel('\beta')
    ylabel('dC_Y/d\delta_r')
    title('v=40, OEI')
    subplot(2,2,4)
    scatter([-10 -6:2:6 10],dCYddelta40b)
    yline(dcydd40b)
     xlabel('\beta')
    ylabel('dC_Y/d\delta_r')
    title('v=40')
    sgtitle('dC_Y/d\delta_r')
    

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
        CMy020 = rud020(abs(AOS(iAOS)-rud020.AoS)<err, :);
        CMy520 = rud520(abs(AOS(iAOS)-rud520.AoS)<err, :);
        CMy1020 = rud1020(abs(AOS(iAOS)-rud1020.AoS)<err, :);
        CMyArr20(iAOS,:) = [CMy020.CMy CMy520.CMy CMy1020.CMy];
        
        if AOS(iAOS)==-2
            CMy020b = rud020b(4, :);
            CMy520b = rud520b(abs(AOS(iAOS)-rud520b.AoS)<err, :);
            CMy1020b = rud1020b(abs(AOS(iAOS)-rud1020b.AoS)<err, :);
            CMyArr20b(iAOS,:) = [CMy020b.CMy CMy520b.CMy CMy1020b.CMy];
            
        elseif AOS(iAOS)==0
            CMyArr20b(iAOS,:) = [0 0 0];
        else
            CMy020b = rud020b(abs(AOS(iAOS)-rud020b.AoS)<err, :);
            CMy520b = rud520b(abs(AOS(iAOS)-rud520b.AoS)<err, :);
            CMy1020b = rud1020b(abs(AOS(iAOS)-rud1020b.AoS)<err, :);
            CMyArr20b(iAOS,:) = [CMy020b.CMy CMy520b.CMy CMy1020b.CMy];
        end
        
        if AOS(iAOS)==-10
            CMy040 = rud040(1, :);
            CMy540 = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CMy1040 = rud1040(abs(AOS(iAOS)-rud1040.AoS)<err, :);
            CMyArr40(iAOS,:) = [CMy040.CMy CMy540.CMy CMy1040.CMy];
        elseif AOS(iAOS)==-4
            CMy040b = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CMy540b = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CMy1040b = rud1040(3, :);
            CMyArr40b(iAOS,:) = [CMy040b.CMy CMy540b.CMy CMy1040b.CMy];
        else
            CMy040 = rud040(abs(AOS(iAOS)-rud040.AoS)<err, :);
            CMy540 = rud540(abs(AOS(iAOS)-rud540.AoS)<err, :);
            CMy1040 = rud1040(abs(AOS(iAOS)-rud1040.AoS)<err, :);
            CMyArr40(iAOS,:) = [CMy040.CMy CMy540.CMy CMy1040.CMy];
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
        if idx == 5
            CMy0d20 = fit(2);                % value for CMyo
        end
    end
    for idx=1:length(CMyArr20b)
        if idx == 5
            
        else
            fit=polyfit([0 5 10], CMyArr20b(idx,:),1);
            dCMyddelta20b = [dCMyddelta20b fit(1)];
            CMy0d20b = [CMy0d20b fit(2)];
        end
    end    
    for idx=1:length(CMyArr40)
        if idx == 3
            1;
        elseif idx == 5
            fit=polyfit([0 5 10], CMyArr40(idx,:),1);
            CMy0d40 = fit(2);
        else
            fit=polyfit([0 5 10], CMyArr40(idx,:),1);
            dCMyddelta40 = [dCMyddelta40 fit(1)];
        end
    end
    for idx=1:length(CMyArr40b)
        fit=polyfit([0 5 10], CMyArr40b(idx,:),1);
        dCMyddelta40b = [dCMyddelta40b fit(1)];
        if idx == 5
            CMy0d40b = fit(2);
        end
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
    dCMydb20b   = mean([dCMydb020b(3) dCMydb520b(3) dCMydb1020b(3)]);% too much noise
    dCMydb40    = mean([dCMydb040(3) dCMydb540(3) dCMydb1040(3)]);
    dCMydb40b   = mean([dCMydb040b(3) dCMydb540b(3) dCMydb1040b(3)]);
    
    % dCMydbeta|0 for different delta_r
    CMy0b20     = rud020(abs(rud020.AoS) < 0.2, end).CMy;%dCMydb020(4) + CMy0d20;
    CMy0b20b    = rud020b(abs(rud020b.AoS) < 0.2, end).CMy;%dCMydb020b(4)+ CMy0d20b;
    CMy0b40     = rud040(abs(rud040.AoS) < 0.2, end).CMy;%dCMydb040(4) + CMy0d40;
    CMy0b40b    = rud040b(abs(rud040b.AoS) < 0.2, end).CMy;%dCMydb040b(4)+ CMy0d40b;
    
    % compute the corresponding sideslip for the given rudder angle and
    % configuration. You want to find the trim based on the steady-state
    % condition which we define to be delta_r=0 and beta=0. Then, the
    % CMy0 should be obtained from CMy0|beta=0 and CMy0|delta_r=0
    
    % only compute OEI states, why do we even want to do it for both
    % engines on?
    aosspace = linspace(-5, 5, 11);
    AoSTrim20 = findBeta4TrimAngle(CMy0b20, aosspace, dCMydd20, dCMydb20);
    AoSTrim40 = findBeta4TrimAngle(CMy0b40, aosspace, dCMydd40, dCMydb40);
    % if you actually insert the const. term, then both engines on require
    % more trimming then OEI. Noise?
    AoSTrim40b = findBeta4TrimAngle(CMy0b40b, aosspace, dCMydd40b, dCMydb40b);
    
    figure("defaultAxesFontSize", 14)
    hold on
    plot(aosspace, AoSTrim20, "DisplayName", "V20 - OEI")
    plot(aosspace, AoSTrim40, "DisplayName", "V40 - OEI")
    plot(aosspace, AoSTrim40b, "DisplayName", "V40")
    xlabel("\beta")
    ylabel("\delta_{r,trim}")
    legend
    grid
    
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

    
    subplot(2,2,1)
    scatter([-10 -6:2:6 10],dCYddelta20)
    xlabel('\beta')
    ylabel('dC_Y/d\delta_r')
    title('v=20, OEI')
    hold on
    yline(dcydd20)
    subplot(2,2,2)
    scatter([-10 -6:2:6 10],dCYddelta20b)
    yline(dcydd20b)
    xlabel('\beta')
    ylabel('dC_Y/d\delta_r')
    title('v=20')
    subplot(2,2,3)
    scatter([-10 -6:2:6 10],dCYddelta40)
    yline(dcydd40)
    xlabel('\beta')
    ylabel('dC_Y/d\delta_r')
    title('v=40, OEI')
    subplot(2,2,4)
    scatter([-10 -6:2:6 10],dCYddelta40b)
    yline(dcydd40b)
     xlabel('\beta')
    ylabel('dC_Y/d\delta_r')
    title('v=40')
    sgtitle('dC_Y/d\delta_r')
    
    
    %% Plotting
    figure(1)
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    nexttile
    plot(rud020.AoS,rud020.CY,'x')
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CY,3),rud020.AoS))
    plot(rud020b.AoS,rud020b.CY,'o')
    plot(rud020b.AoS,polyval(polyfit(rud020b.AoS,rud020b.CY,3),rud020b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_Y')
    grid on
    nexttile
    plot(rud020.AoS,rud020.CD,'x')
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CD,3),rud020.AoS))
    plot(rud020b.AoS,rud020b.CD,'o')
    plot(rud020b.AoS,polyval(polyfit(rud020b.AoS,rud020b.CD,3),rud020b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_D')
    grid on
    nexttile
    plot(rud020.AoS,rud020.CMr,'x')
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CMr,3),rud020.AoS))
    plot(rud020b.AoS,rud020b.CMr,'o')
    plot(rud020b.AoS,polyval(polyfit(rud020b.AoS,rud020b.CMr,3),rud020b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_{Mr}')
    grid on
    nexttile
    plot(rud020.AoS,rud020.CMp,'x')
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CMp,3),rud020.AoS))
    plot(rud020b.AoS,rud020b.CMp,'o')
    plot(rud020b.AoS,polyval(polyfit(rud020b.AoS,rud020b.CMp,3),rud020b.AoS))
    xlim([-10,10])   
    xlabel('\beta')
    ylabel('C_{My}')
    grid on

    figure(2)
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    nexttile
    plot(rud040.AoS,rud040.CY,'x')
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CY,3),rud040.AoS))
    plot(rud040b.AoS,rud040b.CY,'o')
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CY,3),rud040b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_Y')
    grid on
    nexttile
    plot(rud040.AoS,rud040.CD,'x')
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CD,3),rud040.AoS))
    plot(rud040b.AoS,rud040b.CD,'o')
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CD,3),rud040b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_D')
    grid on
    nexttile
    plot(rud040.AoS,rud040.CMr,'x')
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CMr,3),rud040.AoS))
    plot(rud040b.AoS,rud040b.CMr,'o')
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CMr,3),rud040b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_{Mr}')
    grid on
    nexttile
    plot(rud040.AoS,rud040.CMp,'x')
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CMp,3),rud040.AoS))
    plot(rud040b.AoS,rud040b.CMp,'o')
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CMp,3),rud040b.AoS))
    xlim([-10,10])    
    xlabel('\beta')
    ylabel('C_{My}')
    grid on
    
    figure(3) % figure for thrust coefficient
    t = tiledlayout(1,2,'TileSpacing','Compact','Padding','Compact');
    nexttile
    plot(rud020b.AoS,rud020b.dPb)
    hold on
    plot(rud520b.AoS,rud520b.dPb)
    plot(rud1020b.AoS,rud1020b.dPb)
    legend('\delta_r=0','\delta_r=5','\delta_r=10','Location','northwest')
    scatter(rud020.AoS,rud020.dPb)
    hold on
    scatter(rud520.AoS,rud520.dPb)
    scatter(rud1020.AoS,rud1020.dPb)
    legend('\delta_r=0','\delta_r=5','\delta_r=10','Location','northwest')
    nexttile
    plot(rud040b.AoS,rud040b.dPb)
    hold on
    plot(rud540b.AoS,rud540b.dPb)
    plot(rud1040b.AoS,rud1040b.dPb)
    legend('\delta_r=0','\delta_r=5','\delta_r=10','Location','northwest')
    plot(rud040.AoS,rud040.dPb,'--')
    hold on
    plot(rud540.AoS,rud540.dPb,'--')
    plot(rud1040.AoS,rud1040.dPb,'--')
    legend('\delta_r=0','\delta_r=5','\delta_r=10','Location','northwest')
    
    figure(4) % figure for rudder stability
    order=1;
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    nexttile
    plot(rud020.AoS,rud020.CY,'x','HandleVisibility','off')
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CY,order),rud020.AoS))
    plot(rud520.AoS,rud520.CY,'o','HandleVisibility','off')
    plot(rud520.AoS,polyval(polyfit(rud520.AoS,rud520.CY,order),rud520.AoS))
    plot(rud1020.AoS,rud1020.CY,'d','HandleVisibility','off')
    plot(rud1020.AoS,polyval(polyfit(rud1020.AoS,rud1020.CY,order),rud1020.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_Y')
    legend('\delta_r=0','\delta_r=5','\delta_r=10','Location','northwest')
    nexttile
    plot(rud020b.AoS,rud020b.CY,'x')
    hold on
    plot(rud020b.AoS,polyval(polyfit(rud020b.AoS,rud020b.CY,order),rud020b.AoS))
    plot(rud520b.AoS,rud520b.CY,'o')
    plot(rud520b.AoS,polyval(polyfit(rud520b.AoS,rud520b.CY,order),rud520b.AoS))
    plot(rud1020b.AoS,rud1020b.CY,'d')
    plot(rud1020b.AoS,polyval(polyfit(rud1020b.AoS,rud1020b.CY,order),rud1020b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_Y')
    
    nexttile
    plot(rud040.AoS,rud040.CY,'x')
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CY,order),rud040.AoS))
    plot(rud540.AoS,rud540.CY,'o')
    plot(rud540.AoS,polyval(polyfit(rud540.AoS,rud540.CY,order),rud540.AoS))
    plot(rud1040.AoS,rud1040.CY,'d')
    plot(rud1040.AoS,polyval(polyfit(rud1040.AoS,rud1040.CY,order),rud1040.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_Y')
    nexttile
    plot(rud040b.AoS,rud040b.CY,'x')
    hold on
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CY,order),rud040b.AoS))
    plot(rud540b.AoS,rud540b.CY,'o')
    plot(rud540b.AoS,polyval(polyfit(rud540b.AoS,rud540b.CY,order),rud540b.AoS))
    plot(rud1040b.AoS,rud1040b.CY,'d')
    plot(rud1040b.AoS,polyval(polyfit(rud1040b.AoS,rud1040b.CY,order),rud1040b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_Y')
    
    function beta = findBeta4TrimAngle(cstLst, betaLst, dyddrLst, ...
            dydbetaLst)
       beta = (-dydbetaLst.*betaLst-cstLst)./(dyddrLst);
    end
    
end