package com.example.pharmacy.mapper;

import com.example.pharmacy.vo.pharmacyInfo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface indexMapper {
    List<pharmacyInfo> getParmarcy();

}
