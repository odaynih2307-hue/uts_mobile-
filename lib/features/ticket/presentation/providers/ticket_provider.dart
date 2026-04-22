import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../../data/datasources/ticket_mock_datasource.dart';
import '../../data/repositories/ticket_repository_impl.dart';

// --- Injection Providers ---
final ticketDataSourceProvider = Provider<TicketMockDataSource>((ref) {
  return TicketMockDataSource(); // Singleton
});

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  return TicketRepositoryImpl(
    remoteDataSource: ref.watch(ticketDataSourceProvider),
  );
});

// --- State Classes ---
class TicketListState {
  final bool isLoading;
  final List<Ticket> tickets;
  final String? errorMessage;
  final String filterStatus; // 'semua', 'pending', 'proses', 'selesai'
  final String searchQuery;
  final bool isDescending;

  const TicketListState({
    this.isLoading = false,
    this.tickets = const [],
    this.errorMessage,
    this.filterStatus = 'semua',
    this.searchQuery = '',
    this.isDescending = true,
  });

  TicketListState copyWith({
    bool? isLoading,
    List<Ticket>? tickets,
    String? errorMessage,
    String? filterStatus,
    String? searchQuery,
    bool? isDescending,
  }) {
    return TicketListState(
      isLoading: isLoading ?? this.isLoading,
      tickets: tickets ?? this.tickets,
      errorMessage: errorMessage,
      filterStatus: filterStatus ?? this.filterStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      isDescending: isDescending ?? this.isDescending,
    );
  }

  List<Ticket> get filteredTickets {
    List<Ticket> list = List.from(tickets);
    
    // Filter by status
    if (filterStatus != 'semua') {
      list = list.where((t) => t.status == filterStatus).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      list = list.where((t) => 
        t.title.toLowerCase().contains(query) || 
        t.description.toLowerCase().contains(query)
      ).toList();
    }
    
    // Sort
    list.sort((a, b) => isDescending 
      ? b.createdAt.compareTo(a.createdAt) 
      : a.createdAt.compareTo(b.createdAt));
      
    return list;
  }
}

// --- Notifiers ---
class TicketListNotifier extends Notifier<TicketListState> {
  late TicketRepository _repository;

  @override
  TicketListState build() {
    _repository = ref.watch(ticketRepositoryProvider);
    Future.microtask(() => loadTickets());
    return const TicketListState();
  }

  Future<void> loadTickets() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.getTickets();
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.message),
      (tickets) => state = state.copyWith(isLoading: false, tickets: List.from(tickets)),
    );
  }

  void setFilter(String status) {
    state = state.copyWith(filterStatus: status);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleSortOrder() {
    state = state.copyWith(isDescending: !state.isDescending);
  }

  Future<bool> createTicket(String title, String desc, String priority, String creatorId, String creatorName, String? imagePath) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.createTicket(title, desc, priority, creatorId, creatorName, imagePath);
    
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (newTicket) {
        final updatedList = List<Ticket>.from(state.tickets)..insert(0, newTicket);
        state = state.copyWith(isLoading: false, tickets: updatedList);
        return true;
      },
    );
  }

  Future<bool> updateStatus(String id, String status, {String? assigneeId, String? assigneeName}) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.updateTicketStatus(id, status, assigneeId: assigneeId, assigneeName: assigneeName);
    
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (updatedTicket) {
        final index = state.tickets.indexWhere((t) => t.id == id);
        if (index >= 0) {
          final newList = List<Ticket>.from(state.tickets);
          newList[index] = updatedTicket;
          state = state.copyWith(isLoading: false, tickets: newList);
        } else {
           state = state.copyWith(isLoading: false);
        }
        return true;
      },
    );
  }

  Future<bool> addComment(String ticketId, String userId, String userName, String message) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.addComment(ticketId, userId, userName, message);
    
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (newComment) {
        final index = state.tickets.indexWhere((t) => t.id == ticketId);
        if (index >= 0) {
          final ticket = state.tickets[index];
          final currentComments = List<TicketComment>.from(ticket.comments)..add(newComment);
          final newList = List<Ticket>.from(state.tickets);
          newList[index] = ticket.copyWith(comments: currentComments);
          state = state.copyWith(isLoading: false, tickets: newList);
        } else {
          state = state.copyWith(isLoading: false);
        }
        return true;
      },
    );
  }
}

// --- Providers ---
final ticketListNotifierProvider = NotifierProvider<TicketListNotifier, TicketListState>(() {
  return TicketListNotifier();
});

// A provider for fetching detail dynamically
final ticketDetailProvider = FutureProvider.family<Ticket, String>((ref, id) async {
  final repo = ref.watch(ticketRepositoryProvider);
  final result = await repo.getTicketDetail(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (ticket) => ticket,
  );
});
