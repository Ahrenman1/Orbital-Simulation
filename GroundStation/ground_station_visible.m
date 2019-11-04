function y_n = ground_station_visible(Moon_sat_coord, UTC)
    
    Moon_Earth_coord = 1000.*planetEphemeris(juliandate(UTC),'Moon','Earth');
    
    oblqEarth = -23.4; % Obliquity of Earth (degs)
    oblqMoon = 1.54; % Obliquity of Moon (degs)
    rotMatrix = [1 0 0 ; 0 cosd(oblqEarth+oblqMoon) -sind(oblqEarth+oblqMoon) ; 0 sind(oblqEarth+oblqMoon) cosd(oblqEarth+oblqMoon)]; % Rotation around x-axis
    Moon_Earth_coord = (rotMatrix*Moon_Earth_coord.')';
    
    % Moon_sat_coord is Satelite location in xyz from moon frame of referencre;
    % Moon_Earth_coord is Moon location in xyz from moon frame of referencre;
    % UTC is the time at which this check is to be done.

    % A_B_vect is vector from A to B

    
    R_moon=1.7e6; %Please update to accurate value

    %R_s_orb = sqrt(sum(Moon_sat_coord.^2));

    
    Earth_sat_coord=Moon_sat_coord - Moon_Earth_coord;

    %Calculating Earth_Glasg_vect
    glasgow_lla = [55.8642,4.2518,40]; %glasgows long, lat and alt.
    %Convert geodetic latitude, longitude, altitude (LLA) coordinates to Earth-centered inertial (ECI) coordinates:
    Earth_Glasg_coord=lla2eci(glasgow_lla,UTC);
    Moon_Glasg_coord = Moon_Earth_coord+Earth_Glasg_coord;
    Glasg_Sat_Vect=Moon_sat_coord-Moon_Glasg_coord;
    
    
    %testing the satelite is 10deg above glasgow
    if (angle_between(Glasg_Sat_Vect,Earth_Glasg_coord) > 90 )
        y_n = false;
        return
    end
    %{
    else
        y_n = true;
        return
    end
    %}

    
    %testing to see if satelite is in moons shadow form flasgows perspective
    %assuming the "shadow" is a cone.
    
    %THIS IS FALSE AND DOESNT WORK
    
    dist_moon_glasg=sqrt(sum(Moon_Glasg_coord.^2));
    %Half beam width of the Moon shadow cone.
    shadow_ang=acosd(R_moon/dist_moon_glasg);
    
    
    if angle_between(Earth_sat_coord,Moon_Glasg_coord)<=shadow_ang
        y_n = false;
        disp("in moons shadow!")
        return
    end
    %
    %it's passes the tests
    y_n = true;
    return;
end


function deg = angle_between(v1, v2)
    %quick function to calc angle between two vects;
    %uses the dot product
    angle_r = atan2(norm(cross(v1,v2)), dot(v1,v2));
    deg=angle_r*180/pi;
    
    %m1=sqrt(sum(v1.^2));
    %m2=sqrt(sum(v2.^2));

    %deg=acosd(dot(v1,v2)/(m1*m2));
end



