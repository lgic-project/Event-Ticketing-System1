import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_ticketing_system1/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  // Get auth token from storage
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.authTokenKey);
  }

  // Get headers with auth token
  Future<Map<String, String>> getHeaders({bool requireAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(json.decode(response.body)['message']);
      case 401:
        throw UnauthorizedException('Unauthorized');
      case 403:
        throw ForbiddenException('Forbidden');
      case 404:
        throw NotFoundException('Not found');
      case 500:
      default:
        throw ServerException('Server error: ${response.statusCode}');
    }
  }

  // GET request
  Future<dynamic> get(
    String endpoint, {
    bool requireAuth = false,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}$endpoint',
      ).replace(queryParameters: queryParams);
      final headers = await getHeaders(requireAuth: requireAuth);

      final response = await http.get(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // POST request
  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requireAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await getHeaders(requireAuth: requireAuth);

      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // PUT request
  Future<dynamic> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requireAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await getHeaders(requireAuth: requireAuth);

      final response = await http.put(
        uri,
        headers: headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {bool requireAuth = false}) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await getHeaders(requireAuth: requireAuth);

      final response = await http.delete(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // PATCH request
  Future<dynamic> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requireAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await getHeaders(requireAuth: requireAuth);

      final response = await http.patch(
        uri,
        headers: headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // Upload file
  Future<dynamic> uploadFile(
    String endpoint, {
    required String filePath,
    required String fieldName,
    Map<String, String>? additionalFields,
    bool requireAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await getHeaders(requireAuth: requireAuth);

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      // Add file
      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      // Add additional fields if any
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }
}

// Custom Exceptions
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}
