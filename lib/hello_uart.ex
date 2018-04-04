defmodule HelloUart do
  @moduledoc """
  Documentation for HelloUart.
  """

  require Logger

  def uart_ini do
    uart_opts = [speed: 9600, active: false, framing: {Nerves.UART.Framing.Line, separator: "\n"}]
    pids =
      Nerves.UART.enumerate() |> Enum.reduce(%{}, fn {k, _v}, _acc ->
        Logger.info "Open #{k}"
        {:ok, uart} = Nerves.UART.start_link()
        Logger.info "#{inspect uart}"
        _open = Nerves.UART.open(uart, k, uart_opts)
        Nerves.UART.write(uart, "HOLaS")
        [k, uart]
      end)
    uart_loop(pids)
  end

  def uart_loop(pids) do
    [nom, uart] = pids
    response = Nerves.UART.read(uart,3000)
    case response do
      {:ok, ""} ->
        Logger.info("nada")
        uart_loop(pids)
      {:ok, msn} ->
        Logger.info("me llego #{msn} de #{nom}" )
        #Nerves.UART.write(uart,"Hola")
        uart_loop(pids)
      {:error, _error} -> false
    end
  end
end
