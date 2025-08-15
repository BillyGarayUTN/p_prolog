/*
Un tuid: tuid(usuario, [listadepalabras])
Un retuid: retuid(retuideador, tuid(autorOriginal, [contenido, original]))

→ functor tuid/2
tuid(coirotomas, ["es", "mi", "cumple", "arrodillense"]).

→ functor retuid/2
retuid(fanDeTusk, tuid(melonTusk, ["ser", "millonario", "es", "más", "difícil", "que", "ser", "pobre"])).

*/


% publicacion(Fecha, Post). 
publicacion(fecha(25, 01, 2013), tuid(coirotomas, ["es", "mi", "cumple", "arrodillense"])). 
publicacion(fecha(26, 01, 2014), tuid(fanDeTusk, ["paga", "Tuiderr", "en", "vez", "de", "quejarte", "queridito"])). 
publicacion(fecha(06, 07, 2014), tuid(matifreyre, ["que", "bueno", "Les", "Luthiers"])). 
publicacion(fecha(25, 12, 2014), tuid(melonTusk, ["ser", "millonario", "es", "más", "difícil", "que", "ser", "pobre"])). 
publicacion(fecha(23, 07, 2023), tuid(melonTusk, ["ahora", "se", "llama", "Z"])). 
publicacion(fecha(18, 05, 2024), tuid(alumnoFrustrado, ["pdep", "hace", "los", "peores", "parciales"])). 
publicacion(fecha(05, 06, 2024), retuid(fanDeTusk, tuid(melonTusk, ["ser", "millonario", "es", "más", "difícil", "que", "ser", "pobre"]))). 
publicacion(fecha(18, 05, 2024), retuid(alumno2, tuid(alumnoFrustrado, ["pdep", "hace", "los", "peores", "parciales"]))). 
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "mas", "contenido", "gatito", "enBio"])). 
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "menos", "contenido", "gatito", "enBio"])). 
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "otro", "contenido", "gatito", "enBio"])). 
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "diferente", "contenido", "gatito", "enBio"])). 
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "parecido", "contenido", "gatito", "enBio"])). 
publicacion(fecha(23, 06, 2024), tuid(bornoPot, ["para", "distinto", "contenido", "gatito", "enBio"])). 
publicacion(fecha(23, 06, 2024), tuid(coirotomas, ["compren", "bitcoin", "es", "el", "futuro"])). 
publicacion(fecha(27, 06, 2024), tuid(estafador238, ["cryptos", "gratis", "en", "link", "pongan", "datos"])). 
publicacion(fecha(06, 07, 2024), retuid(matifreyre, tuid(matifreyre, ["que", "bueno", "Les", "Luthiers"]))). 
% paraAprobar(Fecha, Post). 
paraAprobar(fecha(20, 03, 2023), tuid(leocesario, ["miren", "este", "lechoncito"])). 
paraAprobar(fecha(25, 01, 2024), tuid(coirotomas, ["cumpli", "30", "me", "duele", "la", "espalda"])). 
paraAprobar(fecha(17, 11, 2024), retuid(leocesario, tuid(coirotomas, ["es", "mi", "cumple", "arrodillense"]))). 
paraAprobar(fecha(23, 06, 2024), tuid(bornoPot, ["gatito", "enBio", "clickea", "el", "link"])).

%  Nota: Recuerden que existen los predicados nth0/3 y nth1/3.

/* 
Aclaración: Cuando se hace referencia a una “publicación”, estamos hablando de un Post aprobado.
En cambio, cuando hablamos de Post, puede ser aprobado (publicado) o en proceso (para aprobar).
*/

% 1) Hacer publicacionDe/2, que relacione a un usuario con el contenido de una de sus publicaciones.
publicacionDe(Usuario, Post) :-
    publicacion(_, tuid(Usuario, Post)).

publicacionDe(Usuario, Post) :-
    publicacion(_, retuid(Usuario, tuid(_, Post))).

% 2) Implementar diferentes predicados de revisión de contenido:
/*
a) contieneFrase/3 que relaciona dos palabras con un Post si las dos palabras están escritas en forma
consecutiva en el contenido de ese Post. No necesita ser inversible para las dos palabras.
*/
contieneFrase(Palabra1, Palabra2, Post) :-
    contenidoPost(Post, Contenido),
    contienePalabrasConsecutivas(Palabra1, Palabra2, Contenido).

% Predicado auxiliar para obtener el contenido de un post
contenidoPost(tuid(_, Contenido), Contenido).
contenidoPost(retuid(_, tuid(_, Contenido)), Contenido).

% Predicado auxiliar para verificar palabras consecutivas
contienePalabrasConsecutivas(Palabra1, Palabra2, [Palabra1, Palabra2 | _]).
contienePalabrasConsecutivas(Palabra1, Palabra2, [_ | Resto]) :-
    contienePalabrasConsecutivas(Palabra1, Palabra2, Resto).


/*
b) esDeBot/1, que se verifica para cualquier Post que cumpla al menos una de las siguientes condiciones:
i) Contiene "gatito enBio" en cualquier lugar del contenido.
ii) No es de este año.
iii) Es un ReTuid de un Post anterior a 2015.
3) Hacer verdaderoAutor/2, que relaciona un Post con su autor
*/

esDeBot(Post) :-
    contieneFrase("gatito", "enBio", Post).

esDeBot(Post) :-
    obtenerFechaPost(Post, fecha(_, _, Año)),
    Año \= 2025.

esDeBot(retuid(_, TuidOriginal)) :-
    obtenerFechaPost(TuidOriginal, fecha(_, _, Año)),
    Año < 2015.

% Predicado auxiliar para obtener la fecha de un post
obtenerFechaPost(Post, Fecha) :-
    publicacion(Fecha, Post).

obtenerFechaPost(Post, Fecha) :-
    paraAprobar(Fecha, Post).

/*
3) Hacer verdaderoAutor/2, que relaciona un Post con su autor verdadero, siendo que, en los casos 
de los ReTuids, el verdadero autor es el que publicó el Tuid original.
*/
verdaderoAutor(Usuario, Post):-
    publicacion(_, tuid(Usuario,Post)).

verdaderoAutor(Usuario, Post) :-
    publicacion(_, retuid(_, tuid(Usuario, Post))).

/*
4) Implementar postsParaPublicar/2, que relaciona un usuario y sus Posts en 
    proceso de aprobación que no son de bot.
*/
/*
4) Implementar postsParaPublicar/2, que relaciona un usuario y sus Posts en 
    proceso de aprobación que no son de bot.
*/
postsParaPublicar(Usuario, Post) :-
    paraAprobar(_, Post),
    autorDelPost(Usuario, Post),
    not(esDeBot(Post)).

% Predicado auxiliar para obtener el autor de un post
autorDelPost(Usuario, tuid(Usuario, _)).
autorDelPost(Usuario, retuid(Usuario, _)).


/*
5) Necesitamos saber si un usuario debe ser favorecido/1 por el algoritmo. Esto sucede sólo cuando,
en sus Posts, no tiene ReTuids (él/ella no retuidea, es “100% ORISHINAL”), y además nunca incluyó
la frase "cryptos gratis".
*/

