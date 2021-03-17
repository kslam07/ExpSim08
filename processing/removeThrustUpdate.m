classdef removeThrustUpdate
    
methods (Static)
    function dataOut = mainFunction(dataStruct)
        dataTable = dataStruct.("i0");
        % x=load2Struct('OUTPUT.xls','DATA/TailOffData.xlsx').i0
        %% Get initial data set
        propOff=sortrows(dataTable.propoff,[19 6]);    %read data and order for velocity and engine setting
        beta0=sortrows(dataTable.beta0,[19 24 6]);
        beta5=sortrows(dataTable.beta5,[19 24 6]);
        beta10=sortrows(dataTable.beta10, [19 24 6]);
        beta0(table2array(beta0(:,28))<2,:)=[];  % remove measurements where propeller was not at right J
        
        %% Get relevant values
        beta020=sortrows(beta0(1:9,:),'AoS');
        beta020b=sortrows(beta0(10:19,:),'AoS');
        beta040=sortrows(beta0(20:29,:),'AoS');
        beta040b=sortrows(beta0(30:38,:),'AoS');
        
        beta520=sortrows(beta5(1:9,:),'AoS');
        beta520b=sortrows(beta5(10:18,:),'AoS');
        beta540=sortrows(beta5(19:27,:),'AoS');
        beta540b=sortrows(beta5(28:36,:),'AoS');
        
        beta1020=sortrows(beta10(1:9,:),'AoS');
        beta1020b=sortrows(beta10(10:18,:),'AoS');
        beta1040=sortrows(beta10(19:28,:),'AoS');
        beta1040b=sortrows(beta10(29:37,:),'AoS');
        
     
        %% Remove prop off data from measurements
