import uvicorn
from fastapi import FastAPI

from api import logger


app = FastAPI()


@app.get("/")
async def main():

    logger.info("Inside main ")

    return {"msg": "API is running"}

@app.get("/warning")
async def warning():

    logger.warning("Something occurred")

    return {"msg": "warning"}


if __name__ == "__main__":
    uvicorn.run(
        app=app,
        host="0.0.0.0",
        port=8000,
    )
