%Grupo 2
%Gustavo Rosseto Leticio, Lucas Spagnol, Lucas Mondini, Pedro Gonçalves, Vinícius Brunheroto
:-dynamic evento/2.
:-dynamic lista/1.
lista([]).

%Adiciona evento no banco
adiciona(Nome, Duracao) :-
    Duracao > 0, 
    Duracao < 672, % 28 dias em horas (passível de alteração)
    assertz(evento(Nome, Duracao)),
	retract(lista(_)),
    findall(evento(X,Y), evento(X, Y), L),
    asserta(lista(L)).

%Remove evento do banco
remove(Nome) :-
    retract(evento(Nome, _)),
    retract(lista(_)),
    findall(evento(X,Y), evento(X, Y), L),
    asserta(lista(L)).

%Data e verificação
data(Dia,Hora):- Dia>0, Dia<29, Hora>0, Hora <25.

%Roteiro
roteiro(Nome,Duracao,Dia,Hora):-evento(Nome,Duracao),data(Dia,Hora).

imprimeLista(Roteiro,Dia):-
    Roteiro=roteiro(evento(Nome,Duracao),data(DiaEvento,Hora)),
    Dia=:=DiaEvento,
    format('~a~d~d~d~n', [Nome,Duracao,DiaEvento,Hora]).

%Calendario
diaSemana(1,terça).
diaSemana(2,quarta).
diaSemana(3,quinta).
diaSemana(4,sexta).
diaSemana(5,sabado).
diaSemana(6,domingo).
diaSemana(7,segunda).
diaSemana(N,Nome):-
    Nmenos is N - 7,
    diaSemana(Nmenos, Nome).
dia(N,Roteiro):-
   (
    N=<28,
    diaSemana(N,Nome),
    format('Dia:~d ~a ~n',[N,Nome]),
    imprimeEventos(N,Roteiro),
    Proximo is N+1,
    dia(Proximo,Roteiro)
    )
    ;
    true.
    
%---------------------PRECISA TESTAR--------------------------------------%
%requisito2
imprimeData(Horario,Dia) :-
    Horario = horario(evento(Nome,Duração), data (DiaEvento, Hora)),
    Dia =:= DiaEvento,  %se isso for verdade, printa
    format("~a ~d ~d ~d~n",[Nome,Duração,DiaEvento,Hora]).

%caso base
imprimeEventos(_,[]).

%Recursão( passa o dia que deve imprimir e o roteiro)
imprimeEventos(N, Roteiro) :-
   Roteiro = [Cabeça|Cauda], % divide numa lista com cabeça e cauda
   (
    imprimeData(Cabeça, N) % subrotina
    ;
    imprimeEventos(N, Cauda) % recursão, chama ele mesmo passando a cauda
   ).
%-------------------------------------------------------------------------%
    
    
calendario:-dia(1,Roteiro).
%Requisito 2 para arquivo
calendarioNoArquivo:-tell('requisito2.txt'), calendario, told.
