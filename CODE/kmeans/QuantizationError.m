function QuantizationError(ttp24h,Kini,Kfin,nomInputVars,nomSerie,year)

%X = ttp24h{:, nomInputVars};
years = ttp24h.FECHA.Year == year;
X = ttp24h{years, nomInputVars};
qe=[];
for K = Kini:Kfin
    [~, ~, sumd] = kmeans(X, K, 'replicates',100);
    qe(K)=sum(sumd);
end
figure; 
bar(qe);
axis tight;
xlabel('K');
ylabel('QE');
title(sprintf('Error cuantificación %s año %d',nomSerie,year));
grid on;
end