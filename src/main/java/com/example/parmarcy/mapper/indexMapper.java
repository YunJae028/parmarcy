package com.example.parmarcy.mapper;

import com.example.parmarcy.vo.parmarcyVo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface indexMapper {
    List<parmarcyVo> getParmarcy();

}
