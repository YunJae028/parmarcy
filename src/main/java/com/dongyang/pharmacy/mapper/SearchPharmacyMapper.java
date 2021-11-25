package com.dongyang.pharmacy.mapper;

import com.dongyang.pharmacy.vo.drugInfo;
import com.dongyang.pharmacy.vo.pharmacyInfo;
import com.dongyang.pharmacy.vo.pharmacySearchInfo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface SearchPharmacyMapper {
    List<pharmacyInfo> getParmarcy();

    List<pharmacyInfo> getPharmacyList(pharmacySearchInfo info);

    List<drugInfo> getDrugList(pharmacySearchInfo info);

}
