const fs = require('fs');
const path = require('path');

function replaceImageWithShortcode(content) {
  const regex = /!\[(.*?)\]\((.*?)\)/g;
  return content.replace(regex, (match, alt, src) => {
    return `{{< responsive-image src="${src}" alt="${alt}" >}}`;
  });
}

function processFile(filePath) {
  fs.readFile(filePath, 'utf8', (err, content) => {
    if (err) {
      console.error(`Error reading file ${filePath}:`, err);
      return;
    }

    const updatedContent = replaceImageWithShortcode(content);

    fs.writeFile(filePath, updatedContent, 'utf8', (err) => {
      if (err) {
        console.error(`Error writing file ${filePath}:`, err);
      } else {
        console.log(`Updated ${filePath}`);
      }
    });
  });
}

function walkDir(dir) {
  fs.readdir(dir, (err, files) => {
    if (err) {
      console.error(`Error reading directory ${dir}:`, err);
      return;
    }

    files.forEach(file => {
      const filePath = path.join(dir, file);

      fs.stat(filePath, (err, stats) => {
        if (err) {
          console.error(`Error getting file stats for ${filePath}:`, err);
          return;
        }

        if (stats.isDirectory()) {
          walkDir(filePath);
        } else if (path.extname(file) === '.md') {
          processFile(filePath);
        }
      });
    });
  });
}

// Start processing from the content/blog directory
walkDir(path.join(__dirname, '..', 'content', 'blog'));
