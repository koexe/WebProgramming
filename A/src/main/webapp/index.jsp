<%--
  Created by IntelliJ IDEA.
  User: seojongchan
  Date: 2023/06/02
  Time: 9:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="apis.*" %>
<%
    double defaultLat = 36.33701029373081;
    double defaultLon = 127.44509405440104;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>WELCOME</title>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>
    <link href="sticky-footer-navbar.css?after" rel="stylesheet">
</head>
<body class="d-flex flex-column h-100">
<%
   
%>
<header>
    <!-- Fixed navbar -->
    <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
        <div class="collapse navbar-collapse justify-content-md-center">
            <form action="index.jsp" method="post">
                <input type="hidden" name="x" id="variable1" value="">
                <input type="hidden" name="y" id="variable2" value="">
                <button class="btn btn-outline-success" type="submit" onclick=""> <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-play-fill" viewBox="0 0 16 16">
                    <path d="m11.596 8.697-6.363 3.692c-.54.313-1.233-.066-1.233-.697V4.308c0-.63.692-1.01 1.233-.696l6.363 3.692a.802.802 0 0 1 0 1.393z"/>
                </svg> Let's Go</button>
            </form>
        </div>
    </nav>
</header>

<script>
     var ButtonKeyword = "";
     function handleButtonClick(Button_Word, button) {
         // 현재 버튼의 클래스 리스트를 가져옵니다
            var buttonClasses = button.classList;

            // 버튼이 'active' 클래스를 포함하고 있는지 여부를 확인합니다
            var isActive = buttonClasses.contains('active');

            // 'active' 클래스를 토글합니다
            buttonClasses.toggle('active');

            // 버튼이 활성화되어 있다면 문자열을 추가하고, 비활성화되어 있다면 제거합니다
            if (!isActive) {
                ButtonKeyword += Button_Word + " ";
            } else {
                // 버튼이 비활성화되면 해당 단어를 제거합니다
                ButtonKeyword = ButtonKeyword.replace(Button_Word + " ", "");
            }
            
            var keywordDisplay = document.getElementById('selectedKeywords');

            // 선택된 키워드를 표시합니다
            if (keywordDisplay) {
                keywordDisplay.textContent = ButtonKeyword.trim();
            }

            console.log("버튼 " + Button_Word + "이 클릭되었습니다.");
            console.log(ButtonKeyword);
            // 여기에 버튼이 클릭되었을 때 원하는 동작을 추가할 수 있습니다.
        }
</script>

<!-- Begin page content -->
<main class="flex-shrink-0">
    <div class="container">
        <br>
        <div id="showTable">
            <div id="playMusic">
                <div id="map"></div>
            </div>
            <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bd94f9a4656aff9055eeda75c7af11ad"></script>
            <script>
                var mapContainer = document.getElementById('map'), // 지도를 표시할 div
                    mapOption = {
                        center: new kakao.maps.LatLng(<%=defaultLat%>, <%=defaultLon%>), // 지도의 중심좌표
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
                kakao.maps.event.addListener(map, 'click', function (mouseEvent) {

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
                });

                Date.prototype.amPm = function () {
                    let h = this.getHours() < 12 ? "am" : "pm";
                    return h;
                }

                var now = new Date();
                var hours = now.getHours()
                let AIPick = "볼빨간 사춘기 - 여행";
                let url = "";
                let query = ButtonKeyword + " 한 음식 1가지를 추천하는데 음식명만 알려줘";
                
                console.log(query);
                function askQuestion() {
                    fetch("https://api.openai.com/v1/chat/completions", {
                        method: "POST",
                        headers: {
                            Authorization: "Bearer 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",
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify({
                            model: "gpt-3.5-turbo",
                            messages: [{ role: "user", content: ButtonKeyword + " 한 음식 1가지를 추천하는데 음식명만 알려줘" }],
                        }),
                    })
                    .then((res) => res.json())
                    .then((data) => {
                        // Ensure that data.choices is defined and has at least one element
                        if (data && data.choices && data.choices.length > 0 && data.choices[0].message) {
                            let word = data.choices[0].message.content;

                            // Rest of your code that uses 'word'

                            let apikey = "AIzaSyBSO0bDUeGWYapTx0j5dSsMwRhwEKJoKb8";
                            $.ajax({
                                url: 'https://www.googleapis.com/youtube/v3/search',
                                type: 'get',
                                dataType: 'json',
                                data: { part: 'snippet', key: apikey, q: word, maxResults: 50, type: 'video', videoEmbeddable: 'true' },
                                success: function (data) {
                                    console.log(data);
                                    
                                    // Remove existing YouTube content
                                    $("#title").remove();
                                    $("#youtube").remove();

                                    // Add new YouTube content
                                    var title = $('<h1>', {
                                        id: "title",
                                        text: word
                                    });
                                    title.css('color', '#ecedee');
                                    $(".result").append(title);

                                    var iframe = $('<iframe>', {
                                        id: "youtube",
                                        width: "100%",
                                        height: "250px",
                                        src: "https://www.youtube.com/embed/" + data.items[0].id.videoId,
                                        title: "YouTube video player",
                                        frameborder: "0",
                                        allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                    });
                                    $(".result").append(iframe);

                                    var cnt = 0;
                                    $.each(data.items, function (i, item) {
                                        thumbnail = item.snippet.thumbnails.medium.url; // 썸네일 이미지
                                        videoId = item.id.videoId;                 // 비디오 아이디
                                        console.log("!!");
                                    });
                                }
                            });
                        } else {
                            console.error("Invalid response from API");
                        }
                    })
                    .catch((error) => {
                        console.error("Error fetching data:", error);
                    });
                }

            </script>
            <script src="https://code.jquery.com/jquery-3.0.0.js"></script>
            


            <div id="recommand">

                <h1> 나는 </h1>
                <div id="selectedKeywords"></div>
                <br>
                <h3>이런 음식을 먹고싶어..</h3>
                <br>
                <div class="result">
<button onclick="askQuestion()">질문하기</button>
                 </div>
                </div>
            </div>
        </div>
    <div class ="recommend_button">
            <h2>내가 원하는 음식은</h2>
    <p></p>

<div class="button-row">
    <!-- 첫 번째 열 -->
    <button class="btn btn-primary" onclick="handleButtonClick('달달한', this)">달달한</button>
    <button class="btn btn-secondary" onclick="handleButtonClick('매운', this)">매운</button>
    <button class="btn btn-success" onclick="handleButtonClick('든든한', this)">든든한</button>
    <button class="btn btn-danger" onclick="handleButtonClick('새콤한', this)">새콤한</button>
</div>

<div class="button-row">
    <!-- 두 번째 열 -->
    <button class="btn btn-primary" onclick="handleButtonClick('한식', this)">한식</button>
    <button class="btn btn-secondary" onclick="handleButtonClick('중식', this)">중식</button>
    <button class="btn btn-success" onclick="handleButtonClick('양식', this)">양식</button>
    <button class="btn btn-danger" onclick="handleButtonClick('일식', this)">일식</button>
</div>

<div class="button-row">
    <!-- 세 번째 열 -->
    <button class="btn btn-primary" onclick="handleButtonClick('뜨거운', this)">뜨거운</button>
    <button class="btn btn-secondary" onclick="handleButtonClick('차가운', this)">차가운</button>
    <button class="btn btn-success" onclick="handleButtonClick('국물있는', this)">국물있는</button>
    <button class="btn btn-danger" onclick="handleButtonClick('국물없는', this)">국물없는</button>
</div>

   </div>
</main>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">
</body>
</html>