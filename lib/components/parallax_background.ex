defmodule SOTB.Component.ParallaxBackground do
  use SOTB.Component

  alias Scenic.Graph
  alias SOTB.Asset

  import SOTB.Component.Helpers

  @assets 1..12
          |> Enum.reduce(%{}, fn i, acc ->
            cnt = i |> to_string |> String.pad_leading(2, "0")
            key = "s#{cnt}" |> String.to_atom()
            path = Asset.image("sotb/#{key}.png")

            acc |> Map.put(key, {path, Asset.hash(path)})
          end)
  @speed 6

  # --------------------------------------------------------
  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  # ----------------------------------------------------------------------------
  def init(_, opts, parent) do
    viewport_width = viewport_width(opts[:viewport]) * 2

    graph =
      Graph.build()
      |> Map.put(:__parent, parent)
      |> add_horizontal_scroller(
        %{
          path: @assets[:s05],
          size: {960, 18},
          speed: @speed * 0.2,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 265}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: @assets[:s04],
          size: {960, 27},
          speed: @speed * 0.3,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 244}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: @assets[:s03],
          size: {960, 57},
          speed: @speed * 0.5,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 190}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: @assets[:s02],
          size: {960, 120},
          speed: @speed * 0.75,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 62}
        }
      )
      |> add_horizontal_scroller(%{
        path: @assets[:s01],
        size: {960, 63},
        speed: @speed,
        direction: :left,
        viewport_width: viewport_width
      })
      |> add_horizontal_scroller(
        %{
          path: @assets[:s06],
          size: {960, 219},
          speed: @speed * 0.1,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 291}
        }
      )
      |> add_horizontal_scroller(%{
        path: @assets[:s07],
        size: {10200, 600},
        speed: @speed,
        direction: :left,
        viewport_width: viewport_width
      })
      |> add_horizontal_scroller(%{
        path: @assets[:s08],
        size: {13500, 600},
        speed: @speed * 2,
        direction: :left,
        viewport_width: viewport_width
      })
      |> add_horizontal_scroller(
        %{
          path: @assets[:s09],
          size: {960, 65},
          speed: @speed * 2.2,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 600 - 75}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: @assets[:s10],
          size: {960, 54},
          speed: @speed * 2.4,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 600 - 54}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: @assets[:s11],
          size: {960, 33},
          speed: @speed * 2.6,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 600 - 33}
        }
      )
      |> add_horizontal_scroller(
        %{
          path: @assets[:s12],
          size: {960, 66},
          speed: @speed * 3,
          direction: :left,
          viewport_width: viewport_width
        },
        %{
          translate: {0, 600 - 66}
        }
      )
      |> push_graph()

    {:ok, graph}
  end
end
