package com.app.utils;

import java.net.URLEncoder;

public class AlertUtils {
    
    public static String redirectWithSuccess(String path, String message) {
        return "redirect:" + path + "?success=" + encodeMessage(message);
    }
    
    public static String redirectWithError(String path, String message) {
        return "redirect:" + path + "?error=" + encodeMessage(message);
    }
    
    public static String redirectWithWarning(String path, String message) {
        return "redirect:" + path + "?warning=" + encodeMessage(message);
    }
    
    public static String redirectWithInfo(String path, String message) {
        return "redirect:" + path + "?info=" + encodeMessage(message);
    }
    
    private static String encodeMessage(String message) {
        try {
            return URLEncoder.encode(message, "UTF-8");
        } catch (Exception e) {
            return message.replace(" ", "%20")
                         .replace(":", "%3A")
                         .replace("ñ", "%C3%B1")
                         .replace("á", "%C3%A1")
                         .replace("é", "%C3%A9")
                         .replace("í", "%C3%AD")
                         .replace("ó", "%C3%B3")
                         .replace("ú", "%C3%BA");
        }
    }
}