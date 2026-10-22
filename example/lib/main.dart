import 'package:degree_picker/degree_picker.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const Demo(),
      );
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('degree_picker')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DegreePickerField(
                validator: (d) => d == null ? 'Please select a degree' : null,
                decoration: const InputDecoration(
                  labelText: 'Highest degree',
                  border: OutlineInputBorder(),
                ),
                config: const DegreePickerConfig(allowClear: true),
              ),
              const SizedBox(height: 16),
              const DegreePickerField(
                decoration: InputDecoration(
                  labelText:
                      'Degree (dialog, master/doctorate, custom allowed)',
                  border: OutlineInputBorder(),
                ),
                config: DegreePickerConfig(
                  mode: DegreePickerMode.dialog,
                  levels: {DegreeLevel.master, DegreeLevel.doctorate},
                  allowCustom: true,
                ),
              ),
              const SizedBox(height: 16),
              DegreePickerField(
                decoration: const InputDecoration(
                  labelText: 'Degree (custom style)',
                  border: OutlineInputBorder(),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                config: DegreePickerConfig(
                  title: 'Your qualification',
                  style: DegreePickerStyle(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    titleStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                    selectedColor: Colors.indigo,
                    selectedTileColor: Colors.indigo.shade50,
                    showDividers: true,
                    searchDecoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.indigo.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => _formKey.currentState!.validate(),
                child: const Text('Validate'),
              ),
            ],
          ),
        ),
      );
}
