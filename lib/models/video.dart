class Video {
  String? id, videoUrl,title;

  Video(this.videoUrl,this.title);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'videoUrl': videoUrl,
        'title': title
      };

  Video.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['_id'],
      title = jsonData['title'],
        videoUrl = jsonData['videoUrl'];
}
