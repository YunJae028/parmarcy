<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
    <header>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="/css/mapstyle.css" rel="stylesheet">
        <title>지도 찾기</title>
    </header>

    <%@ include file="header.jsp" %>
    <body>
        <div class="map-area">
            <button class="openbtn" onclick="openNav()">☰ Open List</button>
            <div class="list-area" style="left:0px; position: absolute;">
                <div id="mySidebar" class="sidebar">
                    <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">×</a>
                    <ul>

                    </ul>
                </div>
            </div>
            <button id="search" style="position: absolute;right: 86px; margin-top: 100px;">재검색</button>
            <div id="map" style="position: relative; width: 1600px;height: 700px;margin-left: 300px;"></div>
        </div>
    </body>

    <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0eec856fe65fd0106ad48250e458cae0&libraries=services"></script>

  <script>
    // 현재 위치 이용하여 약국 검색
    if (navigator.geolocation) {

        var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(37.686040837930676, 127.04676347327286), // 지도의 중심좌표
            level: 2 // 지도의 확대 레벨
        };

        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

        var bounds = null; // 현재 위치
        var markers = [];
        var infoWindows = [];

        // GeoLocation을 이용해서 접속 위치를 얻어옵니다
        navigator.geolocation.getCurrentPosition(function(position) {

            var lat = position.coords.latitude, // 위도
                lon = position.coords.longitude; // 경도

            var coords = new kakao.maps.LatLng(lat, lon);

            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
            map.setCenter(coords);

             bounds = map.getBounds();
            var center = map.getCenter();
           // getInfo();
        // 영역의 남서쪽 좌표를 얻어옵니다
            var swLatLng = bounds.getSouthWest();
            console.log('남서쪽 : ', swLatLng);

            // 영역의 북동쪽 좌표를 얻어옵니다
            var neLatLng = bounds.getNorthEast();
           console.log('북동쪽 : ', neLatLng);
           console.log('북동쪽 Lat : ', neLatLng.getLat());
           console.log('북동쪽 Lng : ', neLatLng.getLng());

            // 영역정보를 문자열로 얻어옵니다. ((남,서), (북,동)) 형식입니다
            var boundsStr = bounds.toString();
            console.log('영역정보 문자열 : ', boundsStr);

            var params = {
                currentLat : lat,
                currentLon : lon,
                swLat : swLatLng.getLat(),
                swLng : swLatLng.getLng(),
                neLat : neLatLng.getLat(),
                neLng : neLatLng.getLng()
            }

            // 현재 위치에서 약국 검색
            $.ajax({
                url:"/pharmacyList",
                type:"GET",
                dataType:"json",
                data : params,
                success:function (data){
                    console.log('ajax :', data);
                }
            });

            //마커 표시
            <c:forEach var="point" items="${list}">
            setMarkerInfo("<c:out value="${point.wgs84Lat}"/>", "<c:out value="${point.wgs84Lon}"/>","<c:out value="${point.checkopen}"/>","<c:out value="${point.hpid}"/>","<c:out value="${point.dutyName}"/>","<c:out value="${point.dutyTel1}"/>","<c:out value="${point.dutyAddr}"/>");
            </c:forEach>

          });

    }

    // 주소를 받아서 검색
  /*  // 주소-좌표 변환 객체를 생성합니다
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
            setMarkerInfo("<c:out value="${point.wgs84Lat}"/>", "<c:out value="${point.wgs84Lon}"/>","<c:out value="${point.checkopen}"/>","<c:out value="${point.hpid}"/>","<c:out value="${point.dutyName}"/>","<c:out value="${point.dutyTel1}"/>","<c:out value="${point.dutyAddr}"/>");
            </c:forEach>

        }
    });*/

    // 약품으로 검색 -> 관리자 구현 후 가능

    //마커 생성 함수
    function setMarkerInfo(lat, lng,checkopen, hpid, dutyName, dutyTel, dutyAddr){
        // 현재위치에서 해당하는 위치 반환
        if(bounds.pa >= lat && bounds.qa <= lat && bounds.ha <= lng && bounds.oa >= lng ){

            console.log(checkopen)
            if(checkopen == '0'){
               imageSrc = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHhtbG5zOnN2Z2pzPSJodHRwOi8vc3ZnanMuY29tL3N2Z2pzIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgeD0iMCIgeT0iMCIgdmlld0JveD0iMCAwIDUxMiA1MTIiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDUxMiA1MTIiIHhtbDpzcGFjZT0icHJlc2VydmUiIGNsYXNzPSIiPjxnPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgoJPGc+CgkJPHBhdGggZD0iTTI1NiwwQzE1My43NTUsMCw3MC41NzMsODMuMTgyLDcwLjU3MywxODUuNDI2YzAsMTI2Ljg4OCwxNjUuOTM5LDMxMy4xNjcsMTczLjAwNCwzMjEuMDM1ICAgIGM2LjYzNiw3LjM5MSwxOC4yMjIsNy4zNzgsMjQuODQ2LDBjNy4wNjUtNy44NjgsMTczLjAwNC0xOTQuMTQ3LDE3My4wMDQtMzIxLjAzNUM0NDEuNDI1LDgzLjE4MiwzNTguMjQ0LDAsMjU2LDB6IE0yNTYsMjc4LjcxOSAgICBjLTUxLjQ0MiwwLTkzLjI5Mi00MS44NTEtOTMuMjkyLTkzLjI5M1MyMDQuNTU5LDkyLjEzNCwyNTYsOTIuMTM0czkzLjI5MSw0MS44NTEsOTMuMjkxLDkzLjI5M1MzMDcuNDQxLDI3OC43MTksMjU2LDI3OC43MTl6IiBmaWxsPSIjZmYwMDAwIiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBzdHlsZT0iIiBjbGFzcz0iIj48L3BhdGg+Cgk8L2c+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPC9nPjwvc3ZnPg=="
               var status = '운영 종료';
            } else {
                imageSrc = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHhtbG5zOnN2Z2pzPSJodHRwOi8vc3ZnanMuY29tL3N2Z2pzIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgeD0iMCIgeT0iMCIgdmlld0JveD0iMCAwIDUxMiA1MTIiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDUxMiA1MTIiIHhtbDpzcGFjZT0icHJlc2VydmUiIGNsYXNzPSIiPjxnPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgoJPGc+CgkJPHBhdGggZD0iTTI1NiwwQzE1My43NTUsMCw3MC41NzMsODMuMTgyLDcwLjU3MywxODUuNDI2YzAsMTI2Ljg4OCwxNjUuOTM5LDMxMy4xNjcsMTczLjAwNCwzMjEuMDM1ICAgIGM2LjYzNiw3LjM5MSwxOC4yMjIsNy4zNzgsMjQuODQ2LDBjNy4wNjUtNy44NjgsMTczLjAwNC0xOTQuMTQ3LDE3My4wMDQtMzIxLjAzNUM0NDEuNDI1LDgzLjE4MiwzNTguMjQ0LDAsMjU2LDB6IE0yNTYsMjc4LjcxOSAgICBjLTUxLjQ0MiwwLTkzLjI5Mi00MS44NTEtOTMuMjkyLTkzLjI5M1MyMDQuNTU5LDkyLjEzNCwyNTYsOTIuMTM0czkzLjI5MSw0MS44NTEsOTMuMjkxLDkzLjI5M1MzMDcuNDQxLDI3OC43MTksMjU2LDI3OC43MTl6IiBmaWxsPSIjMDA4NWZiIiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBzdHlsZT0iIiBjbGFzcz0iIj48L3BhdGg+Cgk8L2c+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPC9nPjwvc3ZnPg=="
                var status = '운영 중';
            }
            imageSize = new kakao.maps.Size(60, 65);
            imageOption = {offset: new kakao.maps.Point(27, 69)};

            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption)
            var markerPosition = new kakao.maps.LatLng(lat, lng);

            var marker = new kakao.maps.Marker({
                position: markerPosition,
                image : markerImage
            });

            marker.setMap(this.map);


            var content = '<div class="wrap">' +
                '    <div class="info">' +
                '        <div class="title">' +
                '            '+dutyName+'' +
                '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' +
                '        </div>' +
                '        <div class="body">' +
                '                <div class="ellipsis"> '+ dutyAddr+ '</div>' +
                '                <div class="jibun ellipsis">'+ dutyTel+ '</div>' +
                '                <div class="jibun ellipsis">'+ status + '</div>' +
                '        </div>' +
                '    </div>' +
                '</div>';

            var infoWindow = new kakao.maps.CustomOverlay({
                content: content,
                position: marker.getPosition()
            });
            infoWindows.push(infoWindow);

            // 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
            kakao.maps.event.addListener(marker, 'click', function() {
                // All infowindow close
                closeOverlay();

                //
                // infoWindow.open(map,marker);
                infoWindow.setMap(map);
            });

            markers.push(marker);
        }
    }

    function closeOverlay() {
        for (var i=0;i<infoWindows.length;i++) {
            infoWindows[i].setMap(null);
        }
    }

    // 아래 코드는 지도 위의 마커를 제거하는 코드입니다
    // marker.setMap(null);


    // 정보
    function getInfo() {
        // 지도의 현재 중심좌표를 얻어옵니다
        var center = map.getCenter();
        console.log("center :", center);

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

        console.log(message);
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
        setMarkerInfo("<c:out value="${point.wgs84Lat}"/>", "<c:out value="${point.wgs84Lon}"/>","<c:out value="${point.checkopen}"/>","<c:out value="${point.hpid}"/>","<c:out value="${point.dutyName}"/>","<c:out value="${point.dutyTel1}"/>","<c:out value="${point.dutyAddr}"/>");
        </c:forEach>
    });

</script>

  <script>
function openNav() {
  document.getElementById("mySidebar").style.width = "300px";
  document.getElementById("map").style.marginLeft = "300px";
}

function closeNav() {
  document.getElementById("mySidebar").style.width = "0";
  document.getElementById("map").style.marginLeft= "0px";
}
</script>

</html>