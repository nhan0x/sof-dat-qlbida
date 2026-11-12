package org.example.models;

public class BillDetails {
    private int id;
    private int  bill_id;
    private int service_id;
    private int quantity;
    private double price;

    public BillDetails() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBillId() {
        return bill_id;
    }

    public void setBillId(int billId) {
        this.bill_id = billId;
    }

    public int getService_id() {
        return service_id;
    }

    public void setService_id(int service_id) {
        this.service_id = service_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public BillDetails(int id, int billId, int service_id, int quantity, double price) {
        this.id = id;
        this.bill_id = billId;
        this.service_id = service_id;
        this.quantity = quantity;
        this.price = price;
    }
}
