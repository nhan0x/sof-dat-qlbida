package org.example.models;

public class Cue {
    private int id;
    private String name;
    private String brand;
    private double price_per_hour;
    private String status;
    private String description;

    public Cue() {
    }

    public Cue(int id, String name, String brand, double price_per_hour, String status, String description) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.price_per_hour = price_per_hour;
        this.status = status;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public double getPrice_per_hour() {
        return price_per_hour;
    }

    public void setPrice_per_hour(double price_per_hour) {
        this.price_per_hour = price_per_hour;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
