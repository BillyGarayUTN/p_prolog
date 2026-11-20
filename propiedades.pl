
%casa(MetrosCuadrados).
%depto(Ambientes,Baños).
%loft(AñosDeAntiguedad).

% Punto 1: Hablar con propiedad Se pide que agregue a la base de conocimientos 
% la siguiente información:

% vive(Persona,Vivienda).
vive(juan,casa(120)).
vive(nico,depto(3,2)).
vive(alf,depto(3,1)).
vive(julian,loft(2000)).
vive(vale,depto(4,1)).
vive(fer,casa(110)).

% quiereMudarse(Persona, Vivienda).
quiereMudarse(rocio, casa(90)).

% barrio(Persona, Barrio).
barrio(juan, almagro).
barrio(nico, almagro).
barrio(alf, almagro).
barrio(julian, almagro).
barrio(vale, flores).
barrio(fer, flores).

% Punto 2: Barrio copado, infierno chico Queremos saber si en un barrio todas
%  las personas viven en propiedades copadas.

barrioCopado(Barrio):-
    barrio(_, Barrio),
    forall(barrio(Persona, Barrio), ( vive(Persona, Vivienda), viviendaCopada(Vivienda))).

viviendaCopada(casa(MetrosCuadrados)):- MetrosCuadrados > 100. 
viviendaCopada(depto(Ambientes, _)):- Ambientes > 3.
viviendaCopada(depto(_, Banio)):- Banio > 1.
viviendaCopada(loft(Antiguedad)):- Antiguedad > 2015.

% Punto 3: Barrio (caro) tal vez Ahora necesitamos conocer si hay un barrio caro, 
%          en el que no hay una casa que sea barata.
%  los loft construidos antes del 2005 son baratos
%  las casas de menos de 90 metros son baratas
%  los departamentos que tienen 1 ó 2 ambientes son baratos


barrioCaro(Barrio):-
    barrio(_,Barrio),
    forall(barrio(Persona, Barrio), ( vive(Persona, Vivienda), viviendaCara(Vivienda))).

viviendaCara(loft(Antiguedad)):- Antiguedad > 2005.
viviendaCara(casa(MetrosCuadrados)):- MetrosCuadrados> 90.
viviendaCara(depto(Ambientes,_)):- Ambientes > 2. 

% Punto 4: Tasa, tasa, tasación de la casa

% tasacion(Persona, Precio).
tasacion(juan, 150000).
tasacion(nico, 80000).
tasacion(alf, 75000).
tasacion(julian, 140000).
tasacion(vale, 95000).
tasacion(fer, 60000).

% sublista/2 - genera sublistas
sublista([], []).
sublista([_ | Cola], Sublista):- sublista(Cola, Sublista).
sublista([Cabeza | Cola], [Cabeza | Sublista]):- sublista(Cola, Sublista).

% puedeComprar(Plata, PropiedadesAComprar, PlataRestante)
puedeComprar(Plata, Propiedades, PlataRestante):-
    findall(Persona, tasacion(Persona, _), TodasLasPersonas),
    sublista(TodasLasPersonas, Propiedades),
    Propiedades \= [],
    costoTotal(Propiedades, CostoTotal),
    CostoTotal =< Plata,
    PlataRestante is Plata - CostoTotal.

costoTotal(Propiedades, Costo):-
    findall(Precio, 
            (member(Persona, Propiedades), tasacion(Persona, Precio)), 
            Precios),
    sumlist(Precios, Costo). 