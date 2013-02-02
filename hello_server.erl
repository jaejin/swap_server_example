%%%-------------------------------------------------------------------
%%% File    : hello_server.erl
%%% Author  : 재진 윤 <jaejinyun@jaejinyunmac.local>
%%% Description : hello_server 메시지만 출력
%%%
%%% Created :  1 Feb 2013 by 재진 윤 <jaejinyun@jaejinyunmac.local>
%%%-------------------------------------------------------------------
-module(hello_server).
-export([loop/0]).

loop()->
    receive
        {From, {hello,N}}->
            From ! {self(), N},
            loop();
        {become,Something} ->
            Something()
    end.


hello(N)->
    io:format("hello ~p~n",[N]).
           
