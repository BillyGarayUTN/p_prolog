% tema 1

/*
Del Módulo 1 – Predicados. Individuos. Consultas. Universo Cerrado los puntos que se ven son:

1. Paradigma lógico y proposiciones

2. Predicados

Concepto y sintaxis

Aridad

Predicados de verdad y predicados relacionales

3. Individuos

Simples

Compuestos (con functor y argumentos)

4. Consultas en Prolog

Consultas existenciales (sí/no)

Consultas con variables

Múltiples respuestas

Uso del punto y coma (;) para backtracking

5. Universo cerrado

Significado en Prolog

Consecuencias de no definir hechos

6. Ejemplos y ejercicios iniciales




Punto 1
Paradigma lógico y proposiciones
Explica con tus palabras qué significa que en Prolog usamos el principio de universo cerrado.
Luego, indica qué sucede si consultas un hecho que no está definido en la base de conocimientos.

% el principio de universo cerrado quiere decir que lo que no esta es falso.
% si consulto por un hecho y no esta definido es falso.

Punto 2
Predicados y aridad
Dado el predicado hermano/2, explica qué representa la aridad y cómo se diferencia de hermano/3.
Indica si hermano(juan) es válido o no, y por qué.

% la aridad representa los arguntemtos necesarios para el predicado
% el hermando/3 tiene otra aridad , por ende es otro predicado.

Putno 3
Predicados de verdad vs. relacionales
Clasifica los siguientes predicados como predicados de verdad o predicados relacionales:

esPar(4)
✔ Predicado de verdad
Significa que “4 es par”.

madre(maria, juan)
✔ Predicado relacional
Significa que “María es madre de Juan”.

mayorQue(5, 3)
✔ Predicado relacional
Significa que “5 es mayor que 3”.

capitalDe(argentina, buenosAires)
✔ Predicado relacional
Significa que “Buenos Aires es capital de Argentina”.

Punto 4
Individuos

Da 2 ejemplos de individuos simples y 2 de individuos compuestos usando functor y argumentos.

Explica la diferencia.

Ejemplos de individuos simples:
1. persona(maria).
2. animal(perro).

Ejemplos de individuos compuestos:
1. coche(marca, modelo).
2. libro(titulo, autor).

Individuo simple: Representa un único elemento indivisible en la base de conocimientos. 
Está compuesto únicamente por un átomo (o constante) y no tiene argumentos.

Individuo compuesto: Representa una entidad compleja que incluye un functor y uno o más argumentos. 
Los argumentos pueden ser otros individuos simples o compuestos.

La diferencia radica en que los individuos simples son aquellos que se definen 
por un solo término (un functor sin argumentos), mientras que los individuos compuestos 
se definen por un functor que toma uno o más argumentos, permitiendo una descripción
más rica y detallada de la entidad representada.

Punto 5
Consultas existenciales y variables

¿Qué diferencia hay entre humano(socrates). y humano(X). en cuanto a tipo de respuesta y backtracking?
% humano(socrates) es una consulta específica que busca un hecho concreto en la base de conocimientos. 
Si existe, devuelve verdadero; si no, falso.
% humano(X) es una consulta más general que busca cualquier individuo que cumpla con la condición de ser humano.
Puede devolver múltiples resultados y utiliza backtracking para encontrar todos los posibles valores de X.

¿Para qué sirve el punto y coma ; en Prolog?

El punto y coma ; en Prolog se utiliza para representar una disyunción lógica, 
es decir, un "o" entre dos o más condiciones. Permite expresar que al menos una de las condiciones
debe ser verdadera para que la consulta se considere satisfactoria. 
Por ejemplo, en una consulta como padre(X, Y); madre(X, Y), se está preguntando si X es padre o madre de Y.

*/

% Hechos
humano(socrates).
humano(platon).
humano(aristoteles).
filosofo(socrates).
filosofo(platon).

viveEn(socrates, atenas).
viveEn(platon, atenas).
viveEn(aristoteles, estagira).

% Ejemplo de functor
nacioEn(socrates, fecha(470, antesCristo)).
nacioEn(platon, fecha(427, antesCristo)).


/*
1. Consultas simples y existenciales
✔ Consulta si socrates es humano (sí/no).
✔ Consulta todos los humanos.
✔ Consulta todos los filósofos que vivan en Atenas.
*/

humano(socrates).
humano(Quienes).
filosofo_vive_En_Atenas(Quienes):-filosofo(Quienes),viveEn(Quienes, atenas).

/*
2. Uso de variables y backtracking
✔ Consulta: ¿quiénes viven en Atenas?
✔ Usando ; muestra todas las respuestas.
*/

viveEn(Quienes, atenas).

/*
3. Define el predicado:

mismoLugar(Persona1, Persona2) :-
    viveEn(Persona1, Lugar),
    viveEn(Persona2, Lugar),
    Persona1 \= Persona2.

Consulta quiénes comparten lugar de residencia.

%  respuesa ? - mismoLugar(socrates,platon).
*/

/*
4. Ejercicio de universo cerrado
Pregunta humano(pitagoras). y explica por qué devuelve false aunque Pitágoras fue humano.

Agrega el hecho a la base de conocimiento y verifica que ahora sea true.


% respuesta : devuelve false porque humano(pitagoras) no está definido en la base de conocimiento.
% se debe agregar a la base de conocimiento.

humano(pitagoras).

*/

/*
5.  Individuos compuestos
Consulta el año de nacimiento de Platón usando nacioEn/2.

Escribe un predicado nacidoAntesDe(Persona, Anio) que sea verdadero si la persona nació antes del año dado.

Ejemplo:

?- nacidoAntesDe(socrates, 400).
true.

*/

nacioEn(platon, fecha(Fecha, antesCristo)).

nacidoAntesDe(Persona, Anio) :-
    nacioEn(Persona, fecha(FechaNacimiento, antesCristo)),
    FechaNacimiento < Anio.
    