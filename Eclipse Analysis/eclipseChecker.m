function inEclipse = eclipseChecker(satCoords,tStep,tMax,t0Year,t0Month,t0Day,t0Hour,t0Minute,checkSatEclipse,checkLunarEclipse,enPlotting,enVideo)

    % satCoords, generated using Constellation_Generator.m, 1x1 Struct containing:
    %   timelist: time array
    %   all_location_variables: 4-D double (plane,satellite,dimension,time)
    % tStep = time step [in resolution of satCoords.timelist]
    % tMax = time to stop checking [as with tStep]
    % checkLunarEclipse: boolean value, check for Lunar eclipses
    % enPlotting: boolean value, enables scatter plot of satellite points
    % enVideo: boolean value, enable saving of animation to video.avi

    if enPlotting
        clf;
        colour = hsv(6);
    end
    if enVideo
        v = VideoWriter('video.avi');
        v.FrameRate = 30;
        open(v);
    end

    Rm = 1.7e6; % Moon radius
    Re = 6.371e6; % Earth radius

    [j_max, k_max, ~] = size(satCoords.all_location_variables);

    oblqEarth = -23.4; % Obliquity of Earth (degs)
    rotMatrix = [   1       0                         0                           ;...
                    0       cosd(oblqEarth)  -sind(oblqEarth)   ;...
                    0       sind(oblqEarth)  cosd(oblqEarth)]   ; % Rotation around x-axis

    inEclipse = [];
    
    Ti = tStep;
    Tmax = tMax;
    trailThreshold = 200;
    tRemainString = '-';
    tElapsed = 0;
    tElapsedTotal = 0;
    for i = satCoords.timelist(1:Ti:Tmax)
        index=find(satCoords.timelist == i);
        tStart = tic;
        tElapsedTotal = tElapsed + tElapsedTotal;

        timeJulian = juliandate(t0Year,t0Month,t0Day,t0Hour,t0Minute,i);

        timestamp = datetime(timeJulian,'convertfrom','juliandate');
        fprintf('%f%% done.\t',i*100/satCoords.timelist(Tmax));
        fprintf('Elapsed:%s\t',datestr(tElapsedTotal/(60*60*24),'HH:MM:SS'));
        fprintf("Approx %s remaining.\t",tRemainString);
        fprintf('%s\n',timestamp);
        
        if checkLunarEclipse
            r_earth_ECI = 1000*planetEphemeris(timeJulian,'Moon','Earth');
            r_earth_MCI = rotMatrix*r_earth_ECI.';
        end
        r_sun_ECI = 1000*planetEphemeris(timeJulian,'Moon','Sun'); % Earth centered ephemeris (J2000/ICRF)
        r_sun_MCI = rotMatrix*r_sun_ECI.';
        
        %% Draw Moon sphere, Sun and Earth vector arrows
        if enPlotting
            hold on;
            axis equal;
            axis([-7e6,7e6,-7e6,7e6,-7e6,7e6]);
            set(gcf, 'Position', [50 50 800 800]);
            view(3);
            title(datestr(timestamp));
            sunLine = mArrow3([0,0,0],r_sun_MCI.','color',[1,0.65,0]);
            if checkLunarEclipse
                earthLine = mArrow3([0,0,0],r_earth_MCI.','color','b');
            end
            [sx,sy,sz]=sphere;
            h=surf(sx*Rm,sy*Rm,sz*Rm,'FaceColor',[0.9,0.9,0.9]);
            [cx,cy,cz] = cylinder2(Rm,r_sun_MCI);
            cx(2, :) = -r_sun_MCI(1);
            cy(2, :) = -r_sun_MCI(2);
            cz(2, :) = -r_sun_MCI(3);
            cylinder = surf(cx,cy,cz,'FaceAlpha',0.5,'FaceColor',[0 0 0]);
        end
        %% Multisat
        for j = 1:1:j_max
            for k = 1:1:k_max
                r_sat = squeeze(satCoords.all_location_variables(j,k,:,index));
                if checkLunarEclipse
                    r_sat_earth = r_earth_MCI - r_sat;
                    r_sat_sun = r_sun_MCI - r_sat;
                end
                if enPlotting
                    sat_pt = zeros(j,k);
                    if index <= trailThreshold
                        x_trail=squeeze(satCoords.all_location_variables(j,k,1,1:index));
                        y_trail=squeeze(satCoords.all_location_variables(j,k,2,1:index));
                        z_trail=squeeze(satCoords.all_location_variables(j,k,3,1:index));
                    else
                        x_trail=squeeze(satCoords.all_location_variables(j,k,1,index-trailThreshold:index));
                        y_trail=squeeze(satCoords.all_location_variables(j,k,2,index-trailThreshold:index));
                        z_trail=squeeze(satCoords.all_location_variables(j,k,3,index-trailThreshold:index));
                    end
                    plot3(x_trail,y_trail,z_trail,'Color',colour(j,:));
                end
                %% Eclipse check
                if dot(r_sat,r_sun_MCI)<=0
                    if norm(cross(r_sat,(r_sun_MCI/norm(r_sun_MCI))))<=Rm
                        if checkSatEclipse
                            inEclipse(j,k,index) = true;
                            fprintf('Plane %i, Sat %i\t',j,k);
                            fprintf('Satellite Eclipse!\n');
                        end
                        if enPlotting
                            sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
                        end
                    else
                        if checkLunarEclipse
                            if dot(r_sat_earth,r_sat_sun)>0
                                if norm(cross(r_sat_earth,(r_sat_sun/norm(r_sat_sun))))<=Re
                                    inEclipse(j,k,index) = true;
                                    fprintf('Plane %i, Sat %i\t',j,k);
                                    fprintf('Lunar Eclipse!\n');
                                    if enPlotting
                                        sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
                                    end
                                else
                                    inEclipse(j,k,index) = false;
                                    if enPlotting
                                        sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                                    end
                                end
                            else
                                inEclipse(j,k,index) = false;
                                if enPlotting
                                    sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                                end
                            end
                        else
                            if enPlotting
                                sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                            end
                        end
                    end
                else
                    if checkLunarEclipse
                        if dot(r_sat_earth,r_sat_sun)>0
                            if norm(cross(r_sat_earth,(r_sat_sun/norm(r_sat_sun))))<=Re
                                inEclipse(j,k,index) = true;
                                fprintf('Plane %i, Sat %i\t',j,k);
                                fprintf('Lunar Eclipse!\n');
                                if enPlotting
                                    sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'r','filled');
                                end
                            else
                                inEclipse(j,k,index) = false;
                                if enPlotting
                                    sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                                end
                            end
                        else
                            inEclipse(j,k,index) = false;
                            if enPlotting
                                sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                            end
                        end
                    else
                        if enPlotting
                            sat_pt(j,k) = scatter3(r_sat(1),r_sat(2),r_sat(3),50,'g','filled');
                        end
                    end
                end
            end   
        end

        if enPlotting
            pause(0.001);
            if enVideo
                frame=getframe(gcf);
                writeVideo(v,frame);
            end
            clf;
        end

        tElapsed = toc(tStart);
        tRemainString = datestr(tElapsed*(numel(satCoords.timelist(1:Tmax))-index)/(60*60*24*Ti), 'HH:MM:SS');
    end
    if enVideo
        close(v);
    end
end
