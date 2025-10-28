function PlotClusterProximoNextYearRespectoMasFrec(ttp24h,K,mes,nomInputVars)
    
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    %K=7;
    figure;
    ax = [];
    kk=1;
    cont = 0;
    for i=primerYear:ultimoYear-1
        [idx1, ctrs1,sumd1] =KMeansYearMes(ttp24h,K,i+1,mes,nomInputVars);
        [idx2, ctrs2,sumd2] =KMeansYearMes(ttp24h,K,i,mes,nomInputVars);
        for p=1:K
            for k=1:K
                matDist(p,k) = sum(abs(ctrs2(p,:)-ctrs1(k,:)));
            end
        end 
        for s=1:K
            num_veces_vec(s)= sum(idx2 == s);
        end
        [M,idClustersOrd]=sort(num_veces_vec,'descend');



        matDistClusters = DistClusters(ctrs2,7);
        
            
        vecProxYear = OrdenRespectoMasFrec(ttp24h,K,mes,nomInputVars,i+1);

        for j=0:K-1 


            %%idCluster = idClustersOrd(j+1);
            %idClusterMasFrec = idClustersOrd(1);
            %[val,ind]= min(matDist(idCluster,:));%prox year


            if j==0 
                idClusterMasFrec = idClustersOrd(1);
                [val,ind]= min(matDist(idClusterMasFrec,:)); 

                matDistClusters(:,idClusterMasFrec) = 100;
                
                ax(kk)=subplot(7,6,(j*7)+cont+1);
                kk = kk+1;
                title(sprintf('%d (%d) -> %d ',j+1,num_veces_vec(idClusterMasFrec),vecProxYear(ind)));
                nextid_ind = idClusterMasFrec;

            else 
                antnextid = nextid_ind;
                [nextid,nextid_ind] = min(matDistClusters(antnextid,:));        
                [val,ind]= min(matDist(nextid_ind,:));

                matDistClusters(:,nextid_ind) = 100;
                ax(kk)=subplot(7,6,(j*6)+1+cont);
                kk = kk+1;
                title(sprintf('%d (%d) -> %d ',j+1,num_veces_vec(nextid_ind),vecProxYear(ind)));        
            end
            hold on;
            plot(ctrs2(nextid_ind,:)');
            hold on;
            plot(ctrs1(ind,:)');
            hold on;
        end
        cont = cont + 1; 
    end


    [idx2, ctrs2,sumd2] =KMeansYearMes(ttp24h,K,ultimoYear,mes,nomInputVars);
    matDistClusters = DistClusters(ctrs2,7);
    for i=1:K
        num_veces_vec(i)= sum(idx2 == i);
    end

    [M,idClustersOrd]=sort(num_veces_vec,'descend');
    for j=0:K-1
        if j==0 
            idClusterMasFrec = idClustersOrd(1);  

            matDistClusters(:,idClusterMasFrec) = 100;
            ax(kk)=subplot(7,6,6*(j+1));
            kk = kk+1;
            title(sprintf('%d (%d)',j+1,num_veces_vec(idClusterMasFrec)));
            nextid_ind = idClusterMasFrec;
        else 
            antnextid = nextid_ind;
            [nextid,nextid_ind] = min(matDistClusters(antnextid,:));        


            matDistClusters(:,nextid_ind) = 100;
            ax(kk)= subplot(7,6,6*(j+1));
            kk = kk+1;
            title(sprintf('%d (%d)',j+1,num_veces_vec(nextid_ind)));        
        end
        hold on;
        plot(ctrs2(nextid_ind,:)');
    end
    linkaxes(ax,'xy');
end


