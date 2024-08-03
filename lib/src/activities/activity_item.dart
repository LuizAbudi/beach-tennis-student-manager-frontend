class ActivityItem {
  const ActivityItem({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  final int? id;
  final String title;
  final String description;
  final String date;
}
