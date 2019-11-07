eclipseTimes = find(inEclipse);
timeEclipse = 0;
eclipses = [];
ect=[];


this_eclipse=0
eclipse_at=eclipseTimes(1);
eclipse_length=[]
for j = 1:length(eclipseTimes)-1
    if eclipseTimes(j)+Ti == eclipseTimes(j+1)
        this_eclipse=this_eclipse+Ti;
    else
        eclipse_length=[eclipse_length this_eclipse];
        eclipse_at=[eclipse_at eclipseTimes(j+1)];
        this_eclipse=0;
    end
end
eclipse_length=[eclipse_length this_eclipse];

    
%{

for j = 1:length(eclipseTimes)-1
    timeEclipse=0;
    if eclipseTimes(j) == eclipseTimes(j+1)-Ti
        disp(eclipseTimes(j));
       
        
        timeEclipse = timeEclipse + Ti;
        eclipses=[eclipses timeEclipse];
    else
       eclipses=[eclipses; timeEclipse];
    end
    
end
%}
