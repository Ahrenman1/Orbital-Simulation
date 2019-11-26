%% Calculating /\V
% for hoghman transfer, r_init = R_earth + 500km
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
a_post=(mum*(t_post/(2*pi)).^2).^1/3;
r_spr = 2*a_post-r_p;%spreading orbit height 


% Initilaising Matricies
dV_esc = zeros(length(time_vals),1); 
transfer_time = zeros(length(time_vals),1);
v_sat = zeros(length(time_vals),1);
%dV_capture(i) = zeros(length(time_vals),1);
dV_inj = zeros(length(time_vals),1);
dV_inc = zeros(length(time_vals),1);
dV_spr = zeros(length(time_vals),1);


%Calculating the dV required for each time interval
for i = 1:length(time_vals)
    %calculating DV
    [m_pos, m_vel] = planetEphemeris(juliandate(time_vals(i)),'Earth','Moon');
    m_pos = m_pos*1000; %converting from km to m
    m_vel = m_vel*1000; %converting from km to m
    
    R_2 = norm(m_pos);
    dV_esc(i) = sqrt(mu/R_1).*(sqrt(2*R_2/R_1+R_2)-1);
    
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
    
    %changing inclination
    dV_inc(i) =  sqrt(2*v_orb.^2 - 2*cos(inc)*v_orb.^2);
    
    % making orbit eccentric to spread sattleites
    % ahren plz add here!
    dV_spread_1 = sqrt((2*mum/r_p)-(2*mum/(r_p+r_spr)))-sqrt(mum/r_spr);
    dV_spr(i) = 2*dV_spread_1;%reverse kick is identical
    
end


figure
plot(time_vals,dV_esc,'*')
title('\DeltaV to the Moon (Hoghman Transfer)')

figure
plot(time_vals,transfer_time,'*')
title('ToF to the Moon (Hoghman Transfer)')

dV_tot = dV_esc + dV_inj + dV_inc + dV_spr;

figure
plot(time_vals,dV_tot,'*')
title('\DeltaV_{tot} to Desired Orbit (Hoghman Transfer)')

save('dV_vals','dV_tot')

figure
plot(time_vals,dV_esc,'*',time_vals,dV_inj,'*',time_vals,dV_inc,'*',time_vals,dV_spr,'*',time_vals,dV_tot,'*')
title('\DeltaVs to Desired Orbit')
legend('\DeltaV Escape','\DeltaV Inject','\DeltaV Incline','\DeltaV Spread','\DeltaV Total')