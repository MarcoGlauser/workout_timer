import 'package:flutter/material.dart';

class AddSubtract extends StatelessWidget {
  final Widget child;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;
  final bool showAdd;
  final bool showSubtract;

  const AddSubtract(
      {Key key,
      this.child,
      this.onAdd,
      this.onSubtract,
      this.showAdd: true,
      this.showSubtract: true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Icon(Icons.remove),
          onPressed: onSubtract,
        ),
        child,
        MaterialButton(
          child: Icon(Icons.add),
          onPressed: onAdd,

          elevation: 5,
        ),
      ],
    );
  }
}
