% Funcion que calcula el costo mas pequeno para un actor "a", donde solo se tiene en cuenta las escenas que aparece
function int: getCostActor(ACTORES: a) = let{
  int: cc == sum(i in s where Escenas[a, i] == 1)(Duracion[i]) * Escenas[a, len];
}in cc;
