%% Coverage_Plot
%this is a function which plots coverage

function Coverage_Plot(sat_mat)%, sats_visib_mat)
    figure
    clf
    view(3)
    %%% Taking size of the sats_mat for number of orbs, sats/orb, and the sim
    %%% lenght:
    [orbs,~,~,sim_length] = size(sat_mat);
    orb_col = hsv(orbs+1);
    for sim_step = 1:sim_length
        %%% Plotting The Satellites
        for orb = 1:orbs
                sats_snapshot = squeeze(sat_mat(orb,:,:,sim_step));
                sats_x=sats_snapshot(:,1);
                sats_y=sats_snapshot(:,2);
                sats_z=sats_snapshot(:,3);
                scatter3(sats_x,sats_y,sats_z,'filled','MarkerFaceColor',orb_col(orb,:));
                hold on
        end
        
        % Plotting the Sphere surface with a smaller radius for show
        rm = 1.6e6;
        [s,b,c]=sphere(50);
        s=s.*rm;
        b=b.*rm;
        c=c.*rm;
        surf(s,b,c);
        colormap(gray);
        
        % Plotting the Meeting Points
        

    end
    
    
    
end