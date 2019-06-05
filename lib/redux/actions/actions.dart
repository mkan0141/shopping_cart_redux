import 'package:shopping_app/redux/state/model.dart';

class AddItemAction {
  final CartItem item;

  AddItemAction(this.item);
}

class DeleteItemAction {
  final CartItem item;

  DeleteItemAction(this.item);
}

class ToggleStateItemAction {
  final CartItem item;

  ToggleStateItemAction(this.item);
}