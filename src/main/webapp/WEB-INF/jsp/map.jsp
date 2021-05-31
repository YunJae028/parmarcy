<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>간단한 지도 표시하기</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=a4vj6jrblt"></script>
</head>
<body>
<div id="map" style="width:100%;height:400px;"></div>

    <script type="text/javascript">

    var m = new Array();

    var t = new Array();

    <c:set var="i" value="0" />

    <c:choose>

    <c:when test="${!empty result}">

    <c:forEach items="${result}" var="result">

    m[${i}] = new naver.maps.LatLng(${result.wgs84Lat},${result.wgs84Lon});

    t[${i}] = '${result.dutyName}';

    <c:set var="i" value="${i+1}" />

    </c:forEach>

    </c:when>

    <c:otherwise>

    m[0] = new naver.maps.LatLng(37.56661, 126.978388);

    t[0] = '검색결과가 없습니다.'

    </c:otherwise>

    </c:choose>

    //var defaultLevel = 7;

    //var map = new naver.maps.Map('map',{

    var map = new naver.maps.Map(document.getElementById('map'), {
        //  center : new naver.maps.LatLng(37.566285,126.977960),
        center : new naver.maps.LatLng(m[0]),

        zoom : 6,

        size : new naver.maps.Size(890, 250)

    });


    var markers = [],infoWindows = [];

    for (var ii=0; ii<m.length; ii++) {

        var icon = {

                url: 'http://static.naver.net/maps/v3/pin_default.png',
                size: new naver.maps.Size(24, 37),
                anchor: new naver.maps.Point(12, 37),
                origin: new naver.maps.Point(ii * 29, 0)

            },

            marker = new naver.maps.Marker({

                position: m[ii],
                map: map,
                icon: icon,
                shadow: {

                    url: 'http://static.naver.net/maps/v3/pin_default.png',

                    size: new naver.maps.Size(40, 35),
                    origin: new naver.maps.Point(0, 0),
                    anchor: new naver.maps.Point(11, 35)

                }

            });

        var infoWindow = new naver.maps.InfoWindow({ content:t[ii] });

        markers.push(marker);
        infoWindows.push(infoWindow);

    }


    // 해당 마커의 인덱스를 seq라는 클로저 변수로 저장하는 이벤트 핸들러를 반환합니다.

    function getClickHandler(seq) {
        return function(e) {
            var marker = markers[seq];
            var infoWindow = infoWindows[seq];

            if (infoWindow.getMap()) {
                infoWindow.close();
            } else {
                infoWindow.open(map, marker);
            }
        }
    }


    for (var i=0; i<markers.length; i++) {
        naver.maps.Event.addListener(markers[i],  'click', getClickHandler(i));
    }

</script>
</body>
</html>