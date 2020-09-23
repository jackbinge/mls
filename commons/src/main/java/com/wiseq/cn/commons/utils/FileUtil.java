package com.wiseq.cn.commons.utils;

import com.wiseq.cn.commons.entity.BaseFile;
import com.wiseq.cn.commons.entity.Result;
import org.apache.poi.poifs.filesystem.DirectoryEntry;
import org.apache.poi.poifs.filesystem.DocumentEntry;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        wangyh     原始版本
 * 文件说明: 文件上传工具类
 **/
public class FileUtil {

    /**
     * 文件上传
     *
     * @param file   上传文件
     * @param path   文件保存路径
     * @param dataId 关联数据ID
     */
    public static Result upload(MultipartFile file, String path, String dataId) {
        // 关联数据ID
        if (QuHelper.isNull(dataId)) dataId = ID.get();
        // 上次文件名,组装保存文件名
        String fileName = file.getOriginalFilename();
        String name = fileName.substring(0, fileName.lastIndexOf("."));
        String suffix = fileName.substring(fileName.lastIndexOf(".") + 1);
        String saveName = ID.get();
        try {
            File targetFile = new File(path + "/" + saveName + "." + suffix);
            // 判断保存目录,不存在创建
            exists(targetFile);
            // 保存文件
            file.transferTo(targetFile);
            // 保存附件记录
            BaseFile baseFile = new BaseFile();
            baseFile.setName(name);
            baseFile.setSaveName(saveName);
            baseFile.setPath(targetFile.getPath());
            baseFile.setSuffix(suffix);
            baseFile.setDataId(dataId);
            return ResultUtils.success(baseFile);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtils.error(-1, "文件上传异常");
        }
    }

    /**
     * 附件下载
     *
     * @param baseFile
     * @param response
     */
    public static Result down(BaseFile baseFile, HttpServletResponse response) {
        try {
            String name = new String(baseFile.getName().getBytes("UTF-8"), "iso-8859-1");
            File file = new File(baseFile.getPath());
            if (!file.exists()) return ResultUtils.error(-1, "附件不存在!");
            // 以流的形式下载文件。
            InputStream fis = new BufferedInputStream(new FileInputStream(baseFile.getPath()));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();
            // 设置response的Header
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/octet-stream");
            response.addHeader("Content-Length", "" + file.length());
            response.addHeader("Content-Disposition", "attachment;filename=" + name + "." + baseFile.getSuffix());
            // 写出文件
            OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
            outputStream.write(buffer);
            outputStream.flush();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtils.error(-1, "下载失败!");
        }
        return ResultUtils.success();
    }

    /**
     * 附件下载
     *
     * @param path
     * @param response
     */
    public static Result down(String path, HttpServletResponse response) {
        try {
            File file = new File(path);
            String name = new String(file.getName().getBytes("UTF-8"), "iso-8859-1");
            if (!file.exists()) return ResultUtils.error(-1, "附件不存在!");
            // 以流的形式下载文件。
            InputStream fis = new BufferedInputStream(new FileInputStream(path));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();
            // 设置response的Header
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/octet-stream");
            response.addHeader("Content-Length", "" + file.length());
            response.addHeader("Content-Disposition", "attachment;filename=" + name);
            // 写出文件
            OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
            outputStream.write(buffer);
            outputStream.flush();
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtils.error(-1, "下载失败!");
        }
        return ResultUtils.success();
    }

