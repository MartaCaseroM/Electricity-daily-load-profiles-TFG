function PlotCentroidesDiasEnClusterCorrespondientePorYearNuevoOrden(ttp24h,year,ctrs,idx,K,row,col,nomSerie,vecOrden)



years = ttp24h.FECHA.Year == year;
mp24h = [ttp24h{years,1:end}]; 
figure;
for i=1:length(idx)
    hold on;
    subplot(row,col,vecOrden(idx(i)));    
    plot(mp24h(i,:));    
end

for i=1:K
    hold on;
    subplot(row,col,vecOrden(i));    
    title(sprintf("cluster %d",vecOrden(i)));
    plot(ctrs(i,:)','k','linewidth',3);
    axis tight;
end
sgtitle(sprintf('%s año %d',nomSerie,year));
linkaxes;
end