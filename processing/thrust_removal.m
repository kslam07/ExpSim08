classdef thrust_removal
    
methods (Static)
    function dataOut = mainFunction(dataStruct)
        propOff=sortrows(dataStruct.propoff,[19 6]);    %read data and order for velocity and engine setting
        beta0=sortrows(dataStruct.beta0,[19 24 6]);
        beta5=sortrows(dataStruct.beta5,[19 24 6]);
        beta10=sortrows(dataStruct.beta10, [19 24 6]);
        beta0(table2array(beta0(:,28))<2,:)=[];  % remove measurements where propeller was not at right J
      
        % Model Off
        modelOff=readtable('modelOffData.xlsx','VariableNamingRule','preserve');    % read model off data
        aoaEffectF=table2array(modelOff(8,2:5))-table2array(modelOff(6,2:5)); % effect of 2 deg aoa on forces
        aosEffect=modelOff{[1,5,7,9,11,13,15,17,21],11:14}; % forces at -10, -6, -4, -2, 0, 2, 4, 6, 10 for aos
        
        % Prop Off
        propOff20=table2array(propOff(1:5,{'AoS','FX','FY','FZ'}));
        pOneg=flip(propOff20(2:5,:));   % mirror to get negative sideslip values
        pOneg=pOneg.*[-1,1,-1,1];       % flip sign AoS and Fy
        propOff20=cat(1,pOneg, propOff20); % array containing the prop off forces v=20
        propOff20C=propOff20-aoaEffectF*0.5*1.225*0.2172*20*20; % FX, FY, FZ corrected for aoa 2 deg
        propOff20C=propOff20C-aosEffect.*[0,1,1,1]*0.5*1.225*20*20*0.2172; % FX, FY, FZ corrected for aoa and aos
        
        propOff40=table2array(propOff(6:10,{'AoS','FX','FY','FZ'}));
        pOneg=flip(propOff40(2:5,:));
        pOneg=pOneg.*[-1,1,-1,1];
        propOff40=cat(1,pOneg, propOff40); % array containing the prop off forces v=40
        propOff40C=propOff40-aoaEffectF*0.5*1.225*0.2172*40*40; % FX, FY, FZ corrected for aoa 2 deg
        propOff40C=propOff40C-aosEffect.*[0,1,1,1]*0.5*1.225*40*40*0.2172; % FX, FY, FZ corrected for aoa and aos
        
        %% plots showing correction effects
%         subplot(2,1,1)
%         plot(propOff20(:,1),propOff20(:,2:4))
%         hold on
%         plot(propOff20C(:,1),propOff20C(:,2:4),'-o')
%         legend('Fx','Fy','Fz','Fx corrected','Fy corrected','Fz corrected')
%         title('v=20')
%         subplot(2,1,2)
%         plot(propOff40(:,1),propOff40(:,2:4))
%         hold on
%         plot(propOff40C(:,1),propOff40C(:,2:4),'-o')      
%         legend('Fx','Fy','Fz','Fx corrected','Fy corrected','Fz corrected')
%         title('v=40')
%         sgtitle('Prop off forces, corrected')

        %% implement propoff data
        order=5;
        fcor20x=polyfit(propOff20C(:,1),propOff20C(:,2),order); % make fit for forces
        fcor20y=polyfit(propOff20C(:,1),propOff20C(:,3),order);
        fcor20z=polyfit(propOff20C(:,1),propOff20C(:,4),order);
        
        fcor40x=polyfit(propOff40C(:,1),propOff40C(:,2),order);
        fcor40y=polyfit(propOff40C(:,1),propOff40C(:,3),order);
        fcor40z=polyfit(propOff40C(:,1),propOff40C(:,4),order);
        
        %% select the correct beta0 values
        beta020=table2array(sortrows(beta0(1:9,:),6)); 
        beta020=beta020(:,[6,30:32]);    % aos, FX, FY, FZ
        beta020b=table2array(sortrows(beta0(10:19,:),6));
        beta020b=beta020b(:,[6,30:32]);    % aos, FX, FY, FZ
        beta040=table2array(sortrows(beta0(20:29,:),6)); 
        beta040=beta040(:,[6,30:32]);   % aos, FX, FY, FZ
        beta040b=table2array(sortrows(beta0(30:38,:),6));
        beta040b=beta040b(:,[6,30:32]);    % aos, FX, FY, FZ
        
        %% Remove model off data from measurement forces
