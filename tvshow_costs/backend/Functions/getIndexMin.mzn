% Funcion que calcula el indice donde cierto actor inicia de grabar sus escenas | LowerBound
function var s: getIndexMin(ACTORES: a) = 
let {
      int: sm = sum(i in s)(Escenas[a, i]);
      var 1..(len-sm): m;
      constraint m == min([i | i in 1..(len-sm) where Escenas[a, e[i]] == 1]);
    } in m;
