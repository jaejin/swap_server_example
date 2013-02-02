%%%-------------------------------------------------------------------
%%% File    : hello_server2.erl
%%% Author  : 재진 윤 <jaejinyun@jaejinyunmac.local>
%%% Description : hello2_server2
%%%
%%% Created :  1 Feb 2013 by 재진 윤 <jaejinyun@jaejinyunmac.local>
%%%-------------------------------------------------------------------
-module(hello_server2).
-export([loop/0]).

loop()->
    receive
        {From, {hello,N}}->
            From ! {self(), hello(N)},
            loop();
        {become,Something} ->
            Something()
    end.


hello(N)->
    io:format("hello2 ~p~n",[N]).
           
