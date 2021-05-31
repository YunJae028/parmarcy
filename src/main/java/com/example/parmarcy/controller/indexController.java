package com.example.parmarcy.controller;

import com.example.parmarcy.service.indexService;
import com.example.parmarcy.vo.parmarcyVo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@RequiredArgsConstructor
@RestController
public class indexController {

    private final indexService service;

    @GetMapping("/")
    public ModelAndView index(){
        ModelAndView mav = new ModelAndView("map");

        List<parmarcyVo> parmarcyList = service.getParmarcy();
        mav.addObject("list", parmarcyList);

        return mav;
    }
}
