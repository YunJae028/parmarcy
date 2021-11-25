package com.dongyang.pharmacy.service;

import com.dongyang.pharmacy.mapper.SearchPharmacyMapper;
import com.dongyang.pharmacy.vo.drugInfo;
import com.dongyang.pharmacy.vo.pharmacyInfo;
import com.dongyang.pharmacy.vo.pharmacySearchInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class SearchPharmacyServiceImpl implements searchPharmacyService {

    private final SearchPharmacyMapper mapper;

    @Override
    public List<pharmacyInfo> getParmarcy() {
        return mapper.getParmarcy();
    }

    @Override
    public List<pharmacyInfo> getPharmacyList(pharmacySearchInfo info) {
        return mapper.getPharmacyList(info);
    }

    @Override
    public List<drugInfo> getDrugList(pharmacySearchInfo info) {
        return mapper.getDrugList(info);
    }

}
