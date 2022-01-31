%Data e verificação
Evento(Nome,Duracao):- Duracao>0, Duracao<29.
data(Dia,Hora):- Dia>0, Dia<29, Hora>0, Hora <25.
Evento (Nome, Duracao). 
Roteiro(evento,data).

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
    dia(Proximo)
           );
    true.
calendario:- dia(1).
%Requisito 2 para arquivo
tell('requisito2.txt'), listing(calendario), told.
