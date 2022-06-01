import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:initiative_tracker/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class CampaignsService extends ChangeNotifier {
  final String _baseUrl = 'alex-initiative-tracker.herokuapp.com';
  final authService = AuthService();

  final List<Campaign> campaigns = [];

  late Campaign selectedCampaign;

  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;

  CampaignsService() {
    loadCampaigns();
  }

  Future<List<Campaign>> loadCampaigns() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, '/campaigns');
    final token = await authService.readToken();
    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final List<Campaign> campaigns = data.map((dynamic item) {
        return Campaign.fromJson(item);
      }).toList();
      this.campaigns.clear();
      campaigns.sort(
          (a, b) => b.createdAt.toString().compareTo(a.createdAt.toString()));
      this.campaigns.addAll(campaigns);
      isLoading = false;
      notifyListeners();
      return campaigns;
    } else {
      campaigns.clear();
      isLoading = false;
      notifyListeners();
      if (response.statusCode == 401) {
        // TODO: handle unauthorized
        throw Exception('Unauthorized');
        // restart app

      } else {
        throw Exception('Failed to load campaigns');
      }
    }
  }

  Future saveOrCreateCampaign(Campaign campaign) async {
    isSaving = true;
    notifyListeners();
    if (campaign.id == null) {
      await _createCampaign(campaign);
    } else {
      await _updateCampaign(campaign);
    }
    isSaving = false;
    notifyListeners();
  }

  Future deleteCampaign(Campaign campaign) async {
    isSaving = true;
    notifyListeners();
    await _deleteCampaign(campaign);
    isSaving = false;
    notifyListeners();
  }

  Future _updateCampaign(Campaign campaign) async {
    final url = Uri.https(_baseUrl, '/campaigns/${campaign.id}');
    final response = await http.patch(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer ${await authService.readToken()}'
        },
        body: json.encode(campaign));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      loadCampaigns();
      notifyListeners();
    } else {
      throw Exception('Failed to update campaign');
    }
  }

  Future _createCampaign(Campaign campaign) async {
    final url = Uri.https(_baseUrl, '/campaigns');
    final response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer ${await authService.readToken()}'
        },
        body: json.encode(campaign));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      final Campaign createdCampaign = Campaign.fromJson(data);
      campaigns.add(createdCampaign);
      notifyListeners();
    } else {
      throw Exception('Failed to create campaign');
    }
  }

  Future _deleteCampaign(Campaign campaign) async {
    final url = Uri.https(_baseUrl, '/campaigns/${campaign.id}');
    final response = await http.delete(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer ${await authService.readToken()}'
        },
        body: json.encode(campaign));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final index = campaigns.indexWhere((Campaign c) => c.id == campaign.id);
      campaigns.removeAt(index);
      notifyListeners();
    } else {
      throw Exception('Failed to delete campaign');
    }
  }

  void updateSelectedCampaignImage(String path) {
    selectedCampaign.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();
    // upload image to cloudinary
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dgnezslzj/image/upload?upload_preset=dnd-initiative-tracker');
    // ignore: todo
    // TODO: esto podria hacerlo en backend initiative-tracker-server y no en cliente
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      isSaving = false;
      notifyListeners();
      return null;
    }

    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
