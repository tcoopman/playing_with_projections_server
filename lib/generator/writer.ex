defmodule Quizzy.Generator.Writer do
    alias Quizzy.Events

    def write_json(events, file_name) do
        path = "data"
        file = Path.join("data", "#{file_name}.json")

        encoded = events |> Enum.map(&Events.event_to_json/1) |> Poison.encode!

        File.write!(file, encoded, [:utf8])
    end
end
