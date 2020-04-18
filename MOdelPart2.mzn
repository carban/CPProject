include "globals.mzn";
include "getIndexMax.mzn";
include "getIndexMin.mzn";
include "getBigger.mzn";
% include "getSmall.mzn";
include "getActorNorm.mzn";
include "getNorm.mzn";

enum ACTORES;

array[ACTORES, int] of int: Escenas; 

array[int] of int: Duracion;

int: lim = length(Duracion);

int: len = lim + 1;

set of int: s =  1..lim;

array[s] of var s: e;

predicate Dist(ACTORES: a, int: t) = sum(i in L[a]..U[a])(Duracion[e[i]]) <= t;
predicate Evi(ACTORES: a, ACTORES: b) = U[a] <= L[b] \/ U[b] <= L[a];


constraint all_different(e);

% Upper indexs
array[ACTORES] of var s: U;
constraint forall(a in ACTORES)(U[a] == getIndexMax(a));


%Lower indexs
array[ACTORES] of var s: L;
constraint forall(a in ACTORES)(L[a] == getIndexMin(a));

%Bigger
var ACTORES: big;
constraint big == getBigger();
var int: sm_bg == sum(i in s)(Escenas[big, i]);
constraint U[big] - L[big] + 1 == sm_bg;

var ACTORES: norm == getActorNorm();

constraint U[norm] - L[norm] + 1 < lim;

var int: border;

constraint border == lim - (U[norm] - L[norm] + 1);

constraint forall(a in ACTORES diff {big})(
 U[a] - L[a] + 1 >= sum(i in s)(Escenas[a,i]) /\ U[a] - L[a] + 1 <= lim - border
);

constraint lex_lesseq(e, reverse(e));
% constraint lex_lesseq(reverse(e), e);

var int: c;

constraint c > 0;

constraint c == sum(a in ACTORES)(
  sum(i in L[a]..U[a])(Duracion[e[i]]) * Escenas[a, len]
);

solve minimize c;

output["\(e)\n\(c)\n\(border)"];
% output["\(e)\n\(c)\n\(U)\n\(L)"];




  