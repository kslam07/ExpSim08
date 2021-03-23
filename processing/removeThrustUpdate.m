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
        jVar=rud0(table2array(rud0(:,28))<2,:);
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
        
     
        order=3;
        fit20CN=polyfit(propOff20.AoS,propOff20.CN,order); % make fit for forces
        fit20CT=polyfit(propOff20.AoS,propOff20.CT,order);
        fit20CY=polyfit(propOff20.AoS,propOff20.CY,order);
        fit20CL=polyfit(propOff20.AoS,propOff20.CL,order);
        fit20CD=polyfit(propOff20.AoS,propOff20.CD,order);
        
        
        fit40CN=polyfit(propOff40.AoS,propOff40.CN,order); % make fit for forces
        fit40CT=polyfit(propOff40.AoS,propOff40.CT,order);
        fit40CY=polyfit(propOff40.AoS,propOff40.CY,order);
        fit40CL=polyfit(propOff40.AoS,propOff40.CL,order);
        fit40CD=polyfit(propOff40.AoS,propOff40.CD,order);
        

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
        
        jVarPO=jVar;
        
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
        
%         subplot(1,2,1)
%         plot(propOff20.AoS,propOff20.CT)
%         hold on 
%         plot(rud1020b.AoS,rud1020b.CT)
%         plot(propOff20.AoS,polyval(fit20CT,propOff20.AoS))
%         title('v = 20')
%         xlabel('\beta')
%         ylabel('C_{Tref}')
%         legend('Prop Off', 'Prop On', 'Prop Off fit','Location','south')
%                
%         subplot(1,2,2)
%         plot(propOff40.AoS,propOff40.CT)
%         hold on 
%         plot(rud040b.AoS,rud040b.CT)
%         plot(propOff40.AoS,polyval(fit40CT,propOff40.AoS))
%         title('v = 40')
%         xlabel('\beta')
%         ylabel('C_{Tref}')
%         legend('Prop Off', 'Prop On', 'Prop Off fit','Location','south')
        
%         plot(rud020bPO.AoS,rud020bPO.CT)
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
        
        jVarPO.CN=jVarPO.CN-propOff40(5,:).CN*ones(2,1);
        jVarPO.CT=jVarPO.CT-propOff40(5,:).CT*ones(2,1);
        jVarPO.CY=jVarPO.CY-propOff40(5,:).CY*ones(2,1);
        jVarPO.CL=jVarPO.CL-propOff40(5,:).CL*ones(2,1);
        jVarPO.CD=jVarPO.CD-propOff40(5,:).CD*ones(2,1);

        
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
        data020.a=rud020bPO;                      % prop on - prop off
        data020.b=removeThrustUpdate.removeModelOff(rud020b);        % both prop on - model off
        data020.c=rud020b;                        % both prop on
        data020.d=rud020;                         % OEI
        
        data040.a=rud040bPO;
        data040.b=removeThrustUpdate.removeModelOff(rud040b);        
        data040.c=rud040b;
        data040.d=rud040;
        
        data520.a=rud520bPO;
        data520.b=removeThrustUpdate.removeModelOff(rud520b);        
        data520.c=rud520b;
        data520.d=rud520;
        
        data540.a=rud540bPO;
        data540.b=removeThrustUpdate.removeModelOff(rud540b); 
        data540.c=rud540b;
        data540.d=rud540;

        data1020.a=rud1020bPO;
        data1020.b=removeThrustUpdate.removeModelOff(rud1020b);        
        data1020.c=rud1020b;
        data1020.d=rud1020;
        
        data1040.a=rud1040bPO;
        data1040.b=removeThrustUpdate.removeModelOff(rud1040b);        
        data1040.c=rud1040b;
        data1040.d=rud1040;        
        
        datajVar.a=jVarPO;
        datajVar.b=removeThrustUpdate.removeModelOffjVar(jVar);
        datajVar.c=jVarPO;
        
        data020=thrustIter(data020);
        data040=thrustIter(data040);
        datajVar=thrustIterjVar(datajVar);
        data520=thrustIter(data520);
        data540=thrustIter(data540);
        data1020=thrustIter(data1020);
        data1040=thrustIter(data1040);        

