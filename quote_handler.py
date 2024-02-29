#!/usr/bin/env python3

import os

def clean_frontmatter(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    with open(file_path, 'w', encoding='utf-8') as file:
        in_front_matter = False
        for line in lines:
            if line.startswith('---'):
                in_front_matter = not in_front_matter
            elif in_front_matter and ':' in line:
                key, value = line.split(':', 1)
                value = value.strip()

                # Remove quotes from date fields if present
                if key.strip() == 'date' and (value.startswith(('"', "'")) and value.endswith(('"', "'"))):
                    value = value[1:-1]  # Remove the first and last characters (quotes)

                # Add quotes to non-date fields if not present
                elif not (value.startswith(('"', "'")) or key.strip() == 'date'):
                    value = f'"{value}"'

                line = f'{key}: {value}\n'
            
            file.write(line)

# Example usage
#directory = '/home/florian/Projects/Websites/182bit.org/posts/'
#for filename in os.listdir(directory):
#    if filename.endswith('.md'):
#        clean_front_matter(os.path.join(directory, filename))
