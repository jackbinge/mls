/*
 Navicat Premium Data Transfer

 Source Server         : 本地库
 Source Server Type    : MySQL
 Source Server Version : 80018
 Source Host           : localhost:3306
 Source Schema         : yk_ai

 Target Server Type    : MySQL
 Target Server Version : 80018
 File Encoding         : 65001

 Date: 15/04/2020 11:01:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bs_eqpt_gule_dosage
-- ----------------------------
DROP TABLE IF EXISTS `bs_eqpt_gule_dosage`;
CREATE TABLE `bs_eqpt_gule_dosage`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_state_id` bigint(20) NOT NULL COMMENT '任务单状态 id',
  `eqpt_valve_id` bigint(20) NOT NULL COMMENT '设备阀体id',
  `dosage` double NOT NULL COMMENT '点胶用量',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_task_state_dosage`(`task_state_id`) USING BTREE,
  INDEX `fk_gule_dosage_eqpt_valve_id`(`eqpt_valve_id`) USING BTREE,
  CONSTRAINT `fk_gule_dosage_eqpt_valve_id` FOREIGN KEY (`eqpt_valve_id`) REFERENCES `t_eqpt_valve` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_task_state_dosage` FOREIGN KEY (`task_state_id`) REFERENCES `bs_task_state` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备机台点胶用量，用于记录此设备的点胶用量,如果每修改一次点胶量，此表增加一条数据' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_eqpt_task_runtime
-- ----------------------------
DROP TABLE IF EXISTS `bs_eqpt_task_runtime`;
CREATE TABLE `bs_eqpt_task_runtime`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) NOT NULL COMMENT '任务单id',
  `eqpt_valve_id` bigint(20) NOT NULL COMMENT '设备阀体id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_eqpt_task_id`(`task_id`) USING BTREE,
  INDEX `fk_task_eqpt_valve_id`(`eqpt_valve_id`) USING BTREE,
  CONSTRAINT `fk_eqpt_task_id` FOREIGN KEY (`task_id`) REFERENCES `bs_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_task_eqpt_valve_id` FOREIGN KEY (`eqpt_valve_id`) REFERENCES `t_eqpt_valve` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备任务状态，当前设备正在做那个任务单,当该设备完成当前任务单点胶时，将删除相应记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_eqpt_valve_state
-- ----------------------------
DROP TABLE IF EXISTS `bs_eqpt_valve_state`;
CREATE TABLE `bs_eqpt_valve_state`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_state_id` bigint(20) NOT NULL COMMENT '任务状体id',
  `eqpt_valve_id` bigint(20) NOT NULL COMMENT '设备阀体id',
  `eqpt_valve_df_id` bigint(20) NOT NULL COMMENT '设备阀体状态定义',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_eqpt_valve_state_valve_id`(`eqpt_valve_id`) USING BTREE,
  INDEX `fk_eqpt_valve_df_valve_id`(`eqpt_valve_df_id`) USING BTREE,
  INDEX `fk_eqpt_valve_task_state_id`(`task_state_id`) USING BTREE,
  CONSTRAINT `fk_eqpt_valve_df_valve_id` FOREIGN KEY (`eqpt_valve_df_id`) REFERENCES `t_eqpt_valve_state_df` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_eqpt_valve_state_valve_id` FOREIGN KEY (`eqpt_valve_id`) REFERENCES `t_eqpt_valve` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_eqpt_valve_task_state_id` FOREIGN KEY (`task_state_id`) REFERENCES `bs_task_state` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备状态阀体' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_formula_update_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_formula_update_log`;
CREATE TABLE `bs_formula_update_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `model_bom_id` bigint(20) NOT NULL COMMENT '配方id',
  `update_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 用户输入,1 系统主动修改,2 系统推荐，3 推荐修改',
  `creator` bigint(20) NULL DEFAULT NULL COMMENT '修改用户',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_formula_update_log_id`(`model_bom_id`) USING BTREE,
  CONSTRAINT `fk_formula_update_log_id` FOREIGN KEY (`model_bom_id`) REFERENCES `t_model_bom` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配比库更新日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_formula_update_log_dtl
-- ----------------------------
DROP TABLE IF EXISTS `bs_formula_update_log_dtl`;
CREATE TABLE `bs_formula_update_log_dtl`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `formula_update_log_id` bigint(20) NOT NULL COMMENT '配比修改日志',
  `model_bom_id` bigint(20) NOT NULL COMMENT '配方id - 新加',
  `material_id` bigint(20) NOT NULL COMMENT 'a胶，b胶，荧光粉、抗成淀粉、扩散粉 a胶和b胶对应的胶水详情表 - 新加',
  `ratio` double NOT NULL COMMENT '比值 - 新加',
  `material_class` tinyint(4) NOT NULL COMMENT '物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉，4 扩散粉 - 新加',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_formula_update_log_dtl_id`(`formula_update_log_id`) USING BTREE,
  CONSTRAINT `fk_formula_update_log_dtl_id` FOREIGN KEY (`formula_update_log_id`) REFERENCES `bs_formula_update_log` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统配比修改所有数据记录,具体存储放内容需和算法联系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_model_data_source
-- ----------------------------
DROP TABLE IF EXISTS `bs_model_data_source`;
CREATE TABLE `bs_model_data_source`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `model_factor_id` bigint(20) NOT NULL COMMENT '模型id',
  `file_id` bigint(20) NOT NULL COMMENT '分光文件id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ai_model_file_id`(`file_id`) USING BTREE,
  INDEX `fk_ai_model_factor_data_source_id`(`model_factor_id`) USING BTREE,
  CONSTRAINT `fk_ai_model_factor_data_source_id` FOREIGN KEY (`model_factor_id`) REFERENCES `bs_model_factor` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_model_file_id` FOREIGN KEY (`file_id`) REFERENCES `d_upload_file` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '更新当前模型所使用的数据源' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_model_factor
-- ----------------------------
DROP TABLE IF EXISTS `bs_model_factor`;
CREATE TABLE `bs_model_factor`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `model_id` bigint(20) NOT NULL COMMENT '模型id',
  `mcoff_valgol` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '基于体积,json格式采用{荧光粉id:系数}',
  `mcoff_walgol` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '基于质量,json格式采用{荧光粉id:系数}',
  `task_state_id` bigint(20) NOT NULL COMMENT '关联具体任务单状态',
  `is_active` tinyint(1) NULL DEFAULT NULL COMMENT '标识系数是否该模型最新系数， true 是最新 false 不是',
  `modify_time` datetime(0) NULL DEFAULT NULL COMMENT '记录模型系数被修改的时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '模型参数创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ai_model_factor_task_state_id`(`task_state_id`) USING BTREE,
  INDEX `fk_ai_model_factor_id`(`model_id`) USING BTREE,
  CONSTRAINT `fk_ai_model_factor_id` FOREIGN KEY (`model_id`) REFERENCES `t_ai_model` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_model_factor_task_state_id` FOREIGN KEY (`task_state_id`) REFERENCES `bs_task_state` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '模型系数' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_model_recommend_result
-- ----------------------------
DROP TABLE IF EXISTS `bs_model_recommend_result`;
CREATE TABLE `bs_model_recommend_result`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `model_id` bigint(20) NOT NULL COMMENT '模型id',
  `valgol` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '基于体积,json格式采用[{荧光粉id:比例}]',
  `walgol` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '基于质量,json格式采用[{荧光粉id:比例}]',
  `model_factor_id` bigint(20) NOT NULL COMMENT '模型系数id',
  `task_state_id` bigint(20) NULL DEFAULT NULL COMMENT '关联具体任务单状态',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '模型参数创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ai_model_result_model_factor_id`(`model_factor_id`) USING BTREE,
  INDEX `fk_ai_model_result_factor_id`(`model_id`) USING BTREE,
  CONSTRAINT `fk_ai_model_result_factor_id` FOREIGN KEY (`model_id`) REFERENCES `t_ai_model` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_model_result_model_factor_id` FOREIGN KEY (`model_factor_id`) REFERENCES `bs_model_factor` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '算法每次推荐结果存储' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_task
-- ----------------------------
DROP TABLE IF EXISTS `bs_task`;
CREATE TABLE `bs_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工单编码',
  `type` tinyint(4) NULL DEFAULT 0 COMMENT '工单类型，0量产单 1 样品单',
  `wo_id` bigint(20) NULL DEFAULT NULL COMMENT '来自EAS_wo的那条记录',
  `state` tinyint(1) NULL DEFAULT 0 COMMENT '工单是否关闭,ture关闭，false未关闭',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `close_time` datetime(0) NULL DEFAULT NULL COMMENT '关闭时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `f_eas_wo_id`(`wo_id`) USING BTREE,
  CONSTRAINT `f_eas_wo_id` FOREIGN KEY (`wo_id`) REFERENCES `eas_wo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产任务单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_task_formula
-- ----------------------------
DROP TABLE IF EXISTS `bs_task_formula`;
CREATE TABLE `bs_task_formula`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_state_id` bigint(20) NOT NULL COMMENT '任务单状态 id',
  `task_bom_id` bigint(20) NOT NULL COMMENT '任务单状态bom id,取当前任务单状态对应的model bom id',
  `vesion_code` int(11) NOT NULL COMMENT '配比的版本号,不断累加',
  `vesion_time` datetime(0) NOT NULL COMMENT '配比的创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_task_formula_info_id`(`task_state_id`) USING BTREE,
  CONSTRAINT `fk_task_formula_info_id` FOREIGN KEY (`task_state_id`) REFERENCES `bs_task_state` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务在每个阶段的配比' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_task_formula_dtl
-- ----------------------------
DROP TABLE IF EXISTS `bs_task_formula_dtl`;
CREATE TABLE `bs_task_formula_dtl`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_formula_id` bigint(20) NOT NULL COMMENT '任务单状态 id',
  `material_id` bigint(20) NOT NULL COMMENT 'a胶，b胶，荧光粉、抗成淀粉、扩散粉 a胶和b胶对应的胶水详情表',
  `ratio` double NOT NULL COMMENT '比值',
  `material_class` tinyint(4) NOT NULL COMMENT '物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉  4 扩散粉  ',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_task_formula_dtl_id`(`task_formula_id`) USING BTREE,
  CONSTRAINT `fk_task_formula_dtl_id` FOREIGN KEY (`task_formula_id`) REFERENCES `bs_task_formula` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务在每个阶段配比详细信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_task_state
-- ----------------------------
DROP TABLE IF EXISTS `bs_task_state`;
CREATE TABLE `bs_task_state`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) NOT NULL COMMENT '任务单id',
  `task_df_id` bigint(20) NOT NULL COMMENT '任务状态定义id',
  `is_retest` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否重新测试',
  `model_id` bigint(20) NOT NULL COMMENT '当前状态对应的算法模型',
  `reason` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '失败原因',
  `solution_type` tinyint(4) NULL DEFAULT NULL COMMENT '解决措施 成功为0, 1忽略继续生产  2修改点胶量 3修改配比 4 修改bom 5 前测数据批量否定',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `modify_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '当前是否处于活动状态',
  `creator` bigint(20) NOT NULL COMMENT '当前登录用户',
  `update_user` bigint(20) NULL DEFAULT NULL COMMENT '修改状态的用户',
  `check_user` bigint(20) NULL DEFAULT NULL COMMENT '状态变更修改确认用户',
  `output_require_before_test_rule_id` bigint(20) NULL DEFAULT NULL COMMENT '前测规则ID',
  `output_require_nbake_rule_id` bigint(20) NULL DEFAULT NULL COMMENT '非正常烤',
  `fileid_list` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件id的list',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_task_state_df_id`(`task_df_id`) USING BTREE,
  INDEX `fk_output_require_before_test_rule_id`(`output_require_before_test_rule_id`) USING BTREE,
  INDEX `fk_output_require_nbake_rule_id`(`output_require_nbake_rule_id`) USING BTREE,
  INDEX `fk_task_state_model_id`(`model_id`) USING BTREE,
  INDEX `fk_task_state_id`(`task_id`) USING BTREE,
  CONSTRAINT `fk_output_require_before_test_rule_id` FOREIGN KEY (`output_require_before_test_rule_id`) REFERENCES `t_output_require_before_test_rule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_output_require_nbake_rule_id` FOREIGN KEY (`output_require_nbake_rule_id`) REFERENCES `t_output_require_nbake_rule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_task_state_df_id` FOREIGN KEY (`task_df_id`) REFERENCES `t_task_state_df` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_task_state_id` FOREIGN KEY (`task_id`) REFERENCES `bs_task` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_task_state_model_id` FOREIGN KEY (`model_id`) REFERENCES `t_ai_model` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务单状态' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for d_file_color_region_summary
-- ----------------------------
DROP TABLE IF EXISTS `d_file_color_region_summary`;
CREATE TABLE `d_file_color_region_summary`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_id` bigint(20) NOT NULL COMMENT '分光文件id',
  `color_region_id` bigint(20) NULL DEFAULT NULL COMMENT '色区id',
  `color_region_dtl_id` bigint(20) NULL DEFAULT NULL COMMENT '色区详情id',
  `total_size` bigint(20) NULL DEFAULT NULL COMMENT '总量',
  `bin_size` bigint(20) NULL DEFAULT NULL COMMENT '各色区落bin数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_file_color_region_summary_id`(`file_id`) USING BTREE,
  INDEX `fk_file_summary_color_region_id`(`color_region_id`) USING BTREE,
  CONSTRAINT `fk_file_color_region_summary_id` FOREIGN KEY (`file_id`) REFERENCES `d_upload_file` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_file_summary_color_region_id` FOREIGN KEY (`color_region_id`) REFERENCES `t_color_region` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分光文件各色取落bin率统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for d_file_summary
-- ----------------------------
DROP TABLE IF EXISTS `d_file_summary`;
CREATE TABLE `d_file_summary`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_id` bigint(20) NOT NULL COMMENT '分光文件id',
  `total_size` double NULL DEFAULT NULL COMMENT '总量，测试记录数',
  `cie_x` double NULL DEFAULT NULL COMMENT '打靶的中心点x坐标',
  `cie_y` double NULL DEFAULT NULL COMMENT '打靶的中心点y坐标',
  `cie_x_std` double NULL DEFAULT NULL COMMENT 'cie_x标准差',
  `cie_y_std` double NULL DEFAULT NULL COMMENT 'cie_y标准差',
  `cie_xy_corr` double NULL DEFAULT NULL COMMENT 'cie_xy相关系数',
  `euclidean_distance_xy` double NULL DEFAULT NULL COMMENT '打靶中心点距离目标中心的欧式距离',
  `euclidean_distance_x` double NULL DEFAULT NULL COMMENT 'x方向欧式距离',
  `euclidean_distance_y` double NULL DEFAULT NULL COMMENT 'y方向欧式距离',
  `ra_mean` double NULL DEFAULT NULL COMMENT '显指均值',
  `ra_media` double NULL DEFAULT NULL COMMENT '显指中位数',
  `ra_max` double NULL DEFAULT NULL COMMENT '显指最大值',
  `ra_min` double NULL DEFAULT NULL COMMENT '显指最小值',
  `ra_std` double NULL DEFAULT NULL COMMENT '显指标准差',
  `ra_yield` double NULL DEFAULT NULL COMMENT '显示指数良率',
  `cri9_mean` double NULL DEFAULT NULL COMMENT 'cri9均值',
  `cri9_media` double NULL DEFAULT NULL COMMENT 'cri9中位数',
  `cri9_max` double NULL DEFAULT NULL COMMENT 'cri9最大值',
  `cri9_min` double NULL DEFAULT NULL COMMENT 'cri9最小值',
  `cri9_std` double NULL DEFAULT NULL COMMENT 'cri9标准差',
  `lm_mean` double NULL DEFAULT NULL COMMENT 'lm均值',
  `lm_media` double NULL DEFAULT NULL COMMENT 'lm中位数',
  `lm_max` double NULL DEFAULT NULL COMMENT 'lm最大值',
  `lm_min` double NULL DEFAULT NULL COMMENT 'lm最小值',
  `lm_std` double NULL DEFAULT NULL COMMENT 'lm标准差',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_file_summary_file_id`(`file_id`) USING BTREE,
  CONSTRAINT `fk_file_summary_file_id` FOREIGN KEY (`file_id`) REFERENCES `d_upload_file` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分光结果汇总' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for d_upload_file
-- ----------------------------
DROP TABLE IF EXISTS `d_upload_file`;
CREATE TABLE `d_upload_file`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_state_id` bigint(20) NOT NULL COMMENT '任务单状态 id',
  `path` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件路径',
  `classType` tinyint(4) NOT NULL COMMENT '文件类型,0 正常烤文件 1 非正常烤文件 2 前测文件',
  `process_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '工艺类型，0 单层工艺，1 双层工艺',
  `gule_layer` tinyint(4) NULL DEFAULT 0 COMMENT '只针对双层工艺，双层工艺先下后上，层级 0 下层 1 上层; ',
  `user_id` bigint(20) NOT NULL COMMENT '关联用户表，上传当前文件的用户',
  `device_ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试机ip',
  `device_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试及编号',
  `eqpt_valve_id` bigint(20) NOT NULL COMMENT '生产设备阀体id',
  `digest` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件摘要,取文件的md5，防止文件被篡改',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT '文件是否废弃,false不废弃，true废弃',
  `file_state` tinyint(4) NOT NULL DEFAULT -1 COMMENT '文件状态，-1未判定，0判定ok,1判定NG',
  `judgeUser` bigint(20) NULL DEFAULT NULL COMMENT '判定人',
  `judgeTime` datetime(0) NULL DEFAULT NULL COMMENT '判定时间',
  `color_coordinates` tinyint(1) NULL DEFAULT NULL COMMENT '色坐标判定结果',
  `lightness` tinyint(1) NULL DEFAULT NULL COMMENT '亮度判定结果',
  `ra` tinyint(1) NULL DEFAULT NULL COMMENT 'ra的判定结果',
  `r9` tinyint(1) NULL DEFAULT NULL COMMENT 'r9的判定结果',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_task_state_file`(`task_state_id`) USING BTREE,
  CONSTRAINT `fk_task_state_file` FOREIGN KEY (`task_state_id`) REFERENCES `bs_task_state` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分光文件,每次上上传的分光文件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for eas_wo
-- ----------------------------
DROP TABLE IF EXISTS `eas_wo`;
CREATE TABLE `eas_wo`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `eas_billId` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单ID',
  `eas_billNumber` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单编码',
  `eas_bizDate` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务日期',
  `eas_status` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态',
  `eas_storageId` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '库存组织ID',
  `eas_storageNumber` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '库存组织编码',
  `eas_storageName` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '库存组织名称',
  `eas_adminOrgId` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门ID',
  `eas_adminOrgNumber` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门编码',
  `eas_adminOrgName` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门名称',
  `eas_productId` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品ID',
  `eas_productNumber` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编码',
  `eas_productName` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品名称',
  `eas_productModel` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品规格型号',
  `eas_ttypeNumber` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '事务类型编码',
  `eas_ttypeName` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '事务类型名称',
  `eas_bomNumber` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Bom编码',
  `eas_qty` decimal(10, 0) NULL DEFAULT NULL COMMENT '订单数量',
  `eas_inWarehQty` decimal(10, 0) NULL DEFAULT NULL COMMENT '订单已入库数量',
  `eas_planBeginDate` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计划开工日期',
  `eas_planEndDate` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计划完工日期',
  `eas_remak` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'eas 工单备注',
  `feed_exception` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '投料是否异常,存放异常原因，如果为null没有异常，可以投产,不为null,有异常',
  `conver_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否已处理,当被成功转为我们系统的工单时，修改该状态 0 未投产 1 投产成功 ',
  `group_id` bigint(20) NOT NULL COMMENT '组织机构ID,用来确定这条工单属于哪个生产车间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '同步创建时间',
  `convert_time` datetime(0) NULL DEFAULT NULL COMMENT '投产时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `f_eas_wo_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `f_eas_wo_group_id` FOREIGN KEY (`group_id`) REFERENCES `t_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '从木林森EAS同步的工单，需要用户手动转为我们系统的工单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for eas_wo_dtl
-- ----------------------------
DROP TABLE IF EXISTS `eas_wo_dtl`;
CREATE TABLE `eas_wo_dtl`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `wo_id` bigint(20) NULL DEFAULT NULL COMMENT 'eas_wo 表id',
  `entryId` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分录ID',
  `parentId` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单ID',
  `materialId` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产订单ID',
  `materialNumber` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料编码',
  `materialName` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料名称',
  `materialModel` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格型号',
  `unitName` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计量单位',
  `standardQty` decimal(10, 0) NULL DEFAULT NULL COMMENT '标准用量',
  `reqQty` decimal(10, 0) NULL DEFAULT NULL COMMENT '需求数量',
  `unitQty` decimal(10, 0) NULL DEFAULT NULL COMMENT '单位用量',
  `issueQty` decimal(10, 0) NULL DEFAULT NULL COMMENT '已领料数量',
  `returnQty` decimal(10, 0) NULL DEFAULT NULL COMMENT '退料数量',
  `material_class` tinyint(4) NULL DEFAULT NULL COMMENT '物料类型，null 未知,0芯片  1胶水 2 荧光粉 3 支架 4扩散粉 5抗沉淀粉',
  `canIssueQty` decimal(10, 0) NULL DEFAULT NULL COMMENT '可领料数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_eas_wo_id`(`wo_id`) USING BTREE,
  CONSTRAINT `fk_eas_wo_id` FOREIGN KEY (`wo_id`) REFERENCES `eas_wo` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '从木林森EAS同步的工单，需要用户手动转为我们系统的工单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for material_type_map
-- ----------------------------
DROP TABLE IF EXISTS `material_type_map`;
CREATE TABLE `material_type_map`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `materal_type` tinyint(4) NOT NULL COMMENT '物料类型，0芯片  1胶水 2 荧光粉 3 支架 4扩散粉 5抗沉淀粉',
  `type_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料类型名',
  `map_rule` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料编码与类型映射规则，建议为正则表达式,通过正则过滤',
  `remark` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '物料编码与类型映射规则，建议为正则表达式' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of material_type_map
-- ----------------------------
INSERT INTO `material_type_map` VALUES (1, 0, '芯片', '01.01.01.010', NULL, 0, 0, '2019-11-19 17:19:30');
INSERT INTO `material_type_map` VALUES (2, 0, '芯片', '22.22.22.222', NULL, 0, 1, '2019-11-19 17:19:30');
INSERT INTO `material_type_map` VALUES (3, 0, '芯片', '33.33.33.333', NULL, 0, 1, '2019-11-19 17:19:30');
INSERT INTO `material_type_map` VALUES (4, 0, '芯片', '02.10.03.001', NULL, 0, 0, '2019-11-20 15:05:06');
INSERT INTO `material_type_map` VALUES (5, 0, '芯片', '06.10.03.001', NULL, 0, 0, '2019-11-20 15:05:06');
INSERT INTO `material_type_map` VALUES (6, 0, '芯片', '05.10.22.001', NULL, 0, 0, '2019-11-20 15:05:06');
INSERT INTO `material_type_map` VALUES (7, 1, '胶水', '01.02.03.013', NULL, 0, 0, '2019-11-20 15:05:35');
INSERT INTO `material_type_map` VALUES (8, 1, '胶水', '01.02.03.014', NULL, 0, 0, '2019-11-20 15:05:35');
INSERT INTO `material_type_map` VALUES (9, 1, '胶水', '01.02.03.010', NULL, 0, 0, '2019-11-20 15:05:35');
INSERT INTO `material_type_map` VALUES (10, 2, '荧光粉', '01.02.01.001', NULL, 0, 0, '2019-11-20 15:06:05');
INSERT INTO `material_type_map` VALUES (11, 3, '支架', '02.03.20.002', NULL, 0, 0, '2019-11-20 15:06:20');
INSERT INTO `material_type_map` VALUES (12, 5, '抗沉淀粉', '01.02.10.008', NULL, 0, 0, '2019-11-20 15:06:48');
INSERT INTO `material_type_map` VALUES (13, 5, '抗沉淀粉', '01.02.10.015', NULL, 0, 0, '2019-11-20 15:06:48');
INSERT INTO `material_type_map` VALUES (14, 5, '抗沉淀粉', '11.11.11.111', NULL, 0, 1, '2019-11-21 14:41:26');
INSERT INTO `material_type_map` VALUES (16, 5, '抗沉淀粉', '12.22.15.451', NULL, 0, 0, '2019-11-22 10:14:18');
INSERT INTO `material_type_map` VALUES (17, 5, '抗沉淀粉', '12.15.78.987', NULL, 0, 0, '2019-11-22 10:14:18');
INSERT INTO `material_type_map` VALUES (18, 4, '扩散粉', '36.45.77.887', NULL, 0, 0, '2019-11-22 10:14:39');
INSERT INTO `material_type_map` VALUES (19, 1, '胶水', '01.02.00.112', NULL, 0, 0, '2019-11-22 10:15:35');

-- ----------------------------
-- Table structure for t_ai_model
-- ----------------------------
DROP TABLE IF EXISTS `t_ai_model`;
CREATE TABLE `t_ai_model`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_machine_id` bigint(20) NOT NULL COMMENT '机种ID',
  `color_region_id` bigint(20) NOT NULL COMMENT '机种色区ID',
  `output_require_machine_id` bigint(20) NOT NULL COMMENT '机种出货要求ID',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `creator` bigint(20) NOT NULL COMMENT '模型创建用户',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ai_model_type_machine_id`(`type_machine_id`) USING BTREE,
  INDEX `fk_ai_model_require_id`(`output_require_machine_id`) USING BTREE,
  INDEX `fk_ai_model_color_region_id`(`color_region_id`) USING BTREE,
  CONSTRAINT `fk_ai_model_color_region_id` FOREIGN KEY (`color_region_id`) REFERENCES `t_color_region` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_model_require_id` FOREIGN KEY (`output_require_machine_id`) REFERENCES `t_output_requirements` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_model_type_machine_id` FOREIGN KEY (`type_machine_id`) REFERENCES `t_type_machine` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '算法模型，模型定义：机种（显指、色温、流明、波长），BOM组合（支架型号、AB胶型号、荧光粉组合、芯片型号、芯片波段），色区，出货要求。' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_anti_starch
-- ----------------------------
DROP TABLE IF EXISTS `t_anti_starch`;
CREATE TABLE `t_anti_starch`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `anti_starch_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '抗沉淀粉编码',
  `anti_starch_spec` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '抗沉淀粉规格',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `density` double NOT NULL COMMENT '密度',
  `add_proportion` double NULL DEFAULT NULL COMMENT '添加比例',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false 正常、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '抗沉淀粉' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_before_test_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_before_test_rule`;
CREATE TABLE `t_before_test_rule`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rule_kind` tinyint(4) NOT NULL COMMENT '规则类型， 0 椭圆,1 四边形,2 点,3 等于出货要求中心点，该中心点在在新建机种时，以调用算法算出来',
  `a` double NULL DEFAULT NULL COMMENT '椭圆长轴',
  `b` double NULL DEFAULT NULL COMMENT '椭圆短轴',
  `x` double NULL DEFAULT NULL COMMENT '椭圆中心点x',
  `y` double NULL DEFAULT NULL COMMENT '椭圆中心点y',
  `angle` double NULL DEFAULT NULL COMMENT '椭圆倾角',
  `x1` double NULL DEFAULT NULL COMMENT '左上-坐标 x1',
  `y1` double NULL DEFAULT NULL COMMENT '左上-坐标 y1',
  `x2` double NULL DEFAULT NULL COMMENT '右上-坐标 x2',
  `y2` double NULL DEFAULT NULL COMMENT '右上-坐标 y2',
  `x3` double NULL DEFAULT NULL COMMENT '右下-坐标 x3',
  `y3` double NULL DEFAULT NULL COMMENT '右下下-坐标 y3',
  `x4` double NULL DEFAULT NULL COMMENT '左下-坐标 x4',
  `y4` double NULL DEFAULT NULL COMMENT '左下-坐标 y4',
  `cp_x` double NULL DEFAULT NULL COMMENT '中心点x',
  `cp_y` double NULL DEFAULT NULL COMMENT '中心点x',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求对应的前测规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_bom
-- ----------------------------
DROP TABLE IF EXISTS `t_bom`;
CREATE TABLE `t_bom`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_machine_id` bigint(20) NOT NULL COMMENT '机种id',
  `bom_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'bom编码',
  `scaffold_id` bigint(20) NOT NULL COMMENT '支架',
  `glue_id` bigint(20) NOT NULL COMMENT '胶水',
  `diffusion_powder_id` bigint(20) NULL DEFAULT NULL COMMENT '扩散粉',
  `anti_starch_id` bigint(20) NULL DEFAULT NULL COMMENT '抗沉淀粉',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_temp` tinyint(1) NULL DEFAULT 0 COMMENT 'bom 类型，flase 正常,true 临时',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  `bom_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'bom类型 0 对应单层工艺，1 对应多层工艺上层 2 对应多层工艺下层',
  `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `bom_source` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'bom来源 0 EAS投料,1人工建立,2系统推荐',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_scaffold_id`(`scaffold_id`) USING BTREE,
  INDEX `fk_bom_glue_id`(`glue_id`) USING BTREE,
  INDEX `fk_diffusion_powder_id`(`diffusion_powder_id`) USING BTREE,
  INDEX `fk_anti_starch_id`(`anti_starch_id`) USING BTREE,
  INDEX `t_tpye_machine_bom_id`(`type_machine_id`) USING BTREE,
  CONSTRAINT `fk_anti_starch_id` FOREIGN KEY (`anti_starch_id`) REFERENCES `t_anti_starch` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_bom_glue_id` FOREIGN KEY (`glue_id`) REFERENCES `t_glue` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_diffusion_powder_id` FOREIGN KEY (`diffusion_powder_id`) REFERENCES `t_diffusion_powder` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_scaffold_id` FOREIGN KEY (`scaffold_id`) REFERENCES `t_scaffold` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `t_tpye_machine_bom_id` FOREIGN KEY (`type_machine_id`) REFERENCES `t_type_machine` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_bom_chip
-- ----------------------------
DROP TABLE IF EXISTS `t_bom_chip`;
CREATE TABLE `t_bom_chip`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bom_id` bigint(20) NOT NULL COMMENT 'bom_id',
  `chip_id` bigint(20) NOT NULL COMMENT '芯片id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom与芯片关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_bom_phosphor
-- ----------------------------
DROP TABLE IF EXISTS `t_bom_phosphor`;
CREATE TABLE `t_bom_phosphor`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bom_id` bigint(20) NOT NULL COMMENT 'bom id',
  `phosphor_id` bigint(20) NOT NULL COMMENT '荧光粉id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_bom_id`(`bom_id`) USING BTREE,
  INDEX `fk_phosphor_id`(`phosphor_id`) USING BTREE,
  CONSTRAINT `fk_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `t_bom` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_phosphor_id` FOREIGN KEY (`phosphor_id`) REFERENCES `t_phosphor` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom与荧光粉对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_bom_phosphor_for_recommended
-- ----------------------------
DROP TABLE IF EXISTS `t_bom_phosphor_for_recommended`;
CREATE TABLE `t_bom_phosphor_for_recommended`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `must_use_phosphor_id` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '必须要用的荧光粉',
  `prohibited_phosphor_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '禁止使用的荧光粉',
  `limit_phosphor_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '限制使用的荧光粉类型',
  `bom_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '推荐BOM时选择的禁用和必选的荧光粉' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_bom_target_parameter
-- ----------------------------
DROP TABLE IF EXISTS `t_bom_target_parameter`;
CREATE TABLE `t_bom_target_parameter`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ra_target` double NULL DEFAULT NULL COMMENT '显色指数,目标值/ra系列',
  `ra_max` double NULL DEFAULT NULL COMMENT '限制范围上限，用于算法显指良率统计',
  `ra_min` double NULL DEFAULT NULL COMMENT '显色指数下限，用于算法显指良率统计',
  `r9` double NULL DEFAULT NULL COMMENT 'R9',
  `ct` int(11) NULL DEFAULT NULL COMMENT '色温(k)',
  `lumen_lsl` double NULL DEFAULT NULL COMMENT '流明下限',
  `lumen_usl` double NULL DEFAULT NULL COMMENT '流明上限',
  `wl_lsl` double NULL DEFAULT NULL COMMENT '波长下限',
  `wl_usl` double NULL DEFAULT NULL COMMENT '波长上限',
  `bom_id` bigint(20) NOT NULL COMMENT 'bomId',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_t_bom_target_parameter_bom_id`(`bom_id`) USING BTREE,
  CONSTRAINT `fk_t_bom_target_parameter_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `t_bom` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '推荐BOM时的机种目标参数' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_chip
-- ----------------------------
DROP TABLE IF EXISTS `t_chip`;
CREATE TABLE `t_chip`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chip_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '芯片编码',
  `chip_spec` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '芯片规格',
  `chip_rank` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '芯片等级',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `test_condition` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '测试条件(非必填)',
  `vf_max` double NULL DEFAULT NULL COMMENT 'VF正向电压最大值',
  `vf_min` double NULL DEFAULT NULL COMMENT 'VF正向电压最小值',
  `iv_max` double NULL DEFAULT NULL COMMENT 'IV发光强度最大值',
  `iv_min` double NULL DEFAULT NULL COMMENT 'IV发光强度最小值',
  `wl_max` double NULL DEFAULT NULL COMMENT '波长最大值',
  `wl_min` double NULL DEFAULT NULL COMMENT '波长最小值',
  `lumen_max` double NULL DEFAULT NULL COMMENT '亮度最大值',
  `lumen_min` double NULL DEFAULT NULL COMMENT '亮度最小值',
  `fwhm` double NULL DEFAULT NULL COMMENT '半高宽',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '芯片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_chip_wl_rank
-- ----------------------------
DROP TABLE IF EXISTS `t_chip_wl_rank`;
CREATE TABLE `t_chip_wl_rank`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '芯片名字',
  `chip_id` bigint(20) NOT NULL COMMENT '芯片ID',
  `wl_max` double NOT NULL COMMENT '波长最大值',
  `wl_min` double NOT NULL COMMENT '波长最小值',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_chip_wl_rank`(`chip_id`) USING BTREE,
  CONSTRAINT `fk_chip_wl_rank` FOREIGN KEY (`chip_id`) REFERENCES `t_chip` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '芯片波段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_color_region
-- ----------------------------
DROP TABLE IF EXISTS `t_color_region`;
CREATE TABLE `t_color_region`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_machine_id` bigint(20) NOT NULL COMMENT '机种id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '色区名称，色块色区名称',
  `color_region_type` tinyint(4) NULL DEFAULT NULL COMMENT '色区细分类型，0 色容差色区，1 色块色区',
  `xrows` int(11) NULL DEFAULT NULL COMMENT '此色块所在行数, 只针对色块色区，色容差色区该字段为空',
  `xcolumns` int(11) NULL DEFAULT NULL COMMENT '此色块所在列数，只针对色块色区，色容差色区该字段为空',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false启用、true 禁用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_color_region_type_machine_id`(`type_machine_id`) USING BTREE,
  CONSTRAINT `fk_color_region_type_machine_id` FOREIGN KEY (`type_machine_id`) REFERENCES `t_type_machine` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种对应的色区' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_color_region_dtl
-- ----------------------------
DROP TABLE IF EXISTS `t_color_region_dtl`;
CREATE TABLE `t_color_region_dtl`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `color_region_id` bigint(20) NULL DEFAULT NULL COMMENT '此色块所属色区ID',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '色块名称 如:A ， B ，C，只针对色块类型色区，色容差类型色区该字段为空',
  `xrow` int(11) NULL DEFAULT NULL COMMENT '此色块所在行数，只针对色块类型色区，色容差类型色区该字段为空',
  `xcolumn` int(11) NULL DEFAULT NULL COMMENT '此色块所在列数，只针对色块类型色区，色容差类型色区该字段为空',
  `shape` tinyint(4) NULL DEFAULT NULL COMMENT '色区形状 0 椭圆 1四边 只针对色容差色区，色块类型类型色区该字段为空',
  `x1` double NULL DEFAULT NULL COMMENT '左上坐标 x1',
  `y1` double NULL DEFAULT NULL COMMENT '左上坐标 y1',
  `x2` double NULL DEFAULT NULL COMMENT '右上坐标 x2',
  `y2` double NULL DEFAULT NULL COMMENT '右上坐标 y2',
  `x3` double NULL DEFAULT NULL COMMENT '右下坐标 x3',
  `y3` double NULL DEFAULT NULL COMMENT '右下坐标 y3',
  `x4` double NULL DEFAULT NULL COMMENT '左下坐标 x4',
  `y4` double NULL DEFAULT NULL COMMENT '左下坐标 y4',
  `a` double NULL DEFAULT NULL COMMENT '椭圆长轴',
  `b` double NULL DEFAULT NULL COMMENT '椭圆短轴 x',
  `x` double NULL DEFAULT NULL COMMENT '椭圆中心点 x',
  `y` double NULL DEFAULT NULL COMMENT '椭圆中心点 y',
  `angle` double NULL DEFAULT NULL COMMENT '椭圆倾斜角度',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false、true 删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_color_region_id`(`color_region_id`) USING BTREE,
  CONSTRAINT `fk_color_region_id` FOREIGN KEY (`color_region_id`) REFERENCES `t_color_region` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '常规色区-四边形色区' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_diffusion_powder
-- ----------------------------
DROP TABLE IF EXISTS `t_diffusion_powder`;
CREATE TABLE `t_diffusion_powder`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `diffusion_powder_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩散粉编码',
  `diffusion_powder_spec` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩散粉规格',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `density` double NOT NULL COMMENT '密度',
  `add_proportion` double NULL DEFAULT NULL COMMENT '添加比例',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false 正常、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '扩散粉' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_eqpt
-- ----------------------------
DROP TABLE IF EXISTS `t_eqpt`;
CREATE TABLE `t_eqpt`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `eqpt_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备编码',
  `positon` int(11) NOT NULL COMMENT '设备位置编号',
  `group_id` bigint(20) NOT NULL COMMENT '组织架构ID',
  `pinhead_num` int(11) NULL DEFAULT NULL COMMENT '针头数量',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  `assets_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '资产编码',
  `type` tinyint(4) NOT NULL COMMENT '设备类型,0 点胶设备',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_eqpt_valve
-- ----------------------------
DROP TABLE IF EXISTS `t_eqpt_valve`;
CREATE TABLE `t_eqpt_valve`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `eqpt_id` int(11) NOT NULL COMMENT '设备id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '阀体名称',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备阀体表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_eqpt_valve_state_df
-- ----------------------------
DROP TABLE IF EXISTS `t_eqpt_valve_state_df`;
CREATE TABLE `t_eqpt_valve_state_df`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `state_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备阀体状体',
  `state_flag` tinyint(4) NOT NULL COMMENT '状态编号',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '阀体设备状态定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_eqpt_valve_state_df
-- ----------------------------
INSERT INTO `t_eqpt_valve_state_df` VALUES (1, '待生产', 1, '2020-04-14 15:27:59');
INSERT INTO `t_eqpt_valve_state_df` VALUES (2, '生产中', 2, '2020-04-14 15:27:59');
INSERT INTO `t_eqpt_valve_state_df` VALUES (3, '阀体NG', 3, '2020-04-14 15:27:59');
INSERT INTO `t_eqpt_valve_state_df` VALUES (4, '已关闭', 4, '2020-04-14 15:27:59');

-- ----------------------------
-- Table structure for t_feed_exception_reason
-- ----------------------------
DROP TABLE IF EXISTS `t_feed_exception_reason`;
CREATE TABLE `t_feed_exception_reason`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `reason` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `flag` tinyint(4) NOT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '同步创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '投单异常原因定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_feed_exception_reason
-- ----------------------------
INSERT INTO `t_feed_exception_reason` VALUES (1, '无芯片', 1, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (2, '无支架', 2, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (3, '无荧光粉', 3, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (4, '胶水规格不足两种', 4, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (5, '芯片超过一种', 5, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (6, '支架超过一种', 6, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (7, '荧光粉超过四种', 7, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (8, '抗沉淀粉超过一种', 8, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (9, '扩散粉超过一种', 9, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (10, '抗沉淀粉与扩散粉同时存在', 10, '2020-04-14 15:27:59');
INSERT INTO `t_feed_exception_reason` VALUES (11, '胶水规格超过两种', 11, '2020-04-14 15:27:59');

-- ----------------------------
-- Table structure for t_glue
-- ----------------------------
DROP TABLE IF EXISTS `t_glue`;
CREATE TABLE `t_glue`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ratio_a` double NOT NULL COMMENT '固定比例a',
  `ratio_b` double NOT NULL COMMENT '固定比例b',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false 正常、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '胶水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_glue_dtl
-- ----------------------------
DROP TABLE IF EXISTS `t_glue_dtl`;
CREATE TABLE `t_glue_dtl`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `glue_id` bigint(20) NOT NULL COMMENT '外键关联胶水表主键',
  `glue_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '胶水类型 A胶或B胶',
  `glue_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '胶水编码',
  `glue_spec` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '胶水规格',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `viscosity_max` double NULL DEFAULT NULL COMMENT '粘度最大值',
  `viscosity_min` double NULL DEFAULT NULL COMMENT '粘度最小值',
  `hardness_max` double NULL DEFAULT NULL COMMENT '硬度最大值',
  `hardness_min` double NULL DEFAULT NULL COMMENT '硬度最小值',
  `density` double NOT NULL COMMENT '密度',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_glue_id`(`glue_id`) USING BTREE,
  CONSTRAINT `fk_glue_id` FOREIGN KEY (`glue_id`) REFERENCES `t_glue` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '胶水详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_group
-- ----------------------------
DROP TABLE IF EXISTS `t_group`;
CREATE TABLE `t_group`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父ID',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `map_eas_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联至eas组织结构id',
  `parent_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '父级路径',
  `level` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组织级别,建议创建一张表，关联相关id',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '组织结构' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_group
-- ----------------------------
INSERT INTO `t_group` VALUES (1, 0, NULL, '木林森股份', NULL, '0', '0', 0, '2020-04-14 15:27:59');
INSERT INTO `t_group` VALUES (2, 1, NULL, '中山木林森电子', NULL, '0,1', '1', 0, '2020-04-14 15:27:59');
INSERT INTO `t_group` VALUES (3, 2, NULL, '照明器件', NULL, '0,1,2', '2', 0, '2020-04-14 15:27:59');
INSERT INTO `t_group` VALUES (4, 3, NULL, '五厂一部', '01.19.20.01.02.061', '0,1,2,3', '3', 0, '2020-04-14 15:27:59');

-- ----------------------------
-- Table structure for t_model_bom
-- ----------------------------
DROP TABLE IF EXISTS `t_model_bom`;
CREATE TABLE `t_model_bom`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `model_id` bigint(20) NOT NULL COMMENT '模型id',
  `bom_id` bigint(20) NOT NULL COMMENT 'bom id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ai_model_bom_id`(`bom_id`) USING BTREE,
  INDEX `fk_ai_bom_model_id`(`model_id`) USING BTREE,
  CONSTRAINT `fk_ai_bom_model_id` FOREIGN KEY (`model_id`) REFERENCES `t_ai_model` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_model_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `t_bom` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '模型与bom的关系, 单层工艺以一对一，双层工艺一对二' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_model_bom_chip_wl_rank
-- ----------------------------
DROP TABLE IF EXISTS `t_model_bom_chip_wl_rank`;
CREATE TABLE `t_model_bom_chip_wl_rank`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chip_wl_rank_id` bigint(20) NOT NULL COMMENT '芯片波段ID',
  `model_bom_id` bigint(20) NOT NULL COMMENT 't_model_bom 表的ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产搭配对应的芯片波段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_model_formula
-- ----------------------------
DROP TABLE IF EXISTS `t_model_formula`;
CREATE TABLE `t_model_formula`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `model_bom_id` bigint(20) NOT NULL COMMENT '配方id',
  `material_id` bigint(20) NOT NULL COMMENT 'a胶，b胶，荧光粉、抗成淀粉、扩散粉 a胶和b胶对应的胶水详情表',
  `ratio` double NOT NULL COMMENT '比值',
  `material_class` tinyint(4) NOT NULL COMMENT '物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉，4 扩散粉',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_formula_id`(`model_bom_id`) USING BTREE,
  CONSTRAINT `fk_formula_id` FOREIGN KEY (`model_bom_id`) REFERENCES `t_model_bom` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配比详细信息（配比库）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_none_bake_test_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_none_bake_test_rule`;
CREATE TABLE `t_none_bake_test_rule`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rule_kind` tinyint(4) NOT NULL COMMENT '规则类型， 0 椭圆,1 四边形,2 中心点,3 等于出货要求中心点，该中心点在在新建机种时，以调用算法算出来',
  `a` double NULL DEFAULT NULL COMMENT '椭圆长轴',
  `b` double NULL DEFAULT NULL COMMENT '椭圆短轴',
  `x` double NULL DEFAULT NULL COMMENT '椭圆中心点x',
  `y` double NULL DEFAULT NULL COMMENT '椭圆中心点y',
  `angle` double NULL DEFAULT NULL COMMENT '椭圆倾角',
  `x1` double NULL DEFAULT NULL COMMENT '左上-坐标 x1',
  `y1` double NULL DEFAULT NULL COMMENT '左上-坐标 y1',
  `x2` double NULL DEFAULT NULL COMMENT '右上-坐标 x2',
  `y2` double NULL DEFAULT NULL COMMENT '右上-坐标 y2',
  `x3` double NULL DEFAULT NULL COMMENT '右下-坐标 x3',
  `y3` double NULL DEFAULT NULL COMMENT '右下下-坐标 y3',
  `x4` double NULL DEFAULT NULL COMMENT '左下-坐标 x4',
  `y4` double NULL DEFAULT NULL COMMENT '左下-坐标 y4',
  `cp_x` double NULL DEFAULT NULL COMMENT '中心点x',
  `cp_y` double NULL DEFAULT NULL COMMENT '中心点x',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求对应的非正常烤规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_output_require_before_test_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_output_require_before_test_rule`;
CREATE TABLE `t_output_require_before_test_rule`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `before_test_rule_id` bigint(20) NOT NULL COMMENT '前测规则id',
  `output_require_id` bigint(20) NOT NULL COMMENT '出货要求id',
  `rule_type` tinyint(4) NULL DEFAULT NULL COMMENT '规则类型 0 对应单层工艺，2 对应多层工艺上层 1 对应多层工艺下层',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false、true 删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_output_requirements_before_test_rule_id`(`before_test_rule_id`) USING BTREE,
  INDEX `fk_before_test_rule_output_requirements_id`(`output_require_id`) USING BTREE,
  CONSTRAINT `fk_before_test_rule_output_requirements_id` FOREIGN KEY (`output_require_id`) REFERENCES `t_output_requirements` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_output_requirements_before_test_rule_id` FOREIGN KEY (`before_test_rule_id`) REFERENCES `t_before_test_rule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求与前测规则对应关系,单层工艺对应一条前测规则，双层工艺对应两条前测规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_output_require_nbake_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_output_require_nbake_rule`;
CREATE TABLE `t_output_require_nbake_rule`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `none_bake_rule_id` bigint(20) NOT NULL COMMENT '非正常烤规则id',
  `output_require_id` bigint(20) NOT NULL COMMENT '出货要求id',
  `rule_type` tinyint(4) NULL DEFAULT 0 COMMENT '规则类型 0 对应单层工艺，2 对应多层工艺上层 1 对应多层工艺下层',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false、true 删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_output_requirements_nbake_rule_id`(`none_bake_rule_id`) USING BTREE,
  INDEX `fk_nbake_rule_output_requirements_id`(`output_require_id`) USING BTREE,
  CONSTRAINT `fk_nbake_rule_output_requirements_id` FOREIGN KEY (`output_require_id`) REFERENCES `t_output_requirements` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_output_requirements_nbake_rule_id` FOREIGN KEY (`none_bake_rule_id`) REFERENCES `t_none_bake_test_rule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求与非正常烤规则对应关系，单层工艺对应一条前测规则，双层工艺对应两条前测规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_output_requirements
-- ----------------------------
DROP TABLE IF EXISTS `t_output_requirements`;
CREATE TABLE `t_output_requirements`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '出货要求编码',
  `type_machine_id` bigint(20) NOT NULL COMMENT '机种id',
  `output_kind` tinyint(4) NOT NULL COMMENT '出货要求类型 0 色容差类型，1 出货比例类型，2 中心点类型。其中对于同一机种色容差类型出货要求，共用一组前测规则和非正常烤规则，非色容差出货要求，每种出货要求对应一组前测和非正常烤规则',
  `is_temp` tinyint(1) NOT NULL COMMENT '是否时临时出货要求 true 临时 false 正常',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_require_type_machime_id`(`type_machine_id`) USING BTREE,
  CONSTRAINT `fk_require_type_machime_id` FOREIGN KEY (`type_machine_id`) REFERENCES `t_type_machine` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种对应的出货需求,一个机种对应多个出货要求' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_output_requirements_dtl
-- ----------------------------
DROP TABLE IF EXISTS `t_output_requirements_dtl`;
CREATE TABLE `t_output_requirements_dtl`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `output_require_id` bigint(20) NOT NULL COMMENT '出货要求id',
  `cp_x` double NULL DEFAULT NULL COMMENT '中心点x, 对应与output_kind为1，2，1为调用算法计算，2为用户输入',
  `cp_y` double NULL DEFAULT NULL COMMENT '中心点y, 对应与output_kind为1，2，1为调用算法计算，2为用户输入',
  `ratio_type` double NULL DEFAULT NULL COMMENT '类型，0 等于 、1 小于、 2 小于等于、 3大于、 4 大于等于，对应与output_kind为1时',
  `ratio_value` double NULL DEFAULT NULL COMMENT '比值 对应与output_kind为1时',
  `color_region_dtl_id` bigint(20) NULL DEFAULT NULL COMMENT ' 关联t_color_region_dtl 的id',
  `color_region_id` bigint(20) NULL DEFAULT NULL COMMENT '色区表ID主要用于色块中心点类型',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_output_require_dtl_id`(`output_require_id`) USING BTREE,
  CONSTRAINT `fk_output_require_dtl_id` FOREIGN KEY (`output_require_id`) REFERENCES `t_output_requirements` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_phosphor
-- ----------------------------
DROP TABLE IF EXISTS `t_phosphor`;
CREATE TABLE `t_phosphor`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `phosphor_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '荧光粉编码',
  `phosphor_spec` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '荧光粉规格',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `cold_heat_ratio` double NULL DEFAULT NULL COMMENT '冷热比',
  `particle_diameter10` double NULL DEFAULT NULL COMMENT '粒径10',
  `particle_diameter50` double NULL DEFAULT NULL COMMENT '粒径50',
  `particle_diameter90` double NULL DEFAULT NULL COMMENT '粒径90',
  `peak_wavelength` double NOT NULL COMMENT '峰值波长',
  `density` double NOT NULL COMMENT '密度',
  `cie_x` double NULL DEFAULT NULL COMMENT '色坐标_x',
  `cie_y` double NULL DEFAULT NULL COMMENT '色坐标_y',
  `fwhm` double NULL DEFAULT NULL COMMENT '半高宽',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false 正常、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  `phosphor_type_id` bigint(20) NOT NULL COMMENT '荧光粉类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '荧光粉' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_phosphor_type
-- ----------------------------
DROP TABLE IF EXISTS `t_phosphor_type`;
CREATE TABLE `t_phosphor_type`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '荧光粉类型名称',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false 正常、true 删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '荧光粉类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_privilege
-- ----------------------------
DROP TABLE IF EXISTS `t_privilege`;
CREATE TABLE `t_privilege`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '功能模块名称，页面名称，导航名称',
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父菜单Id',
  `router` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '路由名称',
  `router_path` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '路由路径',
  `kind` tinyint(4) NOT NULL DEFAULT 0 COMMENT '标识该权限是否为按钮级别，1 按钮级别 0 菜单级别',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_privilege
-- ----------------------------
INSERT INTO `t_privilege` VALUES (1, '在制生产管理', 0, 'productionManage', '', 0);
INSERT INTO `t_privilege` VALUES (2, 'EAS工单管理', 1, 'easManage', '', 0);
INSERT INTO `t_privilege` VALUES (3, '在制工单管理', 1, 'productionManage', '', 0);
INSERT INTO `t_privilege` VALUES (4, '在制详情', 3, 'productionManageInfo', '', 0);
INSERT INTO `t_privilege` VALUES (5, '在制记录', 3, 'productionManageLog', '', 0);
INSERT INTO `t_privilege` VALUES (6, '在线监控', 0, 'monitor', '', 0);
INSERT INTO `t_privilege` VALUES (7, '品质测试', 6, 'test', '', 0);
INSERT INTO `t_privilege` VALUES (8, '在制详情', 7, 'testInfo', '', 0);
INSERT INTO `t_privilege` VALUES (9, '在制记录', 7, 'testLog', '', 0);
INSERT INTO `t_privilege` VALUES (10, '基础数据库', 0, 'baseDataSource', '', 0);
INSERT INTO `t_privilege` VALUES (11, '点胶设备库', 10, 'glueEquit', '', 0);
INSERT INTO `t_privilege` VALUES (12, '原材料库', 10, 'rawMaterial', '', 0);
INSERT INTO `t_privilege` VALUES (13, '机种库', 10, 'machineType', '', 0);
INSERT INTO `t_privilege` VALUES (14, '色区库', 10, 'colorArea', '', 0);
INSERT INTO `t_privilege` VALUES (15, '配比库', 10, 'mixtureRatio', '', 0);
INSERT INTO `t_privilege` VALUES (16, '查看详情', 15, 'mixtureRatioDetail', '', 0);
INSERT INTO `t_privilege` VALUES (17, '测试规则库', 10, 'testRule', '', 0);
INSERT INTO `t_privilege` VALUES (18, '后台管理', 0, 'backgroundManage', '', 0);
INSERT INTO `t_privilege` VALUES (19, '组织结构管理', 18, 'groupManage', '', 0);
INSERT INTO `t_privilege` VALUES (20, '角色管理', 18, 'ruleManage', '', 0);
INSERT INTO `t_privilege` VALUES (21, '用户管理', 18, 'userManage', '', 0);
INSERT INTO `t_privilege` VALUES (22, '生产车间编码', 18, 'productManage', '', 0);
INSERT INTO `t_privilege` VALUES (23, '材料类型编码', 18, 'materialManage', '', 0);
INSERT INTO `t_privilege` VALUES (24, '一键同步', 2, 'synch', '', 1);
INSERT INTO `t_privilege` VALUES (25, '投产', 2, 'putInto', '', 1);
INSERT INTO `t_privilege` VALUES (26, '关闭工单', 3, 'close', '', 1);
INSERT INTO `t_privilege` VALUES (27, '查看在制详情', 3, 'info', '', 1);
INSERT INTO `t_privilege` VALUES (28, '查看在制记录', 3, 'log', '', 1);
INSERT INTO `t_privilege` VALUES (29, '开始试样', 4, 'start', '', 1);
INSERT INTO `t_privilege` VALUES (30, '试样通过', 4, 'success', '', 1);
INSERT INTO `t_privilege` VALUES (31, '修改配方', 4, 'edits', '', 1);
INSERT INTO `t_privilege` VALUES (32, '修改配比', 4, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (33, '在制设备管理', 4, 'manage', '', 1);
INSERT INTO `t_privilege` VALUES (34, '在制详情', 7, 'info', '', 1);
INSERT INTO `t_privilege` VALUES (35, '在制记录', 7, 'log', '', 1);
INSERT INTO `t_privilege` VALUES (36, '上传测试结果', 8, 'upload', '', 1);
INSERT INTO `t_privilege` VALUES (37, '取消NG判定', 8, 'cancle', '', 1);
INSERT INTO `t_privilege` VALUES (38, '测试结果判定', 8, 'result', '', 1);
INSERT INTO `t_privilege` VALUES (39, '新增', 11, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (40, '编辑', 11, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (41, '删除', 11, 'delete', '', 1);
INSERT INTO `t_privilege` VALUES (42, '新增', 12, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (43, '编辑', 12, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (44, '删除', 12, 'delete', '', 1);
INSERT INTO `t_privilege` VALUES (45, '新增', 13, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (46, '编辑', 13, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (47, '删除', 13, 'delete', '', 1);
INSERT INTO `t_privilege` VALUES (48, '新增', 14, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (49, '删除', 14, 'delete', '', 1);
INSERT INTO `t_privilege` VALUES (50, '查看详情', 15, 'searchInfo', '', 1);
INSERT INTO `t_privilege` VALUES (51, '生产搭配管理', 16, 'collocationManage', '', 1);
INSERT INTO `t_privilege` VALUES (52, '编辑配比', 16, 'editMixture', '', 1);
INSERT INTO `t_privilege` VALUES (53, '编辑', 17, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (54, '新增', 19, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (55, '删除', 19, 'delete', '', 1);
INSERT INTO `t_privilege` VALUES (56, '新增', 20, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (57, '编辑', 20, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (58, '删除', 20, 'delete', '', 1);
INSERT INTO `t_privilege` VALUES (59, '新增', 21, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (60, '编辑', 21, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (61, '删除', 21, 'delete', '', 1);
INSERT INTO `t_privilege` VALUES (62, '修改', 21, 'editpwd', '', 1);
INSERT INTO `t_privilege` VALUES (63, '新增', 22, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (64, '编辑', 22, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (65, '新增', 23, 'add', '', 1);
INSERT INTO `t_privilege` VALUES (66, '编辑', 23, 'edit', '', 1);
INSERT INTO `t_privilege` VALUES (67, '修改胶量', 4, 'editdjcs', '', 1);
INSERT INTO `t_privilege` VALUES (68, '查看', 2, 'ckxq', '', 1);
INSERT INTO `t_privilege` VALUES (69, '上传测试结果', 4, 'cccsjg', '', 1);
INSERT INTO `t_privilege` VALUES (70, '取消NG判定', 4, 'qxngpd', '', 1);
INSERT INTO `t_privilege` VALUES (71, '测试结果判定', 4, 'csjgpd', '', 1);
INSERT INTO `t_privilege` VALUES (72, '荧光粉分类', 12, 'ygffl', '', 1);
INSERT INTO `t_privilege` VALUES (73, 'BOM组合设置', 13, 'bomzhsz', '', 1);

-- ----------------------------
-- Table structure for t_role
-- ----------------------------
DROP TABLE IF EXISTS `t_role`;
CREATE TABLE `t_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) NOT NULL COMMENT '组织id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_role_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `fk_role_group_id` FOREIGN KEY (`group_id`) REFERENCES `t_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_role
-- ----------------------------
INSERT INTO `t_role` VALUES (1, 1, '1231', '123', 0, '2019-11-14 18:52:11');

-- ----------------------------
-- Table structure for t_role_privilege
-- ----------------------------
DROP TABLE IF EXISTS `t_role_privilege`;
CREATE TABLE `t_role_privilege`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) NOT NULL,
  `privilege_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_role_privilege_id`(`role_id`) USING BTREE,
  INDEX `fk_privilege_role_id`(`privilege_id`) USING BTREE,
  CONSTRAINT `fk_privilege_role_id` FOREIGN KEY (`privilege_id`) REFERENCES `t_privilege` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_role_privilege_id` FOREIGN KEY (`role_id`) REFERENCES `t_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_role_privilege
-- ----------------------------
INSERT INTO `t_role_privilege` VALUES (1, 1, 1);
INSERT INTO `t_role_privilege` VALUES (2, 1, 2);
INSERT INTO `t_role_privilege` VALUES (3, 1, 3);
INSERT INTO `t_role_privilege` VALUES (4, 1, 4);
INSERT INTO `t_role_privilege` VALUES (5, 1, 5);
INSERT INTO `t_role_privilege` VALUES (6, 1, 6);
INSERT INTO `t_role_privilege` VALUES (7, 1, 7);
INSERT INTO `t_role_privilege` VALUES (8, 1, 8);
INSERT INTO `t_role_privilege` VALUES (9, 1, 9);
INSERT INTO `t_role_privilege` VALUES (10, 1, 10);
INSERT INTO `t_role_privilege` VALUES (11, 1, 11);
INSERT INTO `t_role_privilege` VALUES (12, 1, 12);
INSERT INTO `t_role_privilege` VALUES (13, 1, 13);
INSERT INTO `t_role_privilege` VALUES (14, 1, 14);
INSERT INTO `t_role_privilege` VALUES (15, 1, 15);
INSERT INTO `t_role_privilege` VALUES (16, 1, 16);
INSERT INTO `t_role_privilege` VALUES (17, 1, 17);
INSERT INTO `t_role_privilege` VALUES (18, 1, 18);
INSERT INTO `t_role_privilege` VALUES (19, 1, 19);
INSERT INTO `t_role_privilege` VALUES (20, 1, 20);
INSERT INTO `t_role_privilege` VALUES (21, 1, 21);
INSERT INTO `t_role_privilege` VALUES (22, 1, 22);
INSERT INTO `t_role_privilege` VALUES (23, 1, 23);
INSERT INTO `t_role_privilege` VALUES (24, 1, 24);
INSERT INTO `t_role_privilege` VALUES (25, 1, 25);
INSERT INTO `t_role_privilege` VALUES (26, 1, 26);
INSERT INTO `t_role_privilege` VALUES (27, 1, 27);
INSERT INTO `t_role_privilege` VALUES (28, 1, 28);
INSERT INTO `t_role_privilege` VALUES (29, 1, 29);
INSERT INTO `t_role_privilege` VALUES (30, 1, 30);
INSERT INTO `t_role_privilege` VALUES (31, 1, 31);
INSERT INTO `t_role_privilege` VALUES (32, 1, 32);
INSERT INTO `t_role_privilege` VALUES (33, 1, 33);
INSERT INTO `t_role_privilege` VALUES (34, 1, 34);
INSERT INTO `t_role_privilege` VALUES (35, 1, 35);
INSERT INTO `t_role_privilege` VALUES (36, 1, 36);
INSERT INTO `t_role_privilege` VALUES (37, 1, 37);
INSERT INTO `t_role_privilege` VALUES (38, 1, 38);
INSERT INTO `t_role_privilege` VALUES (39, 1, 39);
INSERT INTO `t_role_privilege` VALUES (40, 1, 40);
INSERT INTO `t_role_privilege` VALUES (41, 1, 41);
INSERT INTO `t_role_privilege` VALUES (42, 1, 42);
INSERT INTO `t_role_privilege` VALUES (43, 1, 43);
INSERT INTO `t_role_privilege` VALUES (44, 1, 44);
INSERT INTO `t_role_privilege` VALUES (45, 1, 45);
INSERT INTO `t_role_privilege` VALUES (46, 1, 46);
INSERT INTO `t_role_privilege` VALUES (47, 1, 47);
INSERT INTO `t_role_privilege` VALUES (48, 1, 48);
INSERT INTO `t_role_privilege` VALUES (49, 1, 49);
INSERT INTO `t_role_privilege` VALUES (50, 1, 50);
INSERT INTO `t_role_privilege` VALUES (51, 1, 51);
INSERT INTO `t_role_privilege` VALUES (52, 1, 52);
INSERT INTO `t_role_privilege` VALUES (53, 1, 53);
INSERT INTO `t_role_privilege` VALUES (54, 1, 54);
INSERT INTO `t_role_privilege` VALUES (55, 1, 55);
INSERT INTO `t_role_privilege` VALUES (56, 1, 56);
INSERT INTO `t_role_privilege` VALUES (57, 1, 57);
INSERT INTO `t_role_privilege` VALUES (58, 1, 58);
INSERT INTO `t_role_privilege` VALUES (59, 1, 59);
INSERT INTO `t_role_privilege` VALUES (60, 1, 60);
INSERT INTO `t_role_privilege` VALUES (61, 1, 61);
INSERT INTO `t_role_privilege` VALUES (62, 1, 62);
INSERT INTO `t_role_privilege` VALUES (63, 1, 63);
INSERT INTO `t_role_privilege` VALUES (64, 1, 64);
INSERT INTO `t_role_privilege` VALUES (65, 1, 65);
INSERT INTO `t_role_privilege` VALUES (66, 1, 66);

-- ----------------------------
-- Table structure for t_scaffold
-- ----------------------------
DROP TABLE IF EXISTS `t_scaffold`;
CREATE TABLE `t_scaffold`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `scaffold_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支架编码',
  `scaffold_spec` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支架规格',
  `supplier` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `family` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品系列',
  `is_circular` tinyint(4) NULL DEFAULT 0 COMMENT '0圆台1棱台。棱台默认使用1-5到 分别是底宽、底长、顶长、顶宽、和高；圆台使用1-3，分别是底部直径，顶部直径，高度',
  `param1` double NULL DEFAULT NULL COMMENT '棱台底宽/底部直径',
  `param2` double NULL DEFAULT NULL COMMENT '棱台底长/顶部直径',
  `param3` double NULL DEFAULT NULL COMMENT '棱台顶长/圆台高度',
  `param4` double NULL DEFAULT NULL COMMENT '棱台顶宽',
  `param5` double NULL DEFAULT NULL COMMENT '棱台高',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false 正常、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '支架' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_spc_base_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_spc_base_rule`;
CREATE TABLE `t_spc_base_rule`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rule_no` int(11) NOT NULL COMMENT '规则编号',
  `rule_template` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '规则模板',
  `m` int(11) NULL DEFAULT NULL,
  `n` int(11) NULL DEFAULT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'SPC预警规则(模板)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_spc_base_rule
-- ----------------------------
INSERT INTO `t_spc_base_rule` VALUES (1, 1, '控制图上有%m个点位于控制线以外', 1, NULL, '2020-04-14 15:27:59');
INSERT INTO `t_spc_base_rule` VALUES (2, 2, '连续%m点落在中心线的同一侧', 9, NULL, '2020-04-14 15:27:59');
INSERT INTO `t_spc_base_rule` VALUES (3, 3, '连续%m点递增或递减', 6, NULL, '2020-04-14 15:27:59');
INSERT INTO `t_spc_base_rule` VALUES (4, 4, '连续%m点中相邻点交替上下', 14, NULL, '2020-04-14 15:27:59');
INSERT INTO `t_spc_base_rule` VALUES (5, 5, '连续%m点中有%m点落在中心线同一侧的B区以外', 3, 3, '2020-04-14 15:27:59');
INSERT INTO `t_spc_base_rule` VALUES (6, 6, '连续%m点中有%m点落在中心线同一侧的C区之外', 5, 4, '2020-04-14 15:27:59');
INSERT INTO `t_spc_base_rule` VALUES (7, 7, '连续%m点落在C区之内', 15, NULL, '2020-04-14 15:27:59');
INSERT INTO `t_spc_base_rule` VALUES (8, 8, '连续%m点落在中心线两侧，但无%m点在C区之内', 8, 1, '2020-04-14 15:27:59');

-- ----------------------------
-- Table structure for t_spc_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_spc_rule`;
CREATE TABLE `t_spc_rule`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_machine_id` bigint(20) NOT NULL COMMENT '机种ID',
  `qc_point` tinyint(4) NOT NULL COMMENT '质控点 0 落bin率 1 △x和△y',
  `ucl` double NULL DEFAULT NULL COMMENT '控制上线,只针对良率',
  `lcl` double NULL DEFAULT NULL COMMENT '控制下线,只针对良率',
  `delta_x_ucl` double NULL DEFAULT NULL COMMENT '控制上线,只针对距离，x',
  `delta_x_lcl` double NULL DEFAULT NULL COMMENT '控制下线,只针对距离，x',
  `delta_y_ucl` double NULL DEFAULT NULL COMMENT '控制上线,只针对距离，y',
  `delta_y_lcl` double NULL DEFAULT NULL COMMENT '控制下线,只针对距离，y',
  `cl_optional` tinyint(4) NOT NULL DEFAULT 1 COMMENT '控制限设定方式 0 理论计算，1人工设定',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_qc_rule_id`(`type_machine_id`) USING BTREE,
  CONSTRAINT `fk_qc_rule_id` FOREIGN KEY (`type_machine_id`) REFERENCES `t_type_machine` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '每一个机种对应对应的spc规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_spc_rule_dtl
-- ----------------------------
DROP TABLE IF EXISTS `t_spc_rule_dtl`;
CREATE TABLE `t_spc_rule_dtl`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `qc_rule_id` bigint(20) NOT NULL COMMENT '质控规则',
  `base_rule_id` bigint(20) NOT NULL COMMENT '预警规则ID',
  `m` int(11) NULL DEFAULT NULL,
  `n` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_spc_rule_id`(`qc_rule_id`) USING BTREE,
  INDEX `fk_spc_base_rule_id`(`base_rule_id`) USING BTREE,
  CONSTRAINT `fk_spc_base_rule_id` FOREIGN KEY (`base_rule_id`) REFERENCES `t_spc_base_rule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_spc_rule_id` FOREIGN KEY (`qc_rule_id`) REFERENCES `t_spc_rule` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '每一个机种对应对应的spc规则详细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_task_state_df
-- ----------------------------
DROP TABLE IF EXISTS `t_task_state_df`;
CREATE TABLE `t_task_state_df`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `state_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态内容',
  `state_flag` tinyint(4) NOT NULL COMMENT '状态编号',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务单状态定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_task_state_df
-- ----------------------------
INSERT INTO `t_task_state_df` VALUES (1, '待生产', 1, '2020-04-14 15:27:59');
INSERT INTO `t_task_state_df` VALUES (2, '试样前测中', 2, '2020-04-14 15:27:59');
INSERT INTO `t_task_state_df` VALUES (3, '试样前测NG', 3, '2020-04-14 15:27:59');
INSERT INTO `t_task_state_df` VALUES (4, '试样前测通过', 4, '2020-04-14 15:27:59');
INSERT INTO `t_task_state_df` VALUES (5, '试样品质测试NG', 5, '2020-04-14 15:27:59');
INSERT INTO `t_task_state_df` VALUES (6, '批量生产', 6, '2020-04-14 15:27:59');
INSERT INTO `t_task_state_df` VALUES (7, '批量生产中有阀体NG', 7, '2020-04-14 15:27:59');
INSERT INTO `t_task_state_df` VALUES (8, '工单关闭', 8, '2020-04-14 15:27:59');

-- ----------------------------
-- Table structure for t_type_machine
-- ----------------------------
DROP TABLE IF EXISTS `t_type_machine`;
CREATE TABLE `t_type_machine`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '机种编码',
  `spec` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '机种规格',
  `ra_target` double NULL DEFAULT NULL COMMENT '显色指数,目标值/ra系列',
  `ra_max` double NULL DEFAULT NULL COMMENT '限制范围上限，用于算法显指良率统计',
  `ra_min` double NULL DEFAULT NULL COMMENT '显色指数下限，用于算法显指良率统计',
  `r9` double NULL DEFAULT NULL COMMENT 'R9',
  `ct` int(11) NULL DEFAULT NULL COMMENT '色温(k)',
  `lumen_lsl` double NULL DEFAULT NULL COMMENT '流明下限',
  `lumen_usl` double NULL DEFAULT NULL COMMENT '流明上限',
  `wl_lsl` double NULL DEFAULT NULL COMMENT '波长下限',
  `wl_usl` double NULL DEFAULT NULL COMMENT '波长上限',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `process_type` tinyint(4) NOT NULL COMMENT '工艺类型，0单层工艺 1双层工艺',
  `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `crystal_number` int(11) NULL DEFAULT NULL COMMENT '晶体数量/芯片数量',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_type_machine_default_chip
-- ----------------------------
DROP TABLE IF EXISTS `t_type_machine_default_chip`;
CREATE TABLE `t_type_machine_default_chip`  (
  `t_type_machine_id` bigint(20) NULL DEFAULT NULL COMMENT '机种id',
  `chip_id` bigint(20) NULL DEFAULT NULL COMMENT '默认的芯片ID'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种默认的芯片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_type_machine_default_other_material
-- ----------------------------
DROP TABLE IF EXISTS `t_type_machine_default_other_material`;
CREATE TABLE `t_type_machine_default_other_material`  (
  `t_type_machine_id` bigint(20) NULL DEFAULT NULL COMMENT '机种id',
  `limit_phosphor_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '限制使用的荧光粉类型',
  `default_scaffold_id` bigint(20) NULL DEFAULT NULL COMMENT '默认支架',
  `default_glue_id` bigint(20) NULL DEFAULT NULL COMMENT '默认胶水',
  `default_diffusion_powder_id` bigint(20) NULL DEFAULT NULL COMMENT '默认的扩散粉',
  `default_anti_starch_id` bigint(20) NULL DEFAULT NULL COMMENT '默认抗沉淀粉'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '默认的物料' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_type_machine_gule_high
-- ----------------------------
DROP TABLE IF EXISTS `t_type_machine_gule_high`;
CREATE TABLE `t_type_machine_gule_high`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_machine_id` bigint(20) NOT NULL COMMENT '机种id',
  `gule_hight_usl` double NOT NULL COMMENT '胶体高度上限',
  `gule_hight_lsl` double NOT NULL COMMENT '胶体高度下限',
  `process_type` tinyint(4) NOT NULL COMMENT '胶体高度类型，0 用于单层工艺，1用于双从工艺',
  `layer` tinyint(4) NULL DEFAULT NULL COMMENT '层次,null 为单层，0 整体胶高 1 底层胶高',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_type_machine_gule_high_id`(`type_machine_id`) USING BTREE,
  CONSTRAINT `fk_type_machine_gule_high_id` FOREIGN KEY (`type_machine_id`) REFERENCES `t_type_machine` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种点胶高度' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) NOT NULL COMMENT '组织id',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `account` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '账户',
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用 false 不禁用 true 禁用',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false正常、true 删除',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `fk_user_group_id` FOREIGN KEY (`group_id`) REFERENCES `t_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (1, 1, 'admin', 'admin', '4297f44b13955235245b2497399d7a93', 0, 0, '2019-11-17 16:53:49');

-- ----------------------------
-- Table structure for t_user_role
-- ----------------------------
DROP TABLE IF EXISTS `t_user_role`;
CREATE TABLE `t_user_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_id`(`user_id`) USING BTREE,
  INDEX `fk_role_id`(`role_id`) USING BTREE,
  CONSTRAINT `fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `t_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user_role
-- ----------------------------
INSERT INTO `t_user_role` VALUES (1, 1, 1);

-- ----------------------------
-- View structure for t_model_task_id_dtl
-- ----------------------------
DROP VIEW IF EXISTS `t_model_task_id_dtl`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `t_model_task_id_dtl` AS select `bs_task_state`.`model_id` AS `model_id`,`bs_task_state`.`task_id` AS `task_id`,`bs_task_state`.`id` AS `task_state_id`,`bs_task_state`.`create_time` AS `task_state_id_create_time`,`bs_task`.`create_time` AS `task_id_create_time`,`bs_task_state`.`task_df_id` AS `task_df_id`,`d_upload_file`.`id` AS `file_id`,`d_upload_file`.`create_time` AS `file_id_create_time`,`d_upload_file`.`classType` AS `classType`,`d_file_summary`.`euclidean_distance_x` AS `euclidean_distance_x`,`d_file_summary`.`euclidean_distance_y` AS `euclidean_distance_y` from (((`bs_task` left join `bs_task_state` on((`bs_task_state`.`task_id` = `bs_task`.`id`))) join `d_upload_file` on((`bs_task_state`.`id` = `d_upload_file`.`task_state_id`))) left join `d_file_summary` on((`d_upload_file`.`id` = `d_file_summary`.`file_id`))) where ((`d_upload_file`.`is_delete` = 0) and (`bs_task_state`.`is_retest` = false) and (`d_file_summary`.`euclidean_distance_x` <= 0.003) and (`d_file_summary`.`euclidean_distance_y` <= 0.003) and (`d_file_summary`.`total_size` > 100) and (`bs_task_state`.`task_df_id` not in (1,3,5)));

SET FOREIGN_KEY_CHECKS = 1;
