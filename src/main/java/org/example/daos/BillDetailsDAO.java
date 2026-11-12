package org.example.daos;

import org.example.models.BillDetails;
import java.util.List;

public interface BillDetailsDAO {
    List<BillDetails> getDetailsByBillId(int billId);
    boolean addDetail(BillDetails detail);
    boolean updateDetail(BillDetails detail);
    boolean deleteDetail(int id);
    BillDetails getDetailByBillAndService(int billId, int serviceId);
}

