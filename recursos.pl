/*
○ “Existe” vs “Para todos”: cuando el enunciado dice “sólo cometió… / todos fueron…”, 
se resuelve con forall/2, no con “hay algún” hecho que cumple .

○ not/1: usalo con variables ya ligadas por un generador (si no, no es inversible y 
la consulta falla existencialmente) .

○ findall/3: ligá el dominio afuera del findall para que sea inversible en el argumento 
que corresponde (ver patrón “cantidad de hijos”) .

*/