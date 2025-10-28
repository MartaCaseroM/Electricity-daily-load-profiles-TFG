function [G,H]=GrafoEvolucionCluster(ttp24h,K,nomInputVars,nomSerie)
    d = [];
    %K=36;
    %K=7;
    
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    cont = 0;    
    s = 1:K*((ultimoYear-primerYear)+1);  
    %s = 1:K*6;
    markerSize = [];
    for i=primerYear:ultimoYear-1
        [idx1, ctrs1,sumd1] =KMeansYear(ttp24h,K,i+1,nomInputVars);
        [idx2, ctrs2,sumd2] =KMeansYear(ttp24h,K,i,nomInputVars);
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
        vecProxYear = OrdenRespectoMasFrec(ttp24h,K,0,nomInputVars,i+1);       

        


        for j=0:K-1     


            if j==0 
                idClusterMasFrec = idClustersOrd(1);
                [val,ind]= min(matDist(idClusterMasFrec,:)); 

                matDistClusters(:,idClusterMasFrec) = 100;
                if(val>0.015)
                    d((cont*K)+1) = (cont*K)+1;
                else
                    d((cont*K)+1)= vecProxYear(ind)+(K*(cont+1));
                end
                markerSize((cont*K)+1) = num_veces_vec(idClusterMasFrec);
                %nextid_ind = idClusterMasFrec;

            else 
                %antnextid = nextid_ind;
                [nextid,nextid_ind] = min(matDistClusters(idClusterMasFrec,:));        
                [val,ind]= min(matDist(nextid_ind,:));

                matDistClusters(:,nextid_ind) = 100;
                if(val>0.015)
                    d((cont*K)+1+j) = (cont*K)+1+j;
                else
                    d((cont*K)+1+j)= vecProxYear(ind)+(K*(cont+1));
                end
                markerSize((cont*K)+1+j) = num_veces_vec(nextid_ind);
            end
           
        end
            cont = cont + 1; 
    end


    [idx2, ctrs2,sumd2] =KMeansYear(ttp24h,K,ultimoYear,nomInputVars);
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
            %nextid_ind = idClusterMasFrec;
        else 
            %antnextid = nextid_ind;
            [nextid,nextid_ind] = min(matDistClusters(idClusterMasFrec,:));        


            matDistClusters(:,nextid_ind) = 100;
            
            markerSize((K*(ultimoYear-primerYear))+1+j) = num_veces_vec(nextid_ind);
        end
        
    end
   
    G = digraph(s,d,'omitselfloops');
    %G.Nodes.Name = {'id1-2015','id2-2015','id3-2015','id4-2015','id5-2015','id6-2015','id7-2015','id8-2015','id9-2015','id10-2015','id11-2015','id12-2015','id13-2015','id14-2015','id15-2015','id16-2015','id17-2015','id18-2015','id19-2015','id20-2015','id21-2015','id22-2015','id23-2015','id24-2015','id25-2015','id26-2015','id27-2015','id28-2015','id29-2015','id7-2015','id1-2016','id2-2016','id3-2016','id4-2016','id5-2016','id6-2016','id7-2016','id1-2017','id2-2017','id3-2017','id4-2017','id5-2017','id6-2017','id7-2017','id1-2018','id2-2018','id3-2018','id4-2018','id5-2018','id6-2018','id7-2018','id1-2019','id2-2019','id3-2019','id4-2019','id5-2019','id6-2019','id7-2019','id1-2020','id2-2020','id3-2020','id4-2020','id5-2020','id6-2020','id7-2020'}';
    ind = 1;
    contaux=0;
    %K=7;
    aux ={};
    for f=1:K*((ultimoYear-primerYear)+1)
        
        %G.Nodes.Name(f) 
        aux{f}= sprintf('id%d-%d',ind,contaux+primerYear);
        
        if(mod(f,K)== 0)
            contaux = contaux+1;
            ind = 0;
        end
        
        ind = ind +1;
    end
    G.Nodes.Name = aux';
    %markerSize(207) = 20;
    vecX=[1:K];
    figure;
    H= plot(G,'Layout','layered','NodeLabel',G.Nodes.Name,'MarkerSize',markerSize*0.35);
    H.NodeFontSize = 5;
    vecYData=[];
    for i=((ultimoYear-primerYear)+1):-1:1
        vecYData = [vecYData repmat(i,1,K)];
    end
    set(H,'YData',vecYData);


    
    %H= plot(G,'Layout','layered','NodeLabel',G.Nodes.Name,'MarkerSize',markerSize*0.5);
    
    % H= plot(G,'XData',[vecX,vecX,vecX,vecX,vecX,vecX]','YData',[[repmat(6,1,K)], [repmat(5,1,K)],[repmat(4,1,K)],[repmat(3,1,K)],[repmat(2,1,K)],[repmat(1,1,K)]]','ZData',zeros(K*6,1),'MarkerSize',markerSize*0.5);
    %highlight(H,[207],'NodeColor','r');
    title(sprintf('%s',nomSerie));
    
end