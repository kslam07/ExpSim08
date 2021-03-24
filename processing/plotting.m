function [] = plotting(data)
    %% Get data indices
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
    plot(rud020.AoS,rud020.CN,'x')
    hold on
    plot(rud020.AoS,polyval(polyfit(rud020.AoS,rud020.CN,3),rud020.AoS))
    plot(rud020b.AoS,rud020b.CN,'o')
    plot(rud020b.AoS,polyval(polyfit(rud020b.AoS,rud020b.CN,3),rud020b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_N')
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
    plot(rud040.AoS,rud040.CN,'x')
    hold on
    plot(rud040.AoS,polyval(polyfit(rud040.AoS,rud040.CN,3),rud040.AoS))
    plot(rud040b.AoS,rud040b.CN,'o')
    plot(rud040b.AoS,polyval(polyfit(rud040b.AoS,rud040b.CN,3),rud040b.AoS))
    xlim([-10,10])
    xlabel('\beta')
    ylabel('C_N')
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
    nexttile
    plot(rud040b.AoS,rud040b.dPb)
    hold on
    plot(rud540b.AoS,rud540b.dPb)
    plot(rud1040b.AoS,rud1040b.dPb)
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
end