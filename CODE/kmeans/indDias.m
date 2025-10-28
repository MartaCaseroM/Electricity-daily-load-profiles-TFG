function [aux_ttp24h] = indDias(num_id,year_id,ultimoYear,ttp24h,K,nomInputVars)  
    vecOrdenClusters=[];
    matOrdenClusters=[];    
    
    vecOrdenClusters=OrdenRespectoMasFrec(ttp24h,K,0,nomInputVars,year_id);
    %if year_id==ultimoYear
    %    vecOrdenClusters=UltimoYearOrdenRespectoMasFrec(infomat,K,0,nomInputVars,year_id);
    %else
    %    vecOrdenClusters=OrdenNextYearRespectoMasFrec(infomat,K,0,nomInputVars,year_id);       
    %end
    [idx1, ctrs1,sumd1] =KMeansYear(ttp24h,K,year_id,nomInputVars);%idx1 tiene orden original
    indOrig=find(vecOrdenClusters==num_id);
    indOrigIdx1 = find(idx1==indOrig);
    ind_aux_ttp24h = find(ttp24h.FECHA.Day ==1 & ttp24h.FECHA.Month ==1 & ttp24h.FECHA.Year == year_id);
    sizeIdx1= size(indOrigIdx1);
    for tamidx1=1:sizeIdx1(1)
        indOrigIdx1(tamidx1)= indOrigIdx1(tamidx1)+ind_aux_ttp24h-1;
    end
    aux_ttp24h=ttp24h.FECHA(indOrigIdx1);
end