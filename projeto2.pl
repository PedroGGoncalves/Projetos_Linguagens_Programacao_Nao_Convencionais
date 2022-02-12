%Grupo 2
%Gustavo Rosseto Leticio, Lucas Spagnol, Lucas Mondini, Pedro Gonçalves, Vinícius Brunheroto

%%Setup do banco de dados dinâmico
:-dynamic evento/2.
:-dynamic listaEventos/1.
:-dynamic roteiro/1.
:-dynamic dia_inicio/1.
:-dynamic dia_fim/1.
:-dynamic hora_inicio/1.
:-dynamic hora_fim/1.
listaEventos([]).
roteiro([]).
%Os dias e horas para inclusão inicialmente envolvem o mês inteiro. Deve ser definido com roteiroInf posteriormente.
dia_inicio(1).
dia_fim(28).
hora_inicio(1).
hora_fim(24).

%%Especificação do if then else
if(Condição, Then, _) :- Condição, !, Then.
if(_,_,Else) :- Else.

%%Verifica os limites válidos para dia e hora
data(Dia, Hora):- Dia > 0, Dia < 29, Hora > 0, Hora < 25.

%%Gerenciamento de eventos
%Adiciona eventos dinamicamente e reorganiza o roteiro
adiciona(Nome, Duracao) :-
    assertz(evento(Nome, Duracao)),
	retract(listaEventos(_)),
    findall(evento(X,Y), evento(X, Y), L),
    asserta(listaEventos(L)),
    %Reorganiza o roteiro
    dia_inicio(PrimeiroDia), dia_fim(ÚltimoDia), hora_inicio(PrimeiraHora), hora_fim(ÚltimaHora),
    organiza(L, [], PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora). 

%Carrega o banco de dados do "arquivo_insercao.pl" e organiza automaticamente o banco de dados dinâmico e o roteiro
carregaDoArquivo:-
    consult("arquivo_insercao.pl"),
    retract(listaEventos(_)),
    findall(evento(X,Y), evento(X, Y), L),
    asserta(listaEventos(L)),
    %Reorganiza o roteiro
    dia_inicio(PrimeiroDia), dia_fim(ÚltimoDia), hora_inicio(PrimeiraHora), hora_fim(ÚltimaHora),
    organiza(L, [], PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora). 


%Remove o evento de nome Nome do banco de dados
remove(Nome) :-
    retract(evento(Nome, _)),
    retract(listaEventos(_)),
    findall(evento(X,Y), evento(X, Y), L),
    asserta(listaEventos(L)),
    %Reorganiza o roteiro
    dia_inicio(PrimeiroDia), dia_fim(ÚltimoDia), hora_inicio(PrimeiraHora), hora_fim(ÚltimaHora),
    organiza(L, [], PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora). 

%%Roteiro
roteiroInf :-
    print("Digite primeiro dia:"),
    nl,
    read(Primeirodia),
    print("Digite ultimo dia:"),
    nl,
    read(Ultimodia),
    print("Digite primeira hora de cada dia:"), 
    nl,
    read(Primeirahora),
    print("Digite a ultima hora de cada dia: "),
    nl,
    read(Ultimahora),
    data(Primeirodia, Primeirahora),
    data(Ultimodia, Ultimahora),
    %Atualização das variáveis globais
    retract(dia_inicio(_)),
    retract(dia_fim(_)),
    retract(hora_inicio(_)),
    retract(hora_fim(_)),
    asserta(dia_inicio(Primeirodia)),
    asserta(dia_fim(Ultimodia)),
    asserta(hora_inicio(Primeirahora)),
    asserta(hora_fim(Ultimahora)),
    %Reorganiza o roteiro
    listaEventos(L),
    organiza(L, [], Primeirodia, Ultimodia, Primeirahora, Ultimahora).

%%Organizador
%Critério de parada (salva no banco de dados dinâmico)
organizaRecursao([], Roteiro, _, _, _, _, _):- 
    retract(roteiro(_)),
    asserta(roteiro(Roteiro)).

%Parte recursiva do procedimento de organização do roteiro
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

%Procedimento inicial de organização do roteiro
%Como chamar o organizador: listaEventos(E), organiza(E, [], PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora).
%O roteiro fica salvo no fato dinâmico roteiro/1.
organiza([EvHead | EvTail], Roteiro, PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora) :-
    EvHead = evento(_, Duracao),
    Duracao < ÚltimaHora - PrimeiraHora, %Falha caso a duração do evento seja maior que o intervalo de hora liberado para alocação
    FimNovoEvento is PrimeiraHora + Duracao,
    append(Roteiro, [horario(EvHead, data(PrimeiroDia, PrimeiraHora))], NovoRoteiro),
    organizaRecursao(EvTail, NovoRoteiro, PrimeiroDia, ÚltimoDia, PrimeiraHora, ÚltimaHora, FimNovoEvento). 

%%Calendario
%Fatos e regras para associação dos dias da semana
diaSemana(1, terça).
diaSemana(2, quarta).
diaSemana(3, quinta).
diaSemana(4, sexta).
diaSemana(5, sabado).
diaSemana(6, domingo).
diaSemana(7, segunda).
diaSemana(N, Nome):-
    Nmenos is N - 7,
    diaSemana(Nmenos, Nome).
%Imprime o calendário recursivamente
dia(N, Roteiro):-
    (     
    	N  =< 28,
      	diaSemana(N, Nome),
        format('Dia:~d ~a ~n', [N, Nome]),
        imprimelistaEventos(N, Roteiro),
        Proximo is N+1,
        dia(Proximo, Roteiro)
    );
    true.
    
%Imprime informações do evento se estiver no dia certo
imprimeData(Horario, Dia) :-
    Horario = horario(evento(Nome, Duração), data(DiaEvento, Hora)),
    Dia =:= DiaEvento,  %se isso for verdade, printa
    format("~a: Dia ~d às ~d horas. Duração: ~d horas.~n",[Nome, DiaEvento, Hora, Duração]).

%Caso base
imprimelistaEventos(_,[]).

%Recursão para procurar se há eventos para imprimir no dia N (passa o dia e o roteiro)
imprimelistaEventos(N, [Cabeça|Cauda]) :-
    imprimeData(Cabeça, N), fail; % subrotina (não sei pq mas ele só roda o que está dps do ; se der false)  
    imprimelistaEventos(N, Cauda). % recursão, chama ele mesmo passando a cauda

%Requisito 1
imprimeLista:-
    roteiro(R),
    write(R).    
%Requisito 2   
calendarioRoteiro:- 
    roteiro(R),
    dia(1, R), !.

%Requisito 3
calendarioSimples:-
    dia(1, []), !.

%Requisito 2 para arquivo
calendarioRoteiroNoArquivo:- tell('requisito2.txt'), calendarioRoteiro, told.
%Requisito 3 para arquivo
calendarioSimplesNoArquivo:- tell('requisito3.txt'), calendarioSimples, told.
