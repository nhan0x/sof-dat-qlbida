package org.example.models;

import java.time.LocalDateTime;

public class CueRental {
    private int id;
    private int bill_id;
    private int cue_id;
    private LocalDateTime rental_start;
    private LocalDateTime rental_end;
    private double price;

    public CueRental() {
    }

    public CueRental(int id, int bill_id, int cue_id, LocalDateTime rental_start, LocalDateTime rental_end, double price) {
        this.id = id;
        this.bill_id = bill_id;
        this.cue_id = cue_id;
        this.rental_start = rental_start;
        this.rental_end = rental_end;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBill_id() {
        return bill_id;
    }

    public void setBill_id(int bill_id) {
        this.bill_id = bill_id;
    }

    public int getCue_id() {
        return cue_id;
    }

    public void setCue_id(int cue_id) {
        this.cue_id = cue_id;
    }

    public LocalDateTime getRental_start() {
        return rental_start;
    }

    public void setRental_start(LocalDateTime rental_start) {
        this.rental_start = rental_start;
    }

    public LocalDateTime getRental_end() {
        return rental_end;
    }

    public void setRental_end(LocalDateTime rental_end) {
        this.rental_end = rental_end;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
