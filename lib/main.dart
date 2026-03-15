import 'dart:convert';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'providers/team_provider.dart';
import 'models/team.dart';
import 'services/auth_service.dart';

// Conditional import handling for the URL parsing
import 'dart:html' if (dart.library.io) 'package:ete6_mentor_portal/models/team.dart' as html;

void main() {
  runApp(const ProviderScope(child: SentinelApp()));
}

final handleProvider = StateProvider<String>((ref) => '');
final authServiceProvider = Provider((ref) => GithubAuthImplementation());

// -----------------------------------------------------------------------------
// NAVIGATION
// -----------------------------------------------------------------------------
final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
    GoRoute(
      path: '/team/:name',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? '';
        return TeamDetailScreen(teamName: Uri.decodeComponent(name));
      },
    ),
  ],
);

class SentinelApp extends StatelessWidget {
  const SentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SENTINEL_6',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(ThemeData.light().textTheme),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// LOGIN SCREEN
// -----------------------------------------------------------------------------
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _handleCtrl = TextEditingController();
  bool _isManual = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _checkAuthWeb();
    }
  }

  void _checkAuthWeb() async {
    // Only run this on web
    try {
      final uri = Uri.parse(Uri.base.toString());
      if (uri.queryParameters.containsKey('code')) {
        final h = await ref.read(authServiceProvider).handleCallback(uri.queryParameters['code']!);
        if (h != null) {
          ref.read(handleProvider.notifier).state = h;
          context.go('/dashboard');
        }
      }
    } catch (e) {
      // Fail silently on non-web
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 450,
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 4), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(12, 12))]),
          padding: const EdgeInsets.all(64),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 3)), child: const Icon(Icons.terminal_sharp, size: 48)),
              const SizedBox(height: 32),
              Text('SENTINEL_6', style: GoogleFonts.jetBrainsMono(fontSize: 32, fontWeight: FontWeight.w900)),
              const Text('MULTI_PLATFORM_INTERFACE', style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
              const SizedBox(height: 48),
              if (!_isManual) ...[
                _btn('SIGN IN WITH GITHUB', () => ref.read(authServiceProvider).redirectToGithub()),
                const SizedBox(height: 16),
                TextButton(onPressed: () => setState(() => _isManual = true), child: const Text('MANUAL_IDENTITY_OVERRIDE', style: TextStyle(fontSize: 9, color: Colors.black38))),
              ] else ...[
                _input('ENTER_HANDLE', _handleCtrl),
                const SizedBox(height: 24),
                _btn('INITIALIZE', () {
                  if (_handleCtrl.text.isNotEmpty) {
                    ref.read(handleProvider.notifier).state = _handleCtrl.text;
                    context.go('/dashboard');
                  }
                }),
                const SizedBox(height: 16),
                TextButton(onPressed: () => setState(() => _isManual = false), child: const Text('< BACK', style: TextStyle(fontSize: 9, color: Colors.black38))),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String l, TextEditingController c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      TextField(controller: c, decoration: const InputDecoration(filled: true, fillColor: Color(0xFFF5F5F5), border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)))),
    ]);
  }

  Widget _btn(String l, VoidCallback o) {
    return InkWell(onTap: o, child: Container(height: 64, width: double.infinity, color: Colors.black, alignment: Alignment.center, child: Text(l, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))));
  }
}

