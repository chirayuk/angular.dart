library angular.directive.ng_click;

import "dart:html" as dom;
import "../dom/directive.dart";
import "../scope.dart";

@NgDirective(
    selector: '[ng-blur]',
    map: const {'ng-blur': '&.onBlur'}
)
class NgBlurAttrDirective {
  Getter onBlur;

  NgBlurAttrDirective(dom.Element element, Scope scope) {
    element.onBlur.listen((event) => scope.$apply(() {
      onBlur({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-change]',
    map: const {'ng-change': '&.onChange'}
)
class NgChangeAttrDirective {
  Getter onChange;

  NgChangeAttrDirective(dom.Element element, Scope scope) {
    element.onChange.listen((event) => scope.$apply(() {
      onChange({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-click]',
    map: const {'ng-click': '&.onClick'}
)
class NgClickAttrDirective {
  Getter onClick;

  NgClickAttrDirective(dom.Element element, Scope scope) {
    element.onClick.listen((event) => scope.$apply(() {
      onClick({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-contextmenu]',
    map: const {'ng-contextmenu': '&.onContextMenu'}
)
class NgContextMenuAttrDirective {
  Getter onContextMenu;

  NgContextMenuAttrDirective(dom.Element element, Scope scope) {
    element.onContextMenu.listen((event) => scope.$apply(() {
      onContextMenu({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-drag]',
    map: const {'ng-drag': '&.onDrag'}
)
class NgDragAttrDirective {
  Getter onDrag;

  NgDragAttrDirective(dom.Element element, Scope scope) {
    element.onDrag.listen((event) => scope.$apply(() {
      onDrag({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-dragend]',
    map: const {'ng-dragend': '&.onDragEnd'}
)
class NgDragEndAttrDirective {
  Getter onDragEnd;

  NgDragEndAttrDirective(dom.Element element, Scope scope) {
    element.onDragEnd.listen((event) => scope.$apply(() {
      onDragEnd({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-dragenter]',
    map: const {'ng-dragenter': '&.onDragEnter'}
)
class NgDragEnterAttrDirective {
  Getter onDragEnter;

  NgDragEnterAttrDirective(dom.Element element, Scope scope) {
    element.onDragEnter.listen((event) => scope.$apply(() {
      onDragEnter({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-dragleave]',
    map: const {'ng-dragleave': '&.onDragLeave'}
)
class NgDragLeaveAttrDirective {
  Getter onDragLeave;

  NgDragLeaveAttrDirective(dom.Element element, Scope scope) {
    element.onDragLeave.listen((event) => scope.$apply(() {
      onDragLeave({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-dragover]',
    map: const {'ng-dragover': '&.onDragOver'}
)
class NgDragOverAttrDirective {
  Getter onDragOver;

  NgDragOverAttrDirective(dom.Element element, Scope scope) {
    element.onDragOver.listen((event) => scope.$apply(() {
      onDragOver({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-dragstart]',
    map: const {'ng-dragstart': '&.onDragStart'}
)
class NgDragStartAttrDirective {
  Getter onDragStart;

  NgDragStartAttrDirective(dom.Element element, Scope scope) {
    element.onDragStart.listen((event) => scope.$apply(() {
      onDragStart({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-drop]',
    map: const {'ng-drop': '&.onDrop'}
)
class NgDropAttrDirective {
  Getter onDrop;

  NgDropAttrDirective(dom.Element element, Scope scope) {
    element.onDrop.listen((event) => scope.$apply(() {
      onDrop({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-focus]',
    map: const {'ng-focus': '&.onFocus'}
)
class NgFocusAttrDirective {
  Getter onFocus;

  NgFocusAttrDirective(dom.Element element, Scope scope) {
    element.onFocus.listen((event) => scope.$apply(() {
      onFocus({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-keydown]',
    map: const {'ng-keydown': '&.onKeyDown'}
)
class NgKeyDownAttrDirective {
  Getter onKeyDown;

  NgKeyDownAttrDirective(dom.Element element, Scope scope) {
    element.onKeyDown.listen((event) => scope.$apply(() {
      onKeyDown({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-keypress]',
    map: const {'ng-keypress': '&.onKeyPress'}
)
class NgKeyPressAttrDirective {
  Getter onKeyPress;

  NgKeyPressAttrDirective(dom.Element element, Scope scope) {
    element.onKeyPress.listen((event) => scope.$apply(() {
      onKeyPress({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-keyup]',
    map: const {'ng-keyup': '&.onKeyUp'}
)
class NgKeyUpAttrDirective {
  Getter onKeyUp;

  NgKeyUpAttrDirective(dom.Element element, Scope scope) {
    element.onKeyUp.listen((event) => scope.$apply(() {
      onKeyUp({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-mousedown]',
    map: const {'ng-mousedown': '&.onMouseDown'}
)
class NgMouseDownAttrDirective {
  Getter onMouseDown;

  NgMouseDownAttrDirective(dom.Element element, Scope scope) {
    element.onMouseDown.listen((event) => scope.$apply(() {
      onMouseDown({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-mouseenter]',
    map: const {'ng-mouseenter': '&.onMouseEnter'}
)
class NgMouseEnterAttrDirective {
  Getter onMouseEnter;

  NgMouseEnterAttrDirective(dom.Element element, Scope scope) {
    element.onMouseEnter.listen((event) => scope.$apply(() {
      onMouseEnter({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-mouseleave]',
    map: const {'ng-mouseleave': '&.onMouseLeave'}
)
class NgMouseLeaveAttrDirective {
  Getter onMouseLeave;

  NgMouseLeaveAttrDirective(dom.Element element, Scope scope) {
    element.onMouseLeave.listen((event) => scope.$apply(() {
      onMouseLeave({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-mousemove]',
    map: const {'ng-mousemove': '&.onMouseMove'}
)
class NgMouseMoveAttrDirective {
  Getter onMouseMove;

  NgMouseMoveAttrDirective(dom.Element element, Scope scope) {
    element.onMouseMove.listen((event) => scope.$apply(() {
      onMouseMove({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-mouseout]',
    map: const {'ng-mouseout': '&.onMouseOut'}
)
class NgMouseOutAttrDirective {
  Getter onMouseOut;

  NgMouseOutAttrDirective(dom.Element element, Scope scope) {
    element.onMouseOut.listen((event) => scope.$apply(() {
      onMouseOut({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-mouseover]',
    map: const {'ng-mouseover': '&.onMouseOver'}
)
class NgMouseOverAttrDirective {
  Getter onMouseOver;

  NgMouseOverAttrDirective(dom.Element element, Scope scope) {
    element.onMouseOver.listen((event) => scope.$apply(() {
      onMouseOver({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-mouseup]',
    map: const {'ng-mouseup': '&.onMouseUp'}
)
class NgMouseUpAttrDirective {
  Getter onMouseUp;

  NgMouseUpAttrDirective(dom.Element element, Scope scope) {
    element.onMouseUp.listen((event) => scope.$apply(() {
      onMouseUp({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-mousewheel]',
    map: const {'ng-mousewheel': '&.onMouseWheel'}
)
class NgMouseWheelAttrDirective {
  Getter onMouseWheel;

  NgMouseWheelAttrDirective(dom.Element element, Scope scope) {
    element.onMouseWheel.listen((event) => scope.$apply(() {
      onMouseWheel({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-scroll]',
    map: const {'ng-scroll': '&.onScroll'}
)
class NgScrollAttrDirective {
  Getter onScroll;

  NgScrollAttrDirective(dom.Element element, Scope scope) {
    element.onScroll.listen((event) => scope.$apply(() {
      onScroll({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-touchcancel]',
    map: const {'ng-touchcancel': '&.onTouchCancel'}
)
class NgTouchCancelAttrDirective {
  Getter onTouchCancel;

  NgTouchCancelAttrDirective(dom.Element element, Scope scope) {
    element.onTouchCancel.listen((event) => scope.$apply(() {
      onTouchCancel({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-touchend]',
    map: const {'ng-touchend': '&.onTouchEnd'}
)
class NgTouchEndAttrDirective {
  Getter onTouchEnd;

  NgTouchEndAttrDirective(dom.Element element, Scope scope) {
    element.onTouchEnd.listen((event) => scope.$apply(() {
      onTouchEnd({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-touchmove]',
    map: const {'ng-touchmove': '&.onTouchMove'}
)
class NgTouchMoveAttrDirective {
  Getter onTouchMove;

  NgTouchMoveAttrDirective(dom.Element element, Scope scope) {
    element.onTouchMove.listen((event) => scope.$apply(() {
      onTouchMove({r"$event": event});
    }));
  }
}


@NgDirective(
    selector: '[ng-touchstart]',
    map: const {'ng-touchstart': '&.onTouchStart'}
)
class NgTouchStartAttrDirective {
  Getter onTouchStart;

  NgTouchStartAttrDirective(dom.Element element, Scope scope) {
    element.onTouchStart.listen((event) => scope.$apply(() {
      onTouchStart({r"$event": event});
    }));
  }
}