# Project Overview

This repository contains a powerful set of GPT wrappers designed to streamline various development tasks. The goal of this project to minimize developer contact with code and leverage the power of GPTs to manipulate the codebase with prompts.

## Features

- **gptcreate**: Creates a new project based on a user-supplied prompt, generating the necessary files and folder structure.
- **gptmodify**: Modifies existing project files based on a user-supplied prompt.
- **gptask**: Executes a GPT prompt based on the current project context.
- **gpttest**: Generates unit tests for the project using pytest.
- **gptsuggest**: Provides suggestions for changes to achieve a specific goal.
- **gptguard**: Validates user input by asking GPT to respond with a simple "true" or "false".

## Advanced features
- **gptrefactor**: Analyzes the current project files and generates a refactor plan, including creating, moving, deleting, and modifying files.
- **gptarchitect**: Generates a list of subsystems based on a system description and implements each subsystem as a FastAPI app.
- **gptarchitect_recursive**: Generates a detailed tree of subsystems and implements each as a FastAPI app.

## Project Structure

```
project_folder/
    ├── gptarchitect.fish
    ├── gptask.fish
    ├── gptguard.fish
    ├── gptrefactor.fish
    ├── gptmodify.fish
    ├── gptcreate.fish
    ├── gptsuggest.fish
    ├── gptarchitect_recursive.fish
    ├── gpttest.fish
    └── README.md
```

## How to Use

1. **gptarchitect**:
   - Generates and implements subsystems as FastAPI apps.
   - Usage: `gptarchitect "System description"`

2. **gptask**:
   - Executes a GPT prompt based on the current project context.
   - Usage: `gptask "Your prompt"`

3. **gptguard**:
   - Validates user input by asking GPT to respond with "true" or "false".
   - Usage: `gptguard "Your validation prompt"`

4. **gptrefactor**:
   - Analyzes and refactors the current project files.
   - Usage: `gptrefactor "Refactor prompt"`

5. **gptmodify**:
   - Modifies existing project files based on a user-supplied prompt.
   - Usage: `gptmodify "Modification prompt"`

6. **gptcreate**:
   - Creates a new project based on a user-supplied prompt.
   - Usage: `gptcreate "Project description"`

7. **gptsuggest**:
   - Provides suggestions for changes to achieve a specific goal.
   - Usage: `gptsuggest "Goal description"`

8. **gptarchitect_recursive**:
   - Generates a detailed tree of subsystems and implements each as a FastAPI app.
   - Usage: `gptarchitect_recursive "System description"`

9. **gpttest**:
   - Generates unit tests for the project using pytest.
   - Usage: `gpttest "Test requirements"`

## Requirements

- Python 3.8+
- FastAPI
- Uvicorn
- jq (for JSON processing)
- fish shell

## Installation
### OPENAI API key setup
OPENAI_API_KEY is set with your openai api key. You might consider putting this in your ~/.config/fish/config.fish
```
set -x OPENAI_API_KEY your_api_key
```
### install dependencies
```
pip install fastapi uvicorn shell-gpt
```

### move all functions repository to .config/fish/functions
```
#run this from the root of the gptalchemy repo
mkdir -p ~/.config/fish/functions
find . -type f -name '*.fish' -exec mv {} ~/.config/fish/functions/
```
## Testing

Unit tests are written using pytest. To run the tests, use the following command:
```
pytest
```

## Author

This project was generated using ShellGPT, a command-line tool for automating project setup and management.
