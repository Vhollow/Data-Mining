#Matriz con los puntos a clasificar como vectores
	entradas = [
		-1,-1,1;
		1,-1,-1;
		1,1,1;
		-1,1,1;
		-1,-1,-1;
		1,1,-1;
	];
#Matriz con los puntos que actuarán como patrones a reconocer
	patrones = [
		1,-1,1;
		-1,1,-1;
	];
#Matriz de pesos
	w = [
		0,0,0;
		0,0,0;
		0,0,0;
	];
#Entrenamiento
	for i=1:3
		for j=1:3
			if(i!=j)
				for k=1:2
					w(i,j) += patrones(k,i)*patrones(k,j);
				end;
			endif;
		end;
	end;

#Clasificación
	for e=1:6
		s = [];
		s = entradas(e,:);
		do
			s_ant = s;
      #Iteración sobre los elementos del vector
			for i = 1:3
        #Signo con la evolución de estado
				temp = 0;
				for j = 1:3
					temp += w(i,j)*s_ant(j);
				end;
        #Cambiamos estado
				if(sign(temp) == 1)#Signo positivo
					s(i) = 1;
				elseif(sign(temp) == -1)#Signo negativo
					s(i) = -1;
				endif;
			end;
      #Comparación del vector estado con el anterior
      a = length(s)- sum(s == s_ant) ;
		until( a == 0)
		s
	end;

