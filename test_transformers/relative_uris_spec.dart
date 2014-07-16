library angular.test_transformers.relative_uris_spec;

import 'package:protractor/protractor_api.dart';

main() {
  describe('relative-uri rewriting in static application', () {
    it('should rewrite a relative uri', () {
      var ptor = protractor.getInstance().get('index.html');
      expect(ptor.isElementPresent(by.id('test_div'))).toBe(true);
    });
  });
}