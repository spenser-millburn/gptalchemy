# Project Overview

This project is designed to implement a system with multiple subsystems, each represented as a FastAPI application. The main orchestrator will call these subsystems via API.

## Subsystems

The project consists of the following subsystems:
- Subsystem 1: Description of subsystem 1
- Subsystem 2: Description of subsystem 2
- Subsystem 3: Description of subsystem 3

Each subsystem is a FastAPI app located at `http://localhost:8000/{subsystem_name}`, and each subsystem has an endpoint at the root (`/`).

## Main Orchestrator

The main orchestrator is a FastAPI application that has an endpoint for each subsystem. It makes a request to the respective subsystem's API and returns its response.

## Project Structure

The project structure is as follows:
```
project_folder/
    ├── subsystem_1/
    ├── subsystem_2/
    ├── subsystem_3/
    └── main_orchestrator.py
```

## How to Run

1. Navigate to the project folder:
   ```
   cd project_folder
   ```

2. Start each subsystem FastAPI app:
   ```
   uvicorn subsystem_1.main:app --reload --port 8001
   uvicorn subsystem_2.main:app --reload --port 8002
   uvicorn subsystem_3.main:app --reload --port 8003
   ```

3. Start the main orchestrator:
   ```
   uvicorn main_orchestrator:app --reload --port 8000
   ```

4. Access the orchestrator at `http://localhost:8000`.

## Requirements

- Python 3.8+
- FastAPI
- Uvicorn

## Installation

Install the required packages using pip:
```
pip install fastapi uvicorn
```

## Testing

Unit tests are written using pytest. To run the tests, use the following command:
```
pytest
```

## Dockerization

The project can be dockerized for easier deployment. Ensure you have Docker installed and follow the instructions in the Dockerfile to build and run the Docker containers.

## Author

This project was generated using ShellGPT, a command-line tool for automating project setup and management.
