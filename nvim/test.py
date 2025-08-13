"""
what does this script do?

This script retrieves and prints the current working directory and lists all files in that directory.
list of files in the current directory.
"""
import os

if __name__ == "__main__":
    # Get the current working directory
    current_directory = os.getcwd()
    
    # Print the current working directory
    print(f"Current working directory: {current_directory}")
    
    # List all files in the current directory
    files = os.listdir(current_directory)
    
    # Print the list of files
    print("Files in the current directory:")
    for file in files:
        print(file)

    print("I have a ")
