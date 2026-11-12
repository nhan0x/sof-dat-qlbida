package org.example.daos;

import org.example.models.TableType;
import java.util.List;

public interface TableTypeDAO {
    List<TableType> getAll();

    TableType getById(int id);

    boolean create(TableType tableType);

    boolean update(TableType tableType);

    boolean delete(int id);
}
