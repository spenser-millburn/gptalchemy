# Project Overview

A powerful set of GPT/LLM based wrappers designed to catalyze and automate software development and iteration. The goal of this project to minimize developer contact with code and leverage the power of GPTs to manipulate the codebase with prompts.


## Features

- **gptcreate**: Creates a new project based on a user-supplied prompt, generating the necessary files and folder structure.
- **gptmodify**: Modifies existing project files based on a user-supplied prompt.
- **gptrefactor**: Analyzes the current project files and generates a refactor plan, including creating, moving, deleting, and modifying files.
- **gptask**: Executes a GPT prompt based on the current project context.
- **gpttest**: Generates unit tests for the project using pytest.
- **gptsuggest**: Provides suggestions for changes to achieve a specific goal.
- **gptguard**: Validates user input by asking GPT to respond with a simple "true" or "false".

## Advanced features [ Experimental / Beta ] 
- **gptiterate**: Iterate on the current repository by running it and addressing problems in the output
- **gptarchitect**: Generates a list of subsystems based on a system description and implements each subsystem as a FastAPI app.
- **gptarchitect_recursive**: Generates a detailed tree of subsystems and implements each as a FastAPI app.

## Quick Start
```
docker compose run -it cli fish -c "gptcreate a minimal application for converting units"
```
The built project will be located in the ./workspace directory. 

## Project Structure

```bash
project_folder/
    ├── gptcreate.fish
    ├── gptmodify.fish
    ├── gptrefactor.fish
    ├── gptask.fish
    ├── gptsuggest.fish
    ├── gpttest.fish
    ├── gptguard.fish
    ├── gptiterate.fish
    ├── gptarchitect.fish
    ├── gptarchitect_recursive.fish
    └── README.md
```
## How to Use

1. **gptcreate**:
   - Creates a new project based on a user-supplied prompt.
   - Usage: `gptcreate "Project description"`

2. **gptmodify**:
   - Modifies existing project files based on a user-supplied prompt.
   - Usage: `gptmodify "Modification prompt"`

3. **gptrefactor**:
   - Analyzes and refactors the current project files.
   - Usage: `gptrefactor "Refactor prompt"`

4. **gptask**:
   - Ask gpt about anything in the current directory or its children.
   - Usage: `gptask "Your prompt"`

5. **gptsuggest**:
   - Provides suggestions for changes to achieve a specific goal.
   - Usage: `gptsuggest "Goal description"`

6. **gpttest**:
   - Generates unit tests for the project using pytest.
   - Usage: `gpttest "Test requirements"`

7. **gptguard**:
   - Validates user input by asking GPT to respond with "true" or "false".
   - Usage: `gptguard "Your validation prompt"`
  
     ```
     [I] ~/.c/f/functions ❯❯❯ if gptguard "is the sky red"                  
                                 echo "no thats not right"
                         else
                                 echo "yes thats correct"
                         end
     no thats not right
     
     [I] ~/.c/f/functions ❯❯❯ if gptguard "is the sky blue"                
                                 echo "no thats not right"
                         else
                                 echo "yes thats correct"
                         end

        yes thats correct
     ```

1. **gptiterate**:
   - Modifies existing project files by automatically running the project and iterating based on the result. 
   - Usage: `gptiterate "Optionally provide what you want to iterate on"`


8. **gptarchitect**:
   - Generates and implements subsystems as FastAPI apps.
   - Usage: `gptarchitect "System description"`

9. **gptarchitect_recursive**:
   - Generates a tree of subsystems and implements recursively implements each as a FastAPI app.
   - Usage: `gptarchitect_recursive "System description"`

## Disclaimer 
These scripts (by definition) index the entire repository to OPENAI servers. Do not use this tool on proprietary codebases to avoid IP loss. Feature coming soon to connect to OLLAMA based offline models. 

## Requirements
- fish shell
- shell-gpt
- Python 3.8+
- FastAPI
- Uvicorn
- jq (for JSON processing)
- rich
  
## Installation
### OPENAI API key setup
OPENAI_API_KEY is set with your openai api key. You might consider putting this in your ~/.config/fish/config.fish
```
set -x OPENAI_API_KEY your_api_key
```
### install dependencies
```
sudo apt update && sudo apt install -y jq 
pip install fastapi uvicorn shell-gpt rich
```

### move all functions repository to .config/fish/functions
- *run this from the root of the gptalchemy repo*

```
mkdir -p ~/.config/fish/functions
find . -type f -name '*.fish' -exec mv {} ~/.config/fish/functions/ \;
```
## Testing

Unit tests are written using pytest. After generating the tests with `gpttest <optionally ask for specific test cases>`, use the following command:
```
pytest
```


## Author
Wrapper implementation: Spenser Millburn
Full credit to the incredible shell-gpt for making this possible. 
