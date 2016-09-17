defmodule Quizzy.EventStream.Test do
    use ExUnit.Case, async: true

    alias Quizzy.EventStream

    setup do
        EventStream.start_link

        on_exit fn -> EventStream.stop end
    end

    test "getting a non existing stream id, returns an empty stream" do
        assert EventStream.get("invalid_id") == []
    end

    test "getting an existing stream id, returns a stream of events" do
        stream = EventStream.get("0")

        assert Enum.count(stream) > 0

        Enum.each(stream, fn event -> 
            event_name = inspect event.__struct__
            assert String.starts_with? event_name, "Quizzy.Events."
        end)
    end
end