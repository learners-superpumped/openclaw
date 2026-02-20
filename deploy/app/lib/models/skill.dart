class BrowseSkillItem {
  final String slug;
  final String? name;
  final String? summary;
  final bool installed;
  final String? installedVersion;
  final Map<String, dynamic> raw;

  const BrowseSkillItem({
    required this.slug,
    this.name,
    this.summary,
    required this.installed,
    this.installedVersion,
    required this.raw,
  });

  factory BrowseSkillItem.fromJson(Map<String, dynamic> json) {
    return BrowseSkillItem(
      slug: json['slug'] as String,
      name: json['displayName'] as String?,
      summary: json['summary'] as String?,
      installed: json['installed'] as bool? ?? false,
      installedVersion: json['installedVersion'] as String?,
      raw: json,
    );
  }

  factory BrowseSkillItem.fromInstalledJson(Map<String, dynamic> json) {
    return BrowseSkillItem(
      slug: json['slug'] as String,
      name: json['displayName'] as String?,
      summary: json['summary'] as String?,
      installed: true,
      installedVersion: json['version'] as String?,
      raw: json,
    );
  }
}

class BrowseSkillsResponse {
  final List<BrowseSkillItem> skills;
  final String? cursor;

  const BrowseSkillsResponse({
    required this.skills,
    this.cursor,
  });

  factory BrowseSkillsResponse.fromJson(Map<String, dynamic> json) {
    final skillsList = (json['skills'] as List?)
            ?.map((e) => BrowseSkillItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return BrowseSkillsResponse(
      skills: skillsList,
      cursor: json['cursor'] as String?,
    );
  }
}

class BrowseSkillDetail {
  final String slug;
  final String? name;
  final String? summary;
  final String? changelog;
  final String? author;
  final String? latestVersion;
  final bool installed;
  final String? installedVersion;
  final Map<String, dynamic> raw;

  const BrowseSkillDetail({
    required this.slug,
    this.name,
    this.summary,
    this.changelog,
    this.author,
    this.latestVersion,
    required this.installed,
    this.installedVersion,
    required this.raw,
  });

  factory BrowseSkillDetail.fromJson(Map<String, dynamic> json) {
    final skill = json['skill'] as Map<String, dynamic>?;
    final latestVer = json['latestVersion'] as Map<String, dynamic>?;
    final owner = json['owner'] as Map<String, dynamic>?;
    return BrowseSkillDetail(
      slug: skill?['slug'] as String? ?? json['slug'] as String? ?? '',
      name: skill?['displayName'] as String?,
      summary: skill?['summary'] as String?,
      changelog: latestVer?['changelog'] as String?,
      author: owner?['displayName'] as String? ?? owner?['handle'] as String?,
      latestVersion: latestVer?['version'] as String?,
      installed: json['installed'] as bool? ?? false,
      installedVersion: json['installedVersion'] as String?,
      raw: json,
    );
  }
}
