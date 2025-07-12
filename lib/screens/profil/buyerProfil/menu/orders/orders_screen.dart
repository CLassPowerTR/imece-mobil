part of '../../buyer_profil_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<String> orderTabs = [
    'Tümü',
    'Devam Edenler',
    'İptaller',
    'İadeler',
    'Teslim Edilemeyenler',
  ];
  int selectedTab = 0;

  final List<String> filterOptions = [
    'Tüm Siparişler',
    'Son 30 Gün',
    'Son 6 Ay',
    'Son 1 Yıl',
    '1 Yıl Önce',
  ];
  String selectedFilter = 'Tüm Siparişler';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siparişlerim'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedFilter,
              style: TextStyle(color: secondary, fontWeight: FontWeight.bold),
              icon: Icon(Icons.filter_list, color: secondary),
              items: filterOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedFilter = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: HomeStyle(context: context).surface,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(orderTabs.length, (index) {
                    final isSelected = selectedTab == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          orderTabs[index],
                          style: TextStyle(
                            color: isSelected ? secondary : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: secondary.withOpacity(0.15),
                        backgroundColor: Colors.white,
                        onSelected: (_) {
                          setState(() {
                            selectedTab = index;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Buraya sipariş listesi veya filtrelenmiş içerik gelecek
          Expanded(
            child: OrderScreenBody(),
          ),
        ],
      ),
    );
  }
}
