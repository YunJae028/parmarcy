package com.dongyang.pharmacy.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class pharmacySearchInfo {
     private Double currentLat;
     private Double currentLon;
     private Double swLat;
     private Double swLng;
     private Double neLat;
     private Double neLng;
     private String searchOption;
     private String hpid;
     private String searchDrugNm;

}
