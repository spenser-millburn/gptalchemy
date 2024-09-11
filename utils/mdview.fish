function mdview
    python3 -c "
import sys
from rich.console import Console
from rich.markdown import Markdown

# Initialize the console
console = Console()

# Read the Markdown file
with open(\"$argv[1]\", \"r\") as file:
    markdown_content = file.read()

# Create a Markdown object
markdown = Markdown(markdown_content)

# Print the Markdown content to the console
console.print(markdown)
"

end
