'use strict';

hexo.extend.filter.register('after_post_render', function (data) {
  if (!data || typeof data.content !== 'string' || !data.content.includes('<img')) {
    return data;
  }

  data.content = data.content.replace(/<img\b[^>]*>/gi, function (tag) {
    if (/\bloading\s*=\s*/i.test(tag)) {
      return tag;
    }

    let nextTag = tag.replace('<img', '<img loading="lazy"');

    if (!/\bdecoding\s*=\s*/i.test(nextTag)) {
      nextTag = nextTag.replace('<img', '<img decoding="async"');
    }

    if (!/\bfetchpriority\s*=\s*/i.test(nextTag)) {
      nextTag = nextTag.replace('<img', '<img fetchpriority="low"');
    }

    return nextTag;
  });

  return data;
});
