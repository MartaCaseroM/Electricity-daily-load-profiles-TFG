function [idx, ctrs,sumd]= KMeansDia(ttp24h, dia, K,nomInputVars)
% obtención de idx, ctrs, sumd al aplicar Kmeans, eligiendo un día
% determinado

%years = ttp24h.FECHA.Year ==2018;
days = weekday(ttp24h.FECHA) ==dia; %| weekday(ttp24h.FECHA) == 7;
X = ttp24h{days, nomInputVars};
rng('default'); 
[idx, ctrs,sumd] = kmeans(X,K,'replicates',100,'MaxIter',1000);
end