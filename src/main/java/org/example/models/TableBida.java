package org.example.models;

public class TableBida {
    private int id;
    private String name;
    private String status;
    private int tableTypeId;
    private String tableTypeName;
    private double pricePerHour;
    private String cameraIp;
    private String cameraPort;
    private String cameraUsername;
    private String cameraPassword;

    public TableBida() {
    }

    public TableBida(int id, String name, String status) {
        this.id = id;
        this.name = name;
        this.status = status;
    }

    public TableBida(int id, String name, String status, int tableTypeId) {
        this.id = id;
        this.name = name;
        this.status = status;
        this.tableTypeId = tableTypeId;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getTableTypeId() {
        return tableTypeId;
    }

    public void setTableTypeId(int tableTypeId) {
        this.tableTypeId = tableTypeId;
    }

    public String getTableTypeName() {
        return tableTypeName;
    }

    public void setTableTypeName(String tableTypeName) {
        this.tableTypeName = tableTypeName;
    }

    public double getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(double pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public String getCameraIp() {
        return cameraIp;
    }

    public void setCameraIp(String cameraIp) {
        this.cameraIp = cameraIp;
    }

    public String getCameraPort() {
        return cameraPort;
    }

    public void setCameraPort(String cameraPort) {
        this.cameraPort = cameraPort;
    }

    public String getCameraUsername() {
        return cameraUsername;
    }

    public void setCameraUsername(String cameraUsername) {
        this.cameraUsername = cameraUsername;
    }

    public String getCameraPassword() {
        return cameraPassword;
    }

    public void setCameraPassword(String cameraPassword) {
        this.cameraPassword = cameraPassword;
    }

    public boolean isCameraConfigured() {
        return cameraIp != null && !cameraIp.trim().isEmpty();
    }
}
