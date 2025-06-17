from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum

app = FastAPI()

origins = [
    "https://d3f4nrxvf43e8.cloudfront.net",
    # Add your local development origin as well
    "http://localhost:8080", # Or whatever port your Vue dev server runs on
    "http://localhost:8000" # If your frontend sometimes runs on 8000 and connects to backend on 8000
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"], # Allows all methods (GET, POST, etc.)
    allow_headers=["*"], # Allows all headers
)

@app.get("/chat")
async def chat(q: str):
    # Your chat logic
    return {"response": f"You said: {q}"}

@app.get("/calculate")
async def calculate(a: int, b: int):
    # Your calculation logic
    return {"result": a + b}