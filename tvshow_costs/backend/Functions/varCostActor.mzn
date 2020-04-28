% Funcion que calcula el costo actual para un actor "a" desde su LowerBound hasta su UpperBound
% de tiempo
function var int: varCostActor(ACTORES: a) = let{
  var int: cc == sum(i in L[a]..U[a])(Duracion[e[i]]) * Escenas[a, len];
}in cc;
