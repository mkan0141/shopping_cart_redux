import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shopping_app/redux/state/model.dart';
import 'package:shopping_app/redux/actions/actions.dart';
import 'package:shopping_app/redux/reducers/reducers.dart';

void main() {
  final store = new Store<List<CartItem>>(
    cartItemsReducer,
    initialState: new List(),
  );
  runApp(ShoppingApp(store));
}

class ShoppingApp extends StatelessWidget {
  final Store<List<CartItem>> store;

  ShoppingApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(store: store, child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingCart(store),
    ));
  }
}

class ShoppingCart extends StatelessWidget {
  final Store<List<CartItem>> store;

  ShoppingCart(this.store);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Shopping Cart"),
      ),
      body: new ShoppingList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: () => _openAddItemDialog(context),
        child: new Icon(Icons.add),
      ),
    );
  }

  _openAddItemDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => new AddItemDialog());
  }

}


class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<CartItem>, List<CartItem>>(
      converter: (store) => store.state,
      builder: (context, list) => new ListView.builder(
        itemBuilder: (context, i) => new ShoppingItem(list[i]),
        itemCount: list.length,
      )
    );
  }
}

class ShoppingItem extends StatefulWidget {
  final CartItem item;

  ShoppingItem(this.item);

  @override
  ShoppingItemState createState() => new ShoppingItemState();
}

typedef OnItemDelete = Function(CartItem item);
typedef OnToggleStateItemAction = Function(CartItem item);

class ShoppingItemState extends State<ShoppingItem> {
  @override
  Widget build(BuildContext context) {
    return new  StoreConnector<List<CartItem>, OnItemDelete>(
      converter: (store) => (item) => store.dispatch(DeleteItemAction(item)),
      builder: (context, callback) => Dismissible(
        onDismissed: (_) { setState(() {
          callback(widget.item);
        }); },
        key: new Key(widget.item.name),
        child: new StoreConnector<List<CartItem>, OnToggleStateItemAction>(
          converter: (store) => (item) => store.dispatch(ToggleStateItemAction(item)),
          builder: (context, callback) => ListTile(
            title: new Text(widget.item.name),
            leading: new Checkbox(
              value: widget.item.checked,
              onChanged: (value){
                print(value);
                setState((){
                  callback(CartItem(name: widget.item.name, checked: value));
                });
              }
            )
          ),
        ),
      ),
    );
  }
}


typedef OnItemCallback = Function(String itemName);

class AddItemDialog extends StatefulWidget {
  @override
  AddItemDialogState createState() => new AddItemDialogState();
}


class AddItemDialogState extends State<AddItemDialog> {
  String itemName;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<List<CartItem>, OnItemCallback>(
      converter: (store) => (itemName) => store.dispatch(AddItemAction(CartItem(name: itemName, checked: false))),
      builder: (context, callback) =>
          AlertDialog(
            title: new Text("Add Item"),
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: "Item Name",
                          hintText: "Eg. iPhone"
                      ),
                      onChanged: (value) {
                        setState(() {
                          itemName = value;
                        });
                      },
                    )
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () { Navigator.of(context).pop(); },
                  child: new Text("Cancel")
              ),
              new FlatButton(
                  onPressed: () { callback(itemName); Navigator.of(context).pop(); },
                  child: new Text("Add")
              )
            ],
          )
    );

  }
}