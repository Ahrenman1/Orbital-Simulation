%% Transfer Time Calculator for the full period
% this script runs the Transfer_time_Calc function for the time period ot
% find the correct arrival times.
t_start = [2029,1,1,0,0,0];
%t_end = [2035,12,31,0,0,0];
t_end = [2029,12,31,0,0,0]; %testing end point

time_vals = [];

time2test = t_start;
while juliandate(time2test) < juliandate(t_end)
    time_vals = [time_vals; Transfer_time_Calc(time2test)];
    %assuming theres 28 days in a lunar month and it occurs 2x / month
    time2test(3) = time_vals(end,3)+14;
end

save('Moon_Capture_Arrival_Times','time_vals');