%         propOff20=table2array(propOff(1:5,{'AoS','V','iM2','FX','FY','FZ'}))
        propOff20=sortrows(propOff(1:5,:),'AoS');
        propOffneg=flip(propOff20);
        lst={'AoS', 'FY', 'MY', 'CFY', 'CY', 'CYaw','CMy'};
        for i=1:length(lst)
            propOffneg.(cell2mat(lst(i)))=propOffneg.(cell2mat(lst(i)))*-1;
        end
        propOff20=cat(1,propOffneg(1:4,:),propOff20);
 
        propOff40=sortrows(propOff(1:5,:),'AoS');
        propOffneg=flip(propOff40);
        lst={'AoS', 'FY', 'MY', 'CFY', 'CY', 'CYaw','CMy'};
        for i=1:length(lst)
            propOffneg.(cell2mat(lst(i)))=propOffneg.(cell2mat(lst(i)))*-1;
        end
        propOff40=cat(1,propOffneg(1:4,:),propOff40);
        
        order=8;
        fit20CN=polyfit(propOff20.AoS,propOff20.CN,order); % make fit for forces
        fit20CT=polyfit(propOff20.AoS,propOff20.CT,order);
        fit20CY=polyfit(propOff20.AoS,propOff20.CY,order);
        fit20CL=polyfit(propOff20.AoS,propOff20.CL,order);
        fit20CD=polyfit(propOff20.AoS,propOff20.CD,order);
        
        fit40CN=polyfit(propOff20.AoS,propOff40.CN,order); % make fit for forces
        fit40CT=polyfit(propOff20.AoS,propOff40.CT,order);
        fit40CY=polyfit(propOff20.AoS,propOff40.CY,order);
        fit40CL=polyfit(propOff20.AoS,propOff40.CL,order);
        fit40CD=polyfit(propOff20.AoS,propOff40.CD,order);

        % Make copies of structures
        beta020PO=beta020;
        beta020bPO=beta020b;
        beta040PO=beta040;
        beta040bPO=beta040b;
        
        beta520PO=beta520;
        beta520bPO=beta520b;
        beta540PO=beta540;
        beta540bPO=beta540b;
        
        beta1020PO=beta1020;
        beta1020bPO=beta1020b;
        beta1040PO=beta1040;
        beta1040bPO=beta1040b;
        
        % Compute difference between prop on and prop off
        beta020PO.CN=beta020PO.CN-polyval(fit20CN,beta020PO.AoS);
        beta020PO.CT=beta020PO.CT-polyval(fit20CT,beta020PO.AoS);
        beta020PO.CY=beta020PO.CY-polyval(fit20CY,beta020PO.AoS);
        beta020PO.CL=beta020PO.CL-polyval(fit20CL,beta020PO.AoS);
        beta020PO.CD=beta020PO.CD-polyval(fit20CD,beta020PO.AoS);
        
        beta020bPO.CN=beta020bPO.CN-polyval(fit20CN,beta020bPO.AoS);
        beta020bPO.CT=beta020bPO.CT-polyval(fit20CT,beta020bPO.AoS);
        beta020bPO.CY=beta020bPO.CY-polyval(fit20CY,beta020bPO.AoS);
        beta020bPO.CL=beta020bPO.CL-polyval(fit20CL,beta020bPO.AoS);
        beta020bPO.CD=beta020bPO.CD-polyval(fit20CD,beta020bPO.AoS);        

        beta040PO.CN=beta040PO.CN-polyval(fit40CN,beta040PO.AoS);
        beta040PO.CT=beta040PO.CT-polyval(fit40CT,beta040PO.AoS);
        beta040PO.CY=beta040PO.CY-polyval(fit40CY,beta040PO.AoS);
        beta040PO.CL=beta040PO.CL-polyval(fit40CL,beta040PO.AoS);
        beta040PO.CD=beta040PO.CD-polyval(fit40CD,beta040PO.AoS);        
        
        beta040bPO.CN=beta040bPO.CN-polyval(fit40CN,beta040bPO.CN);
        beta040bPO.CT=beta040bPO.CT-polyval(fit40CT,beta040bPO.CN);
        beta040bPO.CY=beta040bPO.CY-polyval(fit40CY,beta040bPO.CN);
        beta040bPO.CL=beta040bPO.CL-polyval(fit40CL,beta040bPO.CN);
        beta040bPO.CD=beta040bPO.CD-polyval(fit40CD,beta040bPO.CN);           
        
        %for delta=5
        beta520PO.CN=beta520PO.CN-polyval(fit20CN,beta520PO.AoS);
        beta520PO.CT=beta520PO.CT-polyval(fit20CT,beta520PO.AoS);
        beta520PO.CY=beta520PO.CY-polyval(fit20CY,beta520PO.AoS);
        beta520PO.CL=beta520PO.CL-polyval(fit20CL,beta520PO.AoS);
        beta520PO.CD=beta520PO.CD-polyval(fit20CD,beta520PO.AoS);
        
        beta520bPO.CN=beta520bPO.CN-polyval(fit20CN,beta520bPO.AoS);
        beta520bPO.CT=beta520bPO.CT-polyval(fit20CT,beta520bPO.AoS);
        beta520bPO.CY=beta520bPO.CY-polyval(fit20CY,beta520bPO.AoS);
        beta520bPO.CL=beta520bPO.CL-polyval(fit20CL,beta520bPO.AoS);
        beta520bPO.CD=beta520bPO.CD-polyval(fit20CD,beta520bPO.AoS);        

        beta540PO.CN=beta540PO.CN-polyval(fit40CN,beta540PO.AoS);
        beta540PO.CT=beta540PO.CT-polyval(fit40CT,beta540PO.AoS);
        beta540PO.CY=beta540PO.CY-polyval(fit40CY,beta540PO.AoS);
        beta540PO.CL=beta540PO.CL-polyval(fit40CL,beta540PO.AoS);
        beta540PO.CD=beta540PO.CD-polyval(fit40CD,beta540PO.AoS);        
       
        beta540bPO.CN=beta540bPO.CN-polyval(fit40CN,beta540bPO.CN);
        beta540bPO.CT=beta540bPO.CT-polyval(fit40CT,beta540bPO.CN);
        beta540bPO.CY=beta540bPO.CY-polyval(fit40CY,beta540bPO.CN);
        beta540bPO.CL=beta540bPO.CL-polyval(fit40CL,beta540bPO.CN);
        beta540bPO.CD=beta540bPO.CD-polyval(fit40CD,beta540bPO.CN);    
        
        % For delta=10
        beta1020PO.CN=beta1020PO.CN-polyval(fit20CN,beta1020PO.AoS);
        beta1020PO.CT=beta1020PO.CT-polyval(fit20CT,beta1020PO.AoS);
        beta1020PO.CY=beta1020PO.CY-polyval(fit20CY,beta1020PO.AoS);
        beta1020PO.CL=beta1020PO.CL-polyval(fit20CL,beta1020PO.AoS);
        beta1020PO.CD=beta1020PO.CD-polyval(fit20CD,beta1020PO.AoS);
        
        beta1020bPO.CN=beta1020bPO.CN-polyval(fit20CN,beta1020bPO.AoS);
        beta1020bPO.CT=beta1020bPO.CT-polyval(fit20CT,beta1020bPO.AoS);
        beta1020bPO.CY=beta1020bPO.CY-polyval(fit20CY,beta1020bPO.AoS);
        beta1020bPO.CL=beta1020bPO.CL-polyval(fit20CL,beta1020bPO.AoS);
        beta1020bPO.CD=beta1020bPO.CD-polyval(fit20CD,beta1020bPO.AoS);        

        beta1040PO.CN=beta1040PO.CN-polyval(fit40CN,beta1040PO.AoS);
        beta1040PO.CT=beta1040PO.CT-polyval(fit40CT,beta1040PO.AoS);
        beta1040PO.CY=beta1040PO.CY-polyval(fit40CY,beta1040PO.AoS);
        beta1040PO.CL=beta1040PO.CL-polyval(fit40CL,beta1040PO.AoS);
        beta1040PO.CD=beta1040PO.CD-polyval(fit40CD,beta1040PO.AoS);        
        
        beta1040bPO.CN=beta1040bPO.CN-polyval(fit40CN,beta1040bPO.CN);
        beta1040bPO.CT=beta1040bPO.CT-polyval(fit40CT,beta1040bPO.CN);
        beta1040bPO.CY=beta1040bPO.CY-polyval(fit40CY,beta1040bPO.CN);
        beta1040bPO.CL=beta1040bPO.CL-polyval(fit40CL,beta1040bPO.CN);
        beta1040bPO.CD=beta1040bPO.CD-polyval(fit40CD,beta1040bPO.CN);  
        
