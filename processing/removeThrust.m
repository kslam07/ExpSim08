classdef removeThrust
    
methods (Static)
    function dataOut = mainFunction(dataStruct)
        % x=load2Struct('OUTPUT.xls','DATA/TailOffData.xlsx').i0
        %% Get initial data set
        propOff=sortrows(dataStruct.propoff,[19 6]);    %read data and order for velocity and engine setting
        beta0=sortrows(dataStruct.beta0,[19 24 6]);
        beta5=sortrows(dataStruct.beta5,[19 24 6]);
        beta10=sortrows(dataStruct.beta10, [19 24 6]);
        beta0(table2array(beta0(:,28))<2,:)=[];  % remove measurements where propeller was not at right J
        
        %% Get relevant values
        beta020=table2array(beta0(1:9,:));  % v=20, OEI
        beta020=sortrows(beta020(:,[6,19,24,30:32]),1);    % aos, v, Engine setting,  FX, FY, FZ
        beta020b=table2array(beta0(10:19,:),6); % V=20
        beta020b=sortrows(beta020b(:,[6,19,24,30:32]),1);    % aos, FX, FY, FZ
        beta040=table2array(beta0(20:29,:),6);  % V=40, OEI
        beta040=sortrows(beta040(:,[6,19,24,30:32]),1);   % aos, FX, FY, FZ
        beta040b=table2array(beta0(30:38,:),6); % V=40
        beta040b=sortrows(beta040b(:,[6,19,24,30:32]),1);    % aos, FX, FY, FZ
        
        beta520=table2array(beta5(1:9,:));  % v=20, OEI
        beta520=sortrows(beta520(:,[6,19,24,30:32]),1);    % aos, v, Engine setting,  FX, FY, FZ
        beta520b=table2array(beta5(10:18,:),6); % V=20
        beta520b=sortrows(beta520b(:,[6,19,24,30:32]),1);    % aos, FX, FY, FZ
        beta540=table2array(beta5(19:27,:),6);  % V=40, OEI
        beta540=sortrows(beta540(:,[6,19,24,30:32]),1);   % aos, FX, FY, FZ
        beta540b=table2array(beta5(28:36,:),6); % V=40
        beta540b=sortrows(beta540b(:,[6,19,24,30:32]),1);    % aos, FX, FY, FZ
        
        beta1020=table2array(beta10(1:9,:));  % v=20, OEI
        beta1020=sortrows(beta1020(:,[6,19,24,30:32]),1);    % aos, v, Engine setting,  FX, FY, FZ
        beta1020b=table2array(beta10(10:18,:),6); % V=20
        beta1020b=sortrows(beta1020b(:,[6,19,24,30:32]),1);    % aos, FX, FY, FZ
        beta1040=table2array(beta10(19:28,:),6);  % V=40, OEI
        beta1040=sortrows(beta1040(:,[6,19,24,30:32]),1);   % aos, FX, FY, FZ
        beta1040b=table2array(beta10(29:37,:),6); % V=40
        beta1040b=sortrows(beta1040b(:,[6,19,24,30:32]),1);    % aos, FX, FY, FZ        
        
     
        %% Remove prop off data from measurements
        propOff20=table2array(propOff(1:5,{'AoS','V','iM2','FX','FY','FZ'}));
        pOneg=flip(propOff20(2:5,:));   % mirror to get negative sideslip values
        pOneg=pOneg.*[-1,1,1,1,-1,1];       % flip sign AoS and Fy
        propOff20=cat(1,pOneg, propOff20); % array containing the prop off forces v=20
        propOff40=table2array(propOff(6:10,{'AoS','V','iM2','FX','FY','FZ'}));
        pOneg=flip(propOff40(2:5,:));
        pOneg=pOneg.*[-1,1,1,1,-1,1];
        propOff40=cat(1,pOneg, propOff40); % array containing the prop off forces v=40
        
        order=8;
        fcor20x=polyfit(propOff20(:,1),propOff20(:,4),order); % make fit for forces
        fcor20y=polyfit(propOff20(:,1),propOff20(:,5),order);
        fcor20z=polyfit(propOff20(:,1),propOff20(:,6),order);
        
        fcor40x=polyfit(propOff40(:,1),propOff40(:,4),order);
        fcor40y=polyfit(propOff40(:,1),propOff40(:,5),order);
        fcor40z=polyfit(propOff40(:,1),propOff40(:,6),order);
        
        % Make copies for corrections
        beta020p=beta020;
        beta020bp=beta020b;
        beta040p=beta040;
        beta040bp=beta040b;
        
        beta020p(:,4)=beta020p(:,4)-polyval(fcor20x,beta020p(:,1));    %model off corrections in x, y and z directions
        beta020p(:,5)=beta020p(:,5)-polyval(fcor20y,beta020p(:,1));
        beta020p(:,6)=beta020p(:,6)-polyval(fcor20z,beta020p(:,1));
        
        beta020bp(:,4)=beta020bp(:,4)-polyval(fcor20x,beta020bp(:,1));    %model off corrections in x, y and z directions
        beta020bp(:,5)=beta020bp(:,5)-polyval(fcor20y,beta020bp(:,1));
        beta020bp(:,6)=beta020bp(:,6)-polyval(fcor20z,beta020bp(:,1));

        % Add AoS=0 measurement point from average
        beta020bp=sortrows(cat(1,beta020bp, [0 20 0.5 mean([beta020bp(6,4),beta020bp(7,4)]) mean([beta020bp(6,5),beta020bp(7,5)]) mean([beta020bp(6,6),beta020bp(7,6)])]),1);
        beta020b=sortrows(cat(1,beta020b, [0 20 0.5 mean([beta020b(6,4),beta020b(7,4)]) mean([beta020b(6,5),beta020b(7,5)]) mean([beta020b(6,6),beta020b(7,6)])]),1);
        
        beta040p(:,4)=beta040p(:,4)-polyval(fcor40x,beta040p(:,1));    %model off corrections in x, y and z directions
        beta040p(:,5)=beta040p(:,5)-polyval(fcor40y,beta040p(:,1));
        beta040p(:,6)=beta040p(:,6)-polyval(fcor40z,beta040p(:,1));
        
        beta040bp(:,4)=beta040bp(:,4)-polyval(fcor40x,beta040bp(:,1));    %model off corrections in x, y and z directions
        beta040bp(:,5)=beta040bp(:,5)-polyval(fcor40y,beta040bp(:,1));
        beta040bp(:,6)=beta040bp(:,6)-polyval(fcor40z,beta040bp(:,1));
        
        %%
