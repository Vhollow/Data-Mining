M=dlmread('digitos.entrena.normalizados.txt');
#Separamos una matriz con las entradas y otra con las etiquetas correspondientes
E=[];
for i=1:270
  E(i,:)= M(i+1,:);
  M(i+1,:)=[];
end;
M = [M ones(size(M, 1), 1)];
#Normaliza vectores de la matriz de entrada
norm=M.^2;
norm=sum(M');
norm=sqrt(norm);

for i=1:270
  M(i,:)=M(i,:)/norm(:,i);
end;
#Crea mapa con vectores de peso aleatorios y los normaliza
map=rand(96,41);
nmap=map.^2;
nmap=sum(nmap');
nmap=sqrt(nmap);

for i=1:96
  map(i,:)=map(i,:)/nmap(:,i);
end;

#Fase de entrenamiento
for epoca=1:4
radio=4-epoca;
for i=1:270
  distancia=3000;
  alpha=25/(1+epoca/270);
  #Calculamos la salida mas cercana
  for j=1:96
    d=M(i,:)-map(j,:);
    d=d.^2;
    d=sum(d');
    d=sqrt(d);
    if(d<distancia)
      distancia=d;
      sal=j;
    endif;
  end;
  #Cambio el numero por fila y columna
  f=floor(sal/12);
  c=sal-12*(f-1);
  #Actualizamos las neuronas alrededor de la ganadora
  for a=f-radio:f+radio
    for b=c-radio:c+radio
      #Corregimos las filas y columnas que se salen de la matriz
      if(a<1)
        fil=8+a;
      elseif(a>8)
        fil=a-8;
      else
        fil=a;
      endif;
      
      if(b<1)
        col=12+b;
      elseif(b>12)
        col=b-12;
      else
        col=b;
      endif;
      #Actualizamos pesos
      n=8*(fil-1)+col;
      x= map(n,:)+(M(i,:)*alpha);
      nX= x.^2;
      nX=sum(nX');
      nX=sqrt(nX);
      map(n,:)= x./nX;
    end;
  end;  
end;
end;

#Etiquetado del mapa
map_etiquetas=[];
for n=1:96
  #Calculamos la entrada mas cercana a la neurona
  distancia=3000;
  for i=1:270
    d=M(i,:)-map(n,:);
    d=d.^2;
    d=sum(d');
    d=sqrt(d);
    if(d<distancia)
      distancia=d;
      sal=i;
    endif;
  end;
  #Asignamos la etiqueta
  map_etiquetas(n,:)=E(sal,:);  
end;

#Fase de prueba
Prueba=dlmread('digitos.test.normalizados.txt');
sal_esp=[];
for i=1:70
  sal_esp(i,:)= Prueba(i+1,:);
  Prueba(i+1,:)=[];
end;
Prueba = [Prueba ones(size(Prueba, 1), 1)];
#Normaliza vectores de la matriz de entrada
nPrueba=Prueba.^2;
nPrueba=sum(nPrueba');
nPrueba=sqrt(nPrueba);

for i=1:70
  Prueba(i,:)=Prueba(i,:)/nPrueba(:,i);
end;

num_aciertos=0;
for i=1:70
  distancia=3000;
  #Calculamos la salida mas cercana
  for j=1:96
    d=Prueba(i,:)-map(j,:);
    d=d.^2;
    d=sum(d');
    d=sqrt(d);
    if(d<distancia)
      distancia=d;
      sal=j;
    endif;
  end;
  #Comprobamos si ha sido bien clasificado
  if(map_etiquetas(sal,:)== sal_esp(i,:))
    num_aciertos++;
  endif;
 end;
 num_aciertos