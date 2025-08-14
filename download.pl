
% libro(título, autor, edición) 
contenido(amazingzone, host1, 0.1, libro(lordOfTheRings, jrrTolkien, 4)). 
contenido(g00gle, ggle1, 0.04, libro(fundation, asimov, 3)). 
contenido(g00gle, ggle1, 0.015, libro(estudioEnEscarlata, conanDoyle, 3)). 

% musica(título, género, banda/artista) 
contenido(spotify, spot1, 0.3, musica(theLastHero, hardRock, alterBridge)). 
contenido(pandora, pand1, 0.3, musica(burn, hardRock, deepPurple)). 
contenido(spotify, spot1, 0.3, musica(2, hardRock, blackCountryCommunion)). 
contenido(spotify, spot2, 0.233, musica(squareUp, kpop, blackPink)). 
contenido(pandora, pand1, 0.21, musica(exAct, kpop, exo)). 
contenido(pandora, pand1, 0.28, musica(powerslave, heavyMetal, ironMaiden)). 
contenido(spotify, spot4, 0.18, musica(whiteWind, kpop, mamamoo)). 
contenido(spotify, spot2, 0.203, musica(shatterMe, dubstep, lindseyStirling)). 
contenido(spotify, spot4, 0.22, musica(redMoon, kpop, mamamoo)). 
contenido(g00gle, ggle1, 0.31, musica(braveNewWorld, heavyMetal, ironMaiden)). 
contenido(pandora, pand1, 0.212, musica(loveYourself, kpop, bts)). 
contenido(spotify, spot2, 0.1999, musica(aloneInTheCity, kpop, dreamcatcher)). 

% serie(título, géneros) 
contenido(netflix, netf1, 30, serie(strangerThings, [thriller, fantasia])). 
contenido(fox, fox2, 500, serie(xfiles, [scifi])). 
contenido(netflix, netf2, 50, serie(dark, [thriller, drama])). 
contenido(fox, fox3, 127, serie(theMentalist, [drama, misterio])). 
contenido(amazon, amz1, 12, serie(goodOmens, [comedia,scifi])). 
contenido(netflix, netf1, 810, serie(doctorWho, [scifi, drama])). 

% pelicula(título, género, año) 
contenido(netflix, netf1, 2, pelicula(veronica, terror, 2017)). 
contenido(netflix, netf1, 3, pelicula(infinityWar, accion, 2018)). 
contenido(netflix, netf1, 3, pelicula(spidermanFarFromHome, accion, 2019)). 

% Y por supuesto también hay información de las descargas de los usuarios.
% descargar(usuario, titulo)
descarga(mati1009, strangerThings).
descarga(mati1009, infinityWar).
descarga(leoOoOok, dark).
descarga(leoOoOok, powerslave).

% contenido/4
% contenido (Empresa,Servidor,PesoGB,contenido)

%contenido puede ser :  libro, musica, serie o pelicula.

/* 

ser totalmente inversibles, a menos que se aclare lo contrario.

1. La vida es más fácil cuando hablamos solo de los títulos de las cosas...

a. titulo/2. Relacionar un contenido con su título.
b. descargaContenido/2. Relaciona a un usuario con un contenido descargado, es decir 
    toda la información completa del mismo.
*/
contenido(Contenido):-contenido(_, _, _, Contenido).

% a
% titulo(Contenido, Titulo)
titulo(Contenido,Titulo):-
    contenido(Contenido),
    tituloContenido(Contenido,Titulo).

tituloContenido(libro(Titulo, _, _), Titulo).
tituloContenido(musica(Titulo, _, _), Titulo).
tituloContenido(serie(Titulo, _), Titulo).
tituloContenido(pelicula(Titulo, _, _), Titulo).

% b
% descargaContenido(Usuario, Contenido)
descargaContenido(Usuario,Contenido):-
    descarga(Usuario, Titulo),
    titulo(Contenido,Titulo).
%   contenido(_, _, _, Contenido),

% 2. contenidoPopular/1. Un contenido es popular si lo descargan más de 10 usuarios.

contenidoPopular(Contenido) :-
    titulo(Contenido, Titulo),
    findall(Usuario, descargaContenido(Usuario, Contenido), Usuarios),
    length(Usuarios, Cantidad),
    Cantidad > 10.

% 3. cinefilo/1 Un usuario es cinéfilo si solo descarga contenido audiovisual (series y películas)
usuario(Usuario):-
    distinct(Usuario,descarga(Usuario,_)).

cinefilo(Usuario):-
    usuario(Usuario),
    forall(descargaContenido(Usuario,Contenido), esAudioVisual(Contenido)).