%         plot(data040.a.CT)
%         hold on
%         rud040
%         data040=thrustIter(data020);
%         data040.d.AoS
%         unique(data040.d.AoS)
%         data040.d.dPb*2.1*2.1*pi/8
%         data040.c.dPb*2.1*2.1*pi/8
%         data040.c.dPb
%         plot(data040.a.CT)

       
%         data020.c=removeThrustUpdate.sideslipCorrection(data020.c);
%         data020.c=removeThrustUpdate.sideslipCorrection(data020.c);
%         data020.c=removeThrustUpdate.sideslipCorrection(data020.c);
%         data020.c=removeThrustUpdate.sideslipCorrection(data020.c);

        dataStruct.i1.rud0=sortrows([data020.d; data020.c; data040.d; data040.c; datajVar.c],1);
        dataStruct.i1.rud5=sortrows([data520.d; data520.c; data540.d; data540.c],1);
        dataStruct.i1.rud10=sortrows([data1020.d; data1020.c; data1040.d; data1040.c],1);
       
        dataOut=dataStruct;      
 
    %%
%         function output=SideslipCorr(data)
%             solid=4*
%             dCN/da=
      
    %%
        function thrustOut=thrustIter(data)
            
            % prop off - prop on; initial thrust estimate
            TEngine=-data.a.CT*0.5.*data.a.temp.*data.a.V.^2.*dataStruct.sRef/2; % force per engine
%             data.a.CT*dataStruct.sRef/pi*4/dataStruct.Dprop^2/2;
            TC=TEngine./(0.5*data.a.temp.*data.a.V.^2*pi/4*dataStruct.Dprop^2);  % TC for engine
            CT=TC.*data.a.J_M1.^2*pi/8; % CT for engine    
            TCi=TC;
%             res = 1;
            for idx=1:1:50
% %                 plot(data.c.AoS, TCi);
% %                 hold on
%                 % k=0.6 (constant found by Eckert)
%                 % qE/qinf; spanTail = 0.576 [m]
                uRatio=1+0.6*2*dataStruct.Dprop/0.576*...
                    (TCi.*sqrt((sqrt(1+TCi)+1)./(2*sqrt(1+TCi))));
% =========================== THOMAS' APPROACH ===========================
%               computes increase in thrust from tail wing drag
                dcl=data.b.CN.*(1-1./uRatio)*dataStruct.sTail/ ...
                    dataStruct.sRef;
                dCT=dcl/pi/3.87; % increased drag of tail
                TCi=TC+dCT;
%                 % compute induced drag over wetted area HT
%                 dCD = data.b.CL.^2./(pi*3.87).*(uRatio.^2-1);
%                 
%                 % compute CL_TC=0 and CD_TC=0 (assume model off values)
%                 CL_TC0 = data.b.CL .* 1./uRatio;
%                 CD_TC0 = data.b.CD + dCD;
%                 
%                 % compute thrust using TC=0 values
%                 dcm = angle2dcm(deg2rad(data.c.AoS), deg2rad(data.c.AoA), ...
%                     zeros(size(data.c.AoS)));
%                 aero=[-CD_TC0, data.c.CYaw, -CL_TC0]';
%                 
%                 % convert CL, CD, Cyaw to CT, CY, CN
%                 coeffModels = zeros(size(aero));
%                 for i = 1:length(data.c.AoS)
%                     coeffModels(:,i)=dcm(:,:,i) * aero(:,i) .* [-1; 1; -1];
%                 end
%                 
%                 % compute new thrust coefficient
%                 TCi = data.c.CT - coeffModels(1,:)';
%                 % change basis
%                 TCi = TCi * dataStruct.sRef / (pi/4*dataStruct.Dprop^2);
% %                 TCi ./ res
% %                 res = TCi;
            end
%             TCi;
%             TCi/dataStruct.sRef*pi/4*dataStruct.Dprop^2*2; % nondim with 
%             data.a.CT=TCi/dataStruct.sRef*pi/4*dataStruct.Dprop^2*2;
            
        data.a.CT=TCi;
        data.c.dPb=TCi;
%             data.c.dPb=-TCi/dataStruct.sRef*pi/4*dataStruct.Dprop^2*2;

            % use 3rd order polynomial fit
        tcfit=polyfit(data.c.AoS,TCi,3);
