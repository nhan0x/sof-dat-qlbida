package org.example.models;

import java.time.LocalDateTime;

public class Matchmaking {
    private int id;
    private int accountId;
    private String hostName;
    private String hostZalo;
    private String tableType;
    private String format;
    private String rankRequirement;
    private LocalDateTime playTime;
    private String note;
    private String status;
    private Integer partnerId;
    private String partnerName;
    private String partnerZalo;
    private LocalDateTime createdAt;

    public Matchmaking() {
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

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public String getHostZalo() {
        return hostZalo;
    }

    public void setHostZalo(String hostZalo) {
        this.hostZalo = hostZalo;
    }

    public String getTableType() {
        return tableType;
    }

    public void setTableType(String tableType) {
        this.tableType = tableType;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public String getRankRequirement() {
        return rankRequirement;
    }

    public void setRankRequirement(String rankRequirement) {
        this.rankRequirement = rankRequirement;
    }

    public LocalDateTime getPlayTime() {
        return playTime;
    }

    public void setPlayTime(LocalDateTime playTime) {
        this.playTime = playTime;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(Integer partnerId) {
        this.partnerId = partnerId;
    }

    public String getPartnerName() {
        return partnerName;
    }

    public void setPartnerName(String partnerName) {
        this.partnerName = partnerName;
    }

    public String getPartnerZalo() {
        return partnerZalo;
    }

    public void setPartnerZalo(String partnerZalo) {
        this.partnerZalo = partnerZalo;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
