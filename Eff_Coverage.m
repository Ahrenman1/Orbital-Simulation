%% Eff_Coverage
% this function was written to make the coverage calculations easier to
% parrallelise (and thus hopefully quicker).
%
% It takes the satelite vectors calculated from Coord_Generator.
% 
% This function works by taking every point in the moon sized sphere and
% calculating how many satteltites it can see.
%
% The returning array is the same moon sphere but with a value for each
% point.

function sats_visible = Eff_Coverage(sat_mat)

    %% Coords For Moon Sphere
    rm = 1737100;
    [s,b,c]=sphere(50);
    s=s.*rm;
    b=b.*rm;
    c=c.*rm;

    [sp_a, sp_b] = size(s); %returns the dimentions of the sphere arrays.

    %%% Taking size of the sats_mat for number of orbs, sats/orb, and the sim
    %%% lenght:
    [orbs,sats,~,sim_length] = size(sat_mat);

    %%% initialising the answer varirable
    sats_visible = zeros(sp_a,sp_b,sim_length);

    for lv_a = 1:length(sp_a)
        for lv_b = 1:length(sp_b)
            
            %preventing broadcast variables
            moon_x_coord = s(lv_a,lv_b);
            moon_y_coord = b(lv_a,lv_b);
            moon_z_coord = c(lv_a,lv_b);
            
            parfor sim_step = 1:sim_length
                %%% Within this loop it will iterate over every value within the
                %%% sphere.
                moon_coord = [moon_x_coord;moon_y_coord;moon_z_coord]; %Moon Point vect

                sats_visib_bool = zeros(orbs,sats); %bool matrix to hold whether satelites are visible.

                for orb = 1:orbs
                    % orb is current_orbit, orbs is total orbits
                    for sat = 1:sats
                        % sat is current_sat, sats is total sats per orbit.

                        %%% Within this loop iterate for each satelite individually



                        % This code runs for every sat in every simulation
                        % step.
                        sat_vector = squeeze(sat_mat(orb,sat,:,sim_step));
                        %temp bool is jsut to split the code into 2 lines
                        if check_in_ao_influence(sat_vector,moon_coord)
                            sats_visib_bool(orb,sat) = 1;
                        end
                    end
                end
                sats_visible(lv_a,lv_b,sim_step)=sum(sats_visib_bool,'all');
            end
        end
    end
    
    
end

