package com.dongyang.pharmacy.service;

import com.dongyang.pharmacy.vo.pharmacyInfo;
import com.dongyang.pharmacy.vo.pharmacySearchInfo;

import java.util.List;

public interface searchPharmacyService {
    public List<pharmacyInfo> getParmarcy();

    public List<pharmacyInfo> getPharmacyList(pharmacySearchInfo info);
}
