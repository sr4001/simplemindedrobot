# Simpleminded Robot: AI and Agile Development Insights

Welcome to the Simpleminded Robot repository! This project explores how AI can transform Agile development practices and related technical trends, insights, and solutions. This repository contains the source code for the Simpleminded Robot site, powered by Hugo, and integrates various enhancements including SEO, performance optimizations, and remote work-related content.

## Who We Are

Simpleminded Robot is a platform dedicated to exploring the intersection of Artificial Intelligence (AI) and Agile development methodologies. We provide cutting-edge insights, analysis, and practical advice for tech professionals navigating the complexities of modern software development.

## What We Do

Our mission is to:

1. Explore and analyze the integration of AI in Agile workflows
2. Share insights on tech advancements in software development
3. Provide practical guidance on implementing AI-enhanced Agile practices
4. Discuss trends and innovations in project management and software engineering

## Getting Started

### Prerequisites

To get started with this project, ensure you have the following installed:

- Hugo (v0.135.0 or higher)
- Node.js (v22.9.0)
- npm (v10.8.3)

### Installing

Clone the repository and install dependencies:

```bash
git clone https://github.com/sr4001/simplemindedrobot.git
cd simplemindedrobot
npm install
```

### Running Locally

To run the site locally and make changes:

```bash
npm run serve
```

This will launch the site at `http://localhost:1313/`.

### Building the Site

To build the site for production:

```bash
npm run build
```

The site will be output to the `public/` directory.

## Site Customizations

This site is built using Hugo, a fast and flexible static site generator. Our theme is based on [Doks](https://getdoks.org/), which is built on top of [Thulite](https://github.com/Thulite/thulite). We highly recommend referring to their documentation for a deeper understanding of the theme's capabilities:

- Doks Documentation: [https://getdoks.org/docs/](https://getdoks.org/docs/)
- Thulite Documentation: [https://github.com/Thulite/thulite](https://github.com/Thulite/thulite)

We've made several customizations to enhance the user experience and optimize for search engines:

### Layout and Partial Overrides

1. **Custom Footer**: We've customized the footer in `layouts/partials/footer/footer.html` to include specific information about our site and relevant links.

2. **Blog Meta Information**: The `layouts/partials/main/blog-meta.html` file has been modified to display custom meta information for blog posts, enhancing the presentation of our content.

3. **Homepage Layout**: We've customized the `layouts/index.html` file to create a unique and engaging homepage that reflects our brand and content focus.

## Configurations

### Configuration Files

The main configuration files for the site are:

1. `config/_default/hugo.toml`: Contains the main Hugo configuration settings
2. `config/_default/languages.toml`: Manages language-specific settings
3. `config/_default/params.toml`: Stores custom parameters for the theme and site functionality

### Modifying `hugo.toml`

To make changes to the site's core configuration:

1. Open `config/_default/hugo.toml`
2. Modify settings such as `title`, `baseurl`, `languageCode`, etc.
3. Adjust build settings, output formats, and other Hugo-specific configurations as needed

Key settings include:

```toml
title = "Simpleminded Robot"
baseurl = "http://sr4001.net/"
description = "AI and Agile Development Insights | Explore AI integration, Agile workflows, and tech advancements in software development."
languageCode = "en-US"
pagination.pagerSize = 10
```

For SEO and robots management, ensure the following settings are enabled:

```toml
enableRobotsTXT = true
canonifyURLs = true
```

### Multilingual Configuration

Languages such as German and Dutch are disabled by default:

```toml
disableLanguages = ["de", "nl"]
```

You can enable additional languages by adjusting this setting.

### Updating params.toml

To customize theme-specific settings and site parameters:

1. Open `config/_default/params.toml`
2. Modify settings related to appearance, social media links, and other custom features

Note: Please refer to the Doks and Thulite documentation for specific parameters that can be adjusted.

## Content Management

### Adding New Pages

Content is primarily managed under the `content/` directory. To create a new blog post, add a Markdown file in the appropriate directory (e.g., `content/blog/`).

For example:

```md
---
title: "My New Blog Post"
date: 2024-10-08
tags: ["ai", "agile"]
---
```

### About Page

The "About" page content is located in `content/about.md`. You can modify this file to update the information displayed about the site and its owner.

### Images and Media

Images should be placed in the relevant post folders. Hugo's image processing capabilities ensure images are optimized for faster load times. Default image settings are defined in `config/_default/params.toml`:

```toml
images = ["cover.png"]  # Default image for social sharing
```

### Site Metadata and SEO

The site's SEO settings have been streamlined. Structured data, JSON-LD, and schema are handled via Hugo templates. You can review and modify these settings in the `layouts/partials/seo/structured-data.html` file.

To edit meta descriptions, keywords, and other SEO-related data for individual pages, include them in the page's front matter:

```md
---
title: "My SEO-Friendly Page"
description: "This page covers the best practices for AI in Agile development."
seo:
  canonical: "https://sr4001.net/my-page/"
  noindex: false
  title: "AI in Agile Development"
tags: ["ai", "agile"]
---
```

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

## Customization

### Styling

The project uses custom SCSS for styling. You can find the SCSS files in `assets/scss/`. Fonts and typography have been updated for a modern, streamlined look:

- Headers use the "Orbitron" font.
- Body text uses "Helvetica Neue" and similar sans-serif fonts for a clean, readable design.

For example, header styles are set as follows:

```scss
h1, h2, h3, h4, h5, h6 {
    font-family: "Orbitron", serif;
    font-weight: 500;
}
```

### JavaScript

The site relies on minimal JavaScript, but for build optimizations, we use esbuild. Any necessary custom scripts are located in the `scripts/` folder. You can modify and add functionality as needed.

## Deployment

### Cloudflare Integration

The site is integrated with Cloudflare Pages for deployment. The deployment script has been updated to include environment variables for Node.js, npm, and Hugo:

```bash
export NODE_VERSION="22.9.0"
export NPM_VERSION="10.8.3"
export HUGO_VERSION="0.135.0"
```

To clear the Cloudflare cache after a deployment, run:

```bash
./scripts/update_cloudflare.sh
```

This will ensure the most up-to-date version of the site is displayed.

### GitHub Actions

GitHub Actions is used to automate the deployment process. The configuration is found in `.github/workflows/update_cloudflare_pages.yml`. When pushing to the `main` branch or merging pull requests, the site is automatically built and deployed to Cloudflare Pages.

## Contributing

We welcome contributions to improve our content and site functionality. Please refer to our contribution guidelines (link to CONTRIBUTING.md if available) for more information on how to submit changes or new content.

## License

This project is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en). Please see the LICENSE file for more details.

---

For any questions or support, please [contact us](mailto:your-email@example.com) or open an issue in this repository.
