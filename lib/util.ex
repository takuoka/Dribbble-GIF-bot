defmodule DribbbleGif.Util do
    def random_num(number) do
      :random.seed(:erlang.now())
      :random.uniform(number)
    end
end
