package com.wiseq.cn.commons.utils;

import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.exception.QuException;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 各种加密方法，其中包括md5
 **/
public class DES {
    private static byte[] iv = {1, 2, 3, 4, 5, 6, 7, 8};
    public static String strkey = "%%d";

    /**
     * 数据加密
     *
     * @param encryptString
     * @return string
     * @throws Exception
     */
    public static String encryptDES(String encryptString) throws QuException {
        if (QuHelper.isNull(encryptString)) {
            return "";
        }
        try {
            IvParameterSpec zeroIv = new IvParameterSpec(iv);
            SecretKeySpec key = new SecretKeySpec(getkeys().getBytes(), "DES");
            Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, key, zeroIv);
            byte[] encryptedData = cipher.doFinal(encryptString.getBytes());
            return BASE64.encode(encryptedData);
        } catch (Exception ex) {
            throw new QuException(ResultEnum.DESENCRYPT_ERR);
        }
    }

    /**
     * 数据解密
     *
     * @param decryptString
     * @return string
     * @throws Exception
     */
    public static String decryptDES(String decryptString) throws QuException {
        if (QuHelper.isNull(decryptString)) {
            return "";
        }
        try {
            byte[] byteMi = new BASE64().decode(decryptString);
            IvParameterSpec zeroIv = new IvParameterSpec(iv);
            SecretKeySpec key = new SecretKeySpec(getkeys().getBytes(), "DES");
            Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, key, zeroIv);
            byte decryptedData[] = cipher.doFinal(byteMi);
            return new String(decryptedData);
        } catch (Exception ex) {
            throw new QuException(ResultEnum.DESENCRYPT_ERR);
        }
    }

    public static String getkeys() {
        return BASE64.STRKEY2;
    }

    // MD5加密
    private static final char HEX_DIGITS[] = {'0', '1', '2', '3', '4', '5',
            '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
    public static String strkey3 = "*(&";

    public static String toHexString(byte[] b) { // String to byte
        StringBuilder sb = new StringBuilder(b.length * 2);
        for (int i = 0; i < b.length; i++) {
            sb.append(HEX_DIGITS[(b[i] & 0xf0) >>> 4]);
            sb.append(HEX_DIGITS[b[i] & 0x0f]);
        }
        return sb.toString();
    }

    public static String md5(String s) {
        if (QuHelper.isNull(s)) {
            return "";
        }
        try {
            // Create MD5 Hash
            MessageDigest digest = MessageDigest
                    .getInstance("MD5");
            digest.update(s.getBytes());
            byte[] messageDigest = digest.digest();
            return toHexString(messageDigest).toLowerCase();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * 密码MD5 调用此方法
     *
     * @param s
     * @return
     */
    public static String md5Pwd(String s) {
        if (QuHelper.isNull(s)) {
            return "";
        }
        return md5("quanshi" + s);
    }
}


