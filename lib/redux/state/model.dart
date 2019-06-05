import 'package:meta/meta.dart';

@immutable
class AppState {
  final int counter;

  AppState({
    this.counter
  });
}

class CartItem {
  String name;
  bool checked;

  CartItem({
    @required this.name,
    @required this.checked,
  });
}