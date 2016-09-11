defmodule Quizzy.StreamController do
    @moduledoc """
    Controller module for event streams
    """

    use Quizzy.Web, :controller

    alias Quizzy.EventStream

    def show(conn, %{"id" => id}) do
        stream = EventStream.get(id)
        render conn, "show.json", stream: stream
    end

end
