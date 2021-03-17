classdef removeThrustUpdate
    
methods (Static)
    function dataOut = mainFunction(dataStruct)
        dataTable = dataStruct.("i0");
        % x=load2Struct('OUTPUT.xls','DATA/TailOffData.xlsx').i0
        %% Get initial data set
        propOff=sortrows(dataTable.propoff,[19 6]);    %read data and order for velocity and engine setting
        rud0=sortrows(dataTable.rud0,[19 24 6]);
        rud5=sortrows(dataTable.rud5,[19 24 6]);
        rud10=sortrows(dataTable.rud10, [19 24 6]);
        rud0(table2array(rud0(:,28))<2,:)=[];  % remove measurements where propeller was not at right J
        
        %% Get relevant values
        rud020=sortrows(rud0(1:9,:),'AoS');
        rud020b=sortrows(rud0(10:19,:),'AoS');
        rud040=sortrows(rud0(20:29,:),'AoS');
        rud040b=sortrows(rud0(30:38,:),'AoS');
        
        rud520=sortrows(rud5(1:9,:),'AoS');
        rud520b=sortrows(rud5(10:18,:),'AoS');
        rud540=sortrows(rud5(19:27,:),'AoS');
        rud540b=sortrows(rud5(28:36,:),'AoS');
        
        rud1020=sortrows(rud10(1:9,:),'AoS');
        rud1020b=sortrows(rud10(10:18,:),'AoS');
        rud1040=sortrows(rud10(19:28,:),'AoS');
        rud1040b=sortrows(rud10(29:37,:),'AoS');
        
     
        %% Remove prop off data from measurements
