% puedeCumplir(Persona, Rol): relaciona una persona con un rol que puede cumplir
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

% necesita(Sketch, Rol): relaciona un sketch con un rol necesario para interpretarlo.
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

% punto 1: Necesitamos programar interprete/2, que relacione a una persona 
%          con un sketch en el que puede participar. Inversible.

interprete(Persona,Sketch):-
    puedeCumplir(Persona,Rol),
    necesita(Sketch,Rol).

% punto 2: Se precisa la relación duracionTotal/2, que relacione una lista de sketches
%          con la duración total que tomaría realizarlos a todos. Inversible para la duración.

combinaciones([], []).

combinaciones([Sketch|Sketches], [Sketch|Combinacion]) :-
    combinaciones(Sketches, Combinacion).

combinaciones([_|Sketches], Combinacion) :-
    combinaciones(Sketches, Combinacion).


duracionTotal(Sketches, DuracionTotal) :-
    findall(Sketch, duracion(Sketch, _), TodosLosSketches),
    combinaciones(TodosLosSketches, Sketches),
    findall(Duracion,
            (member(Sketch, Sketches),
            duracion(Sketch, Duracion)),
            Duraciones),
    sumlist(Duraciones, DuracionTotal).

% punto 3: Saber si un sketch puede ser interpretado por un conjunto de intérpretes. 
% Esto sucede cuando en ese conjunto disponemos de intérpretes que cubren todos los roles 
% necesarios para el mencionado sketch. Inversible para el sketch.
