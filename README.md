DribbbleGif
===========

**https://twitter.com/dribbble_gif**


## if you want to use this
Please add `config/config.exs` to use [ExTwitter](https://github.com/parroty/extwitter).

###### config/config.exs
``` elixir 
use Mix.Config

config :ex_twitter, :oauth, [
   consumer_key: "xxxxxx",
   consumer_secret: "xxxxxx",
   access_token: "xxxxxx",
   access_token_secret: "xxxxxx"
]
```

### [develop] watch & run in iex
> chokidar **/*.exs **/*.ex -c 'iex -S mix run -e "DribbbleGif.main"'

### start as daemon
> elixir --detached -S mix run --no-halt

### kill daemon
> ps -eaf|grep elixir
> kill <PID>

