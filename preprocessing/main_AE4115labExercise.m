%% Main processing file LTT data AE4115 lab exercise 2020-2021
% T Sinnige
% 26 February 2021

%% Initialization
% clear workspace, figures, command window
clear 
close all
clc

%% Inputs
% enter group number 
groupNo = 1; 

% define root path on disk where data is stored
diskPath      = './DATA/';

% [GROUP08 CODE]
tm_norand = readtable(diskPath + "test_matrix_2p3_norand.xlsx");
tm_rand = readtable(diskPath + "test_matrix_2p3.xlsx");

% get vInf columns
vInfZeroStab = table2array(tm_rand(16:55, 6));
vInfFiveStab = table2array(tm_norand(90:125, 6));
vInfTenStab = table2array(tm_norand(53:89, 6));
vInfPropoff = table2array(tm_rand(128:137, 6));
% get rhoInf and TInf of same size
rhoInfZeroStab = 1.225 * ones(size(vInfZeroStab));
rhoInfFiveStab = 1.225 * ones(size(vInfFiveStab));
rhoInfTenStab = 1.225 * ones(size(vInfTenStab));
rhoInfPropoff = 1.225 * ones(size(vInfPropoff));
TInfZeroStab = 1.225 * ones(size(vInfZeroStab));
TInfFiveStab = 1.225 * ones(size(vInfFiveStab));
TInfTenStab = 1.225 * ones(size(vInfTenStab));
TInfPropoff = 1.225 * ones(size(vInfPropoff));
% get indices balance data files
[idxB] = SUP_getIdx;

% filename(s) of the raw balance files - DEFINE AS STRUCTURE WITH AS MANY FILENAMES AS DESIRED 
% The name of the file must start with "raw_" and the name cannot have any
% hyphen or space

fn_BAL = {'raw_beta_sweep_alfa_2_propoff.txt',...
          'raw_dir_stab_rudder_zero.txt',...
          'raw_dir_stab_rudder_five.txt',...
          'raw_dir_stab_rudder_ten.txt'};

% filename(s) of the zero-measurement (tare) data files. Define an entry
% per raw data files. In case multiple zero-measurements are available for
% a datapoint, then add a structure with the filenames of the zero 
% measurements at the index of that datapoint.
fn0 = {'zero_beta_propoff.txt',...
       'zero_beta_propon.txt',...
       'zero_beta_propon.txt',...
       'zero_beta_propon.txt'};  
   
% manual input of freestream conditions - ONLY USE FOR GROUPS 1-13 !! 
% enter vector of values per measurement file
operManual.vInf = {vInfPropoff, vInfZeroStab, vInfFiveStab, vInfTenStab};
operManual.rhoInf = {rhoInfPropoff, rhoInfZeroStab, rhoInfFiveStab, ...
                     rhoInfTenStab};
operManual.tInf = {TInfPropoff, TInfZeroStab, TInfFiveStab, TInfTenStab};

% wing geometry
b     = 1.4*cosd(4); % span [m]
cR    = 0.222; % root chord [m]
cT    = 0.089; % tip chord [m]
S     = b/2*(cT+cR);   % reference area [m^2]
taper = cT/cR; % taper ratio
c     = 2*cR/3*(1+taper+taper^2)/(1+taper); % mean aerodynamic chord [m]

% prop geometry
D        = 0.2032; % propeller diameter [m]
R        = D/2;   % propeller radius [m]

% moment reference points
XmRefB    = [0,0,0.0465/c]; % moment reference points (x,y,z coordinates) in balance reference system [1/c] 
XmRefM    = [0.25,0,0];     % moment reference points (x,y,z coordinates) in model reference system [1/c] 

% incidence angle settings
dAoA      = 0.0; % angle of attack offset (subtracted from measured values)   
dAoS      = 0.0;  % angle of sideslip offset (subtracted from measured values)
modelType = 'aircraft'; % options: aircraft, 3dwing, halfwing
modelPos  = 'inverted'; % options: normal, inverted
testSec   = 5;    % test-section number   

%% Run the processing code to get balance and pressure data
BAL = BAL_process(diskPath,fn_BAL,fn0,idxB,D,S,b,c,XmRefB,XmRefM,dAoA,dAoS,modelType,modelPos,testSec,groupNo,operManual);

%% Turn BAL data into .xls file (Optional)
xls_file_output(BAL,fn_BAL);

%% Write your code here

