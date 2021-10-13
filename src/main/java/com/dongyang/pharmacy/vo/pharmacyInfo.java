package com.dongyang.pharmacy.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class pharmacyInfo {
    /*약국이름*/
    private String dutyName;
    private String wgs84Lat;
    private String wgs84Lon;
    private String checkopen;
    private String hpid;
    private String dutyTel1;
    private String dutyAddr;

}
