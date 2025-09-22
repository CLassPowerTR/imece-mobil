part of '../buyer_profil_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late Future<List<dynamic>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _groupsFuture = ApiService.fetchUserGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        title: customText('Gruplarım', context,
            size: HomeStyle(context: context).bodyLarge.fontSize,
            weight: FontWeight.w600),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _groupsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: buildLoadingBar(context));
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Herhangi bir gruba dahil değilsiniz.'));
          } else {
            final groups = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: groups.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final dynamic raw = groups[index];
                final Map<String, dynamic> item = raw is Map<String, dynamic>
                    ? raw
                    : <String, dynamic>{'name': raw.toString()};
                final String title =
                    (item['name'] ?? item['ad'] ?? 'Grup').toString();
                final String subtitle =
                    (item['description'] ?? item['aciklama'] ?? '').toString();
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        HomeStyle(context: context).secondary.withOpacity(0.15),
                    child: Icon(Icons.group_outlined,
                        color: HomeStyle(context: context).secondary),
                  ),
                  title:
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: subtitle.isEmpty
                      ? null
                      : Text(subtitle,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey.shade600),
                  onTap: () {},
                );
              },
            );
          }
        },
      ),
    );
  }
}
