function coverage(a,e,in,w,omega,t,no,a1,e1,in1,w1,omega1,t1,no1,a2,e2,in2,w2,omega2,t2,no2,a3,e3,in3,w3,omega3,t3,no3,a4,e4,in4,w4,omega4,t4,no4,a5,e5,in5,w5,omega5,t5,no5)
%% clears any previous figures
clf
hold on
%% defines radius of moon, sphere dimensions, x y and z limits for the plot, and the radius of the sphere
rm = 1737100;
[s,b,c]=sphere(50);
lim = 7e6;
s=s.*rm;
b=b.*rm;
c=c.*rm;

%% initiates lists for plotting coverage after the loop
perlist654 = [];
perlist65 = [];
perlist6 = [];

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

%% finds the number of points to be analysed on each slice of the sphere
n_pts=length(s);

%% viewing angles for the plot, the number of periods to analyse and the range of time values to analyse the orbit for
az = 45;
el = 45;
per = 3;
ts = per*T/1000;
timelist = 0.01:ts:per*T/2;

%% initialising frame variabe for video
vid_file = VideoWriter('simulation.avi');
open(vid_file);

%% initialising 'Grand Matrix' to hold all variables for plot
all_location_variables=zeros(6,4,3,length(timelist));
%Six Orbs, 4 Satelites per orbit, 3 coords (x,y,z), and a value for each
%timestep.

