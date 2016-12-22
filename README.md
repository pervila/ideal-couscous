# Basic task list application

Uses AWS Lambda serverless architecture.

So far, some manual labour is required to design the policies and roles defined
in aws/IAM_Role_Policies.txt. Use these names for the roles:

  * taskListPut
  * taskListQuery
  * taskListDelete
  * taskListUpdate

The methods defined in TaskList.py get registered as separate lambda functions
by aws/lambda_functions_create.sh. They use the roles above so that

  * taskListPut => TaskListPOST
  * taskListQuery => TaskListGET
  * taskListDelete => TaskListDELETE
  * taskListUpdate => TaskListPUT

After this, we create an API gateway in aws/API_gateway_create.sh. This script
should be replaced with a CloudFormations template ASAP, but no time thus far.

Then we register the lambda functions to the API gateway using different HTTP methdods:

  * POST => TaskListPOST
  * GET => TaskListGET
  * DELETE => TaskListDELETE
  * PUT => TasListPUT

Different HTTP methods now have different IAM roles. After correct perms have
been assigned by the same script, one can test the application using either
curl, AWS CLI, or the API Gateway testing functions.

# TODO

Any input checking of the HTTP parameters is woefully inadequate at this point.

GET parameters are not correctly mapped to the TaskListGET lambda. There's a
tutorial for the mappings, but it seems outdated(?).

The daily lambda has not been implemented yet.
