%function eclipseTime = eclipseTime()
clf;
Rm = 1.7e6; % Moon radius
Re = 6.371e6; % Earth radius

T0 = 1;
Ti = 5*60;
Tmax = 60*60*24*1;
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
view(60,30);
inEclipse = [];
open(v);
for i = T0:Ti:Tmax
    
    fprintf('%f%% done \n',i*100/Tmax);
    r_earth_ECI = 1000*planetEphemeris(juliandate(2029,6,25,20,0,i),'Moon','Earth');
    r_sun_ECI = 1000*planetEphemeris(juliandate(2029,6,25,20,0,i),'Moon','Sun'); % Earth centered ephemeris (J2000/ICRF)
    r_sun_MCI = rotMatrix*r_sun_ECI.';
    r_earth_MCI = rotMatrix*r_earth_ECI.';
    
    %% Draw Sun and Earth vectors
    sunLine = mArrow3([0,0,0],r_sun_MCI.','color',[1,0.65,0]);
    earthLine = mArrow3([0,0,0],r_earth_MCI.'/50,'color','b');
    
    [cx,cy,cz] = cylinder2(Rm,r_sun_MCI);
    cx(2, :) = -r_sun_MCI(1);
    cy(2, :) = -r_sun_MCI(2);
    cz(2, :) = -r_sun_MCI(3);
    cylinder = surf(cx,cy,cz,'FaceAlpha',0);
    
    %% Multisat
    for j = 0:1:5
        %% Find satellite vector
        r_sat = pert_orb_with_ext_time(6.609e6,0,55,0,j*60,i);
        r_sat_earth = r_sat + r_earth_MCI;
        r_sat_sun = r_sat + r_sun_MCI;

        %% Eclipse check
        if dot(r_sat,r_sun_MCI)<=0
            if norm(cross(r_sat,(r_sun_MCI/norm(r_sun_MCI))))<=Rm
                inEclipse(i) = true;
                sat_pt = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
            else
                if dot(r_sat_earth,r_sat_sun)>0
                    if norm(cross(r_sat_earth,(r_sat_sun/norm(r_sat_sun))))<=Re
                        inEclipse(i) = true;
                        sat_pt = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
                    else
                        inEclipse(i) = false;
                        sat_pt = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                    end
                else
                    inEclipse(i) = false;
                    sat_pt = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                end
            end
        else
            sat_pt = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
        end   
    end
    
    %% Animate + capture frame
    pause(0.001);
    frame=getframe(gcf);
    writeVideo(v,frame);
    delete(sunLine);
    delete(earthLine);
    delete(sat_pt);
    delete(cylinder);
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

