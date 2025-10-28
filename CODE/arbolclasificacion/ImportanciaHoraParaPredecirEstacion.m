function ImportanciaHoraParaPredecirEstacion(infomat,K,nomInputVars,timetableFestivos,nomSerie)
    ttp24h = infomat.ttp24h;
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    figure;
    for year=primerYear:ultimoYear
        %year =2008;
        %K=12;
        tr=TablaVariablesCategArbolClassif(infomat,K,year,nomInputVars,timetableFestivos); 
        treeIni = fitctree(tr, 'IdCluster~PERFILH0+PERFILH1+PERFILH2+PERFILH3+PERFILH4+PERFILH5+PERFILH6+PERFILH7+PERFILH8+PERFILH9+PERFILH10+PERFILH11+PERFILH12+PERFILH13+PERFILH14+PERFILH15+PERFILH16+PERFILH17+PERFILH18+PERFILH19+PERFILH20+PERFILH21+PERFILH22+PERFILH23', 'SplitCriterion','deviance','MinParentSize', 10); %deviance: "decrease entropy"
        imp = predictorImportance(treeIni);
        subplot(3,5,(year-primerYear)+1);
        bar(imp);
        h = gca;
        h.XTick=1:24;
        h.XTickLabel = 0:23;
        h.FontSize =4;
        %h.XTickLabelRotation = 45;
        %h.TickLabelInterpreter = 'none';
        title(sprintf('%d',year));
    end
    sgtitle(sprintf('Importancia de la hora para predecir estacion para %s',nomSerie));
    linkaxes;
end