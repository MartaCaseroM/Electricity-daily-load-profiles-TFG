function ScatterPlotPCATodosYears(ttp24h,nomInputVars,nomSerie)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    numDims = 2;
    figure;
    for i=primerYear:ultimoYear
        years = ttp24h.FECHA.Year == i;
        X = ttp24h{years, nomInputVars};        
        [loading, score, latent,~, explained, mu] = pca(X); 
        subplot(3,5,i-(primerYear-1));
        plot(score(:,1),score(:,2),'.', 'Markersize',15);
        xlabel('1st Principal Component');
        ylabel('2nd Principal Component');
        title(sprintf('%d',i));
        grid on;
    end       
    sgtitle(sprintf('Evolucion Temporal Scatterplot Demanda %s',nomSerie));
    linkaxes;
end