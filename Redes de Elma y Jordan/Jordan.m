#Configuramos para poder abrir archivos openDocument
pkg load io;
javaaddpath jOpenDocument-1.3.jar;
#Leemos la columna correpondiente a los valores de la bolsa al cierre
M=odsread('IberdrolaNOV15DIC16.ods','2016-12-14','B2:B255');
M=M./10;

#Inicializamos los pesos de las distintas capas
W0 = rand(21,10);
W1 = rand(10,1);

vaciertos = [];

#Comienzo epoca
for Epoca=1:100
#Fase de entrenamiento

r=ceil(rand(1)*234);

anteriorSalida = 0;
u0 = [];
y0 = [];
u1 = [];
y1 = [];

for a=r:156+r
#Fase hacia delante
  if(a>234)
    i=a-234;
  else
    i=a;
  endif;
  entrada = cat(1,M(i:19+i),anteriorSalida)';#Entrada a la primera capa con los valores de entrada y la salida de la oculta 
  #Capa entrada->oculta
  for j=1:10
    u0(j) = sum(entrada*W0(:,j));
  end;
  for j=1:10
    y0(j) = 1 / (1 + e^-u0(j));#Aplicamos sigmoide
  end;
  #Capa oculta->salida
  u1 = sum(y0*W1);
  y1 = 1 / (1 + e.^-u1);#Aplicamos sigmoide
#Fase hacia atras
  #Actualizacion capa entrada->oculta
  for j=1:10
    er = 0;
    er = (M(20+i)-y1)*(e^-y1 /(1 + e^-y1)^2)*W1(j);
    er *= e^-y0(j) /(1 + e^-y0(j))^2;
    for k=1:21
      W0(k,j) = W0(k,j)+0.2 * er * entrada(1,k);
    end;
  end;
  #Actualizacion capa oculta->salida
  for j=1:10
    er = (M(20+i)-y1) * (e^-y1 /(1 + e^-y1)^2);
    W1(j)=W1(j)+0.2 * er * y0(1,j);
  end;
  
  anteriorSalida = y1;
  
end;

#Fase de prueba
aciertos = 0;
for a=r-79:r-1
  if(a<1)
    i=a+234;
  else
    i=a;
  endif;
  entrada = cat(1,M(i:19+i),anteriorSalida)';#Entrada a la primera capa con los valores de entrada y la salida de la oculta 
  #Capa entrada->oculta
  for j=1:10
    u0(j) = sum(entrada*W0(:,j));
  end;
  for j=1:10
    y0(j) = 1 / (1 + e^-u0(j));#Aplicamos sigmoide
  end;
  #Capa oculta->salida
  u1 = sum(y0*W1);
  y1 = 1 / (1 + e.^-u1);#Aplicamos sigmoide
  if(M(20+i)-y1 < 0.005 && M(20+i)-y1 > -0.005) 
    aciertos += 1;
  endif;
  anteriorSalida = y1;
end;
paciertos = aciertos*100/85
vaciertos(Epoca) = paciertos;
#Fin Epoca
end;

plot(vaciertos);