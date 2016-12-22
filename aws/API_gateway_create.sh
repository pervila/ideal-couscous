#!/bin/bash

acc_id=312445988018
api_id=zxax1i0knb
res_id=etev6x

aws apigateway create-rest-api \
    --name TaskList

aws apigateway create-resource \
    --rest-api-id ${api_id} \
    --parent-id op2z99xtod \
    --path-part TaskListManager

for func in GET POST PUT DELETE; do 
  aws apigateway put-method \
    --rest-api-id ${api_id} \
    --resource-id ${res_id} \
    --http-method $func \
    --authorization-type NONE

  aws apigateway put-integration \
    --rest-api-id ${api_id} \
    --resource-id ${res_id} \
    --http-method $func \
    --type AWS \
    --integration-http-method $func \
    --uri arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:${acc_id}:function:TaskList${func}/invocations

  aws apigateway put-method-response \
    --rest-api-id ${api_id} \
    --resource-id ${res_id} \
    --http-method $func \
    --status-code 200 \
    --response-models '{"application/json": "Empty"}'

  aws apigateway put-integration-response \
    --rest-api-id ${api_id} \
    --resource-id ${res_id} \
    --http-method $func \
    --status-code 200 \
    --response-templates '{"application/json": ""}'
done


aws apigateway create-deployment \
    --rest-api-id ${api_id} \
    --stage-name prod


for func in GET POST PUT DELETE; do
  aws lambda add-permission \
    --function-name TaskList${func} \
    --statement-id apigateway-test-${func} \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:eu-west-1:${acc_id}:${api_id}/*/${func}/TaskListManager"

  aws lambda add-permission \
    --function-name TaskList${func} \
    --statement-id apigateway-prod-${func} \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:eu-west-1:${acc_id}:${api_id}/prod/${func}/TaskListManager"
done
