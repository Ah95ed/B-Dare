# نظام المسابقة العالمية - Global Tournament System

## نظرة عامة

نظام مسابقة عالمية بين المجاميع يتضمن:
- **التصفيات**: نظام تصفيات متعدد المراحل
- **البطولة النهائية**: فائز واحد على مستوى العالم
- **التحديات**: نظام جولات ومراحل متقدم
- **التوقيتات**: إدارة ذكية للوقت والتوقيتات العالمية

---

## أحدث الممارسات 2025

### 1. أنظمة التصفيات (Bracket Systems)

#### أ. Single Elimination (الإقصاء الفردي)
- **الاستخدام**: البطولات السريعة، عدد كبير من الفرق
- **المزايا**: سريع، بسيط، دراماتيكي
- **العيوب**: خطأ واحد = خروج
- **مثال**: كأس العالم FIFA

#### ب. Double Elimination (الإقصاء المزدوج)
- **الاستخدام**: البطولات الكبرى، عدالة أكبر
- **المزايا**: فرصة ثانية، أكثر عدالة
- **العيوب**: أطول، أكثر تعقيداً
- **مثال**: بطولات Esports الكبرى

#### ج. Swiss System (النظام السويسري)
- **الاستخدام**: عدد كبير من الفرق، عدالة قصوى
- **المزايا**: كل فريق يلعب نفس العدد من المباريات
- **العيوب**: معقد، يحتاج خوارزمية متقدمة
- **مثال**: بطولات الشطرنج العالمية

#### د. Round-Robin (الدور الدائري)
- **الاستخدام**: مجموعات صغيرة، عدالة قصوى
- **المزايا**: كل فريق يواجه كل الفرق
- **العيوب**: طويل جداً للعدد الكبير
- **مثال**: دوري كرة القدم

### 2. نظام الجولات والمراحل (2025)

#### المرحلة 1: التصفيات الأولية (Qualifiers)
- **عدد الجولات**: 3-5 جولات
- **المدة**: أسبوع واحد
- **النظام**: Swiss System أو Round-Robin
- **التأهل**: أعلى 64-128 فريق

#### المرحلة 2: التصفيات النهائية (Playoffs)
- **عدد الجولات**: 6-7 جولات (64 → 32 → 16 → 8 → 4 → 2 → 1)
- **المدة**: أسبوعان
- **النظام**: Single Elimination
- **التأهل**: 64 فريق → 32 → 16 → 8 → 4 → 2 → 1

#### المرحلة 3: النهائي (Grand Final)
- **عدد الجولات**: 3-5 جولات (Best of 3/5)
- **المدة**: يوم واحد
- **النظام**: Best of Series
- **الفائز**: بطل العالم

### 3. نظام التحديات (Match Format)

#### أ. Best of 3 (أفضل 3)
- **3 جولات**: أول من يفوز جولتين يفوز
- **الاستخدام**: التصفيات، المراحل الأولى
- **المدة**: 15-30 دقيقة

#### ب. Best of 5 (أفضل 5)
- **5 جولات**: أول من يفوز 3 جولات يفوز
- **الاستخدام**: ربع النهائي، نصف النهائي
- **المدة**: 30-60 دقيقة

#### ج. Best of 7 (أفضل 7)
- **7 جولات**: أول من يفوز 4 جولات يفوز
- **الاستخدام**: النهائي الكبير
- **المدة**: 60-90 دقيقة

### 4. نظام التوقيتات (2025)

#### Time Zone Management
- **تحديد توقيت محلي**: لكل فريق
- **تحويل تلقائي**: إلى UTC
- **جدولة ذكية**: تجنب الأوقات غير المناسبة
- **إشعارات**: قبل المباراة بـ 24 ساعة، 1 ساعة، 15 دقيقة

