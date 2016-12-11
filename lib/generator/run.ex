defmodule Quizzy.Generator.Run do
  alias Quizzy.Generator
  alias Quizzy.Generator.Writer

  def run(start, filename) do
    start
    |> Generator.generate
    |> Writer.write_json(filename)
  end
end
