defmodule MyApp.Component.HorizontalScroller do
  use Scenic.Component
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:group, 3}, {:update_opts, 2}]
  import MyApp.Component.Helpers

  @default %{
    direction: :right
  }

  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  def init({:ok, data}, opts \\ []) do
    hash = hash()
    {width, _} = data[:size]

    graph =
      Graph.build()
      |> group(
        fn g ->
          g
          |> group(
            fn g ->
              g
              |> add_sprite(data, translate: {-width, 0})
              |> add_sprite(data, translate: {0, 0})
              |> add_sprite(data, translate: {width, 0})
            end,
            translate: {0, 0},
            id: hash
          )
        end,
        opts
      )
      |> push_graph()

    :timer.send_interval(8, :animate)

    state =
      @default
      |> Map.merge(data)
      |> Map.merge(%{
        hash: hash,
        graph: graph,
        width: width,
        x: 0
      })

    {:ok, state}
  end

  def handle_info(:animate, %{x: x, width: width, direction: :right} = state)
      when x >= width do
    {:noreply, state |> reset_position()}
  end

  def handle_info(:animate, %{x: x, width: width} = state)
      when x <= -width do
    {:noreply, state |> reset_position()}
  end

  def handle_info(:animate, %{graph: graph, hash: hash} = state) do
    new_x = state |> update_position

    graph =
      graph
      |> Graph.modify(
        hash,
        &update_opts(&1,
          translate: {trunc(new_x), 0}
        )
      )
      |> push_graph()

    {:noreply, %{state | graph: graph, x: new_x}}
  end

  defp reset_position(%{graph: graph, hash: hash} = state) do
    graph =
      graph
      |> Graph.modify(
        hash,
        &update_opts(&1,
          translate: {0, 0}
        )
      )
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
