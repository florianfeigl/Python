import markdown
from markdown_checklist.extension import ChecklistExtension

markdown_text = """
- [ ] Unchecked item
- [x] Checked item
"""

html = markdown.markdown(markdown_text, extensions=[ChecklistExtension()])
print(html)
