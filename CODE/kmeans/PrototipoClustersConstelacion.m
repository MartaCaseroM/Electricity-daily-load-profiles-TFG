function [H]=PrototipoClustersConstelacion(numConstelacion,nomInputVars,ttp24h,K,DiasConstelacionesEstruct,gruposConstelaciones)
    %numConstelacion = 2;
    
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);

    constelacion = DiasConstelacionesEstruct.(sprintf('constelacion%d',numConstelacion));
    IDsConstelacion = gruposConstelaciones.(sprintf('constelacion%d',numConstelacion));
    dimConstelacion = size(constelacion);
    lowerBoundYear = min(constelacion.Year);
    upperBoundYear = max(constelacion.Year);

    H=figure;
    hold on;
    dimLastYear = 0; %aqui esta el problema
    encontradoYear=1;
    dimLastYearDef = 0;
    
    for j=primerYear:ultimoYear
        if (lowerBoundYear == primerYear)
            dimLastYearDef = 0;
        else
            if(j== lowerBoundYear)
                dimLastYearDef= dimLastYear;
            else
                [idx, ctrs,sumd] =  KMeansYear(ttp24h,K,j,nomInputVars);
                dimLastYear = dimLastYear + size(idx);
            end
        end

    end
    leyenda=string([]);
    cont = 0;
    for i=lowerBoundYear:upperBoundYear
        %i=2008;   
        [idx, ctrs,sumd] =  KMeansYear(ttp24h,K,i,nomInputVars);
        primerElementoYearActual = find(constelacion.Year == i);
        ind = find(ismember(ttp24h.FECHA ,constelacion(primerElementoYearActual)));
        ind = ind - dimLastYearDef(1);
        idClustYearActual = unique(idx(ind));      

        
          
        vecProxYear = OrdenRespectoMasFrec(ttp24h,K,0,nomInputVars,i);
        if(size(idClustYearActual)>0)
            for f=1:size(idClustYearActual)
                plot(ctrs(idClustYearActual(f),:)'); 
                cont = cont +1;
                leyenda{1,cont} = sprintf('id%d-%d',vecProxYear(idClustYearActual(f)),i);
                hold on;
            end
        end
     
        
       dimLastYearDef = dimLastYearDef(1) + size(idx);
    end

    title(sprintf('Perfiles Clusters Constelacion%d',numConstelacion));
    axis tight;
    legend(leyenda);
    %legend;
end