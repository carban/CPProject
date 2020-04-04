include "alldifferent.mzn";
include "getIndexMax.mzn";
include "getIndexMin.mzn";
include "getBigger.mzn";

enum ACTORES;

array[ACTORES, int] of int: Escenas; 

array[int] of int: Duracion;

int: lim = length(Duracion);

int: len = lim + 1;

set of int: s =  1..lim;

array[s] of var s: e;

constraint alldifferent(e);

% Upper indexs
array[ACTORES] of var s: U;
constraint forall(a in ACTORES)(U[a] == getIndexMax(a));


%Lower indexs
array[ACTORES] of var s: L;
constraint forall(a in ACTORES)(L[a] == getIndexMin(a));


%Bigger
var ACTORES: big;
constraint big == getBigger();
var int: sm_bg = sum(i in s)(Escenas[big, i]);
constraint U[big] - L[big] + 1 == sm_bg;


var int: c = sum(a in ACTORES)(
  sum(i in L[a]..U[a])(Duracion[e[i]]) * Escenas[a, len]
);

solve minimize c;

output["\(e)\n\(c)"];
% output["\(e)\n\(c)\n\(U)\n\(L)"];





