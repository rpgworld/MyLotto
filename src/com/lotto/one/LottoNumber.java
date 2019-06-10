package com.lotto.one;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/LottoNumber")
public class LottoNumber extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public LottoNumber() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String count = request.getParameter("count");
		response.getWriter().append(lottoTest(count));
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	private static class CustomizedHostnameVerifier implements HostnameVerifier {
		public boolean verify(String hostname, SSLSession session) {
			return true;
		}
	}
	
	public String lottoTest(String count) {
		HttpsURLConnection conn;
		JSONObject result  = new JSONObject();
		
		try {
			// 결과 조회 URL
			conn = (HttpsURLConnection) new URL(
					"https://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=" + count).openConnection();
			conn.setHostnameVerifier(new CustomizedHostnameVerifier());
			InputStreamReader isr = new InputStreamReader(conn.getInputStream(), "UTF-8");
			
			// JSON 형식 읽기
			BufferedReader br = new BufferedReader(isr);
			String str = "";
			str = br.readLine();
			result = new JSONObject(str);
			for(int i = 1; i < 7; i++) {
				System.out.println(result.get("drwtNo" + i));
			}
			System.out.println(result.get("bnusNo"));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result.toString();
	}

}
