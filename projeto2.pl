%Grupo 2
%Gustavo Rosseto Leticio, Lucas Spagnol, Lucas Mondini, Pedro Gonçalves, Vinícius Brunheroto
:- dynamic lista/1.
lista([]).
%Evento
evento(Nome, Duracao):- 
    Nome == Nome, 
    Duracao>0, 
    Duracao<29.

%Adiciona evento na lista
adiciona(Evento) :-
    lista(L),
    append(L, Evento, NovoL),
    retract(lista(L)),
    asserta(lista(NovoL)).

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
    diaSemana(Nmenos, Nome)
    .
dia(N):-
    (   
    N=<28,
    diaSemana(N,Nome),
    format('Dia:~d ~a ~n',[N,Nome]),
    Proximo is N+1,
    dia(Proximo),
    imprimeEventos(N,Roteiro)
           );
    true.
    
%---------------------PRECISA TESTAR--------------------------------------%

imprimeData(Horario,Dia) :-
    Horario = horario(evento(Nome,Duração), data (DiaEvento, Hora)),
    Dia =:= DiaEvento,  %se isso for verdade, printa
    format("~a ~d ~d ~d~n",[Nome,Duração,DiaEvento,Hora]).

%caso base
imprimeEventos(_,[])

%Recursão ( passa o dia que deve imprimir e o roteiro)
imprimeEventos(N, Roteiro) :-
   Roteiro = [Cabeça|Cauda], % divide numa lista com cabeça e cauda
   {
    imprimeData(Cabeça, N) % subrotina
    imprimeEventos (N,Cabeça)  %recursão, chama ele mesmo passando a cabeça
   } ;
   imprimeEventos (N, Cauda). % recursão, chama ele mesmo passando a cauda

%-------------------------------------------------------------------------%
    
    
calendario:- dia(1).
%Requisito 2 para arquivo
%tell('requisito2.txt'), listing(calendario), told.