%         figure(1)
%         title('Corrected data')
%         subplot(2,2,1)
%         plot(beta020(:,1),beta020(:,4:6))
%         hold on
%         plot(beta020(:,1),beta020p(:,4:6),'-x')
%         legend('x','y','z','xc','yc','zc')
%         title('v=20')
%         subplot(2,2,2)
%         plot(beta020b(:,1),beta020b(:,4:6))
%         hold on
%         plot(beta020b(:,1),beta020bp(:,4:6),'-x')
%         legend('x','y','z','xc','yc','zc')
%         title('v=20')
%         subplot(2,2,3)
%         plot(beta040(:,1),beta040(:,4:6))
%         hold on
%         plot(beta040(:,1),beta040p(:,4:6),'-x')
%         legend('x','y','z','xc','yc','zc')
%         title('v=40')
%         subplot(2,2,4)
%         plot(beta040b(:,1),beta040b(:,4:6))
%         hold on
%         plot(beta040b(:,1),beta040bp(:,4:6),'-x')
%         legend('x','y','z','xc','yc','zc')
%         title('v=40')
%         sgtitle('Forces due to Thrust')
        

        %% Compute thrust       
 
        data=beta020bp; % data thrust effect
        idx=abs(data(:,1))==min(abs(data(:,1))); % get index for zero sideslip
        zeroAoS=data(idx,:); % data for zero sideslip thrust effect
        
        dataMO=removeModelOff(beta020b); % data with strut effect removed
        zeroAoSMO=dataMO(idx,:);
        
        dataPO=removeModelOff(propOff20);
        idx1=abs(data(:,1))==min(abs(data(:,1)));
        zeroAoSPO=dataPO(idx1,:);
        
        CLm=zeroAoSMO(6)./(0.5*1.225*zeroAoSMO(2).^2*0.2172); % CL for sideslip 0
        iter=0;
        zeroAoS
        thrustIn=-1*(-zeroAoS(6)*sind(2)+zeroAoS(4)*cosd(2))
        zeroAoS(6);
        zeroAoS(2);
