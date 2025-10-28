function [gruposConstelaciones] = EstructuraIDConstelaciones(ttp24h,K,G)
    primerYear = ttp24h.FECHA.Year(1,:);    
    ultimoYear = ttp24h.FECHA.Year(end,:);
    numConstelacion=0;
    gruposConstNodos=zeros(1,K*((ultimoYear-primerYear)+1));
    gruposConstelaciones = struct;
    for i=0:(ultimoYear-primerYear)
        for j=0:K-1
            %j=6;
            if(isempty(predecessors(G,(i*K)+1+j)))
                %grupo nuevo
                numConstelacion = numConstelacion +1;
                gruposConstNodos((i*K)+j+1) = numConstelacion;
                gruposConstelaciones.(sprintf('constelacion%d',numConstelacion))=G.Nodes((i*K)+j+1,1);            
            end
            %f=isempty(successors(G,42));
            %(successors(G,42)== 42) || (isempty(successors(G,42)))
            if(isempty(successors(G,(i*K)+j+1)))
                %fin grupo            
            else
                N = successors(G,(i*K)+j+1); 
                if(gruposConstNodos(N)>0)
                    %nodo ya forma parte de otra constelacion
                    grupoActual = gruposConstNodos((i*K)+1+j);
                    grupoNuevo = gruposConstNodos(N);
                    aux1 = gruposConstelaciones.(sprintf('constelacion%d',gruposConstNodos((i*K)+1+j)));
                    aux2 = gruposConstelaciones.(sprintf('constelacion%d',gruposConstNodos(N)));
                    %gruposConstelaciones.(sprintf('constelacion%d',gruposConstNodos((i*K)+1+j))) = [];
                    gruposConstelaciones=rmfield(gruposConstelaciones,sprintf('constelacion%d',gruposConstNodos((i*K)+1+j)));
                    aux1 = [aux2;aux1];
                    gruposConstelaciones.(sprintf('constelacion%d',gruposConstNodos(N)))= aux1;
                else
                    %añado info sucesores
                    gruposConstNodos(N)= gruposConstNodos((i*K)+j+1);
                    aux3 = gruposConstelaciones.(sprintf('constelacion%d',gruposConstNodos((i*K)+j+1)));
                    aux3(end+1,1)= G.Nodes(N,1);%aqui esta el problema 
                    gruposConstelaciones.(sprintf('constelacion%d',gruposConstNodos((i*K)+j+1))) = aux3;
                end
            end

        end
    end
end