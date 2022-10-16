defmodule Consumer do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwaySQS.Producer,
          queue_url: "http://localhost:4566/000000000000/sqs-demo",
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
        default: []
      ]
      # batchers: [
      #   default: []
      # ]
    )
  end

  @impl true
  def handle_message(_processor, %Message{data: data} = message, _context) do
    IO.inspect(data, label: "Message")

    message
  end

  @impl true
  def handle_batch(_batcher, messages, _batch_info, _context) do
    # Send batch of successful messages as ACKs to SQS
    # This tells SQS that this list of messages were successfully processed
    # If there are no batchers, the acknowledgement will be done by processors (on handle_message)
    messages
  end
end
