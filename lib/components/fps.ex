defmodule SOTB.Component.FPS do
  use SOTB.Component

  alias Scenic.Graph
  import Scenic.Primitives, only: [{:text, 3}]

  @opts [translate: {20, 50}, fill: :red]

  # --------------------------------------------------------
  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  # ----------------------------------------------------------------------------
  def init(_data, _opts, _parent) do
    graph =
      Graph.build(font: :roboto, font_size: 48)
      |> text("", id: :fps)
      |> push_graph()

    {:ok, %{graph: graph}}
  end

  def animation_frame(%{elapsed_time: 0}, %{graph: graph}) do
    s = ~s(Frames: 0 Time: 0s FPS: 0)

    graph =
      graph
      |> Graph.modify(:fps, &text(&1, s, @opts))
      |> push_graph()

    {:noreply, %{graph: graph}}
  end

  def animation_frame(%{frame: frame, elapsed_time: time, diff: diff}, %{graph: graph}) do
    global_fps = frame / time * 1_000

    current_fps =
      1_000 /
        if diff == 0 do
          1
        else
          diff
        end

    time =
      (time / 1_000)
      |> Number.Delimit.number_to_delimited(precision: 2)

    global_fps =
      global_fps
      |> Number.Delimit.number_to_delimited(precision: 2)

    current_fps =
      current_fps
      |> Number.Delimit.number_to_delimited(precision: 2)

    frame =
      frame
      |> Number.Delimit.number_to_delimited(precision: 0)

    s = """
    Frames: #{frame}
    Time: #{time}s
    Current FPS: #{current_fps}
    Global FPS: #{global_fps}
    """

    graph =
      graph
      |> Graph.modify(:fps, &text(&1, s, @opts))
      |> push_graph()

    {:noreply, %{graph: graph}}
  end
end
