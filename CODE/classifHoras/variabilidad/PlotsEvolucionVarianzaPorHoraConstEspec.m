function PlotsEvolucionVarianzaPorHoraConstEspec(idConst,gruposConstelaciones,ttp24h,infomat,K,nomInputVars)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    grupoConstelacion = gruposConstelaciones.(sprintf('constelacion%d',idConst));
    diasTotalConst =[];
    for n=1:size(grupoConstelacion)
        idClust=string(grupoConstelacion{n,1});
        num_id=str2num(extractBetween(idClust,"id","-"));
        year_id=str2num(extractAfter(idClust,"-"));

        diasClust = indDias(num_id,year_id,ultimoYear,infomat,K,nomInputVars);
        [dimdiasClust,~] = size(diasClust);
        diasTotalConst = [diasTotalConst; diasClust];
        %sumVarianza = sumVarianza +vecVarianza((K*(year_id-primerYear))+num_id);
    end
    tdiasConst = ttp24h(ismember(ttp24h.FECHA,diasTotalConst),:);
    varianzaHoras = var(tdiasConst{:,1:end});
    VarianzaMedia = sum(varianzaHoras)/24;

    minYear = min(tdiasConst.FECHA.Year);
    maxYear = max(tdiasConst.FECHA.Year);
    MatVarHorasConst=[];
    for j=minYear:maxYear    
        indDiasConst=find(tdiasConst.FECHA.Year == j);
        YearDias= tdiasConst(indDiasConst,:);
        mYearDias = YearDias{:,1:end};
        for hora=0:23        
            mHora = mYearDias(:,hora+1);
            MatVarHorasConst(j-minYear+1,hora+1)=var(mHora);
        end
    end

    figure;
    bar([minYear:maxYear],MatVarHorasConst,'stacked');
    legend('hora0','hora1','hora2','hora3','hora4','hora5','hora6','hora7','hora8','hora9','hora10','hora11','hora12','hora13','hora14','hora15','hora16','hora17','hora18','hora19','hora20','hora21','hora22','hora23');
    ylabel('Variabilidad');
    title(sprintf('IDConstelacion %d',idConst));

    figure;
    hold on;
    for j=1:24
        plot([minYear:maxYear],MatVarHorasConst(:,j));
    end
    legend('hora0','hora1','hora2','hora3','hora4','hora5','hora6','hora7','hora8','hora9','hora10','hora11','hora12','hora13','hora14','hora15','hora16','hora17','hora18','hora19','hora20','hora21','hora22','hora23');
    axis tight;
    ylabel('Variabilidad');
    xticks([minYear:maxYear]);
    xticklabels([minYear:maxYear]);
    title(sprintf('IDConstelacion %d',idConst));
end