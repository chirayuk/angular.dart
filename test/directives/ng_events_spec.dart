library ng_click_spec;

import '../_specs.dart';
import "../_test_bed.dart";
import 'dart:html' as dom;


main() {
  var events = ['blur', 'change', 'click', 'contextmenu', 'drag', 'dragend',
                'dragenter', 'dragleave', 'dragover', 'dragstart', 'drop',
                'focus', 'keydown', 'keypress', 'keyup', 'mousedown',
                'mouseenter', 'mouseleave', 'mousemove', 'mouseout',
                'mouseover', 'mouseup', 'mousewheel', 'scroll', 'touchcancel',
                'touchend', 'touchmove', 'touchstart'];

  events.forEach((name) {
    ddescribe('ng-$name', () {
      TestBed _;

      beforeEach(beforeEachTestBed((tb) => _ = tb));

      it('should evaluate the expression on $name', inject(() {
        _.compile('<button ng-$name="abc = true; event = \$event"></button>');
        _.triggerEvent(_.rootElement, '$name');
        expect(_.rootScope['abc']).toEqual(true);
        expect(_.rootScope['event'] is dom.MouseEvent).toEqual(true);
      }));
    });
  });
}
