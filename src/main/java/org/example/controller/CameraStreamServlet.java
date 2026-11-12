package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

@WebServlet("/admin/camera-stream")
public class CameraStreamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ip = req.getParameter("ip");
        String port = req.getParameter("port");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String path = req.getParameter("path");

        if (ip == null || ip.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Missing IP parameter");
            return;
        }

        if (port == null || port.trim().isEmpty()) {
            port = "8080";
        }

        if (path == null || path.trim().isEmpty()) {
            path = "/video";
        }
        if (!path.startsWith("/")) {
            path = "/" + path;
        }

        String cameraUrlStr = "http://" + ip.trim() + ":" + port.trim() + path;

        // Thêm đầy đủ CORS Headers để Trình duyệt không bị chặn bởi CORS Policy
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "*");
        resp.setHeader("Access-Control-Expose-Headers", "*");

        HttpURLConnection conn = null;
        try {
            URL url = new URL(cameraUrlStr);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(15000);
            conn.setUseCaches(false);

            if (username != null && !username.trim().isEmpty()) {
                String auth = username.trim() + ":" + (password != null ? password.trim() : "");
                String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));
                conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode >= 200 && responseCode < 400) {
                String contentType = conn.getContentType();
                if (contentType != null) {
                    resp.setContentType(contentType);
                } else {
                    resp.setContentType("multipart/x-mixed-replace; boundary=--jpgboundary");
                }

                try (InputStream in = conn.getInputStream();
                     OutputStream out = resp.getOutputStream()) {
                    byte[] buffer = new byte[8192];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                        out.flush();
                    }
                }
            } else {
                resp.setStatus(responseCode);
                resp.setContentType("text/plain;charset=UTF-8");
                resp.getWriter().write("Camera returned HTTP " + responseCode);
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
            resp.setContentType("text/plain;charset=UTF-8");
            resp.getWriter().write("Error connecting to camera proxy: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.disconnect();
                } catch (Exception ignored) {}
            }
        }
    }

    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "*");
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}
