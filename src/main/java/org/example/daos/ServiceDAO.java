package org.example.daos;

import org.example.models.Service;
import java.util.List;

public interface ServiceDAO {
    List<Service> getAll();
    Service getById(int id);
    boolean create(Service service);
    boolean update(Service service);
    boolean delete(int id);
}

