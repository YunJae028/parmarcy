<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <meta charset="utf-8">
    <title>마커 생성하기</title>

</head>
<body>
<button id="search">재검색</button>
<div id="map" style="width:100%;height:800px;"></div>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0eec856fe65fd0106ad48250e458cae0&libraries=services"></script>
<script>

    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(37.686040837930676, 127.04676347327286), // 지도의 중심좌표
            level: 2 // 지도의 확대 레벨
        };

    var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

    var bounds = null; // 현재 위치
    var markers = [];

    // 주소-좌표 변환 객체를 생성합니다
    var geocoder = new kakao.maps.services.Geocoder();

    // 주소로 좌표를 검색합니다
    geocoder.addressSearch('은평구 역촌동', function(result, status) {

        // 정상적으로 검색이 완료됐으면
        if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
            map.setCenter(coords);

            getInfo();

            //마커 표시
            <c:forEach var="point" items="${list}">
            setMarkerInfo("<c:out value="${point.wgs84Lat}"/>", "<c:out value="${point.wgs84Lon}"/>");
            </c:forEach>

        }
    });

    //마커 생성 함수
    function setMarkerInfo(lat, lng){
        // 현재위치에서 해당하는 위치 반환
        if(bounds.pa >= lat && bounds.qa <= lat && bounds.ha <= lng && bounds.oa >= lng ){
            var markerPosition = new kakao.maps.LatLng(lat, lng);

            marker = new kakao.maps.Marker({
                position: markerPosition
            });

            marker.setMap(this.map);

            markers.push(marker);
        }
    }

    // 아래 코드는 지도 위의 마커를 제거하는 코드입니다
    // marker.setMap(null);

    // 정보
    function getInfo() {
        // 지도의 현재 중심좌표를 얻어옵니다
        var center = map.getCenter();
        console.log(center);

        // 지도의 현재 레벨을 얻어옵니다
        var level = map.getLevel();
        console.log(level);

        // 지도타입을 얻어옵니다
        var mapTypeId = map.getMapTypeId();
        console.log(mapTypeId);

        // 지도의 현재 영역을 얻어옵니다
        bounds = map.getBounds();
        console.log(bounds);

        // 영역의 남서쪽 좌표를 얻어옵니다
        var swLatLng = bounds.getSouthWest();
        console.log(swLatLng);

        // 영역의 북동쪽 좌표를 얻어옵니다
        var neLatLng = bounds.getNorthEast();
        console.log(neLatLng);

        // 영역정보를 문자열로 얻어옵니다. ((남,서), (북,동)) 형식입니다
        var boundsStr = bounds.toString();


        var message = '지도 중심좌표는 위도 ' + center.getLat() + ', <br>';
        message += '경도 ' + center.getLng() + ' 이고 <br>';
        message += '지도 레벨은 ' + level + ' 입니다 <br> <br>';
        message += '지도 타입은 ' + mapTypeId + ' 이고 <br> ';
        message += '지도의 남서쪽 좌표는 ' + swLatLng.getLat() + ', ' + swLatLng.getLng() + ' 이고 <br>';
        message += '북동쪽 좌표는 ' + neLatLng.getLat() + ', ' + neLatLng.getLng() + ' 입니다';

        // 개발자도구를 통해 직접 message 내용을 확인해 보세요.
        // ex) console.log(message);
    }

    // 배열에 추가된 마커들을 지도에 표시하거나 삭제하는 함수입니다
    function setMarkers(map) {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(map);
        }
    }


    $('#search').click(function (){
        setMarkers(null);

        bounds = map.getBounds();

        //마커 표시
        <c:forEach var="point" items="${list}">
        setMarkerInfo("<c:out value="${point.wgs84Lat}"/>", "<c:out value="${point.wgs84Lon}"/>");
        </c:forEach>
    });


</script>
</body>
</html>