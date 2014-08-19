import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:angulardart_transformer_e2e_app/a/b/c/foo.dart';

main() {
  applicationFactory()
      .addModule(new Module()
          ..bind(ResourceResolverConfig,
                 toValue: new ResourceResolverConfig(useRelativeUris: false))
          ..bind(FooComponent))
      .run();
}
