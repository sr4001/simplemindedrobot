# Simpleminded Robot: AI and Agile Development Insights

## Who We Are

Simpleminded Robot is a platform dedicated to exploring the intersection of Artificial Intelligence (AI) and Agile development methodologies. We provide cutting-edge insights, analysis, and practical advice for tech professionals navigating the complexities of modern software development.

## What We Do

Our mission is to:

1. Explore and analyze the integration of AI in Agile workflows
2. Share insights on tech advancements in software development
3. Provide practical guidance on implementing AI-enhanced Agile practices
4. Discuss trends and innovations in project management and software engineering

## Site Customizations

This site is built using Hugo, a fast and flexible static site generator. Our theme is based on [Doks](https://getdoks.org/), which is built on top of [Thulite](https://github.com/Thulite/thulite). We highly recommend referring to their documentation for a deeper understanding of the theme's capabilities:

- Doks Documentation: [https://getdoks.org/docs/](https://getdoks.org/docs/)
- Thulite Documentation: [https://github.com/Thulite/thulite](https://github.com/Thulite/thulite)

We've made several customizations to enhance the user experience and optimize for search engines:

### Layout and Partial Overrides

1. **Custom Footer**: We've customized the footer in `layouts/partials/footer/footer.html` to include specific information about our site and relevant links.

2. **Blog Meta Information**: The `layouts/partials/main/blog-meta.html` file has been modified to display custom meta information for blog posts, enhancing the presentation of our content.

3. **Homepage Layout**: We've customized the `layouts/index.html` file to create a unique and engaging homepage that reflects our brand and content focus.

### Configuration Files

The main configuration files for the site are:

1. `config/_default/hugo.toml`: Contains the main Hugo configuration settings
2. `config/_default/languages.toml`: Manages language-specific settings
3. `config/_default/params.toml`: Stores custom parameters for the theme and site functionality

## Making Changes to the Site

### Modifying hugo.toml

To make changes to the site's core configuration:

1. Open `config/_default/hugo.toml`
2. Modify settings such as `title`, `baseurl`, `languageCode`, etc.
3. Adjust build settings, output formats, and other Hugo-specific configurations as needed

Example:
```toml
title = "AI and Agile Development Insights | Simpleminded Robot"
baseurl = "http://sr4001.net/"
languageCode = "en-US"
```

### Updating params.toml

To customize theme-specific settings and site parameters:

1. Open `config/_default/params.toml`
2. Modify settings related to appearance, social media links, and other custom features

Note: Please refer to the Doks and Thulite documentation for specific parameters that can be adjusted.

## Adding New Taxonomies

To add new taxonomies, such as the upcoming series capability:

1. Open `config/_default/hugo.toml`
2. Locate the `[taxonomies]` section
3. Add a new line for the "series" taxonomy:

```toml
[taxonomies]
  contributor = "contributors"
  category = "categories"
  tag = "tags"
  series = "series"  # Add this line for the new series taxonomy
```

4. Create a new folder in the `content` directory for the series, e.g., `content/series/`
5. For each series, create a markdown file with front matter defining the series, e.g., `content/series/ai-in-agile.md`:

```markdown
---
title: "AI in Agile"
description: "A series exploring the integration of AI in Agile methodologies"
---
```

6. In your content files (e.g., blog posts), add the series to the front matter:

```markdown
---
title: "Introduction to AI in Agile"
date: 2023-04-15
series: ["AI in Agile"]
---
```

7. Update your theme templates to display and link series information on relevant pages

## Contributing

We welcome contributions to improve our content and site functionality. Please refer to our contribution guidelines (link to CONTRIBUTING.md if available) for more information on how to submit changes or new content.

## License

This project is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en). Please see the LICENSE file for more details.

---

For any questions or support, please [contact us](mailto:your-email@example.com) or open an issue in this repository.
