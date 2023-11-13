<%--
  Created by IntelliJ IDEA.
  User: seojongchan
  Date: 2023/06/02
  Time: 9:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="apis.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="EUC-KR">
    <title>WELCOME</title>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>
    <link href="sticky-footer-navbar.css?after" rel="stylesheet">
</head>
<body class="d-flex flex-column h-100">
<%
    ApiExplorer weatherApi = new ApiExplorer();

    double defaultLat = 36.33701029373081;
    double defaultLon = 127.44509405440104;
    if (request.getParameter("x")!=null && request.getParameter("y")!=null){
        defaultLat = Double.parseDouble(request.getParameter("x"));
        defaultLon = Double.parseDouble(request.getParameter("y"));
    }
    String word = weatherApi.getWeather(defaultLat,defaultLon);
%>
<header>
    <!-- Fixed navbar -->
    <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
        <div class="collapse navbar-collapse justify-content-md-center">
            <form action="index.jsp" method="post">
                <input type="hidden" name="x" id="variable1" value="">
                <input type="hidden" name="y" id="variable2" value="">
                <button class="btn btn-outline-success" type="submit" onclick="setVariables()"> <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-play-fill" viewBox="0 0 16 16">
                    <path d="m11.596 8.697-6.363 3.692c-.54.313-1.233-.066-1.233-.697V4.308c0-.63.692-1.01 1.233-.696l6.363 3.692a.802.802 0 0 1 0 1.393z"/>
                </svg> Let's Play</button>
            </form>
        </div>
        </div>
    </nav>
</header>

<!-- Begin page content -->
<main class="flex-shrink-0">
    <div class="container">
        <br>
        <div id="showTable">
            <div id ="playMusic">
                <div id="map"></div>
            </div>
            <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bd94f9a4656aff9055eeda75c7af11ad"></script>
            <script>
                var mapContainer = document.getElementById('map'), // 지도를 표시할 div
                    mapOption = {
                        center: new kakao.maps.LatLng(<%=defaultLat%>,<%=defaultLon%>), // 지도의 중심좌표
                        level: 3 // 지도의 확대 레벨
                    };

                var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

                // 지도를 클릭한 위치에 표출할 마커입니다
                var marker = new kakao.maps.Marker({
                    // 지도 중심좌표에 마커를 생성합니다
                    position: map.getCenter()
                });
                // 지도에 마커를 표시합니다
                marker.setMap(map);
                let lat;
                let lon;
                // 지도에 클릭 이벤트를 등록합니다
                // 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
                kakao.maps.event.addListener(map, 'click', function(mouseEvent) {

                    // 클릭한 위도, 경도 정보를 가져옵니다
                    var latlng = mouseEvent.latLng;
                    lat = latlng.getLat();
                    lon = latlng.getLng();
                    // 마커 위치를 클릭한 위치로 옮깁니다
                    marker.setPosition(latlng);
                    var variable1Input = document.getElementById('variable1');
                    var variable2Input = document.getElementById('variable2');
                    variable1Input.value = lat;
                    variable2Input.value = lon;

                    // var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
                    // message += '경도는 ' + latlng.getLng() + ' 입니다';
                    //
                    // var resultDiv = document.getElementById('clickLatlng');
                    // resultDiv.innerHTML = "<p>"+message+"</p>";

                });
                Date.prototype.amPm = function() {
                    let h = this.getHours() < 12 ? "am" : "pm";
                    return h;
                }
                var now = new Date();
                var hours = now.getHours()
                let AIPick = "볼빨간 사춘기 - 여행";
                let url = "";
                let query = hours+""+now.amPm()+", <%=word%> 날씨에 맞는 한국 노래 1곡을 \"가수-제목\" 포맷으로 알려줘";
                console.log(query);
                fetch("https://api.openai.com/v1/chat/completions", {
                    method: "POST",
                    headers: {
                        Authorization: "Bearer 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",
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify({
                        model: "gpt-3.5-turbo",
                        messages: [{ role: "user", content: hours+"시, <%=word%> 날씨에 맞는 한국 노래 1곡을 \"가수-제목\" 포맷으로 알려줘" }],
                    }),
                })
                    .then((res) => res.json())
                    .then((data) =>{
                        let word = data.choices[0].message.content;
                        let apikey = "AIzaSyAt2XNiggBVtYcIjzxqKgY-5m-Eld0y0rM";
                        $.ajax({
                            url:'https://www.googleapis.com/youtube/v3/search',
                            type:'get',
                            dataType:'json',
                            data:{part:'snippet',key:apikey,q:data.choices[0].message.content, maxResults:50,type:'video',videoEmbeddable:'true'},
                            success:function (data){
                                console.log(data);
                                var title = $('<h1>',{
                                   id:"title",
                                    text: word

                                });
                                title.css('color', '#ecedee');
                                $(".result").append(title);
                                var iframe = $('<iframe>',{
                                    id:"youtube",
                                    width:"100%" ,
                                    height:"250px",
                                    src:"https://www.youtube.com/embed/"+data.items[0].id.videoId ,
                                    title:"YouTube video player" ,
                                    frameborder:"0" ,
                                    allow:"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                });
                                $(".result").append(iframe);
                                var cnt = 0;
                                $.each(data.items, function(i, item) {
                                    thumbnail = item.snippet.thumbnails.medium.url; // 썸네일 이미지
                                    videoId = item.id.videoId;                 // 비디오 아이디
                                    console.log("!!");


                                });
                            }
                        });
                    });

            </script>
            <script src="https://code.jquery.com/jquery-3.0.0.js"></script>

            <div  id="recommand">

                <h1>현재 위치한 곳의 하늘은 </h1>
                <h1><%=word%></h1>
                <br>
                <h3>에 듣기 좋은 노래는..</h3>
                <br>
                <div class="result">

                </div>
            </div>
        </div>
    </div>
</main>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">
</body>
</html>