package org.example;

import java.util.Random;

public class main {
    public static void main(String[] args) {
        Random random = new Random();
        int otp = random.nextInt(1000000);
        String otpString = String.format("%06d", otp);
        System.out.println(otpString);
    }
}
