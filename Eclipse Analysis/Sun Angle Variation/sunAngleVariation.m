
function a = sunAngleVariation(incli,longAN)
% Rotation Matrix around x-axis
rot1 = [1 0             0           ; 
        0 cosd(incli)   -sind(incli); 
        0 sind(incli)   cosd(incli)];
% Rotation Matrix around z-axis
rot2 = [cosd(longAN)    -sind(longAN)   0 ; 
        sind(longAN)    cosd(longAN)    0 ; 
        0               0               1];
% Normal vector of orbital plane
h_orbit = rot2*rot1*([0 0 1].');
% Sun-Moon Vector
r_sun = [];

a = [];
oblqEarth = -23.4; % Obliquity of Earth (degs)
oblqMoon = 0;%1.54; % Obliquity of Moon (degs)
T0 = 1;
Tmax = 365;
TA = T0:Tmax;
for i=T0:Tmax
    fprintf('%f%% done \n',i*100/Tmax);
    r_sun_Earth = 1000*planetEphemeris(juliandate(2029,01,i,0,0,0),'Moon','Sun'); % Earth centered ephemeris (J2000/ICRF)
    % Rotation around x-axis
    rotMatrix = [   1 0                         0                           ; 
                    0 cosd(oblqEarth+oblqMoon)  -sind(oblqEarth+oblqMoon)   ; 
                    0 sind(oblqEarth+oblqMoon)  cosd(oblqEarth+oblqMoon)]   ; 
    r_sun = rotMatrix*r_sun_Earth.';
    a(i,:) = rad2deg(acos(dot(r_sun,h_orbit)/norm(r_sun)*norm(h_orbit)));
    disp(a);
end
figure;
plot(TA,a);
