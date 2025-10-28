function PlotsEvolucionMediaPorHoraTodosDatos(gruposConstelaciones,ttp24h,infomat,K,nomInputVars,nomSerie)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:); 
   

    
    MatMediaHorasConst=[];
    for j=primerYear:ultimoYear    
        
        dias=find(ttp24h.FECHA.Year == j);
        YearDias= ttp24h(dias,:);
        mYearDias = YearDias{:,1:end};
        for hora=0:23        
            mHora = mYearDias(:,hora+1);
            MatMediaHorasConst(j-primerYear+1,hora+1)=mean(mHora);
        end
    end
    
    figure;
    bar([primerYear:ultimoYear],MatMediaHorasConst,'stacked');
    legend('hora0','hora1','hora2','hora3','hora4','hora5','hora6','hora7','hora8','hora9','hora10','hora11','hora12','hora13','hora14','hora15','hora16','hora17','hora18','hora19','hora20','hora21','hora22','hora23');
    ylabel('Media');
    title(sprintf('Tarifa %s',nomSerie));

    figure;
    hold on;
    for j=1:24
        plot([primerYear:ultimoYear],MatMediaHorasConst(:,j));
    end
    legend('hora0','hora1','hora2','hora3','hora4','hora5','hora6','hora7','hora8','hora9','hora10','hora11','hora12','hora13','hora14','hora15','hora16','hora17','hora18','hora19','hora20','hora21','hora22','hora23');
    axis tight;
    ylabel('Media');
    xticks([primerYear:ultimoYear]);
    xticklabels([primerYear:ultimoYear]);
    title(sprintf('Tarifa %s',nomSerie));
end