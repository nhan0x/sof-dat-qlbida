package org.example.daos;

import org.example.models.BookingDetail;
import java.util.List;

public interface BookingDetailDAO {
    List<BookingDetail> getByBookingId(int bookingId);
    boolean create(BookingDetail detail);
    boolean deleteByBookingId(int bookingId);
}
