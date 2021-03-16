clear all
close all
clc


PropellerDiameter = 0.2032;%[m]
PropellerArea = (pi/4)*PropellerDiameter^2;



Volume_wing = 0.0030229;% [m^3]
Volume_fuselage = 0.0160632;% [m^3]
Area_wing = 0.2172;% [m^2]
Area_tail = 0.0858;% [m^2]
AR_wing = 8.98;
AR_tail = 3.87;
%MAC = 0.165m
MAC_wing = 0.165;% [m]
%DU-96 thickness = 0.1579c
%2s = 1.397m^2; --> full wing span
s = 1.397/2;

tail_arm = 0.535;% [m], distamce from c/4 wing to c/4 tail
tail_arm_cg = tail_arm - (0.48-0.25)*MAC_wing;% [m]

Vbar = (Area_tail*tail_arm_cg)/(Area_wing*MAC_wing);
%Wind tunnel
B = 1.29*2*s;
H = 0.89*2*s;
BreadthToHeight = B/H;%B/H
lambda = H/B;


%Wind tunnel x-section area ~= 2.06m^2
% WTCrossSection = (1.8*1.25)-2*(0.3*0.3);% [m^2]
WTCrossSection = (B*H)-2*(0.3*0.3);% [m^2]

%% Solid blockage factor
% profile=readmatrix('wing airfoil coordinates DU 96-150.dat');
profile=readmatrix('./DATA/modified_DU96-150.dat');
profile_cp=dlmread('./DATA/modified_DU96-150.cp','',1,0);

% profile=dlmread('./DATA/naca0012.dat','',1,0);
% profile_cp=dlmread('./DATA/naca0012.cp','',1,0);
% figure;
% plot(profile(1:81,1),profile(1:81,2),'o');
% axis equal

%----------------------------------------------------
% K1/K2 (from NACA report 995)
profile_upper=(profile(51:end,:));%for du96
profile_uppercp=flip(profile_cp(1:51,:));

% profile_upper=flip(profile(1:81,:));%0012
% profile_uppercp=flip(profile_cp(1:81,:));

dydx=[];
thickness=2*max(profile_upper(:,2))/(profile_upper(end,1)-profile_upper(1,1));

for i=1:length(profile_upper)-1
   dydx(i,1)=(profile_upper(i+1,2)-profile_upper(i,2))/(profile_upper(i+1,1)-profile_upper(i,1));
   dx(i,1)=profile_upper(i+1,1)-profile_upper(i,1);
   q(i,1)=profile_upper(i,2)*sqrt(1-profile_uppercp(i,2))*sqrt(1+dydx(i)^2)*dx(i);
end

qsum=(16/pi)*sum(q);
K2=((pi^1.5)/16)*(qsum/thickness);
%K2 for DU 96 airfoil = 0.6425
%K2 for 0012 airfoil = 0.687

t_wing = thickness*MAC_wing;

%k1=V/2sct
%k1= 0.503 for DU96 airfoil using full span
k1 = Volume_wing/(2*s*MAC_wing*t_wing);

% K1=K2/k1;
K1 = K2/k1
%--------------------------------------------------------------
%Have to estimate K3 (fuselage) from figure 10.2 in Pope, using d/l=0.14/1.342=0.104
%K3 approximately 0.91
K3 = 0.91
%---------------------------------------------------------------
%tau1 (from NACA report 995)
N=7;
SpantoTunnelBreadth = 2*s/B;%2s/b
sigma_wing = sigma_term1_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + sigma_term2_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + sigma_term3_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + Rn_calc(BreadthToHeight,N);

%tau1=0.8844 for the wing
%tau1=0.8678 for the fuselage
tau1_wing = 0.5*sigma_wing*(BreadthToHeight/pi)^1.5

%For body of revolution (fuselage), take SpantoTunnelBreadth = 0
SpantoTunnelBreadth = 0;%2s/b=0
sigma_fuselage = sigma_term1_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + sigma_term2_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + sigma_term3_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + Rn_calc(BreadthToHeight,N);
tau1_fuselage = 0.5*sigma_fuselage*(BreadthToHeight/pi)^1.5

