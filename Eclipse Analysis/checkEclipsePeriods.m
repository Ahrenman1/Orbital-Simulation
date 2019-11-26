
satCoords = load("Sat_Coords_30Day_1mRes.mat");

tStep = 60;
tMax = 60*12;
year = 2035;
month = 8;
day = 18;
hour = 19;
minute = 0;
checkSatEclipse = false;
checkLunarEclipse = true;
enablePlotting = false;
enableVideo = false;

inEclipse = eclipseChecker(satCoords,tStep,tMax,year,month,day,hour,minute,checkSatEclipse,checkLunarEclipse,enablePlotting,enableVideo);

eclipseTimes = find(inEclipse);
[j_max, k_max, ~] = size(inEclipse);

for j = 1:1:j_max
    for k = 1:1:k_max
        inEclipseList = squeeze(inEclipse(j,k,:));
        thisEclipseTimes = find(inEclipseList);
        this_eclipse=0;
        eclipse_at=eclipseTimes(1);
        eclipse_length=[];
        for m = 1:length(thisEclipseTimes)-1
            if thisEclipseTimes(m)+tStep == thisEclipseTimes(m+1)
                this_eclipse=this_eclipse+tStep;
            else
                eclipse_length=[eclipse_length this_eclipse];
                eclipse_at=[eclipse_at eclipseTimes(m+1)];
                this_eclipse=0;
            end
        end
        eclipse_length=60*[eclipse_length this_eclipse];
        
        max_eclipse(j,k) = max(eclipse_length);
        
        min_eclipse(j,k) = min(eclipse_length);
    end
end
saveLocation = ['Results/', datestr(datetime(year,month,day))];
save(saveLocation,'max_eclipse','min_eclipse','inEclipse');

disp('Maximum eclipse times (mins)');
disp(max_eclipse/60);
disp('Minimum eclipse times (mins)');
disp(min_eclipse/60);
disp('Maximum eclipse times (hrs)');
disp(max_eclipse/3600);
disp('Minimum eclipse times (hrs)');
disp(min_eclipse/3600);

numSatsEclipse = numel(find(max_eclipse));
disp('Number of sats in eclipse');
disp(numSatsEclipse);

disp('Max of all eclipses');
disp(max(max_eclipse/3600,[],'all'));
disp('Min of all eclipses');
disp(min(min_eclipse(min_eclipse>0)/3600,[],'all'));