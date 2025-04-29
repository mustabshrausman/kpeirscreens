import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayDataController extends GetxController
    with GetTickerProviderStateMixin {
  final RxList<Map<String, dynamic>> allData = <Map<String, dynamic>>[].obs;
  late ScrollController scrollController;

  // Animation controllers and animations for each item
  final List<AnimationController> controllers = [];
  final List<Animation<Offset>> slideAnimations = [];

  final isLoadingMore = false.obs;
  final nextBatchStartIndex = 0.obs;
  final batchSize = 10.obs;
  bool isFirstLoad = true;

  final List<Map<String, dynamic>> initialData;

  DisplayDataController(this.initialData) {
    print("Initial data received: ${initialData.length} items");
  }

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _loadMoreData();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore.value) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (isLoadingMore.value ||
        nextBatchStartIndex.value >= initialData.length) {
      return;
    }

    isLoadingMore.value = true;
    update();

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final nextBatch = initialData
        .skip(nextBatchStartIndex.value)
        .take(batchSize.value)
        .toList();
    nextBatchStartIndex.value += nextBatch.length;

    print("Loading ${nextBatch.length} more items");

    // Create animations for new items
    for (int i = 0; i < nextBatch.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      final animation = Tween<Offset>(
        begin: const Offset(0.0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));

      controllers.add(controller);
      slideAnimations.add(animation);
      controller.forward();
    }

    allData.addAll(nextBatch);
    isLoadingMore.value = false;

    if (isFirstLoad) {
      isFirstLoad = false;
    }
    update();
  }

  @override
  void onClose() {
    scrollController.dispose();
    for (final controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
