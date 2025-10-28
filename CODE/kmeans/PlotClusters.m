function PlotClusters(ctrs,K,nomInputVars)
%years = ttp24h.FECHA.Year ==2018;
figure;
hold on;
plot(ctrs','-s','linewidth',3,'Markersize',4);
set(gca,'xtick',1:length(nomInputVars)); 
set(gca,'xticklabel',nomInputVars);
ylabel('Demanda Normalizada');
grid minor;
legend(strcat('CLUSTER-', num2str([1:K]')));
title ('Cluster prototypes (centroids)');
end