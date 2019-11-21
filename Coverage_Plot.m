%% Coverage_Plot
%this is a function which plots coverage

function Coverage_Plot(sat_mat, sats_visib_mat)
    figure
    clf
    view(3)
    %%% Taking size of the sats_mat for number of orbs, sats/orb, and the sim
    %%% lenght:
    [orbs,~,~,sim_length] = size(sat_mat);
    orb_col = hsv(orbs+1);
    
    %need to get the maximum number of visible satelites.
    visib_col = hsv(13);
    
    for sim_step = 584%1:sim_length
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
        [s_false,b_false,c_false]=sphere(50);
        s_false=s_false.*rm;
        b_false=b_false.*rm;
        c_false=c_false.*rm;
        surf(s_false,b_false,c_false);
        colormap(gray);
        
        % Plotting the Meeting Points
        rm = 1737100;
        [s,b,c]=sphere(50);
        Xsp=reshape(s.*rm,1,[]);
        Ysp=reshape(b.*rm,1,[]);
        Zsp=reshape(c.*rm,1,[]);
        S_vis = reshape(sats_visib_mat(:,:,sim_step),1,[]);
        %the plus one is in case any point cant see a satelite
        Dot_col = visib_col(S_vis+1,:);
        
        %plotting visible points w/ colors
        hold on
        scatter3(Xsp,Ysp,Zsp,4,Dot_col,'filled');


    end
    
    
    
end