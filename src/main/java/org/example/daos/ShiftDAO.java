package org.example.daos;

import org.example.models.Shift;
import java.util.List;

public interface ShiftDAO {
    Shift getActiveShiftByAccountId(int accountId);
    boolean openShift(Shift shift);
    /**
     * Đóng ca kèm số tiền thực tế nhân viên nộp/đếm được trong két và ghi chú bàn giao/giải trình.
     */
    boolean closeShift(int shiftId, double totalRevenue, double closingBalance);
    boolean closeShift(int shiftId, double initialBalance, double totalRevenue, double closingBalance, String note);
    List<Shift> getAllShifts();
    Shift getShiftById(int id);
}
