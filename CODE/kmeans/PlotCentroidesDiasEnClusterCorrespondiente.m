function PlotCentroidesDiasEnClusterCorrespondiente(ttp24h,ctrs,idx,K,row,col)

mp24h = [ttp24h{:,1:end}]; 
figure;
for i=1:length(idx)
    hold on;
    subplot(row,col,idx(i));    
    plot(mp24h(i,:));
end

for i=1:K
    hold on;
    subplot(row,col,i);    
    title(sprintf("cluster %s"),i);
    plot(ctrs(i,:)','k','linewidth',3);
    axis tight;
end

end