'use strict';

const fs = require('fs');
const path = require('path');
const { pathToFileURL } = require('url');
const sass = require('sass');

// Use Sass modern compile API to avoid legacy-js-api warnings.
hexo.extend.renderer.register('scss', 'css', async function (data) {
  const absolutePath = data && data.path ? path.resolve(data.path) : '';
  let source = data && typeof data.text === 'string' ? data.text : '';

  // Hexo may pass empty text in some pipelines; fall back to reading the file.
  if (!source && absolutePath && fs.existsSync(absolutePath)) {
    source = fs.readFileSync(absolutePath, 'utf8');
  }

  const options = {
    style: 'expanded',
    loadPaths: [
      absolutePath ? path.dirname(absolutePath) : hexo.base_dir,
      path.resolve(hexo.base_dir, 'node_modules')
    ]
  };

  if (absolutePath) {
    options.url = pathToFileURL(absolutePath);
  }

  const result = await sass.compileStringAsync(source, options);
  return result.css;
}, false);

