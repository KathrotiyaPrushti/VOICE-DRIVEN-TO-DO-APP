import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_exam/providers/task_provider.dart';
import 'package:project_exam/services/voice_service.dart';
import 'package:project_exam/services/auth_service.dart';
import 'package:project_exam/widgets/task_list.dart';
import 'package:project_exam/widgets/voice_button.dart';
import 'package:project_exam/models/task.dart';
import 'package:project_exam/widgets/voice_input_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VoiceService _voiceService;
  bool _isInitialized = false;
  final TextEditingController _textController = TextEditingController();
  String _currentTranscription = '';

  @override
  void initState() {
    super.initState();
    _initializeVoiceService();
  }

  Future<void> _initializeVoiceService() async {
    _voiceService = context.read<VoiceService>();
    _isInitialized = await _voiceService.initialize();
    setState(() {});
  }

  void _handleVoiceCommand(String command) {
    setState(() {
      _currentTranscription = command;
      _textController.text = command;
    });
    final taskProvider = context.read<TaskProvider>();
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.startsWith('add')) {
      final taskTitle = command.substring(3).trim();
      if (taskTitle.isNotEmpty) {
        taskProvider.addTask(taskTitle);
        _voiceService.speak('Task added: $taskTitle');
        setState(() {
          _currentTranscription = '';
          _textController.clear();
        });
      }
    } else if (lowerCommand.startsWith('complete')) {
      final taskTitle = command.substring(8).trim();
      final task = taskProvider.tasks.firstWhere(
        (t) => t.title.toLowerCase().contains(taskTitle.toLowerCase()),
        orElse: () => Task(
          id: '',
          title: '',
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      );
      if (task.id.isNotEmpty) {
        taskProvider.toggleTaskCompletion(task.id);
        _voiceService.speak('Task completed: ${task.title}');
        setState(() {
          _currentTranscription = '';
          _textController.clear();
        });
      }
    } else if (lowerCommand.startsWith('delete')) {
      final taskTitle = command.substring(6).trim();
      final task = taskProvider.tasks.firstWhere(
        (t) => t.title.toLowerCase().contains(taskTitle.toLowerCase()),
        orElse: () => Task(
          id: '',
          title: '',
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      );
      if (task.id.isNotEmpty) {
        taskProvider.deleteTask(task.id);
        _voiceService.speak('Task deleted: ${task.title}');
        setState(() {
          _currentTranscription = '';
          _textController.clear();
        });
      }
    } else {
      _voiceService.speak('I didn\'t understand that command. Please try again.');
    }
  }

  void _handleSubmit() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<TaskProvider>().addTask(text);
      _voiceService.speak('Task added: $text');
      setState(() {
        _currentTranscription = '';
        _textController.clear();
      });
    }
  }

  Future<void> _logout() async {
    await context.read<AuthService>().logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice To-Do'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return TaskList(
                    tasks: taskProvider.tasks,
                    onTaskComplete: taskProvider.toggleTaskCompletion,
                    onTaskDelete: taskProvider.deleteTask,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'What are you doing?',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      onPressed: _handleSubmit,
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const VoiceInputButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 