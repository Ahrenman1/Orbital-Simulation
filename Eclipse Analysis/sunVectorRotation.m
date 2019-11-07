%function eclipseTime = eclipseTime()
clf;
Rm = 1.7e6;
T0 = 0;
Ti = 1*60;
Tmax = 24*60*60;
TA = [T0:Ti:Tmax];
oblqEarth = -23.4; % Obliquity of Earth (degs)
oblqMoon = 0; % Obliquity of Moon (degs)
rotMatrix = [   1       0                         0                           ;...
                0       cosd(oblqEarth+oblqMoon)  -sind(oblqEarth+oblqMoon)   ;...
                0       sind(oblqEarth+oblqMoon)  cosd(oblqEarth+oblqMoon)]   ; % Rotation around x-axis
            
%figure;
v = VideoWriter('video.avi');
[sx,sy,sz]=sphere;
h=surf(sx*Rm,sy*Rm,sz*Rm);
hold on
axis equal;
%set(gca,'XLim',[-7e6 7e6],'YLim',[-7e6 7e6],'ZLim',[-7e6 7e6])
axis([-7e6,7e6,-7e6,7e6,-7e6,7e6]);
inEclipse = [];
open(v);
for i = T0:Ti:Tmax
    disp(i)
    r_sun_Earth = planetEphemeris(juliandate(2029,1,1,0,i,0),'Earth','Sun'); % Earth centered ephemeris (J2000/ICRF)
    r_sun = rotMatrix*r_sun_Earth.';
    sunLine = mArrow3([0,0,0],r_sun.'/20);
    pause(0.001);
    frame=getframe(gcf);
    writeVideo(v,frame);
    delete(sunLine);
    delete(sat_pt);
    fprintf('%f%% done \n',i*100/Tmax);
    
end
close(v);
