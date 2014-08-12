library angular.core_dom.type_to_uri_mapper;

import 'package:path/path.dart' as native_path;

final _path = native_path.url;

/// Utility to convert type-relative URIs to be page-relative.
abstract class TypeToUriMapper {
  final ResourceResolverConfig _resourceResolverConfig;
  final String baseUri = Uri.base.toString();
  
  TypeToUriMapper(this._resourceResolverConfig);
  
  static final RegExp _libraryRegExp = new RegExp(r'/packages/');
  
  // to be rewritten for dynamic and static cases
  Uri uriForType(Type type);
  
  String combineWithType(Type type, String uri) {
    return combine(uriForType(type), uri);
  }

  // Combines a type-based URI with a relative URI.
  //
  // [baseUri] is assumed to use package: syntax for package-relative
  // type URIs, but can be an absolute path for ng-include, etc.  If it is
  //  relative to Uri.baseUri, then we will make it relative so that the template
  //  can be looked up in the templateCache.
  //  while [uri] is assumed to use 'packages/' syntax for
  /// package-relative URIs. Resulting URIs will use 'packages/' to indicate
  /// package-relative URIs.
  String combine(Uri baseUri, String uri) {
    if (!_resourceResolverConfig.useRelativeUrls) {
      return uri;
    }
    
    if (uri == null) {
      uri = baseUri.path;
    } else {
      // if it's absolute but not package-relative, then just use that
      if (uri.startsWith("/") || uri.startsWith('packages/')) {
        return uri;
      }
    }
    // If it's not absolute, then resolve it first
    Uri resolved = baseUri.resolve(uri);

    // If it's package-relative, tack on 'packages/' - Note that eventually
    // we may want to change this to be '/packages/' to make it truly absolute
    if (resolved.scheme == 'package') {
      return 'packages/${resolved.path}';
    } else if (baseUri.isAbsolute && baseUri.toString().startsWith(baseUri)) {
      return baseUri.path;
    } else {
      return resolved.toString();
    }
  }
}

class ResourceResolverConfig {
  bool useRelativeUrls;
  
  ResourceResolverConfig({this.useRelativeUrls});
}
