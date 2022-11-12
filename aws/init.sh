# https://docs.localstack.cloud/integrations/aws-cli/#localstack-aws-cli-awslocal

# Setup SQS
awslocal sqs create-queue \
--queue-name "sqs-demo.fifo" \
--attributes '{"FifoQueue":"true", "ContentBasedDeduplication":"true"}'

awslocal sqs create-queue \
--queue-name "sqs-demo-dlq.fifo" \
--attributes '{"FifoQueue":"true", "ContentBasedDeduplication":"true"}'

# Setup EventBridge
awslocal events create-event-bus \
--name "eventbridge-demo"

awslocal events put-rule \
--name "rule-demo" \
--event-bus-name "eventbridge-demo" \
--event-pattern '{ "detail": { "event": { "data": {} } } }'

awslocal events put-targets \
--rule "rule-demo" \
--event-bus-name "eventbridge-demo" \
--targets "Id"="target-demo","Arn"="arn:aws:sqs:us-east-1:000000000000:sqs-demo.fifo","SqsParameters"={"MessageGroupId"="default-group-demo"},"DeadLetterConfig"={"Arn"="arn:aws:sqs:us-east-1:000000000000:sqs-demo-dlq.fifo"}

# Put demo event
awslocal events put-events \
--entries '[{"DetailType": "test", "Source": "aws.test", "Detail": "{ \"event\": {\"data\": \"demo\" } }", "EventBusName": "eventbridge-demo"}]'
