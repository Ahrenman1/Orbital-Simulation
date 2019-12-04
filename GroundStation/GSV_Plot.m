%% GSV TO PLOT Results
%close all;

load("Sat_Coords.mat")
%hidden_array=GSV_2(datenum(2029,1,1),timelist,all_location_variables);

%
plot_style = ["-","--","-.",":"];
for orb_num = 1:6
    figure
    for sat_num = 1:4
        
        hold on;
        plot(timelist./(24*60*60),squeeze(hidden_array(orb_num, sat_num,:)),plot_style(sat_num))

    end
    title(['Glasgow- Satelite Visability - Orbit ', num2str(orb_num)]);
    xlabel("Time (Days) after 01/01/2029");
    ylabel("1=Eath Interference, 2=Moon Interference");
    %temp_str=sprintf("Orbit %d Sat. %d",orb_num,sat_num);
    legend('Sat 1','Sat 2','Sat 3','Sat 4');
end
%}

save('Satelite_Visibility_Array.mat', 'hidden_array')

