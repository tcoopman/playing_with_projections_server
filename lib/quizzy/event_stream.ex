defmodule Quizzy.EventStream do
    use GenServer
    use Timex

    alias Quizzy.Events

    # Client

    def start_link do
        GenServer.start_link(__MODULE__, nil, name: EventStream)
    end

    def stop do
        GenServer.cast(EvenStream, :stop)
    end

    def get(stream) do
        GenServer.call(EventStream, {:get, stream})
    end

    # Server

    def init(_) do
      # reading all the files is way too slow for a start up
      # state = read_json_files
      # {:ok, state}
       {:ok, %{}}
    end

    def handle_cast(:stop, _, state) do
        {:stop, :normal, state}
    end

    def handle_call({:get, stream}, _, state) do
        {:reply, Map.get(state, stream, []), state}
    end

    # To refactor

    defp read_json_files do
        is_json = fn file ->
            Path.extname(file) == ".json"
        end

        path = "data"

        path
        |> File.ls!
        |> Enum.filter(&(is_json.(&1)))
        |> Enum.map(&({Path.rootname(&1), parse_json_file(Path.join(path, &1))}))
        |> Map.new
    end

    defp parse_json_file(file) do
        {:ok, file} = File.read file

        sort_events = fn(event1, event2) ->
            t1 = Timex.parse!(event1.meta.timestamp, "{ISO:Extended}")
            t2 = Timex.parse!(event2.meta.timestamp, "{ISO:Extended}")
            Timex.compare(t1, t2) < 1
        end

        file
        |> Poison.Parser.parse!(keys: :atoms)
        |> Enum.map(&(Events.json_to_event(&1)))
        |> Enum.sort(&(sort_events.(&1, &2)))
    end
end