/* esAudioVisual(Contenido):- titulo(Contenido, Titulo), (contenido(_, _, _, serie(Titulo, _));
    contenido(_, _, _, pelicula(Titulo, _, _))  ).*/
esAudioVisual(serie(_,_)).

esAudioVisual(pelicula(_, _, _)).

% 4. totalDescargado/2. Relaciona a un usuario con el total del peso del contenido de sus descargas, en GB
totalDescargado(Usuario,PesoTotal):-
    usuario(Usuario),
    findall(Peso, (descargaContenido(Usuario,Contenido),contenido(_, _, Peso, Contenido)), Pesos),
    sumlist(Pesos, PesoTotal).

% 5. usuarioCool/1. Un usuario es cool, si solo descarga contenido cool:
% a. La música es cool si el género es kpop o hardRock.
% b. Las series, si tienen más de un género.
% c. Las películas anteriores al 2010 son cool.
% d. Ningún libro es cool. 

usuarioCool(Usuario):-
    usuario(Usuario),
    forall( descargaContenido(Usuario,Contenido),esContenidoCool(Contenido)).

esContenidoCool(musica(_,kpop,_)).
esContenidoCool(musica(_,hardRock,_)).
esContenidoCool(serie(_, Generos)):-length(Generos, Cantidad),Cantidad > 1.
esContenidoCool(pelicula(_, _, Anio)):-Anio < 2010.

% 6.empresaHeterogenea/1. Si todo su contenido no es del mismo tipo. Es decir, todo película, o todo serie... etc.
empresaHeterogenea(Empresa) :-
    contenido(Empresa,_,_,Contenido1),
    contenido(Empresa,_,_,Contenido2),
    tipoContenido(Contenido1, Tipo1),
    tipoContenido(Contenido2, Tipo2),
    Tipo1 \= Tipo2.

tipoContenido(libro(_, _, _), libro).
tipoContenido(musica(_, _, _), musica).
tipoContenido(serie(_, _), serie).
tipoContenido(pelicula(_, _, _), pelicula).

% 7. Existe la sobrecarga de equipos, por lo tanto vamos a querer trabajar sobre los servidores a 
%   partir del peso de su contenido:
% a. cargaServidor/3. Relaciona a una empresa con un servidor de dicha empresa y su carga, es
%   decir el peso conjunto de todo su contenido.
% b. tieneMuchaCarga/2. Relaciona una empresa con su servidor que tiene exceso de carga. Esto pasa
%   cuando supera los 1000 GB de información.
% c. servidorMasLiviano/2. Relaciona a la empresa con su servidor más liviano, que es aquel que tiene
%   menor carga, teniendo en cuenta que no puede tener mucha carga.
% d. balancearServidor/3. Relaciona una empresa, un servidor que tiene mucha carga y el servidor
%   más liviano de la empresa; de forma tal de planificar una migración de contenido del primero
%   al segundo, los cuales deben ser distintos.

% 7.a --------------------------------------
empresaServidor(Empresa,Servidor):-
    distinct(Servidor,contenido(Empresa,Servidor,_,_)).

cargaServidor(Empresa, Servidor, Carga) :-
    empresaServidor(Empresa, Servidor),
    findall(Peso, contenido(Empresa, Servidor, Peso, _), Pesos),
    sumlist(Pesos, Carga).
% 7.b ---------------------------------------
tieneMuchaCarga(Empresa, Servidor) :-
    contenido(Empresa,Servidor,PesoGB,_),
    PesoGB > 1000.
% 7.c ---------------------------------------
servidorMasLiviano(Empresa, Servidor) :-
    cargaServidor(Empresa, Servidor, Carga),
    Carga =< 1000,    % “no tiene mucha carga” sin usar \+
    forall(cargaServidor(Empresa, _, OtraCarga), % es el mínimo (o uno de los mínimos)
    Carga =< OtraCarga).
/*
servidorMasLiviano(Empresa, Servidor) :-
    cargaServidor(Empresa, Servidor, Carga),
    not(tieneMuchaCarga(Empresa, Servidor)),
    not((cargaServidor(Empresa, _, OtraCarga), OtraCarga < Carga)).
*/
% 7.d ---------------------------------------
balancearServidor(Empresa, ServidorConMuchaCarga, ServidorMasLiviano) :-
    tieneMuchaCarga(Empresa, ServidorConMuchaCarga),
    servidorMasLiviano(Empresa, ServidorMasLiviano),
    ServidorConMuchaCarga \= ServidorMasLiviano.