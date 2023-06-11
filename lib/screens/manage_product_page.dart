import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManageProductPage extends StatefulWidget {
  final String campsiteId;
  const ManageProductPage({super.key, required this.campsiteId});

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed('campsite-add-product',
                  params: {"campsiteId": widget.campsiteId});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(children: [
          ListTile(
              isThreeLine: true,
              title: const Text('3 days 2 nights camping'),
              subtitle: const Text(
                'RM 10.00\nQuantity: 100',
                maxLines: 2,
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Theme.of(context).primaryColor.withOpacity(0.8)),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              )),
        ]),
      ),
    );
  }
}
