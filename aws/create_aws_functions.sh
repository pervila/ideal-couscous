#!/bin/bash

zip TaskList.zip TaskList.py

# list
aws lambda create-function --function-name TaskListGET --zip-file fileb://TaskList.zip --role arn:aws:iam::312445988018:role/taskListQuery --handler TaskList.list --runtime python2.7

# update
aws lambda create-function --function-name TaskListPUT --zip-file fileb://TaskList.zip --role arn:aws:iam::312445988018:role/taskListPut --handler TaskList.add --runtime python2.7

# add (same as update)
aws lambda create-function --function-name TaskListPOST --zip-file fileb://TaskList.zip --role arn:aws:iam::312445988018:role/taskListUpdate --handler TaskList.add --runtime python2.7

# delete 
aws lambda create-function --function-name TaskListDELETE --zip-file fileb://TaskList.zip --role arn:aws:iam::312445988018:role/taskListDelete --handler TaskList.delete --runtime python2.7

