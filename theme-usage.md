# Theme Usage in Simpleminded Robot Project

This document provides an overview of how the Doks theme is used in the Simpleminded Robot project.

1. **Theme**: The project uses the Doks theme, which is a Hugo theme designed for documentation websites.

2. **Installation**: The theme is installed as a Node.js package, specifically @thulite/doks-core version 1.7.0, as seen in the package.json file.

3. **Main Configuration**: The main Hugo configuration is located in `config/_default/hugo.toml`. This file contains general site settings but doesn't include explicit theme configurations.

4. **Theme Integration**: Theme integration is managed through `config/_default/module.toml`. This file defines how various components of the Doks theme are mounted from the node_modules directory into the Hugo project structure.

5. **Additional Packages**: The project uses several Thulite packages, including @thulite/core, @thulite/images, @thulite/seo, and @thulite/inline-svg, in addition to the main @thulite/doks-core package.

6. **Component Mounting**: Theme components such as archetypes, assets, layouts, and static files are mounted from the respective node_modules directories into the Hugo project structure.

7. **Customization**: The project allows for custom overrides by mounting local directories (e.g., layouts, assets, content) after the theme directories, allowing for easy customization.

This setup allows the project to use the Doks theme while maintaining the ability to easily update the theme (by updating the npm packages) and customize it as needed (by adding files to the local directories that override the theme defaults).

For detailed mount configurations, refer to the `config/_default/module.toml` file.
