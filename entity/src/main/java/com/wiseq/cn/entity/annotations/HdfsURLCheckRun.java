package com.wiseq.cn.entity.annotations;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class HdfsURLCheckRun implements ConstraintValidator<HdfsURLCheck,Object> {
    private String message;

    public void initialize(HdfsURLCheck constraintAnnotation) {

        this.message=constraintAnnotation.message();
    }

    public boolean isValid(Object o, ConstraintValidatorContext constraintValidatorContext) {
        if(o==null){
            return false;
        }
        String strUrl=o.toString();
        return isHDFSUrul(strUrl);
    }

    private static boolean isHDFSUrul(String surl){
        String regEx4="^((hdfs)\\://)([a-zA-Z0-9\\.\\-]+" +
                "(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)?" +
                "((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|" +
                "[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|" +
                "2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.[a-zA-Z]{2,4})" +
                "(\\:[0-9]+)?(/[^/][a-zA-Z0-9\\.\\,\\?\\'\\\\/\\+&amp;%\\$#\\=~_\\-@]*)*$";

        Pattern p = Pattern.compile(regEx4);
        Matcher m = p.matcher(surl);
        return  m.matches();
    }
    /* public static void main(String[] args){
        boolean b=isHDFSUrul("hdfs://192.168.2.68:8080/test/123.txt");
        System.out.println(b);
     }*/
}
