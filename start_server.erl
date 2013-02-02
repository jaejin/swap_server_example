%%%-------------------------------------------------------------------
%%% File    : start_server.erl
%%% Author  : 재진 윤 <jaejinyun@jaejinyunmac.local>
%%% Description : 얼랭을 이용한 스왑서버의 시작 소스
%%%
%%% Created :  1 Feb 2013 by 재진 윤 <spyrogira256@gmail.com>
%%%-------------------------------------------------------------------
-module(start_server).
-export([start/0, rpc/2]).

start() ->
    Pid = start_swap_server(),
    {ok, Listen} = gen_tcp:listen(2345, [binary,
                                         {reuseaddr, true},
                                         {active, true}]),
    {ok, Socket} = gen_tcp:accept(Listen),
    gen_tcp:close(Listen),
    loop(Socket,Pid).

loop(Socket,Pid) ->
    receive
        {tcp, Socket, Bin} ->
            io:format("Server received binary = ~p~n",[Bin]),
            ResponseString = binary_to_list(Bin),
            case ResponseString of 
                "hello\r\n" ->
                    Pid ! {become, fun hello_server:loop/0},
                    gen_tcp:send(Socket,list_to_binary(rpc(Pid,{hello,"hello"}) ++ "\r\n"));
                "hello2\r\n" ->
                    Pid ! {become, fun hello_server2:loop/0},
                    gen_tcp:send(Socket,list_to_binary(rpc(Pid,{hello,"hello"})));
                _ ->
                    gen_tcp:send(Socket,list_to_binary("없는 명령어입니다.\r\n"))
            end,
            loop(Socket,Pid);
        {tcp_closed, Socket} ->
            io:format("Server socket closed~n")
    end.

start_swap_server()->
    spawn(fun()->
                  wait() end).

wait()->
    receive
        {become, F}->
             F()
    end.


rpc(Pid,Q) ->
    Pid ! {self(), Q},
    receive
        {Pid, Reply} ->
            Reply
    end.
           
