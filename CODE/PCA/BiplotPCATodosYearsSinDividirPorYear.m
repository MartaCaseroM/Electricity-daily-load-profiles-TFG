function BiplotPCATodosYearsSinDividirPorYear(ttp24h,nomInputVars,nomSerie)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    %figure;
    %hold on;
    numDims = 2;
    
    %legend(string(primerYear:ultimoYear));
    figure;
    
    %years = ttp24h.FECHA.Year == i;
    X = ttp24h{:, nomInputVars};
    %tr = TablaVariablesCategArbolClassif(infomat,K,i,nomInputVars,timetableFestivos);
    [loading, score, latent,~, explained, mu] = pca(X);  

    biplot(loading(:,1:numDims),'scores',score(:,1:numDims),'varlabels', nomInputVars);

    grid on;
    %axis square;
    %hold on;           
    title(sprintf('Biplot %s',nomSerie));
    
end