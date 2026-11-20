% Una cañería es una lista de piezas
% [   ]
%
% Canio rojo de 3m ? => canio(rojo, 3)
% Codo rojo => codo(rojo)
% Canilla triangular roja de 4 cm de ancho => canilla(triangular, rojo, 4)
% [codo(rojo), codo(rojo), codo(rojo)]
% Definir un predicado que relacione una cañería con su precio. Una cañería es una lista de piezas.
% 1-
%precio(Canieria, Precio):- 
precio([], 0).
precio([Pieza|Piezas], Precio):-
    precio(Pieza, PrecioPieza),
    precio(Piezas, PrecioResto),
    Precio is PrecioPieza + PrecioResto.

precio(canio(_, Metros), Precio):- 
    Precio is 3 * Metros.

precio(codo(_), 5).

precio(canilla(triangular,_,_), 20).
precio(canilla(Tipo,_,Ancho), 12):- Tipo \= triangular, Ancho =< 5.
precio(canilla(Tipo,_,Ancho), 15):- Tipo \= triangular, Ancho > 5.

% 2 - 
coloresEnchufables(Color, Color).
coloresEnchufables(azul, rojo).
coloresEnchufables(rojo, negro).

color(canio(Color, _), Color).
color(codo(Color), Color).
color(canilla(_, Color, _), Color).
color(extremo(Color, _), Color).

puedoEnchufar(PiezaIzquierda, PiezaDerecha):-
    color(PiezaIzquierda, ColorIzquierdo),
    color(PiezaDerecha, ColorDerecho),
    PiezaIzquierda \= extremo(_, derecho),
    PiezaDerecha \= extremo(_, izquierdo),
    coloresEnchufables(ColorIzquierdo, ColorDerecho).

% 3 - 
puedoEnchufar(Canieria, PiezaOCanieria):-
    last(Canieria, PiezaIzquierda),
    puedoEnchufar(PiezaIzquierda, PiezaOCanieria).

puedoEnchufar(PiezaOCanieria, [PiezaDerecha | _]):-
    puedoEnchufar(PiezaOCanieria, PiezaDerecha).

/* No hace falta, se resuelve por los otros
puedoEnchufar(Canieria1, [PiezaDerecha|_]):-
    last(Canieria, PiezaIzquierda),
    puedoEnchufar(PiezaIzquierda, PiezaDerecha).
*/

% 4 - 
canieriaBienArmada([_]).
canieriaBienArmada([PiezaIzquierda,PiezaDerecha|Piezas]):-
    puedoEnchufar(PiezaIzquierda, PiezaDerecha),
    canieriaBienArmada([PiezaDerecha|Piezas]).

% 5 - 
% Agregamos arriba la relación de extremo y color

% 6 - 
% [codo(azul), [codo(rojo), codo(negro)], codo(negro)]
% debido a la extensión del punto 3 del puedoEnchufar/2, ya se banca estas estructuras

% 7 - 
% canieriasLegales(Piezas, CanieriaLegal):-
% Piezas -> [codo(azul), codo(negro), codo(rojo)]
% Canieria -> [codo(azul), codo(rojo), codo(negro)]
canieriasLegales([Pieza], [Pieza]).
canieriasLegales(Piezas, [Pieza | CanieriaLegal]):-
    select(Pieza, Piezas, RestoPiezas),
    canieriasLegales(RestoPiezas, CanieriaLegal),
    canieriaBienArmada([Pieza | CanieriaLegal]).

% Solución 2 ----
canieriasLegales2(Piezas, CanieriaLegal):-
    posibleCanieria(Piezas, CanieriaLegal),
    canieriaBienArmada(CanieriaLegal).

posibleCanieria([Pieza], [Pieza]).
posibleCanieria(Piezas, [Pieza | PosibleCanieria]):-
    select(Pieza, Piezas, RestoPiezas),
    posibleCanieria(RestoPiezas, PosibleCanieria).

% Solución 3 ----
canieriasLegales3(Piezas, CanieriaLegal):-
    permutation(Piezas, CanieriaLegal),
    canieriaBienArmada(CanieriaLegal).

% Solución 4 ----
canieriasLegales4([Pieza], [Pieza]).
canieriasLegales4(Piezas, [Pieza | CanieriaLegal]):-
    select(Pieza, Piezas, RestoPiezas),
    canieriasLegales4(RestoPiezas, CanieriaLegal),
    puedoEnchufar(Pieza, CanieriaLegal).