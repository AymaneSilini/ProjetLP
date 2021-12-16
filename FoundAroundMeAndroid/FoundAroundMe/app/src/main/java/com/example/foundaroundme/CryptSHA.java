package com.example.foundaroundme;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Is a utility class is use for cript the password for the utilisator
 */

public final class CryptSHA {

    /**
     * is the methode for encrypt the password of the user before wes stock in the firecloud
     * @param testPassword
     * @return String with encrypt by SHA-256
     */
    public static String toSHA256(String testPassword) {

        MessageDigest digest = null;
        try {
            digest = MessageDigest.getInstance("SHA-256");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        digest.update(testPassword.getBytes());

        byte[] hash = digest.digest();

        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        String password = sb.toString();

        return password;
    }
}