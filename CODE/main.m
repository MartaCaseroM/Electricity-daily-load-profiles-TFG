addpath(genpath(pwd));
creaPerfilesReparto();
nomSerie = 'DEMELEH#P48';
nomInputVars = {'P0' 'P1' 'P2' 'P3' 'P4' 'P5' 'P6' 'P7' 'P8' 'P9' 'P10' 'P11' 'P12' 'P13' 'P14' 'P15' 'P16' 'P17' 'P18' 'P19' 'P20' 'P21' 'P22' 'P23'};
[ttp24h, timetableFestivos] = CargaDatos(nomSerie,nomInputVars);
K=12;

PrototipoClustersConstelacion(50,nomInputVars,ttp24h,K,DiasConstelacionesEstruct,gruposConstelaciones)
  
h = gca;
%h.XTick=1:24;
h.XTick=1:24;
h.XTickLabel = [string(0:23)];
xlabel('Hora');
ylabel('Demanda');
[G,H]=GrafoEvolucionCluster(ttp24h,K,nomInputVars,nomSerie);
gruposConstelaciones = EstructuraIDConstelaciones(ttp24h,K,G);
DiasConstelacionesEstruct=EstructuraDiasConstelaciones(gruposConstelaciones,K,ttp24h,nomInputVars);
%me tarda 9 mins :(
EstructTablaDiasMesesConstelaciones = EstructuraTablaClasificDiasYMeses(DiasConstelacionesEstruct);   

[EstructTablaDiasMesesConstelaciones,DiasConstelacionesEstruct,gruposConstelaciones]=CambioNombreConstelacionesEstruct(EstructTablaDiasMesesConstelaciones,DiasConstelacionesEstruct,gruposConstelaciones);


[GMeses,HMeses] = GrafoColoresMeses(ttp24h,K,nomInputVars,nomSerie);
[GEstaciones,HEstaciones] = GrafoColoresEstaciones(ttp24h,K,nomInputVars,nomSerie);

[GLaborables,HLaborables] = GrafoColoresDiasLaborables(ttp24h,K,nomInputVars,nomSerie,timetableFestivos);

[GDias,HDias] = GrafoColoresDias(ttp24h,K,nomInputVars,nomSerie,timetableFestivos);

[vecVarianza] = VectorVarianzaMedia(ttp24h,K,nomInputVars);
CambiarEtiquetasGrafo(G,H,ttp24h,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);
CambiarEtiquetasGrafo(GEstaciones,HEstaciones,ttp24h,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);
CambiarEtiquetasGrafo(GLaborables,HLaborables,ttp24h,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);
CambiarEtiquetasGrafo(GDias,HDias,ttp24h,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);
CambiarEtiquetasGrafo(GMeses,HMeses,ttp24h,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);


%% Analysis

%BOXPLOTS
BoxplotGeneral(nomSerie, ttp24h,nomInputVars);

%domingo
pintarAnalisisTemporalMediaDiaCadaMes(nomSerie,1,ttp24h);
%diciembre
analisisTemporalPerfilDiaYMesEspecifico(nomSerie,1,5,ttp24h);
%ultima fecha es  4 junio 2021 viernes->6
creaPerfilesReparto;
%pintarDiaCadaMes('DEMELEH#P48',1);
analisisTemporalPorDiaTodosMeses(nomSerie,ttp24h);
analisisTemporalPorDiaTodosMesesYear(nomSerie,ttp24h,2018,nomInputVars);
figure;
analisisTemporalDiaEspecifico(nomSerie,1,ttp24h);
legend(meses{:});
l = legend(meses{:});
l.ItemHitFcn = @hitcallback_ex1;
analisisTemporalDia(nomSerie,1,ttp24h);
boxplotPorMesesDiaEspecifico(nomSerie,1,thn);
addpath 'C:\Users\Usuario\Documents\ICAI\TFG\DATOS\DATOS\ALMACEN';
pintarAnalisisTemporalMediaDiaCadaMes(nomSerie,1,ttp24h);
analisisPerfilesUnaSerieCoefHoras(nomSerie,ttp24h);

pintarAnalisisTemporalMediaCadaMes(nomSerie,2019,ttp24h);
ruta = '..\DATA';
nomFi = sprintf('%s.txt',nomSerie);
fullFi = fullfile(ruta,nomFi);
th = readtable(fullFi);
th.FECHAHORA = datetime(th{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Zurich','locale','es_ES', 'Format', 'dd/MM/yyyy HH');

thn = normalizaDatosHorarios(th);
for i=0:6
    ttotal(i+1) = sum(th.DEM(88537+23*i:88537+23*i+23));
end
ttp24haux=ttp24h;
ttp24haux.FECHA.TimeZone = 'Europe/Zurich';
figure; ax =[];
axis tight;
ax(1)=subplot(3,1,1);
plot(th.FECHAHORA(88537:88536+24*7), th.DEM(88537:88536+24*7), '.-');
title('Demanda horaria original');
ax(2)= subplot(3,1,2);
stairs(ttp24haux.FECHA(3690:3696), ttotal,'o-'); % ojo con stairs mejor
title('Demanda diaria original');
ax(3)= subplot(3,1,3);
plot(th.FECHAHORA(88537:88536+24*7), reshape(ttp24h{3690:3696,1:end}',1,[]), '.-', 'linewidth', 3);
title('Perfil diario (coeficientes de reparto)');
linkaxes(ax,'x');
axis tight;
tight
%% K-means
infomat =load ('perfil_SEGELEH#TA20.mat');
infomat =load ('perfil_DEMELEH#P48.mat');

infomat.ttp24h = renamevars(infomat.ttp24h,{'PERFILH0' 'PERFILH1' 'PERFILH2' 'PERFILH3' 'PERFILH4' 'PERFILH5' 'PERFILH6' 'PERFILH7' 'PERFILH8' 'PERFILH9' 'PERFILH10' 'PERFILH11' 'PERFILH12' 'PERFILH13' 'PERFILH14' 'PERFILH15' 'PERFILH16' 'PERFILH17' 'PERFILH18' 'PERFILH19' 'PERFILH20' 'PERFILH21' 'PERFILH22' 'PERFILH23'},{'P0' 'P1' 'P2' 'P3' 'P4' 'P5' 'P6' 'P7' 'P8' 'P9' 'P10' 'P11' 'P12' 'P13' 'P14' 'P15' 'P16' 'P17' 'P18' 'P19' 'P20' 'P21' 'P22' 'P23'});
nomInputVars = {'P0' 'P1' 'P2' 'P3' 'P4' 'P5' 'P6' 'P7' 'P8' 'P9' 'P10' 'P11' 'P12' 'P13' 'P14' 'P15' 'P16' 'P17' 'P18' 'P19' 'P20' 'P21' 'P22' 'P23'};
ttp24h=infomat.ttp24h;
%nomInputVars = regexprep(nomInputVars,'PERFILH', 'P');
[idx, ctrs,sumd] = KMeans(ttp24h,K,nomInputVars);
num_veces3 = sum(idx==3);
num_veces1 = sum(idx==1);
num_veces2 = sum(idx==2);
num_veces4 = sum(idx==4);
num_veces5 = sum(idx==5);
num_veces6 = sum(idx==6);
num_veces7 = sum(idx==7);
K=7;
PlotClusters(ctrs,7,nomInputVars);
axis tight;
%SELECT K
Kini=1; Kfin=24;
%Quantization error
QuantizationError(ttp24h,Kini,Kfin,nomInputVars,nomSerie,2016);
%centroides de cada cluster
PlotCentroidesDiasEnClusterCorrespondiente(ttp24h,ctrs,idx,7,2,4);
[idx, ctrs,sumd]= KMeansYear(ttp24h,12,2019,nomInputVars);

PlotCentroidesDiasEnClusterCorrespondientePorYear(ttp24h,2019,ctrs,idx,12,3,4,nomSerie);
[vecOrden] = OrdenRespectoMasFrec(ttp24h,12,0,nomInputVars,2019);
PlotCentroidesDiasEnClusterCorrespondientePorYearNuevoOrden(ttp24h,2019,ctrs,idx,12,3,4,nomSerie,vecOrden);

%% arboles de clasificación

ImportanciaHoraParaPredecirIdCluster(ttp24h,K,nomInputVars,timetableFestivos,nomSerie);
xtickangle(45);
xlim([-1 24]);
ImportanciaHoraParaPredecirDiaSemana(ttp24h,K,nomInputVars,timetableFestivos,nomSerie);
ImportanciaHoraParaPredecirFestivo(ttp24h,K,nomInputVars,timetableFestivos,nomSerie);
%treeIni = fitctree(tr, 'IdCluster~PERFILH0+PERFILH1+PERFILH2+PERFILH3+PERFILH4+PERFILH5+PERFILH6+PERFILH7+PERFILH8+PERFILH9+PERFILH10+PERFILH11+PERFILH12+PERFILH13+PERFILH14+PERFILH15+PERFILH16+PERFILH17+PERFILH18+PERFILH19+PERFILH20+PERFILH21+PERFILH22+PERFILH23', 'SplitCriterion','deviance', 'MinParentSize', 10); %deviance: "decrease entropy"
K=7;
year=2017;
tr=TablaVariablesCategArbolClassif(ttp24h,K,year,nomInputVars,timetableFestivos); 
treeIni = fitctree(tr, 'IdCluster~Estación+Mes+Día+Festivo+P0+P1+P2+P3+P4+P5+P6+P7+P8+P9+P10+P11+P12+P13+P14+P15+P16+P17+P18+P19+P20+P21+P22+P23', 'SplitCriterion','deviance','MinParentSize', 10); %deviance: "decrease entropy"
view(treeIni,'mode','graph');
treeIni = fitctree(tr,'IdCluster~Est+Dia+Mes+Festivo','SplitCriterion','deviance','MinParentSize', 1); %deviance: "decrease entropy"
view(treeIni,'mode','text');
% show the tree
view(treeIni,'mode','graph');
t=view(treeIni);
title(sprintf('Árbol Clasificación %s',nomSerie));
%p02PlotInputSpacePartition(treeIni);%solo para 2 variables
Mdl = fitctree(tr,["DiaSemana","Estacion","Festivo"]);
%Importancia predictor
Mdl = fitctree(tr,'Estacion','DiaSemana','Surrogate','on');
%pruning level
[lTR,seTR,nLeafTR] = loss(treeIni,tr, 'DiaSemana', 'Subtrees', 'all', 'LossFun','classiferror');
figure;
plot(0:max(treeIni.PruneList), lTR,'.-');
set(gca,'Xdir','reverse');
xlabel('Pruning level (1 node - full tree)'); grid on;
ylabel('Error rate');

for numConstelacion=1:size(fieldnames(gruposConstelaciones))    
    HProtoConst=PrototipoClustersConstelacion(numConstelacion,nomInputVars,infomat,K,DiasConstelacionesEstruct,gruposConstelaciones)
    
    savefig(HProtoConst,sprintf('constelacion%d.fig',numConstelacion));
end
    
PrototipoClustersConstelacion(2,nomInputVars,infomat,K,DiasConstelacionesEstruct,gruposConstelaciones)
    
GrafoEvolucionClusterMesEspecifico(infomat,7,3,nomInputVars,nomSerie);

GrafoEvolucionCluster(infomat,36,nomInputVars,nomSerie);



G=GrafoEvolucionCluster(infomat,36,nomInputVars,nomSerie);



primerYear=2015;
ultimoYear=2020;
K=36;
K=12;

figure;
h=plot(G);
color={'g','b','k'}
highlight(h,1,'NodeColor',color{1})

find(contains(G.Nodes(:,1),"id3-2015"))



vec=indDias(3,2015,2020,infomat,36,nomInputVars);



%% prototipos de cada constelacion 

PrototipoClustersConstelacion(10,nomInputVars,infomat,K,DiasConstelacionesEstruct);

K=7;

[G,H]=GrafoEvolucionCluster(ttp24h,K,nomInputVars,nomSerie);

[GMeses,HMeses] = GrafoColoresMeses(ttp24h,K,nomInputVars,nomSerie);
[GEstaciones,HEstaciones] = GrafoColoresEstaciones(ttp24h,K,nomInputVars,nomSerie);

[GLaborables,HLaborables] = GrafoColoresDiasLaborables(ttp24h,K,nomInputVars,nomSerie,timetableFestivos);

[GDias,HDias] = GrafoColoresDias(ttp24h,K,nomInputVars,nomSerie,timetableFestivos);

addpath 'C:\Users\Usuario\Documents\ICAI\TFG\DATOS\DATOS\imagenes\demandaP48';
gruposConstelaciones = load('gruposConstelaciones.mat');
gruposConstelaciones = gruposConstelaciones.gruposConstelaciones;
DiasConstelacionesEstruct = load('DiasConstelacionesEstruct.mat');
DiasConstelacionesEstruct = DiasConstelacionesEstruct.DiasConstelacionesEstruct;
EstructTablaDiasMesesConstelaciones = load('EstructTablaDiasMesesConstelaciones.mat');
EstructTablaDiasMesesConstelaciones = EstructTablaDiasMesesConstelaciones.EstructTablaDiasMesesConstelaciones;
gruposConstelaciones = EstructuraIDConstelaciones(ttp24h,K,G);
DiasConstelacionesEstruct=EstructuraDiasConstelaciones(gruposConstelaciones,K,ttp24h,nomInputVars);
%me tarda 9 mins :(
EstructTablaDiasMesesConstelaciones = EstructuraTablaClasificDiasYMeses(DiasConstelacionesEstruct);   

[EstructTablaDiasMesesConstelaciones,DiasConstelacionesEstruct,gruposConstelaciones]=CambioNombreConstelacionesEstruct(EstructTablaDiasMesesConstelaciones,DiasConstelacionesEstruct,gruposConstelaciones);

matDist=[];
for i=2015:2019
      
    [idx1, ctrs1,sumd1] =KMeansYear(ttp24h,K,i+1,nomInputVars);
    [idx2, ctrs2,sumd2] =KMeansYear(ttp24h,K,i,nomInputVars);
    for p=1:K
        for k=1:K
            matDistaux(p,k) = sum(abs(ctrs2(p,:)-ctrs1(k,:)));
        end
    end
    matDist = [matDist; matDistaux];
end
minMatDist=min(matDist');
figure;
histogram(matDist,30);
figure;
histogram(minMatDist,30); %esta es la que he usado para guiarme para el umbral
title(sprintf('Histograma de distancias mínimas entre los perfiles de consumo tipo %s',nomSerie));
xlabel('Distancia');
ylabel('Frecuencia');
for w=1:K
    num_veces_vec(w)= sum(idx2 == w);
end
[M,idClustersOrd]=sort(num_veces_vec,'descend');


H.YData

highlight(H,[1],'YData',6);

y=get(H,'YData');
y(1)=6;
set(H,'YData',[[repmat(6,1,K)], [repmat(5,1,K)],[repmat(4,1,K)],[repmat(3,1,K)],[repmat(2,1,K)],[repmat(1,1,K)]])


%% data tip añadir constelacion 

[vecVarianza] = VectorVarianzaMedia(ttp24h,K,nomInputVars);
CambiarEtiquetasGrafo(G,H,infomat,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);
CambiarEtiquetasGrafo(GEstaciones,HEstaciones,ttp24h,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);
CambiarEtiquetasGrafo(GLaborables,HLaborables,infomat,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);
CambiarEtiquetasGrafo(GDias,HDias,infomat,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);
CambiarEtiquetasGrafo(GMeses,HMeses,infomat,K,gruposConstelaciones,nomInputVars,DiasConstelacionesEstruct,vecVarianza);

%% PCA

%un año específico
K=12;
year=2018;
AnalisisPCAYear(year,ttp24h,nomInputVars,K,timetableFestivos);

%todos los años
BiplotPCATodosYears(ttp24h,nomInputVars,nomSerie);
ScatterPlotPCATodosYears(ttp24h,nomInputVars,nomSerie);
ScreePlotPCATodosYears(ttp24h,nomInputVars,nomSerie);
Coeff1y2ComponentePrincipalPCATodosYears(ttp24h,nomInputVars,nomSerie);

BiplotPCATodosYearsSinDividirPorYear(ttp24h,nomInputVars,nomSerie);
X = ttp24h{:, nomInputVars};   
figure;
numPCShow = 2; 
subplot(2,1,1);
[loading, score, latent,~, explained, mu] = pca(X);
bar(loading(:,1));
xlabel('Hora'); ylabel('Pesos'); title (sprintf('Coeff. PC %d',1));
h = gca;
h.XTick=1:24;
h.XTickLabel = [string(0:23)];
subplot(2,1,2);
bar(loading(:,2));
xlabel('Hora');  title (sprintf('Coeff. PC %d',2)); 
ylabel('Pesos');
h = gca;
h.XTick=1:24;
h.XTickLabel = [string(0:23)];


X = ttp24h{:, nomInputVars};        
[loading, score, latent,~, explained, mu] = pca(X); 
%subplot(3,5,i-(primerYear-1));
% Scree plot
%p04ScreePlot(explained,false); %gráfico acumulada
nPrincComp = length(explained);

acumPEV = cumsum(explained);
yyaxis left;
bar(explained);
ylabel('Variance Explained (%)');
ylim([0 100]);
yyaxis right;
plot(acumPEV, '-o', 'linewidth', 3);
ylabel('Acumulated variance Explained (%)');
ylim([0 100]);
xlim([0.5 nPrincComp+0.5]);

set(gca,'xtick', 1:nPrincComp);

title ('Scree plot'); 
xlabel('Principal Component');

grid on;

%% arbol classif con la constelacion

[trfinal]=TablaVariablesCategArbolConstelacion(gruposConstelaciones,K,infomat,nomInputVars,3,timetableFestivos)
  trfinal(:,2)  
figure;
hold on;
for i=2:24
    plot(trfinal{:,i},trfinal.FECHA,'-o');
end
legend(nomInputVars);

figure;
hold on;
plot(trfinal{:,2},trfinal.FECHA,'-o');%P0
plot(trfinal{:,3},trfinal.FECHA,'-o');%P1
plot(trfinal{:,10},trfinal.FECHA,'-o');%P8
plot(trfinal{:,21},trfinal.FECHA,'-o');%P19
%plot(trfinal{:,22},trfinal.FECHA,'-o');%P20
plot(trfinal{:,8},trfinal.FECHA,'-o');%P6
legend('P0','P1','P8','P19','P6');
xlabel('Valor Perfil Normalizado');
ylabel('Tiempo');
title(sprintf('Evolucion perfil hora demanda %s',nomSerie));
plot(trfinal{:,2},trfinal.FECHA,'-o');

%% dendograma

ScatterPlotPCATodosYears(infomat,nomInputVars,nomSerie);
BiplotPCATodosYearsSinDividirPorYear(infomat,nomInputVars,nomSerie);

%create the tree
X = ttp24h{:, nomInputVars};
tree = linkage(X','average', 'correlation');

%plot with a threshold
figure;
hdg = dendrogram(tree, 'ColorThreshold','default', 'Labels', nomInputVars);
set(hdg,'LineWidth',2); grid minor;
figure;
hdg = dendrogram(tree, 'ColorThreshold',0.2, 'Labels', nomInputVars);
set(hdg,'LineWidth',2); grid minor;

title(sprintf('Clasificación Jerárquica horas %s',nomSerie));
xlabel('Hora');
ylabel('Disimilitud');
X = ttp24h{:, nomInputVars};
tr = TablaVariablesCategArbolClassifTodosYears(infomat,K,nomInputVars,timetableFestivos);
figure;plot(X); legend(nomInputVars); grid on; 
title(sprintf('Valor variables perfiles Año %d', year));
xlabel('Días');
figure;boxplot(X, 'Labels', nomInputVars , 'notch','on', 'orientation','horizontal'); 
title(sprintf('Boxplot demanda %s',nomSerie));



%% kmeans
K=12;
year=2019;
[idx, ctrs,sumd] = KMeansYear(ttp24h,K,year,nomInputVars);
PlotCentroidesDiasEnClusterCorrespondientePorYear(ttp24h,year,ctrs,idx,K,3,4);
sgtitle(sprintf('Demanda %s Año %d',nomSerie, year));




%% analizar anomalias de 2021
K=12;

diasID1Year2020 = indDias(1,2020,2021,infomat,K,nomInputVars);
diasID12Year2021 = indDias(12,2021,2021,infomat,K,nomInputVars);
mp24h=ttp24h{:,1:end};

aux = mp24h(find(ttp24h.FECHA == "13/07/2020"),:);
for i=find(ttp24h.FECHA == "13/07/2020")+1:find(ttp24h.FECHA == "13/07/2020")+4
    aux= [aux mp24h(i,:)];
end
aux1 = mp24h(find(ttp24h.FECHA == "12/07/2021"),:);
for i=find(ttp24h.FECHA == "12/07/2021")+1:find(ttp24h.FECHA == "12/07/2021")+4
    aux1= [aux1 mp24h(i,:)];
end
aux4 = mp24h(find(ttp24h.FECHA == "18/01/2021"),:);
for i=find(ttp24h.FECHA == "18/01/2021")+1:find(ttp24h.FECHA == "21/01/2021")
    aux4= [aux4 mp24h(i,:)];
end
aux5 = mp24h(find(ttp24h.FECHA == "07/09/2020"),:);
for i=find(ttp24h.FECHA == "07/09/2020")+1:find(ttp24h.FECHA == "07/09/2020")+4
    aux5= [aux5 mp24h(i,:)];
end

aux2 = mp24h(find(ttp24h.FECHA == "20/07/2020"),:);
for i=find(ttp24h.FECHA == "20/07/2020")+1:find(ttp24h.FECHA == "20/07/2020")+4
    aux2= [aux2 mp24h(i,:)];
end
aux3 = mp24h(find(ttp24h.FECHA == "19/07/2021"),:);
for i=find(ttp24h.FECHA == "19/07/2021")+1:find(ttp24h.FECHA == "19/07/2021")+4
    aux3= [aux3 mp24h(i,:)];
end

aux2 = [aux aux2];
aux3 = [aux1 aux3];

figure;
plot(aux');
hold on;
plot(aux1');
plot(aux4');
plot(aux5');
axis tight;
legend('13/07/2020-17/07/2020','12/07/2021-16/07/2021','18/01/2021-21/01/21');,'07/09/2020-11/09/2020');
title('Tercera semana de Julio lunes a viernes');

figure;
plot(aux2');
hold on;
plot(aux3');
axis tight;
legend('13/07/2020-24/07/2020','12/07/2021-23/07/2021');
title('Tercera y cuarta semana de Julio lunes a viernes');

h = gca;
h.XTick=1:7;
h.XTickLabel =string(datetime("13/07/2020",'InputFormat','dd/MM/yyyy'):datetime("17/07/2020",'InputFormat','dd/MM/yyyy'));
h.XTick=1:11;
h.FontSize =4;
xlabel(string(repmat(nomInputVars,[1,5])));
axis tight;

find(ttp24h.FECHA == "13/07/2020");





%% varianza por hora

PlotsEvolucionVarianzaPorHoraConstEspec(idConst,gruposConstelaciones,ttp24h,infomat,K,nomInputVars);
PlotsEvolucionVarianzaPorHoraTodosDatos(gruposConstelaciones,ttp24h,infomat,4,nomInputVars,nomSerie);

PlotsEvolucionVarianzaPorHoraTodosDatosNoLaborables(ttp24h,infomat,K,nomInputVars,nomSerie, timetableFestivos)
PlotsEvolucionVarianzaPorHoraTodosDatosLaborables(ttp24h,infomat,4,nomInputVars,nomSerie, timetableFestivos)
  
PlotsEvolucionMediaPorHoraTodosDatosLaborables(ttp24h,infomat,K,nomInputVars,nomSerie, timetableFestivos)
PlotsEvolucionMediaPorHoraTodosDatosNoLaborables(ttp24h,infomat,K,nomInputVars,nomSerie, timetableFestivos)
 

DendogramaVariabilidadNoLaborables(ttp24h,timetableFestivos);
DendogramaVariabilidadLaborables(ttp24h,timetableFestivos);
DendogramaVariabilidadTodosDatos(ttp24h,timetableFestivos);

PlotsEvolucionMediaPorHoraTodosDatos(gruposConstelaciones,ttp24h,infomat,K,nomInputVars,nomSerie)




