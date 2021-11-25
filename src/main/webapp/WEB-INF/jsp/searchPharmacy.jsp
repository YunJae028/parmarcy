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
            <button class="openbtn" onclick="openNav()">💊 Open List</button>
            <div class="list-area" style="left:0px; position: absolute;">
                <div id="mySidebar" class="sidebar">
                    <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">×</a>
                        <div id="list"></div>
                </div>
            </div>
            <select name="searchOption">
                <option value="">검색옵션</option>
                <option value="place">위치</option>
                <option value="drug">약품명</option>
            </select>
            <input id="place" />
            <button id="search" style="position: absolute;right: 20px; margin-top: 100px;">검색</button>
            <button id="currentSearch" style="position: absolute;right: 86px; margin-top: 100px;">현재 위치에서 검색</button>
            <div id="map" style="position: relative; width: 1550px;height: 700px;margin-left: 350px;"></div>
        </div>

        <div class="background">
          <div class="window">
            <div class="popup">
              <button id="closePop">×</button>
              <div id="drugList">

              </div>
            </div>
            <div>
              <div></div>
            </div>
          </div>
        </div>

    </body>

    <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0eec856fe65fd0106ad48250e458cae0&libraries=services"></script>

  <script>
        var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(37.686040837930676, 127.04676347327286), // 지도의 중심좌표
            level: 1 // 지도의 확대 레벨
        };

        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

        var bounds = null; // 현재 위치
        var markers = [];
        var infoWindows = [];

        // 현재 위치 이용하여 약국 검색
        if (navigator.geolocation) {
            // GeoLocation을 이용해서 접속 위치를 얻어옵니다
            navigator.geolocation.getCurrentPosition(function(position) {

                var lat = position.coords.latitude, // 위도
                    lon = position.coords.longitude; // 경도

                var coords = new kakao.maps.LatLng(lat, lon);

                // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                map.setCenter(coords);

                bounds = map.getBounds();
                var center = map.getCenter();

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
                    //마커 표시
                     searchMarkerInfo(data);
                     $.each(data, function (index, item){
                         $("#list").append("<ul>"+item.dutyName + "</ul>");
                         $("#list").append("<ul>"+item.dutyAddr+"</ul>");
                         $("#list").append("<ul>"+item.dutyTel1+"</ul>");
                     });
                }
            });

        });
        } else {
                var params = {
                    currentLat :  37.500501354129156,
                    currentLon : 126.86761643487512
                }

                // 현재 위치에서 약국 검색
                $.ajax({
                url:"/pharmacyList",
                type:"GET",
                dataType:"json",
                data : params,
                success:function (data){
                    console.log('ajax :', data);
                    //마커 표시
                     searchMarkerInfo(data);
                     $.each(data, function (index, item){
                         $("#list").append("<ul>"+item.dutyName + "</ul>");
                         $("#list").append("<ul>"+item.dutyAddr+"</ul>");
                         $("#list").append("<ul>"+item.dutyTel1+"</ul>");
                     });
                }
            });
        }

    // 약품으로 검색 -> 관리자 구현 후 가능

    function closeOverlay() {
        for (var i=0;i<infoWindows.length;i++) {
            infoWindows[i].setMap(null);
        }
    }

    function searchMarkerInfo(list){
        $.each(list, function (index, item){
            var checkOpen = item.checkopen;

            if(checkOpen == '0'){
                 imageSrc = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHhtbG5zOnN2Z2pzPSJodHRwOi8vc3ZnanMuY29tL3N2Z2pzIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgeD0iMCIgeT0iMCIgdmlld0JveD0iMCAwIDUxMiA1MTIiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDUxMiA1MTIiIHhtbDpzcGFjZT0icHJlc2VydmUiIGNsYXNzPSIiPjxnPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgoJPGc+CgkJPHBhdGggZD0iTTI1NiwwQzE1My43NTUsMCw3MC41NzMsODMuMTgyLDcwLjU3MywxODUuNDI2YzAsMTI2Ljg4OCwxNjUuOTM5LDMxMy4xNjcsMTczLjAwNCwzMjEuMDM1ICAgIGM2LjYzNiw3LjM5MSwxOC4yMjIsNy4zNzgsMjQuODQ2LDBjNy4wNjUtNy44NjgsMTczLjAwNC0xOTQuMTQ3LDE3My4wMDQtMzIxLjAzNUM0NDEuNDI1LDgzLjE4MiwzNTguMjQ0LDAsMjU2LDB6IE0yNTYsMjc4LjcxOSAgICBjLTUxLjQ0MiwwLTkzLjI5Mi00MS44NTEtOTMuMjkyLTkzLjI5M1MyMDQuNTU5LDkyLjEzNCwyNTYsOTIuMTM0czkzLjI5MSw0MS44NTEsOTMuMjkxLDkzLjI5M1MzMDcuNDQxLDI3OC43MTksMjU2LDI3OC43MTl6IiBmaWxsPSIjZmYwMDAwIiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBzdHlsZT0iIiBjbGFzcz0iIj48L3BhdGg+Cgk8L2c+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPC9nPjwvc3ZnPg=="
               var status = '운영 종료';
            } else {
                imageSrc = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHhtbG5zOnN2Z2pzPSJodHRwOi8vc3ZnanMuY29tL3N2Z2pzIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgeD0iMCIgeT0iMCIgdmlld0JveD0iMCAwIDUxMiA1MTIiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDUxMiA1MTIiIHhtbDpzcGFjZT0icHJlc2VydmUiIGNsYXNzPSIiPjxnPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgoJPGc+CgkJPHBhdGggZD0iTTI1NiwwQzE1My43NTUsMCw3MC41NzMsODMuMTgyLDcwLjU3MywxODUuNDI2YzAsMTI2Ljg4OCwxNjUuOTM5LDMxMy4xNjcsMTczLjAwNCwzMjEuMDM1ICAgIGM2LjYzNiw3LjM5MSwxOC4yMjIsNy4zNzgsMjQuODQ2LDBjNy4wNjUtNy44NjgsMTczLjAwNC0xOTQuMTQ3LDE3My4wMDQtMzIxLjAzNUM0NDEuNDI1LDgzLjE4MiwzNTguMjQ0LDAsMjU2LDB6IE0yNTYsMjc4LjcxOSAgICBjLTUxLjQ0MiwwLTkzLjI5Mi00MS44NTEtOTMuMjkyLTkzLjI5M1MyMDQuNTU5LDkyLjEzNCwyNTYsOTIuMTM0czkzLjI5MSw0MS44NTEsOTMuMjkxLDkzLjI5M1MzMDcuNDQxLDI3OC43MTksMjU2LDI3OC43MTl6IiBmaWxsPSIjMDA4NWZiIiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBzdHlsZT0iIiBjbGFzcz0iIj48L3BhdGg+Cgk8L2c+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPGcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPC9nPgo8ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgo8L2c+CjxnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjwvZz4KPC9nPjwvc3ZnPg=="
                var status = '운영 중';
            }
            imageSize = new kakao.maps.Size(50, 55);
            imageOption = {offset: new kakao.maps.Point(27, 69)};

            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption)
            var markerPosition = new kakao.maps.LatLng(item.wgs84Lat,item.wgs84Lon);

            var marker = new kakao.maps.Marker({
                position: markerPosition,
                image : markerImage,
                text : item.dutyName,
            });

            getInfoWindow(marker,item);

            marker.setMap(map);


            // 생성된 마커를 배열에 추가합니다
            markers.push(marker);
        });
    }

    function getInfoWindow(marker,item){
        var content = '<div class="wrap">' +
            '    <div class="info">' +
            '        <div class="title">' +
            '            '+item.dutyName+'' +
            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' +
            '        </div>' +
            '        <div class="body">' +
            '                <div class="ellipsis"> '+ item.dutyAddr+ '</div>' +
            '                <div class="jibun ellipsis">'+ item.dutyTel1+ '</div>' +
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

            // infoWindow.open(map,marker);
            infoWindow.setMap(map);
        });
    }

    // 배열에 추가된 마커들을 지도에 표시하거나 삭제하는 함수입니다
    function setMarkers(map) {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(map);
        }
    }

    $('#search').on('click',function () {
        $("#list").empty();
        setMarkers(null);

        // 주소를 받아서 검색
        // 주소-좌표 변환 객체를 생성합니다
        var geocoder = new kakao.maps.services.Geocoder();

        var address = $('#place').val();

        // 주소 있으면 해당 주소로 검색
        if (address != null && address != '') {
            // 주소로 좌표를 검색합니다
            geocoder.addressSearch(address, function (result, status) {
                // 정상적으로 검색이 완료됐으면
                if (status === kakao.maps.services.Status.OK) {
                    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                    // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                    // map.setCenter(coords);
                    searchPharmacy(coords);
                }
            });
        }
    });

     $('#currentSearch').on('click',function () {
        $("#list").empty();
         setMarkers(null);

        searchPharmacy();
     });

     $('#dutyAddr').on('click', function (){


     });

    function searchPharmacy(coords) {

        if (coords != null && coords != '') {
            map.setCenter(coords);
        }

        bounds = map.getBounds();

        // 영역의 남서쪽 좌표를 얻어옵니다
        var swLatLng = bounds.getSouthWest();
        console.log('남서쪽 : ', swLatLng);

        // 영역의 북동쪽 좌표를 얻어옵니다
        var neLatLng = bounds.getNorthEast();

        // 영역정보를 문자열로 얻어옵니다. ((남,서), (북,동)) 형식입니다
        var boundsStr = bounds.toString();
        console.log('영역정보 문자열 : ', boundsStr);

        var params = {
            searchOption : $("#searchOption option:selected").val(),
            swLat: swLatLng.getLat(),
            swLng: swLatLng.getLng(),
            neLat: neLatLng.getLat(),
            neLng: neLatLng.getLng()
        }

        // 현재 위치에서 약국 검색
        $.ajax({
            url: "/pharmacyList",
            type: "GET",
            dataType: "json",
            data: params,
            success: function (data) {
                //마커 표시
                searchMarkerInfo(data);
                $.each(data, function (index, item) {
                    if(item.checkopen == '0'){
                        var checkOpen = '운영종료 😞';
                    } else {var checkOpen = '운영중 😊';}
                    var hpid = item.hpid;
                    var dutyName =  'dutyName' + index;
                    var dutyAddr =  'dutyAddr' + index;
                    var dutyTel = 'dutyTel' + index;
                    var checkOpenId =  'checkOpen' + index;
                    var dutyInventory =  'dutyInventory' + index;
                    $("#list").append("<ul id=\"" +  dutyName + "\" class='dutyName'>" + item.dutyName + "</ul>");
                    $("#list").append("<ul id=\"" +  dutyAddr + "\" class='dutyAddr'>" + item.dutyAddr + "</ul>");
                    $("#list").append("<ul id=\"" +  dutyTel + "\" class='dutyTel'>" + item.dutyTel1 + "</ul>");
                    $("#list").append("<ul id=\"" +  checkOpenId + "\" class='checkOpen'>" + checkOpen + "</ul>");
                    $("#list").append("<button id=\"" +  dutyInventory + "\" class='dutyInventory'>"+"약품재고"+"</button>");
                    document.getElementById(dutyInventory).addEventListener("click", function() {
                        inventoryPop(hpid);
                    }, false);
                });
            }
        });
    }

</script>

<script>
function openNav() {
  document.getElementById("mySidebar").style.width = "350px";
  document.getElementById("map").style.marginLeft = "350px";
}

function closeNav() {
  document.getElementById("mySidebar").style.width = "0";
  document.getElementById("map").style.marginLeft= "0px";
}

function inventoryPop(srchHpid){

    show();

        var params = {
            hpid : srchHpid
        };

        // 약품 재고 리스트 확인
        $.ajax({
            url: "/drugList",
            type: "GET",
            dataType: "json",
            data: params,
            success: function (data) {
                // $.each(data, function (index, item) {
                //
                // });

            }
        });
}

  function show() {
    document.querySelector(".background").className = "background show";
  }

  function closePop() {
    document.querySelector(".background").className = "background";
  }

  document.querySelector("#closePop").addEventListener("click", closePop);
</script>

</html>