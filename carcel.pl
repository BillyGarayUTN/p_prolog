% Parcial de la carcel

% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).
% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).


% 1. Dado el predicado controla/2:
% controla(Controlador, Controlado)
% controla(piper, alex). 
% controla(bennett, dayanara).
% controla(Guardia, Otro):- prisionero(Otro,_), not(controla(Otro, Guardia)).

/*
Indicar, justificando, si es inversible y, en caso de no serlo, dar ejemplos
de las consultas que NO podrían hacerse y corregir la implementación para que se pueda.
*/
controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- 
    guardia(Guardia), prisionero(Otro,_), not(controla(Otro, Guardia)).

% 2. conflictoDeIntereses/2: relaciona a dos personas distintas (ya sean guardias o prisioneros)
% si no se controlan mutuamente y existe algún tercero al cual ambos controlan.

conflictoDeIntereses(Alguien,Otro):-
    controla(Alguien,Tercero),
    controla(Otro,Tercero),
    not(controla(Alguien,Otro)),
    not(controla(Otro,Alguien)),
    Alguien \= Otro.

% 3. peligroso/1: Se cumple para un preso que sólo cometió crímenes graves.
% ○ Un robo nunca es grave.
% ○ Un homicidio siempre es grave.
% ○ Un delito de narcotráfico es grave cuando incluye al menos 5 drogas a la vez,o incluye metanfetaminas.

peligroso(Preso):-
    prisionero(Preso,_),
    forall( prisionero(Preso,Crimen), esGrave(Crimen) ).

esGrave(homicidio(_)).
esGrave(narcotrafico(Drogas)):-
    length(Drogas, Cantidad), Cantidad >= 5.
esGrave(narcotrafico(Drogas)):-
    member(metanfetaminas, Drogas).

% 4. ladronDeGuanteBlanco/1: Aplica a un prisionero si sólo cometió robos y todos fueron por más de $100.000.
ladronDeGuanteBlanco(Preso):-
    prisionero(Preso,_),
    forall(prisionero(Preso,Crimen),altoRobo(Crimen)).

altoRobo(robo(Cantidad)):-Cantidad>100000.

% 5. condena/2: Relaciona a un prisionero con la cantidad de años de condena que debe cumplir. 
%     Esto se calcula como la suma de los años que le aporte cada crimen cometido, que se obtienen 
%     de la siguiente forma:
% ○ La cantidad de dinero robado dividido 10.000.
% ○ 7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
% ○ 2 años por cada droga que haya traficado.

condena(Preso,AniosCondena):-
    prisionero(Preso, _),
    findall( Anio,( prisionero(Preso, Crimen) , anioPorCrimen(Crimen,Anio)),Anios),
    sum_list(Anios,AniosCondena).

anioPorCrimen(robo(Monto), Anio):- Anio is Monto // 10000.
anioPorCrimen(narcotrafico([Drogas]),Anio):- length([Drogas], Cantidad),Anio is Cantidad * 2.
anioPorCrimen(homicidio(Persona),7):-not(guardia(Persona)).
anioPorCrimen(homicidio(Persona),9):-guardia(Persona).

% 6. capoDiTutiLiCapi/1: Se dice que un preso es el capo de todos los capos cuando nadie lo controla,
% pero todas las personas de la cárcel (guardias o prisioneros) son controlados por él, o por alguien
%  a quien él controla (directa o indirectamente).
capo(Capo):-
    controla(Capo,_),
    not(controla(_,Capo)),
    forall(persona(Persona),controlaDoI(Capo,Persona)).

persona(Persona):-prisionero(Persona,_).
persona(Persona):-guardia(Persona).

%Recursivo
controlaDoI(Capo,Persona):-controla(Capo,Persona).
controlaDoI(Capo,Persona):-controla(Capo,Tercero),controlaDoI(Tercero,Persona).
