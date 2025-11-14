import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/property_model.dart';
import '../services/property_service.dart';
import '../widgets/property_card.dart';
import 'add_property_screen.dart';
import 'edit_property_screen.dart';
import 'manage_users_screen.dart'; // import manage users page

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _SmallScreenNotice extends StatelessWidget {
  const _SmallScreenNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.desktop_windows,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Admin Dashboard is best viewed on a larger screen',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please open this page on a tablet or desktop (≥ 600px width).',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardChart extends StatelessWidget {
  final String title;
  const _DashboardChart({required this.title});

  List<BarChartGroupData> _sampleGroups() {
    final months = List.generate(6, (i) => i); // last 6 months index
    final values = [5.0, 8.0, 3.0, 10.0, 7.0, 12.0];
    return List.generate(months.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: values[i],
            width: 16,
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            title,
            style: textStyle?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 36),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                      final i = value.toInt();
                      return Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          i >= 0 && i < labels.length ? labels[i] : '',
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: _sampleGroups(),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminDashboardState extends State<AdminDashboard> {
  final PropertyService _propertyService = PropertyService();
  List<PropertyModel> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final data = await _propertyService.getAllProperties();
    setState(() {
      properties = data;
      isLoading = false;
    });
  }

  Future<void> _deleteProperty(String id) async {
    await _propertyService.deleteProperty(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Property deleted successfully')),
    );
    _loadProperties();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: const _SmallScreenNotice(),
      );
    }
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.deepPurple.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple.shade400),
              child: const Center(
                child: Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.deepPurple),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_home, color: Colors.deepPurple),
              title: const Text('Add Property'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
                ).then((_) => _loadProperties());
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt, color: Colors.deepPurple),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadProperties,
            tooltip: 'Refresh',
          ),
        ],
      ),

      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : properties.isEmpty
          ? const Center(
              child: Text(
                'No properties found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Chart section
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width >= 1000
                            ? 260
                            : MediaQuery.of(context).size.width >= 600
                            ? 220
                            : 180,
                        child: _DashboardChart(title: 'Properties per month'),
                      ),
                    ),
                  ),
                ),

                // Properties grid
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadProperties,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: width >= 1200
                            ? 4
                            : width >= 900
                            ? 3
                            : 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        return PropertyCard(
                          property: property,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditPropertyScreen(property: property),
                              ),
                            ).then((_) => _loadProperties());
                          },
                          onDelete: () => _deleteProperty(property.id),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
