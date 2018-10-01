defmodule Sotb.Component.Airships do
  use ScenicME.Component

  alias Scenic.Graph
  alias ScenicME.Asset

  import Scenic.Primitives, only: [{:update_opts, 2}]
  import Sotb.Component.Helpers

  @large_start -192
  @large_max 768 * 4

  @small_start 768 * 6
  @small_min -96

  # --------------------------------------------------------
  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  # ----------------------------------------------------------------------------
  def init(_data, _opts, _parent) do
    graph =
      Graph.build()
      |> add_sprite(
        %{
          path: Asset.image("sotb/airship-large.png"),
          size: {192, 81}
        },
        id: :airship_large,
        translate: {@large_start, 65}
      )
      |> add_sprite(
        %{
          path: Asset.image("sotb/airship-small.png"),
          size: {96, 39}
        },
        id: :airship_small,
        translate: {@small_start, 160}
      )
      |> push_graph()

    {:ok, %{graph: graph}}
  end

  def animation_frame(_scene_state, %{graph: graph} = state) do
    graph =
      graph
      |> animate_large_airship()
      |> animate_small_airship()

    {:noreply, %{state | graph: graph}}
  end

  def animation_frame(_scene_state, state), do: {:noreply, state}

  defp animate_large_airship(graph) do
    airship =
      graph
      |> Graph.get!(:airship_large)

    {x, y} =
      airship
      |> Scenic.Primitive.get_transform(:translate)

    new_x =
      if x >= @large_max do
        @large_start
      else
        x + 3
      end

    # IO.inspect({:large, {x, y}, {new_x, y}})

    graph
    |> Graph.modify(
      :airship_large,
      &update_opts(&1, translate: {new_x, y})
    )
    |> push_graph()
  end

  defp animate_small_airship(graph) do
    airship =
      graph
      |> Graph.get!(:airship_small)

    {x, y} =
      airship
      |> Scenic.Primitive.get_transform(:translate)

    new_x =
      if x <= @small_min do
        @small_start
      else
        x - 2
      end

    graph
    |> Graph.modify(
      :airship_small,
      &update_opts(&1, translate: {new_x, y})
    )
    |> push_graph()
  end
end
