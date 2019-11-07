%% GSV Find Times
% this script was written to find the timings of visibility and non
% visibility of the satelites

load("Sat_Coords.mat");
load("Satelite_Visibility_Array.mat");

dt = timelist(2) - timelist(1);

longest_visible_time_array = zeros(6,4);
longest_obsuced_time_array = zeros(6,4);
longest_moonhid_time_array = zeros(6,4);

for On = 1:6
    for Sn= 1:4
        short_list=squeeze(hidden_array(On,Sn,:));
        M_interups=short_list==2;

            % will keep checking longer lists until it fails
            for list_length = 1:length(short_list)
               test_str=ones(list_length,1);
               %checking to see if theres an occurence of the strings of 1
               if isempty(strfind(M_interups',test_str')) %#ok<STREMP>
                   break
               end
            end
        %Shorten the length by one as this is the "failing" lengtth
        moon_hiding = dt*(list_length-1)/3600;
        
        %adding it to an array for storage
        longest_moonhid_time_array(On,Sn)=moon_hiding;
        
        % For Any Oscuration
        Any_interups=short_list>0;
        % will keep checking longer lists until it fails
            for list_length = 1:length(short_list)
               test_str=ones(list_length,1);
               %checking to see if theres an occurence of the strings of 1
               if isempty(strfind(Any_interups',test_str')) %#ok<STREMP>
                   break
               end
            end
        %Shorten the length by one as this is the "failing" lengtth
        total_hiding = dt*(list_length-1)/3600;
        
        %adding it to an array for storage
        longest_obsuced_time_array(On,Sn)=total_hiding;
        
        %Longest Visible times
        No_interups=short_list==0;
                % will keep checking longer lists until it fails
            for list_length = 1:length(short_list)
               test_str=ones(list_length,1);
               %checking to see if theres an occurence of the strings of 1
               if isempty(strfind(No_interups',test_str')) %#ok<STREMP>
                   break
               end
            end
        %Shorten the length by one as this is the "failing" lengtth
        non_hiding = dt*(list_length-1)/3600;
        
        %adding it to an array for storage
        longest_visible_time_array(On,Sn)=non_hiding;
    end
end

save("Satelite_Visibility_Times.mat",'longest_moonhid_time_array', ...
'longest_obsuced_time_array','longest_visible_time_array')

disp(['Max Hidden  Time = ' num2str(max(longest_obsuced_time_array,[],'all'))]);
disp(['Max Visible Time = ' num2str(max(longest_visible_time_array,[],'all'))]);
disp(['Max Moonhid Time = ' num2str(max(longest_moonhid_time_array,[],'all'))]);
