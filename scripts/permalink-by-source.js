'use strict';

hexo.extend.filter.register('before_post_render', function (data) {
  const rawSource = data && data.source ? String(data.source) : '';
  const source = rawSource.replace(/\\/g, '/');
  const marker = '_posts/';
  const markerIndex = source.indexOf(marker);

  if (markerIndex === -1) {
    return data;
  }

  let relative = source.slice(markerIndex + marker.length);
  relative = relative.replace(/\.[^/.]+$/, '');
  relative = relative.replace(/\/index$/i, '');

  if (!relative) {
    return data;
  }

  // Custom token used by config.permalink (:route_path/).
  data.route_path = relative;
  return data;
});

