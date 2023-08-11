import 'package:firebaseflutterproject/stateManagement/provider/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class DarkTheme extends StatefulWidget {
  const DarkTheme({Key? key}) : super(key: key);

  @override
  State<DarkTheme> createState() => _DarkThemeState();
}

class _DarkThemeState extends State<DarkTheme> {
  @override
  Widget build(BuildContext context) {
    final themeChanger=Provider.of<ThemeProvider>(context);
    return Scaffold(
       appBar: AppBar(title: Text("THEME CHANGE"),),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Text("Light Mode"),
              value: ThemeMode.light,
              groupValue: themeChanger.themeMode,
              onChanged: themeChanger.setTheme
          ),

RadioListTile<ThemeMode>(
            title: Text("DARK Mode"),
              value: ThemeMode.dark,
              groupValue: themeChanger.themeMode,
              onChanged: themeChanger.setTheme
          ),

           RadioListTile<ThemeMode>(
            title: Text("System Mode"),
              value: ThemeMode.system,
              groupValue: themeChanger.themeMode,
              onChanged: themeChanger.setTheme
          ),

          ElevatedButton(onPressed: (){}, child: Text("${themeChanger.themeMode}")),
          Icon(Icons.add)

        ],
      ),
    );
  }
}
