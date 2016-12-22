#!/bin/bash

aws apigateway create-rest-api --name TaskList
aws apigateway create-resource --rest-api-id npfisvw5ya --parent-id op2z99xtod --path-part TaskListManager


for func in GET POST PUT DELETE; do 
  aws apigateway put-method \
    --rest-api-id npfisvw5ya --resource-id ab4qgt \
    --http-method $func --authorization-type NONE

  aws apigateway put-integration \
    --rest-api-id npfisvw5ya --resource-id ab4qgt \
    --http-method $func --type AWS --integration-http-method $func \
    --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:312445988018:function:TaskList${func}/invocations

  aws apigateway put-method-response \
    --rest-api-id npfisvw5ya --resource-id ab4qgt \
    --http-method $func --status-code 200 --response-models '{"application/json": "Empty"}'

  aws apigateway put-integration-response \
    --rest-api-id npfisvw5ya --resource-id ab4qgt \
    --http-method $func --status-code 200 --response-templates '{"application/json": ""}'
done


aws apigateway create-deployment --rest-api-id npfisvw5ya --stage-name prod


for func in GET POST PUT DELETE; do
  aws lambda add-permission \
    --function-name TaskList${func} \
    --statement-id apigateway-test-2 \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:eu-west-1:312445988018:npfisvw5ya/*/${func}/TaskListManager"

  aws lambda add-permission \
    --function-name TaskList${func} \
    --statement-id apigateway-prod-2 \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:eu-west-1:312445988018:npfisvw5ya/prod/${func}/TaskListManager"
done
