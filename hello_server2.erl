%%%-------------------------------------------------------------------
%%% File    : hello_server2.erl
%%% Author  : 재진 윤 <jaejinyun@jaejinyunmac.local>
%%% Description : hello2_server2
%%%
%%% Created :  1 Feb 2013 by 재진 윤 <jaejinyun@jaejinyunmac.local>
%%%-------------------------------------------------------------------
-module(hello_server2).
-export([init/0,handle/2]).


init()->
    true.

handle(Request,OldState)->
    io:format("Request: hello2 ~p~n",[Request]),
    {"Response Hello Server2",OldState}.
           
