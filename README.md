Erlang을 이용한 아주 간단한 swap 서버
==========


실행
----------

    $erl -sname hello
    (hello@localhost)1> c(start_server).
    (hello@localhost)2> c(hello_server). 
    (hello@localhost)3> start_sever:server_front().
    
    

접속
----------

    $telnet localhost 2345
    hello
    Response Hello
    
    
    
swap 하기
----------

# 첫번째방법 #

    (hello@localhost)4> c(hello_server2).
    (hello@localhost)5> start_server:swap_code(hello,hello_server2).
    

# 두번째방법 #

    $erl -sname hello2
    (hello2@localhost)1> rpc:call(hello@localhost,c,c,[hello_server2]).
    (hello2@localhost)2> rpc:call(hello@localhost,start_server,swap_code,[hello,hello_server2]).
    
    
위에 접속에서 이어서 다시 확인
----------

    $telnet localhost 2345
    hello
    Response Hello
    Response2 Hello
    
 
    
 
