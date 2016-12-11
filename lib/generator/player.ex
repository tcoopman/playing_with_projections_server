defmodule Quizzy.Generator.Player do
  alias Quizzy.Generator.Player.TypeOfPlayer
  alias Quizzy.Generator.Util
  alias Quizzy.Events.{PlayerHasRegistered, Meta}

  def generate_players(register_distribution, type_generator, {year, month}) do
    register_distribution
    |> Map.keys
    |> Util.filter_from_distribution({year, month})
    |> Enum.flat_map(&(Util.generate_days(&1, Util.number_to_generate_for_date(register_distribution, &1))))
    |> Enum.map(&generate_player/1)
    |> Enum.map(fn event -> %{type: type_generator.(), event: event} end)
  end

  defp generate_player(timestamp) do
    meta = Util.generate_meta(timestamp)
    player_id = Util.generate_id

    name_hash = Util.hash_string(player_id)
    first_name = String.slice(name_hash, 0..4)
    last_name = String.slice(name_hash, 5..8)

    %PlayerHasRegistered{meta: meta, player_id: player_id, first_name: first_name, last_name: last_name}
  end
end
