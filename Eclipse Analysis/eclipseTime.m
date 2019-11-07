%function eclipseTime = eclipseTime()
clf;
Rm = 1.7e6;
T0 = 1;
Ti = 10*60;
Tmax = 60*60*24*30;
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
    
    fprintf('%f%% done \n',i*100/Tmax);
    
    r_sun_Earth = 1000*planetEphemeris(juliandate(2029,01,01,0,i/5,0),'Moon','Sun'); % Earth centered ephemeris (J2000/ICRF)
    r_sun = rotMatrix*r_sun_Earth.';
    sunLine = mArrow3([0,0,0],r_sun.'/1.5e11*3e6);
    %scatter3(r_sun(1),r_sun(2),r_sun(3));
    r_sat = orb_with_ext_time(6.6e6,0,90,0,0,i);
    if dot(r_sat,r_sun)<=0
        if norm((cross(r_sat,(r_sun/norm(r_sun)))))<=Rm
            inEclipse(i) = true;
            sat_pt = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
        else
            inEclipse(i) = false;
            sat_pt = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
        end
    else
        sat_pt = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
    end
    pause(0.001);
    frame=getframe(gcf);
    writeVideo(v,frame);
    delete(sunLine);
    delete(sat_pt);
end
close(v);
eclipseTimes = find(inEclipse);
timeEclipse = 0;
eclipses = [];
ect=[];


this_eclipse=0;
eclipse_at=eclipseTimes(1);
eclipse_length=[];
for j = 1:length(eclipseTimes)-1
    if eclipseTimes(j)+Ti == eclipseTimes(j+1)
        this_eclipse=this_eclipse+Ti;
    else
        eclipse_length=[eclipse_length this_eclipse];
        eclipse_at=[eclipse_at eclipseTimes(j+1)];
        this_eclipse=0;
    end
end
eclipse_length=[eclipse_length this_eclipse];

maxEclipse = max(eclipse_length);
maxEclipseIndex = find(eclipse_length==maxEclipse);
maxEclipseTime = eclipse_at(maxEclipseIndex);

minEclipse = min(eclipse_length);
minEclipseIndex = find(eclipse_length==minEclipse);
minEclipseTime = eclipse_at(minEclipseIndex);

