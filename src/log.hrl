-define(T,
(fun() ->
    {_,_,__McS} = __Now = erlang:now(),
    {{__YYYY,__MM,__DD},{__H,__M,__S}} = calendar:now_to_local_time(__Now),
    lists:flatten(io_lib:format("~2..0B.~2..0B.~4..0B ~2..0B:~2..0B:~2..0B.~6..0B", [__DD,__MM,__YYYY,__H,__M,__S,__McS rem 1000000]))
end)()).

-ifndef(NOLOGGING).
-define(LOG(__T,__L,__M,__F,__A),
(fun() ->    
    case [A || {A,_,_} <- application:which_applications(), A =:= erloci] of
        [erloci] -> ok;
        _ -> application:load(erloci)
    end,
    __S = case application:get_env(erloci, logging) of
    {ok, debug} ->
        case __L of
        dbg -> lists:flatten(io_lib:format(?T++" [debug] ["++__T++"] " ++ __F ++ "~n", __A));
        nfo -> lists:flatten(io_lib:format(?T++" [info]  ["++__T++"] " ++ __F ++ "~n", __A));
        err -> lists:flatten(io_lib:format(?T++" [error] ["++__T++"] " ++ __F ++ "~n", __A));
        _ -> ok
        end;
    {ok, info} ->
        case __L of
        nfo -> lists:flatten(io_lib:format(?T++" [info]  ["++__T++"] " ++ __F ++ "~n", __A));
        err -> lists:flatten(io_lib:format(?T++" [error] ["++__T++"] " ++ __F ++ "~n", __A));
        _ -> ok
        end;
    {ok, error} ->
        case __L of
        err -> lists:flatten(io_lib:format(?T++" [error] ["++__T++"] " ++ __F ++ "~n", __A));
        _ -> ok
        end;
    _ -> ok
    end,
    oci_logger:log(__S)
end)()
).
-else.
-define(LOG(__T,__L,__M,__F,__A), ok = ok).
-endif.
