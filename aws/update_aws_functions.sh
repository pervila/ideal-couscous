#!/bin/bash
zip TaskList.zip TaskList.py
aws lambda update-function-code --function-name TaskListGET --zip-file fileb://TaskList.zip
aws lambda update-function-code --function-name TaskListPOST --zip-file fileb://TaskList.zip
aws lambda update-function-code --function-name TaskListDELETE --zip-file fileb://TaskList.zip
aws lambda update-function-code --function-name TaskListPUT --zip-file fileb://TaskList.zip
