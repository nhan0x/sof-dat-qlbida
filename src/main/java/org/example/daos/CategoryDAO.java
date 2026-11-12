package org.example.daos;

import org.example.models.Category;
import java.util.List;

public interface CategoryDAO {
    List<Category> getAll();
    Category getById(int id);
    Category getByName(String name);
    Category getAnyByName(String name);
    boolean create(Category category);
    boolean update(Category category);
    boolean delete(int id);
}
