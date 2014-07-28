library angular.test.core_dom.uri_resolver_spec;

import 'package:angular/core_dom/absolute_uris.dart' as absolute;
import '../_specs.dart';

import 'dart:mirrors';

void main() {
  describe('url_resolver', () {
    var container;

    beforeEach(() {
      container = document.createElement('div');
      document.body.append(container);
    });

    afterEach(() {
      container.remove();
    });

    // TODO(chirayu): Repeat all these tests again with originalBase set to
    //     reflectType(SomeTypeInThisFile).owner.uri, which will be an http URL
    //     instead of a package: URL (because of the way karma runs the tests)
    //     and ensure that after resolution, the result doesn't have a protocol
    //     or domain but contains the full path.
    var originalBase = Uri.parse('package:angular/test/core_dom/absolute_uris_spec.dart');

    testResolution(url, expected) {
      iit('resolves attribute URIs $url to $expected', () {
        var html = absolute.resolveHtml("<img src='$url'>", originalBase);
        expect(html).toEqual('<img src="$expected">');
      });
    }

    testResolution('packages/angular/test/core_dom/foo.html', 'packages/angular/test/core_dom/foo.html');
    testResolution('foo.html', 'packages/angular/test/core_dom/foo.html');
    testResolution('./foo.html', 'packages/angular/test/core_dom/foo.html');
    testResolution('/foo.html', '/foo.html');
    testResolution('http://google.com/foo.html', 'http://google.com/foo.html');

    testTemplateResolution(url, expected) {
      expect(absolute.resolveHtml('''
        <template>
          <img src="$url">
        </template>''', originalBase)).toEqual('''
        <template>
          <img src="$expected">
        </template>''');
    }

    iit('resolves template contents', () {
        testTemplateResolution('foo.png', 'packages/angular/test/core_dom/foo.png');
    });
    
    iit('does not change absolute urls when they are resolved', () {
      testTemplateResolution('/foo/foo.png', '/foo/foo.png');
    });

    // NOTE: These two tests currently fail on firefox, but pass on chrome,
    // safari and dartium browsers. Add back into the list of tests when firefox
    // pushes new version(s).
    xit('resolves CSS URIs', () {
      var html = ('''
        <style>
          body {
            background-image: url(foo.png);
          }
        </style>''');

      html = absolute.resolveHtml(html, originalBase);
      var style = html.children[0];
      container.append(style);
      expect(style.sheet.rules[0].style.backgroundImage).toEqual(
          'url(${originalBase.resolve('foo.png')})');
    });

    xit('resolves @import URIs', () {
      var html = ('''
        <style>
          @import url("foo.css");
          @import 'bar.css';
        </style>''');

      html = absolute.resolveHtml(html, originalBase);
      var style = html.children[0];
      document.body.append(style);
      CssImportRule import1 = style.sheet.rules[0];
      expect(import1.href).toEqual(originalBase.resolve('foo.css').toString());
      CssImportRule import2 = style.sheet.rules[1];
      expect(import2.href).toEqual(originalBase.resolve('bar.css').toString());
    });
  });
}

class NullSanitizer implements NodeValidator {
  bool allowsElement(Element element) => true;
  bool allowsAttribute(Element element, String attributeName, String value) =>
      true;
}