%epsilon_solid blockage = 0.0054
epsilon_sb_wing = (K1*tau1_wing*Volume_wing)/(WTCrossSection^1.5) 
epsilon_sb_fuselage = (K3*tau1_fuselage*Volume_fuselage)/(WTCrossSection^1.5) 
epsilon_sb = epsilon_sb_wing + epsilon_sb_fuselage

%% wake blockage


%% slipstream blockage


%% tail downwash correction
temp = (0.1*AR_wing*0.8)/(AR_tail+2);
dCMcgdalphat=-temp*Vbar;% = -0.1456

%%tau2 for tail_arm_cg

%l_t/B = 0.2758
ratio_uw_tail = tail_arm_cg/B;
tau2_uw_tail = 0.721;

%(0.5*MAC)/B = 0.0458
ratio_sc = (0.5*MAC_wing)/B;
tau2_sc = 0.122;
%% functions 
function Emn = Emn_calc(n,m,SpantoTunnelBreadth,BreadthToHeight)%checked
    halfspantobreadth=SpantoTunnelBreadth/2;
    a1 = (m+halfspantobreadth)^2;
    Emn = sqrt((n^2)+(a1*BreadthToHeight^2));
end

function Fmn = Fmn_calc(n,m,SpantoTunnelBreadth,BreadthToHeight)%checked
    halfspantobreadth=SpantoTunnelBreadth/2;
    Fmn = sqrt((n^2)+((m-halfspantobreadth)^2)*(BreadthToHeight^2));
end

function [Rn,Term3_5,Term3_4] = Rn_calc(BreadthToHeight,N)%checked
    Term1 = 1/((BreadthToHeight^3)*(N+0.5)^2);
    Term2 = 1/((N+0.5)^2);
    
    Term3_1 = 2/BreadthToHeight;
    Term3_2 = 2/(BreadthToHeight^2);
    
    Term3_3_1 = 2*sqrt((BreadthToHeight^2)*((N+0.5)^2)+0.25);
    Term3_3_2 = (BreadthToHeight^2)*(N+0.5);
    Term3_3 = Term3_3_1/Term3_3_2;
    
    Term3_4_1 = 2*sqrt((0.25*(BreadthToHeight^2))+((N+0.5)^2));
    Term3_4_2 = (BreadthToHeight^2)*(N+0.5);
    Term3_4 = Term3_4_1/Term3_4_2;
    
    Term3_5_1 = sqrt(1+BreadthToHeight^2);
    Term3_5_2 = (BreadthToHeight^2)*(N+0.5);
    Term3_5 = Term3_5_1/Term3_5_2;
    
    Term3 = 4*(Term3_1 + Term3_2 - Term3_3 - Term3_4 +Term3_5);
    Rn = Term1 + Term2 + Term3;
end

function sigma_term1 = sigma_term1_calc(N,SpantoTunnelBreadth,BreadthToHeight)
    halfspantobreadth=SpantoTunnelBreadth/2;
    sigma_term1 = 0;
    for n=1:N
       for m=1:N
           Emn = Emn_calc(n,m,SpantoTunnelBreadth,BreadthToHeight);
           Fmn = Fmn_calc(n,m,SpantoTunnelBreadth,BreadthToHeight);
           A1 = Fmn*(m+halfspantobreadth) + Emn*(m-halfspantobreadth);
           sigma_term1=sigma_term1+(m/(Emn*Fmn*A1));           
       end        
    end
    sigma_term1 = sigma_term1*8;
end

function sigma_term2 = sigma_term2_calc(N,SpantoTunnelBreadth,BreadthToHeight)
    halfspantobreadth=SpantoTunnelBreadth/2;
    halfspantoheight=halfspantobreadth*BreadthToHeight;
    sigma_term2 = 0;
    for n=1:N
       A1 = (n^2)*sqrt((n^2)+(halfspantoheight^2));
       sigma_term2 = sigma_term2 + (1/A1);
    end
    sigma_term2 = sigma_term2*2;
end

function sigma_term3 = sigma_term3_calc(N,SpantoTunnelBreadth,BreadthToHeight)
    halfspantobreadth=SpantoTunnelBreadth/2;
    sigma_term3 = 0;
    for m=1:N
       A1=((m^2)-(halfspantobreadth^2))^2;
       sigma_term3 = sigma_term3 + m/A1;
    end
    sigma_term3 = 2*sigma_term3/(BreadthToHeight^3);  
end
