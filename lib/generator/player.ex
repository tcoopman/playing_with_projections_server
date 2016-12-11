defmodule Quizzy.Generator.Player do
  alias Quizzy.Generator.Player.TypeOfPlayer
  alias Quizzy.Generator.Util
  alias Quizzy.Events.{PlayerHasRegistered, Meta}

  @player_names [
      "Yasmin Rearick",
      "Carmelita Gangemi",
      "Jenniffer Truehart",
      "Jerrold Ver",
      "Leonore Curry",
      "Rocky Stackpole",
      "Twanna Hadfield",
      "Beula Burt",
      "Alta Oakes",
      "Nicki Bodkin",
      "Junie Manigo",
      "Manual Martell",
      "Roxanne Sharrock",
      "Bunny Ruge",
      "Sylvie Hatton",
      "Rolanda Beavers",
      "Jacalyn Oxley",
      "Matha Nuckles",
      "Barney Keough",
      "Reiko Cadieux",
      "Arthur Manney",
      "Era Longmore",
      "Charise Peterka",
      "Dung Abbot",
      "Pamelia Hausner",
      "Fransisca Moscoso",
      "Karyn Gerson",
      "Zoila Corella",
      "Taren Despres",
      "Kendrick Eley",
      "Shela Lynes",
      "Hoa Martyn",
      "Lakisha Towles",
      "Shauna Rappaport",
      "Myrle Dunham",
      "Leandra Pires",
      "Charlyn Scardina",
      "Jefferey Kealey",
      "Ivey Cespedes",
      "Bree Tison",
      "Damion Wagener",
      "Elicia Abrahamson",
      "Kendall Kibby",
      "Humberto Aumick",
      "Laurena Davey",
      "Delana Kamin",
      "Chaya Treloar",
      "Dale Mealy",
      "Chae Stogner",
      "Mitchell Haun",
    ]

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

    [first_name, last_name] = Enum.at(@player_names, (:rand.uniform(50) - 1)) |> String.split

    %PlayerHasRegistered{meta: meta, player_id: player_id, first_name: first_name, last_name: last_name}
  end
end
