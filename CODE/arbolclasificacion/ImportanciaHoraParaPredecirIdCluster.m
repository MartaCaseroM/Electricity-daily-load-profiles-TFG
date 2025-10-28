function ImportanciaHoraParaPredecirIdCluster(ttp24h,K,nomInputVars,timetableFestivos,nomSerie)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    figure;
    for year=primerYear:ultimoYear
        %year =2008;
        %K=12;
        tr=TablaVariablesCategArbolClassif(ttp24h,K,year,nomInputVars,timetableFestivos); 
        treeIni = fitctree(tr, 'IdCluster~Estacion+Dia+Mes+P0+P1+P2+P3+P4+P5+P6+P7+P8+P9+P10+P11+P12+P13+P14+P15+P16+P17+P18+P19+P20+P21+P22+P23', 'SplitCriterion','deviance','MinParentSize', 1); %deviance: "decrease entropy"
        
        %treeIni = fitctree(tr, 'IdCluster~P0+P1+P2+P3+P4+P5+P6+P7+P8+P9+P10+P11+P12+P13+P14+P15+P16+P17+P18+P19+P20+P21+P22+P23', 'SplitCriterion','deviance','MinParentSize', 1); %deviance: "decrease entropy"
        imp = predictorImportance(treeIni);
        subplot(3,2,(year-primerYear)+1);
        bar(imp);
        h = gca;
        %h.XTick=1:24;
        h.XTick=1:27;
        %h.XTickLabel = [string(0:23)];
        h.XTickLabel = [string(treeIni.PredictorNames)];
        h.FontSize =7;
        %h.XTickLabelRotation = 45;
        %h.TickLabelInterpreter = 'none';
        title(sprintf('%d',year));
        xtickangle(45);
        ylabel('Estimaciones');
    end
    sgtitle(sprintf('Importancia de variables para clasificar IdCluster para %s',nomSerie));
    linkaxes;
end