%         make fit for aoseffect
%         subtract aoa from all
%         fitProp20=polyfit(
        beta020m=beta020-aoaEffectF*0.5*1.225*0.2172*20*20
        beta020bm=beta020b-aoaEffectF*0.5*1.225*0.2172*20*20;
        beta040m=beta040-aoaEffectF*0.5*1.225*0.2172*40*40;
        beta040bm=beta040b-aoaEffectF*0.5*1.225*0.2172*40*40;
        
        aosEffect
        AoSFitX=polyfit(aosEffect(:,1),aosEffect(:,2),8);
        AoSFitY=polyfit(aosEffect(:,1),aosEffect(:,3),8);
        AoSFitZ=polyfit(aosEffect(:,1),aosEffect(:,4),8);
        
        beta020x=polyval(AoSFitX,beta020(:,1))
        beta020y=polyval(AoSFitY,beta020(:,1));
        beta020z=polyval(AoSFitZ,beta020(:,1));
        corMO020=cat(2, zeros(9,1), beta020x, beta020y, beta020z);
        beta020MO=beta020-corMO020;
        
        plot(beta020(:,1),beta020(:,2))
        hold on
        plot(beta020MO(:,1),beta020MO(:,2),'x')
       
        
        %% compute forces due to propellers
        b020cx=polyval(fcor20x,beta020(:,1));    %model off corrections in x, y and z directions
        b020cy=polyval(fcor20y,beta020(:,1));
        b020cz=polyval(fcor20z,beta020(:,1));
        cor020=cat(2, zeros(9,1), b020cx, b020cy, b020cz); % prop off forces corrected with model off
        b020c=beta020-cor020; % values due to thrust
        
        b020bcx=polyval(fcor20x,beta020b(:,1));    %model off corrections in x, y and z directions
        b020bcy=polyval(fcor20y,beta020b(:,1));
        b020bcz=polyval(fcor20z,beta020b(:,1));
        cor020b=cat(2, zeros(10,1), b020bcx, b020bcy, b020bcz);
        b020bc=beta020b-cor020b; % values due to thrust
        
        b040cx=polyval(fcor40x,beta040(:,1));    %model off corrections in x, y and z directions
        b040cy=polyval(fcor40y,beta040(:,1));
        b040cz=polyval(fcor40z,beta040(:,1));
        cor040=cat(2, zeros(10,1), b040cx, b040cy, b040cz);
        b040c=beta040-cor040; % values due to thrust
        
        b040bcx=polyval(fcor40x,beta040b(:,1));    %model off corrections in x, y and z directions
        b040bcy=polyval(fcor40y,beta040b(:,1));
        b040bcz=polyval(fcor40z,beta040b(:,1));
        cor040b=cat(2, zeros(9,1), b040bcx, b040bcy, b040bcz);
        b040bc=beta040b-cor040b; % values due to thrust
        
%         figure(2)
%         title('Corrected data')
%         subplot(2,2,1)
%         plot(beta020(:,1),beta020(:,2:4))
%         hold on
%         plot(beta020(:,1),b020c(:,2:4),'-x')
%         legend('x','y','z','xc','yc','zc')
%         title('v=20')
%         subplot(2,2,2)
%         plot(beta020b(:,1),beta020b(:,2:4))
%         hold on
%         plot(beta020b(:,1),b020bc(:,2:4),'-x')
%         legend('x','y','z','xc','yc','zc')
%         title('v=20, OEI')
%         subplot(2,2,3)
%         plot(beta040(:,1),beta040(:,2:4))
%         hold on
%         plot(beta040(:,1),b040c(:,2:4),'-x')
%         legend('x','y','z','xc','yc','zc')
%         title('v=40')
%         subplot(2,2,4)
%         plot(beta040b(:,1),beta040b(:,2:4))
%         hold on
%         plot(beta040b(:,1),b040bc(:,2:4),'-x')
%         legend('x','y','z','xc','yc','zc')
%         title('v=40, OEI')
%         sgtitle('Forces due to Thrust')
%         
%         figure(3)
%         subplot(2,2,1)
%         plot(beta020(:,1),cor020(:,2:4))
%         title('v=20')
%         legend('x','y','z')
%         subplot(2,2,2)
%         plot(beta020b(:,1),cor020b(:,2:4))
%         title('v=20, OEI')
%         legend('x','y','z')
%         subplot(2,2,3)
%         plot(beta040(:,1),cor040(:,2:4))
%         title('v=40')
%         legend('x','y','z')
%         xlim([-10, 10])
%         subplot(2,2,4)
%         plot(beta040b(:,1),cor040b(:,2:4))
%         title('v=20, OEI')
%         legend('x','y','z')
%         sgtitle('Model Off forces')

%         figure(4)
%         title('Thrust Forces')
%         subplot(2,2,1)
%         plot(beta020(:,1),b020c(:,2:4),'-x')
%         legend('x','y','z')
%         title('v=20')
%         subplot(2,2,2)
%         plot(beta020b(:,1),b020bc(:,2:4),'-x')
%         legend('x','y','z')
%         title('v=20, OEI')
%         subplot(2,2,3)
%         plot(beta040(:,1),b040c(:,2:4),'-x')
%         legend('x','y','z')
%         title('v=40')
%         subplot(2,2,4)
%         plot(beta040b(:,1),b040bc(:,2:4),'-x')
%         legend('x','y','z')
%         title('v=40, OEI')
%         sgtitle('Forces due to Thrust')
       
%         b0=sortrows(x.beta0,[19 24 6])
%         c=b0(:,[6,19,24,ll30:32])
%         c=c(1:9,:)
%         c=sortrows(c,1)


%         urat=1+0.6*2*0.2032/0.576*(TC*sqrt((sqrt(1+TC)+1)/(2*sqrt(1+TC))));
%         dcl=CLTC*(1-urat);
%         cdi=dcl/pi/3.87;

%         sigmaEff=4*6/3/pi*(0.01427/0.2032);
%         B0=45 % pitch at r/R=0.75 (is given for r/R=0.7)
%         J=u/nD
%         dTda = 4.25*sigmaEff/(1+2*sigmaEff)*sin(bo+3)*(pi*J^2/8+3*sqrt(pi*J^2/8*CT)/(8*sqrt(\pi*J^2/8+2/3*CT)))
        
        
        dataOut=b040bc;
    end
  %%
%     function thrustOut = thrustCalc
% 
%         % Insert thrust force
%         % Use empirical relation for thrust under sideslip
%         % Take into account AoS for Fy
%         % Take into account AoA for Fx and Fy
%         
%         
% 
%         thrust=2;
%         uRatio=1+0.6*2*0.2032/0.576*(TC*sqrt((sqrt(1+TC)+1)/(2*sqrt(1+TC))));
%         dcl=CLTC*(1-uRatio);
%         cdi=dcl/pi/3.87;
%         dragForce=0.5*1.225*
%         
%         % If both engines are on apply twice
%         % can check if J2!=0
%         fx=fx+dragForce*cos(AoA)
%         fy=fy+dragForce*sin(AoS)
%         fz=fz+dragForce*sin(AoA)
%         thrustOut=
%   end
end
end

% xloc=1:1:5
% x=load2Struct('OUTPUT.xls').i0
% y=sortrows(x.propoff,[19 6])
% dat=table2array(y(:,'FX'))
% dv20=dat(1:5);
% dv40=dat(6:10);
% 
% f=polyfit(x,dv20,2)
% 
% plot(dv20,'-o','LineStyle','none')
% hold on
% plot(x,polyval(f,x))