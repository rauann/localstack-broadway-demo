defmodule Producer do
  @moduledoc """
  Producer Demo
  """
  @doc """
  Send message to SQS
  """
  def send_message(message) do
    config = [
      scheme: "http://",
      host: "localhost",
      port: 4566,
      access_key_id: "",
      secret_access_key: ""
    ]

    queue_url = "http://localhost:4566/000000000000/sqs-demo.fifo"
    message = Poison.encode!(%{"message" => message})

    queue_url
    |> ExAws.SQS.send_message(message, message_group_id: "foobar")
    |> ExAws.request!(config)
  end

  @doc """
  Send events to EventBridge
  """
  def send_event(event, amount \\ 1..10) do
    Enum.each(amount, fn index ->
      AWS.EventBridge.put_events(build_client(), %{
        "Entries" => [
          %{
            "Detail" =>
              Poison.encode!(%{
                "event" => %{"index" => index, "data" => event}
              }),
            "DetailType" => "demo",
            "Source" => "demo",
            "EventBusName" => "eventbridge-demo"
          }
        ]
      })
    end)
  end

  defp build_client do
    ""
    |> AWS.Client.create("", "us-east-1")
    |> then(&%{&1 | proto: "http", port: 4566, endpoint: "localhost"})
  end
end
