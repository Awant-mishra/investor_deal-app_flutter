class Deal {
  final String id;
  final String companyName;
  final String industry;
  final int investment;
  final double roi;
  final String risk;
  final String status;
  final String ? description;


  Deal({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.investment,
    required this.roi,
    required this.risk,
    required this.status,
    this.description,

  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['id'],
      companyName: json['companyName'],
      industry: json['industry'],
      investment: json['investment'],
      roi: (json['roi'] as num).toDouble(),
      risk: json['risk'],
      status: json['status'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'industry': industry,
      'investment': investment,
      'roi': roi,
      'risk': risk,
      'status': status,
    };
  }
}