%         thrustIn=-data(4)
        thrustOut=thrustIter([thrustIn, dataMO(5,2), dataMO(5,6),zeroAoSPO(6)/(0.5*1.225*zeroAoS(2)^2*0.2172)])
        thrustSideslip([thrustOut zeroAoS(2) 10])
        CT=thrustOut/1.225/(zeroAoSMO(2)/2.1/0.2032)^2/0.2032^4/2;
        thrustCorr([thrustOut zeroAoS(2) zeroAoSMO(6)/(0.5*1.225*zeroAoS(2)^2*0.2172)])
        
        dataOut=beta020p;
        
     %%
    function Tout=thrustIter(data) % T, V, FZ, CLTC=0
        T1=data(1);
        TOL1=1;
        while TOL1>0.001
            CLTC=(data(3)-data(1)*sind(2))/(0.5*1.225*data(2)^2*0.2172);
            dcl=CLTC-data(4);
            cdi=dcl/pi/3.87;
            T=data(1)+cdi*0.5*1.225*data(2)^2.*0.0415;
            TOL1=(T-T1)/T1;
            T1=T;
        end
        Tout=T;
    end
    
    %%
    function thrustSideOut=thrustSideslip(data)    % T, V, Beta
        sigmaEff=4*6/3/pi*(0.01427/0.2032);
        B0=45; % pitch at r/R=0.75 (is given for r/R=0.7)
        J=2.1;
%         CT=data(1)/(0.5*1.225*data(2)^2*0.2172);
        CT=data(1)/(1.225*(data(2)/2.1/0.2032)^2*0.2032^4)
        dTdb = 4.25*sigmaEff/(1+2*sigmaEff)*sind(B0+3)*(pi*J^2/8+3*sqrt(pi*J^2/8*CT)/(8*sqrt(pi*J^2/8+2/3*CT)))
        thrustCorrSideOut = data(1)+dTdb*data(3);
    end
    
    %%
    function thrustCorrOut=thrustCorr(data) % T, V, CLTC
        TC=data(1)/(0.5*1.225*data(2)^2*0.2172);
        urat=1+0.6*2*0.2032/0.576*(TC*sqrt((sqrt(1+TC)+1)/(2*sqrt(1+TC))));
        dcl=data(3)*(1-urat); % CL at thrust
        cdi=dcl/pi/3.87;
    end
    
    
    %%
    function dataMO=removeModelOff(data)
        modelOff=readtable('modelOffData.xlsx','VariableNamingRule','preserve');    % read model off data
        aoaEffectF=table2array(modelOff(8,2:5))-table2array(modelOff(6,2:5)); % effect of 2 deg aoa on forces
        aosEffect=modelOff{[1,5,7,9,11,13,15,17,21],11:14}; % forces at -10, -6, -4, -2, 0, 2, 4, 6, 10 for aos
        
        AoSFitX=polyfit(aosEffect(:,1),aosEffect(:,2),8); % makes fit of forces in aero frame
        AoSFitY=polyfit(aosEffect(:,1),aosEffect(:,3),8);
        AoSFitZ=polyfit(aosEffect(:,1),aosEffect(:,4),8);
        
        FXa=(polyval(AoSFitX,data(:,1))+aoaEffectF(:,2))*0.5*1.225*0.2172*data(1,2).^2; % force in aero frame
        FYa=(polyval(AoSFitY,data(:,1))+aoaEffectF(:,2))*0.5*1.225*0.2172*data(1,2).^2;
        FZa=(polyval(AoSFitZ,data(:,1))+aoaEffectF(:,2))*0.5*1.225*0.2172*data(1,2).^2;
        
        FX=cos(2)*(-FXa.*cosd(data(:,1))+FYa.*sind(-data(:,1)))+FZa*sind(2);
        FY=FXa.*sind(-data(:,1))+cosd(data(:,1)).*FYa;
        FZ=sin(2)*(-FXa.*cosd(data(:,1))+FYa.*sind(-data(:,1)))+FZa*cosd(2);
        
        fxt=FXa;
        fyt=-sind(data(:,1)).*FXa-cosd(data(:,1)).*FYa;
        fzt=FZa;

        m=size(data,1);
%         dataMO=data-(cat(2, zeros(m,1),zeros(m,1),zeros(m,1), FX, FY, FZ));
        dataMO=data-(cat(2, zeros(m,1),zeros(m,1),zeros(m,1), fxt, fyt, fzt));
    end 
end
end    
end