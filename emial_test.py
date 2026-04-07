from pathlib import Path

# Print the module name
print(f"Module name: {__name__}")

# Convert the module name to a Path object
module_path = Path(__name__)

# Print the Path object created from module name
print(f"Module Path: {module_path}")


# Get the path of the current script
script_path = Path(__file__)

# Print the script's path
print(f"Script path: {script_path}")

# Get the directory of the current script
script_dir = script_path.parent

# Print the script's directory
print(f"Script directory: {script_dir}")

# Example of accessing a file in the same directory
data_file = script_dir / 'data.txt'

# Print the path to the data file
print(f"Data file path: {data_file}")