#### Flexible Scheduling
- **نوافذ زمنية**: كل فريق يختار 3 أوقات مناسبة
- **مطابقة تلقائية**: بين الفرق
- **إعادة جدولة**: في حالات الطوارئ
- **Auto-forfeit**: بعد 15 دقيقة تأخير

---

## التصميم المعماري

### 1. Tournament Entity

```dart
class Tournament {
  final String id;
  final String name;
  final TournamentType type; // singleElimination, doubleElimination, swiss, roundRobin
  final TournamentStatus status; // registration, qualifiers, playoffs, final, completed
  final DateTime startDate;
  final DateTime endDate;
  final int maxTeams;
  final int currentTeams;
  final List<TournamentStage> stages;
  final TournamentBracket? bracket;
  final TournamentSettings settings;
}
```

### 2. Tournament Stage

```dart
class TournamentStage {
  final String id;
  final String name; // "Qualifiers", "Round of 64", "Final"
  final StageType type; // qualifier, elimination, final
  final int roundNumber;
  final int totalRounds;
  final List<Match> matches;
  final DateTime startDate;
  final DateTime endDate;
  final MatchFormat format; // bestOf3, bestOf5, bestOf7
}
```

### 3. Match Entity

```dart
class Match {
  final String id;
  final String tournamentId;
  final String stageId;
  final Team team1;
  final Team team2;
  final MatchStatus status; // scheduled, inProgress, completed, forfeited
  final DateTime scheduledTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<GameResult> gameResults; // نتائج الجولات
  final Team? winner;
  final MatchFormat format; // bestOf3, bestOf5, bestOf7
  final String? roomId; // Cloudflare room ID
}
```

### 4. Team Entity

```dart
class Team {
  final String id;
  final String name;
  final String captainId;
  final List<String> memberIds;
  final String timeZone;
  final List<DateTime> preferredTimeSlots;
  final TeamStats stats;
  final int seed; // للترتيب في البطولة
}
```

---

## نظام التحديات (Match Format)

### Best of 3 (أفضل 3)
```
الجولة 1: Team A vs Team B
الجولة 2: Team A vs Team B
الجولة 3: Team A vs Team B (إذا لزم الأمر)

الفائز: أول من يفوز جولتين
```

### Best of 5 (أفضل 5)
```
الجولة 1-5: Team A vs Team B
الفائز: أول من يفوز 3 جولات
```

### Best of 7 (أفضل 7)
```
الجولة 1-7: Team A vs Team B
الفائز: أول من يفوز 4 جولات
```

### نظام النقاط في الجولة
- **الفوز**: 3 نقاط
- **الخسارة**: 0 نقاط
- **في حالة التعادل**: جولة إضافية (Sudden Death)

---

## نظام الجدولة والتوقيتات

### 1. Time Zone Management
- **تحديد توقيت كل فريق**: تلقائي من GPS أو اختيار يدوي
- **تحويل إلى UTC**: جميع الأوقات في UTC
- **عرض محلي**: كل فريق يرى الوقت بتوقيته المحلي

### 2. Flexible Scheduling
- **نوافذ زمنية**: كل فريق يختار 3 أوقات مناسبة
- **مطابقة تلقائية**: النظام يجد الوقت المشترك
- **إعادة جدولة**: حتى 24 ساعة قبل المباراة
- **Auto-scheduling**: للجولات التالية

### 3. Notifications
- **24 ساعة قبل**: تذكير بالمباراة
- **1 ساعة قبل**: تذكير نهائي
- **15 دقيقة قبل**: استعداد
- **بدء المباراة**: إشعار فوري

---

## التكامل مع Cloudflare

### 1. Tournament Room (Durable Object)
```typescript
class TournamentRoom implements DurableObject {
  private tournament: Tournament;
  private matches: Map<string, Match>;
  private teams: Map<string, Team>;
  
  // إدارة البطولة
  async createTournament(config: TournamentConfig): Promise<Tournament>
  async registerTeam(team: Team): Promise<void>
  async startStage(stageId: string): Promise<void>
  async scheduleMatch(matchId: string): Promise<void>
  async updateMatchResult(matchId: string, result: GameResult): Promise<void>
  async advanceBracket(): Promise<void>
}
```

