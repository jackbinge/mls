package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/5/30     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class EqptValveWithFile {
     private  String groupName; //组织
     private String eqptValveName;//阀体名称
     private Long groupId;//组织机构ID
     private  Integer positon ; //位置编码
     private  Long  eqptValveId;
     private  Long  taskStateId;
     private  String createTime;//创建时间
     private  String qcFileList;
     private  Integer qcNum;
     private  String fzckFileIdList;
     private  Integer fzckNum;
     private  String zckFileIdList;
     private  Integer zckNum;
     private  String teskOkFileIdList;
     private  Integer testOkNum;
     private String testNgFileList;
     private  Integer testNgNum;
}
