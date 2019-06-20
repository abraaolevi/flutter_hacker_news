class Article {
  final String title;
  final String url;
  final String by;
  final int time;
  final int score;

  Article(
      {this.title,
      this.url,
      this.by,
      this.time,
      this.score});

  factory Article.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Article(
      title: json['title'],
      url: json['url'],
      by: json['by'],
      time: json['time'],
      score: json['score'] as int
    );
  }
}
