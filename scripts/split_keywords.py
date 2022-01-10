import json
import csv
import re
from pathlib import Path 

parent_wd = Path(__file__).parent.parent
file_path = parent_wd/'data'/'1000_keywords.csv'
output_file_path = parent_wd/'data'/'fixed_1000_keywords.csv'
kw_regex = re.compile(r"'name':\s'(.+?)'")
new_keywords_listofdicts = [] 

with open(file_path, newline='') as csv_file:
    rows = csv.DictReader(csv_file)
    for i, row in enumerate(rows):
        movie_id = row['id']
        keywords_str = row['keywords']
        keywords = re.findall(kw_regex, keywords_str)
        # new_keywords_str = ",".join(keywords)
        for kw in keywords:
            new_kw_dict = {
                'id':movie_id, 
                'keyword': kw
                }
            new_keywords_listofdicts.append(new_kw_dict)

with open(output_file_path, 'w', newline='') as csv_file:
    fields = ['id', 'keyword']
    writer = csv.DictWriter(csv_file, fieldnames=fields)
    writer.writeheader()
    for l_item in new_keywords_listofdicts: 
        writer.writerow(l_item)
    