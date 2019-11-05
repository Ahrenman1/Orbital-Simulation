%% Updated Version of "Ground_Station_Visable" for the MTR
% This functon operates using an updated .mat file (Sat_Coords.mat) from the coverage.m fucntion.
% This function returns a matrix for each satelite with:
% - visible = 0
% - blockeb by earth = 1
% - blocked by moon = 2
% 
% thus will accurately return the answer to the boolian question
% "is this bloocked?" 
% 
% Further, it also will save file which includes the location of earth in the MCI frame for future plotting.


function y_n_array = GSV_2(t_0,time_vect,position_array)
%where the following are:
% - t_0 is initial time of the orbits (in datenum)
% - time_vect is vector of time (in seconds) after t_0
% - position_array is the array vector saved as "Sat_Array.mat" in
% coverage.m
% - y_n_array is the array with the data from each satelite at each time
% point with whether its visible or not.

% Converting To Datenum Vector
% 1 day is 1 in datenum thus 1s = 1/24*60*60 in datnum
date_vect=time_vect./(24*60*60) + t_0;

%converting to Datetime
datetime_vect = datetime(date_vect,'convertfrom','datenum'); 

%converting to UTC Vect
UTC=[datetime_vect.Year' datetime_vect.Month' datetime_vect.Day' datetime_vect.Hour' datetime_vect.Minute' datetime_vect.Second'];

% Moon Radius
R_moon=1.7e6; %Please update to accurate value

%Calculating Earth_Glasg_vect which is constant in the ECR Frame
glasgow_lla = [55.8642,4.2518,40]; %glasgows long, lat and alt.

% Creating A Moon-Earth Vector Variabel To save for later plotting
ME_Vect=zeros(3,length(time_vect));

%initialising y_n_array
y_n_array = zeros(6,4,length(time_vect));

%looping through each time
for loop_time_ind=1:length(time_vect)
    
    loop_time = UTC(loop_time_ind,:);
    % Getting Earth Coords (or moon coords Relitive to earth)
    Moon_Earth_coord = 1000.*planetEphemeris(juliandate(loop_time),'Moon','Earth');
    Moon_Earth_coord = Moon_Earth_coord';
    
    % Calulating Earth Pos Rel to MOON INERTIAL FRAME
    oblqEarth = -23.4; % Obliquity of Earth (degs)
    oblqMoon = 1.54; % Obliquity of Moon (degs)
    rotMatrix = [1 0 0 ; 0 cosd(oblqEarth+oblqMoon) -sind(oblqEarth+oblqMoon) ; 0 sind(oblqEarth+oblqMoon) cosd(oblqEarth+oblqMoon)]; % Rotation around x-axis
    Moon_Earth_vect = (rotMatrix*Moon_Earth_coord);
    
    % Saving the Moon Earth Vector
    % Check the Moon_Earth_vect is a vertical 1x3 vector
    ME_Vect(:,loop_time_ind) = Moon_Earth_vect;
    
    %Convert geodetic latitude, longitude, altitude (LLA) coordinates to Earth-centered inertial (ECI) coordinates:
    Earth_Glasg_vect=lla2eci(glasgow_lla,loop_time)';

    %calculating vectors for glasgoe
    Moon_Glasg_vect = Moon_Earth_vect+Earth_Glasg_vect;
    
    position_slice = squeeze(position_array(:,:,:,loop_time_ind));
    
    % Satelite Specific Stuff:
    for orb_num = 1:6
        for sat_num = 1:4
            
            Moon_sat_coord = squeeze(position_slice(orb_num,sat_num,:));
            
            % Check the vectors for position are vertical vectors
            Glasg_Sat_Vect=Moon_sat_coord-Moon_Glasg_vect;
            %Earth_sat_vect=Moon_sat_coord - Moon_Earth_vect;
            
            %checking to see the satelite is above the horison
            if (angle_between(Glasg_Sat_Vect,Earth_Glasg_vect) > 90 )
                break
            end
            
            % testing to see if satelite is in moons shadow form flasgows perspective
            % assuming the "shadow" is a cone.

            %THIS SHOULD WORK

            dist_moon_glasg=sqrt(sum(Moon_Glasg_vect.^2));
            %Half beam width of the Moon shadow cone.
            shadow_ang=atand(R_moon/dist_moon_glasg);
            
            
            %calculating angle betwene the Glasg -> Sat vector and
            %                          the Glasg -> Moon vect
            % Glasg -> Moon is -ve Moon -> Glasg Vect.
            sat_ang = angle_between(Glasg_Sat_Vect,-Moon_Glasg_vect);

            if sat_ang<=shadow_ang
                disp("in moons shadow!")
                y_n_array(orb_num,sat_num,loop_time_ind) = 2;
                break
            end
            
            
            % if it passes both tests then set the array to true
            y_n_array(orb_num,sat_num,loop_time_ind) = 1;
            
            
            
        end
    end
end

save('Earth_Pos_Array', 'ME_Vect');
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