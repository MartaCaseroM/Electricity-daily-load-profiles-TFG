function [G,H] = GrafoColoresEstaciones(ttp24h,K,nomInputVars,nomSerie)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    [G,H]=GrafoEvolucionCluster(ttp24h,K,nomInputVars,nomSerie);     
    title(sprintf('%s Clasificación por estaciones del año',nomSerie));
    coloresEstaciones={'r','b','g','#FF8826','#BD2DFF','y','#FF47B1','c'};%naranja(4),morado(5),amarillo(6),rosa(7),cian(8)
    num_nodos=size(G.Nodes);
    colorIdNodo=num2cell(zeros(1,num_nodos(1)));
    i=1;
    for w=primerYear:ultimoYear
        for j=1:K
            
            vec_diasIdClust=indDias(j,w,ultimoYear,ttp24h,K,nomInputVars);            
            summer = 0;            
            winter = 0;
            spring = 0;
            fall = 0; 
            
            for e=1:size(vec_diasIdClust)    
                yearActual= vec_diasIdClust(e).Year;
                fechaActual=datetime(vec_diasIdClust(e),'InputFormat','dd/MM/yyyy');
                if (isbetween(fechaActual,datetime(sprintf("20/03/%d",yearActual),'InputFormat','dd/MM/yyyy'),datetime(sprintf("20/06/%d",yearActual),'InputFormat','dd/MM/yyyy')))
                    %primavera
                    spring = spring + 1;
                elseif (isbetween(fechaActual,datetime(sprintf("21/06/%d",yearActual),'InputFormat','dd/MM/yyyy'),datetime(sprintf("22/09/%d",yearActual),'InputFormat','dd/MM/yyyy')))
                    %verano
                    summer = summer + 1;
                elseif (isbetween(fechaActual,datetime(sprintf("23/09/%d",yearActual),'InputFormat','dd/MM/yyyy'),datetime(sprintf("21/12/%d",yearActual),'InputFormat','dd/MM/yyyy')))
                    %otoño
                    fall = fall + 1;
                elseif (isbetween(fechaActual,datetime(sprintf("22/12/%d",yearActual)),datetime(sprintf("31/12/%d",yearActual))))
                    %invierno
                    winter = winter + 1;
                elseif (isbetween(fechaActual,datetime(sprintf("01/01/%d",yearActual),'InputFormat','dd/MM/yyyy'),datetime(sprintf("19/03/%d",yearActual),'InputFormat','dd/MM/yyyy')))
                    %invierno
                    winter = winter + 1;
                end
            end
            vecPesos = [summer, winter, spring, fall];
            [seasonFrec,ind_seasonFrec]=max(vecPesos);
            
            porcentajePredominio = seasonFrec/sum(vecPesos);
            if porcentajePredominio<0.7
                %mezcla
                vecPesosaux= vecPesos;
                vecPesosaux(ind_seasonFrec)=0;                
                [SegundoseasonFrec,Segundoind_seasonFrec]=max(vecPesosaux);
                if ((SegundoseasonFrec/sum(vecPesosaux))>0.2)
                    if (ind_seasonFrec == 1)
                        if(Segundoind_seasonFrec == 3)
                            %mezcla verano&primavera
                            ind_seasonFrec = 7;%rosa
                        elseif(Segundoind_seasonFrec == 4)
                            %mezcla otoño&verano
                            ind_seasonFrec = 6;%amarillo
                        end 
                    elseif (ind_seasonFrec == 2)
                        if(Segundoind_seasonFrec == 3)
                            %mezcla invierno&primavera
                            ind_seasonFrec = 8;%cian
                        elseif(Segundoind_seasonFrec == 4)
                            %mezcla invierno&otoño
                            ind_seasonFrec = 5;%morado
                        end
                    elseif (ind_seasonFrec == 3)
                        if(Segundoind_seasonFrec == 1)
                            %mezcla primavera&verano
                            ind_seasonFrec = 7;%rosa
                        elseif(Segundoind_seasonFrec == 2)
                            %mezcla primavera&invierno
                            ind_seasonFrec = 8;%cian
                        end
                    elseif (ind_seasonFrec == 4)
                        if(Segundoind_seasonFrec == 2)
                            %mezcla otoño&invierno
                            ind_seasonFrec = 5;%morado
                        elseif(Segundoind_seasonFrec == 1)
                            %mezcla otoño&verano
                            ind_seasonFrec = 6;%amarillo
                        end
                    end
                end
                
            end
            colorIdNodo{i}=coloresEstaciones{ind_seasonFrec};
            i=i+1;
        end
    end
    str = 'Rojo = Verano; Azul = Invierno; Naranja = Otoño; Verde = Primavera; Morado = Invierno&Otoño; Cian = Invierno&Primavera; Rosa = Primavera&Verano; Amarillo = Verano&Otoño';
    annotation('textbox','String',str,'FontSize',8,'FitBoxToText','on','Position',[0.15,0.0,0.1,0.1]);
    for i=1:num_nodos
        highlight(H,i,'NodeColor',colorIdNodo{i});
        hold on;
    end
end