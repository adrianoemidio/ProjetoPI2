% Disciplina de Processamento de imagens
% Projeto Parcial 1
% 
% @file projeto_parcial_1.m
% @author Adriano Leite Emidio
% @version 1.0
%

%Fecha todas as janelas
close all

%Remove as variáveis da memórai
clear

%Limpa a janela de comandos
clc

%Carrega o pacote para leitura de imagens
pkg load image

%kenel filtro de direções
k_norte = [1 1 1 ; 1 -2 1; -1 -1 -1]; %NORTE
k_sul   = [-1 -1 -1 ; 1 -2 1; 1 1 1]; %SUL
k_leste = [-1 1 1 ; -1 -2 1; -1 1 1]; %LESTE
k_oeste = [1 1 -1 ; 1 -2 -1; 1 1 -1]; %OESTE

p_baixa = [0 1 0; 1 1 1; 0 1 0];

neutro = [1 1 1 ; 1 1 1 ; 1 1 1];

%Função que executa a convulação periódica em imagens em escala de cinza
function retImg = ConvulucaoPeriodica(img, kernel)

  %Verifica se a imagem é colorida e a conteve para escala de cinza
  if isrgb(img)
    img = rgb2gray(img);
  end

  
   %tamanho da imagem
  [lin col] = size(img);
  
  %tamanho do kernel
  [kLin kCol] = size(kernel);
  
  %Percorre a imagem
  for i=1:lin
    for j=1:col
       
       %acumulador das somas
       acc = 0;
      
       %Percorre o kernel
       for k=1:kLin
          for l=1:kCol
            
            %calcula o pixel relativo da imagem em relação ao kernel
            i_rel = i + (k - (kLin - 1));
            j_rel = j + (l - (kCol - 1));
            
            %Verifica se as colunas utrapasssou a imagem
            if j_rel < 1
              j_rel = col + j_rel;
            elseif j_rel > col
              j_rel = j_rel - col;                 
            endif
            
            %Verifica se as linhas utrapasssou a imagem
            if i_rel < 1
              i_rel = lin + i_rel;
            elseif i_rel > lin
              i_rel = i_rel - lin;                 
            endif
            
            %if (i_rel > 0) && (i_rel <= lin) && (j_rel > 0) && (j_rel <= col)
            acc = acc + (kernel(k,l) * img(i_rel,j_rel));
            %endif
            
          endfor
       endfor

      retImg(i,j) = (acc);       
   
    end
  end
 
endfunction

%Função que executa a convulação periódica em imagens em escala de cinza
function retImg = ConvulucaoAperiodica(img,kernel)
  
  %Verifica se a imagem é colorida e a conteve para escala de cinza
  if isrgb(img)
    img = rgb2gray(img);
  end

  
   %tamanho da imagem
  [lin col] = size(img);
  
  %tamanho do kernel
  [kLin kCol] = size(kernel);
  
  %Percorre a imagem
  for i=1:lin
    for j=1:col
       
       %acumulador das somas
       acc = 0;
       
      
       %Percorre o kernel
       for k=1:kLin
          for l=1:kCol
            
            %calcula o pixel relativo da imagem em relação ao kernel
            i_rel = i + (k - (kLin - 1));
            j_rel = j + (l - (kCol - 1));
            
            if (i_rel > 0) && (i_rel <= lin) && (j_rel > 0) && (j_rel <= col)
              acc = acc + (kernel(k,l) * img(i_rel,j_rel));
            endif
            
          endfor
       endfor

      retImg(i,j) = (acc);       
   
    end
  end
  
endfunction

%Nome da imagem a ser aberta
imgName = 'rice_binary.png'

%Tenta abrir a imagem
A = imread(imgName);

%Maścara Norte
CA_Norte = ConvulucaoAperiodica(A,k_norte);
CP_Norte = ConvulucaoPeriodica(A,k_norte);

%Maścara Sul
CA_Sul = ConvulucaoAperiodica(A,k_sul);
CP_Sul = ConvulucaoPeriodica(A,k_sul);

%Maścara Leste
CA_Leste = ConvulucaoAperiodica(A,k_leste);
CP_Leste = ConvulucaoPeriodica(A,k_leste);

%Maścara Oeste
CA_Oeste = ConvulucaoAperiodica(A,k_oeste);
CP_Oeste = ConvulucaoPeriodica(A,k_oeste);


figure('name',imgName);

%Exibe figuras

%Maścara Norte
%Convulução Periódica
subplot(2,4,1);
imshow(CP_Norte);
title (sprintf("Norte - CP"));
%Convulução Aperiódica
subplot(2,4,5);
imshow(CA_Norte);
title (sprintf("Norte - CA"));

%Maścara Sul
%Convulução Periódica
subplot(2,4,2);
imshow(CP_Sul);
title (sprintf("Sul - CP"));
%Convulução Aperiódica
subplot(2,4,6);
imshow(CA_Sul);
title (sprintf("Sul - CA"));

%Maścara Leste
%Convulução Periódica
subplot(2,4,3);
imshow(CP_Leste);
title (sprintf("Leste - CP"));
%Convulução Aperiódica
subplot(2,4,7);
imshow(CA_Leste);
title (sprintf("Leste - CA"));

%Maścara Oeste
%Convulução Periódica
subplot(2,4,4);
imshow(CP_Oeste);
title (sprintf("Oeste - CP"));
%Convulução Aperiódica
subplot(2,4,8);
imshow(CA_Oeste);
title (sprintf("Oeste - CA"));

  
  
