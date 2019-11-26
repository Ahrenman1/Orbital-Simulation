%% Transfer_Times
% this function is to calcualte the times to arrive at the moon.
function Time_out = Transfer_time_Calc(time,depth)

    %implementing a depth check as this is a recursive function for the
    %calulations
    if ~exist('depth','var')
         % third parameter does not exist, so default it to something
          depth = 0;
     end
    if depth > 100
        error('Couldnt find a value in avalible depth');
    end

    % Finding value
    [Pos, Vel] = planetEphemeris(juliandate(time(1),time(2),time(3),time(4),time(5),time(6)),'Earth','Moon');
    
    % Assuming the z is normal to the equitorial plane.
    % if its not then this is where the transofrmation needs to occur.

    % if the value is less than a this val above/below the horison
    % Adjust it for accuracy reasons.
    if abs(Pos(3)) <= 1e-3
        Time_out = time;
    else
        %applying the newton ralphson method
        dt = Pos(3)/Vel(3);
        new_time = time;
        new_time(end)= new_time(end) - dt ;
        %minus because if x(t) and x'(t) are the same then the time need to go
        %back
        
        %disp(depth) %for Debugging
        
        %recursive function to iterate through the values.
        Time_out = Transfer_time_Calc(new_time,depth+1);
    end

end
    
