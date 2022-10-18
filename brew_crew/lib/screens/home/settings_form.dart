import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/models/user.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName = '';
  String _currentSugars = '0';
  int _currentStrength = 100;

  @override
  Widget build(BuildContext context) {

    myUser user = Provider.of<myUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        print(snapshot.error);
        if (snapshot.hasData) {

          UserData? userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Text(
                  'Update your brew settings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData!.name,
                  decoration: TextInputDecoration,
                  validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField(
                  decoration: TextInputDecoration,
                  value: _currentSugars ?? userData.sugars,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars')
                    );
                  }).toList(),
                  onChanged: (sugar) {
                    setState(() {
                      _currentSugars = sugar! ?? '0';
                    });
                  },
                ),
                Slider(
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (value) => setState(() {
                    _currentStrength = value.round();
                  }),
                  value: (_currentStrength ?? userData.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength],
                  inactiveColor: Colors.brown[_currentStrength],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[400]),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars,
                          _currentName,
                          _currentStrength,
                        );
                        Navigator.pop(context);
                      }
                    }
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
