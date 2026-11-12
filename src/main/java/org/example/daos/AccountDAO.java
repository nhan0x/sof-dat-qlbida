package org.example.daos;

import org.example.models.Account;

public interface AccountDAO {
    Boolean dangKy(String username, String password, String name, String phone, String email, String role);

    Boolean daTonTaiUserName(String username);

    Boolean daTonTaiEmail(String email);

    Account dangNhap(String username, String password);

    java.util.List<Account> getAllAccounts();

    Account getAccountById(int id);

    boolean createAccount(Account acc);

    boolean updateAccount(Account acc);

    boolean deleteAccount(int id);

    java.util.List<Account> searchAccounts(String keyword);

    boolean resetPassword(String email, String newPasswordHashed);

    Account getAccountByEmail(String email);

    boolean updateMatchmakingProfile(int accountId, String rank, String style, String phone, String email);

    /**
     * Người chơi tự chỉnh sửa thông tin cá nhân của mình: họ tên, SĐT, email,
     * cấp độ (member_rank) và phong cách chơi. Không đụng tới role/mật khẩu.
     */
    boolean updatePersonalInfo(Account acc);
}