
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
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface(context),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.5,
        shadowColor: AppColors.shadow(context).withOpacity(0.15),
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        title: customText('Siparişlerim', context,
            size: AppTextStyle.bodyLarge(context).fontSize,
            weight: FontWeight.w600),
        leading: TurnBackTextIcon(),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedFilter,
              style: TextStyle(
                color: AppColors.primary(context),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              icon: Icon(Icons.filter_list, color: AppColors.primary(context)),
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
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surface(context),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(orderTabs.length, (index) {
                    final isSelected = selectedTab == index;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary(context)
                                : AppColors.primary(context).withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary(context)
                                  : AppColors.outline(context).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            orderTabs[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.onPrimary(context)
                                  : AppColors.onSurface(context),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.outline(context).withOpacity(0.3)),
          // Buraya sipariş listesi veya filtrelenmiş içerik gelecek
          Expanded(
            child: OrderScreenBody(),
          ),
        ],
      ),
    );
  }
}
