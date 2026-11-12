package org.example.utils;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Singleton in-memory queue for real-time booking notifications.
 * Stores notifications for up to RETENTION_MS milliseconds, then prunes them.
 * Employees/admins poll via SSE and receive any notifications newer than
 * their last-seen timestamp.
 */
public class NotificationQueue {

    /** How long (ms) to keep a notification in the queue (5 minutes) */
    private static final long RETENTION_MS = 5 * 60 * 1000;

    /** Singleton */
    private static final NotificationQueue INSTANCE = new NotificationQueue();

    public static NotificationQueue getInstance() {
        return INSTANCE;
    }

    // -------------------------------------------------------
    /** Immutable notification payload */
    public static class Notification {
        public final long timestamp;
        public final String customerName;
        public final String tableName;
        public final String playTime;
        public final int    duration;
        public final int    bookingId;
        public final String paymentType;

        public Notification(String customerName, String tableName, String playTime, int duration, int bookingId, String paymentType) {
            this.timestamp    = Instant.now().toEpochMilli();
            this.customerName = customerName;
            this.tableName    = tableName;
            this.playTime     = playTime;
            this.duration     = duration;
            this.bookingId    = bookingId;
            this.paymentType  = paymentType != null ? paymentType : "Trả sau";
        }
    }

    /** Immutable notification for deleted bills */
    public static class DeletedBillNotification {
        public final long timestamp;
        public final int billId;
        public final String tableName;
        public final String staffName;
        public final double total;
        public final String reason;

        public DeletedBillNotification(int billId, String tableName, String staffName, double total, String reason) {
            this.timestamp = Instant.now().toEpochMilli();
            this.billId = billId;
            this.tableName = tableName != null ? tableName : "Bàn không rõ";
            this.staffName = staffName != null ? staffName : "Nhân viên";
            this.total = total;
            this.reason = reason != null ? reason : "Xóa hóa đơn";
        }
    }
    // -------------------------------------------------------

    private final CopyOnWriteArrayList<Notification> queue = new CopyOnWriteArrayList<>();
    private final CopyOnWriteArrayList<DeletedBillNotification> deletedBillQueue = new CopyOnWriteArrayList<>();

    private NotificationQueue() {}

    /** Called by BookingServlet when a booking is confirmed */
    public void push(Notification n) {
        queue.add(n);
        prune();
    }

    /** Called when an employee or admin deletes a bill */
    public void pushDeletedBill(DeletedBillNotification n) {
        deletedBillQueue.add(n);
        prune();
    }

    /**
     * Returns all notifications with timestamp > sinceTimestamp.
     * Used by the SSE servlet to send only new events.
     */
    public List<Notification> getNewerThan(long sinceTimestamp) {
        prune();
        List<Notification> result = new ArrayList<>();
        for (Notification n : queue) {
            if (n.timestamp > sinceTimestamp) {
                result.add(n);
            }
        }
        return result;
    }

    public List<DeletedBillNotification> getNewerDeletedBills(long sinceTimestamp) {
        prune();
        List<DeletedBillNotification> result = new ArrayList<>();
        for (DeletedBillNotification n : deletedBillQueue) {
            if (n.timestamp > sinceTimestamp) {
                result.add(n);
            }
        }
        return result;
    }

    /** Return the latest notification timestamp (0 if empty) */
    public long latestTimestamp() {
        long max = 0;
        for (Notification n : queue) {
            if (n.timestamp > max) max = n.timestamp;
        }
        for (DeletedBillNotification n : deletedBillQueue) {
            if (n.timestamp > max) max = n.timestamp;
        }
        return max;
    }

    /** Remove notifications older than RETENTION_MS */
    private void prune() {
        long cutoff = Instant.now().toEpochMilli() - RETENTION_MS;
        queue.removeIf(n -> n.timestamp < cutoff);
        deletedBillQueue.removeIf(n -> n.timestamp < cutoff);
    }
}
