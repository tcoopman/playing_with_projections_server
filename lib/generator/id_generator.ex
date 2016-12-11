defmodule Quizzy.Generator.IdGenerator do
  def start_link do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def new_id do
    Agent.get_and_update(__MODULE__, fn counter -> {Integer.to_string(counter), counter + 1} end)
  end

  def stop do
    Agent.stop(__MODULE__)
  end
end
