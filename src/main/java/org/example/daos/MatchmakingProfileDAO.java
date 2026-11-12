package org.example.daos;

import org.example.models.MatchmakingProfile;

import java.util.List;

public interface MatchmakingProfileDAO {
    List<MatchmakingProfile> getAll();

    MatchmakingProfile getById(int id);

    MatchmakingProfile getByAccountId(int accountId);

    boolean upsert(MatchmakingProfile profile);
}
