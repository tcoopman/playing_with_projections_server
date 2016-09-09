defmodule Quizzy.EventStream.Test do
    use ExUnit.Case, async: true

    alias Quizzy.EventStream

    setup do
        EventStream.start

        on_exit fn -> EventStream.stop end
    end

    test "getting a non existing stream id, returns an empty stream" do
        EventStream.start

        assert EventStream.get(1) == []
    end
end