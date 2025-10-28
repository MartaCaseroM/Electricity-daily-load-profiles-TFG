function [veca] = UltimoYearOrdenRespectoMasFrec(infomat,K,mes,nomInputVars,year)
    if (mes == 0)
        [idx2, ctrs2,sumd2] =KMeansYear(infomat,K,year,nomInputVars);
    else
        [idx2, ctrs2,sumd2] =KMeansYearMes(infomat,K,year,mes,nomInputVars);
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
            veca(idClusterMasFrec) = j+1;
            %subplot(7,6,6*(j+1));
            %title(sprintf('%d (%d)',j+1,num_veces_vec(idClusterMasFrec)));
            nextid_ind = idClusterMasFrec;
        else 
            antnextid = nextid_ind;
            [nextid,nextid_ind] = min(matDistClusters(antnextid,:));        

            veca(nextid_ind) = j+1;
            matDistClusters(:,nextid_ind) = 100;
            %subplot(7,6,6*(j+1));
            %title(sprintf('%d (%d)',j+1,num_veces_vec(nextid_ind)));        
        end

    end
end