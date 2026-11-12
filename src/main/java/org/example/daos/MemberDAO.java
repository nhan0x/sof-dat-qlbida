package org.example.daos;

import org.example.models.Member;
import java.util.List;

public interface MemberDAO {
    List<Member> getAll();
    Member getById(int id);
    Member getByPhone(String phone);
    boolean create(Member member, String plainPassword);
    boolean update(Member member);
    boolean delete(int id);
    boolean addPoints(int id, int pointsToAdd);
    List<Member> search(String keyword);
}
