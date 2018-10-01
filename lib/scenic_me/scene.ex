defmodule ScenicME.Scene do
  defmacro __using__(_opts) do
    quote do
      use Scenic.Scene

      def init(args, opts) do
        {:ok, timer} = :timer.send_interval(trunc(1_000 / 60), :animation_frame)
        {:ok, state} = __MODULE__.init({args, opts})

        state =
          state
          |> Map.merge(%{
            __state: %{
              start: Time.utc_now(),
              last: Time.utc_now(),
              frame: 0,
              diff: 0,
              elapsed_time: 0
            },
            children: [],
            timer: timer
          })

        {:ok, state}
      end

      def filter_event(:component_created, pid, state) do
        send(self(), {:component_created, pid})
        {:stop, state}
      end

      def filter_event({:fps, fps}, _pid, %{timer: timer} = state) do
        :timer.cancel(timer)
        {:ok, timer} = :timer.send_interval(trunc(1_000 / fps), :animation_frame)

        {:stop, %{state | timer: timer}}
      end

      def handle_info({:component_created, pid}, %{children: children} = state) do
        {:noreply, %{state | children: [pid | children]}}
      end

      def handle_info(:animation_frame, %{children: []} = state) do
        {:noreply, state |> update_state}
      end

      def handle_info(:animation_frame, %{children: children, __state: state__} = state) do
        children
        |> Enum.each(&send(&1, {:animation_frame, state__}))

        {:noreply, state |> update_state}
      end

      def handle_info(:animation_frame, state), do: {:noreply, state}

      defp update_state(%{__state: %{start: start, last: last}} = state) when start == last do
        state
        |> update_state(Time.diff(Time.utc_now(), start, :millisecond))
      end

      defp update_state(%{__state: %{start: start, last: last}} = state) do
        state
        |> update_state(Time.diff(Time.utc_now(), last, :millisecond))
      end

      defp update_state(%{__state: %{frame: frame, start: start}} = state, diff) do
        %{
          state
          | __state: %{
              frame: frame + 1,
              last: Time.utc_now(),
              diff: diff,
              start: start,
              elapsed_time: Time.diff(Time.utc_now(), start, :millisecond)
            }
        }
      end
    end
  end
end
