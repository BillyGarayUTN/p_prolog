%puedeCumplir(Persona, Rol): relaciona una persona con un rol que puede cumplir
puedeCumplir(jorge, instrumentista(guitarra)).
puedeCumplir(daniel, instrumentista(guitarra)).
puedeCumplir(daniel, actor(narrador)).
puedeCumplir(daniel, instrumentista(tuba)).
puedeCumplir(daniel, actor(paciente)).
puedeCumplir(marcos, actor(narrador)).
puedeCumplir(marcos, actor(psicologo)). 
puedeCumplir(marcos, instrumentista(percusion)).
puedeCumplir(daniel, instrumentista(percusion)).
puedeCumplir(carlos, instrumentista(violin)).
puedeCumplir(carlitos, instrumentista(piano)). 
puedeCumplir(daniel, actor(canto)). 
puedeCumplir(carlos, actor(canto)). 
puedeCumplir(carlitos, actor(canto)). 
puedeCumplir(marcos, actor(canto)). 
puedeCumplir(jorge, actor(canto)). 
puedeCumplir(jorge, instrumentista(bolarmonio)).

%necesita(Sketch, Rol): relaciona un sketch con un rol necesario para interpretarlo.
necesita(payadaDeLaVaca, instrumentista(guitarra)). 
necesita(malPuntuado, actor(narrador)). 
necesita(laBellaYGraciosaMozaMarchoseALavarLaRopa, actor(canto)). 
necesita(laBellaYGraciosaMozaMarchoseALavarLaRopa, instrumentista(violin)). 
necesita(laBellaYGraciosaMozaMarchoseALavarLaRopa, instrumentista(tuba)). 
necesita(lutherapia, actor(paciente)). necesita(lutherapia, actor(psicologo)). 
necesita(cantataDelAdelantadoDonRodrigoDiazDeCarreras, actor(narrador)).
necesita(cantataDelAdelantadoDonRodrigoDiazDeCarreras, instrumentista(percusion)). 
necesita(cantataDelAdelantadoDonRodrigoDiazDeCarreras, actor(canto)). 
necesita(rhapsodyInBalls, instrumentista(bolarmonio)). 
necesita(rhapsodyInBalls, instrumentista(piano)).

% duracion(Sketch, Duracion):. relaciona un sketch con la duración 
%  (aproximada, pero la vamos a tomar como fija) que se necesita para interpretarlo.
duracion(payadaDeLaVaca, 9). 
duracion(malPuntuado, 6). 
duracion(laBellaYGraciosaMozaMarchoseALavarLaRopa, 8). 
duracion(lutherapia, 15). 
duracion(cantataDelAdelantadoDonRodrigoDiazDeCarreras, 17). 
duracion(rhapsodyInBalls, 7).

% 1. Necesitamos programar interprete/2, que relacione a una persona con un sketch 
%  en el que puede participar. Inversible.

interprete(Persona,Sketch):-
    puedeCumplir(Persona, Rol),
    necesita(Sketch, Rol).

% 2. Se precisa la relación duracionTotal/2, que relacione una lista de sketches con
%  la duración total que tomaría realizarlos a todos. Inversible para la duración.

duracionTotal(Sketches,DuracionTotal):-
    findall(Duracion, (member(Sketch, Sketches), duracion(Sketch, Duracion)), Duraciones),
    sumlist(Duraciones,DuracionTotal).

/*   Aqui EMPIEZA para hacerlo Inversible para Sketches usando explosion combinatoria 
duracionTotal(Sketches, DuracionTotal) :-
    findall(Sketch, duracion(Sketch, _), TodosLosSketches),
    subconjunto(TodosLosSketches, Sketches),
    findall(Duracion, (member(Sketch, Sketches), duracion(Sketch, Duracion)), Duraciones),
    sumlist(Duraciones, DuracionTotal).

% Predicado auxiliar para generar subconjuntos
subconjunto([], []).
subconjunto([PrimerElemento|RestoLista], [PrimerElemento|SubconjuntoDelResto]) :-
    subconjunto(RestoLista, SubconjuntoDelResto).
subconjunto([_|RestoLista], SubconjuntoFinal) :-  % _ "ElementoIgnorado"
    subconjunto(RestoLista, SubconjuntoFinal).

  Aqui TERMINA para hacerlo Inversible para Sketches usando explosion combinatoria */

% 3. Saber si un sketch puede ser interpretado por un conjunto de intérpretes. 
%  Esto sucede cuando en ese conjunto disponemos de intérpretes que cubren todos 
%  los roles necesarios para el mencionado sketch. Inversible para el sketch.

% puedeInterpretarse(Sketch, Personas):
% Un sketch puede interpretarse si cada rol que necesita
% está cubierto por al menos una persona del conjunto.

puedeInterpretarse(Sketch, Personas) :-
    necesita(Sketch, _),  % asegura que el sketch existe
    forall( necesita(Sketch, Rol), (member(Persona, Personas), puedeCumplir(Persona, Rol))).
%"Para CADA rol que necesita el sketch, tiene que haber AL MENOS UNA persona en el grupo que pueda cumplir ese rol"

% 4. generarShow(Interpretes,DuracionMaxShow,Sketches)
generarShow(Personas, DuracionMaxShow, Sketches) :-
    findall(Sketch, puedeInterpretarse(Sketch, Personas), SketchesPosibles),
    subconjunto(SketchesPosibles, Sketches),
    Sketches \= [],  % asegura que el show no esté vacío
    duracionTotal(Sketches, DuracionTotal),
    DuracionTotal =< DuracionMaxShow.

% Predicado auxiliar para generar subconjuntos (descomenta si no lo tienes)
subconjunto([], []).
subconjunto([PrimerElemento|RestoLista], [PrimerElemento|SubconjuntoDelResto]) :-
    subconjunto(RestoLista, SubconjuntoDelResto).
subconjunto([_|RestoLista], SubconjuntoFinal) :-  % _ "ElementoIgnorado"
    subconjunto(RestoLista, SubconjuntoFinal).

% 5. Los shows, muchas veces tienen algún participante estrella; que es aquel que
% puede participar en todos los sketchs que componen dicho show. Implementar un 
% predicado que relacione a un show con un participante estrella. Inversible para la estrella.

estrellaShow(Persona, Sketches) :-
    puedeCumplir(Persona, _),  % asegura que la persona existe
    forall(member(Sketch, Sketches), interprete(Persona, Sketch)).

% 6. Para hacer mejor el marketing, queremos saber si un show:
% 6.a. Es puramenteMusical/1. Esto sucede cuando en todos los sketches, sólo se precisan roles 
% de instrumentista.
puramenteMusical(Sketches) :-
    forall((member(Sketch, Sketches), necesita(Sketch, Rol)), esInstrumentista(Rol)).

esInstrumentista(instrumentista(_)).

% 6.b Tiene todosCortitos/1. Esto sucede cuando todos los sketches del show duran menos de 10 minutos.
todosCortitos(Sketches):-
    forall(member(Sketch, Sketches), (duracion(Sketch, Duracion), Duracion < 10)).

% 6.c Los juntaATodos/1. Este evento especial solo pasa si la única manera de que el show suceda es
%  que tengan que participar todos los intérpretes que conocemos.
juntaATodos(Sketches) :-
    findall(Persona, puedeCumplir(Persona, _), TodosLosInterpretes),
    forall(member(Sketch, Sketches), puedeInterpretarse(Sketch, TodosLosInterpretes)).