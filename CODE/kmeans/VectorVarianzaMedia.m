function [vecVarianza] = VectorVarianzaMedia(ttp24h,K,nomInputVars)    
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    vecVarianza = zeros((ultimoYear-primerYear+1)*K,1);
    k=1;
    for i=primerYear:ultimoYear
        for j=1:K
            diasCluster = indDias(j,i,ultimoYear,ttp24h,K,nomInputVars);
            tdiasCluster = ttp24h(ismember(ttp24h.FECHA,diasCluster),:);
            varianzaHoras = var(tdiasCluster{:,1:end});
            mediaVarianzaHoras = sum(varianzaHoras)/24;
            vecVarianza(k,1) = mediaVarianzaHoras;
            k = k+1;
        end
    end
end