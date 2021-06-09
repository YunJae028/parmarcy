package com.example.pharmacy.service;

import com.example.pharmacy.mapper.indexMapper;
import com.example.pharmacy.vo.pharmacyInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class indxServiceImpl implements indexService{

    private final indexMapper mapper;

    public List<pharmacyInfo> getParmarcy() {
        return mapper.getParmarcy();
    }
}
