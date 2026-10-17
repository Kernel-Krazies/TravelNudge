from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
	title="TravelNudge API",
	description="Backend API for the TravelNudge travel planner",
	version="1.0.0",
)

# Allow the frontend to communicate with the backend

app.add_middleware(
	CORSMiddleware,
	allow_origins=[
		"http://localhost:5173",
		"http://127.0.0.1:5173",
	],
	allow_credentials=True,
	allow_methods=["*"],
	allow_headers=["*"],
)

@app.get("/")
def home():
	return {
		"message": "Welcome to TravelNudge!",
		"status": "running",
	}

@app.get("/health")
def health_check():
	return {"status": "healthy"}
