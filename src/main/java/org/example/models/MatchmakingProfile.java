package org.example.models;

import java.time.LocalDateTime;

public class MatchmakingProfile {
    private int id;
    private int accountId;
    private String fullName;
    private int age;
    private String rank;
    private String zaloPhone;
    private LocalDateTime createdAt;

    public MatchmakingProfile() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getRank() {
        return rank;
    }

    public void setRank(String rank) {
        this.rank = rank;
    }

    public String getZaloPhone() {
        return zaloPhone;
    }

    public void setZaloPhone(String zaloPhone) {
        this.zaloPhone = zaloPhone;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
