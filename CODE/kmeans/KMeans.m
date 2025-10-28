function [idx, ctrs,sumd]= KMeans(ttp24h,K,nomInputVars)
% obtención de idx, ctrs, sumd al aplicar Kmeans

%years = ttp24h.FECHA.Year ==2018;
X = ttp24h{:, nomInputVars};
rng('default'); 
[idx, ctrs,sumd] = kmeans(X,K,'replicates',100,'MaxIter',1000);
end