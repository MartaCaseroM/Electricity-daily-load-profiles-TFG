function CambiarEtiquetasGrafo(G,H,ttp24h,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    numconstelaciones = length(fieldnames(gruposConstelaciones));
    vecIDConstelacion = zeros(size(G.Nodes.Name));
    for i=1:size(G.Nodes.Name)    
        for j=1:numconstelaciones
            grupoConstelacion = gruposConstelaciones.(sprintf('constelacion%d',j));
            for n=1:size(grupoConstelacion)

                idClust=string(grupoConstelacion{n,1});
                num_id=str2num(extractBetween(idClust,"id","-"));
                year_id=str2num(extractAfter(idClust,"-"));
                vecIDConstelacion((K*(year_id-primerYear))+num_id)= j;
            end
        end
    end
    row = dataTipTextRow('IDConstelacion',vecIDConstelacion);
    H.DataTipTemplate.DataTipRows(end+1) = row;
    H.DataTipTemplate.DataTipRows(2) = [];
    H.DataTipTemplate.DataTipRows(2) = [];

    

    vecSizeClust = zeros(size(G.Nodes.Name));
    vecIndDias=[];
    for i=primerYear:ultimoYear
        for j=1:K        
            vecIndDias=indDias(j,i,ultimoYear,ttp24h,K,nomInputVars);
            dimClust = size(vecIndDias);
            vecSizeClust(((i-primerYear)*K) + j) = dimClust(1);
        end
    end

    row = dataTipTextRow('NumDiasCluster',vecSizeClust);
    H.DataTipTemplate.DataTipRows(end+1) = row;

    vecFrecDiasConstelacion = zeros(size(G.Nodes.Name));
    for i=1:size(G.Nodes.Name)    
        for j=1:numconstelaciones
            
            grupoConstelacion = gruposConstelaciones.(sprintf('constelacion%d',j));
            dimConstelacion = size(DiasConstelacionesEstruct.(sprintf('constelacion%d',j)));
            for n=1:size(grupoConstelacion)
                idClust=string(grupoConstelacion{n,1});
                num_id=str2num(extractBetween(idClust,"id","-"));
                year_id=str2num(extractAfter(idClust,"-"));
                vecFrecDiasConstelacion((K*(year_id-primerYear))+num_id)= dimConstelacion(1);
            end
        end
    end
    row = dataTipTextRow('NumDiasConstelacion',vecFrecDiasConstelacion);
    H.DataTipTemplate.DataTipRows(end+1) = row;
    row = dataTipTextRow('VarianzaMediaHoras',vecVarianza);
    H.DataTipTemplate.DataTipRows(end+1) = row;
    
    VarianzaConstelacion = [];
    sumVarianza = 0;
    [numConstelaciones,~] = size(fieldnames(DiasConstelacionesEstruct));
    VecVarianzaConst = zeros(1,numConstelaciones);
    for i=1:numConstelaciones        
        grupoConstelacion = gruposConstelaciones.(sprintf('constelacion%d',i));
        sumVarianza = 0;
        diasTotalConst = [];
        for n=1:size(grupoConstelacion)
            idClust=string(grupoConstelacion{n,1});
            num_id=str2num(extractBetween(idClust,"id","-"));
            year_id=str2num(extractAfter(idClust,"-"));

            diasClust = indDias(num_id,year_id,ultimoYear,ttp24h,K,nomInputVars);
            [dimdiasClust,~] = size(diasClust);
            diasTotalConst = [diasTotalConst; diasClust];
            %sumVarianza = sumVarianza +vecVarianza((K*(year_id-primerYear))+num_id);
        end
        tdiasConst = ttp24h(ismember(ttp24h.FECHA,diasTotalConst),:);
        varianzaHoras = var(tdiasConst{:,1:end});
        VarianzaMedia = sum(varianzaHoras)/24;    
        for n=1:size(grupoConstelacion)
            idClust=string(grupoConstelacion{n,1});
            num_id=str2num(extractBetween(idClust,"id","-"));
            year_id=str2num(extractAfter(idClust,"-"));
            VarianzaConstelacion((K*(year_id-primerYear))+num_id) = VarianzaMedia;
        end
        VecVarianzaConst(i)=VarianzaMedia;
    end        


    row = dataTipTextRow('VarianzaMediaTotalConstelacion',VarianzaConstelacion);
    H.DataTipTemplate.DataTipRows(end+1) = row;
    
end