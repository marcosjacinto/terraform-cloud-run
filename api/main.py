import uvicorn
from fastapi import FastAPI


app = FastAPI()

@app.get("/")
async def main():

    return {"msg": "API is running"}

if __name__ == "__main__":
    uvicorn.run(
        app = app,
        host = '0.0.0.0',
        port = 8000,
    )