%         beta040b
%         removeModelOff(beta040)
      
        
%         [y; num2cell(x)]
% 
%         x=mean(t{2:3,:},1)

        %% Compute thrust       
%         test=beta040b;
%         test.AoS
%         abs(test.AoS)
%         idx=abs(test.AoS)==min(abs(test.AoS))
%         zeroAoS=test{idx,:} % data for zero sideslip thrust effect

%         data=beta020bp; % data thrust effect
%         idx=abs(data(:,1))==min(abs(data(:,1))); % get index for zero sideslip
%         zeroAoS=data(idx,:); % data for zero sideslip thrust effect
%         
%         dataMO=removeModelOff(beta020b); % data with strut effect removed
%         zeroAoSMO=dataMO(idx,:);
%         
%         dataPO=removeModelOff(propOff20);
%         idx1=abs(data(:,1))==min(abs(data(:,1)));
%         zeroAoSPO=dataPO(idx1,:);
%         
%         CLm=zeroAoSMO(6)./(0.5*1.225*zeroAoSMO(2).^2*0.2172); % CL for sideslip 0
%         iter=0;
%         zeroAoS
%         thrustIn=-1*(-zeroAoS(6)*sind(2)+zeroAoS(4)*cosd(2))
%         zeroAoS(6);
%         zeroAoS(2);
% %         thrustIn=-data(4)
%         thrustOut=thrustIter([thrustIn, dataMO(5,2), dataMO(5,6),zeroAoSPO(6)/(0.5*1.225*zeroAoS(2)^2*0.2172)])
%         thrustSideslip([thrustOut zeroAoS(2) 10])
%         CT=thrustOut/1.225/(zeroAoSMO(2)/2.1/0.2032)^2/0.2032^4/2;
%         thrustCorr([thrustOut zeroAoS(2) zeroAoSMO(6)/(0.5*1.225*zeroAoS(2)^2*0.2172)])
%         
        

        dataStruct.i1.beta0=sortrows([beta020; beta020b; beta040; beta040b],1);
        dataStruct.i1.beta5=sortrows([beta520; beta520b; beta540; beta540b],1);
        dataStruct.i1.beta10=sortrows([beta1020; beta1020b; beta1040; beta1040b],1);

        dataOut=dataStruct;
%         dataOut=[]
        
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
    function data=removeModelOff(data)
        modelOff=readtable('modelOffData.xlsx','VariableNamingRule','preserve');    % read model off data
        AoAEffect=table2array(modelOff(8,2:8))-table2array(modelOff(6,2:8)); % effect of 2 deg aoa on forces
        AoSEffect=modelOff{[1,5,7,9,11,13,15,17,21],11:17}; % forces at -10, -6, -4, -2, 0, 2, 4, 6, 10 for aos
        
        AoSFitCD=polyfit(AoSEffect(:,1),AoSEffect(:,2),8); % makes fit of forces in aero frame
        AoSFitCy=polyfit(AoSEffect(:,1),AoSEffect(:,3),8);
        AoSFitCL=polyfit(AoSEffect(:,1),AoSEffect(:,4),8);
        AoSFitCMroll=polyfit(AoSEffect(:,1),AoSEffect(:,5),8);
        AoSFitCMpitch=polyfit(AoSEffect(:,1),AoSEffect(:,6),8);
        AoSFitCMyaw=polyfit(AoSEffect(:,1),AoSEffect(:,7),8);
        
        CD=polyval(AoSFitCD,data.AoS)+AoAEffect(:,2);
        Cy=polyval(AoSFitCy,data.AoS)+AoAEffect(:,3);
        CL=polyval(AoSFitCL,data.AoS)+AoAEffect(:,4);
        CMroll=polyval(AoSFitCMroll,data.AoS)+AoAEffect(:,5);
        CMpitch=polyval(AoSFitCMpitch,data.AoS)+AoAEffect(:,6);
        CMyaw=polyval(AoSFitCMyaw,data.AoS)+AoAEffect(:,7);
        
%         plot(data.AoS,data.CD)
%         hold on
        
        data.CD=data.CD-CD;
        data.CYaw=data.CYaw-Cy;
        data.CL=data.CL-CL;
        data.CMr=data.CMr-CMroll;
        data.CMp=data.CMp-CMpitch;
        data.CMp25c=data.CMp25c-CMpitch;
        data.CMy=data.CMy-CMyaw;
                

        for idx=1:length(data.AoS)
            dcm=angle2dcm(deg2rad(data.AoS(idx)), deg2rad(data.AoA(idx)), 0);
            aero=[-data.CD(idx); data.CYaw(idx); -data.CL(idx)];
            model=dcm*aero.*[-1; 1; -1];
            data.CT(idx)=model(1);
            data.CY(idx)=model(2);
            data.CN(idx)=model(3);
        end
%         plot(data.AoS,data.CD)
    end 
end
end    
end