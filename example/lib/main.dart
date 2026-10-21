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
              DegreePickerField(
                decoration: const InputDecoration(
                  labelText: 'Degree (dialog, India, custom allowed)',
                  border: OutlineInputBorder(),
                ),
                config: const DegreePickerConfig(
                  mode: DegreePickerMode.dialog,
                  countries: {'IN'},
                  allowCustom: true,
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
