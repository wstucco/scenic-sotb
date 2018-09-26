defmodule MyApp.Component.Background do
  use Scenic.Component
  alias Scenic.ViewPort
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:rect, 3}, {:update_opts, 2}, {:group, 3}]

  @clouds_path :code.priv_dir(:my_app)
               |> Path.join("/static/images/clouds.png")
  @clouds_hash Scenic.Cache.Hash.file!( @clouds_path, :sha )

  @sprite_width 384
  @sprite_height 256

  @animate_ms div(1_000, 60)
  @animatin_speed 4

  # --------------------------------------------------------
  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  # ----------------------------------------------------------------------------
  def init(_current_scene, opts) do
    Scenic.Cache.File.load(@clouds_path, @clouds_hash)

    # Get the viewport width
    {:ok, %ViewPort.Status{size: {width, height}}} =
      opts[:viewport]
      |> ViewPort.info()

    scale_h = height / @sprite_height
    scale_w = width / @sprite_width
    scale = max(scale_w, scale_h)

    graph =
      Graph.build()
      |> group(
        fn g ->
          g
          |> rect({@sprite_width, @sprite_height}, fill: {95, 167, 249})
      #     |> rect(
      #       {@clouds_width, @clouds_height},
      #       id: :clouds_0,
      #       fill: {:image, @clouds_hash},
      #       translate: {0, 0}
      #     )
      #     |> rect(
      #       {@clouds_width, @clouds_height},
      #       id: :clouds_1,
      #       fill: {:image, @clouds_hash},
      #       translate: {@clouds_width, 0}
      #     )
        end,
        id: :background,
        scale: scale,
        translate: {0, 0}
      )

      # Graph.modify(@graph, :clouds, &update_opts(&1,
      #   scale: 2,
      #   translate: {0, 0}
      # ))
      |> push_graph()

    {:ok, timer} = :timer.send_interval(@animate_ms, :animate)

    state = %{
      graph: graph,
      viewport: opts[:viewport],
      timer: timer,
      position: {0, 0},
      size: {width, height}
    }

    {:ok, state}
  end

  def handle_info(:animate, %{position: {x, y}, graph: graph, size: {width, _}} = state)
    when abs(x) == width do

    position = {0, y}
    graph =
      graph
      |> Graph.modify(:background, &update_opts(&1,
        translate: position
      ))
      |> push_graph()

    {:noreply, %{state | graph: graph, position: position}}
  end


  def handle_info(:animate, %{position: {x, y}, graph: graph} = state) do
    position = {x - @animatin_speed, y}
    graph =
      graph
      |> Graph.modify(:background, &update_opts(&1,
        translate: position
      ))
      |> push_graph()

    {:noreply, %{state | graph: graph, position: position}}
  end

end
