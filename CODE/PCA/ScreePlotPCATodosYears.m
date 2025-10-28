function ScreePlotPCATodosYears(ttp24h,nomInputVars,nomSerie)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    numDims = 2;
    colores={[1 0 0],[0 0 1],[0 0 0],[0 1 0],[1 1 0],[1 0 1],[0 1 1],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.6350 0.0780 0.1840],[1 0.5 0.8],[0.4 1.0 0.7],[0.6 0.5 1]};
    
    figure;
    hold on;
    for i=primerYear:ultimoYear
        years = ttp24h.FECHA.Year == i;
        X = ttp24h{years, nomInputVars};        
        [loading, score, latent,~, explained, mu] = pca(X); 
        %subplot(3,5,i-(primerYear-1));
        % Scree plot
        %p04ScreePlot(explained,false); %gráfico acumulada
        nPrincComp = length(explained);

        acumPEV = cumsum(explained);
        yyaxis left;
        bar(explained,'FaceColor',colores{i-(primerYear-1)},'EdgeColor',colores{i-(primerYear-1)});
        ylabel('Variance Explained (%)');
        ylim([0 100]);
        yyaxis right;
        plot(acumPEV, '-o', 'linewidth', 3,'color',colores{i-(primerYear-1)});
        ylabel('Acumulated variance Explained (%)');
        ylim([0 100]);
        xlim([0.5 nPrincComp+0.5]);

        set(gca,'xtick', 1:nPrincComp);

        title ('Scree plot'); 
        xlabel('Principal Component');

        grid on;


        
        %title(sprintf('%d',i));
        
    end       
    title(sprintf('Evolucion Temporal ScreePlot Demanda %s',nomSerie));
    legend(string(primerYear:ultimoYear));
end