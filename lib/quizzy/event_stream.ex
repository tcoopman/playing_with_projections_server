defmodule Quizzy.EventStream do
    use GenServer

    # Client

    def start do
        GenServer.start(__MODULE__, nil, name: EventStream)
    end

    def stop do
        GenServer.cast(EvenStream, :stop)
    end

    def parse(path) do
        
    end

    def get(stream) do
        GenServer.call(EventStream, {:get, stream})
    end

    # Server

    def init(_) do
       {:ok, %{}} 
    end

    def handle_cast({:parse, path}, state) do
        
    end

    def handle_cast(:stop, _, state) do
        {:stop, :normal, state}
    end

    def handle_call({:get, stream}, _, state) do
        {:reply, [], state}
    end
end