    /**
     * 附件下载
     *
     * @param baseFileList
     * @param response
     */
    public static Result down(List<BaseFile> baseFileList, HttpServletResponse response) {
        try {
            if (baseFileList.size() <= 0) return ResultUtils.error(-1, "附件不存在!");
            // 文件名转码
            String name = new String("附件".getBytes("UTF-8"), "iso-8859-1");
            // 设置response的Header
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/octet-stream");
            response.addHeader("Content-Disposition", "attachment;filename=" + name + ".zip");
            ZipOutputStream out = new ZipOutputStream(response.getOutputStream());
            // 压缩下载
            baseFileList.stream().forEach(baseFile -> {
                try {
                    String fileName = baseFile.getName() + "." + baseFile.getSuffix();
                    if (FileUtil.exists(baseFile.getPath())) {
                        compressZip(new File(baseFile.getPath()), fileName, out);
                        response.flushBuffer();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtils.error(-1, "下载失败!");
        }
        return ResultUtils.success();
    }

    /**
     * 多文件打压缩包
     *
     * @param file
     * @param out
     * @throws IOException
     */
    public static void compressZip(File file, String name, ZipOutputStream out) throws IOException {
        ZipEntry entry = new ZipEntry(name);
        out.putNextEntry(entry);
        int len;
        byte[] buffer = new byte[1024];
        FileInputStream fis = new FileInputStream(file);
        while ((len = fis.read(buffer)) > 0) {
            out.write(buffer, 0, len);
            out.flush();
        }
        out.closeEntry();
        fis.close();
    }

    /**
     * 删除文件
     *
     * @param path
     */
    public static void deletFile(String path) {
        // 设置文件路径
        File file = new File(path);
        // 文件存在删除文件
        if (file.exists()) file.delete();
    }

    /**
     * 判断文件是否存在
     *
     * @param path
     * @return
     */
    public static boolean exists(String path) {
        return new File(path).exists();
    }

    /**
     * 检测文件是否被占用
     *
     * @return
     */
    public static boolean checkFileUsed(String path) {
        try {
            File file = new File(path);
            RandomAccessFile raf = new RandomAccessFile(file, "rw");
            raf.close();
            return false;
        } catch (Exception e) {
            return true;
        }
    }

    /**
     * 判断文件是否存在
     *
     * @param file
     */
    public static void exists(File file) {
        // 判断文件父目录是否存在
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        // 设置文件权限
        try {
            String[] strs = file.getPath().split("/");
            String path = "";
            for (int i = 0; i < strs.length; i++) {
                if ("/".equals(path)) {
                    path = path + strs[i];
                } else {
                    path = path + "/" + strs[i];
                }
                Runtime.getRuntime().exec("chmod 755 " + path);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 判断路径是否存在，不存在创建路径
     *
     * @param path
     */
    public static void existsMkdir(String path) {
        File file = new File(path);
        // 判断文件父目录是否存在
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
    }

    /**
     * 获取目录下所有文件
     *
     * @param path   文件路径
     * @param suffix 是否需要后缀
     * @return
     */
    public static List<String> loadFileByPath(String path, boolean suffix) {
        File file = new File(path);
        File[] fileList = file.listFiles();
        List<String> list = new ArrayList<>();
        if (fileList != null) {
            for (int i = 0; i < fileList.length; i++) {
                if (fileList[i].isFile()) {
                    if (suffix) {
                        list.add(fileList[i].getName());
                        continue;
                    }
                    list.add(fileList[i].getName().substring(0, fileList[i].getName().lastIndexOf(".")));
                }
            }
        }
        return list;
    }

    /**
     * 拷贝文件
     *
     * @param original 原文件
     * @param target   目标文件
     * @param isDelete 拷贝后是否删除原文件
     */
    public static void copyFile(String original, String target, boolean isDelete) {
        // 判断目标路径是否存在
        existsMkdir(target);
        // 拷贝文件
        FileChannel inputChanel = null;
        FileChannel outChanel = null;
        File file = new File(original);
        File file1 = new File(target);
        try {
            inputChanel = new FileInputStream(file).getChannel();
            outChanel = new FileOutputStream(file1).getChannel();
            outChanel.transferFrom(inputChanel, 0, inputChanel.size());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (inputChanel != null) inputChanel.close();
                if (outChanel != null) outChanel.close();
                // 是否删除原文件
                System.err.println(file.exists());
                if (isDelete && file.exists()) file.delete();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * HTML导出为WORD
     *
     * @param request
     * @param response
     * @param content
     * @param fileName
     */
    public static void exportWord(HttpServletRequest request, HttpServletResponse response, String content, String fileName) {
        try {
            //word内容
            byte b[] = content.getBytes("utf-8");
            ByteArrayInputStream bais = new ByteArrayInputStream(b);

            //生成word格式
            POIFSFileSystem poifs = new POIFSFileSystem();
            DirectoryEntry directory = poifs.getRoot();
            directory.createDocument("WordDocument", bais);
            request.setCharacterEncoding("utf-8");
            response.setContentType("application/msword");//导出word格式
            response.addHeader("Content-Disposition", "attachment;filename=" +
                    new String((fileName + ".doc").getBytes(), "iso-8859-1"));

            OutputStream ostream = response.getOutputStream();
            poifs.writeFilesystem(ostream);
            bais.close();
            ostream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
