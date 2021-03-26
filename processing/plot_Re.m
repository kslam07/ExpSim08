function [] = plot_Re(data)
    idx020 = data.i2.rud0.V==20 & data.i0.rud0.iM2==0 & data.i0.rud0.J_M1>2;
    idx020b = data.i2.rud0.V==20 & data.i0.rud0.iM2~=0 & data.i0.rud0.J_M1>2;
    idx040 = data.i2.rud0.V==40 & data.i0.rud0.iM2==0 & data.i0.rud0.J_M1>2;
    idx040b = data.i2.rud0.V==40 & data.i0.rud0.iM2~=0 & data.i0.rud0.J_M1>2;
    
    idx520 = data.i2.rud5.V==20 & data.i0.rud5.iM2==0;
    idx520b = data.i2.rud5.V==20 & data.i0.rud5.iM2~=0;
    idx540 = data.i2.rud5.V==40 & data.i0.rud5.iM2==0;
    idx540b = data.i2.rud5.V==40 & data.i0.rud5.iM2~=0;

    idx1020 = data.i2.rud10.V==20 & data.i0.rud10.iM2==0;
    idx1020b = data.i2.rud10.V==20 & data.i0.rud10.iM2~=0;
    idx1040 = data.i2.rud10.V==40 & data.i0.rud10.iM2==0;
    idx1040b = data.i2.rud10.V==40 & data.i0.rud10.iM2~=0;
    
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

    figure(1);%rudder 0 degrees
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
%     title(t,'rudder 0 degrees OEI');
    nexttile;
    plot(rud020.AoS, rud020.CL,'k-o');
    hold on
    plot(rud040.AoS, rud040.CL,'b-x');
    xlabel('\beta [\circ]');
    ylabel('C_{L}');
    legend('20m/s', '40m/s');    
    nexttile;
    plot(rud020.AoS, rud020.CY,'k-o');
    hold on
    plot(rud040.AoS, rud040.CY,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [\circ]');
    ylabel('C_{Y}');
    nexttile;
    plot(rud020.AoS, rud020.CD,'k-o');
    hold on
    plot(rud040.AoS, rud040.CD,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [\circ]');
    ylabel('C_{D}');
    nexttile;
    plot(rud020.AoS, rud020.CMy,'k-o');
    hold on
    plot(rud040.AoS, rud040.CMy,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [\circ]');
    ylabel('C_{My}');

    figure(2);%rudder 0 degrees both engines
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    title(t,'rudder 0 degrees');
    nexttile;
    plot(rud020b.AoS, rud020b.CL,'k-o');
    hold on
    plot(rud040b.AoS, rud040b.CL,'b-x');
    xlabel('\beta [deg]');
    ylabel('C_{L}');
    legend('20m/s', '40m/s');    
    nexttile;
    plot(rud020b.AoS, rud020b.CY,'k-o');
    hold on
    plot(rud040b.AoS, rud040b.CY,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{Y}');
    nexttile;
    plot(rud020b.AoS, rud020b.CD,'k-o');
    hold on
    plot(rud040b.AoS, rud040b.CD,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{D}');
    nexttile;
    plot(rud020b.AoS, rud020b.CMy,'k-o');
    hold on
    plot(rud040b.AoS, rud040b.CMy,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{My}');
    
    figure(3);%rudder 5 degrees OEI
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    title(t,'rudder 5 degrees OEI');
    nexttile;
    plot(rud520.AoS, rud520.CL,'k-o');
    hold on
    plot(rud540.AoS, rud540.CL,'b-x');
    xlabel('\beta [deg]');
    ylabel('C_{L}');
    legend('20m/s', '40m/s');    
    nexttile;
    plot(rud520.AoS, rud520.CY,'k-o');
    hold on
    plot(rud540.AoS, rud540.CY,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{Y}');
    nexttile;
    plot(rud520.AoS, rud520.CD,'k-o');
    hold on
    plot(rud540.AoS, rud540.CD,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{D}');
    nexttile;
    plot(rud520.AoS, rud520.CMy,'k-o');
    hold on
    plot(rud540.AoS, rud540.CMy,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{My}');

    figure(4);%rudder 5 degrees both engines
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    title(t,'rudder 5 degrees');
    nexttile;
    plot(rud520b.AoS, rud520b.CL,'k-o');
    hold on
    plot(rud540b.AoS, rud540b.CL,'b-x');
    xlabel('\beta [deg]');
    ylabel('C_{L}');
    legend('20m/s', '40m/s');    
    nexttile;
    plot(rud520b.AoS, rud520b.CY,'k-o');
    hold on
    plot(rud540b.AoS, rud540b.CY,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{Y}');
    nexttile;
    plot(rud520b.AoS, rud520b.CD,'k-o');
    hold on
    plot(rud540b.AoS, rud540b.CD,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{D}');
    nexttile;
    plot(rud020b.AoS, rud020b.CMy,'k-o');
    hold on
    plot(rud040b.AoS, rud040b.CMy,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{My}');
    
    figure(5);%rudder 10 degrees OEI
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    title(t,'rudder 10 degrees OEI');
    nexttile;
    plot(rud1020.AoS, rud1020.CL,'k-o');
    hold on
    plot(rud1040.AoS, rud1040.CL,'b-x');
    xlabel('\beta [deg]');
    ylabel('C_{L}');
    legend('20m/s', '40m/s');    
    nexttile;
    plot(rud1020.AoS, rud1020.CY,'k-o');
    hold on
    plot(rud1040.AoS, rud1040.CY,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{Y}');
    nexttile;
    plot(rud1020.AoS, rud1020.CD,'k-o');
    hold on
    plot(rud1040.AoS, rud1040.CD,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{D}');
    nexttile;
    plot(rud1020.AoS, rud1020.CMy,'k-o');
    hold on
    plot(rud1040.AoS, rud1040.CMy,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{My}');

    figure(6);%rudder 10 degrees both engines
    t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
    title(t,'rudder 10 degrees');
    nexttile;
    plot(rud1020b.AoS, rud1020b.CL,'k-o');
    hold on
    plot(rud1040b.AoS, rud1040b.CL,'b-x');
    xlabel('\beta [deg]');
    ylabel('C_{L}');
    legend('20m/s', '40m/s');    
    nexttile;
    plot(rud1020b.AoS, rud1020b.CY,'k-o');
    hold on
    plot(rud1040b.AoS, rud1040b.CY,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{Y}');
    nexttile;
    plot(rud1020b.AoS, rud1020b.CD,'k-o');
    hold on
    plot(rud1040b.AoS, rud1040b.CD,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{D}');
    nexttile;
    plot(rud1020b.AoS, rud1020b.CMy,'k-o');
    hold on
    plot(rud1040b.AoS, rud1040b.CMy,'b-x');
    legend('20m/s', '40m/s');
    xlabel('\beta [deg]');
    ylabel('C_{My}');
    
    
end

