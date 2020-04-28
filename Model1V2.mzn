% ====== Proyecto de Curso Implementacion Parte I VERSION 2======

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

% Restriccion para eliminar simetrias lexicograficas
constraint lex_lesseq(e, reverse(e));

% ====== Funcion Objetivo =======

% Variable de costo
var int: c;

constraint c > 0;

constraint c == sum(a in ACTORES)(
  sum(i in L[a]..U[a])(Duracion[e[i]]) * Escenas[a, len]
);

% solve minimize c;

% Propuesta de una estrategia de busqueda para el problema
solve :: seq_search([int_search(e, dom_w_deg, indomain_split)]) minimize c;


% ====== Salida =======
output["\(e)\nCosto: \(c)"];