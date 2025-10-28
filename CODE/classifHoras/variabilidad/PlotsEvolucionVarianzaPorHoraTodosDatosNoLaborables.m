function PlotsEvolucionVarianzaPorHoraTodosDatosNoLaborables(ttp24h,infomat,K,nomInputVars,nomSerie, timetableFestivos)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:); 
    
    ttp24hNoLab = ttp24h(timetableFestivos(ismember(ttp24h.FECHA,timetableFestivos.FECHA),:).FEST == 1 | ismember(weekday(ttp24h.FECHA),7) | ismember(weekday(ttp24h.FECHA),1),:);
            
      
    MatVarHorasConst=[];
    for j=primerYear:ultimoYear    
        
        dias=find(ttp24hNoLab.FECHA.Year == j);
        YearDias= ttp24hNoLab(dias,:);
        mYearDias = YearDias{:,1:end};
        for hora=0:23        
            mHora = mYearDias(:,hora+1);
            MatVarHorasConst(j-primerYear+1,hora+1)=var(mHora);
        end
    end
    
    figure;
    bar([primerYear:ultimoYear],MatVarHorasConst,'stacked');
    legend('hora0','hora1','hora2','hora3','hora4','hora5','hora6','hora7','hora8','hora9','hora10','hora11','hora12','hora13','hora14','hora15','hora16','hora17','hora18','hora19','hora20','hora21','hora22','hora23');
    ylabel('Variabilidad');
    title(sprintf('Tarifa %s (dias no laborables)',nomSerie));

    rng('default'); 
    [idx, ctrs,sumd] = kmeans(MatVarHorasConst',K,'replicates',100);
    
    figure;
    hold on;
    for j=1:24
        plot([primerYear:ultimoYear],MatVarHorasConst(:,j));
    end
    plot([primerYear:ultimoYear],ctrs,'Linewidth',2.5);
    legend('hora0','hora1','hora2','hora3','hora4','hora5','hora6','hora7','hora8','hora9','hora10','hora11','hora12','hora13','hora14','hora15','hora16','hora17','hora18','hora19','hora20','hora21','hora22','hora23');
    axis tight;
    ylabel('Variabilidad');
    xticks([primerYear:ultimoYear]);
    xticklabels([primerYear:ultimoYear]);
    title(sprintf('Tarifa %s (días no laborables)',nomSerie));
    
    figure;
    hold on;
    for j=1:24
        plot([primerYear:ultimoYear],MatVarHorasConst(:,j));
    end
    
    legend('hora0','hora1','hora2','hora3','hora4','hora5','hora6','hora7','hora8','hora9','hora10','hora11','hora12','hora13','hora14','hora15','hora16','hora17','hora18','hora19','hora20','hora21','hora22','hora23');
    axis tight;
    ylabel('Variabilidad');
    xticks([primerYear:ultimoYear]);
    xticklabels([primerYear:ultimoYear]);
    title(sprintf('Tarifa %s (días no laborables)',nomSerie));
end