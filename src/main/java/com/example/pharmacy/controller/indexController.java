package com.example.pharmacy.controller;

import com.example.pharmacy.service.indexService;
import com.example.pharmacy.vo.pharmacyInfo;
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

        List<pharmacyInfo> parmarcyList = service.getParmarcy();
        mav.addObject("list", parmarcyList);

        return mav;
    }


/*    @GetMapping("/")
    public ModelAndView main(){
        ModelAndView mav = new ModelAndView("main");

        List<parmarcyVo> parmarcyList = service.getParmarcy();
        mav.addObject("list", parmarcyList);

        return mav;
    }*/
}
