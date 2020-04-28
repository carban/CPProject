% ====== Proyecto de Curso Implementacion Parte I VERSION 1======

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
include "./Functions/getSmall.mzn";

% ====== Parametros =======

enum ACTORES;

array[ACTORES, int] of int: Escenas; 

array[int] of int: Duracion;

% ====== Constantes y variables Iniciales =======

int: lim = length(Duracion);

int: len = lim + 1;

set of int: s =  1..lim;

array[s] of var s: e; % Arreglo Solucion

constraint all_different(e);

% ====== Restricciones =======

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

%Smaller
% Se Calcula el actor menos costoso para la produccion y se determina un rango especifico para sus escenas
var ACTORES: small;
constraint small == getSmaller();
var int: sm_sm = sum(i in s)(Escenas[small, i]);
constraint U[small] - L[small] + 1 >= sm_sm;

% ====== Funcion Objetivo =======

% Variable de costo
var int: c;

constraint c > 0;

constraint c == sum(a in ACTORES)(
  sum(i in L[a]..U[a])(Duracion[e[i]]) * Escenas[a, len]
);

solve minimize c;

% ====== Salida =======
output["\(e)\nCosto: \(c)"];  