function var ACTORES: getBigger() = 
let {
      var ACTORES: big;
      
      array[ACTORES] of int: array_aux = [
        sum(i in s where Escenas[a, i] == 1)(Duracion[i]) * Escenas[a, len] | a in ACTORES
      ];
      
      int: mx = max(array_aux); 
      constraint exists(a in ACTORES where array_aux[a] - mx == 0)(big == a);
    } in big;