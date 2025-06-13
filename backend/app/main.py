from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI on Lambda!"}

@app.get("/chat")
def chat(q: str):
    return {"response": f"Echo: {q}"}

# Lambda-compatible handler
handler = Mangum(app)
