package com.sh.spring.publicdata.airpollution.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Item {

    private String stationName;
    private String mangName;
    private String sidoName;
    private String dataTime;
    
    private String so2Value;
    private String coValue;
    private String o3Value;
    private String no2Value;
    private String pm10Value;
    private String pm10Value24;
    private String pm25Value;
    private String pm25Value24;
    private String khaiValue;
    
    private String khaiGrade;
    private String so2Grade;
    private String coGrade;
    private String o3Grade;
    private String no2Grade;
    private String pm10Grade;
    private String pm25Grade;
    private String pm10Grade1h;
    private String pm25Grade1h;
    
    private String so2Flag;
    private String coFlag;
    private String o3Flag;
    private String no2Flag;
    private String pm10Flag;
    private String pm25Flag;
}


