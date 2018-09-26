defmodule MyApp.Component.ParallaxBackground do
  use Scenic.Component

  alias Scenic.Graph
  alias MyApp.Asset

  import MyApp.Component.Helpers

  @speed 2

  # --------------------------------------------------------
  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  # ----------------------------------------------------------------------------
  def init(_, opts) do
    graph =
      Graph.build()
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s05.png"),
          size: {960, 18},
          speed: @speed * 0.4,
          direction: :left
        },
        %{
          translate: {0, 265}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s04.png"),
          size: {960, 27},
          speed: @speed * 0.5,
          direction: :left
        },
        %{
          translate: {0, 244}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s03.png"),
          size: {960, 57},
          speed: @speed * 0.64,
          direction: :left
        },
        %{
          translate: {0, 190}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s02.png"),
          size: {960, 120},
          speed: @speed * 0.8,
          direction: :left
        },
        %{
          translate: {0, 62}
        }
      )
      |> add_horizontal_scroller(%{
        path: Asset.image("sotb/s01.png"),
        size: {960, 63},
        speed: @speed,
        direction: :left
      })
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s06.png"),
          size: {960, 219},
          speed: @speed * 0.8,
          direction: :left
        },
        %{
          translate: {0, 291}
        }
      )
      |> add_horizontal_scroller(%{
        path: Asset.image("sotb/s07.png"),
        size: {10200, 600},
        speed: @speed,
        direction: :left
      })
      |> add_horizontal_scroller(%{
        path: Asset.image("sotb/s08.png"),
        size: {13500, 600},
        speed: @speed,
        direction: :left
      })
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s09.png"),
          size: {960, 65},
          speed: @speed * 1.1,
          direction: :left
        },
        %{
          translate: {0, 600 - 75}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s10.png"),
          size: {960, 54},
          speed: @speed * 1.2,
          direction: :left
        },
        %{
          translate: {0, 600 - 54}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s11.png"),
          size: {960, 33},
          speed: @speed * 1.3,
          direction: :left
        },
        %{
          translate: {0, 600 - 33}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: Asset.image("sotb/s12.png"),
          size: {960, 66},
          speed: @speed * 1.5,
          direction: :left
        },
        %{
          translate: {0, 600 - 66}
        }
      )
      |> push_graph()

    {:ok, graph}
  end
end