### 2. Match Room (Durable Object)
```typescript
class MatchRoom implements DurableObject {
  private match: Match;
  private currentGame: number; // الجولة الحالية
  private gameResults: GameResult[];
  
  // إدارة المباراة
  async startMatch(): Promise<void>
  async startGame(gameNumber: number): Promise<void>
  async endGame(result: GameResult): Promise<void>
  async endMatch(): Promise<Team> // الفائز
}
```

---

## البنية المعمارية المقترحة

```
┌─────────────────────────────────────┐
│     Tournament Management           │
│  (Cloudflare Durable Object)        │
│  - Tournament state                 │
│  - Bracket management               │
│  - Match scheduling                 │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────┐
       │                 │
┌──────▼──────┐  ┌──────▼──────┐
│ Match Room  │  │ Match Room  │
│ (Team A vs  │  │ (Team C vs  │
│  Team B)    │  │  Team D)    │
└─────────────┘  └─────────────┘
```

---

## خطة التنفيذ

### Phase 1: Tournament Infrastructure (أسبوعان)
1. Tournament entities و models
2. Tournament repository
3. Tournament BLoC
4. Basic UI screens

### Phase 2: Bracket System (أسبوعان)
1. Bracket algorithms (Single/Double elimination)
2. Swiss system algorithm
3. Round-robin algorithm
4. Bracket visualization

### Phase 3: Match Management (أسبوعان)
1. Match scheduling
2. Time zone management
3. Notification system
4. Match room integration

### Phase 4: Cloudflare Integration (أسبوع)
1. TournamentRoom Durable Object
2. MatchRoom integration
3. Real-time updates
4. State persistence

### Phase 5: UI & Polish (أسبوع)
1. Tournament dashboard
2. Bracket viewer
3. Match viewer
4. Leaderboard integration

---

## الملفات المطلوبة

### Domain Layer
- `lib/features/tournament/domain/entities/tournament.dart`
- `lib/features/tournament/domain/entities/tournament_stage.dart`
- `lib/features/tournament/domain/entities/match.dart`
- `lib/features/tournament/domain/entities/team.dart`
- `lib/features/tournament/domain/entities/bracket.dart`

### Services
- `lib/features/tournament/domain/services/bracket_algorithm.dart`
- `lib/features/tournament/domain/services/match_scheduler.dart`
- `lib/features/tournament/domain/services/timezone_manager.dart`

### Backend
- `backend/src/TournamentRoom.ts`
- `backend/src/MatchRoom.ts`

### UI
- `lib/features/tournament/presentation/screens/tournament_dashboard.dart`
- `lib/features/tournament/presentation/widgets/bracket_viewer.dart`
- `lib/features/tournament/presentation/widgets/match_card.dart`

---

## التوصيات النهائية

### أفضل نظام للاستخدام الملياري:
1. **التصفيات**: Swiss System (للعدالة)
2. **التصفيات النهائية**: Single Elimination (للسرعة والدراما)
3. **النهائي**: Best of 7 (للإثارة)

### نظام التوقيتات:
- **نوافذ زمنية مرنة**: 3 خيارات لكل فريق
- **مطابقة تلقائية**: AI-powered scheduling
- **إعادة جدولة**: حتى 24 ساعة قبل

### عدد الجولات:
- **التصفيات**: Best of 3
- **ربع/نصف النهائي**: Best of 5
- **النهائي**: Best of 7

---

## الخطوات التالية

1. ✅ تصميم النظام (هذا المستند)
2. ⏳ تنفيذ Tournament entities
3. ⏳ تنفيذ Bracket algorithms
4. ⏳ تنفيذ Match scheduler
5. ⏳ Cloudflare integration
6. ⏳ UI implementation

