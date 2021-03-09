classdef thrust_removal
    
methods (Static)
    function dataOut = mainFunction(dataStruct)
        propOff=sortrows(dataStruct.propoff,[19 6]);
        beta0=sortrows(dataStruct.beta0,[19 6]);
        beta5=sortrows(dataStruct.beta5,[19 6]);
        beta10=sortrows(dataStruct.beta10, [19 6]);
      
        modelOff=readtable('modelOffData.xlsx','VariableNamingRule','preserve');
        aoaEffect=table2array(modelOff(8,3:8));
        aoaEffectF=table2array(modelOff(8,3:5))-table2array(modelOff(6,3:5)); % effect of 2 deg aoa
        
        aosEffect=modelOff{[11,13,15,17,21],12:14}; % only forces at 0, 2, 4, 6, 10 aos
        propOff20=propOff(1:5,{'AoA','AoS','V','FX','FY','FZ'});
        propOff40=propOff(6:10,{'AoA','AoS','V','FX','FY','FZ'});
        
        propOff20=table2array(propOff20(:,4:6))-aoaEffectF*0.5*1.225*0.2172*20*20; % FX, FY, FZ corrected for aoa 2 deg
        propOff20Cor=propOff20-aosEffect*0.5*1.225*0.2172*20*20; % forces corrected for model off data
        
        propOff40=table2array(propOff40(:,4:6))-aoaEffectF*0.5*1.225*0.2172*40*40; % FX, FY, FZ corrected for aoa 2 deg
        propOff40Cor=propOff40-aosEffect*0.5*1.225*0.2172*40*40; % forces corrected for model off data
        
%         aos=[0, 2, 4, 6, 10];
%         f=polyfit(aos,propOff20Cor(:,1),3); % order of fit
%         plot(aos,polyval(f,aos))
%         hold on
%         plot(aos,propOff20Cor(:,1),'-o')
%         
%         beta10=
%         
%         
%         urat=1+0.6*2*0.2032/0.576*(TC*sqrt(()/(2*sqrt(1+TC)))
        
        
        dataOut=propOff20Cor;
    end
  
  function output1 = someFuncName2
  end
end
end

% xloc=1:1:5
% x=load2Struct('OUTPUT.xls')
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