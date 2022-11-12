defmodule Consumer do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        # concurrency: 1,
        concurrency: 10,
        module: {
          BroadwaySQS.Producer,
          queue_url: "http://localhost:4566/000000000000/sqs-demo.fifo",
          config: [
            scheme: "http://",
            host: "localhost",
            port: 4566,
            access_key_id: "",
            secret_access_key: ""
          ]
        }
      ],
      processors: [
        # default: [concurrency: 1]
        default: [concurrency: 16]
      ],
      partition_by: &partition/1
    )
  end

  @impl true
  def prepare_messages(messages, _context) do
    Enum.map(messages, &parse_message_data/1)
  end

  @impl true
  def handle_message(_processor, %Message{data: data} = message, _context) do
    IO.inspect(data.detail, label: "Consumer message data")

    message
  end

  def partition(message) do
    parsed_message = parse_message_data(message)

    :erlang.phash2(parsed_message.data.detail.event.data)
  end

  defp parse_message_data(message) do
    data = Poison.decode!(message.data, %{keys: :atoms})
    Message.put_data(message, data)
  end
end
