function h2
    # Read multiline input from the user
    set input "$argv"

    # Define the Python script using a multiline string in Fish
    set python_script "
from rich.console import Console
from rich.markdown import Markdown

console = Console()
heading = f\"## $input\"
md = Markdown(heading)
console.print(md)
"

    # Pass the Python script to python3 via standard input
    echo "$python_script" | python3
end
