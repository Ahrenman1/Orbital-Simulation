
day_0=datenum(2019,1,1);

Day_interval=1/(24*60*6);
Day_Array=0:Day_interval:4;

%orbit inclinations
O_incs=[0 90 55 125 55 125];

%orbit OMEGAs LoAN
O_omegas=[0 0 60 120 240 300];

visible_sat_array=zeros(length(Day_Array),1);

disp("re-running wiht the correct paramiters");
tic
%

vis_array=zeros(length(Day_Array),6,4);
peri=[0 90 180 270];
parfor i = 1:length(Day_Array)
    visible_sats=0;
    
    time=day_0+Day_Array(i);
    t = datetime(time,'convertfrom','datenum');

    %looping over each orbit
    for lv=1:6
        %looping for each of the four satelites in the orbit
        for lv_p=1:4
            %the t value might need to be "i".
            sat_pos=orb_with_ext_time_dunc(6.609e6,0,O_incs(lv),peri(lv_p),O_omegas(lv),t);
            groundStationView = ground_station_visible(sat_pos',[t.Year t.Month t.Day t.Hour t.Minute t.Second]);
            vis_array(i,lv,lv_p)=groundStationView;
            if groundStationView
                visible_sats = visible_sats+1;
            end
        end
    end
    
    %disp(["Time = ", datestr(t), ", Visibel Sats = ", num2str(visible_sats)])
    visible_sat_array(i)=visible_sats;

    %r_sat = orb_with_ext_time_dunc(6.6e6,0,90,90,0,i);

    %testing to see if glasgow is visible
    %groundStationView = ground_station_visible(r_sat.',[t.Year t.Month t.Day t.Hour t.Minute t.Second]);
    
    %if groundStationView
    %    disp(t);
    %end
end
%
toc

%simulate the whole of the 23rd jan in the am.

figure(1)
plot(Day_Array,visible_sat_array);
