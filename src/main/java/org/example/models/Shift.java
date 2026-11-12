package org.example.models;

import java.time.LocalDateTime;

public class Shift {
    private int id;
    private int accountId;
    private LocalDateTime timeStart;
    private LocalDateTime timeEnd;
    private double initialBalance;
    private double totalRevenue;
    /** Số tiền thực tế nhân viên đếm được trong két khi đóng ca. */
    private double closingBalance;
    private String status;
    private String note;

    public Shift() {
    }

    public Shift(int id, int accountId, LocalDateTime timeStart, LocalDateTime timeEnd, double initialBalance, double totalRevenue, String status) {
        this.id = id;
        this.accountId = accountId;
        this.timeStart = timeStart;
        this.timeEnd = timeEnd;
        this.initialBalance = initialBalance;
        this.totalRevenue = totalRevenue;
        this.status = status;
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

    public LocalDateTime getTimeStart() {
        return timeStart;
    }

    public void setTimeStart(LocalDateTime timeStart) {
        this.timeStart = timeStart;
    }

    public LocalDateTime getTimeEnd() {
        return timeEnd;
    }

    public void setTimeEnd(LocalDateTime timeEnd) {
        this.timeEnd = timeEnd;
    }

    public double getInitialBalance() {
        return initialBalance;
    }

    public void setInitialBalance(double initialBalance) {
        this.initialBalance = initialBalance;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public double getClosingBalance() {
        return closingBalance;
    }

    public void setClosingBalance(double closingBalance) {
        this.closingBalance = closingBalance;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
