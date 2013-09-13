import "_perf.dart";
import "dart:async";

main() {
  var handleDirect = (a, b, c) => a + b + c;
  var handleDirectNamed = ({a, b, c}) => a + b + c;
  var handleIndirect = (e) => e.a + e.b + e.c;
  var streamC = new StreamController(sync:true);
  var stream = streamC.stream..listen(handleIndirect);

  time('direct', () => handleDirect(1, 2, 3) );
  time('directNamed', () => handleDirectNamed(a:1, b:2, c:3) );
  time('indirect', () => handleIndirect(new Container(1, 2, 3)) );
  time('stream', () => streamC.add(new Container(1, 2, 3)));
}

class Container {
  var a;
  var b;
  var c;

  Container(this.a, this.b, this.c);
}
