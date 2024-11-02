import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'item.dart';
import 'api.dart';
import 'add.dart';
import 'edit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [
    Item(id: 1, website: 'memememe.id', email: 'editor31@gmail.com', iconPath: 'assets/icons/default_icon.png'),
    Item(id: 2, website: 'quicktask.io', email: 'quickuser@gmail.com', iconPath: 'assets/icons/default_icon.png'),
    Item(id: 3, website: 'newsportal.com', email: 'news123@gmail.com', iconPath: 'assets/icons/default_icon.png'),
    Item(id: 4, website: 'healthhub.net', email: 'contact@healthhub.net', iconPath: 'assets/icons/default_icon.png'),
    Item(id: 5, website: 'techworld.co', email: 'support@techworld.co', iconPath: 'assets/icons/default_icon.png'),
  ];

  List<Item> filteredItems = [];
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = items;
      });
    } else {
      setState(() {
        filteredItems = items.where((item) {
          return item.website.toLowerCase().contains(query.toLowerCase()) ||
              item.email.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Pintupin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: filterSearchResults,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: isWeb ? 80 : 70, // Different toolbar height for web
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[850],
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(filteredItems[index].iconPath),
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                filteredItems[index].website,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.white, 
                  fontSize: isWeb ? 16 : 14), // Font size adjusted for web/mobile
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                filteredItems[index].email,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isWeb ? 14 : 12), // Font size adjusted for web/mobile
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    icon: const Icon(Icons.open_in_browser, color: Colors.white70),
                    onPressed: () async {
                      final url = 'https://${filteredItems[index].website}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tidak dapat membuka $url")),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white70),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Detail pengguna untuk ${filteredItems[index].website}")),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.key, color: Colors.white70),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Kata sandi untuk ${filteredItems[index].website}: *******")),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.access_time, color: Colors.white70),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Waktu akses terakhir untuk ${filteredItems[index].website}: 10:30 AM")),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        items.removeAt(index);
                        filterSearchResults(searchController.text);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${filteredItems[index].website} berhasil dihapus")),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70),
                    onPressed: () async {
                      final editedItem = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditItemScreen(item: filteredItems[index])),
                      );
                      if (editedItem != null) {
                        setState(() {
                          items[index] = editedItem;
                          filterSearchResults(searchController.text);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
          if (newItem != null) {
            setState(() {
              items.insert(0, newItem); 
              filterSearchResults(searchController.text);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
