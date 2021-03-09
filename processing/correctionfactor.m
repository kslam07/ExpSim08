clear all
close all
clc


PropellerDiameter = 0.2032;%[m]
PropellerArea = (pi/4)*PropellerDiameter^2;

%% Solid blockage factor
% profile=readmatrix('wing airfoil coordinates DU 96-150.dat');
profile=readmatrix('./DATA/modified_DU96-150.dat');
profile_cp=dlmread('./DATA/modified_DU96-150.cp','',1,0);

% profile=dlmread('./DATA/naca0012.dat','',1,0);
% profile_cp=dlmread('./DATA/naca0012.cp','',1,0);
% figure;
% plot(profile(1:81,1),profile(1:81,2),'o');
% axis equal

%% K1/K2 (from NACA report 995)
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

%Volume of actual wing = 0.0030229 m2
V = 0.0030229;
%MAC = 0.165m
cbar = 0.165;
%DU-96 thickness = 0.1579c
t = thickness*cbar;
%2s = 1.397;
s = 1.397/2;
%k1=V/2sct

%k1= 0.503 for DU96 airfoil using full span
k1 = V/(2*s*cbar*t);

% K1=K2/k1;
K1 = K2/k1

%Have to estimate K3 (fuselage) from figure 10.2 in Pope, using d/l=0.14/1.342=0.104
%K3 approximately 0.91
K3 = 0.91

%% tau1 (from NACA report 995)
N=7;

B = 1.29*2*s;
H = 0.89*2*s;
BreadthToHeight = B/H;%B/H
% SpantoTunnelBreadth = 2*s/B;%2s/b

%For body of revolution (fuselage), take SpantoTunnelBreadth = 0
SpantoTunnelBreadth = 0;%2s/b=0

%check

sigma = sigma_term1_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + sigma_term2_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + sigma_term3_calc(N,SpantoTunnelBreadth,BreadthToHeight)...
    + Rn_calc(BreadthToHeight,N);

%tau1=0.8844 for the wing
%tau1=0.8678 for the fuselage
tau1 = 0.5*sigma*(BreadthToHeight/pi)^1.5

%% wake blockage

%Wind tunnel x-section area = 2.07m^2
WTCrossSection = (1.8*1.25)-2*(0.3*0.3);% [m^2]
%% slipstream blockage





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
