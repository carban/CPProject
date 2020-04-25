% ====== Proyecto de Curso Implementacion Parte I ======

% Planificación de los ensayos en una telenovela *
% Programación por Restricciones
% Escuela de Ingenierı́a de Sistemas y Computación
% Facultad de Ingenierı́a

% ====== Integrantes =======
%  Alexander Gonzalez      14
%  Carlos Esteban Murillo  15

% ====== Funciones =======

include "globals.mzn";
include "getIndexMax.mzn";
include "getIndexMin.mzn";
include "getBigger.mzn";
include "getActorWorker.mzn";

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

% Worker
% Se calcula el actor con mas participacion y se establece un rango determinado para sus escenas
var ACTORES: worker == getActorWorker();
constraint U[worker] - L[worker] + 1 < lim;

% Border
% Permite establecer la longitud entre el inicio y el final de las escenas para el actor Worker
var int: border;
constraint border == U[worker] - L[worker] + 1;

% Se condiciona el rango de posiciones posibles para el rango de escenas de cada actor sin incluir al actor Big
constraint forall(a in ACTORES diff {big})(
 U[a] - L[a] + 1 >= sum(i in s)(Escenas[a,i]) /\ U[a] - L[a] + 1 <= border
);

% Restriccion para eliminar simetrias lexicograficas
constraint lex_lesseq(e, reverse(e));


% =========================================================================================

predicate Dist(ACTORES: a, int: t) = if t != 0 then sum(i in L[a]..U[a])(Duracion[e[i]]) <= t else true endif;

predicate Evi(ACTORES: a, ACTORES: b) = L[a] <= L[b] \/ L[b] <= L[a];

constraint forall(i in 1..dispLength)(
  Dist(ACTORES[Disponibilidad[i,1]], Disponibilidad[i,2])
);

constraint forall(i in 1..eviLength)(
  Evi(Evitar[i,1], Evitar[i,2])
);

% ===========================================================================================




% ====== Funcion Objetivo =======

% Variable de costo
var int: c;

constraint c > 0;

constraint c == sum(a in ACTORES)(
  sum(i in L[a]..U[a])(Duracion[e[i]]) * Escenas[a, len]
);

solve minimize c;

% ====== Salida =======

output["\(e)\nCosto: \(c)\n"];  