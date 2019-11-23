% Coverage Analysis Plot

function percent_vect = Coverage_Analysis_Plot(Sat_Visibility_Array, time_series,Greater_than_values)

    %Shortening Labels
    SVA=Sat_Visibility_Array;
    TS = time_series;
    GTA = Greater_than_values;
    [a,b,~] = size(Sat_Visibility_Array);
    %Vector to hold the percentage coverage values
    percent_vect = zeros(length(GTA),length(TS));

    colours = hsv(length(GTA)+1);
    legend_str = [];
    
    for i = GTA
        %creating an array of the plot values
        greater_than_bool=SVA >= i;
        %claculating the percentage of points that have that many sats
        %visible
        percent_vect(i,:) = sum(greater_than_bool,[1 2])*100/(a*b);
    end
    
    %Plotting Results
    figure
    clf
    
    for i = GTA
        hold on
        plot(TS./(60*60*24),percent_vect(i,:), 'Color',colours(find(GTA==i),:))
        legend_str=[legend_str;['\geq ', num2str(i,'%02i'), ' Satelites Visible']];
    end
    
    
    title('Sataleite Visibility Plot')
    xlabel('Time /days')
    ylabel('Percent of Surface points covered')
    legend(legend_str)
end
