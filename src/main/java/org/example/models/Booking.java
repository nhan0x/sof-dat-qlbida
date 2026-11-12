package org.example.models;

import java.time.LocalDateTime;

public class Booking {
    private int id;
    private int account_id;
    private int table_id;
    private LocalDateTime booking_time;
    private LocalDateTime play_time;
    private String status;
    private int duration;
    private String payment_type;

    public Booking() {
    }

    public Booking(int id, int accountId, int tableId, LocalDateTime bookingTime, LocalDateTime playTime, String status) {
        this.id = id;
        this.account_id = accountId;
        this.table_id = tableId;
        this.booking_time = bookingTime;
        this.play_time = playTime;
        this.status = status;
    }

    public Booking(int id, int accountId, int tableId, LocalDateTime bookingTime, LocalDateTime playTime, String status, int duration, String paymentType) {
        this.id = id;
        this.account_id = accountId;
        this.table_id = tableId;
        this.booking_time = bookingTime;
        this.play_time = playTime;
        this.status = status;
        this.duration = duration;
        this.payment_type = paymentType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAccountId() {
        return account_id;
    }

    public void setAccountId(int accountId) {
        this.account_id = accountId;
    }

    public int getTable_id() {
        return table_id;
    }

    public void setTable_id(int table_id) {
        this.table_id = table_id;
    }

    public LocalDateTime getBookingTime() {
        return booking_time;
    }

    public void setBookingTime(LocalDateTime bookingTime) {
        this.booking_time = bookingTime;
    }

    public LocalDateTime getPlayTime() {
        return play_time;
    }

    public void setPlayTime(LocalDateTime playTime) {
        this.play_time = playTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getPaymentType() {
        return payment_type;
    }

    public void setPaymentType(String paymentType) {
        this.payment_type = paymentType;
    }
}