%             plot(data.c.AoS,data.c.dPb)
%             hold on
%             plot(data.d.AoS,polyval(tcfit,data.d.AoS))
        data.d.dPb=polyval(tcfit,data.d.AoS);
        thrustOut=data;
    end
    
    function thrustOut=thrustIterjVar(data)
        TEngine=-data.a.CT*0.5.*data.a.temp.*data.a.V.^2.*dataStruct.sRef/2; % force per engine
        data.a.CT*dataStruct.sRef/pi*4/dataStruct.Dprop^2/2;
        TC=TEngine./(0.5*data.a.temp.*data.a.V.^2*pi/4*dataStruct.Dprop^2);  % TC for engine
        CT=TC.*data.a.J_M1.^2*pi/8; % CT for engine    
        TCi=TC;
        for idx=1:1:5
            uRatio=1+0.6*2*0.2032/0.576*(TCi.*sqrt((sqrt(1+TCi)+1)./(2*sqrt(1+TCi))));
            dcl=data.b.CN.*(1-1./uRatio)*dataStruct.sTail/dataStruct.sRef; % computes increase in thrust from tail wing drag
            dCT=dcl/pi/3.87; % increased drag of tail
            TCi=TC+dCT;
        end
        TCi;
        data.a.CT=TCi;
        data.c.dPb=TCi;
        thrustOut=data;
    end
    end
   
    
    function data=removeModelOffjVar(data)
        modelOff=readtable('modelOffData.xlsx','VariableNamingRule','preserve');    % read model off data
        AoAEffect=table2array(modelOff(8,2:8))-table2array(modelOff(6,2:8)); % effect of 2 deg aoa on forces
        AoSEffect=modelOff{11,11:17}; % forces at -10, -6, -4, -2, 0, 2, 4, 6, 10 for aos

        CD=AoSEffect(:,2)+AoAEffect(:,2);
        Cy=AoSEffect(:,3)+AoAEffect(:,3);
        CL=AoSEffect(:,4)+AoAEffect(:,4);
        CMroll=AoSEffect(:,5)+AoAEffect(:,5);
        CMpitch=AoSEffect(:,6)+AoAEffect(:,6);
        CMyaw=AoSEffect(:,7)+AoAEffect(:,7);
        
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
    end 
       
     function data=removeModelOff(data)
        modelOff=readtable('modelOffData.xlsx','VariableNamingRule','preserve');    % read model off data
        AoAEffect=table2array(modelOff(8,2:8))-table2array(modelOff(6,2:8)); % effect of 2 deg aoa on forces
        AoSEffect=modelOff{[1,5,7,9,11,13,15,17,21],11:17}; % forces at -10, -6, -4, -2, 0, 2, 4, 6, 10 for aos
        
%         order=3;
        AoSFitCD=polyfit(AoSEffect(:,1),AoSEffect(:,2),8); % makes fit of forces in aero frame
        AoSFitCy=polyfit(AoSEffect(:,1),AoSEffect(:,3),8);
        AoSFitCL=polyfit(AoSEffect(:,1),AoSEffect(:,4),8);
        AoSFitCMroll=polyfit(AoSEffect(:,1),AoSEffect(:,5),8);
        AoSFitCMpitch=polyfit(AoSEffect(:,1),AoSEffect(:,6),8);
        AoSFitCMyaw=polyfit(AoSEffect(:,1),AoSEffect(:,7),8);
        
%         figure(2)
%         plot(data.AoS,data.CD)
%         hold on
%         plot(AoSEffect(:,1),AoSEffect(:,2))
%         plot(data.AoS,polyval(AoSFitCD,data.AoS),'x')
        
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

    function data=sideslipCorrection(data)
        sigmaEff=4*6/3/pi*(0.01427/0.2032);
        B0=45; % pitch at r/R=0.75 (is given for r/R=0.7)
        dYdbeta = 4.25*sigmaEff./(1+2*sigmaEff)*sind(B0+3).*(pi*data.J_M1.^2./8+3*sqrt(pi.*data.J_M1.^2./8.*abs(data.dPb))./(8*sqrt(pi*data.J_M1.^2/8+2/3.*data.dPb)));
        dY=dYdbeta.*deg2rad(data.AoS);
        dyRef=8/pi./data.J_M1.^2.*pi/4*0.2032^2/0.2171696.*dY;
%         dyRef=8/pi./data.J_M1.^2.*pi/4.*dY;
%         [data.CY data.CY-dyRef data.CY-8/pi./data.J_M1.^2.*pi/4*0.2032^2/0.2171696.*dY]
        data.CY=data.CY-dyRef;
    end
    
end    
end