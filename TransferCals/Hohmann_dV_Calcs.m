%% Calculating /\V
% for hohmann transfer, r_init = R_earth + 500km
% r_2 = distance to moon.

load('Moon_Capture_Arrival_Times.mat')

% Initial Radius
R_earth = 6.371e6;
R_1 = R_earth + 5e5;

%Constants for Earth
M = 5.6972e24;
G = 6.67408e-11;
mu=G*M;

%Constants for Moon
Mm = 7.3477e22; %mass of moon
mum = G*Mm;

r_p = 6.609e6; %Parking orbit height round mun.
v_orb = sqrt(mum/r_p); %velocity in this orbit
inc = 54.74; % inclination from MTR slides
%ahrens claulation for spreading the sattelites 
%plz check
t_init=2*pi*sqrt(r_p.^3/mum);
t_post=t_init*5/4;
a_post=(mum*(t_post/(2*pi)).^2).^(1/3);
r_spr = 2*a_post-r_p;%spreading orbit height 
e_spr = (r_spr - r_p)/(r_spr + r_p);
dV_spr_1 = sqrt((mum/a_post)*((1+e_spr)/(1-e_spr))) - sqrt(mum/r_p);

%spreading orbits so they happen at the smame time
t_orb_spr = t_init * 7/6;
a_orb_spr=(mum*(t_orb_spr/(2*pi)).^2).^(1/3);
ra_orb_spr = 2*a_orb_spr - r_p;
e_orb_spr = (ra_orb_spr - r_p)/(ra_orb_spr + r_p);
dV_orb_spr_1 = sqrt((mum/a_orb_spr)*((1+e_orb_spr)/(1-e_orb_spr))) - sqrt(mum/r_p);

% Initilaising Matricies
dV_esc = zeros(length(time_vals),1);        %dV 1
transfer_time = zeros(length(time_vals),1);
v_sat = zeros(length(time_vals),1);
dV_inj = zeros(length(time_vals),1);        %dV 2
dV_orb_spr = zeros(length(time_vals),1);    %dV 3&4
dV_inc = zeros(length(time_vals),1);        %dV 5
dV_sat_spr = zeros(length(time_vals),1);     %dV 6&7

%Calculating the dV required for each time interval
for i = 1:length(time_vals)
    startT = tic;
    %calculating DV
    [m_pos, m_vel] = planetEphemeris(juliandate(time_vals(i)),'Earth','Moon');
    m_pos = m_pos*1000; %converting from km to m
    m_vel = m_vel*1000; %converting from km to m
    
    R_2 = norm(m_pos);
    dV_esc(i) = sqrt((2*mu/R_1)-(2*mu/(R_1+R_2)))-sqrt(mu/R_1);
    %dV_esc(i) = sqrt(mu/R_1).*(sqrt(2*R_2/(R_1+R_2))-1);
    
    %Calculating time ToF
    a = (R_1 + R_2)/2;
    transfer_time(i) = pi*sqrt((a.^3)/mu);
    
    %calculating Moon dv
    e = (R_2-R_1)/(R_2+R_1);
    v_sat(i) = sqrt((mu/a).*((1-e)/(1+e)));
    v_mun = norm(m_vel);
    dV_capture = v_sat(i) - v_mun; %Earth reference frame
    %injecting into parking orbit around mooon
    dV_inj(i) = sqrt((2*mum/r_p)+sqrt(abs(dV_capture))) - sqrt(mum/r_p);
    
    %spreading orbits 60deg apart
    dV_orb_spr(i) = 2*dV_orb_spr_1;
    
    %changing inclination
    dV_inc(i) =  sqrt(2*v_orb.^2 - 2*cos(inc)*v_orb.^2);
    
    % making orbit eccentric to spread sattleites
    dV_sat_spr(i) = 2*dV_spr_1;
    
    %Calculaitn time left in loop
    elapsedT = toc(startT);
    remainingT = datestr(elapsedT*(length(time_vals)-i)/(60*60*24),'HH:MM:SS');
    fprintf('%s to go\n',remainingT);
end

figure(1)
plot(time_vals,dV_esc,'*')
title('\DeltaV to the Moon (Hohmann Transfer)')

figure(2)
plot(time_vals,transfer_time/(60*60*24),'*')
title('ToF to the Moon (Hohmann Transfer)')

dV_tot = dV_esc + dV_inj + dV_inc + dV_sat_spr + dV_orb_spr;

figure(3)
plot(time_vals,dV_tot,'*')
title('\DeltaV_{tot} to Desired Orbit (Hohmann Transfer)')

save('dV_vals','dV_tot','dV_esc','dV_inj','dV_inc','dV_orb_spr','dV_sat_spr')

figure(4)
plot(time_vals,dV_esc,'*',time_vals,dV_inj,'*',time_vals,dV_orb_spr,'*',time_vals,dV_inc,'*',time_vals,dV_sat_spr,'*',time_vals,dV_tot,'*')
title('\DeltaVs to Desired Orbit')
legend('\DeltaV Escape','\DeltaV Inject','\DeltaV Spread Orbits','\DeltaV Incline','\DeltaV Spread Satelites','\DeltaV Total')
