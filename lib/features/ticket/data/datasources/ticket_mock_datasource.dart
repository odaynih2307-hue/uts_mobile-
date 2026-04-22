import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/ticket_model.dart';

// Singleton in-memory database with Local Persistence fallback
class TicketMockDataSource {
  static final TicketMockDataSource _instance = TicketMockDataSource._internal();
  factory TicketMockDataSource() => _instance;
  TicketMockDataSource._internal();

  List<TicketModel> _tickets = [];
  SharedPreferences? _prefs;
  static const String _key = 'persisted_tickets';

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _saveToStorage() async {
    await _initPrefs();
    final jsonList = _tickets.map((t) => t.toJson()).toList();
    await _prefs!.setString(_key, jsonEncode(jsonList));
  }

  Future<void> _loadFromStorage() async {
    if (_tickets.isNotEmpty) return; // Already loaded

    await _initPrefs();
    final jsonString = _prefs!.getString(_key);
    
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _tickets = decoded.map((item) => TicketModel.fromJson(item)).toList();
    } else {
      // Load default mock data if storage is empty
      _tickets = _getDefaultMocks();
    }
  }

  List<TicketModel> _getDefaultMocks() {
    return [
      TicketModel(
        id: 'mock-ticket-1',
        title: 'Aplikasi Error saat Login',
        description: 'Ketika saya mencoba login, selalu muncul error 500.',
        status: 'pending',
        priority: 'high',
        creatorId: '2',
        creatorName: 'Ody Dzakwan',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        comments: [],
      ),
      TicketModel(
        id: 'mock-ticket-2',
        title: 'Lupa Password tidak mengirim email',
        description: 'Saya sudah request reset password dari kemarin.',
        status: 'proses',
        priority: 'medium',
        creatorId: '2',
        creatorName: 'Ody Dzakwan',
        assigneeId: '1',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        comments: [
          TicketCommentModel(
            id: 'c1',
            ticketId: 'mock-ticket-2',
            userId: '1',
            userName: 'Super Admin',
            message: 'Halo, sedang kami cek masalah pada server SMTP.',
            createdAt: DateTime.now().subtract(const Duration(hours: 10)),
          ),
        ],
      ),
    ];
  }

  Future<List<TicketModel>> getTickets() async {
    await _loadFromStorage();
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_tickets);
  }

  Future<TicketModel> getTicketDetail(String id) async {
    await _loadFromStorage();
    await Future.delayed(const Duration(milliseconds: 300));
    final ticket = _tickets.firstWhere((t) => t.id == id, orElse: () => throw Exception('Ticket not found'));
    return ticket;
  }

  Future<TicketModel> createTicket(String title, String description, String priority, String creatorId, String creatorName, String? imagePath) async {
    await _loadFromStorage();
    await Future.delayed(const Duration(seconds: 1));
    final newTicket = TicketModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      status: 'pending',
      priority: priority,
      creatorId: creatorId,
      creatorName: creatorName,
      imagePath: imagePath,
      createdAt: DateTime.now(),
      comments: [],
    );
    _tickets.add(newTicket);
    await _saveToStorage();
    return newTicket;
  }

  Future<TicketModel> updateTicketStatus(String id, String status, {String? assigneeId, String? assigneeName}) async {
    await _loadFromStorage();
    await Future.delayed(const Duration(seconds: 1));
    final index = _tickets.indexWhere((t) => t.id == id);
    if (index >= 0) {
      final updated = _tickets[index].copyWithModel(status: status, assigneeId: assigneeId, assigneeName: assigneeName);
      _tickets[index] = updated;
      await _saveToStorage();
      return updated;
    }
    throw Exception('Ticket not found');
  }

  Future<TicketCommentModel> addComment(String ticketId, String userId, String userName, String message) async {
    await _loadFromStorage();
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index >= 0) {
      final newComment = TicketCommentModel(
        id: const Uuid().v4(),
        ticketId: ticketId,
        userId: userId,
        userName: userName,
        message: message,
        createdAt: DateTime.now(),
      );
      
      final currentComments = List<TicketCommentModel>.from(_tickets[index].comments);
      currentComments.add(newComment);
      
      _tickets[index] = _tickets[index].copyWithModel(comments: currentComments);
      await _saveToStorage();
      return newComment;
    }
    throw Exception('Ticket not found');
  }
}
