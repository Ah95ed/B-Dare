import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tournament.dart';
import '../bloc/tournament_bloc.dart';
import '../bloc/tournament_event.dart';
import '../bloc/tournament_state.dart';
import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/constants/tournament_constants.dart';

/// Enum for tournament sizes
enum TournamentSize {
  small(32, 'بطولة سريعة', 'يوم واحد', '5-10 ساعات'),
  medium(64, 'بطولة متوسطة', 'يومان', '11-22 ساعة'),
  large(128, 'بطولة كبيرة', '3-4 أيام', '14-21 ساعة');

  final int teamCount;
  final String label;
  final String duration;
  final String estimatedTime;

  const TournamentSize(
    this.teamCount,
    this.label,
    this.duration,
    this.estimatedTime,
  );
}

/// شاشة إنشاء بطولة جديدة
class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prizePoolController = TextEditingController();

  TournamentType _selectedType = TournamentType.singleElimination;
  int _maxTeams = 64; // Default: Medium tournament
  TournamentSize _selectedSize = TournamentSize.medium;
  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  DateTime _registrationStartDate = DateTime.now();
  DateTime _registrationEndDate = DateTime.now().add(const Duration(days: 6));

  // Settings
  final int _minTeamsPerMatch = 2;
  final int _maxTeamsPerMatch = 2;
  int _matchDurationMinutes = 30;
  int _breakBetweenMatchesMinutes = 5;
  bool _allowRescheduling = true;
  int _reschedulingDeadlineHours = 24;
  bool _autoForfeitEnabled = true;
  int _autoForfeitMinutes = 15;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _prizePoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء بطولة جديدة'),
      ),
      body: BlocConsumer<TournamentBloc, TournamentState>(
        listener: (context, state) {
          if (state is TournamentUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء البطولة بنجاح!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, state.tournament);
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
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Basic Information
                  _buildSectionHeader('المعلومات الأساسية'),
                  const SizedBox(height: 16),

                  // Tournament Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم البطولة *',
                      hintText: 'أدخل اسم البطولة',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.emoji_events),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال اسم البطولة';
                      }
                      if (value.length < 3) {
                        return 'اسم البطولة يجب أن يكون 3 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'الوصف',
                      hintText: 'وصف البطولة (اختياري)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),

                  // Tournament Size Selection
                  _buildSectionHeader('حجم البطولة'),
                  const SizedBox(height: 8),
                  _buildTournamentSizeSelector(),

                  const SizedBox(height: 16),

                  // Tournament Type (Auto-suggested based on size)
                  _buildSectionHeader('نوع البطولة'),
                  const SizedBox(height: 8),
                  _buildTournamentTypeSelector(),

                  // Tournament Info Card
                  const SizedBox(height: 16),
                  _buildTournamentInfoCard(),

                  const SizedBox(height: 24),

                  // Dates
                  _buildSectionHeader('التواريخ'),
                  const SizedBox(height: 16),

                  // Registration Start Date
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('بداية التسجيل'),
                    subtitle: Text(_formatDate(_registrationStartDate)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _registrationStartDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _registrationStartDate = date;
                        });
                      }
                    },
                  ),

                  // Registration End Date
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('نهاية التسجيل'),
                    subtitle: Text(_formatDate(_registrationEndDate)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _registrationEndDate,
                        firstDate: _registrationStartDate,
                        lastDate: _startDate,
                      );
                      if (date != null) {
                        setState(() {
                          _registrationEndDate = date;
                        });
                      }
                    },
                  ),

                  // Tournament Start Date
                  ListTile(
                    leading: const Icon(Icons.play_circle),
                    title: const Text('بداية البطولة'),
                    subtitle: Text(_formatDate(_startDate)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: _registrationEndDate,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                          if (_endDate.isBefore(_startDate)) {
                            _endDate = _startDate.add(const Duration(days: 30));
                          }
                        });
                      }
                    },
                  ),

                  // Tournament End Date
                  ListTile(
                    leading: const Icon(Icons.check_circle),
                    title: const Text('نهاية البطولة'),
                    subtitle: Text(_formatDate(_endDate)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: _startDate,
                        lastDate: DateTime.now().add(const Duration(days: 730)),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  // Prize Pool
                  _buildSectionHeader('الجوائز (اختياري)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _prizePoolController,
                    decoration: const InputDecoration(
                      labelText: 'قيمة الجوائز',
                      hintText: 'مثال: 10,000 ريال',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monetization_on),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Advanced Settings (Collapsible)
                  _buildAdvancedSettings(),

                  const SizedBox(height: 32),

                  // Create Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _createTournament();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.accent,
                    ),
                    child: const Text(
                      'إنشاء البطولة',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
    );
  }

  Widget _buildTournamentSizeSelector() {
    return SegmentedButton<TournamentSize>(
      segments: [
        ButtonSegment<TournamentSize>(
          value: TournamentSize.small,
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${TournamentSize.small.teamCount}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                TournamentSize.small.label,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          icon: const Icon(Icons.flash_on),
        ),
        ButtonSegment<TournamentSize>(
          value: TournamentSize.medium,
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${TournamentSize.medium.teamCount}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                TournamentSize.medium.label,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          icon: const Icon(Icons.people),
        ),
        ButtonSegment<TournamentSize>(
          value: TournamentSize.large,
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${TournamentSize.large.teamCount}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                TournamentSize.large.label,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          icon: const Icon(Icons.stars),
        ),
      ],
      selected: <TournamentSize>{_selectedSize},
      onSelectionChanged: (Set<TournamentSize> newSelection) {
        setState(() {
          _selectedSize = newSelection.first;
          _maxTeams = _selectedSize.teamCount;
          // Auto-update tournament type based on size
          _updateTournamentTypeForSize();
          // Auto-update dates based on size
          _updateDatesForSize();
        });
      },
      style: SegmentedButton.styleFrom(
        foregroundColor: AppColors.accent,
        selectedForegroundColor: AppColors.primary,
        selectedBackgroundColor: AppColors.accent.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildTournamentTypeSelector() {
    return SegmentedButton<TournamentType>(
      segments: const [
        ButtonSegment<TournamentType>(
          value: TournamentType.singleElimination,
          label: Text('إقصاء فردي'),
          icon: Icon(Icons.trending_down),
        ),
        ButtonSegment<TournamentType>(
          value: TournamentType.doubleElimination,
          label: Text('إقصاء مزدوج'),
          icon: Icon(Icons.swap_horiz),
        ),
        ButtonSegment<TournamentType>(
          value: TournamentType.swiss,
          label: Text('سويسري'),
          icon: Icon(Icons.grid_view),
        ),
        ButtonSegment<TournamentType>(
          value: TournamentType.roundRobin,
          label: Text('دوري'),
          icon: Icon(Icons.refresh),
        ),
      ],
      selected: <TournamentType>{_selectedType},
      onSelectionChanged: (Set<TournamentType> newSelection) {
        setState(() {
          _selectedType = newSelection.first;
        });
      },
      style: SegmentedButton.styleFrom(
        foregroundColor: AppColors.accent,
        selectedForegroundColor: AppColors.primary,
        selectedBackgroundColor: AppColors.accent.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildTournamentInfoCard() {
    final recommendation =
        TournamentConstants.getRecommendationForTeamCount(_maxTeams);
    final rounds = _getRoundsForType(_selectedType, _maxTeams);
    final estimatedDuration = _getEstimatedDuration(_selectedType, _maxTeams);

    return Card(
      elevation: 2,
      color: AppColors.accent.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'معلومات البطولة',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('عدد الفرق', '$_maxTeams فريق'),
            const SizedBox(height: 8),
            _buildInfoRow('عدد الجولات', '$rounds جولة'),
            const SizedBox(height: 8),
            _buildInfoRow('المدة المتوقعة', estimatedDuration),
            const SizedBox(height: 8),
            _buildInfoRow('النوع المقترح', _getTypeName(recommendation.type)),
            if (_selectedType != recommendation.type) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        size: 16, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'نصيحة: ${_getTypeName(recommendation.type)} مناسب أكثر لهذا الحجم',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.accent.withValues(alpha: 0.7),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }

  void _updateTournamentTypeForSize() {
    final recommendation =
        TournamentConstants.getRecommendationForTeamCount(_maxTeams);
    _selectedType = recommendation.type;
  }

  void _updateDatesForSize() {
    final recommendation =
        TournamentConstants.getRecommendationForTeamCount(_maxTeams);
    final days = recommendation.days;

    // Update end date based on tournament duration
    _endDate = _startDate.add(Duration(days: days));

    // Update registration end date (should be before tournament start)
    _registrationEndDate = _startDate.subtract(const Duration(days: 1));

    // Update match duration based on recommendation
    if (_maxTeams <= 32) {
      _matchDurationMinutes = 25; // Quick matches for small tournaments
    } else if (_maxTeams <= 64) {
      _matchDurationMinutes = 30; // Standard matches
    } else {
      _matchDurationMinutes = 35; // Longer matches for large tournaments
    }
  }

  int _getRoundsForType(TournamentType type, int teamCount) {
    switch (type) {
      case TournamentType.singleElimination:
        return TournamentConstants.calculateSingleEliminationRounds(teamCount);
      case TournamentType.doubleElimination:
        return TournamentConstants.calculateDoubleEliminationWinnersRounds(
                teamCount) +
            TournamentConstants.calculateDoubleEliminationLosersRounds(
                teamCount);
      case TournamentType.swiss:
        return TournamentConstants.calculateSwissSystemRounds(teamCount);
      case TournamentType.roundRobin:
        return TournamentConstants.calculateRoundRobinRounds(teamCount);
    }
  }

  String _getEstimatedDuration(TournamentType type, int teamCount) {
    final recommendation =
        TournamentConstants.getRecommendationForTeamCount(teamCount);
    final hours = recommendation.estimatedDuration;

    if (hours < 12) {
      return '${hours.toStringAsFixed(1)} ساعة (${recommendation.days} يوم)';
    } else if (hours < 24) {
      return '${hours.toStringAsFixed(1)} ساعة (${recommendation.days} يوم)';
    } else {
      final days = (hours / 24).ceil();
      return '$days أيام';
    }
  }

  String _getTypeName(TournamentType type) {
    switch (type) {
      case TournamentType.singleElimination:
        return 'إقصاء فردي';
      case TournamentType.doubleElimination:
        return 'إقصاء مزدوج';
      case TournamentType.swiss:
        return 'نظام سويسري';
      case TournamentType.roundRobin:
        return 'دوري دائري';
    }
  }

  Widget _buildAdvancedSettings() {
    return ExpansionTile(
      title: const Text('الإعدادات المتقدمة'),
      leading: const Icon(Icons.settings),
      children: [
        // Match Duration
        ListTile(
          leading: const Icon(Icons.timer),
          title: Text('مدة المباراة: $_matchDurationMinutes دقيقة'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_matchDurationMinutes > 5) {
                      _matchDurationMinutes -= 5;
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (_matchDurationMinutes < 120) {
                      _matchDurationMinutes += 5;
                    }
                  });
                },
              ),
            ],
          ),
        ),

        // Break Between Matches
        ListTile(
          leading: const Icon(Icons.pause),
          title: Text(
              'الاستراحة بين المباريات: $_breakBetweenMatchesMinutes دقيقة'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (_breakBetweenMatchesMinutes > 0) {
                      _breakBetweenMatchesMinutes -= 1;
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (_breakBetweenMatchesMinutes < 30) {
                      _breakBetweenMatchesMinutes += 1;
                    }
                  });
                },
              ),
            ],
          ),
        ),

        // Allow Rescheduling
        SwitchListTile(
          title: const Text('السماح بإعادة الجدولة'),
          subtitle: const Text('يمكن للفرق طلب إعادة جدولة المباريات'),
          value: _allowRescheduling,
          onChanged: (value) {
            setState(() {
              _allowRescheduling = value;
            });
          },
        ),

        // Rescheduling Deadline
        if (_allowRescheduling)
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(
                'موعد نهائي لإعادة الجدولة: $_reschedulingDeadlineHours ساعة'),
            subtitle: const Text('قبل المباراة'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_reschedulingDeadlineHours > 1) {
                        _reschedulingDeadlineHours -= 1;
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (_reschedulingDeadlineHours < 168) {
                        _reschedulingDeadlineHours += 1;
                      }
                    });
                  },
                ),
              ],
            ),
          ),

        // Auto Forfeit
        SwitchListTile(
          title: const Text('إلغاء تلقائي'),
          subtitle: const Text('إلغاء المباراة تلقائياً عند التأخير'),
          value: _autoForfeitEnabled,
          onChanged: (value) {
            setState(() {
              _autoForfeitEnabled = value;
            });
          },
        ),

        // Auto Forfeit Minutes
        if (_autoForfeitEnabled)
          ListTile(
            leading: const Icon(Icons.timer_off),
            title: Text('دقائق التأخير: $_autoForfeitMinutes'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_autoForfeitMinutes > 5) {
                        _autoForfeitMinutes -= 5;
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (_autoForfeitMinutes < 60) {
                        _autoForfeitMinutes += 5;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _createTournament() {
    final tournament = Tournament(
      id: 'tournament_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text,
      description: _descriptionController.text,
      type: _selectedType,
      status: TournamentStatus.registration,
      startDate: _startDate,
      endDate: _endDate,
      registrationStartDate: _registrationStartDate,
      registrationEndDate: _registrationEndDate,
      maxTeams: _maxTeams,
      currentTeams: 0,
      settings: TournamentSettings(
        maxTeams: _maxTeams,
        minTeamsPerMatch: _minTeamsPerMatch,
        maxTeamsPerMatch: _maxTeamsPerMatch,
        matchDuration: Duration(minutes: _matchDurationMinutes),
        breakBetweenMatches: Duration(minutes: _breakBetweenMatchesMinutes),
        allowRescheduling: _allowRescheduling,
        reschedulingDeadlineHours: _reschedulingDeadlineHours,
        autoForfeitEnabled: _autoForfeitEnabled,
        autoForfeitMinutes: _autoForfeitMinutes,
      ),
      prizePool: _prizePoolController.text.isNotEmpty
          ? _prizePoolController.text
          : null,
      organizerId: 'current_user_id', // TODO: Get from auth
    );

    context.read<TournamentBloc>().add(CreateTournament(tournament));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
