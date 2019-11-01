function cov = cove(n_pts,no,coord_pos,s,b,c)
%% makes an empty list of points
ls_pts = [];

%% for each slice of the sphere
for k=1:n_pts
   
   %% for each point along the slice
   for j=1:n_pts
       
        %% for each satellite in the orbit
        for f = 1:no
            
           %% check if that point is seen by that satellite
           t_f=check_in_ao_influence([coord_pos(f,1),coord_pos(f,2),coord_pos(f,3)],[s(k,j),b(k,j),c(k,j)]);
           
           %% if it is, add it to the list
           if t_f
               ls_pts=[ls_pts; [s(k,j),b(k,j),c(k,j)]];
           end
        end
    end
end

%% return the list of ponts seen by satellites
cov = ls_pts;