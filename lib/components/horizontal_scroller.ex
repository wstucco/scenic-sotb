defmodule Sotb.Component.HorizontalScroller do
  use ScenicME.Component
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:group, 3}, {:update_opts, 2}]
  import Sotb.Component.Helpers

  @default %{
    direction: :right
  }

  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  def init({:ok, %{size: {width, _}} = data}, opts, _parent) do
    viewport_width = data[:viewport_width] || viewport_width(opts[:viewport])
    hash = hash()

    graph =
      Graph.build()
      |> group(
        fn g ->
          g
          |> group(
            &add_sprites(&1, data, viewport_width),
            translate: {0, 0},
            id: hash
          )
        end,
        opts
      )
      |> push_graph()

    state =
      @default
      |> Map.merge(data)
      |> Map.merge(%{
        hash: hash,
        graph: graph,
        width: width,
        x: 0,
        speed: data[:speed] || 1
      })

    {:ok, state}
  end

  def animation_frame(_sc_state, %{x: x, width: width, direction: :right} = state)
      when x >= width do
    {:noreply, state |> reset_position()}
  end

  def animation_frame(_sc_state, %{x: x, width: width} = state)
      when x <= -width do
    {:noreply, state |> reset_position()}
  end

  def animation_frame(_sc_state, %{graph: graph, hash: hash} = state) do
    new_x = state |> update_position

    graph =
      graph
      |> Graph.modify(hash, &update_opts(&1, translate: {trunc(new_x), 0}))
      |> push_graph()

    {:noreply, %{state | graph: graph, x: new_x}}
  end

  defp add_sprites(graph, %{size: {width, _}} = data, viewport_width) do
    parts = (viewport_width / width) |> Float.ceil() |> trunc

    -parts..parts
    |> Enum.reduce(graph, fn multiplier, g ->
      g |> add_sprite(data, translate: {width * multiplier, 0})
    end)
  end

  defp reset_position(%{graph: graph, hash: hash} = state) do
    graph =
      graph
      |> Graph.modify(hash, &update_opts(&1, translate: {0, 0}))
      |> push_graph()

    %{state | graph: graph, x: 0}
  end

  defp hash do
    abs(System.monotonic_time(:microsecond)) |> to_string |> String.to_atom()
  end

  defp update_position(%{direction: :right, x: x, speed: speed}) do
    x + speed
  end

  defp update_position(%{direction: :left, x: x, speed: speed}) do
    x - speed
  end
end
