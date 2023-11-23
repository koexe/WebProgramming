<%--
  Created by IntelliJ IDEA.
  User: seojongchan
  Date: 2023/06/02
  Time: 9:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="apis.*"%>
<%
double defaultLat = 36.33701029373081;
double defaultLon = 127.44509405440104;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WELCOME</title>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4"
	crossorigin="anonymous"></script>
<link href="sticky-footer-navbar.css?after" rel="stylesheet">
</head>
<body class="d-flex flex-column h-100">
	<%

	%>
	<header>
		<!-- Fixed navbar -->
		<nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
			<div class="collapse navbar-collapse justify-content-md-center">
				<button onclick="askQuestion()">질문하기</button>
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
            keywordDisplay.classList.add('highlight-keyword'); // 클래스 추가
            // 필요한 다른 스타일을 CSS로 구현한 .highlight-keyword 클래스에 추가합니다.
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
				  <div>
        <ul id="placesList"></ul>
        <div id="pagination"></div>
            </div>
					<div id="map"></div>
				</div>
				<script type="text/javascript"
					src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bd94f9a4656aff9055eeda75c7af11ad&libraries=services"></script>
				<script>
            
            	var markers = [];
                var mapContainer = document.getElementById('map'), // 지도를 표시할 div
                    mapOption = {
                        center: new kakao.maps.LatLng(<%=defaultLat%>, <%=defaultLon%>), // 지도의 중심좌표
                        level: 3 // 지도의 확대 레벨
                    };

                var map = new kakao.maps.Map(mapContainer, mapOption);  // 지도를 생성합니다
                var ps = new kakao.maps.services.Places(); 
                var infowindow = new kakao.maps.InfoWindow({zIndex:1});
                
                var geocoder = new kakao.maps.services.Geocoder();
				var InitaialAdress;

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
                            
                            searchPlaces(word);

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
                            });                        } else {
                            console.error("Invalid response from API");
                        }
                    })
                    .catch((error) => {
                        console.error("Error fetching data:", error);
                    });
                }
                
             // 초기에 지도 중심 좌표에 대한 주소정보를 표시합니다
                searchAddrFromCoords(map.getCenter(), function (result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        console.log('초기 주소:', result[0].address.address_name);
                        InitaialAdress = result[0].address.address_name;
                    }
                });
             
                function searchAddrFromCoords(coords, callback) {
                    // 좌표로 주소 정보를 요청합니다
                    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
                }
                

             // 키워드 검색을 요청하는 함수입니다
             function searchPlaces(keyWord_Input) {

                 //var keyword = document.getElementById('keyword').value;
                 
                 console.log(keyWord_Input);
                 var stringWithoutLastFive = InitaialAdress.slice(0, -5);

                 if (!keyWord_Input.replace(/^\s+|\s+$/g, '')) {
                     alert('키워드를 입력해주세요!');
                     return false;
                 }

                 // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
                 console.log(stringWithoutLastFive + keyWord_Input);
                 ps.keywordSearch(stringWithoutLastFive + keyWord_Input, placesSearchCB); 
             }

             // 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
             function placesSearchCB(data, status, pagination) {
                 if (status === kakao.maps.services.Status.OK) {

                     // 정상적으로 검색이 완료됐으면
                     // 검색 목록과 마커를 표출합니다
                     displayPlaces(data);

                     // 페이지 번호를 표출합니다
                     displayPagination(pagination);

                 } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

                     alert('검색 결과가 존재하지 않습니다.');
                     return;

                 } else if (status === kakao.maps.services.Status.ERROR) {

                     alert('검색 결과 중 오류가 발생했습니다.');
                     return;

                 }
             }

             // 검색 결과 목록과 마커를 표출하는 함수입니다
             function displayPlaces(places) {

                 var listEl = document.getElementById('placesList'), 
                 menuEl = document.getElementById('menu_wrap'),
                 fragment = document.createDocumentFragment(), 
                 bounds = new kakao.maps.LatLngBounds(), 
                 listStr = '';
                 
                 // 검색 결과 목록에 추가된 항목들을 제거합니다
                 removeAllChildNods(listEl);

                 // 지도에 표시되고 있는 마커를 제거합니다
                 removeMarker();
                 
                 for ( var i=0; i<places.length; i++ ) {

                     // 마커를 생성하고 지도에 표시합니다
                     var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
                         marker = addMarker(placePosition, i), 
                         itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

                     // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
                     // LatLngBounds 객체에 좌표를 추가합니다
                     bounds.extend(placePosition);

                     // 마커와 검색결과 항목에 mouseover 했을때
                     // 해당 장소에 인포윈도우에 장소명을 표시합니다
                     // mouseout 했을 때는 인포윈도우를 닫습니다
                     (function(marker, title) {
                         kakao.maps.event.addListener(marker, 'mouseover', function() {
                             displayInfowindow(marker, title);
                         });

                         kakao.maps.event.addListener(marker, 'mouseout', function() {
                             infowindow.close();
                         });

                         itemEl.onmouseover =  function () {
                             displayInfowindow(marker, title);
                         };

                         itemEl.onmouseout =  function () {
                             infowindow.close();
                         };
                     })(marker, places[i].place_name);

                     fragment.appendChild(itemEl);
                 }

                 // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
                 listEl.appendChild(fragment);
                 menuEl.scrollTop = 0;

                 // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
                 map.setBounds(bounds);
             }

             // 검색결과 항목을 Element로 반환하는 함수입니다
             function getListItem(index, places) {

                 var el = document.createElement('li'),
                 itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                             '<div class="info">' +
                             '   <h5>' + places.place_name + '</h5>';

                 if (places.road_address_name) {
                     itemStr += '    <span>' + places.road_address_name + '</span>' +
                                 '   <span class="jibun gray">' +  places.address_name  + '</span>';
                 } else {
                     itemStr += '    <span>' +  places.address_name  + '</span>'; 
                 }
                              
                   itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                             '</div>';           

                 el.innerHTML = itemStr;
                 el.className = 'item';

                 return el;
             }

             // 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
             function addMarker(position, idx, title) {
                 var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
                     imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
                     imgOptions =  {
                         spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
                         spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
                         offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
                     },
                     markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
                         marker = new kakao.maps.Marker({
                         position: position, // 마커의 위치
                         image: markerImage 
                     });

                 marker.setMap(map); // 지도 위에 마커를 표출합니다
                 markers.push(marker);  // 배열에 생성된 마커를 추가합니다

                 return marker;
             }

             // 지도 위에 표시되고 있는 마커를 모두 제거합니다
             function removeMarker() {
                 for ( var i = 0; i < markers.length; i++ ) {
                     markers[i].setMap(null);
                 }   
                 markers = [];
             }

             // 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
             function displayPagination(pagination) {
                 var paginationEl = document.getElementById('pagination'),
                     fragment = document.createDocumentFragment(),
                     i; 

                 // 기존에 추가된 페이지번호를 삭제합니다
                 while (paginationEl.hasChildNodes()) {
                     paginationEl.removeChild (paginationEl.lastChild);
                 }

                 for (i=1; i<=pagination.last; i++) {
                     var el = document.createElement('a');
                     el.href = "#";
                     el.innerHTML = i;

                     if (i===pagination.current) {
                         el.className = 'on';
                     } else {
                         el.onclick = (function(i) {
                             return function() {
                                 pagination.gotoPage(i);
                             }
                         })(i);
                     }

                     fragment.appendChild(el);
                 }
                 paginationEl.appendChild(fragment);
             }

             // 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
             // 인포윈도우에 장소명을 표시합니다
             function displayInfowindow(marker, title) {
                 var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

                 infowindow.setContent(content);
                 infowindow.open(map, marker);
             }

              // 검색결과 목록의 자식 Element를 제거하는 함수입니다
             function removeAllChildNods(el) {   
                 while (el.hasChildNodes()) {
                     el.removeChild (el.lastChild);
                 }
             }

            </script>
				<script src="https://code.jquery.com/jquery-3.0.0.js"></script>



				<div id="recommand">

					<h1>나는</h1>
					<div id="selectedKeywords" class="keyword-display"></div>
					<br>
					<h3>이런 음식을 먹고싶어..</h3>
					<br>

				</div>
			</div>
		</div>
		<div class="recommend_button">
			<h2>내가 원하는 음식은</h2>
			<p></p>

			<div class="button-row">
				<!-- 첫 번째 열 -->
				<button class="btn btn-primary"
					onclick="handleButtonClick('달달한', this)">달달한</button>
				<button class="btn btn-secondary"
					onclick="handleButtonClick('매운', this)">매운</button>
				<button class="btn btn-success"
					onclick="handleButtonClick('든든한', this)">든든한</button>
				<button class="btn btn-danger"
					onclick="handleButtonClick('새콤한', this)">새콤한</button>
			</div>

			<div class="button-row">
				<!-- 두 번째 열 -->
				<button class="btn btn-primary"
					onclick="handleButtonClick('한식', this)">한식</button>
				<button class="btn btn-secondary"
					onclick="handleButtonClick('중식', this)">중식</button>
				<button class="btn btn-success"
					onclick="handleButtonClick('양식', this)">양식</button>
				<button class="btn btn-danger"
					onclick="handleButtonClick('일식', this)">일식</button>
			</div>

			<div class="button-row">
				<!-- 세 번째 열 -->
				<button class="btn btn-primary"
					onclick="handleButtonClick('뜨거운', this)">뜨거운</button>
				<button class="btn btn-secondary"
					onclick="handleButtonClick('차가운', this)">차가운</button>
				<button class="btn btn-success"
					onclick="handleButtonClick('국물있는', this)">국물있는</button>
				<button class="btn btn-danger"
					onclick="handleButtonClick('국물없는', this)">국물없는</button>
			</div>

		</div>
	</main>
	<link
		href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css"
		rel="stylesheet"
		integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x"
		crossorigin="anonymous">
</body>
</html>