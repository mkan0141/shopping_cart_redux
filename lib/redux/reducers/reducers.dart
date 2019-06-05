import 'package:shopping_app/redux/actions/actions.dart';
import 'package:shopping_app/redux/state/model.dart';

AppState appReducers(AppState state, action) {
  return new AppState(
    //counter: counterReducer(state.counter, action),
  );
}

List<CartItem>  cartItemsReducer(List<CartItem> items, action) {
  if(action is AddItemAction) {
    return addItem(items, action);
  } else if(action is DeleteItemAction) {
    return  deleteItem(items, action);
  } else if(action is ToggleStateItemAction) {
    return toggleItem(items, action);
  }
  return items;
}


List<CartItem> addItem(List<CartItem> items, AddItemAction action) {
  return new List.from(items)..add(action.item);
}

List<CartItem> deleteItem(List<CartItem> items, DeleteItemAction action) {
  return new List.from(items)..remove(action.item);
}

List<CartItem> toggleItem(List<CartItem> items, ToggleStateItemAction action) {
  return items.map((item) => item.name == action.item.name ? action.item : item).toList();
}