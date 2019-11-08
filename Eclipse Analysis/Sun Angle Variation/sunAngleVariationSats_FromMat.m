
%function a = sunAngleVariationSats_FromMat(semMA,eccent,incli,argPeri,longAN)


load("Sat_Coords_1Year_1hRes.mat")

[j_max, k_max, ~] = size(all_location_variables);

r_sat_MCI = zeros(3,1);

r_sun_MCI = zeros(3,1);
oblqEarth = -23.4; % Obliquity of Earth (degs)
a = [];
Ti = 1; % Hours
Tmax = 24*365; % Hours
for i = timelist(1:Ti:Tmax)
    index=find(timelist == i);
    fprintf('%f%% done \n',i*100/timelist(Tmax));
    %%
    % Earth centered ephemeris (J2000/ICRF)
    r_sun_ECI = 1000*planetEphemeris(juliandate(2029,01,1,0,0,i),'Moon','Sun'); 
    % Rotation around x-axis
    rotMatrix = [1 0 0 ; 0 cosd(oblqEarth) -sind(oblqEarth) ; 0 sind(oblqEarth) cosd(oblqEarth)]; 
    % Moon centered ephemeris
    r_sun_MCI = rotMatrix*r_sun_ECI.';
    %%
    % Satellite vector
    for j = 1:1:j_max
        for k = 1:1:k_max
            r_sat_MCI = squeeze(all_location_variables(j,k,:,index));
            %%
            % Calculate angle using dot product
            a(j,k,index) = rad2deg((acos(dot(r_sun_MCI,r_sat_MCI)/(norm(r_sun_MCI)*norm(r_sat_MCI)))));
        end
    end
    
end

for j = 1:1:j_max
    for k = 1:1:k_max
        hold on
        plot(1:Ti:Tmax,squeeze(a(j,k,:)));
        
    end
end