// -----------------------------------------------------------------------------
// DASHBOARD
// -----------------------------------------------------------------------------
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams = ref.watch(filteredTeamsProvider);
    final handle = ref.watch(handleProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Text('// SYSTEM_INDEX', style: GoogleFonts.jetBrainsMono(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
        actions: [
          Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), color: Colors.black, child: Text(handle.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
          const SizedBox(width: 24),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(2), child: Container(color: Colors.black, height: 2)),
      ),
      body: Column(
        children: [
          _search(ref),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: teams.length,
              itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 200),
                child: SlideAnimation(verticalOffset: 20, child: FadeInAnimation(child: TeamCard(team: teams[index]))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _search(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      child: TextField(onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v, decoration: const InputDecoration(hintText: 'SEARCH_DATABASE >', border: InputBorder.none)),
    );
  }
}

class TeamCard extends StatelessWidget {
  final Team team;
  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    int res = team.failures.where((f) => f.status == 'resolved').length;
    int tot = team.failures.length;

    return GestureDetector(
      onTap: () => context.push('/team/${Uri.encodeComponent(team.name)}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))]),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(team.name.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(team.problemTitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)), child: Text('AUDIT: $res/$tot', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                const Spacer(),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DETAIL
// -----------------------------------------------------------------------------
class TeamDetailScreen extends ConsumerStatefulWidget {
  final String teamName;
  const TeamDetailScreen({super.key, required this.teamName});
  @override
  ConsumerState<TeamDetailScreen> createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends ConsumerState<TeamDetailScreen> {
  int _tab = 0;
  final TextEditingController _remarks = TextEditingController();
  int _round = 1;

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(teamProvider);
    if (teams.isEmpty) return const Scaffold(body: Center(child: Text('LOADING...')));
    
    final team = teams.firstWhere((t) => t.name == widget.teamName, orElse: () => teams[0]);
    final handle = ref.watch(handleProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => context.pop()),
        title: Text(team.name.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black, width: 2), bottom: BorderSide(color: Colors.black, width: 2))),
            child: Row(
              children: [
                _tabItem(0, 'REALITY', team.realityChecks.length),
                _tabItem(1, 'FAILURES', team.failures.length),
                _tabItem(2, 'BLUEPRINT', team.blueprint.length),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(flex: 3, child: _contentSection(team)),
          if (isDesktop) const VerticalDivider(width: 2, color: Colors.black),
          if (isDesktop) Expanded(flex: 2, child: _editorSection(team, handle)),
        ],
      ),
      floatingActionButton: isDesktop ? null : FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () => _showMobileEditor(team, handle),
      ),
    );
  }

  Widget _tabItem(int i, String l, int c) {
    bool active = _tab == i;
    return Expanded(child: InkWell(onTap: () => setState(() => _tab = i), child: Container(height: 60, color: active ? Colors.black : Colors.white, alignment: Alignment.center, child: Text('$l [$c]', style: TextStyle(color: active ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 10)))));
  }

  Widget _contentSection(Team team) {
    List<dynamic> items = _tab == 0 ? team.realityChecks : (_tab == 1 ? team.failures : team.blueprint);
    if (items.isEmpty) return const Center(child: Text('[NO_DATA_STREAM]'));

    return ListView.builder(
      padding: const EdgeInsets.all(32),
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (_tab == 1) return _failureItem(team, team.failures[index], index);
        return Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(24), decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)), child: Text(items[index].toString(), style: const TextStyle(fontSize: 14, height: 1.6)));
      },
    );
  }

  Widget _failureItem(Team team, FailureItem f, int i) {
    bool done = f.status == 'resolved';
    return InkWell(
      onTap: () => ref.read(teamProvider.notifier).toggleFailureStatus(team.name, i),
      child: Container(margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: done ? Colors.black : Colors.white, border: Border.all(color: Colors.black, width: 2)), padding: const EdgeInsets.all(20), child: Row(children: [Icon(done ? Icons.check_circle : Icons.circle_outlined, color: done ? Colors.white : Colors.black), const SizedBox(width: 16), Expanded(child: Text(f.description, style: TextStyle(fontWeight: FontWeight.bold, color: done ? Colors.white : Colors.black, decoration: done ? TextDecoration.lineThrough : null)))]))
    );
  }

  Widget _editorSection(Team team, String h) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('COMMIT_LOG_STREAM', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [1, 2, 3].map((r) => _roundChip(r)).toList()),
          const SizedBox(height: 32),
          _inputField('MENTOR', TextEditingController(text: h), enabled: false),
          const SizedBox(height: 24),
          _inputField('REMARKS', _remarks, lines: 6),
          const SizedBox(height: 32),
          _submitBtn(team, h),
          const SizedBox(height: 32),
          const Text('LOG_HISTORY (SCROLLABLE)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38)),
          const Divider(color: Colors.black, thickness: 2),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16),
              itemCount: team.history.length,
              itemBuilder: (context, i) {
                final r = team.history[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('R${r.roundNumber} • ${r.mentorName}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          Text(r.evaluationTime.toString().substring(11, 16), style: const TextStyle(fontSize: 9, color: Colors.black26)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(r.remarks, style: const TextStyle(fontSize: 12, height: 1.4)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitBtn(Team team, String h) {
    return InkWell(
      onTap: () {
        if (_remarks.text.isNotEmpty) {
          ref.read(teamProvider.notifier).addHistoryEntry(team.name, _round, h, _remarks.text);
          _remarks.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AUDIT_COMMITTED'), backgroundColor: Colors.black));
        }
      },
      child: Container(height: 64, width: double.infinity, color: Colors.black, alignment: Alignment.center, child: const Text('SUBMIT_LOG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
    );
  }

  void _showMobileEditor(Team team, String h) {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => Container(height: MediaQuery.of(context).size.height * 0.85, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 4)), child: _editorSection(team, h)));
  }

  Widget _roundChip(int r) {
    bool active = _round == r;
    return InkWell(onTap: () => setState(() => _round = r), child: Container(width: 70, height: 40, decoration: BoxDecoration(color: active ? Colors.black : Colors.white, border: Border.all(color: Colors.black, width: 2)), alignment: Alignment.center, child: Text('R$r', style: TextStyle(color: active ? Colors.white : Colors.black, fontWeight: FontWeight.w900))));
  }

  Widget _inputField(String label, TextEditingController ctrl, {int lines = 1, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 12),
        TextField(controller: ctrl, maxLines: lines, enabled: enabled, decoration: const InputDecoration(filled: true, fillColor: Color(0xFFF5F5F5), border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)))),
      ],
    );
  }
}
