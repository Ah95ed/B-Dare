import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tournament.dart';
import '../../domain/entities/team.dart';
import '../bloc/tournament_bloc.dart';
import '../bloc/tournament_event.dart';
import '../bloc/tournament_state.dart';
import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';

/// شاشة تسجيل فريق في بطولة
class TournamentRegistrationScreen extends StatefulWidget {
  final String tournamentId;

  const TournamentRegistrationScreen({
    super.key,
    required this.tournamentId,
  });

  @override
  State<TournamentRegistrationScreen> createState() =>
      _TournamentRegistrationScreenState();
}

class _TournamentRegistrationScreenState
    extends State<TournamentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  String _selectedTimeZone = 'UTC';
  final List<DateTime> _preferredTimeSlots = [];

  @override
  void initState() {
    super.initState();
    // جلب معلومات البطولة
    context.read<TournamentBloc>().add(
          FetchTournament(widget.tournamentId),
        );
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل فريق'),
      ),
      body: BlocConsumer<TournamentBloc, TournamentState>(
        listener: (context, state) {
          if (state is TeamRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تسجيل الفريق بنجاح!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else if (state is TournamentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TournamentLoading) {
            return const LoadingWidget();
          } else if (state is TournamentError) {
            return ErrorDisplayWidget(message: state.message);
          } else if (state is TournamentLoaded) {
            return _buildRegistrationForm(context, state.tournament);
          } else {
            return const Center(
              child: Text('جارٍ تحميل معلومات البطولة...'),
            );
          }
        },
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context, Tournament tournament) {
    if (!tournament.isRegistrationOpen) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'التسجيل غير متاح حالياً',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              tournament.status == TournamentStatus.completed
                  ? 'البطولة مكتملة'
                  : 'التسجيل لم يبدأ بعد',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    if (tournament.isFull) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'البطولة ممتلئة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'تم الوصول للحد الأقصى من الفرق',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tournament Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tournament.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${tournament.currentTeams}/${tournament.maxTeams} فريق',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Team Name
            TextFormField(
              controller: _teamNameController,
              decoration: const InputDecoration(
                labelText: 'اسم الفريق',
                hintText: 'أدخل اسم الفريق',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال اسم الفريق';
                }
                if (value.length < 3) {
                  return 'اسم الفريق يجب أن يكون 3 أحرف على الأقل';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Time Zone
            DropdownButtonFormField<String>(
              initialValue: _selectedTimeZone,
              decoration: const InputDecoration(
                labelText: 'التوقيت المحلي',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              items: const [
                DropdownMenuItem(value: 'UTC', child: Text('UTC')),
                DropdownMenuItem(
                    value: 'Asia/Riyadh', child: Text('الرياض (GMT+3)')),
                DropdownMenuItem(
                    value: 'America/New_York', child: Text('نيويورك (GMT-5)')),
                DropdownMenuItem(
                    value: 'Europe/London', child: Text('لندن (GMT+0)')),
                DropdownMenuItem(
                    value: 'Asia/Tokyo', child: Text('طوكيو (GMT+9)')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTimeZone = value!;
                });
              },
            ),

            const SizedBox(height: 24),

            // Preferred Time Slots
            Text(
              'الأوقات المفضلة (اختر 3 أوقات)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم استخدام هذه الأوقات لمطابقة المباريات',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),

            // Time Slot Buttons
            ...List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          if (_preferredTimeSlots.length > index) {
                            _preferredTimeSlots[index] = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          } else {
                            _preferredTimeSlots.add(DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            ));
                          }
                        });
                      }
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _preferredTimeSlots.length > index
                        ? _formatDateTime(_preferredTimeSlots[index])
                        : 'اختر الوقت ${index + 1}',
                  ),
                ),
              );
            }),

            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_preferredTimeSlots.length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى اختيار 3 أوقات مفضلة'),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                    return;
                  }

                  final team = Team(
                    id: 'team_${DateTime.now().millisecondsSinceEpoch}',
                    name: _teamNameController.text,
                    captainId: 'current_user_id', // TODO: Get from auth
                    memberIds: const ['current_user_id'], // TODO: Get from auth
                    timeZone: _selectedTimeZone,
                    preferredTimeSlots: _preferredTimeSlots,
                    registeredAt: DateTime.now(),
                  );

                  context.read<TournamentBloc>().add(
                        RegisterTeam(
                          tournamentId: widget.tournamentId,
                          team: team,
                        ),
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.accent,
              ),
              child: const Text('تسجيل الفريق'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
