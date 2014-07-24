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

    DocumentFragment fragment(String html) =>
        new DocumentFragment.html(html, validator: new NullSanitizer());

    testResolution(url, expected) {
      iit('resolves attribute URIs $url to $expected', () {
        var node = new ImageElement()..attributes['src'] = url;

        absolute.resolveDom(node, originalBase);
        expect(node.attributes['src']).toEqual(expected);
      });
    }

    testResolution('foo.html', 'packages/angular/test/core_dom/foo.html');
    testResolution('./foo.html', 'packages/angular/test/core_dom/foo.html');
    testResolution('/foo.html', '/foo.html');
    testResolution('http://google.com/foo.html', 'http://google.com/foo.html');


    it('resolves template contents', () {
      var dom = fragment('''
        <template>
          <img src='foo.png'>
        </template>''');

      absolute.resolveDom(dom, originalBase);
      var img = dom.children[0].content.children[0];
      container.append(img);
      expect(img.src).toEqual(originalBase.resolve('foo.png').toString());
    });
    
    it('does not change absolute urls when they are resolved', () {
      var dom = fragment('''
        <template>
          <img src='/foo/foo.png'>
        </template>''');

      absolute.resolveDom(dom, originalBase);
      var img = dom.children[0].content.children[0];
      container.append(img);
      expect(img.src).toEqual(originalBase.resolve('foo.png').toString());
    });

    // NOTE: These two tests currently fail on firefox, but pass on chrome,
    // safari and dartium browsers. Add back into the list of tests when firefox
    // pushes new version(s).
    xit('resolves CSS URIs', () {
      var dom = fragment('''
        <style>
          body {
            background-image: url(foo.png);
          }
        </style>''');

      absolute.resolveDom(dom, originalBase);
      var style = dom.children[0];
      container.append(style);
      expect(style.sheet.rules[0].style.backgroundImage).toEqual(
          'url(${originalBase.resolve('foo.png')})');
    });

    xit('resolves @import URIs', () {
      var dom = fragment('''
        <style>
          @import url("foo.css");
          @import 'bar.css';
        </style>''');

      absolute.resolveDom(dom, originalBase);
      var style = dom.children[0];
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
