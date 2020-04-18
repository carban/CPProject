function var ACTORES: getActorWorker() = 
let {
      var ACTORES: n; 
      array[ACTORES] of int: array_aux = [
        sum(i in s)(Escenas[a, i]) | a in ACTORES
      ];
      int: m = max(array_aux);
      constraint exists(a in ACTORES where array_aux[a] - m == 0)(n == a);
    } in n;
