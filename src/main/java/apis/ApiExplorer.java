package apis;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.io.BufferedReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ApiExplorer {
    public String getWeather(double lat, double lon) throws IOException {
        GpsTransegenter gps = new GpsTransegenter();
        gps.setLat(lat);
        gps.setLon(lon);
        Date today = new Date();

        SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat time = new SimpleDateFormat("hhmm");

        String base_date = date.format(today);
        String base_time = time.format(today);
        gps.transfer(gps,0);
        int x = (int)gps.getxLat();
        int y = (int)gps.getyLon();
        System.out.println(x+","+y);
        StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=NJ27TooC01a1zdY5VNxaF8GDhdO0YXkHYWFwXFh6NJE5WwrZo7IRJM8pN6KOYebDSTThi4FDBbzplnWkyyk0MQ==");  /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("1000", "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("dataType","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*요청자료형식(XML/JSON) Default: XML*/
        urlBuilder.append("&" + URLEncoder.encode("base_date","UTF-8") + "=" + URLEncoder.encode(base_date, "UTF-8")); /*‘21년 6월 28일 발표*/
        urlBuilder.append("&" + URLEncoder.encode("base_time","UTF-8") + "=" + URLEncoder.encode(base_time, "UTF-8")); /*06시 발표(정시단위) */
        urlBuilder.append("&" + URLEncoder.encode("nx","UTF-8") + "=" + URLEncoder.encode(String.valueOf(x), "UTF-8")); /*예보지점의 X 좌표값*/
        urlBuilder.append("&" + URLEncoder.encode("ny","UTF-8") + "=" + URLEncoder.encode(String.valueOf(y), "UTF-8")); /*예보지점의 Y 좌표값*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();

        System.out.println(sb.toString());
        String result = sb.toString();

        JSONObject jsonObj_1 = new JSONObject(result);
        JSONObject responseObj = jsonObj_1.getJSONObject("response");
        String response = responseObj.toString();


        // response 로 부터 body 찾기
        JSONObject jsonObj_2 = new JSONObject(response);
        responseObj = jsonObj_2.getJSONObject("body");
        String body = responseObj.toString();

        // body 로 부터 items 찾기
        JSONObject jsonObj_3 = new JSONObject(body);
        responseObj = jsonObj_3.getJSONObject("items");
        String items = responseObj.toString();


        // items로 부터 itemlist 를 받기
        JSONObject jsonObj_4 = new JSONObject(items);
        JSONArray jsonArray = jsonObj_4.getJSONArray("item");
        String weather ="";
        String tmperature = "";
        String water = "";
        for(int i=0;i<jsonArray.length();i++){
            jsonObj_4 = jsonArray.getJSONObject(i);
            String fcstValue = jsonObj_4.getString("obsrValue");
            String category = jsonObj_4.getString("category");

            if(category.equals("PTY")){
                if(fcstValue.equals("0")) {
                    weather += "맑은 상태로 ";
                }else if(fcstValue.equals("1")) {
                    weather += "비가 오는 상태로 ";
                }else if(fcstValue.equals("3")) {
                    weather += "비와 눈이 오는 상태로 ";
                }else if(fcstValue.equals("4")) {
                    weather += "눈이 오는 상태로 ";
                }
            }
            if(category.equals("REH")){
                water = "습도는 "+fcstValue+"%, ";
            }
            if(category.equals("T3H") || category.equals("T1H")){
                tmperature = "기온은 "+fcstValue+"℃ 입니다.";
            }
        }

        return weather+""+water+""+tmperature;
    }
}