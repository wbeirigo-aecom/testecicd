from typing import Union
import os
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

@app.get("/config")
async def get_config():
    api_key = os.getenv("MY_MESSAGE", "default_api_key") # "default_api_key" is a fallback if API_KEY is not set
    return {"my_message": api_key}