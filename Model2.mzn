% ====== Proyecto de Curso Implementacion Parte II ======

% Planificación de los ensayos en una telenovela *
% Programación por Restricciones
% Escuela de Ingenierı́a de Sistemas y Computación
% Facultad de Ingenierı́a

% ====== Integrantes =======
%  Alexander Gonzalez      201429927
%  Carlos Esteban Murillo  201526857

% ====== Funciones =======

include "globals.mzn";
include "./Functions/getIndexMax.mzn";
include "./Functions/getIndexMin.mzn";
include "./Functions/getBigger.mzn";
include "./Functions/varCostActor.mzn";
include "./Functions/getCostActor.mzn";

% ====== Parametros =======

enum ACTORES;

array[ACTORES, int] of int: Escenas; 

array[int] of int: Duracion;

% ====== Parametros Disponibilidad y Evitar =======

array[int, 1..2] of int: Disponibilidad;

int: dispLength = length(Disponibilidad) div 2;

array[int, 1..2] of ACTORES: Evitar;

int: eviLength = length(Evitar) div 2;
  
% ====== Constantes y variables Iniciales =======

int: lim = length(Duracion);

int: len = lim + 1;

set of int: s =  1..lim;

array[s] of var s: e; % Arreglo Solucion

% ====== Restricciones =======

constraint all_different(e);

% Upper indexs
% Guarda el indice de la ultima escena para un actor en particular
array[ACTORES] of var s: U;
constraint forall(a in ACTORES)(U[a] == getIndexMax(a));

%Lower indexs
% Guarda el indice de la primera escena para un actor en particular
array[ACTORES] of var s: L;
constraint forall(a in ACTORES)(L[a] == getIndexMin(a));

%Bigger
% Se Calcula el actor mas costoso para la produccion y se determina un rango especifico para sus escenas
var ACTORES: big;
constraint big == getBigger();
var int: sm_bg == sum(i in s)(Escenas[big, i]);
constraint U[big] - L[big] + 1 == sm_bg;

%Se calcula la distancia maxima entre un LowerBound hasta el UpperBound con el fin de restringir las distancias maximas del resto de actores. 
array[ACTORES] of var int: borders = [U[a] - L[a] + 1 | a in ACTORES];
var int: border;
constraint border == max(borders);

% Se condiciona el rango de posiciones posibles para el rango de escenas de cada actor sin incluir al actor Big
constraint forall(a in ACTORES diff {big})(
 U[a] - L[a] + 1 >= sum(i in s)(Escenas[a,i]) /\ U[a] - L[a] + 1 <= border
);

%Restriccion que busca que para cada actor, su costo sea minimo lo que le corresponde por unidad de tiempo por su precio y maximo la suma de todas las duraciones de tiempo por su precio.
constraint forall(a in ACTORES)(
 varCostActor(a) >= getCostActor(a) 
 /\ 
 varCostActor(a) <= sum(i in 1..lim)(Duracion[e[i]]) * Escenas[a, len]
);

% ======== PREDICADOS Y RESTRICCIONES PARA MANEJAR DISPONIBILIDAD Y EVITAR ============

%Predicado para manejar la disponibilidad de un cierto actor con su respectiva duracion limite
predicate Dist(ACTORES: a, int: t) = if t != 0 then sum(i in L[a]..U[a])(Duracion[e[i]]) <= t else true endif;

%Predicado que busca evitar solapamiento de cierto par de actores durante el rodaje
predicate Evi(ACTORES: a, ACTORES: b) = L[a] <= U[b] \/ L[b] <= U[a];

%Restriccion generalizada para todos los actores
constraint forall(i in 1..dispLength)(
  Dist(ACTORES[Disponibilidad[i,1]], Disponibilidad[i,2])
);

%Restriccion generalizada para todos los actores
constraint forall(i in 1..eviLength)(
  Evi(Evitar[i,1], Evitar[i,2])
);

% ===========================================================================================

% Restriccion para eliminar simetrias lexicograficas
constraint lex_lesseq(e, reverse(e));

% ====== Funcion Objetivo =======

% Variable de costo
var int: c;

constraint c > 0;

constraint c == sum(a in ACTORES)(
  sum(i in L[a]..U[a])(Duracion[e[i]]) * Escenas[a, len]
);

solve minimize c;

% Propuesta de una estrategia de busqueda para el problema
% solve :: seq_search([int_search(e, dom_w_deg, indomain_split)]) minimize c;

% ====== Salida =======
output["\(e)\nCosto: \(c)\nTiempo Compartido:"++show(sum(i in 1..eviLength)(
  sum(j in max(L[Evitar[i,1]], L[Evitar[i,2]])..min(U[Evitar[i,1]], U[Evitar[i,2]]))(Duracion[e[j]])
))];