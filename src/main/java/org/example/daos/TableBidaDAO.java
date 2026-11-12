package org.example.daos;

import org.example.models.TableBida;
import java.util.List;

public interface TableBidaDAO {
    List<TableBida> getAll();

    TableBida getById(int id);

    boolean create(TableBida table);

    boolean update(TableBida table);

    boolean delete(int id);
}
