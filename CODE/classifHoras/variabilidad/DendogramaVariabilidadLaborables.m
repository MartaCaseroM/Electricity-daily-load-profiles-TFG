function DendogramaVariabilidadLaborables(ttp24h,timetableFestivos)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);  

    ttp24hLab = ttp24h(timetableFestivos(ismember(ttp24h.FECHA,timetableFestivos.FECHA),:).FEST == 0 & ismember(weekday(ttp24h.FECHA),2:6),:);
            
      
    MatVarHorasConst=[];
    for j=primerYear:ultimoYear    
        
        dias=find(ttp24hLab.FECHA.Year == j);
        YearDias= ttp24hLab(dias,:);
        mYearDias = YearDias{:,1:end};
        for hora=0:23        
            mHora = mYearDias(:,hora+1);
            MatVarHorasConst(j-primerYear+1,hora+1)=var(mHora);
        end
    end

    
    tree = linkage(MatVarHorasConst','average', 'correlation');

    %plot with a threshold
    figure;
    hdg = dendrogram(tree, 'ColorThreshold',0.3, 'Labels', string([0:23]));
    set(hdg,'LineWidth',2); grid minor;
    title('Dendograma Variabilidad Días Laborables');
    
    e=[];
    for K = 1:24
        [~, ~, sumd] = kmeans(MatVarHorasConst', K, 'replicates',100);
        qe(K)=sum(sumd);
    end
    figure; 
    bar(qe);
    axis tight;
    xlabel('K');
    ylabel('QE'); 
    grid on;
end
