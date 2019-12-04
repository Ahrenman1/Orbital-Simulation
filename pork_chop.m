% Pork-chop plot
clear
muE=1000*astro_constants(13); % Earth gravity constant in km^3/s^2

td_start=mjuliandate(2029,1,1); % put here the opening of the possible departure dates in days;
td_end=mjuliandate(2029,1,30); % put here the closing of the possible departure dates in days;
ta_start=mjuliandate(2029,2,1); % put here the opening of the possible arrival dates in days;
ta_end=mjuliandate(2029,2,30); % put here the closing of the possible arrival dates in days;
a_sat = 1000*(astro_constants(23)+500);
nsteps_i = 10;
nsteps_j = 10;
dv = zeros(nsteps_i,nsteps_j);
for i=1:nsteps_i
    ti(i)=td_start+(td_end-td_start)*((i-1)/(nsteps_i-1));
    for j=1:nsteps_j    
        tj(j)=ta_start+(ta_end-ta_start)*((j-1)/(nsteps_j-1));
        
        % The function ephemerides is what you need to write to compute the
        % position and velocity of Earth and asteroid given their orbital
        % parameters 
        [r_moon,v_moon]=planetEphemeris(tj(j)+2400000.5,'Earth','Moon'); % Position and velocity of the Asteroid at time tj(j)
        r_sat=orb_with_ext_time(a_sat,0,0,0,0,tj(j)); % Position and velocity of the Earth at time ti(i)
        %r_sat=a_sat*r_moon/-norm(r_moon);
        r_moon = r_moon*1000;
        v_moon = v_moon*1000;
        v_sat = sqrt(muE/norm(r_sat));
        ToF(j)=(tj(j)-ti(i))*86400; % time of flight in seconds
        [A,P,E,ERROR,VI,VF,TPAR,THETA] = lambertMR(r_sat.',r_moon,ToF(j),muE,0,0,0);
        dv(i,j)=norm(VI)-v_sat+norm(VI-v_moon)
    end
end

contour(ti,tj,dv.','ShowText','on')
xlabel('Time of departure (MJD)')
ylabel('Time of arrival (MJD)')
