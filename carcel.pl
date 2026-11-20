% base de conocimientos :
% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).
% prisionero(Nombre, Crimen)
prisionero(piper, narcotráfico([metanfetaminas])).
prisionero(alex, narcotráfico([heroína])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotráfico([heroína, opio])).
prisionero(dayanara, narcotráfico([metanfetaminas])).

persona(P):-guardia(P).
persona(P):-prisionero(P,_).


% Punto 1: controla/2

% controla(Controlador, Controlado).
controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- 
    guardia(Guardia),
    prisionero(Otro,_),
    not(controla(Otro, Guardia)).
% es inversivle en Controlado pero no en Controlador

% Punto 2: conflictoDeIntereses/2  relaciona a dos personas distintas(ya sean guardias o prisioneros) 
% si no se controlan mutuamente y existe algún tercero al cual ambos controlan.
conflictoDeIntereses(Persona,Otra):-
    controla(Persona,Controlado),
    controla(Otra,Controlado),
    Persona \= Otra,
    not( controla(Persona,Otra) ),
    not( controla(Otra,Persona) ).

% Punto 3: peligroso/1: Se cumple para un preso que sólo cometió crímenes graves.
% ○ Un robo nunca es grave.
% ○ Un homicidio siempre es grave.
% ○ Un delito de narcotráfico es grave cuando incluye al menos 5 drogas a la vez, o incluye metanfetaminas.

peligroso(Preso):-
    prisionero(Preso,_),
    forall(prisionero(Preso,Crimen),esGrave(Crimen)).

esGrave(homicidio(_)).
esGrave(narcotrafico(Drogas)):-
    length(Drogas,Cantidad),
    Cantidad >=5.

esGrave(narcotrafico(Drogas)):-
    member(metanfetamina,Drogas).

% Punto 4:ladronDeGuanteBlanco/1: Aplica a un prisionero si sólo cometió robos y todos fueron por más de $100.000.
ladronDeGuanteBlanco(Preso):-
    prisionero(Preso,_),
    forall(prisionero(Preso,Crimen),esAltoRobo(Crimen) ).

esAltoRobo(robo(Monto)):-Monto>100000.

% Punto 5: condena/2: Relaciona a un prisionero con la cantidad de años de condena que debe cumplir. 
% Esto se calcula como la suma de los años que le aporte cada crimen cometido, que se obtienen de la siguiente forma:
% ○ La cantidad de dinero robado dividido 10.000.
% ○ 7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
% ○ 2 años por cada droga que haya traficado.

condena(Preso,Pena):-
    prisionero(Preso,_),
    findall( Condena , (prisionero(Preso,Crimen),anios(Crimen,Condena) ), Condenas ),
    sumlist(Condenas, Pena).


anios(robo(Monto),Anio):- Anio is Monto // 10000.
anios(homicidio(Persona),7):-not(guardia(Persona)).
anios(homicidio(Persona),9):- guardia(Persona).
anios(narcotrafico(Drogas),Anio):- length(Drogas, Cantidad), Anio is 2*Cantidad.

% Punto 6: capoDiTutiLiCapi/1: Se dice que un preso es el capo de todos los capos cuando nadie lo controla,
%  pero todas las personas de la cárcel (guardias o prisioneros) son controlados por él, o por alguien a
%  quien él controla (directa o indirectamente).

capoDiTutiLiCapi(Capo):- 
    prisionero(Capo,_),
    not( controla(_,Capo) ),
    forall( persona(Persona),controlaDoI(Capo,Persona)).


controlaDoI(Uno,Otro):-controla(Uno,Otro).
controlaDoI(Uno,Otro):-controla(Uno,Tercero),
    controlaDoI(Tercero,Otro).