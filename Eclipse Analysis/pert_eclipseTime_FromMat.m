%function eclipseTime = eclipseTime()

Rm = 1.7e6; % Moon radius
Re = 6.371e6; % Earth radius


load("Sat_Coords_30Day_1mRes.mat")

[j_max, k_max, ~] = size(all_location_variables);

oblqEarth = -23.4; % Obliquity of Earth (degs)
rotMatrix = [   1       0                         0                           ;...
                0       cosd(oblqEarth)  -sind(oblqEarth)   ;...
                0       sind(oblqEarth)  cosd(oblqEarth)]   ; % Rotation around x-axis

inEclipse = [];

Ti = 1; % Minutes
Tmax = 60*24; % Minutes
trailThreshold = 100;
tRemainString = '-';
tElapsed = 0;
tElapsedTotal = 0;
for i = timelist(1:Ti:Tmax)
    index=find(timelist == i);
    tStart = tic;
    tElapsedTotal = tElapsed + tElapsedTotal;
    
    %timeJulian = juliandate(2029,1,1,0,0,i);
    timeJulian = juliandate(2029,6,25,22,0,i);
    %timeJulian = juliandate(2030,12,9,18,0,i);
    
    timestamp = datetime(timeJulian,'convertfrom','juliandate');
    fprintf('%f%% done.\t',i*100/timelist(Tmax));
    fprintf('Elapsed:%s\t',datestr(tElapsedTotal/(60*60*24),'HH:MM:SS'));
    fprintf("Approx %s remaining.\t",tRemainString);
    fprintf('%s\n',timestamp);
    
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
                    fprintf('Satellite Eclipse!\n');
                else
                    if dot(r_sat_earth,r_sat_sun)>0
                        if norm(cross(r_sat_earth,(r_sat_sun/norm(r_sat_sun))))<=Re
                            inEclipse(j,k,index) = true;
                            fprintf('Plane %i, Sat %i\t',j,k);
                            fprintf('Lunar Eclipse!\n');
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
                        fprintf('Plane %i, Sat %i\t',j,k);
                        fprintf('Lunar Eclipse!\n');
                    else
                        inEclipse(j,k,index) = false;
                    end
                else
                    inEclipse(j,k,index) = false;
                end
            end
        end   
    end
    
    tElapsed = toc(tStart);
    tRemainString = datestr(tElapsed*(numel(timelist(1:Tmax))-index)/(60*60*24*Ti), 'HH:MM:SS');
end

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

