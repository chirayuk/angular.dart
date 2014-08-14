library angular.test.core_dom.uri_resolver_spec;

import 'package:angular/core_dom/absolute_uris.dart';
import 'package:angular/core_dom/type_to_uri_mapper.dart';
import 'package:angular/core_dom/type_to_uri_mapper_dynamic.dart';
import '../_specs.dart';


_run({useRelativeUrls}) {
  describe("resolveUrls=$useRelativeUrls", () {
    var prefix = useRelativeUrls ? "packages/angular/test/core_dom/" : "";
    var container;
    var urlResolver;
    var typeOrIncludeUri;

    beforeEach((ResourceUrlResolver _urlResolver) {
      urlResolver = _urlResolver;
      container = document.createElement('div');
      document.body.append(container);
    });

    afterEach(() {
      urlResolver = null;
      container.remove();
    });

    beforeEachModule((Module module) {
      module
       ..bind(ResourceResolverConfig, toValue:
            new ResourceResolverConfig(useRelativeUrls: useRelativeUrls))
       ..bind(TypeToUriMapper, toImplementation: DynamicTypeToUriMapper);
    });

    toAppUrl(url) {
      var marker = "HTTP://LOCALHOST/";
      if (url.startsWith(marker)) {
        return "${typeOrIncludeUri.origin}/${url.substring(marker.length)}";
      } else {
        return url;
      }
    }

    testResolution(url, expected) {
      url = toAppUrl(url);
      expected = toAppUrl(expected);
      expected = useRelativeUrls ? expected : url;
      var baseUri = typeOrIncludeUri;
      it('resolves URI $url to $expected', (ResourceUrlResolver resourceResolver) {
        var html = resourceResolver.resolveHtml("<img src='$url'>", baseUri);
        print("ckck: expected: $expected");
        print("ckck: actual html: $html");
        expect(html).toEqual('<img src="$expected">');
      });
    }

    // test the cases where we're resolving URLs for a component/decorator whose
    // type URI looks like
    // package:angular/test/core_dom/absolute_uris_spec.dart.
    typeOrIncludeUri = Uri.parse('package:angular/test/core_dom/absolute_uris_spec.dart');

    // These tests check resolving with respect to paths that folks would have
    // typed by hand - either in the component annotation (templateUrl/cssUrl)
    // to ng-include / routing.
    // They also check resolving with respect to paths that were obtained by
    // typeToUri(type) when it returns a non-absolute path.

    // "packges/" paths, though relative, should never be resolved.
    testResolution('packages/angular/test/core_dom/foo.html',
                   'packages/angular/test/core_dom/foo.html');

    testResolution('package:a.b/c/d/foo3.html', 'packages/a.b/c/d/foo3.html');

    testResolution('foo.html', 'packages/angular/test/core_dom/foo.html');
    testResolution('./foo.html', 'packages/angular/test/core_dom/foo.html');
    testResolution('/foo.html', '/foo.html');
    testResolution('http://google.com/foo.html', 'http://google.com/foo.html');

    // A type URI need not always be a package: URI.  This can happen when:
    // • the type was defined in a Dart file that was
    //   imported via a path, e.g. "import 'web/bar.dart'".  (karma does this.)
    // • we are ng-include'ing a file, say, "a/b/foo.html", and we are trying to
    //   resolve paths inside foo.html.  Those should be resolved relative to
    //   something like http://localhost:8765/a/b/foo.html.
    typeOrIncludeUri = Uri.base.resolve('/a/b/included_template.html');

    // "packges/" paths, though relative, should never be resolved.
    testResolution('packages/angular/test/core_dom/foo.html',
                   'packages/angular/test/core_dom/foo.html');

    testResolution('package:a.b/c/d/foo3.html', 'packages/a.b/c/d/foo3.html');

    testResolution('image1.png', 'a/b/image1.png');
    testResolution('./image2.png', 'a/b/image2.png');
    testResolution('style.css', 'a/b/style.css');
    testResolution('/image3.png', '/image3.png');

    testResolution('http://google.com/foo.html', 'http://google.com/foo.html');
    testResolution('HTTP://LOCALHOST/a/b/image.png',
                   'a/b/image.png');
    testResolution('HTTP://LOCALHOST/packages/angular/test/core_dom/foo.html',
                   'packages/angular/test/core_dom/foo.html');


    // Set typeOrIncludeUri back

    templateResolution(url, expected) {
      if (!useRelativeUrls)
        expected = url;
      expect(urlResolver.resolveHtml('''
        <template>
          <img src="$url">
        </template>''', typeOrIncludeUri)).toEqual('''
        <template>
          <img src="$expected">
        </template>''');
    }

    it('resolves template contents', () {
      templateResolution('foo.png', 'packages/angular/test/core_dom/foo.png');
    });

    it('does not change absolute urls when they are resolved', () {
      templateResolution('/foo/foo.png', '/foo/foo.png');
    });

    it('resolves CSS URIs', (ResourceUrlResolver resourceResolver) {
      var html_style = ('''
        <style>
          body {
            background-image: url(foo.png);
          }
        </style>''');

      html_style = resourceResolver.resolveHtml(html_style, typeOrIncludeUri).toString();

      var resolved_style = ('''
        <style>
          body {
            background-image: url('${prefix}foo.png');
          }
        </style>''');
      expect(html_style).toEqual(resolved_style);
    });

    it('resolves @import URIs', (ResourceUrlResolver resourceResolver) {
      var html_style = ('''
        <style>
          @import url("foo.css");
          @import 'bar.css';
        </style>''');

      html_style = resourceResolver.resolveHtml(html_style, typeOrIncludeUri).toString();

      var resolved_style = ('''
        <style>
          @import url('${prefix}foo.css');
          @import '${prefix}bar.css';
        </style>''');
      expect(html_style).toEqual(resolved_style);
    });
  });
}

void main() {
  describe('url_resolver', () {
    _run(useRelativeUrls: true);
  });
}

class NullSanitizer implements NodeValidator {
  bool allowsElement(Element element) => true;
  bool allowsAttribute(Element element, String attributeName, String value) =>
      true;
}