%         propOff20=table2array(propOff(1:5,{'AoS','V','iM2','FX','FY','FZ'}))
        propOff20=sortrows(propOff(1:5,:),'AoS');
        propOffneg=flip(propOff20);
        lst={'AoS', 'FY', 'MY', 'CFY', 'CY', 'CYaw','CMy'};
        for i=1:length(lst)
            propOffneg.(cell2mat(lst(i)))=propOffneg.(cell2mat(lst(i)))*-1;
        end
        propOff20=cat(1,propOffneg(1:4,:),propOff20);
 
        propOff40=sortrows(propOff(6:10,:),'AoS');
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
        rud020PO=rud020;
        rud020bPO=rud020b;
        rud040PO=rud040;
        rud040bPO=rud040b;
        
        rud520PO=rud520;
        rud520bPO=rud520b;
        rud540PO=rud540;
        rud540bPO=rud540b;
        
        rud1020PO=rud1020;
        rud1020bPO=rud1020b;
        rud1040PO=rud1040;
        rud1040bPO=rud1040b;
        
        % Compute difference between prop on and prop off
        rud020PO.CN=rud020PO.CN-polyval(fit20CN,rud020PO.AoS);
        rud020PO.CT=rud020PO.CT-polyval(fit20CT,rud020PO.AoS);
        rud020PO.CY=rud020PO.CY-polyval(fit20CY,rud020PO.AoS);
        rud020PO.CL=rud020PO.CL-polyval(fit20CL,rud020PO.AoS);
        rud020PO.CD=rud020PO.CD-polyval(fit20CD,rud020PO.AoS);
        
        rud020bPO.CN=rud020bPO.CN-polyval(fit20CN,rud020bPO.AoS);
        rud020bPO.CT=rud020bPO.CT-polyval(fit20CT,rud020bPO.AoS);
        rud020bPO.CY=rud020bPO.CY-polyval(fit20CY,rud020bPO.AoS);
        rud020bPO.CL=rud020bPO.CL-polyval(fit20CL,rud020bPO.AoS);
        rud020bPO.CD=rud020bPO.CD-polyval(fit20CD,rud020bPO.AoS);        

        rud040PO.CN=rud040PO.CN-polyval(fit40CN,rud040PO.AoS);
        rud040PO.CT=rud040PO.CT-polyval(fit40CT,rud040PO.AoS);
        rud040PO.CY=rud040PO.CY-polyval(fit40CY,rud040PO.AoS);
        rud040PO.CL=rud040PO.CL-polyval(fit40CL,rud040PO.AoS);
        rud040PO.CD=rud040PO.CD-polyval(fit40CD,rud040PO.AoS);        
        
        rud040bPO.CN=rud040bPO.CN-polyval(fit40CN,rud040bPO.AoS);
        rud040bPO.CT=rud040bPO.CT-polyval(fit40CT,rud040bPO.AoS);
        rud040bPO.CY=rud040bPO.CY-polyval(fit40CY,rud040bPO.AoS);
        rud040bPO.CL=rud040bPO.CL-polyval(fit40CL,rud040bPO.AoS);
        rud040bPO.CD=rud040bPO.CD-polyval(fit40CD,rud040bPO.AoS);           
        
        %for delta=5
        rud520PO.CN=rud520PO.CN-polyval(fit20CN,rud520PO.AoS);
        rud520PO.CT=rud520PO.CT-polyval(fit20CT,rud520PO.AoS);
        rud520PO.CY=rud520PO.CY-polyval(fit20CY,rud520PO.AoS);
        rud520PO.CL=rud520PO.CL-polyval(fit20CL,rud520PO.AoS);
        rud520PO.CD=rud520PO.CD-polyval(fit20CD,rud520PO.AoS);
        
        rud520bPO.CN=rud520bPO.CN-polyval(fit20CN,rud520bPO.AoS);
        rud520bPO.CT=rud520bPO.CT-polyval(fit20CT,rud520bPO.AoS);
        rud520bPO.CY=rud520bPO.CY-polyval(fit20CY,rud520bPO.AoS);
        rud520bPO.CL=rud520bPO.CL-polyval(fit20CL,rud520bPO.AoS);
        rud520bPO.CD=rud520bPO.CD-polyval(fit20CD,rud520bPO.AoS);        

        rud540PO.CN=rud540PO.CN-polyval(fit40CN,rud540PO.AoS);
        rud540PO.CT=rud540PO.CT-polyval(fit40CT,rud540PO.AoS);
        rud540PO.CY=rud540PO.CY-polyval(fit40CY,rud540PO.AoS);
        rud540PO.CL=rud540PO.CL-polyval(fit40CL,rud540PO.AoS);
        rud540PO.CD=rud540PO.CD-polyval(fit40CD,rud540PO.AoS);        
       
        rud540bPO.CN=rud540bPO.CN-polyval(fit40CN,rud540bPO.AoS);
        rud540bPO.CT=rud540bPO.CT-polyval(fit40CT,rud540bPO.AoS);
        rud540bPO.CY=rud540bPO.CY-polyval(fit40CY,rud540bPO.AoS);
        rud540bPO.CL=rud540bPO.CL-polyval(fit40CL,rud540bPO.AoS);
        rud540bPO.CD=rud540bPO.CD-polyval(fit40CD,rud540bPO.AoS);    
        
        % For delta=10
        rud1020PO.CN=rud1020PO.CN-polyval(fit20CN,rud1020PO.AoS);
        rud1020PO.CT=rud1020PO.CT-polyval(fit20CT,rud1020PO.AoS);
        rud1020PO.CY=rud1020PO.CY-polyval(fit20CY,rud1020PO.AoS);
        rud1020PO.CL=rud1020PO.CL-polyval(fit20CL,rud1020PO.AoS);
        rud1020PO.CD=rud1020PO.CD-polyval(fit20CD,rud1020PO.AoS);
        
        rud1020bPO.CN=rud1020bPO.CN-polyval(fit20CN,rud1020bPO.AoS);
        rud1020bPO.CT=rud1020bPO.CT-polyval(fit20CT,rud1020bPO.AoS);
        rud1020bPO.CY=rud1020bPO.CY-polyval(fit20CY,rud1020bPO.AoS);
        rud1020bPO.CL=rud1020bPO.CL-polyval(fit20CL,rud1020bPO.AoS);
        rud1020bPO.CD=rud1020bPO.CD-polyval(fit20CD,rud1020bPO.AoS);        

        rud1040PO.CN=rud1040PO.CN-polyval(fit40CN,rud1040PO.AoS);
        rud1040PO.CT=rud1040PO.CT-polyval(fit40CT,rud1040PO.AoS);
        rud1040PO.CY=rud1040PO.CY-polyval(fit40CY,rud1040PO.AoS);
        rud1040PO.CL=rud1040PO.CL-polyval(fit40CL,rud1040PO.AoS);
        rud1040PO.CD=rud1040PO.CD-polyval(fit40CD,rud1040PO.AoS);        
        
        rud1040bPO.CN=rud1040bPO.CN-polyval(fit40CN,rud1040bPO.AoS);
        rud1040bPO.CT=rud1040bPO.CT-polyval(fit40CT,rud1040bPO.AoS);
        rud1040bPO.CY=rud1040bPO.CY-polyval(fit40CY,rud1040bPO.AoS);
        rud1040bPO.CL=rud1040bPO.CL-polyval(fit40CL,rud1040bPO.AoS);
        rud1040bPO.CD=rud1040bPO.CD-polyval(fit40CD,rud1040bPO.AoS);  
        
