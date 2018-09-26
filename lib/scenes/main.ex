defmodule MyApp.Scene.Main do
  @moduledoc """
  Sample splash scene.

  This scene demonstrate a very simple animation and transition to another scene.

  It also shows how to load a static texture and paint it into a rectangle.
  """

  use Scenic.Scene
  alias Scenic.Graph
  alias MyApp.Component.{ParallaxBackground, StaticBackground}

  import Scenic.Primitives, only: [{:text, 3}, {:update_opts, 2}]

  @graph Graph.build(font: :roboto, font_size: 32)

  # --------------------------------------------------------
  def init(_first_scene, _opts) do
    graph =
      @graph
      |> StaticBackground.add_to_graph()
      |> ParallaxBackground.add_to_graph()
      |> text("", translate: {40, 40}, fill: :yellow, id: :fps)
      |> push_graph

    :timer.send_interval(8, :fps)

    {:ok, %{graph: graph, frames: 0, start: Time.utc_now()}}
  end

  def handle_info(:fps, %{graph: graph, frames: frames, start: start} = state) do
    frames = frames + 1
    diff = Time.diff(Time.utc_now(), start, :millisecond)
    fps = frames / diff * 1_000
    s = ~s(frames: #{frames} Time: #{diff}ms FPS: #{fps |> Float.round(2)})

    graph =
      graph
      |> Graph.delete(:fps)
      |> text(s, translate: {20, 25}, fill: :red, id: :fps)
      |> push_graph()

    {:noreply, %{state | graph: graph, frames: frames}}
  end
end
