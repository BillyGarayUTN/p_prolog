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
    Dificultad == 1.
