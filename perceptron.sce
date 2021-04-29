clear;
clc;

//-----INSERÇÃO DOS DADOS-----
taxa = 0; //taxa de aprendizagem
epocas = 0; //quantidade de épocas
dados = []; //dataset
sair = 's'; //auxiliar para terminar a inserção de dados

//input para valores maiores que zero e menores ou iguais a 1
while (0>=taxa || taxa>1) do
    taxa = input("Indique a taxa de aprendizagem: ");
end

//input para valores não negativos
while (epocas<=1) do
    epocas = input("Indique o número de épocas: ");
end

//input para os dados (x1,x2,classe)
while (sair~='n') do
    x1 = input("Indique x1: ");
    aux = [x1];
    x2 = input("Indique x2: ");
    aux = [aux x2];
    classe = input("Indique a classe (0 ou 1): ");
    aux = [aux classe];
    dados = [dados;aux];
    //o caractere deve ser inserido no console entre ''
    sair = input("Continuar inserção? [s/n]: ");
    clc;
end
//----------------------------

X = dados(:,1:2)'; //vetores (transposto)
Y = dados(:,3)'; //rótulos (transposto)

[l c] = size(X); //tamanho de X'

X_bias = [(-1) * ones(1,c); X]; //adição do bias
W = rand(1,3); //matriz de pesos aleatórios

i = 0;
for ciclo = 1:epocas
    if( i < c) then 
        i = i + 1;
    end
    
    j = 1;
    while (j==1)
        U = W*X_bias(:,i); //ativação
        // calcular a função degrau saída
        if (U > 0) then
            Y_pred = 1;
        else
            Y_pred = 0;
        end
        
        e = Y(i) - Y_pred; //erro
        
        if e == 0 then
           W = W;
           j = 0;
        else
           //ajuste dos pesos (aprendizagem)
           W = W + (taxa * e * X_bias(:,i))';
        end
    end
end

//-----PLOTAGEM DA SEPARAÇÃO-----
//marcação dos pontos dados
for i = 1:c
    if Y(i) == 1
        plot(X(1,i),X(2,i),'g*:');
     else
        plot(X(1,i),X(2,i),'b+:');
     end
end
mtlb_axis([-5 15 -5 15])

//reta de classificação
k = 0;
for i = -1:0.01:10
    k = k + 1;
    XX(k) = i;
    YY(k) = -((W(2)*i)/W(3))-((W(1)*-1)/W(3));
end
plot(XX,YY);
mtlb_axis([-5 15 -5 15])
//-------------------------------
