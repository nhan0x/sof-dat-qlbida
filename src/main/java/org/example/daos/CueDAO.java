package org.example.daos;

import org.example.models.Cue;

import java.util.List;

public interface CueDAO {
    // Create
    Boolean create(String name, String brand, float pricePerHour, String status, String description);

    // Read
    List<Cue> getAll();
    Cue getById(int id);

    // Update
    Boolean update(int id, String name, String brand, float pricePerHour, String status, String description);

    // Delete
    Boolean delete(int id);
}
