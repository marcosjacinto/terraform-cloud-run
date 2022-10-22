import logging

import uvicorn
from fastapi import FastAPI

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(filename)s::%(lineno)d::%(message)s",
    handlers=[
        logging.StreamHandler(),
    ],
)

logger = logging.getLogger(__name__)


app = FastAPI()


@app.get("/")
async def main():

    logger.info("Inside main ")

    return {"msg": "API is running"}

@app.get("/warning")
async def main():

    logger.warning("Something occurred")

    return {"msg": "warning"}


if __name__ == "__main__":
    uvicorn.run(
        app=app,
        host="0.0.0.0",
        port=8000,
    )
