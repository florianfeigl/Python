import os

import frontmatter


def load_tags_from_directory(directory: str) -> dict:
    tags_by_post = {}

    for filename in os.listdir(directory):
        if filename.endswith(".md"):
            file_path = os.path.join(directory, filename)

            with open(file_path, "r", encoding="utf-8") as file:
                post = frontmatter.load(file)
                tag_string = post.metadata.get("tags", "")
                tag_list = [tag.strip() for tag in tag_string.split(",")]

                tags_by_post[filename] = tag_list

    return tags_by_post


# Example usage
directory_path = "content/posts/"
tags = load_tags_from_directory(directory_path)
print(tags)
