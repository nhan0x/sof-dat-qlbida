package org.example.utils;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

public class PayOSPayment {

    private static final String CLIENT_ID = "2ccff12a-25c8-473e-bff1-b7ec3d192857";
    private static final String API_KEY = "3d946779-f83a-46ed-afd8-e40667cd0e9c";
    private static final String CHECKSUM_KEY = "7be2df5747fb86f9297e75009c3449757e8434890a14303be2d76c41eb29011d";
    private static final String PAYOS_API_URL = "https://api-merchant.payos.vn/v2/payment-requests";

    public static String createPaymentLink(long orderCode, int amount, String description, String returnUrl, String cancelUrl) throws Exception {
        // Clean description (PayOS allows only alphanumeric and space, max 25 chars)
        String cleanDesc = removeAccent(description).replaceAll("[^a-zA-Z0-9 ]", "");
        if (cleanDesc.length() > 25) {
            cleanDesc = cleanDesc.substring(0, 25);
        }
        cleanDesc = cleanDesc.trim();
        if (cleanDesc.isEmpty()) {
            cleanDesc = "Thanh toan";
        }

        // 1. Generate Signature
        // Format: amount=<amount>&cancelUrl=<cancelUrl>&description=<description>&orderCode=<orderCode>&returnUrl=<returnUrl>
        String signatureData = "amount=" + amount +
                "&cancelUrl=" + cancelUrl +
                "&description=" + cleanDesc +
                "&orderCode=" + orderCode +
                "&returnUrl=" + returnUrl;

        String signature = hmacSHA256(signatureData, CHECKSUM_KEY);

        // 2. Build JSON Request Body
        String jsonBody = "{"
                + "\"orderCode\":" + orderCode + ","
                + "\"amount\":" + amount + ","
                + "\"description\":\"" + cleanDesc + "\","
                + "\"cancelUrl\":\"" + cancelUrl + "\","
                + "\"returnUrl\":\"" + returnUrl + "\","
                + "\"signature\":\"" + signature + "\""
                + "}";

        // 3. Send HTTP Request
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(PAYOS_API_URL))
                .header("Content-Type", "application/json")
                .header("x-client-id", CLIENT_ID)
                .header("x-api-key", API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200 || response.statusCode() == 201) {
            String body = response.body();
            // Parse checkoutUrl from response body
            int idx = body.indexOf("\"checkoutUrl\":\"");
            if (idx != -1) {
                int start = idx + "\"checkoutUrl\":\"".length();
                int end = body.indexOf("\"", start);
                return body.substring(start, end).replace("\\/", "/");
            }
            throw new Exception("PayOS response did not contain checkoutUrl: " + body);
        } else {
            throw new Exception("PayOS API returned status code " + response.statusCode() + ": " + response.body());
        }
    }

    private static String hmacSHA256(String data, String key) throws Exception {
        Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
        SecretKeySpec secret_key = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        sha256_HMAC.init(secret_key);
        byte[] hash = sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }

    private static String removeAccent(String s) {
        if (s == null) return "";
        String temp = java.text.Normalizer.normalize(s, java.text.Normalizer.Form.NFD);
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("").replace('đ', 'd').replace('Đ', 'D');
    }
}
