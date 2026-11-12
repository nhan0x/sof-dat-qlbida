package org.example.daos;

import org.example.models.Locker;
import java.time.LocalDateTime;
import java.util.List;

public interface LockerDAO {
    boolean create(Locker locker);
    boolean update(Locker locker);
    boolean delete(int id);
    Locker getById(int id);
    List<Locker> getAll();
    List<Locker> search(String keyword);
    Locker getByMemberId(int memberId);
    boolean assignMember(int lockerId, Integer memberId, String customerName, LocalDateTime start, LocalDateTime end, double price, String note, String status);
    boolean confirmRental(int lockerId);
    boolean releaseLocker(int lockerId);
}
