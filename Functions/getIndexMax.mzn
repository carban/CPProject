% Funcion que calcula el indice donde cierto actor termina de grabar sus escenas | UpperBound
function var s: getIndexMax(ACTORES: a) = 
let {
      int: sm = sum(i in s)(Escenas[a, i]);
      var sm..lim: m;
      constraint m == max([i | i in sm..lim where Escenas[a, e[i]] == 1]);
    } in m;
