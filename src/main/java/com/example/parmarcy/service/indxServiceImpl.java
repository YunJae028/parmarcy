package com.example.parmarcy.service;

import com.example.parmarcy.mapper.indexMapper;
import com.example.parmarcy.vo.parmarcyVo;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class indxServiceImpl implements indexService{

    private final indexMapper mapper;

    public List<parmarcyVo> getParmarcy() {
        return mapper.getParmarcy();
    }
}
