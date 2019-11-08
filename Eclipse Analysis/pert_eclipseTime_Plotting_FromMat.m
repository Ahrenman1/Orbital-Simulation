%function eclipseTime = eclipseTime()
clf;
Rm = 1.7e6; % Moon radius
Re = 6.371e6; % Earth radius


load("Sat_Coords_30Day_1mRes.mat")

[j_max, k_max, ~] = size(all_location_variables);

oblqEarth = -23.4; % Obliquity of Earth (degs)
oblqMoon = 0; % Obliquity of Moon (degs)
rotMatrix = [   1       0                         0                           ;...
                0       cosd(oblqEarth+oblqMoon)  -sind(oblqEarth+oblqMoon)   ;...
                0       sind(oblqEarth+oblqMoon)  cosd(oblqEarth+oblqMoon)]   ; % Rotation around x-axis
            
%figure;


colour = hsv(6); %to hold the 6 different colours
%{
v = VideoWriter('video.avi');
v.FrameRate = 20;
open(v);
%}
inEclipse = [];

Ti = 10; % Minutes
Tmax = 60*24*30; % Minutes
for i = timelist(1:Ti:Tmax)
    index=find(timelist == i);
    
    timeJulian = juliandate(2029,1,1,0,0,i);
    %timeJulian = juliandate(2029,12,20,18,0,i);
    %timeJulian = juliandate(2030,12,9,18,0,i);
    timestamp = datetime(timeJulian,'convertfrom','juliandate');
    
    fprintf('%f%% done \n',i*100/timelist(Tmax));
    r_earth_ECI = 1000*planetEphemeris(timeJulian,'Moon','Earth');
    r_sun_ECI = 1000*planetEphemeris(timeJulian,'Moon','Sun'); % Earth centered ephemeris (J2000/ICRF)
    r_sun_MCI = rotMatrix*r_sun_ECI.';
    r_earth_MCI = rotMatrix*r_earth_ECI.';
    %% Draw Sun and Earth vectors
    hold on
    axis equal;
    %set(gca,'XLim',[-7e6 7e6],'YLim',[-7e6 7e6],'ZLim',[-7e6 7e6])
    axis([-7e6,7e6,-7e6,7e6,-7e6,7e6]);
    set(gcf, 'Position', [50 50 800 800]);
    view(200,10);
    title(datestr(timestamp));
    sunLine = mArrow3([0,0,0],r_sun_MCI.','color',[1,0.65,0]);
    earthLine = mArrow3([0,0,0],r_earth_MCI.','color','b');
    
    [sx,sy,sz]=sphere;
    h=surf(sx*Rm,sy*Rm,sz*Rm,'FaceColor',[0.9,0.9,0.9]);
    [cx,cy,cz] = cylinder2(Rm,r_sun_MCI);
    cx(2, :) = -r_sun_MCI(1);
    cy(2, :) = -r_sun_MCI(2);
    cz(2, :) = -r_sun_MCI(3);
    cylinder = surf(cx,cy,cz,'FaceAlpha',0.5,'FaceColor',[0.5,0.5,0.5]);
    %colormap(gray);
    
    %% Multisat
    for j = 1:1:j_max
        for k = 1:1:k_max
            
            sat_pt = zeros(j,k);
            r_sat = squeeze(all_location_variables(j,k,:,index));
            r_sat_earth = r_earth_MCI - r_sat;
            r_sat_sun = r_sun_MCI - r_sat;
            
            x_trail=squeeze(all_location_variables(j,k,1,1:index));
            y_trail=squeeze(all_location_variables(j,k,2,1:index));
            z_trail=squeeze(all_location_variables(j,k,3,1:index));
            plot3(x_trail,y_trail,z_trail,'Color',colour(j,:));
            
            
            %% Eclipse check
            if dot(r_sat,r_sun_MCI)<=0
                if norm(cross(r_sat,(r_sun_MCI/norm(r_sun_MCI))))<=Rm
                    inEclipse(j,k,index) = true;
                    sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
                else
                    if dot(r_sat_earth,r_sat_sun)>0
                        if norm(cross(r_sat_earth,(r_sat_sun/norm(r_sat_sun))))<=Re
                            inEclipse(j,k,index) = true;
                            sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
                        else
                            inEclipse(j,k,index) = false;
                            sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                        end
                    else
                        inEclipse(j,k,index) = false;
                        sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                    end
                end
            else
                if dot(r_sat_earth,r_sat_sun)>0
                    if norm(cross(r_sat_earth,(r_sat_sun/norm(r_sat_sun))))<=Re
                        inEclipse(j,k,index) = true;
                        sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
                    else
                        inEclipse(j,k,index) = false;
                        sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                    end
                else
                    inEclipse(j,k,index) = false;
                    sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                end
            end
        end   
    end
    
    
    %% Animate + capture frame
    pause(0.001);
    %{
    frame=getframe(gcf);
    writeVideo(v,frame);
    %}
    clf;
end

%close(v);

eclipseTimes = find(inEclipse);

for j = 1:1:j_max
    for k = 1:1:k_max
        inEclipseList = squeeze(inEclipse(j,k,:));
        thisEclipseTimes = find(inEclipseList);
        this_eclipse=0;
        eclipse_at=eclipseTimes(1);
        eclipse_length=[];
        for m = 1:length(thisEclipseTimes)-1
            if thisEclipseTimes(m)+Ti == thisEclipseTimes(m+1)
                this_eclipse=this_eclipse+Ti;
            else
                eclipse_length=[eclipse_length this_eclipse];
                eclipse_at=[eclipse_at eclipseTimes(m+1)];
                this_eclipse=0;
            end
        end
        eclipse_length=60*[eclipse_length this_eclipse];
        
        max_eclipse(j,k) = max(eclipse_length);
        
        min_eclipse(j,k) = min(eclipse_length);
    end
end

%{
maxEclipse = Ti*max(eclipse_length);
maxEclipseIndex = find(eclipse_length==maxEclipse);
maxEclipseTime = eclipse_at(maxEclipseIndex);

minEclipse = Ti*min(eclipse_length);
minEclipseIndex = find(eclipse_length==minEclipse);
minEclipseTime = eclipse_at(minEclipseIndex);
%}
