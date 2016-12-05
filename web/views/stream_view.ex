defmodule Quizzy.StreamView do
    use Quizzy.Web, :view

    def render("show.json", %{stream: stream}) do
        render_one(stream, Quizzy.StreamView, "event.json")
    end

    def render("event.json", %{stream: stream}) do
        stream
        |> Enum.map(&(render_event &1))
    end

    def render_event(%{__struct__: struct, meta: meta} = event) do
        %{type: struct_to_type(struct), id: meta.id, timestamp: meta.timestamp, payload: Map.delete(event, :meta)}
    end

    defp struct_to_type(struct) do
        "#{struct}"
        |> String.split(".")
        |> List.last
    end

end
