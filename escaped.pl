%persona(Apodo, Edad, Peculiaridades).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).
persona(rolo, 12, []).

%esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).

%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).
%sala(NombreSala, Experiencia).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(linternas, familiar(comics, 5)).
sala(guerrasEstelares, familiar(futurista, 7)).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).

sala(fundacion, enigmatica([deBoton])).


% 1. -------------------------------------
nivelDeDificultadDeLaSala(NombreSala,Dificultad):-
    sala(NombreSala,Experiencia),
    dificultadSegunExperiencia(Experiencia,Dificultad).

dificultadSegunExperiencia(terrorifica(CantidadDeSustos, EdadMinima),Dificultad):-
    Dificultad is CantidadDeSustos - EdadMinima.
dificultadSegunExperiencia(familiar(futurista, _),15).
dificultadSegunExperiencia(familiar(_, CantidadDeHabitaciones),Dificultad):- Dificultad = CantidadDeHabitaciones.
dificultadSegunExperiencia(enigmatica(Candados),Dificultad):-
    length(Candados, CantidadDeCandados),
    Dificultad = CantidadDeCandados.

% 2. -------------------------------------
puedeSalir( Persona,NombreSala ):-
    persona(Persona,_,Peculiaridad),
    not(member(claustrofobia, Peculiaridad)),
    nivelDeDificultadDeLaSala(NombreSala,Dificultad),
    Dificultad = 1.

puedeSalir( Persona,NombreSala ):-
    persona(Persona,Edad,Peculiaridad),
    not(member(claustrofobia, Peculiaridad)),
    Edad > 13,
    nivelDeDificultadDeLaSala(NombreSala,Dificultad),
    Dificultad < 5.

% 3. ---------------------------------------
tieneSuerte(Persona, NombreSala) :-
    persona(Persona, Edad, []),
    nivelDeDificultadDeLaSala(NombreSala, Dificultad),
    ( Dificultad = 1
    ; Edad > 13, Dificultad < 5
    ).

% 4. ---------------------------------------
esMacabra(Empresa):-
    esSalaDe(_, Empresa),
    forall( esSalaDe(NombreSala, Empresa), esExperienciaTerrorifica(NombreSala) ).

esExperienciaTerrorifica(NombreSala):-
    sala(NombreSala, terrorifica(_, _)).

% 5. ---------------------------------------
empresaCopada(Empresa):-
    esSalaDe(_,Empresa),
    not( esMacabra(Empresa) ),
    findall( Dificultad,(esSalaDe(NombreSala,Empresa), nivelDeDificultadDeLaSala(NombreSala,Dificultad)),ListaDeDificultades),
    length(ListaDeDificultades, CantidadDeSalas),
    sumlist(ListaDeDificultades,Suma),
    Promedio is Suma / CantidadDeSalas,
    Promedio < 4.

% 6. --------------------------------------
% supercelula
esSalaDe(estrellasDePelea, supercelula).
sala(estrellasDePelea, familiar(videojuegos, 7)).

esSalaDe(choqueDeLaRealeza, supercelula).
% (sin hecho sala/2 hasta conocer habitaciones)

% SKPista
esSalaDe(miseriaDeLaNoche, skpista).
sala(miseriaDeLaNoche, terrorifica(150, 21)).

% (opcional) empresa sin salas explícitas
empresa(vertigo).