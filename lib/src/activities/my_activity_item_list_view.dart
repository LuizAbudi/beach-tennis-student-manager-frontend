import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/activities/activity_details_view.dart';
import 'package:mobile/src/activities/activity_form.dart';
import 'package:mobile/src/controllers/activity_controller.dart';
import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';
import 'package:mobile/src/stores/activity_stores.dart';

class MyActivityItemListView extends StatefulWidget {
  const MyActivityItemListView({super.key});

  @override
  State<MyActivityItemListView> createState() => _MyActivityItemListViewState();
}

class _MyActivityItemListViewState extends State<MyActivityItemListView> {
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

    store.getMyActivities();
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

              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final willRefresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityItemDetailsView(
                            id: item.id!,
                            isFromMyActivity: true,
                          ),
                        ),
                      );

                      if (willRefresh) {
                        store.getMyActivities();
                      }
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
                                  if (loggedUserModel?.id != null) {
                                    await store.unlinkActivity(
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
                                  } else {
                                    store.getMyActivities();
                                  }
                                },
                                icon: const Icon(
                                  Icons.assignment_return_outlined,
                                  color: Colors.white30,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (loggedUserModel?.id != null) {
                                    await store.finishActivity(
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
                                  } else {
                                    store.getMyActivities();
                                  }
                                },
                                icon: const Icon(
                                  Icons.upload_file,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
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
