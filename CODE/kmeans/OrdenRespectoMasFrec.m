function [vecOrden] = OrdenRespectoMasFrec(ttp24h,K,mes,nomInputVars,year)
% veca-> vector cuyo índice de posición = idCluster original
% valor del vector en un determinado índice = nuevo idCluster con criterio
% "respecto al idClust mas frecuente"
    if (mes == 0)
        [idx2, ctrs2,sumd2] =KMeansYear(ttp24h,K,year,nomInputVars);
    else
        [idx2, ctrs2,sumd2] =KMeansYearMes(ttp24h,K,year,mes,nomInputVars);
    end
    matDistClusters = DistClusters(ctrs2,K);
    for i=1:K
        num_veces_vec(i)= sum(idx2 == i);
    end

    [M,idClustersOrd]=sort(num_veces_vec,'descend');
    for j=0:K-1
        if j==0 
            idClusterMasFrec = idClustersOrd(1);  

            matDistClusters(:,idClusterMasFrec) = 100;
            vecOrden(idClusterMasFrec) = j+1;
            %subplot(7,6,6*(j+1));
            %title(sprintf('%d (%d)',j+1,num_veces_vec(idClusterMasFrec)));
            %nextid_ind = idClusterMasFrec;
        else
            
            %antnextid = nextid_ind;
            [nextid,nextid_ind] = min(matDistClusters(idClusterMasFrec,:));        

            vecOrden(nextid_ind) = j+1;
            matDistClusters(:,nextid_ind) = 100;
                    
        end

    end
end