%% begins the loop for the defined time
for i = timelist

    %% initialises the list of points for each iteration at 0 elements
    ls_pts=[];
    
    %% clears previous plot, turns the grid on and sets the view to the previously defined angles
    clf
    grid on
    hold on
    view(45,45)
    
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
    
    %% checks every point on the sphere for each satellite and adds the seen points to a list
    or = cove(n_pts,no,coord,s,b,c);
    ls_pts = [ls_pts ;or];
    or1 = cove(n_pts,no1,coord1,s,b,c);
    ls_pts = [ls_pts ;or1];
    or2 = cove(n_pts,no2,coord2,s,b,c);
    ls_pts = [ls_pts ;or2];
    or3 = cove(n_pts,no3,coord3,s,b,c);
    ls_pts = [ls_pts ;or3];
    or4 = cove(n_pts,no4,coord4,s,b,c);
    ls_pts = [ls_pts ;or4];
    or5 = cove(n_pts,no5,coord5,s,b,c);
    ls_pts = [ls_pts ;or5];
    
    %% as long as at least one point is seen, the number of unique rows in the ls_pts array is extracted, with the number of appearances going in a new column
    if length(ls_pts)>0
        [lsu,ia,ic] = unique(ls_pts, 'rows', 'stable'); 
        h = accumarray(ic, 1);
        maph = h(ic);
        listwithocc = [ls_pts,maph];
        unpnts = unique(listwithocc,'rows');
        
        %% initialises the arrays which will hold the points that are seen by the corresponding number of satellites (i.e. onemat holds all the points seen by one satellite)
        onemat = [];
        twomat = [];
        threemat = [];
        fourmat = [];
        fivemat = [];
        sixmat = [];
        
        %% finds the indexes of all the points that contain the corresponding number of satellites seen
        oneov = find(unpnts(:,4)==1);
        twoov = find(unpnts(:,4)==2);
        threeov = find(unpnts(:,4)==3);
        fourov = find(unpnts(:,4)==4);
        fiveov = find(unpnts(:,4)==5);
        sixov = find(unpnts(:,4)>=6);
        
        
        %% for all the indexes, the matrices are added to by the points which have the number of satellites seeing them
        parfor ov = 1:length(oneov)-1
            index = oneov(ov);
            rowov = unpnts(index,:);
            onemat = [onemat; rowov];
        end
        parfor ov = 1:length(twoov)-1
            index = twoov(ov);
            rowov = unpnts(index,:);
            twomat = [twomat; rowov];
        end
        parfor ov = 1:length(threeov)-1
            index = threeov(ov);
            rowov = unpnts(index,:);
            threemat = [threemat; rowov];
        end
        parfor ov = 1:length(fourov)-1
            index = fourov(ov);
            rowov = unpnts(index,:);
            fourmat = [fourmat; rowov];
        end
        parfor ov = 1:length(fiveov)-1
            index = fiveov(ov);
            rowov = unpnts(index,:);
            fivemat = [fivemat; rowov];
        end
        parfor ov = 1:length(sixov)-1
            index = sixov(ov);
            rowov = unpnts(index,:);
            sixmat = [sixmat; rowov];
        end
        
        %% finds the number of rows (i.e. points) that are seen by 4,5 and 6 ; 5 and 6 ; and just 6
        [row654,column11] = size([fourmat;fivemat;sixmat]);

        [row65,column11] = size([fivemat;sixmat]);

        [row6,column11] = size([sixmat]);
        
        %% percentage coverage by at least 4 satellites is calculated and added to an array
        percov654 = ((row654/((n_pts-1).^2))*100)+2;
        perlist654 = [perlist654 percov654];
        
        %% same for at least 5
        percov65 = ((row65/((n_pts-1).^2))*100)+2;
        perlist65 = [perlist65 percov65];
        
        %% same for at least 6
        percov6 = ((row6/((n_pts-1).^2))*100)+2;
        perlist6 = [perlist6 percov6];
        
        %% plots the moon sphere
        plot3(s,b,c,'ob')
        hold on
        
        %% plots the points seen by one satellite in blue
        [n1,m1] = size(onemat);
        if n1 > 0
            plot3(onemat(:,1),onemat(:,2),onemat(:,3),'b.')
            disp('Less than 4')
        end
        hold on
        
        %% plots the points seen by two satellites in red
        [n2,m2] = size(twomat);
        if n2 > 0
            plot3(twomat(:,1),twomat(:,2),twomat(:,3),'r.')
            disp('Less than 4')
        end
        hold on
        
        %% etc
        [n3,m3] = size(threemat);
        if n3 > 0
            plot3(threemat(:,1),threemat(:,2),threemat(:,3),'k.')
            disp('Less than 4')
        end
        hold on
        [n4,m4] = size(fourmat);
        if n4 > 0           
            plot3(fourmat(:,1),fourmat(:,2),fourmat(:,3),'g.')
        end
        hold on
        [n5,m5] = size(fivemat);
        if n5 > 0
            plot3(fivemat(:,1),fivemat(:,2),fivemat(:,3),'c.')
        end
        hold on
        [n6,m6] = size(sixmat);
        if n6 > 0
            plot3(sixmat(:,1),sixmat(:,2),sixmat(:,3),'m.')
        end
        hold on
        
        %% plots all the satellites in orbit 
        for v = 1:no
            scatter3(coord(v,1),coord(v,2),coord(v,3),'b','filled')
            hold on
        end
        hold on
        for v = 1:no1
            scatter3(coord1(v,1),coord1(v,2),coord1(v,3),'g','filled')
            hold on
        end

        for v = 1:no2
            scatter3(coord2(v,1),coord2(v,2),coord2(v,3),'r','filled')
            hold on
        end

        for v = 1:no3
            scatter3(coord3(v,1),coord3(v,2),coord3(v,3),'y','filled')
            hold on
        end
        
        for v = 1:no4
            scatter3(coord4(v,1),coord4(v,2),coord4(v,3),'c','filled')
            hold on
        end

        for v = 1:no5
            scatter3(coord5(v,1),coord5(v,2),coord5(v,3),'m','filled')
            hold on
        end
        
        %% sets the axis limits defined earlier
        xlim([-1*lim lim])
        ylim([-1*lim lim])
        zlim([-1*lim lim])
        drawnow
        
    end  
    hold on
    %pbaspect([1 1 1])
    %% updates the viewing angle to give a rounded view
    %az = az + 3;
    
    %% For frame
    frame = getframe(gcf); %temp Vairable
    writeVideo(vid_file,frame);
    
    %% Saving all the satelite locations:
    loop_iteration = find(timelist == i);
    all_location_variables(1,:,:,loop_iteration)=coord;
    all_location_variables(2,:,:,loop_iteration)=coord1;
    all_location_variables(3,:,:,loop_iteration)=coord2;
    all_location_variables(4,:,:,loop_iteration)=coord3;
    all_location_variables(5,:,:,loop_iteration)=coord4;
    all_location_variables(6,:,:,loop_iteration)=coord5;
    
end
%% Exporing video file
close(vid_file);

%% plots the percentage coverage arrays against time in different colours
figure(2)
plot(timelist,perlist654,'g','Linewidth',3);
hold on
plot(timelist,perlist65,'b-','Linewidth',1);
hold on
plot(timelist,perlist6,'r','Linewidth',3);
hold on

%% adds a vertical line indicating a period has passed by on the graph
for lv = 1:per
    xline(lv*T,'k:','Linewidth',3)
    hold on
end

%% adds a legend, and axis labels, as well as a title
legend(["4 Satellite Coverage","5 Satellite Coverage","6 Satellite Coverage"],'location','southeast')
xlabel('Time (s)')
ylabel('Coverage (%)')
title('Percentage coverage') 
save('Sat_Coords.mat','timelist','all_location_variables');
end
