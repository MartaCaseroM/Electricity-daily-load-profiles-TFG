function PlotClusterProximoNextYear(ttp24h,K,mes,nomInputVars)
    
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    %K=7;
    figure;
    %y=0;
    cont = 0;
    for i=primerYear:ultimoYear-1    
        [idx1, ctrs1,sumd1] =KMeansYearMes(ttp24h,K,i+1,mes,nomInputVars);
        [idx2, ctrs2,sumd2] =KMeansYearMes(ttp24h,K,i,mes,nomInputVars);
        for p=1:K
            for k=1:K
                matDist(p,k) = sum(abs(ctrs2(p,:)-ctrs1(k,:)));
            end
        end 
        for i=1:K
            num_veces_vec(i)= sum(idx2 == i);
        end
        [M,idClustersOrd]=sort(num_veces_vec,'descend');

        
        for j=0:K-1 
            
            idCluster = idClustersOrd(j+1);
            [val,ind]= min(matDist(idCluster,:));
            if j==0
                subplot(7,6,(j*7)+cont+1);
                title(sprintf('%d (%d) -> %d ',idCluster,num_veces_vec(idCluster),ind));
            else
                subplot(7,6,(j*6)+1+cont);
                title(sprintf('%d (%d)-> %d ',idCluster,num_veces_vec(idCluster),ind));
            end
            hold on;
            plot(ctrs2(idCluster,:)');
            hold on;
            plot(ctrs1(ind,:)');
            hold on;
        end
        cont = cont + 1;    
    end

    [idx2, ctrs2,sumd2] =KMeansYearMes(ttp24h,K,ultimoYear,mes,nomInputVars);
    for i=1:K
        num_veces_vec(i)= sum(idx2 == i);
    end
    [M,idClustersOrd]=sort(num_veces_vec,'descend');
    for i=1:K
        idCluster=idClustersOrd(i);
        subplot(7,6,6*i);
        title(sprintf('%d (%d)',idCluster,num_veces_vec(idCluster)));        
        hold on;
        plot(ctrs2(idCluster,:)');
    end
end