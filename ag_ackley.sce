clear; 
clc;

tam_pop = 100;
geracoes = 70;

//função Ackley
function[ackley] = funcao(x,y)
    ackley = -20 * exp(-0.2 * sqrtm(0.5*((x^2)+(y^2)))) - exp(0.5*(cos(2*%pi*x) + cos(2*%pi*y))) + exp(1) + 20;
endfunction

//geração de indivíduos
function[pop] = Gera_Ind(tam_pop)
    individuos = round(rand(tam_pop,1)*2^40);//geração de 100 valores
    pop = dec2bin(individuos,40);//conversão dos valores para binário de 40 bits
endfunction

function[x] = convX(pop)
    X_aux = part(pop,1:20);//20 bits referentes ao x
    
    X_real = bin2dec(X_aux);//binario para decimal

    //x pertence ao intervalo [-5 5]
    //x = l_inf + (l_sup - l_inf)/((2^20) - 1) * X_real;
    x = -5 + (5 - (-5)) / ((2^20) - 1) * X_real;
endfunction

function[y] = convY(pop)
    Y_aux = part(pop,21:40);//20 bits referentes ao y
    
    Y_real = bin2dec(Y_aux);//binario para decimal
    
    //y pertence ao intervalo [-5 5]
    //y = l_inf + (l_sup - l_inf)/((2^20) - 1) * Y_real;
    y = -5 + (5 - (-5)) / ((2^20) - 1) * Y_real;
endfunction

//cada posição de "avaliaCromossomo" se refere ao valor de cada posição de "pop" (população)
function[avaliaCromossomo] = AvaliaPopu(tam_pop,pop)
    x = 0;
    y = 0;
    avaliaCromossomo = ones(tam_pop,1);
    
    for i = 1:tam_pop
        x = convX(pop(i));
        y = convY(pop(i));
        avaliaCromossomo(i) = funcao(x,y);    
    end
endfunction

/////METODO DOS TORNEIOS/////
function[pais] = torneio(tam_pop,pop)
    concorrente = pop(1:6);
    pais = pop;
    
    for i = 1:tam_pop
        for j = 1:6
            concorrente(j) = pop(ceil(rand()*100));
        end
        
        avaliaCromossomo = AvaliaPopu(6,concorrente);
        [avaliacao pos] = min(avaliaCromossomo);
        pais(i) = concorrente(pos);        
    end
endfunction

//cruzamento
function[filho1,filho2] = Cruzamento(pai1,pai2)
    corte = int(rand()*39);//valor aleatório de 1 a 39 para o ponto de corte
    
    //separação do número em dois pedaços a partir do ponto de corte
    pai1_1 = part(pai1,1:corte);
    pai1_2 = part(pai1,corte + 1:40);
    pai2_1 = part(pai2,1:corte);
    pai2_2 = part(pai2,corte + 1:40);
    
    //junção dos valores dos pais para criar filhos
    filho1 = pai1_1 + pai2_2;
    filho2 = pai2_1 + pai1_2;
endfunction

//cruzamento dos filhos com os pais
function[filhos] = Gera_filhos(tam_pop,pais,pop)
    filhos = pop;
    
    for i=1:2:tam_pop
        [filhos(i) filhos(i+1)] = Cruzamento(pais(i),pais(i+1));
    end
endfunction

//mutação de um cromossomo
function[indmutado] = mutacao(individuo)
    prob = rand()*200;//valor aleatório de 0 a 200
    
    //cada bit vai ser analisado separadamente e tem a probabilidadede 0.5% de sofrer mutação (se prob < 1.0)
    for i = 1:40
        bit = part(individuo,i);
        if prob < 0.5
            if bit == "1" then
                bit = "0";
            else
                bit = "1";
            end            
        end
        
        if i == 1 then
            indmutado = bit;
        else
            indmutado = indmutado + bit;
        end       
    end
endfunction

//mutação dos cromossomos
function[filhosMutados] = Fazmutacao(tam_pop,filhos,pop)
    filhos_mutados = pop;
    
    for i = 1:tam_pop
        filhosMutados(i) = mutacao(filhos(i));
    end
endfunction

//Função para fazer o treinamento do algoritmo
function[pop,x,y] = treino(tam_pop,pop)
    for i = 1:geracoes
        x = ones(tam_pop,1);
        y = ones(tam_pop,1);
        
        for j = 1:tam_pop
            x(j) = convX(pop(j));
            y(j) = convY(pop(j));
        end
        
        avaliaCromossomo = AvaliaPopu(geracoes,pop);       
        
        pais = torneio(tam_pop,pop);//pais que escolhidos no torneio
        filhos = Gera_filhos(tam_pop,pais,pop);
        filhosMutados = Fazmutacao(tam_pop,filhos,pop);//mutação dos filhos
        pop = filhosMutados;  
    end
endfunction
////////////////////////////

pop = Gera_Ind(tam_pop);

avaliaCromossomo = AvaliaPopu(geracoes,pop);

[pop x y] = treino(tam_pop,pop);

//resultados
[avaliacao pos] = min(avaliaCromossomo);
mprintf("Valor mínimo da função: %f\n",avaliacao);
mprintf("\nValores de x e y que satisfazem f(x,y) = f(%f,%f)",x(pos),y(pos));
