%%%-------------------------------------------------------------------
%%% File    : hello_server.erl
%%% Author  : 재진 윤 <jaejinyun@jaejinyunmac.local>
%%% Description : hello_server 메시지만 출력
%%%
%%% Created :  1 Feb 2013 by 재진 윤 <jaejinyun@jaejinyunmac.local>
%%%-------------------------------------------------------------------
-module(hello_server).
-export([init/0,handle/2]).


init()->
    true.

handle(Request,OldState)->
    io:format("Request: hello ~p~n",[Request]),
    {"Response Hello",OldState}.
           
