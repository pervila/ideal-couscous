from __future__ import print_function

import boto3
from boto3.dynamodb.conditions import Key, Attr
import json

print('Loading function')
dynamo = boto3.resource('dynamodb').Table('taskListTable')

def list(event, context):
    '''Lists the elements from the dynamodb using scan
       If a description is given, list that task
       If a user is given, list only tasks owned by that user
    '''
    # TODO: input checks, match only strings, lengths okay
    if 'payload' in event:
        if 'description' in event['payload']:
            return dynamo.query(
                KeyConditionExpression=Key('description').eq(event['payload']['description'])
            )
        if 'user' in event['payload']:
           return dynamo.scan(
               FilterExpression=Attr('user').eq(event['payload']['user'])
           )
    else:   
        return dynamo.scan()


def add(event, context):
    '''Provide a task item that must contain the following keys:

       - description: min 1 char
       - priority: integers [0-9]

       The item may contain the following keys:

       - user: user's email, min 5, max 254 chars
       - completed: string representation of datetime
    '''
    
    item = event['payload']['Item']

    if 'description' in item:
        desc = item['description']
        if len(desc) == 0:
            raise ValueError('Description too short')
    else:
        raise ValueError('No description found in task')

    # TODO: check for floats
    if 'priority' in item:
        prio = int(item['priority'])
        if prio < 0 or prio > 9:
            raise ValueError('Priority {} not between [0-9]'.format(prio))
    else:
        raise ValueError('No priority found in task')

    # TODO: check the user email field, if it exists
    # TODO: check for acceptable date formats in completed

    return dynamo.put_item(**event['payload'])


def delete(event, context):
    # TODO: check for description and delete only it
    # TODO: optionally, delete all tasks for a given user
    return dynamo.delete_item(**event['payload'])
