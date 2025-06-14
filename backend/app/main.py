from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins (for development only)
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Your existing endpoints...
@app.get("/")
def read_root():
    return {"message": "Hello from FastAPI!"}

@app.get("/chat")
def chat(q: str):
    return {"response": f"Echo: {q}"}

@app.get("/calculate")
def calculate(a: int, b: int):
    return {"result": a + b}