%         rud040b
%         removeModelOff(rud040)
      
        
%         [y; num2cell(x)]
% 
%         x=mean(t{2:3,:},1)

        %% Compute thrust       
        rud020b;
        propOff20;
        rud020bPO;
        test=rud040bPO;
        test1=rud040b;
        thrustIn=test;
        thrustIn.dPb=test1.CL;
        thrusttest(thrustIn);
        
        t020b=rud020PO.CT.*0.5*1.225.*rud020PO.V.^2*0.2172;
        propOff40.CT
        propOff40.AoS
        rud040b.CT
        rud040bPO.CT
%         test=rud020bPO;
%         test1=rud020b;
%         for idx=1:1:2
%             uRatio=1+0.6*2*0.2032/0.576*(test.CT./2.*sqrt((sqrt(1+test.CT./2)+1)./(2*sqrt(1+test.CT./2))));
%             dcl1=test1.CL.*(1-uRatio);
%             cdi1=dcl1./pi/3.87;
%             test.CT=test.CT-cdi1;
%             test1.CL   =  (test.CN.*cosd(test.AoA)-test.CT.*sind(test.AoA)); % lift
%             test1.CD   =  (test.CN.*sind(test.AoA)+test.CT.*cosd(test.AoA)).*cosd(test.AoS)+test.CY.*sind(test.AoS); % drag
%             test1.CYaw = -(test.CN.*sind(test.AoA)+test.CT.*cosd(test.AoA)).*sind(test.AoS)+test.CY.*cosd(test.AoS); % sideforce
%         end
%         test.CT
        thrust=test.CT*0.5*40*40*1.225*dataStruct.sRef/2;
        TC=thrust./1.225./test.rpsM1.^2./dataStruct.Dprop^4;
        function testOut=thrusttest(data)
            data;
            
        end
%         test.AoS
%         abs(test.AoS)
%         idx=abs(test.AoS)==min(abs(test.AoS))
%         zeroAoS=test{idx,:} % data for zero sideslip thrust effect

%         data=rud020bp; % data thrust effect
%         idx=abs(data(:,1))==min(abs(data(:,1))); % get index for zero sideslip
%         zeroAoS=data(idx,:); % data for zero sideslip thrust effect
%         
%         dataMO=removeModelOff(rud020b); % data with strut effect removed
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
        

        dataStruct.i1.rud0=sortrows([rud020; rud020b; rud040; rud040b],1);
        dataStruct.i1.rud5=sortrows([rud520; rud520b; rud540; rud540b],1);
        dataStruct.i1.rud10=sortrows([rud1020; rud1020b; rud1040; rud1040b],1);

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
    function thrustSideOut=thrustSideslip(data)    % T, V, rud
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