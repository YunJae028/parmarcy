package com.dongyang.pharmacy.controller;

import com.dongyang.pharmacy.service.searchPharmacyService;
import com.dongyang.pharmacy.vo.pharmacyInfo;
import com.dongyang.pharmacy.vo.pharmacySearchInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@RequiredArgsConstructor
@RestController
public class SearchPharmacyController {

    private final searchPharmacyService service;

    @GetMapping("/search/pharmacy")
    public ModelAndView searchPharmacy(){
        ModelAndView mav = new ModelAndView("searchPharmacy");

        List<pharmacyInfo> parmarcyList = service.getParmarcy();
        mav.addObject("list", parmarcyList);

        return mav;
    }

    @GetMapping("/pharmacyList")
    public @ResponseBody List<pharmacyInfo> getPharmacyList(pharmacySearchInfo info){
        List<pharmacyInfo> pharmacyList = service.getPharmacyList(info);
        return pharmacyList;
    }


/*    @GetMapping("/")
    public ModelAndView main(){
        ModelAndView mav = new ModelAndView("main");

        List<parmarcyVo> parmarcyList = service.getParmarcy();
        mav.addObject("list", parmarcyList);

        return mav;
    }*/
}
