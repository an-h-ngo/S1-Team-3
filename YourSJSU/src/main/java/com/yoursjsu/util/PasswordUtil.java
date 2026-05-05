package com.yoursjsu.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    private static final int COST = 12;

    public static boolean isBcryptHash(String storedPassword) {
        return storedPassword != null
                && (storedPassword.startsWith("$2a$")
                || storedPassword.startsWith("$2b$")
                || storedPassword.startsWith("$2y$"));
    }

    public static boolean verifyPassword(String candidate, String storedPassword) {
        if (candidate == null || storedPassword == null) {
            return false;
        }
        if (!isBcryptHash(storedPassword)) {
            return candidate.equals(storedPassword);
        }
        try {
            return BCrypt.checkpw(candidate, normalizeBcryptPrefix(storedPassword));
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    public static String hashPassword(String rawPassword) {
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(COST));
    }

    public static boolean needsBcryptMigration(String storedPassword) {
        return !isBcryptHash(storedPassword);
    }

    private static String normalizeBcryptPrefix(String storedPassword) {
        if (storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$")) {
            return "$2a$" + storedPassword.substring(4);
        }
        return storedPassword;
    }
}
