# خطة تنفيذ نظام المسابقة العالمية

## الأهداف

- نظام مسابقة عالمية بين المجاميع
- تصفيات متعددة المراحل
- فائز واحد على مستوى العالم
- نظام توقيتات ذكي
- تكامل كامل مع Cloudflare

---

## Phase 1: البنية الأساسية (أسبوعان)

### 1.1 Tournament Entities

**الملفات:**
- `lib/features/tournament/domain/entities/tournament.dart`
- `lib/features/tournament/domain/entities/tournament_stage.dart`
- `lib/features/tournament/domain/entities/match.dart`
- `lib/features/tournament/domain/entities/team.dart`
- `lib/features/tournament/domain/entities/bracket.dart`

### 1.2 Tournament Repository

**الملفات:**
- `lib/features/tournament/domain/repositories/tournament_repository_interface.dart`
- `lib/features/tournament/data/repositories/tournament_repository.dart`

### 1.3 Tournament BLoC

**الملفات:**
- `lib/features/tournament/presentation/bloc/tournament_bloc.dart`
- `lib/features/tournament/presentation/bloc/tournament_event.dart`
- `lib/features/tournament/presentation/bloc/tournament_state.dart`

---

## Phase 2: Bracket System (أسبوعان)

### 2.1 Bracket Algorithms

**الملفات:**
- `lib/features/tournament/domain/services/bracket_algorithm.dart`
- `lib/features/tournament/domain/services/single_elimination_bracket.dart`
- `lib/features/tournament/domain/services/double_elimination_bracket.dart`
- `lib/features/tournament/domain/services/swiss_system_bracket.dart`
- `lib/features/tournament/domain/services/round_robin_bracket.dart`

### 2.2 Bracket Visualization

**الملفات:**
- `lib/features/tournament/presentation/widgets/bracket_viewer.dart`
- `lib/features/tournament/presentation/widgets/match_node.dart`
- `lib/features/tournament/presentation/widgets/team_card.dart`

---

## Phase 3: Match Management (أسبوعان)

### 3.1 Match Scheduler

**الملفات:**
- `lib/features/tournament/domain/services/match_scheduler.dart`
- `lib/features/tournament/domain/services/timezone_manager.dart`
- `lib/features/tournament/domain/services/notification_service.dart`

### 3.2 Match UI

**الملفات:**
- `lib/features/tournament/presentation/screens/match_screen.dart`
- `lib/features/tournament/presentation/widgets/match_card.dart`
- `lib/features/tournament/presentation/widgets/game_score_card.dart`

---

## Phase 4: Cloudflare Integration (أسبوع)

### 4.1 Tournament Room

**الملفات:**
- `backend/src/TournamentRoom.ts` - Durable Object لإدارة البطولة

### 4.2 Match Room Integration

**الملفات:**
- تحديث `backend/src/GameRoom.ts` لدعم Tournament matches

### 4.3 Flutter Service

**الملفات:**
- `lib/features/tournament/data/services/tournament_service.dart`
- تحديث `lib/features/multiplayer/data/services/cloudflare_multiplayer_service.dart`

---

## Phase 5: UI & Polish (أسبوع)

### 5.1 Tournament Dashboard

**الملفات:**
- `lib/features/tournament/presentation/screens/tournament_dashboard.dart`
- `lib/features/tournament/presentation/widgets/tournament_card.dart`
- `lib/features/tournament/presentation/widgets/stage_indicator.dart`

### 5.2 Registration & Team Management

**الملفات:**
- `lib/features/tournament/presentation/screens/tournament_registration_screen.dart`
- `lib/features/tournament/presentation/screens/team_management_screen.dart`

---

## نظام التحديات المقترح

### المرحلة 1: التصفيات الأولية (Qualifiers)
- **النظام**: Swiss System
- **عدد الجولات**: 5 جولات
- **المدة**: أسبوع واحد
- **التأهل**: أعلى 64 فريق
- **نظام المباراة**: Best of 3

### المرحلة 2: التصفيات النهائية (Playoffs)
- **النظام**: Single Elimination
- **المراحل**:
  - Round of 64: Best of 3
  - Round of 32: Best of 3
  - Round of 16: Best of 5
  - Quarter Finals: Best of 5
  - Semi Finals: Best of 5
  - Final: Best of 7
- **المدة**: أسبوعان

### المرحلة 3: النهائي الكبير (Grand Final)
- **النظام**: Best of 7
- **المدة**: يوم واحد
- **الفائز**: بطل العالم

---

## نظام التوقيتات

### Time Zone Management
- تحديد توقيت كل فريق تلقائياً
- تحويل جميع الأوقات إلى UTC
- عرض محلي لكل فريق

### Flexible Scheduling
- كل فريق يختار 3 أوقات مناسبة
- مطابقة تلقائية بين الفرق
- إعادة جدولة حتى 24 ساعة قبل

### Notifications
- 24 ساعة قبل المباراة
- 1 ساعة قبل
- 15 دقيقة قبل
- بدء المباراة

---

## Timeline الإجمالي

- **Phase 1**: أسبوعان
- **Phase 2**: أسبوعان
- **Phase 3**: أسبوعان
- **Phase 4**: أسبوع
- **Phase 5**: أسبوع

**الإجمالي**: 8 أسابيع (شهران)

---

## الملفات الرئيسية

### Flutter (Frontend)
1. Tournament entities (5 ملفات)
2. Tournament repository (2 ملفات)
3. Tournament BLoC (3 ملفات)
4. Bracket algorithms (4 ملفات)
5. Match scheduler (3 ملفات)
6. Tournament UI (10+ ملفات)

### Backend (Cloudflare)
1. `backend/src/TournamentRoom.ts`
2. تحديث `backend/src/GameRoom.ts`

**الإجمالي**: ~30 ملف جديد

