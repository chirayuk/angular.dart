library foo;

import 'package:di/di.dart';
import 'package:angular/angular.dart';

@Component(
    selector: 'x-foo',
    // templateUrl: 'foo.html',
    templateUrl: 'packages/angulardart_transformer_e2e_app/a/b/c/foo.html',
    // cssUrl: 'foo.css',
    useShadowDom: false,
    applyAuthorStyles: false)
class FooComponent {
}
