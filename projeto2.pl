%Grupo 2
%Gustavo Rosseto Leticio, Lucas Spagnol, Lucas Mondini, Pedro Gonçalves, Vinícius Brunheroto
:-dynamic evento/2.
:-dynamic eventos/1.
:-dynamic roteiro/1.
eventos([]).
roteiro([]).

if(Condição, Then, _) :- Condição, !, Then.
if(_,_,Else) :- Else.

%Adiciona evento no banco
adiciona(Nome, Duracao) :-
    Duracao > 0, 
    Duracao < 24,
    assertz(evento(Nome, Duracao)),
	retract(eventos(_)),
    findall(evento(X,Y), evento(X, Y), L),
    asserta(eventos(L)).

%Remove evento do banco
remove(Nome) :-
    retract(evento(Nome, _)),
    retract(eventos(_)),
    findall(evento(X,Y), evento(X, Y), L),
    asserta(eventos(L)).

%Data e verificação
data(Dia, Hora):- Dia>0, Dia<29, Hora>0, Hora <25.

%Roteiro
horario(Nome,Duracao,Dia,Hora):- evento(Nome,Duracao), data(Dia,Hora).

organizaRecursao([], Roteiro, _, _, _, _, _):- % Critério de parada (salva no fato dinâmico)
    retract(roteiro(_)),
    asserta(roteiro(Roteiro)).

organizaRecursao([EvHead | EvTail], Roteiro, PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora, FimUltEvento):-
    EvHead = evento(_, Duracao),
    Duracao < ÚltimaHora - PrimeiraHora, %Falha caso a duração do evento seja maior que o intervalo de hora liberado para alocação
    FimNovoEvento is FimUltEvento + Duracao,
    	%se hora passou dos limites:
    	%Se FimNovoEvento >= ÚltimaHora:
    	%	FimUltEvento = PrimeiraHora
        %	FimNovoEvento = PrimeiraHora + Duracao
        %	PrimeiroDia = PrimeiroDia + 1
    	
    if(FimNovoEvento >= ÚltimaHora, 
    (%THEN
       	NovoPrimeiroDia is PrimeiroDia + 1,
        NovoFimNovoEvento is PrimeiraHora + Duracao,
        append(Roteiro, [horario(EvHead, data(NovoPrimeiroDia, PrimeiraHora))], NovoRoteiro),
        organizaRecursao(EvTail, NovoRoteiro, NovoPrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora, NovoFimNovoEvento)
    ),
    (%ELSE
       	PrimeiroDia =< ÚltimoDia, % Falha se o dia atual for maior que o ultimo
       	append(Roteiro, [horario(EvHead, data(PrimeiroDia, FimUltEvento))], NovoRoteiro),
        organizaRecursao(EvTail, NovoRoteiro, PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora, FimNovoEvento)
     )).

%Como chamar o organizador: organiza(eventos, [], PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora).
%O roteiro fica salvo no fato dinâmico roteiro/1.
organiza([EvHead | EvTail], Roteiro, PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora) :-
    EvHead = evento(_, Duracao),
    Duracao < ÚltimaHora - PrimeiraHora, %Falha caso a duração do evento seja maior que o intervalo de hora liberado para alocação
    FimNovoEvento is PrimeiraHora + Duracao,
    append(Roteiro, [horario(EvHead, data(PrimeiroDia, PrimeiraHora))], NovoRoteiro),
    organizaRecursao(EvTail, NovoRoteiro, PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora, FimNovoEvento). 
    
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
