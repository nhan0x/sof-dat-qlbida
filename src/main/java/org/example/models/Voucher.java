package org.example.models;

import java.time.LocalDateTime;

public class Voucher {
    private int id;
    private String code;
    private double discount_value;
    private LocalDateTime expire_date;
    private boolean is_active;

    public Voucher() {
    }

    public Voucher(int id, String code, double discount_value, LocalDateTime expire_date, boolean is_active) {
        this.id = id;
        this.code = code;
        this.discount_value = discount_value;
        this.expire_date = expire_date;
        this.is_active = is_active;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getDiscount_value() {
        return discount_value;
    }

    public void setDiscount_value(double discount_value) {
        this.discount_value = discount_value;
    }

    public LocalDateTime getExpire_date() {
        return expire_date;
    }

    public void setExpire_date(LocalDateTime expire_date) {
        this.expire_date = expire_date;
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }
}
