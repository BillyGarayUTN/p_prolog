:- include(solucion).

:- begin_tests(punto1_interprete).

test(requerimientoDeActorCumplido, nondet):-
    interprete(marcos, lutherapia).

test(requerimientoDeActorNoCumplido, fail):-
    interprete(carlitos, lutherapia).

:- end_tests(punto1_interprete).


:- begin_tests(punto2_duracionTotal).

test(duracionTotal):-
    duracionTotal([lutherapia, payadaDeLaVaca], 24).

:- end_tests(punto2_duracionTotal).



:- begin_tests(punto3_puedeSerInterpretado).

test(requerimientoDeActorCumplido, nondet):-
    puedeSerInterpretado(lutherapia, [marcos, daniel]).

test(equerimientoDeActorCumplido, nondet):-
    puedeSerInterpretado(lutherapia, [daniel, marcos]).

test(requerimientoDeActorCumplido, fail):-
    puedeSerInterpretado(lutherapia, [jorge, carlos]).

test(requerimientoDeActorCumplido,fail):-
    puedeSerInterpretado(payadaDeLaVaca, [jorge, marcos]).

test(requerimientoDeActorCumplido, fail):-
    puedeSerInterpretado(payadaDeLaVaca, [marcos, carlos]).

:- end_tests(punto3_puedeSerInterpretado).





:- begin_tests(punto4_generarShow).

test(showGeneradoConSketchLargo, nondet):-
    generarShow([marcos, daniel], 20, [lutherapia]).

test(showGeneradoConSketchesCortos, nondet):-
    generarShow([marcos, daniel], 20, [malPuntuado, payadaDeLaVaca]).

test(showNoGeneradoPorFaltaDeInterpretes, fail):-
    generarShow([marcos, carlos], 20, [lutherapia]).

test(showNoGeneradoPorTiempo, fail):-
    generarShow([marcos, daniel], 1, [lutherapia]).

:- end_tests(punto4_generarShow).



:- begin_tests(punto5_estrella).

test(estrellaActoral, nondet):-
    estrella([lutherapia], marcos).

test(estrellaMusical, nondet):-
    estrella([rhapsodyInBalls], jorge).

test(noEstrella, fail):-
    estrella([lutherapia], jorge).

:- end_tests(punto5_estrella).



:- begin_tests(punto6a_puramenteMusical).

test(puramenteMusical):-
    puramenteMusical([payadaDeLaVaca]).

test(noPuramenteMusical, fail):-
    puramenteMusical([malPuntuado, payadaDeLaVaca]).

:- end_tests(punto6a_puramenteMusical).



:- begin_tests(punto6b_cortitos).

test(todosCortitos, nondet):-
    todosCortitos([malPuntuado, payadaDeLaVaca]).

test(noTodosCortitos, fail):-
    todosCortitos([cantataDelAdelantadoDonRodrigoDiazDeCarreras]).

:- end_tests(punto6b_cortitos).



:- begin_tests(punto6c_juntaATodos).

test(juntaATodos, nondet):-
    juntaATodos(
        [malPuntuado, payadaDeLaVaca, lutherapia, rhapsodyInBalls,
        cantataDelAdelantadoDonRodrigoDiazDeCarreras, 
        laBellaYGraciosaMozaMarchoseALavarLaRopa]).

test(noJuntaATodos, fail):-
    juntaATodos([lutherapia]).

:- end_tests(punto6c_juntaATodos).

