function DendogramaVariabilidadTodosDatos(ttp24h,timetableFestivos)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);  

    

    MatVarHorasConst=[];
    for j=primerYear:ultimoYear    

        dias=find(ttp24h.FECHA.Year == j);
        YearDias= ttp24h(dias,:);
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
    title('Dendograma Variabilidad');
    
    qe=[];
    for Kfact = 1:24
        [~, ~, sumd] = kmeans(MatVarHorasConst', Kfact, 'replicates',100);
        qe(Kfact)=sum(sumd);
    end
    figure; 
    bar(qe);
    axis tight;
    xlabel('K');
    ylabel('QE'); 
    grid on;
    
    
end
