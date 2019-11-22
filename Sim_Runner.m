%% Sim Runner
% Sim Runner is Top Level Sumulation Runner for Project.
% Set to run 6 orbits
%%% Basiv Variables
a = 6.609e6;    %semimajor axis
n = 4;          %number of sattelites per orbit
in = 55;        %inclination of each of the orbits

%%% Setting up the time array. All values in seconds.
ts = 10; %Timestep
t_max = 60*60*24*1.5; % Length of Sim
timelist = 0:ts:t_max; %vector of time values 

tic
all_location_variables = Coord_Generator(timelist,a,0,in,0,0,0,n,a,0,in,0,60,0,n,a,0,in,0,120,0,n,a,0,in,0,180,0,n,a,0,in,0,240,0,n,a,0,in,0,300,0,n);
cood_time = toc;
tic
satelittes_visble = Eff_Coverage(all_location_variables);
cov_time = toc;
save('Sat_Coords.mat','timelist','all_location_variables','satelittes_visble');