package org.example.models;

import java.time.LocalDateTime;

public class Bill {
    private int bill_id;
    private int table_id;
    private Integer account_id;
    private Integer voucher_id;
    private Integer member_id;
    private LocalDateTime time_start;
    private LocalDateTime time_end;
    private double total;// DEFAULT 0
    private String status;// DEFAULT 'Unpaid'

    public Bill() {
    }

    public Bill(int bill_id, int table_id, Integer account_id, Integer voucher_id, LocalDateTime time_start, LocalDateTime time_end, double total, String status) {
        this.bill_id = bill_id;
        this.table_id = table_id;
        this.account_id = account_id;
        this.voucher_id = voucher_id;
        this.time_start = time_start;
        this.time_end = time_end;
        this.total = total;
        this.status = status;
    }

    public int getBill_id() {
        return bill_id;
    }

    public void setBill_id(int bill_id) {
        this.bill_id = bill_id;
    }

    public int getTable_id() {
        return table_id;
    }

    public void setTable_id(int table_id) {
        this.table_id = table_id;
    }

    public Integer getAccount_id() {
        return account_id;
    }

    public void setAccount_id(Integer account_id) {
        this.account_id = account_id;
    }

    public Integer getVoucher_id() {
        return voucher_id;
    }

    public void setVoucher_id(Integer voucher_id) {
        this.voucher_id = voucher_id;
    }

    public LocalDateTime getTime_start() {
        return time_start;
    }

    public void setTime_start(LocalDateTime time_start) {
        this.time_start = time_start;
    }

    public LocalDateTime getTime_end() {
        return time_end;
    }

    public void setTime_end(LocalDateTime time_end) {
        this.time_end = time_end;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getMemberId() {
        return member_id;
    }

    public void setMemberId(Integer memberId) {
        this.member_id = memberId;
    }
}
