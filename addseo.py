import os
import frontmatter

def add_seo_to_frontmatter(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        post = frontmatter.load(f)

    # Add SEO objects
    post['seo'] = {
        'title': post.get('title', ''),
        'description': post.get('description', ''),
        'canonical': f"https://sr4001.net{file_path.replace('content', '').replace('index.md', '')}",
        'noindex': False
    }

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(frontmatter.dumps(post))

def process_directory(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                add_seo_to_frontmatter(file_path)

# Define the directory to search for .md files
content_blog_directory = './content/blog'
process_directory(content_blog_directory)
