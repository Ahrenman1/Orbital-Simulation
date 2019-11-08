eclipseTimes = find(inEclipse);

Ti = 5;

for j = 1:1:6
    for k = 1:1:4
        inEclipseList = squeeze(inEclipse(j,k,:));
        thisEclipseTimes = find(inEclipseList);
        this_eclipse=0;
        eclipse_at=eclipseTimes(1);
        eclipse_length=[];
        for m = 1:length(thisEclipseTimes)-1
            if thisEclipseTimes(m)+Ti == thisEclipseTimes(m+1)
                this_eclipse=this_eclipse+Ti;
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
