library my_prj.globals;
import 'package:shared_preferences/shared_preferences.dart';

int countdownStartValue = 5;
int speakInterval = 5;
bool soundEnabled = true;
int lastSecondsInMonkimeter = 0;

void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      countdownStartValue = prefs.getInt('countdownStartValue') ?? 5;
      speakInterval = prefs.getInt('speakInterval') ?? 5;
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
  }



List<String> gripTypes = ['Barra', '4Fx40', '4Fx25', 'romo 22º', 'romo 12º'];
Future<void> loadGripTypes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedGripTypes = prefs.getStringList('gripTypes');
  if (savedGripTypes != null) {
    gripTypes = savedGripTypes;
  }
}
Future<void> saveGripTypes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('gripTypes', gripTypes);
}