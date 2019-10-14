import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer/models/Workout.dart';
import 'package:workout_timer/provider/WorkoutListProvider.dart';

class AddWorkout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddWorkoutState();
}


class _AddWorkoutState extends State<AddWorkout>{

  final _formKey = GlobalKey<FormState>();
  final _workout = Workout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workout'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: TextFormField(
                  autofocus: true,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Workout Name'
                  ),
                  onSaved: (val) => setState(() => _workout.name = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      Provider.of<WorkoutListProvider>(context).addWorkout(_workout);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}