import os
from fal.typing import *
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

print("Trying to send a slack message")

CHANNEL_ID = os.getenv("SLACK_BOT_CHANNEL")
SLACK_TOKEN = os.getenv("SLACK_BOT_TOKEN")

model = context.current_model
assert model

client = WebClient(token=SLACK_TOKEN)
message_text = f"This ran after dbt cloud. Model: {model.name}. Status: {model.status}."

if model.status == 'error':
    message_text += f" Pinging <{model.meta.get('owner')}>."

try:
    response = client.chat_postMessage(
        channel=CHANNEL_ID,
        text=message_text
    )
except SlackApiError as e:
    # You will get a SlackApiError if "ok" is False
    assert e.response["error"]

print("Success!")
