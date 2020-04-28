% Funcion que calcula al actor menos costoso del rodaje
function var s: getSmaller() = 
let {
      var ACTORES: small;
      
      array[ACTORES] of int: array_aux = [
        sum(i in s where Escenas[a, i] == 1)(Duracion[i]) * Escenas[a, len] | a in ACTORES
      ];
      
      int: mn = min(array_aux); 
      constraint exists(a in ACTORES where array_aux[a] - mn == 0)(small == a);
    } in small;
