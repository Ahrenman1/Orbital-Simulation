function Coord_Generator(a,e,in,w,omega,t,no,a1,e1,in1,w1,omega1,t1,no1,a2,e2,in2,w2,omega2,t2,no2,a3,e3,in3,w3,omega3,t3,no3,a4,e4,in4,w4,omega4,t4,no4,a5,e5,in5,w5,omega5,t5,no5)
%% defines radius of moon, sphere dimensions, x y and z limits for the plot, and the radius of the sphere
rm = 1737100;

%% defines G*M, as well as the mean motion and period of orbit
u = (6.67*10^-11)*(7.34767*10^22);
n = sqrt(u/a^3);
T = (2*pi)/n;

%% sets up the pertubation variables for the donut orbit
J2 = 2.039e-4;
T1 = (J2*(rm^2))/(a^2);
T2 = 1-((3/2)*((sind(in))^2));
ncorrected = n*(1+(((3/2)*T1)*T2));
incangle = cosd(in);
ascendingnode = (-3/2)*T1*ncorrected*incangle;
disp(ascendingnode)

%% number of periods to analyse and the range of time values to analyse the orbit for
ts = 60*60;
timelist = 0.01:ts:60*60*24*365.25;

%% initialising 'Grand Matrix' to hold all variables for plot
all_location_variables=zeros(6,4,3,length(timelist));
%Six Orbs, 4 Satelites per orbit, 3 coords (x,y,z), and a value for each
%timestep.

%% begins the loop for the defined time
for i = timelist
    %% Percentage done
    disp(100*i/timelist(end));
    
    
    %% initialises each orbit coordinate at 0 elements, then for each satellite in the orbit - the point in space is added to the list  
    coord = [];
    omega = omega + ascendingnode*ts*180/pi;
    for j = 0:no-1
        coords = kep(a,i,t+(T/no)*j,e);
        newco = ref(coords(1),coords(2),in,w,omega);
        coord = [coord; newco'];
    end
    %% same occurs for other six orbits
    coord1 = [];
    omega1 = omega1 + ascendingnode*ts*180/pi;
    for j = 0:no1-1
        coords1 = kep(a1,i,t1+(T/no)*j,e1);
        newco1 = ref(coords1(1),coords1(2),in1,w1,omega1);
        coord1 = [coord1; newco1']; 
    end
    coord2 = [];
    omega2 = omega2 + ascendingnode*ts*180/pi;
    for j = 0:no2-1
        coords2 = kep(a2,i,t2+(T/no)*j,e2);
        newco2 = ref(coords2(1),coords2(2),in2,w2,omega2);
        coord2 = [coord2; newco2'];
    end
    coord3 = [];
    omega3 = omega3 + ascendingnode*ts*180/pi;
    for j = 0:no3-1
        coords3 = kep(a3,i,t3+(T/no)*j,e3);
        newco3 = ref(coords3(1),coords3(2),in3,w3,omega3);
        coord3 = [coord3; newco3'];
    end
    coord4 = [];
    omega4 = omega4 + ascendingnode*ts*180/pi;
    for j = 0:no4-1
        coords4 = kep(a4,i,t4+(T/no)*j,e4);
        newco4 = ref(coords4(1),coords4(2),in4,w4,omega4);
        coord4 = [coord4; newco4'];
    end
    coord5 = [];
    omega5 = omega5 + ascendingnode*ts*180/pi;
    for j = 0:no5-1
        coords5 = kep(a5,i,t5+(T/no)*j,e5);
        newco5 = ref(coords5(1),coords5(2),in5,w5,omega5);
        coord5 = [coord5; newco5'];
    end
     
    %% Saving all the satelite locations:
    loop_iteration = find(timelist == i);
    all_location_variables(1,:,:,loop_iteration)=coord;
    all_location_variables(2,:,:,loop_iteration)=coord1;
    all_location_variables(3,:,:,loop_iteration)=coord2;
    all_location_variables(4,:,:,loop_iteration)=coord3;
    all_location_variables(5,:,:,loop_iteration)=coord4;
    all_location_variables(6,:,:,loop_iteration)=coord5;
    
end

save('Sat_Coords.mat','timelist','all_location_variables');

end
