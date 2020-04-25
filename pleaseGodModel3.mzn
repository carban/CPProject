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

% Se condiciona el rango de posiciones posibles para el rango de escenas de cada actor sin incluir al actor Big

array[ACTORES] of var int: borders = [U[a] - L[a] + 1 | a in ACTORES];
var int: border;
constraint border == max(borders);

constraint forall(a in ACTORES diff {big})(
 U[a] - L[a] + 1 >= sum(i in s)(Escenas[a,i]) /\ U[a] - L[a] + 1 <= border
);

function var int: varCostActor(ACTORES: a) = let{
  var int: cc; 
  constraint cc == sum(i in L[a]..U[a])(Duracion[e[i]]) * Escenas[a, len];
}in cc;

function int: getCostActor(ACTORES: a) = let{
  int: cc == sum(i in s where Escenas[a, i] == 1)(Duracion[i]) * Escenas[a, len];
}in cc;


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

solve minimize c;

% ====== Salida =======
% output["\(e)\nCosto: \(c)"];

output["\(e)\nCosto: \(c)\nBorder: \(border) "];
  