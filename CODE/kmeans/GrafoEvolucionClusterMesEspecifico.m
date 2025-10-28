function GrafoEvolucionClusterMesEspecifico(ttp24h,K,mes,nomInputVars,nomSerie)
    d = [];
    
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    meses = {'Enero','Febrero','Marzo','Abril', 'Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
    cont = 0;    
    s = 1:K*((ultimoYear-primerYear)+1);    
    markerSize = [];
    for i=primerYear:ultimoYear-1
        [idx1, ctrs1,sumd1] =KMeansYearMes(ttp24h,K,i+1,mes,nomInputVars);
        [idx2, ctrs2,sumd2] =KMeansYearMes(ttp24h,K,i,mes,nomInputVars);
        for p=1:K
            for k=1:K
                matDist(p,k) = sum(abs(ctrs2(p,:)-ctrs1(k,:)));
            end
        end 
        for w=1:K
            num_veces_vec(w)= sum(idx2 == w);
        end
        [M,idClustersOrd]=sort(num_veces_vec,'descend');


        % con propio año
        matDistClusters = DistClusters(ctrs2,K);
        vecProxYear = OrdenRespectoMasFrec(ttp24h,K,mes,nomInputVars,i);
        



        for j=0:K-1 


            


            if j==0 
                idClusterMasFrec = idClustersOrd(1);
                [val,ind]= min(matDist(idClusterMasFrec,:)); 

                matDistClusters(:,idClusterMasFrec) = 100;

                d((cont*K)+1)= vecProxYear(ind)+(K*(cont+1));
                markerSize((cont*K)+1) = num_veces_vec(idClusterMasFrec);
                nextid_ind = idClusterMasFrec;

            else 
                antnextid = nextid_ind;
                [nextid,nextid_ind] = min(matDistClusters(antnextid,:));        
                [val,ind]= min(matDist(nextid_ind,:));

                matDistClusters(:,nextid_ind) = 100;
                d((cont*K)+1+j)= vecProxYear(ind)+(K*(cont+1));
                markerSize((cont*K)+1+j) = num_veces_vec(nextid_ind);
            end
           
        end
            cont = cont + 1; 
    end


    [idx2, ctrs2,sumd2] =KMeansYearMes(ttp24h,K,ultimoYear,mes,nomInputVars);
    matDistClusters = DistClusters(ctrs2,K);
    for i=1:K
        num_veces_vec(i)= sum(idx2 == i);
    end

    [M,idClustersOrd]=sort(num_veces_vec,'descend');
    d((K*(ultimoYear-primerYear))+1:K*((ultimoYear-primerYear)+1))= (K*(ultimoYear-primerYear))+1:K*((ultimoYear-primerYear)+1);
    
    for j=0:K-1
        if j==0 
            idClusterMasFrec = idClustersOrd(1);  

            matDistClusters(:,idClusterMasFrec) = 100;
            
            markerSize((K*(ultimoYear-primerYear))+1) = num_veces_vec(idClusterMasFrec);
            nextid_ind = idClusterMasFrec;
        else 
            antnextid = nextid_ind;
            [nextid,nextid_ind] = min(matDistClusters(antnextid,:));        


            matDistClusters(:,nextid_ind) = 100;
            
            markerSize((K*(ultimoYear-primerYear))+1+j) = num_veces_vec(nextid_ind);
        end
        
    end
   
    G = digraph(s,d,'omitselfloops');
    G.Nodes.Name = {'id1-2015','id2-2015','id3-2015','id4-2015','id5-2015','id6-2015','id7-2015','id1-2016','id2-2016','id3-2016','id4-2016','id5-2016','id6-2016','id7-2016','id1-2017','id2-2017','id3-2017','id4-2017','id5-2017','id6-2017','id7-2017','id1-2018','id2-2018','id3-2018','id4-2018','id5-2018','id6-2018','id7-2018','id1-2019','id2-2019','id3-2019','id4-2019','id5-2019','id6-2019','id7-2019','id1-2020','id2-2020','id3-2020','id4-2020','id5-2020','id6-2020','id7-2020'}';

    figure;
    plot(G,'NodeLabel',G.Nodes.Name,'MarkerSize',markerSize*4);
    title(sprintf('%s %s',meses{mes},nomSerie));
end