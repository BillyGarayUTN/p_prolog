%persona(Apodo, Edad, Peculiaridades).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).
persona(rolo, 12, []).

edadPersona(Edad):-persona(_, Edad, _).
%Hay varias empresas metidas en este rubro y cada una tiene distintas salas:

%esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).

%Las salas no son todas iguales. Contamos con las siguientes experiencias:
%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).

%sala(Nombre, Experiencia).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(linternas, familiar(comics, 5)).
sala(guerrasEstelares, familiar(futurista, 7)).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).


% Punto 1
%nivelDeDificultadDeLaSala(Sala,Dificultad)
nivelDeDificultadDeLaSala(Sala,Dificultad):-
    sala(Sala, Experiencia),
    dificultadPorExperiencia(Experiencia,Dificultad).

dificultadPorExperiencia(terrorifica(CantidadDeSustos, EdadMinima),Dificultad):-
    Dificultad is CantidadDeSustos-EdadMinima.
dificultadPorExperiencia(familiar(futurista,_),15).
dificultadPorExperiencia(familiar(Tematica,Habitaciones),Habitaciones):-Tematica \= futurista.
dificultadPorExperiencia(enigmatica(Candados),CantidadDeCandados):-length(Candados,CantidadDeCandados).

% Punto 2
%puedeSalir(Persona,Sala)
puedeSalir(Persona,Sala):-
    persona(Persona, _, Peculiaridades),
    nivelDeDificultadDeLaSala(Sala,Dificultad),
    Dificultad==1,
    not( member(claustrofobia, Peculiaridades) ).


puedeSalir(Persona,Sala):- 
    persona(Persona, Edad, Peculiaridades),  
    Edad>13,
    nivelDeDificultadDeLaSala(Sala,Dificultad),
    Dificultad<5,
    noEsClaustrofobico( Persona).


noEsClaustrofobico( Persona) :- persona(Persona, Edad, Peculiaridades), not( member(claustrofobia, Peculiaridades) ).

%punto 3
%tieneSuerte/2:
tieneSuerte( Persona, Sala)