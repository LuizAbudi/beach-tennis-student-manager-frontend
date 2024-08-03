import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/activities/activity_details_view.dart';
import 'package:mobile/src/activities/activity_form.dart';
import 'package:mobile/src/controllers/activity_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/activity_stores.dart';

class ActivityItemListView extends StatefulWidget {
  const ActivityItemListView({super.key});

  @override
  State<ActivityItemListView> createState() => _ActivityItemListViewState();
}

class _ActivityItemListViewState extends State<ActivityItemListView> {
  final ActivityStore store = ActivityStore(
    controller: ActivityController(
      client: HttpClient(),
    ),
  );

  var isLoaded = false;

  UserModel? loggedUserModel;
  final loggedUser = localStorage.getItem('token');

  @override
  void initState() {
    super.initState();

    if (loggedUser != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(loggedUser!);

      loggedUserModel = UserModel(
        id: decodedToken['id'],
        name: decodedToken['name'],
        email: decodedToken['email'],
      );
    }

    store.getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation:
            Listenable.merge([store.isLoading, store.error, store.state]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            itemBuilder: (_, index) {
              final item = store.state.value[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ActivityItemDetailsView(id: item.id!),
                    ),
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.assignment,
                              color: Colors.white30,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Prazo: ${item.date}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (item.id != null &&
                                  loggedUserModel?.id != null) {
                                await store.linkActivity(
                                    item.id!, loggedUserModel!.id!);
                              }

                              if (store.error.value.isNotEmpty) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(store.error.value),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }

                              store.getActivities();
                            },
                            icon: const Icon(
                              Icons.assignment_ind_outlined,
                              color: Colors.white30,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              bool willRefresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivityForm(
                                    id: item.id,
                                  ),
                                ),
                              );

                              if (willRefresh) {
                                store.getActivities();
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white30,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await store.deleteActivity(item.id!);
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: store.state.value.length,
            padding: const EdgeInsets.all(16),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool willRefresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ActivityForm(),
            ),
          );

          if (willRefresh) {
            store.getActivities();
          }
        },
        backgroundColor: Colors.deepOrange.shade500,
        child: const Icon(
          Icons.assignment_add,
          color: Colors.white70,
        ),
      ),
    );
  }
}
