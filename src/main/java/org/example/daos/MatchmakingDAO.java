package org.example.daos;

import org.example.models.Matchmaking;

import java.util.List;

public interface MatchmakingDAO {
    boolean create(Matchmaking match);

    List<Matchmaking> getAllWaiting();

    List<Matchmaking> getByAccountId(int accountId);

    List<Matchmaking> getByPartnerId(int partnerId);

    Matchmaking getById(int id);

    boolean joinMatch(int matchId, int partnerId);

    boolean cancelMatch(int matchId);
}
