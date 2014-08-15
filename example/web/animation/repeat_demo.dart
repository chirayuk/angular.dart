part of animation;

@Component(
    selector: 'repeat-demo',
    useShadowDom: false,
    templateUrl: 'repeat_demo.html',
    // templateUrl: 'animation/repeat_demo.html',
    publishAs: 'ctrl',
    applyAuthorStyles: true)
class RepeatDemo {
  var thing = 0;
  final items = [];

  void addItem() {
    items.add("Thing ${thing++}");
  }

  void removeItem() {
    if (items.isNotEmpty) items.removeLast();
  }
}
