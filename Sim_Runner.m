%% Sim Runner
% Sim Runner is Top Level Sumulation Runner for Project.
% Set to run 6 orbits
tic
%%% Basic Variables
a = 6.609e6;    %semimajor axis
n = 4;          %number of sattelites per orbit
in = 55;        %inclination of each of the orbits

%%% Setting up the time array. All values in seconds.
ts = 60; %Timestep
t_max = 60*60*24*100; % Length of Sim
timelist = 0:ts:t_max; %vector of time values 


all_location_variables = Coord_Generator(timelist,a,0,in,0,0,0,n,a,0,in,0,60,0,n,a,0,in,0,120,0,n,a,0,in,0,180,0,n,a,0,in,0,240,0,n,a,0,in,0,300,0,n);

%satelittes_visble = Eff_Coverage(all_location_variables);
cov_time = toc;
save('Sat_Coords.mat','timelist','all_location_variables')%'satelittes_visble');

%% Ahrens Coverage Analysis
% Percentage Plots
Coverage_Analysis_Plot(satelittes_visble,timelist,[4 5 6 7 8]);
% Visualisation
Coverage_Plot(all_location_variables,satelittes_visble);

%% Duncs Ground Station Link Analysis
% Adding Path to active directory
addpath('GroundStation')
GSV_Runner;

%% Laurences Eclipse Analysis
% Plz Add here laurence.


toc
