%% Function to plot all the Coverage data and find the longest and shortest period of visability. 
close all;
q=1;
legend_text=[];
%uncomment the Q line and plot to plot each satelite. 
for i = 1:6
    legend_text=[];
    for j= 1:4
        figure(i);%(q);q=q+1;
        hold on
        %plot(Day_Array,vis_array(:,i,j)');
        title("Number of Glasgow-Visable Satelites");
        xlabel("Time (Days)")
        ylabel("Satelite Visibile? (1=Yes, 0=No)");
        temp_str=sprintf("Orbit %d Sat. %d",i,j);
        legend_text=[legend_text, temp_str];
    end
    legend(legend_text);
end

%finding the longest window and shortest.
window_long_temp=0;
window_short_temp=0;
window_long_max=0;
window_short_max=0;
for i = 1:6
    for j= 1:4
        window_long=0;
        window_short=0;
        for lv=1:max(size(vis_array))-1
            if vis_array(lv,i,j)&&vis_array(lv+1,i,j)
                window_long=window_long+1;
                
                window_short_temp=max(window_short_temp,window_short);
                window_short=0;
            else
                window_long_temp=max(window_long_temp,window_long);
                window_long=0;
               
                window_short=window_short+1;
            end
        end
        disp(["Orb ", i, " Sat ", j, "short_temp",window_short_temp]);

        window_long_max=max(window_long_temp,window_long_max);
        window_long_temp=0;
        window_short_max=max(window_short_temp,window_short_max);
        window_short_temp=0;
    end
end

