function BiplotPCATodosYears(ttp24h,nomInputVars,nomSerie)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    %figure;
    %hold on;
    numDims = 2;
    colores={[1 0 0],[0 0 1],[0 0 0],[0 0 1],[1 1 0],[1 0 1],[0 1 1],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.6350 0.0780 0.1840],[1 0.5 0.8],[0.6 0.6 0.9],[0.6 0.5 1]};
    coloresBiplot=[];
    for i=primerYear:ultimoYear
        %i=2007;
        years = ttp24h.FECHA.Year == i;
        dim= size(ttp24h{years, nomInputVars});
        %A=repmat(colores{i-(primerYear-1)},[1,3],dim(1));
        C=cell(1,dim(1));
        C(:)=colores(i-(primerYear-1));
        coloresBiplot = [coloresBiplot C];
    end
    
    for i=primerYear:ultimoYear
        years = ttp24h.FECHA.Year == i;
        X = ttp24h{years, nomInputVars};
        %tr = TablaVariablesCategArbolClassif(infomat,K,i,nomInputVars,timetableFestivos);
        [loading, score, latent,~, explained, mu] = pca(X);        
        %biplot(loading(:,1:numDims),'scores',score(:,1:numDims),'Color',colores{i-(primerYear-1)},'varlabels', nomInputVars);
        %figure;
        %plot(score(:,1),score(:,2),'.', 'Markersize',15);
        %xlabel('1st Principal Component');
        %ylabel('2nd Principal Component');
        %hold on;
        
    end
    %legend(string(primerYear:ultimoYear));
    figure;
    for i=primerYear:ultimoYear
        years = ttp24h.FECHA.Year == i;
        X = ttp24h{years, nomInputVars};
        %tr = TablaVariablesCategArbolClassif(infomat,K,i,nomInputVars,timetableFestivos);
        [loading, score, latent,~, explained, mu] = pca(X);  
        subplot(3,5,i-(primerYear-1));
        biplot(loading(:,1:numDims),'scores',score(:,1:numDims),'varlabels', nomInputVars);
        title(sprintf('%d',i));
        grid on;
        %axis square;
        %hold on;        
    end    
    sgtitle(sprintf('Evolucion Temporal Biplot Demanda %s',nomSerie));
    linkaxes;
end