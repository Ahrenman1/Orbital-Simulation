%% Script for plotting graphs from the 4D Master Variable
close all
figure
hold on

%% Moon Values
rm = 1737100;
[s,b,c]=sphere(50);
lim = 7e6;
s=s.*rm;
b=b.*rm;
c=c.*rm;

%% incrementing view
ang = 0;

colour = hsv(6); %to hold the 6 different colours
%% initialising frame variabe for video
vid_file = VideoWriter('post_simulation4.avi');
open(vid_file);

max_val=7e6;
xlim([-max_val max_val]) 
ylim([-max_val max_val])
zlim([-max_val max_val]) 
for timestep = 1:length(all_location_variables)
    clf
    for orbit_number = 1:6
        for satelite_num = 1:4
            X=all_location_variables(orbit_number,satelite_num,1,timestep);
            Y=all_location_variables(orbit_number,satelite_num,2,timestep);
            Z=all_location_variables(orbit_number,satelite_num,3,timestep);
            scatter3(X,Y,Z,20,colour(orbit_number,:),'Filled');
            hold on
            x_trail=squeeze(all_location_variables(orbit_number,satelite_num,1,1:timestep));
            y_trail=squeeze(all_location_variables(orbit_number,satelite_num,2,1:timestep));
            z_trail=squeeze(all_location_variables(orbit_number,satelite_num,3,1:timestep));
            plot3(x_trail,y_trail,z_trail,'Color',colour(orbit_number,:));
            hold on
            
        end
    end
    
    %% fixing the limits
    xlim([-max_val max_val]) 
    ylim([-max_val max_val])
    zlim([-max_val max_val]) 
    view(ang, 30); ang= ang+1;
    %% plotting the moon
    moon=surf(s,b,c);
    moon.EdgeColor = 'none';
    colormap(gray);
    hold on
    %% For frame
    frame = getframe(gcf); %temp Vairable
    writeVideo(vid_file,frame);
end

close(vid_file);
disp('Done!')