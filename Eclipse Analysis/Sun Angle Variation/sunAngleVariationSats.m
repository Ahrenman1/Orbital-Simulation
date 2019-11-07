
function a = sunAngleVariation(semMA,eccent,incli,argPeri,longAN)

r_sat_MCI = zeros(3,1);

r_sun_MCI = zeros(3,1);
oblqEarth = -23.4; % Obliquity of Earth (degs)
T0 = 1;
Tmax = 365;
TA = T0:Tmax;
a = zeros(Tmax,1);
for i=T0:Tmax
    fprintf('%f%% done \n',i*100/Tmax);
    %%
    % Earth centered ephemeris (J2000/ICRF)
    r_sun_ECI = 1000*planetEphemeris(juliandate(2029,01,i,0,0,0),'Moon','Sun'); 
    % Rotation around x-axis
    rotMatrix = [1 0 0 ; 0 cosd(oblqEarth) -sind(oblqEarth) ; 0 sind(oblqEarth) cosd(oblqEarth)]; 
    % Moon centered ephemeris
    r_sun_MCI = rotMatrix*r_sun_ECI.';
    %%
    % Satellite vector
    r_sat_MCI = orb_with_ext_time(semMA,eccent,incli,argPeri,longAN,i);
    %%
    % Calculate angle using dot product
    a(i,:) = rad2deg(acos(dot(r_sun_MCI,r_sat_MCI)/norm(r_sun_MCI)*norm(r_sat_MCI)));
    disp(a(i));
end
plot(TA,a);
