%function eclipseTime = eclipseTime()
tic
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
        
inEclipse = [];
Ti = 1; % Minutes
Tmax = 60*24*30; % Minutes
for i = timelist(1:Ti:Tmax)
    index=find(timelist == i);
    
    timeJulian = juliandate(2029,1,1,0,0,i);
    %timeJulian = juliandate(2029,12,20,18,0,i);
    %timeJulian = juliandate(2030,12,9,18,0,i);
    timestamp = datetime(timeJulian,'convertfrom','juliandate');
    disp(timestamp);
    fprintf('%f%% done \n',i*100/timelist(Tmax));
    r_earth_ECI = 1000*planetEphemeris(timeJulian,'Moon','Earth');
    r_sun_ECI = 1000*planetEphemeris(timeJulian,'Moon','Sun'); % Earth centered ephemeris (J2000/ICRF)
    r_sun_MCI = rotMatrix*r_sun_ECI.';
    r_earth_MCI = rotMatrix*r_earth_ECI.';
    %% Multisat
    for j = 1:1:j_max
        for k = 1:1:k_max
            r_sat = squeeze(all_location_variables(j,k,:,index));
            r_sat_earth = r_earth_MCI - r_sat;
            r_sat_sun = r_sun_MCI - r_sat;
            
            
            %% Eclipse check
            if dot(r_sat,r_sun_MCI)<=0
                if norm(cross(r_sat,(r_sun_MCI/norm(r_sun_MCI))))<=Rm
                    inEclipse(j,k,index) = true;
                    disp('sat eclipse!');
                else
                    if dot(r_sat_earth,r_sat_sun)>0
                        if norm(cross(r_sat_earth,(r_sat_sun/norm(r_sat_sun))))<=Re
                            inEclipse(j,k,index) = true;
                            disp('lunar eclipse!');
                        else
                            inEclipse(j,k,index) = false;
                        end
                    else
                        inEclipse(j,k,index) = false;
                    end
                end
            else
                if dot(r_sat_earth,r_sat_sun)>0
                    if norm(cross(r_sat_earth,(r_sat_sun/norm(r_sat_sun))))<=Re
                        inEclipse(j,k,index) = true;
                        disp('lunar eclipse!');
                    else
                        inEclipse(j,k,index) = false;
                    end
                else
                    inEclipse(j,k,index) = false;
                end
            end
        end   
    end
    
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
toc