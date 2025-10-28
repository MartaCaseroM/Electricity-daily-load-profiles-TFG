function AnalisisPCAYear(year,ttp24h,nomInputVars,K,timetableFestivos)
    %year =2008;
    
    years = ttp24h.FECHA.Year == year;
    X = ttp24h{years, nomInputVars};
    tr = TablaVariablesCategArbolClassif(ttp24h,K,year,nomInputVars,timetableFestivos);
    figure;plot(X); legend(nomInputVars); grid on; 
    title(sprintf('Valor variables perfiles Año %d', year));
    xlabel('Días');
    figure;boxplot(X, 'Labels', nomInputVars , 'notch','on', 'orientation','horizontal'); 

    %figure;plotmatrix(X);
    disp('covariance matrix:');disp(cov(X));
    disp('correlation matrix:');disp(corr(X));

    % Run PCA
    [loading, score, latent,~, explained, mu] = pca(X);

    % Scree plot
    p04ScreePlot(explained,true); %gráfico acumulada

    % Plot loadings (i.e. the coeffients of each principal component)
    numPCShow = 2;
    figure;
    for i=1:numPCShow
        subplot(numPCShow,1,i);
        bar(loading(:,i));
        xlabel('Input'); ylabel('Loading'); title (sprintf('Coeff. PC %d',i));
    end
    %las componentes salen de tipo tamaño~ con valores positivos y negativos.
    figure;
    plot(score(:,1),score(:,2),'.', 'Markersize',15);
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');

    % Plot Estacion labels in each point
    figure;
    plot(score(:,1),score(:,2),'.', 'Markersize',15);
    text(score(:,1),score(:,2), tr.Mes);
    title ('Mes');
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');

    % Plot Estacion labels in each point
    figure;
    plot(score(:,1),score(:,2),'.', 'Markersize',15);
    text(score(:,1),score(:,2), tr.Estacion);
    title ('Estacion');
    xlabel('1st Principal Component');
    ylabel('2nd Principal Component');%separa otoñoyinvierno con veranoyprimavera la componente2

    nComp = 2; % select the first 2 principal components, si hacemos que nComp=1, sigue explicando bastante.
    fprintf('Number of original variables: %d Number of observations: %d\n', size(X,2), numel(X));
    fprintf('Number of selected PC: %d Number of observations: %d\n', nComp, nComp * size(X,1));

    % reconstruct the original variables from the first nComp PC's
    Xhat = score(:,1:nComp) * loading(:,1:nComp)'; %zeta*pesostraspuesto(columna-pesos cada componente principal)
    Xhat = bsxfun(@plus, Xhat, mu); % add the mu to each variable

    figure;
    ax(1)=subplot(2,1,1); plot(X); title ('ORIGINAL VARIABLES');legend(nomInputVars);
    ax(2)=subplot(2,1,2); plot(Xhat); title ('RECONSTRUCTED VARIABLES FROM 1ST & 2ND PC');legend(nomInputVars);
    linkaxes(ax,'xy');

    nComp = 1; % select the first 2 principal components, si hacemos que nComp=1, sigue explicando bastante.
    fprintf('Number of original variables: %d Number of observations: %d\n', size(X,2), numel(X));
    fprintf('Number of selected PC: %d Number of observations: %d\n', nComp, nComp * size(X,1));

    % reconstruct the original variables from the first nComp PC's
    Xhat = score(:,1:nComp) * loading(:,1:nComp)'; %zeta*pesostraspuesto(columna-pesos cada componente principal)
    Xhat = bsxfun(@plus, Xhat, mu); % add the mu to each variable

    figure;
    ax(1)=subplot(2,1,1); plot(X); title ('ORIGINAL VARIABLES');legend(nomInputVars);
    ax(2)=subplot(2,1,2); plot(Xhat); title ('RECONSTRUCTED VARIABLES FROM 1ST PC');legend(nomInputVars);
    linkaxes(ax,'xy');


    figure; hold on; %only one varible
    plot(X(:,1)); plot(Xhat(:,1)); legend({'Original', 'Reconstructed'});


    figure;
    numDims = 2; %max 3D (try it!)
    biplot(loading(:,1:numDims),'scores',score(:,1:numDims),'varlabels', nomInputVars);
    axis square;
    
end