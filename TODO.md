


# TODO

* なぜかアップロードできない画像をNGに追加していくようにしたい

https://dribbble.com/shots/2211615-Slideshow-prototype
これは5MB以下でもだめだった。

 ↓ エラー
2
2:35:57.962 [error] GenServer DribbbleGif.Server terminating
Last message: {:"$gen_cast", {:search_and_tweet}}
State: #PID<0.131.0>
** (exit) an exception was raised:
    ** (ExTwitter.Error) The validation of media ids failed.
        lib/extwitter/api/base.ex:79: ExTwitter.API.Base.parse_error/2
        lib/extwitter/api/tweets.ex:22: ExTwitter.API.Tweets.update/2
        (dribbble_gif) lib/server.ex:46: DribbbleGif.Server.tweet/1
        (dribbble_gif) lib/server.ex:26: DribbbleGif.Server.handle_cast/2
        (stdlib) gen_server.erl:593: :gen_server.try_dispatch/4
        (stdlib) gen_server.erl:659: :gen_server.handle_msg/5
        (stdlib) proc_lib.erl:237: :proc_lib.init_p_do_apply/3
