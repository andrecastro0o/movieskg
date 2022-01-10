import json
from sys import argv
from pathlib import Path 

cwd = Path(__file__).parent
json_file_path = cwd/argv[1] #'1000_movies_metadata.json'
print(json_file_path)

with open(json_file_path, 'r') as json_file:
    json_content = json.load(json_file)
    # print(json_content)

all_parent_keys = []
for i, entry in enumerate(json_content):
    parent_keys = list(entry.keys())
    for k in parent_keys:
        if k not in all_parent_keys:
            all_parent_keys.append(k)

print(all_parent_keys)