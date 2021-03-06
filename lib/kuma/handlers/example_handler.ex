defmodule Kuma.ExampleHandler do
  use Kuma.Handler

  def handle_info({:names_list, channel, names_list}, conn) do
    names =
      names_list
      |> String.split(" ", trim: true)
      |> Enum.map(fn name -> " #{name}\n" end)
    Logger.info "Users logged in to #{channel}:\n#{names}"
    {:noreply, conn}
  end

  def handle_info({:received, _msg, %SenderInfo{nick: nick}, channel}, conn) do
    Bot.send "That's interesting, #{nick}.", channel
    {:noreply, conn}
  end

  def handle_info({:mentioned, msg, %SenderInfo{nick: nick}, channel}, conn) do
    if String.contains?(msg, "hi") do
      Bot.reply "Hi!", channel, nick
    end
    {:noreply, conn}
  end

  def handle_info({:received, _msg, %SenderInfo{nick: nick}}, conn) do
    Bot.message "Hi!", nick
    {:noreply, conn}
  end

  # Catch-all for messages you don't care about
  def handle_info(_msg, conn) do
    {:noreply, conn}
  end
end
