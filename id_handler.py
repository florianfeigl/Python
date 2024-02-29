#!/usr/bin/env python3

import os


def supplement_id_gaps(directory, start_id=0):
    file_paths = [
        os.path.join(directory, f)
        for f in sorted(os.listdir(directory))
        if f.endswith(".md")
    ]

    for file_path in file_paths:
        with open(file_path, "r", encoding="utf-8") as file:
            lines = file.readlines()

        # Check if the file already has an ID
        has_id = any(line.startswith("id:") for line in lines)

        if not has_id:
            # Find the index of the first '---' which starts the front matter
            start_of_front_matter = lines.index("---\n") + 1
            lines.insert(start_of_front_matter, f"id: \\#{start_id}\n")
            start_id += 1

            with open(file_path, "w", encoding="utf-8") as file:
                file.writelines(lines)


# Usage
supplement_id_gap("/home/florian/Projects/Websites/182bit.org/posts/")
