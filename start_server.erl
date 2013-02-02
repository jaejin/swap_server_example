%%%-------------------------------------------------------------------
%%% File    : start_server.erl
%%% Author  : 재진 윤 <jaejinyun@jaejinyunmac.local>
%%% Description : 얼랭을 이용한 스왑서버의 시작 소스
%%%
%%% Created :  1 Feb 2013 by 재진 윤 <spyrogira256@gmail.com>
%%%-------------------------------------------------------------------
-module(start_server).
-export([start_front/0,start_app/2, rpc/2, swap_code/2]).

start_front()->
    %Business 모듈 시작
    start_app(hello,hello_server),

    %front 서버 모듈 시작 
    {ok,Listen} = gen_tcp:listen(2345, [binary, 
                                        {reuseaddr, true},
                                        {active, true}]),
    spawn(fun()->
                  par_connect(Listen,hello) end).

% 병렬로 접속하기 위해서 처리
par_connect(Listen,Name)->
    {ok, Socket} = gen_tcp:accept(Listen),
    spawn(fun() ->
                   par_connect(Listen,Name) end),
    socket_loop(Socket,Name).

% 소켓 accept시 처리 
socket_loop(Socket,Name)->
    receive
        % 소켓 데이터 넘어왔을때
        {tcp, Socket, Bin} ->
           io:format("Server received binary = ~p ~n" ,[Bin]),
            % binary로 받기 ㄸㅐ문에 알 수 있게 string형태로 변경
            Str = binary_to_list(Bin),
            io:format("Server (unpacked) ~p ~n", [Str]),
            % Business 모듈 호출 
            Reply = rpc(Name,Str),
            % 결과값 client에게 전송 
            gen_tcp:send(Socket,list_to_binary(Reply)),
            % 다시 소켓 listen 하도록 
            socket_loop(Socket,Name);
        % 소켓접속이 ㄲㅡㄴㅎ어 졌을때
        {tcp_closed, Socket} ->
            io:format("Server Socket closed ~n")
    end.
            
           
           
%Business 시작
start_app(Name,Mod)->
    % process로 등록 
    register(Name, spawn(fun()->
                                 loop(Name,Mod,Mod:init()) end)).

%프로세스 교체 
swap_code(Name,Mod) ->
    rpc(Name, {swap_code, Mod}).

%프로세스 호출 
rpc(Name, Request)->
    Name ! {self(), Request},
    receive
        {Name, crash} ->
             exit(rpc);
        {Name, ok, Response} ->
            Response
    end.


% 프로세스로 메시지 전달시 받는 부
loop(Name, Mod, OldState) ->
    receive
        %교체 메시지가 전송되면 아래 모듈 교체 
        {From, {swap_code, NewCallbackMod}} ->
            From ! {Name, ok, ack},
            loop(Name, NewCallbackMod, OldState);
        %메시지가 오면 로직 처리 
        {From, Request} ->
            try 
                %구현체 모듈의 로직처리 
                Mod:handle(Request,OldState) 
                of
                    % 구현체 결과값에 대한 처리
                    {Response, NewState} ->
                                From ! {Name, ok, Response},
                                loop(Name, Mod, NewState)
            catch
                % 구현체에서 에러 발생시 처리 
                _: Why ->
                          log_the_error(Name, Request, Why),
                          From ! {Name, crash},
                          loop(Name, Mod, OldState)
            end
      end.

log_the_error(Name, Request, Why) ->
    io:format("Server ~p request ~p ~n"
              "caused exception ~p~n" ,
              [Name, Request, Why]).

                  
