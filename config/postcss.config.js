const autoprefixer = require('autoprefixer');
const purgecss = require('@fullhuman/postcss-purgecss');
const whitelister = require('purgecss-whitelister');
const fs = require('fs');
const path = require('path');
const glob = require('glob');

function checkPaths(paths) {
    return paths.filter((p) => {
        const fullPath = path.resolve(__dirname, '..', p);
        if (p.includes('*')) {
            // Handle glob patterns
            const matchedFiles = glob.sync(fullPath);
            if (matchedFiles.length > 0) {
                console.log(`Glob pattern ${p} matched ${matchedFiles.length} files.`);
                return true;
            } else {
                console.warn(`Warning: Glob pattern ${p} did not match any files.`);
                return false;
            }
        } else if (fs.existsSync(fullPath)) {
            console.log(`Path ${p} exists.`);
            return true;
        } else {
            console.warn(`Warning: Path ${p} does not exist.`);
            return false;
        }
    });
}

const whitelistPaths = ['./assets/scss/**/*.scss', './node_modules/@thulite/doks-core/assets/scss/components/_code.scss', './node_modules/@thulite/doks-core/assets/scss/components/_expressive-code.scss', './node_modules/@thulite/doks-core/assets/scss/common/_syntax.scss'];

console.log('Checking whitelist paths...');
const validPaths = checkPaths(whitelistPaths);
console.log('Valid paths:', validPaths);

module.exports = {
    plugins: [
        autoprefixer(),
        purgecss({
            content: ['./hugo_stats.json'],
            extractors: [
                {
                    extractor: (content) => {
                        const els = JSON.parse(content).htmlElements;
                        return els.tags.concat(els.classes, els.ids);
                    },
                    extensions: ['json']
                }
            ],
            dynamicAttributes: ['aria-expanded', 'data-bs-popper', 'data-bs-target', 'data-bs-theme', 'data-dark-mode', 'data-global-alert', 'data-pane', 'data-popper-placement', 'data-sizes', 'data-toggle-tab', 'id', 'size', 'type'],
            safelist: ['active', 'btn-clipboard', 'clipboard', 'disabled', 'hidden', 'modal-backdrop', 'selected', 'show', 'img-fluid', 'blur-up', 'lazyload', 'lazyloaded', 'alert-link', 'container-fw ', 'container-lg', 'container-fluid', 'offcanvas-backdrop', 'figcaption', 'dt', 'dd', 'showing', 'hiding', 'page-item', 'page-link', 'not-content', ...(validPaths.length > 0 ? whitelister(validPaths) : [])]
        })
    ]
};
