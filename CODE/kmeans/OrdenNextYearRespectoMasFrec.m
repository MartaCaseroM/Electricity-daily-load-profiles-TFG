function [ind_proxYear_vec] = OrdenNextYearRespectoMasFrec(infomat,K,mes,nomInputVars,year)
    %i= 2016;
    if(mes == 0)
        [idx1, ctrs1,sumd1] =KMeansYear(infomat,K,year+1,nomInputVars);
        [idx2, ctrs2,sumd2] =KMeansYear(infomat,K,year,nomInputVars);
    else
        [idx1, ctrs1,sumd1] =KMeansYearMes(infomat,K,year+1,mes,nomInputVars);
        [idx2, ctrs2,sumd2] =KMeansYearMes(infomat,K,year,mes,nomInputVars);
    end
    for p=1:K
        for k=1:K
            matDist(p,k) = sum(abs(ctrs2(p,:)-ctrs1(k,:)));
        end
    end 
    for i=1:K
        num_veces_vec(i)= sum(idx2 == i);
    end
    [M,idClustersOrd]=sort(num_veces_vec,'descend');



    matDistClusters = DistClusters(ctrs2,K);

    for j=0:K-1 


        %%idCluster = idClustersOrd(j+1);
        %idClusterMasFrec = idClustersOrd(1);
        %[val,ind]= min(matDist(idCluster,:));%prox year


        if j==0 
            idClusterMasFrec = idClustersOrd(1);
            [val,ind]= min(matDist(idClusterMasFrec,:)); 

            matDistClusters(:,idClusterMasFrec) = 100;
            ind_proxYear_vec(idClusterMasFrec) = j+1;
            %subplot(7,6,(j*7)+cont+1);
            %title(sprintf('%d (%d) -> %d ',j+1,num_veces_vec(idClusterMasFrec),ind));
            nextid_ind = idClusterMasFrec;

        else 
            antnextid = nextid_ind;
            [nextid,nextid_ind] = min(matDistClusters(antnextid,:));        
            [val,ind]= min(matDist(nextid_ind,:));
            ind_proxYear_vec(nextid_ind) = j+1;
            matDistClusters(:,nextid_ind) = 100;
            %subplot(7,6,(j*6)+1+cont);
            %title(sprintf('%d (%d) -> %d ',j+1,num_veces_vec(nextid_ind),ind));        
        end

    end
end