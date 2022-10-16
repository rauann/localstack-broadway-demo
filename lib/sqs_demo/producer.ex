defmodule Producer do
  def send_message(message) do
    config = [
      scheme: "http://",
      host: "localhost",
      port: 4566,
      access_key_id: "",
      secret_access_key: ""
    ]

    queue_url = "http://localhost:4566/000000000000/sqs-demo"
    message = Poison.encode!(%{"message" => message})

    queue_url
    |> ExAws.SQS.send_message(message)
    |> ExAws.request!(config)
  end
end
