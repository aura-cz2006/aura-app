import 'package:aura/controllers/discussion_controller.dart';
import 'package:aura/managers/discussion_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
              onPressed: () => DiscussionController.getDiscussions(),
              icon: const Icon(Icons.download_rounded))
        ],
      ),
      body: Center(child: Consumer<DiscussionManager>(
          builder: (context, discussionManager, child) {
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: discussionManager.discussions.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                margin: const EdgeInsets.all(2),
                child: Center(
                    child: Text(
                  discussionManager.discussions[index].title ?? "undefined",
                  style: const TextStyle(fontSize: 18),
                )),
              );
            });
      })),
    );
  }
}
