/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.68.89_3306
 Source Server Type    : MySQL
 Source Server Version : 50728
 Source Host           : 192.168.68.89:3306
 Source Schema         : yk_ai_test

 Target Server Type    : MySQL
 Target Server Version : 50728
 File Encoding         : 65001

 Date: 21/05/2020 10:12:00
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备机台点胶用量，用于记录此设备的点胶用量,如果每修改一次点胶量，此表增加一条数据' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备任务状态，当前设备正在做那个任务单,当该设备完成当前任务单点胶时，将删除相应记录' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备状态阀体' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_formula_update_log
-- ----------------------------
DROP TABLE IF EXISTS `bs_formula_update_log`;
CREATE TABLE `bs_formula_update_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `model_bom_id` bigint(20) NOT NULL COMMENT '配方id',
  `update_type` tinyint(4) NOT NULL DEFAULT 2 COMMENT '1系统推荐，2用户编辑，3生产修正',
  `creator` bigint(20) NULL DEFAULT NULL COMMENT '修改用户',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_formula_update_log_id`(`model_bom_id`) USING BTREE,
  CONSTRAINT `fk_formula_update_log_id` FOREIGN KEY (`model_bom_id`) REFERENCES `t_model_bom` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配比库更新日志' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统配比修改所有数据记录,具体存储放内容需和算法联系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for bs_formula_update_log_target_parameter
-- ----------------------------
DROP TABLE IF EXISTS `bs_formula_update_log_target_parameter`;
CREATE TABLE `bs_formula_update_log_target_parameter`  (
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
  `bs_formula_update_log_id` bigint(20) NULL DEFAULT NULL COMMENT '日志表的ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配比库更新日志表-此配比任何方式新建时的目标参数' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '更新当前模型所使用的数据源' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '模型系数' ROW_FORMAT = Dynamic;

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
  `ra_commend_param` double(10, 3) NULL DEFAULT NULL COMMENT '显指推荐参数，如0.5',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_ai_model_result_model_factor_id`(`model_factor_id`) USING BTREE,
  INDEX `fk_ai_model_result_factor_id`(`model_id`) USING BTREE,
  CONSTRAINT `fk_ai_model_result_factor_id` FOREIGN KEY (`model_id`) REFERENCES `t_ai_model` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_model_result_model_factor_id` FOREIGN KEY (`model_factor_id`) REFERENCES `bs_model_factor` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '算法每次推荐结果存储' ROW_FORMAT = Dynamic;

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
  `rar9Type` tinyint(4) NULL DEFAULT 1 COMMENT '0 忽略 1不忽略',
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
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_task_formula_info_id`(`task_state_id`) USING BTREE,
  CONSTRAINT `fk_task_formula_info_id` FOREIGN KEY (`task_state_id`) REFERENCES `bs_task_state` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务在每个阶段的配比' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务在每个阶段配比详细信息' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分光文件各色取落bin率统计' ROW_FORMAT = Dynamic;

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
  `ra_describe` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显指分位数统计',
  `cri9_describe` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'cri9分位数统计',
  `lm_describe` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'lm分位数统计',
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
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_task_state_file`(`task_state_id`) USING BTREE,
  CONSTRAINT `fk_task_state_file` FOREIGN KEY (`task_state_id`) REFERENCES `bs_task_state` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分光文件,每次上上传的分光文件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for d_upload_file_judgement_result
-- ----------------------------
DROP TABLE IF EXISTS `d_upload_file_judgement_result`;
CREATE TABLE `d_upload_file_judgement_result`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_id` bigint(20) NOT NULL COMMENT '分光文件id',
  `color_coordinates` int(11) NULL DEFAULT NULL COMMENT '色坐标判定结果 ,0 OK，1 NG ',
  `lightness` int(11) NULL DEFAULT NULL COMMENT '亮度判定结果,0 OK，1 NG',
  `ra` int(11) NULL DEFAULT NULL COMMENT 'ra的判定结果,0 OK，1 NG',
  `r9` int(11) NULL DEFAULT NULL COMMENT 'r9的判定结果,0 OK，1 NG',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分光文件,分光文件判定结果表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 278 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '从木林森EAS同步的工单，需要用户手动转为我们系统的工单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eas_wo
-- ----------------------------
INSERT INTO `eas_wo` VALUES (1, 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'MLSDZ-1-20200304-0057', '2020-03-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtS1RECefw', '06.03.03.007.0477', '2835阳光色贴片', 'S-BEN-30E-11L-03-BB7-9', 'MTR-0001', '标准生产', 'BOM201912180059', 5004303, 4352751, '2020-03-04', '2020-03-12', '无', NULL, 0, 4, '2020-05-19 15:35:23', NULL);
INSERT INTO `eas_wo` VALUES (2, 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'MLSDZ-1-20200305-0151', '2020-03-05', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexR4ZECefw', '06.03.03.001.0952', '2835白色贴片', 'S-BEN-50E-31H-09-JC7-E', 'MTR-0001', '标准生产', 'BOM201903260108', 6651073, 6465373, '2020-03-04', '2020-03-11', '无', NULL, 0, 4, '2020-05-19 15:35:23', NULL);
INSERT INTO `eas_wo` VALUES (3, 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'MLSDZ-1-20200305-0158', '2020-03-05', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtTH1ECefw', '06.03.03.001.1122', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-9', 'MTR-0001', '标准生产', 'BOM201912180060', 8202574, 8202574, '2020-03-05', '2020-03-13', '无', NULL, 0, 4, '2020-05-19 15:35:23', NULL);
INSERT INTO `eas_wo` VALUES (4, '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'MLSDZ-1-20200305-0161', '2020-03-05', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/auxECefw', '06.03.03.001.1106', '2835白色贴片', 'S-BEN-65E-11L-03-BB7-7', 'MTR-0001', '标准生产', 'BOM201910240300', 1300321, 1241807, '2020-03-05', '2020-03-12', '无', NULL, 0, 4, '2020-05-19 15:35:23', NULL);
INSERT INTO `eas_wo` VALUES (5, 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'MLSDZ-1-20200305-0162', '2020-03-05', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdVNECefw', '06.03.03.007.0388', '2835阳光色贴片', 'S-BEN-36G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010021', 2012521, 1632660, '2020-03-05', '2020-03-12', '无', NULL, 0, 4, '2020-05-19 15:35:23', NULL);
INSERT INTO `eas_wo` VALUES (6, 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'MLSDZ-1-20200306-0030', '2020-03-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtSQhECefw', '06.03.03.007.0476', '2835阳光色贴片', 'S-BEN-27E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180069', 1503738, 1248003, '2020-03-06', '2020-03-13', '无', NULL, 0, 4, '2020-05-19 15:35:23', NULL);
INSERT INTO `eas_wo` VALUES (7, '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'MLSDZ-1-20200306-0034', '2020-03-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMs4ZECefw', '03.03.28.001.3504', '2835白色贴片', 'XEN-50G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290068', 6000000, 4608000, '2020-03-06', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (8, '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'MLSDZ-1-20200309-0028', '2020-03-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdGAKJECefw', '06.03.03.001.0713', '2835白色贴片', 'S-BEN-57G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901240332', 20872992, 20872992, '2020-03-09', '2020-03-16', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (9, 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'MLSDZ-1-20200310-0097', '2020-03-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABi9DKpECefw', '06.03.03.007.0392', '2835阳光色贴片', 'S-BEN-27E-31H-09-JG7-4', 'MTR-0001', '标准生产', 'BOM201906170058', 1168074, 1131419, '2020-03-10', '2020-03-17', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (10, 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'MLSDZ-1-20200310-0100', '2020-03-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABi8ssdECefw', '06.03.03.001.1022', '2835白色贴片', 'S-BEN-40E-31H-09-JG7-4', 'MTR-0001', '标准生产', 'BOM201906170065', 1167591, 1079839, '2020-03-10', '2020-03-17', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (11, 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'MLSDZ-1-20200310-0102', '2020-03-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190282', 7746430, 7746430, '2020-03-10', '2020-03-17', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (12, 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'MLSDZ-1-20200310-0105', '2020-03-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABi9CeZECefw', '06.03.03.001.1025', '2835白色贴片', 'S-BEN-50E-31H-09-JG7-4', 'MTR-0001', '标准生产', 'BOM201906170066', 1166824, 1115312, '2020-03-10', '2020-03-17', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (13, 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'MLSDZ-1-20200310-0118', '2020-03-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFGwRECefw', '06.03.03.007.0486', '2835阳光色贴片', 'S-BEN-35G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250016', 1011795, 912040, '2020-03-10', '2020-03-18', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (14, 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'MLSDZ-1-20200311-0038', '2020-03-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKqVECefw', '06.03.03.001.0906', '2835白色贴片', 'S-BEN-50G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190261', 10001518, 9502637, '2020-03-11', '2020-03-18', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (15, 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'MLSDZ-1-20200311-0039', '2020-03-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 100000, 80000, '2020-03-11', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (16, '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'MLSDZ-1-20200311-0043', '2020-03-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 5500000, 5225000, '2020-03-14', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (17, '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'MLSDZ-1-20200312-0065', '2020-03-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMzIZECefw', '03.03.28.001.3500', '2835白色贴片', 'XEN-50G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290057', 1100000, 864000, '2020-03-12', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (18, 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'MLSDZ-1-20200312-0100', '2020-03-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180064', 38003755, 38003755, '2020-03-12', '2020-03-19', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (19, 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'MLSDZ-1-20200312-0102', '2020-03-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXXdBECefw', '06.03.03.001.0963', '2835白色贴片', 'S-BEN-50E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010111', 100649, 100649, '2020-03-12', '2020-03-20', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (20, 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'MLSDZ-1-20200312-0106', '2020-03-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABc/6JRECefw', '06.03.03.001.0657', '2835白色贴片', 'S-BEN-50G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901210020', 6003565, 5954565, '2020-03-12', '2020-03-20', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (21, 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'MLSDZ-1-20200313-0023', '2020-03-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMgnVECefw', '03.03.28.001.3503', '2835白色贴片', 'XEN-40G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290046', 300000, 240000, '2020-03-10', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (22, 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'MLSDZ-1-20200313-0025', '2020-03-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMzipECefw', '03.03.28.002.2067', '2835阳光色贴片', 'XEN-30G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290042', 3100000, 2790000, '2020-03-10', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (23, 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'MLSDZ-1-20200314-0032', '2020-03-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABmRrx1ECefw', '06.03.03.007.0426', '2835阳光色贴片', 'S-BEN-30E-11L-03-D8A-Z', 'MTR-0001', '标准生产', 'BOM201908190050', 1109938, 1059991, '2020-03-14', '2020-03-21', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (24, 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'MLSDZ-1-20200314-0033', '2020-03-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyytVECefw', '06.03.03.007.0444', '2835阳光色贴片', 'S-BEN-30E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140033', 999431, 999431, '2020-03-14', '2020-03-21', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (25, 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'MLSDZ-1-20200314-0035', '2020-03-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABmRtZtECefw', '06.03.03.001.1062', '2835白色贴片', 'S-BEN-65E-11L-03-D8A-Z', 'MTR-0001', '标准生产', 'BOM201908190051', 1309587, 1200750, '2020-03-14', '2020-03-21', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (26, '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'MLSDZ-1-20200314-0037', '2020-03-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtLItECefw', '06.03.03.001.1125', '2835白色贴片', 'S-BEN-50E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180065', 15003886, 15003886, '2020-03-14', '2020-03-21', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (27, '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'MLSDZ-1-20200314-0038', '2020-03-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexSAlECefw', '06.03.03.001.0953', '2835白色贴片', 'S-BEN-50G-31H-09-JCA-E', 'MTR-0001', '标准生产', 'BOM201903260118', 8142507, 7973178, '2020-03-14', '2020-03-21', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (28, 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'MLSDZ-1-20200314-0039', '2020-03-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNjNECefw', '06.03.03.001.0899', '2835白色贴片', 'S-XEN-50G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM201903190266', 2806658, 2806658, '2020-03-14', '2020-03-21', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (29, 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'MLSDZ-1-20200314-0040', '2020-03-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNjNECefw', '06.03.03.001.0899', '2835白色贴片', 'S-XEN-50G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM201903190266', 1152516, 781044, '2020-03-14', '2020-03-21', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (30, 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'MLSDZ-1-20200316-0050', '2020-03-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABmRrx1ECefw', '06.03.03.007.0426', '2835阳光色贴片', 'S-BEN-30E-11L-03-D8A-Z', 'MTR-0001', '标准生产', 'BOM201908190050', 1595163, 1538327, '2020-03-16', '2020-03-23', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (31, 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'MLSDZ-1-20200316-0051', '2020-03-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKWlECefw', '06.03.03.001.0903', '2835白色贴片', 'S-XEN-65G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM201903190267', 2001590, 1838753, '2020-03-16', '2020-03-23', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (32, 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'MLSDZ-1-20200317-0056', '2020-03-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABhob6xECefw', '03.03.28.002.1701', '2835阳光色贴片', 'E2835US21B', 'MTR-0001', '标准生产', 'BOM201905170049', 9968000, 9548000, '2020-03-17', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (33, 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'MLSDZ-1-20200318-0028', '2020-03-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/alpECefw', '06.03.03.001.1103', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240298', 10403660, 9817537, '2020-03-18', '2020-03-25', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (34, 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'MLSDZ-1-20200318-0030', '2020-03-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlDe+5ECefw', '06.03.03.007.0407', '2835阳光色贴片', 'S-BEN-30E-41H-12-K15-7', 'MTR-0001', '标准生产', 'BOM201907300054', 975489, 975489, '2020-03-18', '2020-03-25', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (35, 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'MLSDZ-1-20200318-0031', '2020-03-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexSNNECefw', '06.03.03.001.0960', '2835白色贴片', 'S-BEN-65G-31H-09-JCA-E', 'MTR-0001', '标准生产', 'BOM201903260120', 1500724, 1409859, '2020-03-18', '2020-03-25', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (36, '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'MLSDZ-1-20200318-0032', '2020-03-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMq9ECefw', '06.03.03.001.0907', '2835白色贴片', 'S-BEN-65G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190269', 1694453, 1558897, '2020-03-18', '2020-03-25', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (37, 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'MLSDZ-1-20200318-0033', '2020-03-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190255', 10087044, 10022692, '2020-03-18', '2020-03-25', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (38, 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'MLSDZ-1-20200319-0022', '2020-03-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTTBECefw', '06.03.03.007.0484', '2835阳光色贴片', 'S-BEN-27G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250011', 10001233, 9489281, '2020-03-19', '2020-03-26', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (39, '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'MLSDZ-1-20200319-0024', '2020-03-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU2dECefw', '06.03.03.001.0964', '2835白色贴片', 'S-BEN-65E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010106', 4235986, 4098316, '2020-03-19', '2020-03-26', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (40, 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'MLSDZ-1-20200320-0003', '2020-03-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMtBJECefw', '03.03.28.001.3506', '2835白色贴片', 'XEN-65G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290053', 1900000, 1748000, '2020-03-20', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (41, '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'MLSDZ-1-20200320-0006', '2020-03-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 1850000, 1766750, '2020-03-20', '2020-04-07', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (42, 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'MLSDZ-1-20200320-0032', '2020-03-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010020', 3000926, 2805866, '2020-03-20', '2020-03-27', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (43, 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'MLSDZ-1-20200320-0033', '2020-03-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFG8NECefw', '06.03.03.007.0485', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250010', 4393962, 4170302, '2020-03-20', '2020-03-27', '无', '6', 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (44, 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'MLSDZ-1-20200320-0036', '2020-03-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMq9ECefw', '06.03.03.001.0907', '2835白色贴片', 'S-BEN-65G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190269', 2002001, 1699724, '2020-03-20', '2020-03-27', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (45, 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'MLSDZ-1-20200320-0049', '2020-03-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexSTZECefw', '06.03.03.007.0322', '2835阳光色贴片', 'S-BEN-27G-31H-09-JCA-E', 'MTR-0001', '标准生产', 'BOM201903260083', 8890233, 8215308, '2020-03-20', '2020-03-27', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (46, 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'MLSDZ-1-20200320-0093', '2020-03-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMsm1ECefw', '03.03.28.002.2072', '2835阳光色贴片', 'XEN-30G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290047', 1200000, 1161000, '2020-03-20', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (47, '79ERMD9mSoCK41LBd31UQR0NgN0=', 'MLSDZ-1-20200321-0122', '2020-03-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250013', 15002203, 14891665, '2020-03-21', '2020-03-29', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (48, 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'MLSDZ-1-20200321-0123', '2020-03-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABkHIdhECefw', '06.03.03.001.1034', '2835白色贴片', 'S-BEN-40E-21M-06-L02-2', 'MTR-0001', '标准生产', 'BOM201907030131', 4003167, 3606132, '2020-03-21', '2020-03-29', '无', '6', 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (49, 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'MLSDZ-1-20200323-0047', '2020-03-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180064', 19975586, 19975586, '2020-03-23', '2020-03-30', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (50, 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'MLSDZ-1-20200323-0048', '2020-03-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/aBBECefw', '06.03.03.001.1104', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-7', 'MTR-0001', '标准生产', 'BOM201910240296', 3381548, 3068598, '2020-03-23', '2020-03-30', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (51, 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'MLSDZ-1-20200323-0049', '2020-03-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/bKJECefw', '06.03.03.001.1102', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-7', 'MTR-0001', '标准生产', 'BOM201910240302', 4048687, 3672583, '2020-03-23', '2020-03-30', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (52, 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'MLSDZ-1-20200323-0051', '2020-03-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlDfQJECefw', '06.03.03.007.0408', '2835阳光色贴片', 'S-BEN-30G-41H-12-K16-7', 'MTR-0001', '标准生产', 'BOM201907300051', 3121000, 2731209, '2020-03-23', '2020-03-30', '无', '6', 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (53, 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'MLSDZ-1-20200324-0052', '2020-03-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtmwhpECefw', '06.03.03.001.1143', '2835白色贴片（植物照明）', 'S-BEN-61C-21H-06-N34-A', 'MTR-0001', '标准生产', 'BOM202003200020', 100150, 76454, '2020-03-24', '2020-03-30', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (54, '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'MLSDZ-1-20200324-0113', '2020-03-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/bTRECefw', '06.03.03.001.1105', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240294', 5043577, 4807557, '2020-03-24', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (55, 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'MLSDZ-1-20200324-0114', '2020-03-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190255', 7167053, 6913700, '2020-03-24', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (56, '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'MLSDZ-1-20200324-0116', '2020-03-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/NCFECefw', '06.03.03.007.0461', '2835阳光色贴片', 'S-BEN-30E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240304', 1502744, 1447284, '2020-03-24', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (57, 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'MLSDZ-1-20200324-0118', '2020-03-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdAIhhECefw', '06.03.03.007.0042', '2835阳光色贴片', 'S-BEN-27E-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210223', 2227485, 2119809, '2020-03-24', '2020-03-31', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (58, '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'MLSDZ-1-20200324-0126', '2020-03-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtSi5ECefw', '06.03.03.001.1124', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-9', 'MTR-0001', '标准生产', 'BOM201912180072', 7191997, 7042288, '2020-03-24', '2020-04-08', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (59, 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'MLSDZ-1-20200325-0094', '2020-03-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtSi5ECefw', '06.03.03.001.1124', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-9', 'MTR-0001', '标准生产', 'BOM201912180072', 3425781, 3378773, '2020-03-25', '2020-04-01', '无', '6', 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (60, 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'MLSDZ-1-20200325-0097', '2020-03-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/bBBECefw', '06.03.03.007.0463', '2835阳光色贴片', 'S-BEN-35E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240295', 3028894, 2647776, '2020-03-25', '2020-04-01', '无', '6', 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (61, '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'MLSDZ-1-20200325-0098', '2020-03-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABmdjRVECefw', '06.03.03.001.1066', '2835白色贴片', 'S-BEN-50E-21H-18-P54-5', 'MTR-0001', '标准生产', 'BOM201908220050', 102696, 99058, '2020-03-25', '2020-04-01', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (62, 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'MLSDZ-1-20200325-0099', '2020-03-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMnuNECefw', '06.03.03.007.0273', '2835阳光色贴片', 'S-BEN-27E-11M-03-F0E-9', 'MTR-0001', '标准生产', 'BOM201903140042', 3000370, 2872526, '2020-03-25', '2020-04-01', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (63, 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'MLSDZ-1-20200328-0011', '2020-03-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMycpECefw', '03.03.28.002.2071', '2835阳光色贴片', 'XEN-27G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290060', 1000000, 955000, '2020-03-28', '2020-04-09', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (64, 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'MLSDZ-1-20200328-0015', '2020-03-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMsm1ECefw', '03.03.28.002.2072', '2835阳光色贴片', 'XEN-30G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290047', 1000000, 955000, '2020-03-28', '2020-04-04', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (65, 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'MLSDZ-1-20200328-0067', '2020-03-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKqVECefw', '06.03.03.001.0906', '2835白色贴片', 'S-BEN-50G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190261', 4551535, 4255685, '2020-03-28', '2020-04-04', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (66, 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'MLSDZ-1-20200328-0068', '2020-03-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKqVECefw', '06.03.03.001.0906', '2835白色贴片', 'S-BEN-50G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190261', 6169907, 5324143, '2020-03-28', '2020-04-04', '无', NULL, 0, 4, '2020-05-19 15:35:24', NULL);
INSERT INTO `eas_wo` VALUES (67, 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'MLSDZ-1-20200328-0104', '2020-03-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoC9WdECefw', '06.03.03.001.1083', '2835白色贴片', 'S-BEN-75G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201909270028', 4283100, 4143899, '2020-03-28', '2020-04-04', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (68, '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'MLSDZ-1-20200328-0143', '2020-03-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 49000000, '2020-03-28', '2020-04-11', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (69, 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'MLSDZ-1-20200330-0020', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtmwhpECefw', '06.03.03.001.1143', '2835白色贴片（植物照明）', 'S-BEN-61C-21H-06-N34-A', 'MTR-0001', '标准生产', 'BOM202003200020', 1610488, 1537133, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (70, '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'MLSDZ-1-20200330-0028', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 102714, 102714, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (71, 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'MLSDZ-1-20200330-0030', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180064', 3426591, 3426591, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (72, 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'MLSDZ-1-20200330-0032', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABed7/9ECefw', '06.03.03.007.0286', '2835阳光色贴片', 'S-BEN-30G-31H-09-JC1-0', 'MTR-0001', '标准生产', 'BOM201903160118', 3750959, 3476152, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (73, 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'MLSDZ-1-20200330-0033', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZGVFECefw', '06.03.03.007.0279', '2835阳光色贴片', 'S-BEN-27E-31H-09-JC1-0', 'MTR-0001', '标准生产', 'BOM201903150156', 1678941, 1678941, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (74, 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'MLSDZ-1-20200330-0034', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMqrRECefw', '06.03.03.001.0872', '2835白色贴片', 'S-BEN-50E-11M-03-F0E-9', 'MTR-0001', '标准生产', 'BOM201903140034', 3202105, 3202105, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (75, '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'MLSDZ-1-20200330-0036', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZCbJECefw', '06.03.03.007.0280', '2835阳光色贴片', 'S-BEN-30E-31H-09-JC1-0', 'MTR-0001', '标准生产', 'BOM201903150154', 8154745, 7964172, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (76, 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'MLSDZ-1-20200330-0037', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBVtpECefw', '06.03.03.007.0151', '2835阳光色贴片', 'S-BEN-30G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210369', 4195150, 4062583, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (77, '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'MLSDZ-1-20200330-0038', '2020-03-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdADKNECefw', '06.03.03.001.0562', '2835白色贴片', 'S-BEN-40E-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210037', 1231315, 1231315, '2020-03-30', '2020-04-06', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (78, 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'MLSDZ-1-20200331-0001', '2020-04-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 2000000, 1900000, '2020-04-01', '2020-04-11', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (79, 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'MLSDZ-1-20200331-0002', '2020-03-31', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMgV1ECefw', '03.03.28.002.2069', '2835阳光色贴片', 'XEN-27G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290058', 3400000, 3179000, '2020-04-01', '2020-04-11', '无', '6', 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (80, 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'MLSDZ-1-20200331-0005', '2020-04-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180064', 2123056, 1546508, '2020-04-01', '2020-04-08', '无', '6', 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (81, 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'MLSDZ-1-20200401-0066', '2020-04-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtLItECefw', '06.03.03.001.1125', '2835白色贴片', 'S-BEN-50E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180065', 3707310, 3170413, '2020-04-01', '2020-04-08', '无', '6', 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (82, 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'MLSDZ-1-20200401-0069', '2020-04-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABkHIdhECefw', '06.03.03.001.1034', '2835白色贴片', 'S-BEN-40E-21M-06-L02-2', 'MTR-0001', '标准生产', 'BOM201907030131', 5005804, 4745000, '2020-04-01', '2020-04-08', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (83, 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'MLSDZ-1-20200402-0036', '2020-04-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/auxECefw', '06.03.03.001.1106', '2835白色贴片', 'S-BEN-65E-11L-03-BB7-7', 'MTR-0001', '标准生产', 'BOM201910240300', 877471, 757524, '2020-04-01', '2020-04-08', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (84, 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'MLSDZ-1-20200403-0027', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250013', 7786779, 7397440, '2020-04-03', '2020-04-10', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (85, 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'MLSDZ-1-20200403-0028', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo3b/5ECefw', '06.03.03.001.1095', '2835白色贴片', 'S-BEN-65E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910180020', 3002715, 2924501, '2020-04-03', '2020-04-10', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (86, 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'MLSDZ-1-20200403-0030', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140026', 13937660, 13777863, '2020-04-03', '2020-04-10', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (87, 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'MLSDZ-1-20200403-0031', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtLR5ECefw', '06.03.03.007.0478', '2835阳光色贴片', 'S-BEN-30E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180056', 3557651, 3555867, '2020-04-03', '2020-04-10', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (88, 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'MLSDZ-1-20200403-0032', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdAByZECefw', '06.03.03.001.0664', '2835白色贴片', 'S-BEN-50G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210127', 2401496, 2282770, '2020-04-03', '2020-04-10', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (89, 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'MLSDZ-1-20200403-0033', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlxbGRECefw', '06.03.03.001.1047', '2835白色贴片', 'S-BEN-65H-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201908090043', 296774, 237419, '2020-04-03', '2020-04-10', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (90, 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'MLSDZ-1-20200403-0034', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo3VRNECefw', '06.03.03.001.1092', '2835白色贴片', 'S-BEN-40E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910180029', 2392097, 2330703, '2020-04-03', '2020-04-10', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (91, 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'MLSDZ-1-20200403-0035', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 49000000, '2020-04-03', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (92, 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'MLSDZ-1-20200403-0040', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMycpECefw', '03.03.28.002.2071', '2835阳光色贴片', 'XEN-27G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290060', 1900000, 1748000, '2020-04-03', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (93, 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'MLSDZ-1-20200403-0072', '2020-04-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMsm1ECefw', '03.03.28.002.2072', '2835阳光色贴片', 'XEN-30G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290047', 1000000, 608750, '2020-04-03', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (94, 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'MLSDZ-1-20200406-0021', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMgV1ECefw', '03.03.28.002.2069', '2835阳光色贴片', 'XEN-27G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290058', 3600000, 3366000, '2020-04-06', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (95, 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'MLSDZ-1-20200406-0022', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 400000, 320000, '2020-04-06', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (96, 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'MLSDZ-1-20200406-0044', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250013', 7308289, 5686604, '2020-04-06', '2020-04-13', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (97, 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'MLSDZ-1-20200406-0045', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU2dECefw', '06.03.03.001.0964', '2835白色贴片', 'S-BEN-65E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010106', 1999493, 1729808, '2020-04-06', '2020-04-13', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (98, 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'MLSDZ-1-20200406-0046', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdF0bZECefw', '06.03.03.004.0006', '2835红色贴片（植物照明）', 'S-BEN-PCR-21H-06-N11-1', 'MTR-0001', '标准生产', 'BOM201901240173', 751166, 751166, '2020-04-06', '2020-04-13', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (99, 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'MLSDZ-1-20200406-0048', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 10242437, 10046772, '2020-04-06', '2020-04-13', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (100, 'byg1s/W7RgClxmdActOT9R0NgN0=', 'MLSDZ-1-20200406-0049', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph2flECefw', '06.03.03.007.0466', '2835阳光色贴片', 'S-BEN-27E-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070055', 3008065, 2838158, '2020-04-06', '2020-04-13', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (101, 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'MLSDZ-1-20200406-0050', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph5TRECefw', '06.03.03.001.1116', '2835白色贴片', 'S-BEN-65E-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070038', 3008998, 2802480, '2020-04-06', '2020-04-13', '无', '6', 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (102, 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'MLSDZ-1-20200406-0051', '2020-04-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph4D9ECefw', '06.03.03.001.1108', '2835白色贴片', 'S-BEN-40E-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070042', 3006386, 2891650, '2020-04-06', '2020-04-13', '无', '6', 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (103, 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'MLSDZ-1-20200407-0001', '2020-04-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdF4ypECefw', '06.03.03.001.0814', '2835白色贴片（植物照明）', 'S-BEN-65G-21H-06-N12-2', 'MTR-0001', '标准生产', 'BOM201901240230', 2142799, 2110425, '2020-04-07', '2020-04-14', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (104, 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'MLSDZ-1-20200407-0002', '2020-04-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoC9WdECefw', '06.03.03.001.1083', '2835白色贴片', 'S-BEN-75G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201909270028', 102702, 76854, '2020-04-07', '2020-04-14', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (105, '66FJJdNITuatI7XUSqblmh0NgN0=', 'MLSDZ-1-20200408-0003', '2020-04-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMycpECefw', '03.03.28.002.2071', '2835阳光色贴片', 'XEN-27G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290060', 2540000, 2362220, '2020-04-08', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (106, 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'MLSDZ-1-20200409-0037', '2020-04-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 4600000, 1795000, '2020-04-09', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (107, 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'MLSDZ-1-20200409-0045', '2020-04-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMgV1ECefw', '03.03.28.002.2069', '2835阳光色贴片', 'XEN-27G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290058', 3700000, 3209000, '2020-04-09', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (108, 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'MLSDZ-1-20200409-0050', '2020-04-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexS4lECefw', '06.03.03.007.0326', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCA-E', 'MTR-0001', '标准生产', 'BOM201903260086', 10001595, 9800878, '2020-04-09', '2020-04-16', '无', '6', 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (109, '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'MLSDZ-1-20200410-0030', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 49000000, '2020-04-10', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (110, 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'MLSDZ-1-20200410-0056', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ9qlECefw', '06.03.03.007.0496', '2835全光谱机种', 'S-IEN-30R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060039', 34272, 23666, '2020-04-10', '2020-04-17', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (111, '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'MLSDZ-1-20200410-0059', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ3pZECefw', '06.03.03.007.0495', '2835全光谱机种', 'S-IEN-27R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060041', 34265, 11311, '2020-04-10', '2020-04-17', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (112, 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'MLSDZ-1-20200410-0060', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ215ECefw', '06.03.03.007.0497', '2835全光谱机种', 'S-IEN-35R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060040', 34190, 22452, '2020-04-10', '2020-04-17', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (113, 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'MLSDZ-1-20200410-0061', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ3VFECefw', '06.03.03.001.1144', '2835全光谱机种', 'S-IEN-40R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060035', 31513, 18107, '2020-04-10', '2020-04-17', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (114, 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'MLSDZ-1-20200410-0062', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ3AFECefw', '06.03.03.001.1145', '2835全光谱机种', 'S-IEN-50R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060037', 32504, 18884, '2020-04-10', '2020-04-17', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (115, 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'MLSDZ-1-20200410-0066', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyadECefw', '06.03.03.002.0011', '2835阳光色贴片', 'S-BEN-27G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210037', 5570699, 5509055, '2020-04-10', '2020-04-18', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (116, 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'MLSDZ-1-20200410-0067', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190282', 11461, 11461, '2020-04-10', '2020-04-18', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (117, 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'MLSDZ-1-20200410-0068', '2020-04-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190255', 5243389, 5138521, '2020-04-10', '2020-04-18', '无', '6', 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (118, 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'MLSDZ-1-20200411-0010', '2020-04-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 750000, 600000, '2020-04-11', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (119, 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'MLSDZ-1-20200411-0118', '2020-04-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoC9WdECefw', '06.03.03.001.1083', '2835白色贴片', 'S-BEN-75G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201909270028', 13632791, 13360135, '2020-04-11', '2020-04-18', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (120, 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'MLSDZ-1-20200411-0119', '2020-04-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190255', 2044664, 1881299, '2020-04-11', '2020-04-18', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (121, 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'MLSDZ-1-20200411-0120', '2020-04-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeo2+9ECefw', '06.03.03.001.0923', '2835白色贴片', 'S-BEN-57G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210039', 7140033, 6975274, '2020-04-11', '2020-04-18', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (122, 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'MLSDZ-1-20200413-0043', '2020-04-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190282', 5203640, 5133603, '2020-04-13', '2020-04-20', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (123, 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'MLSDZ-1-20200413-0044', '2020-04-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZCbJECefw', '06.03.03.007.0280', '2835阳光色贴片', 'S-BEN-30E-31H-09-JC1-0', 'MTR-0001', '标准生产', 'BOM201903150154', 3125424, 2996811, '2020-04-13', '2020-04-20', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (124, 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'MLSDZ-1-20200413-0045', '2020-04-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdADKNECefw', '06.03.03.001.0562', '2835白色贴片', 'S-BEN-40E-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210037', 3275421, 3222598, '2020-04-13', '2020-04-20', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (125, 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'MLSDZ-1-20200413-0047', '2020-04-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMgnVECefw', '03.03.28.001.3503', '2835白色贴片', 'XEN-40G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290046', 600000, 267000, '2020-04-13', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (126, 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'MLSDZ-1-20200413-0048', '2020-04-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMtBJECefw', '03.03.28.001.3506', '2835白色贴片', 'XEN-65G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290053', 8300000, 7810000, '2020-04-13', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (127, '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'MLSDZ-1-20200414-0077', '2020-04-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoC9WdECefw', '06.03.03.001.1083', '2835白色贴片', 'S-BEN-75G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201909270028', 7959764, 7804364, '2020-04-14', '2020-04-21', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (128, 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'MLSDZ-1-20200414-0078', '2020-04-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdGAKJECefw', '06.03.03.001.0713', '2835白色贴片', 'S-BEN-57G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901240332', 8107845, 7455422, '2020-04-14', '2020-04-21', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (129, 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'MLSDZ-1-20200414-0079', '2020-04-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexNk9ECefw', '06.03.03.001.0956', '2835白色贴片', 'S-BEN-57G-31H-09-JCA-E', 'MTR-0001', '标准生产', 'BOM201903260098', 3040404, 2951097, '2020-04-14', '2020-04-21', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (130, 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'MLSDZ-1-20200414-0080', '2020-04-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBOsVECefw', '06.03.03.007.0144', '2835阳光色贴片', 'S-BEN-30G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901210399', 5119892, 5017494, '2020-04-14', '2020-04-21', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (131, 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'MLSDZ-1-20200415-0054', '2020-04-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140026', 2165825, 1819616, '2020-04-15', '2020-04-22', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (132, 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'MLSDZ-1-20200415-0055', '2020-04-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190282', 5352305, 5084690, '2020-04-15', '2020-04-22', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (133, 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'MLSDZ-1-20200415-0056', '2020-04-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140026', 1911770, 1225000, '2020-04-15', '2020-04-22', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (134, 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'MLSDZ-1-20200415-0057', '2020-04-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlxbGRECefw', '06.03.03.001.1047', '2835白色贴片', 'S-BEN-65H-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201908090043', 865316, 601073, '2020-04-15', '2020-04-22', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (135, 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'MLSDZ-1-20200415-0069', '2020-04-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdAK2lECefw', '06.03.03.007.0063', '2835阳光色贴片', 'S-BEN-27G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901210088', 7026656, 6886123, '2020-04-15', '2020-04-22', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (136, 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'MLSDZ-1-20200417-0015', '2020-04-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5pJFECefw', '06.03.03.007.0423', '2835阳光色贴片', 'S-BEN-30S-11M-03-F0G-B', 'MTR-0001', '标准生产', 'BOM201908120134', 175713, 145071, '2020-04-17', '2020-04-24', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (137, '5X85mW2sRHWmZnj69ete0x0NgN0=', 'MLSDZ-1-20200417-0016', '2020-04-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5qn9ECefw', '06.03.03.007.0422', '2835阳光色贴片', 'S-BEN-27S-11M-03-F0G-B', 'MTR-0001', '标准生产', 'BOM201908120130', 246315, 198393, '2020-04-17', '2020-04-24', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (138, 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'MLSDZ-1-20200417-0017', '2020-04-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010020', 1580395, 1443809, '2020-04-17', '2020-04-24', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (139, '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'MLSDZ-1-20200417-0018', '2020-04-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5p81ECefw', '06.03.03.007.0424', '2835阳光色贴片', 'S-BEN-35S-11M-03-F0G-B', 'MTR-0001', '标准生产', 'BOM201908120133', 206130, 185517, '2020-04-17', '2020-04-24', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (140, 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'MLSDZ-1-20200417-0019', '2020-04-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5p81ECefw', '06.03.03.007.0424', '2835阳光色贴片', 'S-BEN-35S-11M-03-F0G-B', 'MTR-0001', '标准生产', 'BOM201908120133', 192265, 161098, '2020-04-17', '2020-04-24', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (141, 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'MLSDZ-1-20200417-0020', '2020-04-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190282', 5403774, 5151328, '2020-04-17', '2020-04-24', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (142, 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'MLSDZ-1-20200417-0048', '2020-04-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK2RECefw', '06.03.03.007.0480', '2835阳光色贴片', 'S-BEN-35E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180057', 8504997, 7319543, '2020-04-17', '2020-04-24', '无', '6', 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (143, 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'MLSDZ-1-20200418-0001', '2020-04-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 49000000, '2020-04-20', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (144, 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'MLSDZ-1-20200420-0002', '2020-04-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABgBBZNECefw', '06.03.03.007.0341', '2835阳光色贴片', 'S-BEN-25E-12H-18-P07-3', 'MTR-0001', '标准生产', 'BOM201904130027', 447123, 409099, '2020-04-20', '2020-04-27', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (145, 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'MLSDZ-1-20200420-0160', '2020-04-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuhrnpECefw', '06.03.03.007.0498', '2835阳光色贴片', 'S-BEN-22G-11M-03-F7D-6', 'MTR-0001', '标准生产', 'BOM202004150011', 201265, 170650, '2020-04-20', '2020-04-27', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (146, 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'MLSDZ-1-20200420-0161', '2020-04-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250013', 113092, 0, '2020-04-20', '2020-04-27', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (147, 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'MLSDZ-1-20200422-0002', '2020-04-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 10668000, '2020-04-22', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (148, 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'MLSDZ-1-20200422-0003', '2020-04-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 1700000, 1615000, '2020-04-22', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (149, 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'MLSDZ-1-20200423-0020', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190282', 105401, 84321, '2020-04-23', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (150, '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'MLSDZ-1-20200423-0021', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlxbGRECefw', '06.03.03.001.1047', '2835白色贴片', 'S-BEN-65H-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201908090043', 311147, 0, '2020-04-23', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (151, 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'MLSDZ-1-20200423-0125', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelLQRECefw', '06.03.03.007.0289', '2835阳光色贴片', 'S-BEN-27G-31H-09-JD6-F', 'MTR-0001', '标准生产', 'BOM201903190270', 100449, 88251, '2020-04-23', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (152, 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'MLSDZ-1-20200423-0126', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelM9tECefw', '06.03.03.001.0894', '2835白色贴片', 'S-BEN-50G-31H-09-JD6-F', 'MTR-0001', '标准生产', 'BOM201903190262', 102533, 93798, '2020-04-23', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:25', NULL);
INSERT INTO `eas_wo` VALUES (153, 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'MLSDZ-1-20200424-0043', '2020-04-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 1800000, 1656000, '2020-04-24', '2020-04-30', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (154, 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'MLSDZ-1-20200424-0056', '2020-04-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyadECefw', '06.03.03.002.0011', '2835阳光色贴片', 'S-BEN-27G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210037', 3058854, 2322701, '2020-04-24', '2020-05-01', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (155, 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'MLSDZ-1-20200425-0034', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtTH1ECefw', '06.03.03.001.1122', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-9', 'MTR-0001', '标准生产', 'BOM201912180060', 4645975, 4645975, '2020-04-25', '2020-05-02', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (156, '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'MLSDZ-1-20200425-0035', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKc5ECefw', '06.03.03.001.0905', '2835白色贴片', 'S-BEN-40G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190256', 1551284, 1354113, '2020-04-25', '2020-05-02', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (157, 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'MLSDZ-1-20200425-0036', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtTH1ECefw', '06.03.03.001.1122', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-9', 'MTR-0001', '标准生产', 'BOM201912180060', 1351079, 1086704, '2020-04-25', '2020-05-02', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (158, 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'MLSDZ-1-20200425-0037', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 0, '2020-04-25', '2020-05-09', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (159, 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'MLSDZ-1-20200429-0066', '2020-05-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 25000000, 0, '2020-05-09', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (160, 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'MLSDZ-1-20200429-0094', '2020-04-29', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 300000, 140000, '2020-04-29', '2020-05-09', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (161, 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'MLSDZ-1-20200430-0002', '2020-05-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 600000, 480000, '2020-05-01', '2020-05-01', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (162, 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'MLSDZ-1-20200430-0006', '2020-05-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 20000000, 0, '2020-05-09', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (163, 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'MLSDZ-1-20200430-0021', '2020-05-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 10000000, 0, '2020-05-09', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (164, 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'MLSDZ-1-20200430-0022', '2020-04-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 1028250, 0, '2020-05-01', '2020-05-08', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (165, '2odChiALRS+H3OSNHd8NDx0NgN0=', 'MLSDZ-1-20200430-0023', '2020-05-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph2WdECefw', '06.03.03.007.0464', '2835阳光色贴片', 'S-BEN-22E-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070060', 1414911, 0, '2020-05-01', '2020-05-08', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (166, 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'MLSDZ-1-20200430-0024', '2020-04-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdGAKJECefw', '06.03.03.001.0713', '2835白色贴片', 'S-BEN-57G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901240332', 6511181, 0, '2020-05-01', '2020-05-08', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (167, 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'MLSDZ-1-20200430-0025', '2020-04-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdAK2lECefw', '06.03.03.007.0063', '2835阳光色贴片', 'S-BEN-27G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901210088', 6511638, 2038792, '2020-05-01', '2020-05-08', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (168, 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'MLSDZ-1-20200430-0026', '2020-04-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBOsVECefw', '06.03.03.007.0144', '2835阳光色贴片', 'S-BEN-30G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901210399', 5342789, 4690504, '2020-05-01', '2020-05-08', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (169, 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'MLSDZ-1-20200430-0039', '2020-04-30', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 2400000, 2208000, '2020-05-01', '2020-05-09', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (170, 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'MLSDZ-1-20200506-0074', '2020-05-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 250000, 164747, '2020-05-07', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (171, 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'MLSDZ-1-20200506-0076', '2020-05-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 100000, 0, '2020-05-09', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (172, 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'MLSDZ-1-20200507-0079', '2020-05-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMycpECefw', '03.03.28.002.2071', '2835阳光色贴片', 'XEN-27G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290060', 3500000, 2502000, '2020-05-07', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (173, 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'MLSDZ-1-20200507-0080', '2020-05-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 1600000, 1054019, '2020-05-07', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (174, 'iWLw395sQPSBqec9roPOWR0NgN0=', 'MLSDZ-1-20200507-0081', '2020-05-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 90000000, 0, '2020-05-09', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (175, 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'MLSDZ-1-20200507-0082', '2020-05-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABc/4rNECefw', '06.03.03.001.0590', '2835白色贴片', 'S-BEN-40G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210110', 1060609, 0, '2020-05-07', '2020-05-14', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (176, '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'MLSDZ-1-20200508-0078', '2020-05-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 5000000, 0, '2020-05-09', '2020-05-16', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (177, 'jVPtklYCR6qtppbYecgymh0NgN0=', 'MLSDZ-1-20200509-0010', '2020-05-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5qn9ECefw', '06.03.03.007.0422', '2835阳光色贴片', 'S-BEN-27S-11M-03-F0G-B', 'MTR-0001', '标准生产', 'BOM201908120130', 238611, 0, '2020-05-09', '2020-05-18', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (178, '/upvfU28QuG/gklpW/xBpR0NgN0=', 'MLSDZ-1-20200511-0073', '2020-05-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoE+7FECefw', '06.03.03.007.0441', '2835阳光色贴片', 'S-BEN-27E-21H-18-P54-6', 'MTR-0001', '标准生产', 'BOM201909280042', 2164540, 0, '2020-05-11', '2020-05-19', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (179, 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'MLSDZ-1-20200511-0075', '2020-05-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190255', 7503271, 4800, '2020-05-11', '2020-05-19', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (180, 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'MLSDZ-1-20200511-0126', '2020-05-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250013', 7474173, 0, '2020-05-11', '2020-05-19', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (181, '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'MLSDZ-1-20200511-0127', '2020-05-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdAK2lECefw', '06.03.03.007.0063', '2835阳光色贴片', 'S-BEN-27G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901210088', 4504567, 0, '2020-05-11', '2020-05-19', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (182, 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'MLSDZ-1-20200511-0128', '2020-05-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdGAKJECefw', '06.03.03.001.0713', '2835白色贴片', 'S-BEN-57G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901240332', 5275609, 0, '2020-05-11', '2020-05-19', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (183, '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'MLSDZ-1-20200512-0020', '2020-05-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexS+xECefw', '06.03.03.001.0949', '2835白色贴片', 'S-BEN-40E-31H-09-JC7-E', 'MTR-0001', '标准生产', 'BOM201903260110', 300407, 0, '2020-05-12', '2020-05-19', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (184, 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'MLSDZ-1-20200513-0080', '2020-05-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 100000000, 0, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (185, 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'MLSDZ-1-20200513-0081', '2020-05-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdGAKJECefw', '06.03.03.001.0713', '2835白色贴片', 'S-BEN-57G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901240332', 101735, 0, '2020-05-13', '2020-05-20', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (186, 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'MLSDZ-1-20200514-0056', '2020-05-14', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 2100000, 0, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (187, 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'MLSDZ-1-20200514-0068', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5prlECefw', '06.03.03.007.0421', '2835阳光色贴片', 'S-BEN-35S-11L-03-D0G-T', 'MTR-0001', '标准生产', 'BOM201908120131', 289810, 0, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (188, 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'MLSDZ-1-20200514-0069', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5qWtECefw', '06.03.03.007.0420', '2835阳光色贴片', 'S-BEN-30S-11L-03-D0G-T', 'MTR-0001', '标准生产', 'BOM201908120128', 133335, 0, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (189, 'n386PwxFTby3ISob6LrjrB0NgN0=', 'MLSDZ-1-20200514-0070', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5pi9ECefw', '06.03.03.007.0419', '2835阳光色贴片', 'S-BEN-27S-11L-03-D0G-T', 'MTR-0001', '标准生产', 'BOM201908120120', 164487, 0, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (190, 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'MLSDZ-1-20200514-0071', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190282', 2636243, 300337, '2020-05-14', '2020-05-22', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (191, 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'MLSDZ-1-20200514-0072', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 1705540, 0, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (192, '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'MLSDZ-1-20200514-0073', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010020', 1757784, 0, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (193, 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'MLSDZ-1-20200515-0044', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 1050000, 0, '2020-05-15', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (194, 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'MLSDZ-1-20200515-0046', '2020-05-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/bTRECefw', '06.03.03.001.1105', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240294', 6003801, 0, '2020-05-15', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (195, 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'MLSDZ-1-20200515-0047', '2020-05-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/alpECefw', '06.03.03.001.1103', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240298', 4171232, 0, '2020-05-15', '2020-05-23', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (196, 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'MLSDZ-1-20200518-0018', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180064', 7102526, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (197, 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'MLSDZ-1-20200518-0019', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtKtJECefw', '06.03.03.001.1127', '2835白色贴片', 'S-BEN-65E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180070', 702787, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (198, 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'MLSDZ-1-20200518-0020', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlxbGRECefw', '06.03.03.001.1047', '2835白色贴片', 'S-BEN-65H-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201908090043', 10740, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (199, 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'MLSDZ-1-20200518-0021', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBVtpECefw', '06.03.03.007.0151', '2835阳光色贴片', 'S-BEN-30G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210369', 1511427, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (200, 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'MLSDZ-1-20200518-0022', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyadECefw', '06.03.03.002.0011', '2835阳光色贴片', 'S-BEN-27G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210037', 2805178, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (201, 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'MLSDZ-1-20200518-0024', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 1800175, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (202, 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'MLSDZ-1-20200518-0037', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3xtECefw', '06.03.03.007.0471', '2835阳光色贴片', 'S-BEN-30G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070049', 1406297, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (203, 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'MLSDZ-1-20200518-0038', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3WVECefw', '06.03.03.001.1113', '2835白色贴片', 'S-BEN-50G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070044', 1401325, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (204, 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'MLSDZ-1-20200518-0039', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph2NVECefw', '06.03.03.007.0473', '2835阳光色贴片', 'S-BEN-35G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070048', 1272221, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (205, 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'MLSDZ-1-20200518-0043', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdOdECefw', '06.03.03.001.1017', '2835白色贴片', 'S-BEN-50G-31H-09-JCG-E', 'MTR-0001', '标准生产', 'BOM201906010018', 1453700, 0, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (206, 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'MLSDZ-1-20200519-0001', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 70000000, 0, '2020-05-20', '2020-05-30', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (207, 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'MLSDZ-1-20200519-0021', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMycpECefw', '03.03.28.002.2071', '2835阳光色贴片', 'XEN-27G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290060', 610000, 0, '2020-05-19', '2020-06-01', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (208, 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'MLSDZ-1-20200519-0022', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 2100000, 0, '2020-05-19', '2020-05-30', '无', NULL, 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (209, 'GqtVt8pJTE6umVLlJFVuIx0NgN0=', 'MLSDZ-2-20200103-0025', '2020-01-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZCz9ECefw', '06.03.03.007.0283', '2835阳光色贴片', 'S-BEN-30E-12M-03-F4C-7', 'MTR-0002', '返工生产', NULL, 155000, 103917, '2020-01-03', '2020-01-11', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (210, 'oLIUjor0TjWs4hpuEs1BfR0NgN0=', 'MLSDZ-2-20200324-0098', '2020-03-24', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdADKNECefw', '06.03.03.001.0562', '2835白色贴片', 'S-BEN-40E-31H-09-J21-1', 'MTR-0002', '返工生产', NULL, 75452, 0, '2020-03-24', '2020-03-31', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (211, '1WQHTuGhQJO4hbRNs5vARh0NgN0=', 'MLSDZ-2-20200411-0036', '2020-04-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexSAlECefw', '06.03.03.001.0953', '2835白色贴片', 'S-BEN-50G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 623523, 250000, '2020-04-11', '2020-04-11', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (212, 'APn638ZPQ0OefYwjuf82bh0NgN0=', 'MLSDZ-2-20200411-0040', '2020-04-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMnuNECefw', '06.03.03.007.0273', '2835阳光色贴片', 'S-BEN-27E-11M-03-F0E-9', 'MTR-0002', '返工生产', NULL, 396000, 0, '2020-04-11', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (213, 'uFFeu4peT9K6M3IkMJO9Wh0NgN0=', 'MLSDZ-2-20200416-0025', '2020-04-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexSAlECefw', '06.03.03.001.0953', '2835白色贴片', 'S-BEN-50G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 134000, 0, '2020-04-16', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (214, '9In3YA86RB+qUtcN+EBwbR0NgN0=', 'MLSDZ-2-20200416-0027', '2020-04-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABixvAFECefw', '06.03.03.001.1019', '2835白色贴片', 'S-BEN-50E-21M-06-K25-5', 'MTR-0002', '返工生产', NULL, 80000, 0, '2020-04-16', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (215, 'TPEcyaVtS/e5CxJ3q/dv7B0NgN0=', 'MLSDZ-2-20200416-0029', '2020-04-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABixvAFECefw', '06.03.03.001.1019', '2835白色贴片', 'S-BEN-50E-21M-06-K25-5', 'MTR-0002', '返工生产', NULL, 100000, 0, '2020-04-16', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (216, 'f9xiMLQjQnCZva1xHJepAh0NgN0=', 'MLSDZ-2-20200416-0070', '2020-04-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexS4lECefw', '06.03.03.007.0326', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 1946000, 1138680, '2020-04-16', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (217, '/wirNI8HTw+jyOA2Dkqfsh0NgN0=', 'MLSDZ-2-20200416-0072', '2020-04-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABhu6ntECefw', '06.03.03.001.1013', '2835白色贴片', 'S-XEN-40G-31H-09-H06-C', 'MTR-0002', '返工生产', NULL, 120000, 72000, '2020-04-16', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (218, 'vHqa+VZ3QkqMppGPEJneHx0NgN0=', 'MLSDZ-2-20200416-0073', '2020-04-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/alpECefw', '06.03.03.001.1103', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-E', 'MTR-0002', '返工生产', NULL, 370000, 0, '2020-04-16', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (219, 'NreJ6pLTQbq5jelOivHieh0NgN0=', 'MLSDZ-2-20200420-0148', '2020-04-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/bTRECefw', '06.03.03.001.1105', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-E', 'MTR-0002', '返工生产', NULL, 1065000, 0, '2020-04-20', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (220, 'KH8JkHUsRp+QjqPS0OCwpB0NgN0=', 'MLSDZ-2-20200420-0150', '2020-04-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtSi5ECefw', '06.03.03.001.1124', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-9', 'MTR-0002', '返工生产', NULL, 546145, 0, '2020-04-20', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (221, 'U9XnmweQT/i/bKFBHqbEnx0NgN0=', 'MLSDZ-2-20200420-0151', '2020-04-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlDfHhECefw', '06.03.03.007.0405', '2835阳光色贴片', 'S-BEN-27E-41H-12-K15-7', 'MTR-0002', '返工生产', NULL, 300000, 30000, '2020-04-20', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (222, '+zb/o+lPQ/WSsIjTSKjX5R0NgN0=', 'MLSDZ-2-20200420-0153', '2020-04-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexSAlECefw', '06.03.03.001.0953', '2835白色贴片', 'S-BEN-50G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 1030000, 0, '2020-04-20', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (223, 'fo4AajSWQGakNYBDV/leih0NgN0=', 'MLSDZ-2-20200420-0154', '2020-04-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZCbJECefw', '06.03.03.007.0280', '2835阳光色贴片', 'S-BEN-30E-31H-09-JC1-0', 'MTR-0002', '返工生产', NULL, 220000, 0, '2020-04-20', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (224, 'uTKnCMb5Q/6DEug1Q313Xx0NgN0=', 'MLSDZ-2-20200423-0105', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABc/84NECefw', '06.03.03.001.0530', '2835白色贴片', 'S-BEN-40E-11L-03-B32-B', 'MTR-0002', '返工生产', NULL, 420781, 396000, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (225, 'BwGzjRhRRfiYkeKt9eP+th0NgN0=', 'MLSDZ-2-20200423-0107', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXUo1ECefw', '06.03.03.007.0331', '2835阳光色贴片', 'S-BEN-27E-11L-03-BA4-6', 'MTR-0002', '返工生产', NULL, 70736, 0, '2020-04-23', '2020-04-23', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (226, '9e55xrx2QOKSDUlRh12RmB0NgN0=', 'MLSDZ-2-20200423-0108', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0002', '返工生产', NULL, 60000, 43407, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (227, 'zy9lpKpMRk+Woe3GHhsydx0NgN0=', 'MLSDZ-2-20200423-0110', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0002', '返工生产', NULL, 50000, 0, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (228, 'jvnI2727T+iNuqFIoDv+EB0NgN0=', 'MLSDZ-2-20200423-0113', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 29923, 0, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (229, '8xkbUwgaQl+po6AS3LgaLh0NgN0=', 'MLSDZ-2-20200423-0117', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0002', '返工生产', NULL, 70000, 0, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (230, 'fibg/+ezTu2RWP2EPbMxMx0NgN0=', 'MLSDZ-2-20200423-0119', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0002', '返工生产', NULL, 370000, 0, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (231, 'wPN4ULQ/RamLXO0U3EAcmR0NgN0=', 'MLSDZ-2-20200423-0121', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexS4lECefw', '06.03.03.007.0326', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 1300000, 632712, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (232, 'pMiqmVP7SGatDD4rTRI8fB0NgN0=', 'MLSDZ-2-20200423-0122', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNjNECefw', '06.03.03.001.0899', '2835白色贴片', 'S-XEN-50G-31H-09-H14-C', 'MTR-0002', '返工生产', NULL, 900000, 0, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (233, 'hDips8ptSceuaZhXyjvpbh0NgN0=', 'MLSDZ-2-20200423-0123', '2020-04-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexSAlECefw', '06.03.03.001.0953', '2835白色贴片', 'S-BEN-50G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 750000, 0, '2020-04-23', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (234, '+bUYAYolSIK6HebLGlVuvx0NgN0=', 'MLSDZ-2-20200425-0106', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtSZtECefw', '06.03.03.007.0479', '2835阳光色贴片', 'S-BEN-35E-11L-03-BB7-9', 'MTR-0002', '返工生产', NULL, 635000, 610616, '2020-04-25', '2020-04-25', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (235, '8ED4PD5gS6SFJjfQlLiwjB0NgN0=', 'MLSDZ-2-20200425-0107', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZChVECefw', '06.03.03.007.0284', '2835阳光色贴片', 'S-BEN-35E-12M-03-F4C-7', 'MTR-0002', '返工生产', NULL, 319382, 70000, '2020-04-25', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (236, 'E62SDME8Syqq+alygxgn4B0NgN0=', 'MLSDZ-2-20200425-0108', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdAFJJECefw', '06.03.03.001.0569', '2835白色贴片', 'S-BEN-40E-41H-12-K11-6', 'MTR-0002', '返工生产', NULL, 60000, 25305, '2020-04-25', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (237, '04tB5/h4ThSiOn6OxZZMPh0NgN0=', 'MLSDZ-2-20200425-0109', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdF0VNECefw', '06.03.03.004.0005', '2835红色贴片（植物照明）', 'S-BEN-PCR-11M-03-F16-4', 'MTR-0002', '返工生产', NULL, 65000, 21369, '2020-04-25', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (238, 'NqtJRfXnRUaztrRf9dImKx0NgN0=', 'MLSDZ-2-20200425-0121', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelDa1ECefw', '06.03.03.007.0296', '2835阳光色贴片', 'S-XEN-30G-31H-09-H15-C', 'MTR-0002', '返工生产', NULL, 139000, 135000, '2020-04-25', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (239, 'ISIwjasxRdGnGk+LBO72Kh0NgN0=', 'MLSDZ-2-20200425-0127', '2020-04-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABi9DKpECefw', '06.03.03.007.0392', '2835阳光色贴片', 'S-BEN-27E-31H-09-JG7-4', 'MTR-0002', '返工生产', NULL, 11859, 0, '2020-04-25', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (240, 'BItuW/saRoWtkpFEJzSt3h0NgN0=', 'MLSDZ-2-20200427-0052', '2020-04-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 100000, 62816, '2020-04-27', '2020-05-09', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (241, 'yAnt2nuFRXmdzRvU7F9p7B0NgN0=', 'MLSDZ-2-20200427-0053', '2020-04-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKqVECefw', '06.03.03.001.0906', '2835白色贴片', 'S-BEN-50G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 100000, 0, '2020-04-27', '2020-05-09', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (242, '0npkxoqSQmuSN3OtnVx5Oh0NgN0=', 'MLSDZ-2-20200427-0054', '2020-04-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 100000, 0, '2020-04-27', '2020-05-09', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (243, 'HMK103CUTPazbw3byMaU2B0NgN0=', 'MLSDZ-2-20200427-0055', '2020-04-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelLQRECefw', '06.03.03.007.0289', '2835阳光色贴片', 'S-BEN-27G-31H-09-JD6-F', 'MTR-0002', '返工生产', NULL, 100000, 0, '2020-04-27', '2020-05-09', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (244, 'MUctBc2DSG6SDErvN1JTDx0NgN0=', 'MLSDZ-2-20200427-0056', '2020-04-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMq9ECefw', '06.03.03.001.0907', '2835白色贴片', 'S-BEN-65G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 100000, 0, '2020-04-27', '2020-05-09', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (245, 'RX9AXFoURbS4NkeI5FgVnB0NgN0=', 'MLSDZ-2-20200427-0057', '2020-04-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', 'MTR-0002', '返工生产', NULL, 100000, 0, '2020-04-27', '2020-05-09', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (246, '4AkSsNzbT3SXyfQtMNlKgB0NgN0=', 'MLSDZ-2-20200427-0058', '2020-04-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBT6NECefw', '06.03.03.007.0154', '2835阳光色贴片', 'S-BEN-30G-31H-09-J76-4', 'MTR-0002', '返工生产', NULL, 100000, 53361, '2020-04-27', '2020-05-09', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (247, '3zrzH/FLRbqHwNLs43ucch0NgN0=', 'MLSDZ-2-20200428-0010', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMqEpECefw', '06.03.03.007.0276', '2835阳光色贴片', 'S-BEN-27E-12H-18-P06-3', 'MTR-0002', '返工生产', NULL, 245000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (248, 'EcFumlFvSduxYXyFxHDIwx0NgN0=', 'MLSDZ-2-20200428-0011', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdAOMRECefw', '06.03.03.007.0037', '2835阳光色贴片', 'S-BEN-27E-21H-06-L01-1', 'MTR-0002', '返工生产', NULL, 20000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (249, 'iDeD1Z9lTlWj67BMprNYWR0NgN0=', 'MLSDZ-2-20200428-0012', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlG8GRECefw', '06.03.03.007.0409', '2835阳光色贴片', 'S-BEN-27G-21H-18-P58-5', 'MTR-0002', '返工生产', NULL, 65000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (250, 'P7ucMZQGQVy7RdZZq2vAmB0NgN0=', 'MLSDZ-2-20200428-0013', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 500000, 105184, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (251, 'tDn7kpZHQqmQ8Tr7eCgGQB0NgN0=', 'MLSDZ-2-20200428-0014', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdADdRECefw', '06.03.03.007.0076', '2835阳光色贴片', 'S-BEN-27G-41H-12-K01-4', 'MTR-0002', '返工生产', NULL, 105000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (252, 'pIM9c9ACTvu4/zIpYu/vRR0NgN0=', 'MLSDZ-2-20200428-0015', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtLR5ECefw', '06.03.03.007.0478', '2835阳光色贴片', 'S-BEN-30E-11M-03-BB7-D', 'MTR-0002', '返工生产', NULL, 475000, 54660, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (253, 'TjAKrRfgT7iB0SvB+bcqRh0NgN0=', 'MLSDZ-2-20200428-0016', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMqepECefw', '06.03.03.007.0274', '2835阳光色贴片', 'S-BEN-30E-11M-03-F0E-9', 'MTR-0002', '返工生产', NULL, 545000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (254, 'tlLpEU6ZTFGVzQRZOYmPzR0NgN0=', 'MLSDZ-2-20200428-0017', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0002', '返工生产', NULL, 105000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (255, '4od6GhuNR9mMxoLHc3Q0XR0NgN0=', 'MLSDZ-2-20200428-0018', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexS4lECefw', '06.03.03.007.0326', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 320000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (256, 'GN27r5a4TjysMcMZOmAd7h0NgN0=', 'MLSDZ-2-20200428-0019', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 140000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (257, 'tLNb8q4iScuEHMcW2ZrJ8B0NgN0=', 'MLSDZ-2-20200428-0020', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeox5RECefw', '06.03.03.002.0015', '2835阳光色贴片', 'S-BEN-35G-11M-03-F0D-9', 'MTR-0002', '返工生产', NULL, 485000, 118733, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (258, '2aum8Mm7QHSVGWhdFzlzNh0NgN0=', 'MLSDZ-2-20200428-0021', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABc/84NECefw', '06.03.03.001.0530', '2835白色贴片', 'S-BEN-40E-11L-03-B32-B', 'MTR-0002', '返工生产', NULL, 396000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (259, 'wCltn1xbS6inLNC/Ciuk6h0NgN0=', 'MLSDZ-2-20200428-0022', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0002', '返工生产', NULL, 1134000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (260, 'LcI3KbI1S+OHsnVKQwWYgh0NgN0=', 'MLSDZ-2-20200428-0023', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo8ZNZECefw', '06.03.03.001.1100', '2835白色贴片', 'S-BEN-50E-11L-03-BB5-E', 'MTR-0002', '返工生产', NULL, 108000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (261, 'uqJtPHmwRYm459RhzDgSRh0NgN0=', 'MLSDZ-2-20200428-0024', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtLItECefw', '06.03.03.001.1125', '2835白色贴片', 'S-BEN-50E-11M-03-BB7-D', 'MTR-0002', '返工生产', NULL, 576000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (262, 'SGU0fzS6Qaut/J3n25cMKx0NgN0=', 'MLSDZ-2-20200428-0025', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMqrRECefw', '06.03.03.001.0872', '2835白色贴片', 'S-BEN-50E-11M-03-F0E-9', 'MTR-0002', '返工生产', NULL, 255000, 212222, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (263, 'YGorLrP6T6CK6CZLGIwcTB0NgN0=', 'MLSDZ-2-20200428-0026', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZGItECefw', '06.03.03.001.0880', '2835白色贴片', 'S-BEN-50E-31H-09-JC1-0', 'MTR-0002', '返工生产', NULL, 15000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (264, 'jZryNZ5qTva7+sj8945nbx0NgN0=', 'MLSDZ-2-20200428-0027', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexR4ZECefw', '06.03.03.001.0952', '2835白色贴片', 'S-BEN-50E-31H-09-JC7-E', 'MTR-0002', '返工生产', NULL, 75000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (265, 'eDS2V+ikQUG4Hl9DSOcefR0NgN0=', 'MLSDZ-2-20200428-0028', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexSAlECefw', '06.03.03.001.0953', '2835白色贴片', 'S-BEN-50G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 250000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (266, '/cC60BWARySnYGulffXfOB0NgN0=', 'MLSDZ-2-20200428-0029', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMrEZECefw', '06.03.03.001.0873', '2835白色贴片', 'S-BEN-57E-11M-03-F0E-9', 'MTR-0002', '返工生产', NULL, 45000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (267, 'ctjbDa+fTh6GVGHMsf9u7R0NgN0=', 'MLSDZ-2-20200428-0030', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZGCFECefw', '06.03.03.001.0885', '2835白色贴片', 'S-BEN-57E-12M-03-F4C-7', 'MTR-0002', '返工生产', NULL, 140000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (268, 'kWY3NA7RRc+ZkadWAv7XrR0NgN0=', 'MLSDZ-2-20200428-0031', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdF0bZECefw', '06.03.03.004.0006', '2835红色贴片（植物照明）', 'S-BEN-PCR-21H-06-N11-1', 'MTR-0002', '返工生产', NULL, 334135, 85909, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (269, 'KufcvZFpQxSFYUF75PkhQx0NgN0=', 'MLSDZ-2-20200428-0032', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexNk9ECefw', '06.03.03.001.0956', '2835白色贴片', 'S-BEN-57G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 280000, 250000, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (270, 'aMWYSJCESVWwu6jsYat30B0NgN0=', 'MLSDZ-2-20200428-0033', '2020-04-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABhu6ntECefw', '06.03.03.001.1013', '2835白色贴片', 'S-XEN-40G-31H-09-H06-C', 'MTR-0002', '返工生产', NULL, 72000, 0, '2020-04-28', '2020-04-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (271, '4dk/pCBjRLmiu4kYUnRl0B0NgN0=', 'MLSDZ-2-20200429-0001', '2020-04-29', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABmRrgFECefw', '06.03.03.007.0428', '2835阳光色贴片', 'S-SEN-27H-12M-03-F11-3', 'MTR-0002', '返工生产', NULL, 60000, 0, '2020-04-29', '2020-05-07', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (272, 'zaMsFWi/RT+n9CuYDvaU7x0NgN0=', 'MLSDZ-2-20200506-0084', '2020-05-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABhu5IlECefw', '06.03.03.007.0383', '2835阳光色贴片', 'S-XEN-30G-31H-09-H06-C', 'MTR-0002', '返工生产', NULL, 3000, 2159, '2020-05-06', '2020-05-16', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (273, 'M2F+LrQfRCeKUWdwhQw/jR0NgN0=', 'MLSDZ-2-20200506-0093', '2020-05-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABed8ShECefw', '06.03.03.001.0887', '2835白色贴片', 'S-BEN-40G-31H-09-JC1-0', 'MTR-0002', '返工生产', NULL, 222000, 82520, '2020-05-06', '2020-05-16', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (274, '2cKo7rCPRKePL156JVzAtB0NgN0=', 'MLSDZ-2-20200507-0066', '2020-05-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMn7JECefw', '06.03.03.001.0871', '2835白色贴片', 'S-BEN-40E-11M-03-F0E-9', 'MTR-0002', '返工生产', NULL, 550000, 0, '2020-05-07', '2020-05-12', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (275, 'kuf7rwT0TvilGUN/ME028h0NgN0=', 'MLSDZ-2-20200507-0068', '2020-05-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABek/fZECefw', '06.03.03.007.0295', '2835阳光色贴片', 'S-XEN-27G-31H-09-H15-C', 'MTR-0002', '返工生产', NULL, 69000, 68593, '2020-05-07', '2020-05-16', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (276, 'QpOK1ZgaSDSUmpJGvtjofB0NgN0=', 'MLSDZ-2-20200507-0070', '2020-05-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeowg1ECefw', '06.03.03.001.0919', '2835白色贴片', 'S-BEN-40G-11M-03-F0D-9', 'MTR-0002', '返工生产', NULL, 200000, 0, '2020-05-07', '2020-05-16', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);
INSERT INTO `eas_wo` VALUES (277, '8vz8MGvPQQWGDmmZ75WMXh0NgN0=', 'MLSDZ-2-20200518-0070', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKc5ECefw', '06.03.03.001.0905', '2835白色贴片', 'S-BEN-40G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 365000, 0, '2020-05-18', '2020-05-30', '无', '1,2,3', 0, 4, '2020-05-19 15:35:26', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3532 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '从木林森EAS同步的工单，需要用户手动转为我们系统的工单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eas_wo_dtl
-- ----------------------------
INSERT INTO `eas_wo_dtl` VALUES (1, 1, 'gJYAABtVdULtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 239, 239, 0, 239, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2, 1, 'gJYAABtVdT3tSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4087, 4087, 0, 4087, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (3, 1, 'gJYAABtVdTvtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 715, 715, 0, 715, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (4, 1, 'gJYAABtVdT7tSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 9909, 9909, 0, 9909, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (5, 1, 'gJYAABtVdUrtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (6, 1, 'gJYAABtVdUftSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (7, 1, 'gJYAABtVdUntSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1051, 1051, 0, 1051, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (8, 1, 'gJYAABtVdUDtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 10507, 10507, 0, 10507, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (9, 1, 'gJYAABtVdTztSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 78, 78, 0, 78, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (10, 1, 'gJYAABtVdUHtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 20142, 20142, 0, 20142, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (11, 1, 'gJYAABtVdUTtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 272, 272, 0, 272, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (12, 1, 'gJYAABtVdUPtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (13, 1, 'gJYAABtVdUXtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 272, 272, 0, 272, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (14, 1, 'gJYAABtVdUjtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 5004, 5004, 0, 5004, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (15, 1, 'gJYAABtVdUbtSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 20142, 20142, 0, 20142, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (16, 1, 'gJYAABtVdT/tSYg5', 'z9lNuwFIS8mhfJmVC15RJR0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 5004, 5004, 0, 5004, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (17, 2, 'gJYAABtXFb3tSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 170, 170, 0, 170, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (18, 2, 'gJYAABtXFcntSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 275, 275, 0, 275, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (19, 2, 'gJYAABtXFcztSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 5298, 5298, 0, 5298, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (20, 2, 'gJYAABtXFcLtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 30063, 30063, 0, 30063, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (21, 2, 'gJYAABtXFcrtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 133, 133, 0, 133, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (22, 2, 'gJYAABtXFcjtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 78, 78, 0, 78, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (23, 2, 'gJYAABtXFcDtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1349, 1349, 0, 1349, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (24, 2, 'gJYAABtXFb/tSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 13487, 13487, 0, 13487, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (25, 2, 'gJYAABtXFb7tSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 96, 96, 0, 96, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (26, 2, 'gJYAABtXFcvtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 26771, 26771, 0, 26771, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (27, 2, 'gJYAABtXFcftSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 26, 26, 0, 26, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (28, 2, 'gJYAABtXFcbtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 261, 261, 0, 261, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (29, 2, 'gJYAABtXFcPtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAABJZTI9ECefw', '02.03.20.002.1119', '平面支架', '2835E-20PCT-P0', '千个', 6651, 6651, 0, 6651, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (30, 2, 'gJYAABtXFcTtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1304, 1304, 0, 1304, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (31, 2, 'gJYAABtXFcXtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 26771, 26771, 0, 26771, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (32, 2, 'gJYAABtXFcHtSYg5', 'qgcJ12jORYa8hne8nD9csh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 19953, 19953, 0, 19953, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (33, 3, 'gJYAABtXFsbtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 178, 178, 0, 178, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (34, 3, 'gJYAABtXFrrtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 7649, 7649, 0, 7649, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (35, 3, 'gJYAABtXFsDtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 387, 387, 0, 387, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (36, 3, 'gJYAABtXFr/tSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 16241, 16241, 0, 16241, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (37, 3, 'gJYAABtXFrvtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (38, 3, 'gJYAABtXFsPtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (39, 3, 'gJYAABtXFr3tSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1722, 1722, 0, 1722, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (40, 3, 'gJYAABtXFsHtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 17222, 17222, 0, 17222, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (41, 3, 'gJYAABtXFrftSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 138, 138, 0, 138, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (42, 3, 'gJYAABtXFrztSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 33015, 33015, 0, 33015, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (43, 3, 'gJYAABtXFr7tSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 447, 447, 0, 447, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (44, 3, 'gJYAABtXFsTtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (45, 3, 'gJYAABtXFsXtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 447, 447, 0, 447, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (46, 3, 'gJYAABtXFrntSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 8203, 8203, 0, 8203, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (47, 3, 'gJYAABtXFrjtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 33015, 33015, 0, 33015, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (48, 3, 'gJYAABtXFsLtSYg5', 'ZbWNvVDLRw2MfeAwlxOvJx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 8203, 8203, 0, 8203, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (49, 4, 'gJYAABtXFvztSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 121, 121, 0, 121, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (50, 4, 'gJYAABtXFvbtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 62, 62, 0, 62, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (51, 4, 'gJYAABtXFvftSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 894, 894, 0, 894, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (52, 4, 'gJYAABtXFvDtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2575, 2575, 0, 2575, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (53, 4, 'gJYAABtXFu/tSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (54, 4, 'gJYAABtXFvvtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (55, 4, 'gJYAABtXFv3tSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 273, 273, 0, 273, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (56, 4, 'gJYAABtXFvjtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 2730, 2730, 0, 2730, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (57, 4, 'gJYAABtXFvLtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 20, 20, 0, 20, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (58, 4, 'gJYAABtXFvntSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 5234, 5234, 0, 5234, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (59, 4, 'gJYAABtXFvXtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 71, 71, 0, 71, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (60, 4, 'gJYAABtXFvrtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (61, 4, 'gJYAABtXFu7tSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 71, 71, 0, 71, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (62, 4, 'gJYAABtXFvTtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1300, 1300, 0, 1300, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (63, 4, 'gJYAABtXFvPtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5234, 5234, 0, 5234, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (64, 4, 'gJYAABtXFvHtSYg5', '1PoglxD4SMGRzxTg1h0Hkx0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1300, 1300, 0, 1300, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (65, 5, 'gJYAABtXFwPtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 3623, 3623, 0, 3623, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (66, 5, 'gJYAABtXFw7tSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 564, 564, 0, 0, 0, 2, 564);
INSERT INTO `eas_wo_dtl` VALUES (67, 5, 'gJYAABtXFwXtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8392, 8392, 0, 8392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (68, 5, 'gJYAABtXFwvtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (69, 5, 'gJYAABtXFwftSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (70, 5, 'gJYAABtXFw3tSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 412, 412, 0, 412, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (71, 5, 'gJYAABtXFwLtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4124, 4124, 0, 4124, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (72, 5, 'gJYAABtXFwTtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 24, 24, 0, 24, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (73, 5, 'gJYAABtXFwrtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8100, 8100, 0, 8100, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (74, 5, 'gJYAABtXFwDtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (75, 5, 'gJYAABtXFwjtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 79, 79, 0, 79, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (76, 5, 'gJYAABtXFwztSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAABJZTI9ECefw', '02.03.20.002.1119', '平面支架', '2835E-20PCT-P0', '千个', 2013, 2013, 0, 2013, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (77, 5, 'gJYAABtXFwbtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 394, 394, 0, 394, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (78, 5, 'gJYAABtXFwHtSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8100, 8100, 0, 8100, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (79, 5, 'gJYAABtXFwntSYg5', 'QIj229mmQSe8tWXmTfJveR0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 6038, 6038, 0, 6038, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (80, 6, 'gJYAABtXvc/tSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 88, 88, 0, 88, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (81, 6, 'gJYAABtXvdPtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1228, 1228, 0, 1228, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (82, 6, 'gJYAABtXvc7tSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 215, 215, 0, 215, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (83, 6, 'gJYAABtXvcftSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2977, 2977, 0, 2977, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (84, 6, 'gJYAABtXvc3tSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (85, 6, 'gJYAABtXvcntSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (86, 6, 'gJYAABtXvdDtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 316, 316, 0, 316, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (87, 6, 'gJYAABtXvdHtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 3157, 3157, 0, 3157, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (88, 6, 'gJYAABtXvdbtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 23, 23, 0, 23, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (89, 6, 'gJYAABtXvcjtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 6053, 6053, 0, 6053, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (90, 6, 'gJYAABtXvdXtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 82, 82, 0, 82, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (91, 6, 'gJYAABtXvdTtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (92, 6, 'gJYAABtXvcztSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 82, 82, 0, 82, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (93, 6, 'gJYAABtXvdLtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1504, 1504, 0, 1504, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (94, 6, 'gJYAABtXvcrtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6053, 6053, 0, 6053, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (95, 6, 'gJYAABtXvcvtSYg5', 'R7J9fhd1SNuSy7eCPps6XB0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 1504, 1504, 0, 1504, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (96, 7, 'gJYAABtXvj3tSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 18000, 18000, 0, 18000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (97, 7, 'gJYAABtXvkDtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 2533, 2533, 0, 2533, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (98, 7, 'gJYAABtXvj/tSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 6614, 6614, 0, 0, 0, 2, 6614);
INSERT INTO `eas_wo_dtl` VALUES (99, 7, 'gJYAABtXvjftSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 237, 237, 0, 0, 0, 2, 237);
INSERT INTO `eas_wo_dtl` VALUES (100, 7, 'gJYAABtXvjztSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 27120, 27120, 0, 27120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (101, 7, 'gJYAABtXvjvtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 100, 100, 0, 100, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (102, 7, 'gJYAABtXvjbtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 70, 70, 0, 70, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (103, 7, 'gJYAABtXvjrtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1208, 1208, 0, 1208, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (104, 7, 'gJYAABtXvjjtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 12080, 12080, 0, 12080, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (105, 7, 'gJYAABtXvkHtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 49, 49, 0, 49, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (106, 7, 'gJYAABtXvjTtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 24150, 24150, 0, 24150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (107, 7, 'gJYAABtXvjXtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 326, 326, 0, 326, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (108, 7, 'gJYAABtXvjPtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (109, 7, 'gJYAABtXvj7tSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 326, 326, 0, 326, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (110, 7, 'gJYAABtXvjntSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAABJZTI9ECefw', '02.03.20.002.1119', '平面支架', '2835E-20PCT-P0', '千个', 6000, 6000, 0, 6000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (111, 7, 'gJYAABtXvkLtSYg5', '7kE1p5LnSKub2WePV7Pu6h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 24150, 24150, 0, 24150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (112, 8, 'gJYAABtZebPtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 23513, 23513, 0, 23513, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (113, 8, 'gJYAABtZebTtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 507, 507, 0, 507, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (114, 8, 'gJYAABtZebHtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 2359, 2359, 0, 2359, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (115, 8, 'gJYAABtZebLtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 40911, 40911, 0, 40911, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (116, 8, 'gJYAABtZebXtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 104, 104, 0, 104, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (117, 8, 'gJYAABtZea7tSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 167, 167, 0, 167, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (118, 8, 'gJYAABtZebrtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 7315, 7315, 0, 7315, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (119, 8, 'gJYAABtZebDtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 73149, 73149, 0, 73149, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (120, 8, 'gJYAABtZea/tSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 480, 480, 0, 480, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (121, 8, 'gJYAABtZea3tSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 84014, 84014, 0, 84014, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (122, 8, 'gJYAABtZebntSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 82, 82, 0, 82, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (123, 8, 'gJYAABtZebvtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 818, 818, 0, 818, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (124, 8, 'gJYAABtZebztSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAABJZTI9ECefw', '02.03.20.002.1119', '平面支架', '2835E-20PCT-P0', '千个', 20873, 20873, 0, 20873, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (125, 8, 'gJYAABtZebbtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 4091, 4091, 0, 4091, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (126, 8, 'gJYAABtZebjtSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 84014, 84014, 0, 84014, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (127, 8, 'gJYAABtZebftSYg5', '+h0mTbNCStuXsBhCaSEIRh0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 20873, 20873, 0, 20873, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (128, 9, 'gJYAABtbr7DtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 30, 30, 0, 30, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (129, 9, 'gJYAABtbr6ztSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 48, 48, 0, 48, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (130, 9, 'gJYAABtbr6ftSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 793, 793, 0, 793, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (131, 9, 'gJYAABtbr7TtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5280, 5280, 0, 5280, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (132, 9, 'gJYAABtbr63tSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (133, 9, 'gJYAABtbr6rtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 14, 14, 0, 14, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (134, 9, 'gJYAABtbr6btSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 237, 237, 0, 237, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (135, 9, 'gJYAABtbr67tSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2369, 2369, 0, 2369, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (136, 9, 'gJYAABtbr6/tSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 17, 17, 0, 17, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (137, 9, 'gJYAABtbr7PtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4701, 4701, 0, 4701, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (138, 9, 'gJYAABtbr7HtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (139, 9, 'gJYAABtbr6vtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 46, 46, 0, 46, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (140, 9, 'gJYAABtbr6ntSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAABJZTI9ECefw', '02.03.20.002.1119', '平面支架', '2835E-20PCT-P0', '千个', 1168, 1168, 0, 1168, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (141, 9, 'gJYAABtbr7LtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 229, 229, 0, 229, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (142, 9, 'gJYAABtbr6jtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4701, 4701, 0, 4701, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (143, 9, 'gJYAABtbr6XtSYg5', 'ADa9hCuBQzukZY2grFQ16x0NgN0=', 'gJYAABctWJxECefw', '06.10.03.001.0074', 'DICE', 'S-DICE-BXCD1029(X10B)', '千个', 3504, 3504, 0, 3504, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (144, 10, 'gJYAABtbr+ztSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 30, 30, 0, 30, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (145, 10, 'gJYAABtbr+3tSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 48, 48, 0, 48, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (146, 10, 'gJYAABtbr+jtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 944, 944, 0, 944, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (147, 10, 'gJYAABtbr+XtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5278, 5278, 0, 5278, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (148, 10, 'gJYAABtbr+TtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (149, 10, 'gJYAABtbr+vtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 14, 14, 0, 14, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (150, 10, 'gJYAABtbr9/tSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 237, 237, 0, 237, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (151, 10, 'gJYAABtbr+DtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2368, 2368, 0, 2368, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (152, 10, 'gJYAABtbr+ftSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 17, 17, 0, 17, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (153, 10, 'gJYAABtbr97tSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4700, 4700, 0, 4700, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (154, 10, 'gJYAABtbr+PtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (155, 10, 'gJYAABtbr+ntSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 46, 46, 0, 46, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (156, 10, 'gJYAABtbr+rtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1168, 1168, 0, 1168, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (157, 10, 'gJYAABtbr+LtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 229, 229, 0, 229, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (158, 10, 'gJYAABtbr+HtSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4700, 4700, 0, 4700, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (159, 10, 'gJYAABtbr+btSYg5', 'kXTnpeQMRa2nK5XM12CY0x0NgN0=', 'gJYAABctWJxECefw', '06.10.03.001.0074', 'DICE', 'S-DICE-BXCD1029(X10B)', '千个', 3503, 3503, 0, 3503, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (160, 11, 'gJYAABtbsAvtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 16677, 16677, 0, 16677, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (161, 11, 'gJYAABtbsAntSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1013, 1013, 0, 0, 0, 2, 1013);
INSERT INTO `eas_wo_dtl` VALUES (162, 11, 'gJYAABtbsBTtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 367, 367, 0, 367, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (163, 11, 'gJYAABtbsArtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 878, 878, 0, 0, 0, 2, 878);
INSERT INTO `eas_wo_dtl` VALUES (164, 11, 'gJYAABtbsAXtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 32303, 32303, 0, 32303, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (165, 11, 'gJYAABtbsAbtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 155, 155, 0, 155, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (166, 11, 'gJYAABtbsBHtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 156, 156, 0, 156, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (167, 11, 'gJYAABtbsBXtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1665, 1665, 0, 1665, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (168, 11, 'gJYAABtbsAztSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 16648, 16648, 0, 16648, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (169, 11, 'gJYAABtbsA/tSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 194, 194, 0, 194, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (170, 11, 'gJYAABtbsAftSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 31179, 31179, 0, 31179, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (171, 11, 'gJYAABtbsBPtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 30, 30, 0, 60, 30, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (172, 11, 'gJYAABtbsA3tSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 304, 304, 0, 304, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (173, 11, 'gJYAABtbsBLtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 7746, 7746, 0, 7746, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (174, 11, 'gJYAABtbsAjtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1518, 1518, 0, 1518, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (175, 11, 'gJYAABtbsA7tSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 31179, 31179, 0, 31179, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (176, 11, 'gJYAABtbsBDtSYg5', 'QUpgvvzjSpChBH86IL7kKB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 23239, 23239, 0, 23239, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (177, 12, 'gJYAABtbsC3tSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 30, 30, 0, 30, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (178, 12, 'gJYAABtbsCftSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 48, 48, 0, 48, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (179, 12, 'gJYAABtbsCTtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 944, 944, 0, 944, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (180, 12, 'gJYAABtbsCPtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5274, 5274, 0, 5274, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (181, 12, 'gJYAABtbsCjtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (182, 12, 'gJYAABtbsDHtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 14, 14, 0, 14, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (183, 12, 'gJYAABtbsCLtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 237, 237, 0, 237, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (184, 12, 'gJYAABtbsCbtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2366, 2366, 0, 2366, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (185, 12, 'gJYAABtbsCrtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 17, 17, 0, 17, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (186, 12, 'gJYAABtbsC7tSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4696, 4696, 0, 4696, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (187, 12, 'gJYAABtbsDDtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (188, 12, 'gJYAABtbsCztSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 46, 46, 0, 46, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (189, 12, 'gJYAABtbsCvtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1167, 1167, 0, 1167, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (190, 12, 'gJYAABtbsC/tSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 229, 229, 0, 229, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (191, 12, 'gJYAABtbsCntSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4696, 4696, 0, 4696, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (192, 12, 'gJYAABtbsCXtSYg5', 'ixQmj45/SBu8xKNBJJN/mh0NgN0=', 'gJYAABctWJxECefw', '06.10.03.001.0074', 'DICE', 'S-DICE-BXCD1029(X10B)', '千个', 3500, 3500, 0, 3500, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (193, 13, 'gJYAABtbsSDtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 1720, 1720, 0, 1720, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (194, 13, 'gJYAABtbsSPtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 273, 273, 0, 0, 0, 2, 273);
INSERT INTO `eas_wo_dtl` VALUES (195, 13, 'gJYAABtbsSXtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4219, 4219, 0, 4219, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (196, 13, 'gJYAABtbsRztSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (197, 13, 'gJYAABtbsSTtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (198, 13, 'gJYAABtbsRrtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 207, 207, 0, 207, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (199, 13, 'gJYAABtbsSHtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2074, 2074, 0, 2074, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (200, 13, 'gJYAABtbsR3tSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 12, 12, 0, 12, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (201, 13, 'gJYAABtbsRvtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4072, 4072, 0, 4072, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (202, 13, 'gJYAABtbsSbtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (203, 13, 'gJYAABtbsRntSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (204, 13, 'gJYAABtbsR/tSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1012, 1012, 0, 1012, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (205, 13, 'gJYAABtbsSLtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 198, 198, 0, 198, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (206, 13, 'gJYAABtbsRjtSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4072, 4072, 0, 4072, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (207, 13, 'gJYAABtbsR7tSYg5', 'ye2apE+nSAK3gtLR1yc4Bx0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 3035, 3035, 0, 3035, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (208, 14, 'gJYAABtdgnHtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 10707, 10707, 0, 10707, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (209, 14, 'gJYAABtdgnntSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 560, 560, 0, 0, 0, 2, 560);
INSERT INTO `eas_wo_dtl` VALUES (210, 14, 'gJYAABtdgnPtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 583, 583, 0, 583, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (211, 14, 'gJYAABtdgnvtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 41706, 41706, 0, 41706, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (212, 14, 'gJYAABtdgnztSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 200, 200, 0, 200, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (213, 14, 'gJYAABtdgm7tSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (214, 14, 'gJYAABtdgnXtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2786, 2786, 0, 2786, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (215, 14, 'gJYAABtdgnLtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 27862, 27862, 0, 27862, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (216, 14, 'gJYAABtdgnDtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 251, 251, 0, 251, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (217, 14, 'gJYAABtdgn3tSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 40256, 40256, 0, 40256, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (218, 14, 'gJYAABtdgm/tSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 39, 39, 0, 0, 0, NULL, 39);
INSERT INTO `eas_wo_dtl` VALUES (219, 14, 'gJYAABtdgnbtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 392, 392, 0, 392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (220, 14, 'gJYAABtdgnjtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 10002, 10002, 0, 10002, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (221, 14, 'gJYAABtdgnftSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1960, 1960, 0, 1960, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (222, 14, 'gJYAABtdgnrtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 40256, 40256, 0, 40256, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (223, 14, 'gJYAABtdgnTtSYg5', 'E6lb6pjTRRGRUxDD5bsJWx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 30005, 30005, 0, 30005, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (224, 15, 'gJYAABtdgrHtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 300, 300, 0, 300, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (225, 15, 'gJYAABtdgqvtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 42, 42, 0, 42, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (226, 15, 'gJYAABtdgqrtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 120, 120, 0, 0, 0, 2, 120);
INSERT INTO `eas_wo_dtl` VALUES (227, 15, 'gJYAABtdgqftSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 4, 4, 0, 0, 0, 2, 4);
INSERT INTO `eas_wo_dtl` VALUES (228, 15, 'gJYAABtdgqntSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 452, 452, 0, 452, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (229, 15, 'gJYAABtdgqXtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (230, 15, 'gJYAABtdgqPtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (231, 15, 'gJYAABtdgq3tSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 20, 20, 0, 20, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (232, 15, 'gJYAABtdgqjtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 201, 201, 0, 201, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (233, 15, 'gJYAABtdgqTtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (234, 15, 'gJYAABtdgq7tSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 403, 403, 0, 403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (235, 15, 'gJYAABtdgrDtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (236, 15, 'gJYAABtdgqbtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (237, 15, 'gJYAABtdgqztSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (238, 15, 'gJYAABtdgqLtSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 100, 100, 0, 100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (239, 15, 'gJYAABtdgq/tSYg5', 'r+y8k03nRKWdGaEjdM9j4h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (240, 16, 'gJYAABtdl3ftSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 16500, 16500, 0, 21397, 4897, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (241, 16, 'gJYAABtdl3jtSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABXStRFECefw', '01.02.01.001.1250', '荧光粉', 'KSL210', '克', 2634, 2634, 0, 2634, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (242, 16, 'gJYAABtdl33tSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 9939, 9939, 0, 0, 0, 2, 9939);
INSERT INTO `eas_wo_dtl` VALUES (243, 16, 'gJYAABtdl3TtSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 350, 350, 0, 0, 0, 2, 350);
INSERT INTO `eas_wo_dtl` VALUES (244, 16, 'gJYAABtdl4DtSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 24860, 24860, 0, 24860, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (245, 16, 'gJYAABtdl3vtSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 92, 92, 0, 92, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (246, 16, 'gJYAABtdl4HtSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 64, 64, 0, 64, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (247, 16, 'gJYAABtdl3ztSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 822, 822, 0, 822, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (248, 16, 'gJYAABtdl37tSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 8223, 8223, 0, 8223, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (249, 16, 'gJYAABtdl3/tSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 22138, 22138, 0, 22138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (250, 16, 'gJYAABtdl4LtSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 299, 299, 0, 299, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (251, 16, 'gJYAABtdl3XtSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (252, 16, 'gJYAABtdl3rtSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 299, 299, 0, 299, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (253, 16, 'gJYAABtdl3ntSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 5500, 5500, 0, 5500, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (254, 16, 'gJYAABtdl3btSYg5', '0yb0Kl0aTduXceZ0GyaWyx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 22138, 22138, 0, 22138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (255, 17, 'gJYAABteJW/tSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 3300, 3300, 0, 3300, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (256, 17, 'gJYAABteJXXtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 464, 464, 0, 464, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (257, 17, 'gJYAABteJX7tSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1213, 1213, 0, 0, 0, 2, 1213);
INSERT INTO `eas_wo_dtl` VALUES (258, 17, 'gJYAABteJXLtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 43, 43, 0, 0, 0, 2, 43);
INSERT INTO `eas_wo_dtl` VALUES (259, 17, 'gJYAABteJXztSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 4972, 4972, 0, 4972, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (260, 17, 'gJYAABteJXvtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (261, 17, 'gJYAABteJXHtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (262, 17, 'gJYAABteJXTtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 221, 221, 0, 221, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (263, 17, 'gJYAABteJX3tSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2215, 2215, 0, 2215, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (264, 17, 'gJYAABteJXftSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 9, 9, 0, 9, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (265, 17, 'gJYAABteJXrtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4428, 4428, 0, 4428, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (266, 17, 'gJYAABteJXjtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (267, 17, 'gJYAABteJXDtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (268, 17, 'gJYAABteJXbtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (269, 17, 'gJYAABteJXntSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1100, 1100, 0, 1100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (270, 17, 'gJYAABteJXPtSYg5', '8ODPhHf/R6SsY07ujykPfR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4428, 4428, 0, 4428, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (271, 18, 'gJYAABte8IbtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 825, 825, 0, 825, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (272, 18, 'gJYAABte8JTtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 35439, 35439, 0, 35439, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (273, 18, 'gJYAABte8IntSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 1794, 1794, 0, 1794, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (274, 18, 'gJYAABte8JDtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 75247, 75247, 0, 75247, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (275, 18, 'gJYAABte8JPtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 190, 190, 0, 190, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (276, 18, 'gJYAABte8IjtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 304, 304, 0, 304, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (277, 18, 'gJYAABte8JHtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 7979, 7979, 0, 7979, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (278, 18, 'gJYAABte8I7tSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 79793, 79793, 0, 79793, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (279, 18, 'gJYAABte8I/tSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 638, 638, 0, 638, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (280, 18, 'gJYAABte8JXtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 152965, 152965, 0, 152965, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (281, 18, 'gJYAABte8IrtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 2069, 2069, 0, 2069, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (282, 18, 'gJYAABte8JLtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 188, 188, 0, 188, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (283, 18, 'gJYAABte8IvtSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 2069, 2069, 0, 2069, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (284, 18, 'gJYAABte8IztSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 38004, 38004, 0, 38004, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (285, 18, 'gJYAABte8IftSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 152965, 152965, 0, 152965, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (286, 18, 'gJYAABte8I3tSYg5', 'E5L6Y/4aSuWs2jj62cBPwR0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 38004, 38004, 0, 38004, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (287, 19, 'gJYAABtfHVTtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 5, 5, 0, 0, 0, 2, 5);
INSERT INTO `eas_wo_dtl` VALUES (288, 19, 'gJYAABtfHWDtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 5, 5, 0, 5, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (289, 19, 'gJYAABtfHVrtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 82, 82, 0, 82, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (290, 19, 'gJYAABtfHVjtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 197, 197, 0, 197, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (291, 19, 'gJYAABtfHVztSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (292, 19, 'gJYAABtfHWLtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (293, 19, 'gJYAABtfHVntSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 21, 21, 0, 21, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (294, 19, 'gJYAABtfHVftSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 211, 211, 0, 211, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (295, 19, 'gJYAABtfHV3tSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (296, 19, 'gJYAABtfHWHtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 405, 405, 0, 405, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (297, 19, 'gJYAABtfHVXtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (298, 19, 'gJYAABtfHVbtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (299, 19, 'gJYAABtfHWPtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (300, 19, 'gJYAABtfHV7tSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 101, 101, 0, 101, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (301, 19, 'gJYAABtfHVvtSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 405, 405, 0, 405, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (302, 19, 'gJYAABtfHV/tSYg5', 'gcTMcDS4Rh+UOnWO2m5/Dh0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 101, 101, 0, 101, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (303, 20, 'gJYAABtfHa7tSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 6763, 6763, 0, 6763, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (304, 20, 'gJYAABtfHbntSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 146, 146, 0, 0, 0, 2, 146);
INSERT INTO `eas_wo_dtl` VALUES (305, 20, 'gJYAABtfHbjtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 678, 678, 0, 678, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (306, 20, 'gJYAABtfHa/tSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 11767, 11767, 0, 11767, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (307, 20, 'gJYAABtfHbLtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (308, 20, 'gJYAABtfHaztSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 48, 48, 0, 48, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (309, 20, 'gJYAABtfHbPtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2104, 2104, 0, 2104, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (310, 20, 'gJYAABtfHbftSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 21039, 21039, 0, 21039, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (311, 20, 'gJYAABtfHbHtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 138, 138, 0, 138, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (312, 20, 'gJYAABtfHbvtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 24164, 24164, 0, 24164, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (313, 20, 'gJYAABtfHbbtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (314, 20, 'gJYAABtfHa3tSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 235, 235, 0, 235, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (315, 20, 'gJYAABtfHbTtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 6004, 6004, 0, 6004, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (316, 20, 'gJYAABtfHbrtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1177, 1177, 0, 1177, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (317, 20, 'gJYAABtfHbDtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 24164, 24164, 0, 38564, 14400, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (318, 20, 'gJYAABtfHbXtSYg5', 'NGe4SxDTTvSwXdvPEP7qZh0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 6004, 6004, 0, 6004, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (319, 21, 'gJYAABtfja3tSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 900, 900, 0, 900, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (320, 21, 'gJYAABtfja7tSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 127, 127, 0, 127, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (321, 21, 'gJYAABtfjbHtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 316, 316, 0, 0, 0, 2, 316);
INSERT INTO `eas_wo_dtl` VALUES (322, 21, 'gJYAABtfjavtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 12, 12, 0, 0, 0, 2, 12);
INSERT INTO `eas_wo_dtl` VALUES (323, 21, 'gJYAABtfjbDtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 1356, 1356, 0, 1356, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (324, 21, 'gJYAABtfjbrtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (325, 21, 'gJYAABtfjbTtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (326, 21, 'gJYAABtfja/tSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 60, 60, 0, 60, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (327, 21, 'gJYAABtfjbPtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 604, 604, 0, 604, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (328, 21, 'gJYAABtfjaztSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (329, 21, 'gJYAABtfjbbtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1208, 1208, 0, 1208, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (330, 21, 'gJYAABtfjbLtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (331, 21, 'gJYAABtfjbftSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (332, 21, 'gJYAABtfjbntSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (333, 21, 'gJYAABtfjbXtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 300, 300, 0, 300, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (334, 21, 'gJYAABtfjbjtSYg5', 'bFFZPcv4TQah5qkukLLYaB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1208, 1208, 0, 1208, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (335, 22, 'gJYAABtfjf3tSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 9300, 9300, 0, 9300, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (336, 22, 'gJYAABtfjgHtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABXStRFECefw', '01.02.01.001.1250', '荧光粉', 'KSL210', '克', 1250, 1250, 0, 1250, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (337, 22, 'gJYAABtfjfTtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 4546, 4546, 0, 0, 0, 2, 4546);
INSERT INTO `eas_wo_dtl` VALUES (338, 22, 'gJYAABtfjfbtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 152, 152, 0, 0, 0, 2, 152);
INSERT INTO `eas_wo_dtl` VALUES (339, 22, 'gJYAABtfjgLtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 14012, 14012, 0, 14012, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (340, 22, 'gJYAABtfjfftSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 52, 52, 0, 52, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (341, 22, 'gJYAABtfjf7tSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 36, 36, 0, 36, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (342, 22, 'gJYAABtfjfPtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 454, 454, 0, 454, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (343, 22, 'gJYAABtfjfztSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4545, 4545, 0, 4545, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (344, 22, 'gJYAABtfjfjtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 34, 34, 0, 34, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (345, 22, 'gJYAABtfjfXtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12478, 12478, 0, 12478, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (346, 22, 'gJYAABtfjgDtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 169, 169, 0, 169, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (347, 22, 'gJYAABtfjfrtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (348, 22, 'gJYAABtfjfntSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 169, 169, 0, 169, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (349, 22, 'gJYAABtfjf/tSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3100, 3100, 0, 3100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (350, 22, 'gJYAABtfjfvtSYg5', 'UPZN9O75QpOUGE4Mzdtv+x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12478, 12478, 0, 12478, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (351, 23, 'gJYAABtgGg7tSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 162, 162, 0, 0, 0, 2, 162);
INSERT INTO `eas_wo_dtl` VALUES (352, 23, 'gJYAABtgGhrtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 30, 30, 0, 30, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (353, 23, 'gJYAABtgGg/tSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 842, 842, 0, 842, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (354, 23, 'gJYAABtgGhDtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2198, 2198, 0, 2198, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (355, 23, 'gJYAABtgGhvtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (356, 23, 'gJYAABtgGhHtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (357, 23, 'gJYAABtgGhztSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 225, 225, 0, 225, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (358, 23, 'gJYAABtgGhntSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2251, 2251, 0, 2251, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (359, 23, 'gJYAABtgGhPtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 16, 16, 0, 16, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (360, 23, 'gJYAABtgGhftSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4468, 4468, 0, 4468, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (361, 23, 'gJYAABtgGhbtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (362, 23, 'gJYAABtgGhTtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 44, 44, 0, 44, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (363, 23, 'gJYAABtgGhXtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1110, 1110, 0, 1110, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (364, 23, 'gJYAABtgGhLtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 218, 218, 0, 218, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (365, 23, 'gJYAABtgGg3tSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4468, 4468, 0, 4468, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (366, 23, 'gJYAABtgGhjtSYg5', 'VR1EMcovSrGPC7ESRF875B0NgN0=', 'gJYAABctXHFECefw', '06.10.03.001.0089', 'DICE', 'S-DICE-BXCD1130', '千个', 1110, 1110, 0, 1110, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (367, 24, 'gJYAABtgGiTtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 25, 25, 0, 0, 0, 2, 25);
INSERT INTO `eas_wo_dtl` VALUES (368, 24, 'gJYAABtgGiXtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 24, 24, 0, 24, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (369, 24, 'gJYAABtgGiPtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 763, 763, 0, 763, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (370, 24, 'gJYAABtgGijtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAwdkHhECefw', '01.02.01.006.0066', '键合银丝', 'JHB-J-23um', '米', 2938, 2938, 0, 2938, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (371, 24, 'gJYAABtgGivtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (372, 24, 'gJYAABtgGintSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (373, 24, 'gJYAABtgGiDtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 203, 203, 0, 203, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (374, 24, 'gJYAABtgGiHtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2027, 2027, 0, 2027, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (375, 24, 'gJYAABtgGiLtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 14, 14, 0, 14, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (376, 24, 'gJYAABtgGi7tSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4023, 4023, 0, 4023, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (377, 24, 'gJYAABtgGi3tSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (378, 24, 'gJYAABtgGirtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (379, 24, 'gJYAABtgGh/tSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 999, 999, 0, 999, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (380, 24, 'gJYAABtgGiztSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 196, 196, 0, 196, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (381, 24, 'gJYAABtgGiftSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4023, 4023, 0, 4023, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (382, 24, 'gJYAABtgGibtSYg5', 'XIOkeCksTl+G0CamG9Mngh0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 1999, 1999, 0, 1999, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (383, 25, 'gJYAABtgk1/tSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 67, 67, 0, 0, 0, 2, 67);
INSERT INTO `eas_wo_dtl` VALUES (384, 25, 'gJYAABtgk17tSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1007, 1007, 0, 1007, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (385, 25, 'gJYAABtgk2HtSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2593, 2593, 0, 2593, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (386, 25, 'gJYAABtgk1vtSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (387, 25, 'gJYAABtgk2ntSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (388, 25, 'gJYAABtgk2btSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 467, 467, 0, 467, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (389, 25, 'gJYAABtgk2jtSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4669, 4669, 0, 4669, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (390, 25, 'gJYAABtgk2TtSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 34, 34, 0, 34, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (391, 25, 'gJYAABtgk2PtSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5271, 5271, 0, 5271, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (392, 25, 'gJYAABtgk2XtSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (393, 25, 'gJYAABtgk2DtSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 51, 51, 0, 51, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (394, 25, 'gJYAABtgk2ftSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1310, 1310, 0, 1310, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (395, 25, 'gJYAABtgk1ztSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 257, 257, 0, 307, 50, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (396, 25, 'gJYAABtgk2LtSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5271, 5271, 0, 5271, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (397, 25, 'gJYAABtgk13tSYg5', 'mgmHnvQNQIyvUsj1zL8Sfh0NgN0=', 'gJYAABctXHFECefw', '06.10.03.001.0089', 'DICE', 'S-DICE-BXCD1130', '千个', 1310, 1310, 0, 1310, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (398, 26, 'gJYAABtgk4ztSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 173, 173, 0, 173, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (399, 26, 'gJYAABtgk5HtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 11410, 11410, 0, 11410, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (400, 26, 'gJYAABtgk4jtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 429, 429, 0, 429, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (401, 26, 'gJYAABtgk47tSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAwdkHhECefw', '01.02.01.006.0066', '键合银丝', 'JHB-J-23um', '米', 29708, 29708, 0, 29708, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (402, 26, 'gJYAABtgk4XtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (403, 26, 'gJYAABtgk4TtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (404, 26, 'gJYAABtgk4ntSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 3150, 3150, 0, 3150, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (405, 26, 'gJYAABtgk4vtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 31502, 31502, 0, 31502, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (406, 26, 'gJYAABtgk5DtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 233, 233, 0, 233, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (407, 26, 'gJYAABtgk4ftSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 60391, 60391, 0, 60391, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (408, 26, 'gJYAABtgk4LtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 817, 817, 0, 817, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (409, 26, 'gJYAABtgk4btSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 74, 74, 0, 74, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (410, 26, 'gJYAABtgk43tSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 817, 817, 0, 817, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (411, 26, 'gJYAABtgk4/tSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 15004, 15004, 0, 15004, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (412, 26, 'gJYAABtgk4rtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 60391, 60391, 0, 60391, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (413, 26, 'gJYAABtgk4PtSYg5', '8jqQoYwfStaoBFBgTTblBh0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 15004, 15004, 0, 15004, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (414, 27, 'gJYAABtgk6DtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 208, 208, 0, 0, 0, 2, 208);
INSERT INTO `eas_wo_dtl` VALUES (415, 27, 'gJYAABtgk6PtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 989, 989, 0, 989, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (416, 27, 'gJYAABtgk6vtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 6187, 6187, 0, 6187, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (417, 27, 'gJYAABtgk6ftSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 36804, 36804, 0, 36804, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (418, 27, 'gJYAABtgk53tSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 163, 163, 0, 163, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (419, 27, 'gJYAABtgk6HtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 95, 95, 0, 95, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (420, 27, 'gJYAABtgk6jtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1651, 1651, 0, 1651, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (421, 27, 'gJYAABtgk5/tSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 16511, 16511, 0, 16511, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (422, 27, 'gJYAABtgk6TtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 118, 118, 0, 118, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (423, 27, 'gJYAABtgk6ntSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 32774, 32774, 0, 32774, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (424, 27, 'gJYAABtgk6XtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (425, 27, 'gJYAABtgk6ztSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 319, 319, 0, 319, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (426, 27, 'gJYAABtgk57tSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 8143, 8143, 0, 8143, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (427, 27, 'gJYAABtgk6btSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1596, 1596, 0, 1596, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (428, 27, 'gJYAABtgk6rtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 32774, 32774, 0, 32774, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (429, 27, 'gJYAABtgk6LtSYg5', '8unmsOOiQW2Kpflm2k2S7x0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 24428, 24428, 0, 24428, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (430, 28, 'gJYAABtgk77tSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 1185, 1185, 0, 1185, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (431, 28, 'gJYAABtgk7jtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 3094, 3094, 0, 0, 0, 2, 3094);
INSERT INTO `eas_wo_dtl` VALUES (432, 28, 'gJYAABtgk7ntSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 111, 111, 0, 0, 0, 2, 111);
INSERT INTO `eas_wo_dtl` VALUES (433, 28, 'gJYAABtgk7PtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 12686, 12686, 0, 12686, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (434, 28, 'gJYAABtgk7ftSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 47, 47, 0, 47, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (435, 28, 'gJYAABtgk7TtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (436, 28, 'gJYAABtgk7rtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 565, 565, 0, 565, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (437, 28, 'gJYAABtgk8DtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5651, 5651, 0, 5651, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (438, 28, 'gJYAABtgk8LtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 23, 23, 0, 23, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (439, 28, 'gJYAABtgk7vtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 11297, 11297, 0, 11297, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (440, 28, 'gJYAABtgk7XtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 153, 153, 0, 153, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (441, 28, 'gJYAABtgk73tSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 14, 14, 0, 14, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (442, 28, 'gJYAABtgk7btSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 153, 153, 0, 153, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (443, 28, 'gJYAABtgk7ztSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2807, 2807, 0, 2807, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (444, 28, 'gJYAABtgk7/tSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 11297, 11297, 0, 11297, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (445, 28, 'gJYAABtgk8HtSYg5', 'lADTdiKZS66WG+q3wmCZ8B0NgN0=', 'gJYAABctWP5ECefw', '06.10.03.001.0077', 'DICE', 'S-DICE-BXCD11334', '千个', 8420, 8420, 0, 8420, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (446, 29, 'gJYAABtgk9jtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 487, 487, 0, 487, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (447, 29, 'gJYAABtgk9LtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1270, 1270, 0, 0, 0, 2, 1270);
INSERT INTO `eas_wo_dtl` VALUES (448, 29, 'gJYAABtgk9PtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 46, 46, 0, 0, 0, 2, 46);
INSERT INTO `eas_wo_dtl` VALUES (449, 29, 'gJYAABtgk83tSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 5209, 5209, 0, 5209, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (450, 29, 'gJYAABtgk9HtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 19, 19, 0, 19, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (451, 29, 'gJYAABtgk87tSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (452, 29, 'gJYAABtgk9TtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 232, 232, 0, 232, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (453, 29, 'gJYAABtgk9rtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2320, 2320, 0, 2320, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (454, 29, 'gJYAABtgk9ztSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 9, 9, 0, 9, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (455, 29, 'gJYAABtgk9XtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4639, 4639, 0, 4639, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (456, 29, 'gJYAABtgk8/tSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 63, 63, 0, 63, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (457, 29, 'gJYAABtgk9ftSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (458, 29, 'gJYAABtgk9DtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 63, 63, 0, 63, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (459, 29, 'gJYAABtgk9btSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1153, 1153, 0, 1153, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (460, 29, 'gJYAABtgk9ntSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4639, 4639, 0, 4639, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (461, 29, 'gJYAABtgk9vtSYg5', 'Ji5bI1efRMa3ErZsyP4/eR0NgN0=', 'gJYAABctWP5ECefw', '06.10.03.001.0077', 'DICE', 'S-DICE-BXCD11334', '千个', 3458, 3458, 0, 3458, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (462, 30, 'gJYAABth84PtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 232, 232, 0, 0, 0, 2, 232);
INSERT INTO `eas_wo_dtl` VALUES (463, 30, 'gJYAABth84/tSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 42, 42, 0, 42, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (464, 30, 'gJYAABth84TtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1210, 1210, 0, 1210, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (465, 30, 'gJYAABth84XtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 3158, 3158, 0, 3158, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (466, 30, 'gJYAABth85DtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (467, 30, 'gJYAABth84btSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (468, 30, 'gJYAABth85HtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 323, 323, 0, 323, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (469, 30, 'gJYAABth847tSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3235, 3235, 0, 3235, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (470, 30, 'gJYAABth84jtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 23, 23, 0, 23, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (471, 30, 'gJYAABth84ztSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6421, 6421, 0, 6421, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (472, 30, 'gJYAABth84vtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (473, 30, 'gJYAABth84ntSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 63, 63, 0, 63, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (474, 30, 'gJYAABth84rtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1595, 1595, 0, 1595, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (475, 30, 'gJYAABth84ftSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 313, 313, 0, 313, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (476, 30, 'gJYAABth84LtSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6421, 6421, 0, 6421, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (477, 30, 'gJYAABth843tSYg5', 'uE/RdOLmQqmI7aaJ7JkWSx0NgN0=', 'gJYAABctXHFECefw', '06.10.03.001.0089', 'DICE', 'S-DICE-BXCD1130', '千个', 1595, 1595, 0, 1595, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (478, 31, 'gJYAABth85ftSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 845, 845, 0, 845, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (479, 31, 'gJYAABth86PtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 2408, 2408, 0, 0, 0, 2, 2408);
INSERT INTO `eas_wo_dtl` VALUES (480, 31, 'gJYAABth85XtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 79, 79, 0, 0, 0, 2, 79);
INSERT INTO `eas_wo_dtl` VALUES (481, 31, 'gJYAABth857tSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 9047, 9047, 0, 9047, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (482, 31, 'gJYAABth85rtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (483, 31, 'gJYAABth85ntSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (484, 31, 'gJYAABth86LtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 403, 403, 0, 403, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (485, 31, 'gJYAABth86HtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4030, 4030, 0, 4030, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (486, 31, 'gJYAABth85TtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 16, 16, 0, 16, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (487, 31, 'gJYAABth86DtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8056, 8056, 0, 8056, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (488, 31, 'gJYAABth85jtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 109, 109, 0, 109, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (489, 31, 'gJYAABth85ztSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (490, 31, 'gJYAABth853tSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 109, 109, 0, 109, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (491, 31, 'gJYAABth85btSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2002, 2002, 0, 2002, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (492, 31, 'gJYAABth85vtSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8056, 8056, 0, 8056, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (493, 31, 'gJYAABth85/tSYg5', 'Vc4e1eFbS+Cb9LhtVPMf5h0NgN0=', 'gJYAABctWP5ECefw', '06.10.03.001.0077', 'DICE', 'S-DICE-BXCD11334', '千个', 6005, 6005, 0, 6005, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (494, 32, 'gJYAABtjj5DtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAABiChQBECefw', '01.01.01.010.3459', 'DICE', 'DICE-BPA0F11A', '千个', 9968, 9968, 0, 9968, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (495, 32, 'gJYAABtjj53tSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 4437, 4437, 0, 2044, 0, 2, 2393);
INSERT INTO `eas_wo_dtl` VALUES (496, 32, 'gJYAABtjj5LtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 750, 750, 0, 750, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (497, 32, 'gJYAABtjj5ztSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAABcwNiFECefw', '01.02.01.006.0082', '银线', 'JHB_K_18um', '米', 15749, 15749, 0, 15749, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (498, 32, 'gJYAABtjj5ftSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAAAAFAP9ECefw', '01.02.01.100.0054', '瓷嘴', 'MH-008', '个', 56, 56, 0, 56, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (499, 32, 'gJYAABtjj5vtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 1300, 1300, 0, 1300, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (500, 32, 'gJYAABtjj5HtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 13004, 13004, 0, 13004, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (501, 32, 'gJYAABtjj5rtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 77, 77, 0, 77, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (502, 32, 'gJYAABtjj5jtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (503, 32, 'gJYAABtjj5PtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAAAAFD8RECefw', '01.02.13.080.0031', '纯铝袋', '纯铝袋47cm*50cm*12c', '个', 116, 116, 0, 116, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (504, 32, 'gJYAABtjj5XtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAAA+DghFECefw', '02.02.02.002.0015', '胶水', 'MS-042', '克', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (505, 32, 'gJYAABtjj4/tSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 9968, 9968, 0, 9968, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (506, 32, 'gJYAABtjj5ntSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 345, 345, 0, 345, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (507, 32, 'gJYAABtjj5btSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 40121, 40121, 0, 40121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (508, 32, 'gJYAABtjj5TtSYg5', 'CPEDb9mMSXOmge31PJgU+B0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 40121, 40121, 0, 40121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (509, 33, 'gJYAABtkZintSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 1490, 1490, 0, 0, 0, 2, 1490);
INSERT INTO `eas_wo_dtl` VALUES (510, 33, 'gJYAABtkZibtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 496, 496, 0, 496, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (511, 33, 'gJYAABtkZirtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 7934, 7934, 0, 7934, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (512, 33, 'gJYAABtkZiTtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 20599, 20599, 0, 20599, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (513, 33, 'gJYAABtkZh3tSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 52, 52, 0, 52, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (514, 33, 'gJYAABtkZijtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (515, 33, 'gJYAABtkZh7tSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 2184, 2184, 0, 2184, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (516, 33, 'gJYAABtkZiHtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 21844, 21844, 0, 21844, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (517, 33, 'gJYAABtkZhztSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 161, 161, 0, 161, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (518, 33, 'gJYAABtkZiPtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 41875, 41875, 0, 41875, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (519, 33, 'gJYAABtkZiLtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 566, 566, 0, 566, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (520, 33, 'gJYAABtkZiDtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 51, 51, 0, 51, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (521, 33, 'gJYAABtkZh/tSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 566, 566, 0, 566, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (522, 33, 'gJYAABtkZiftSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 10404, 10404, 0, 10404, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (523, 33, 'gJYAABtkZivtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 41875, 41875, 0, 41875, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (524, 33, 'gJYAABtkZiXtSYg5', 'R4XEdcjeQXmhtBJdBcUWrh0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 10404, 10404, 0, 10404, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (525, 34, 'gJYAABtkZk3tSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 155, 155, 0, 0, 0, 2, 155);
INSERT INTO `eas_wo_dtl` VALUES (526, 34, 'gJYAABtkZlztSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 12, 12, 0, 12, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (527, 34, 'gJYAABtkZlXtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 976, 976, 0, 976, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (528, 34, 'gJYAABtkZlTtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5170, 5170, 0, 5170, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (529, 34, 'gJYAABtkZlftSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (530, 34, 'gJYAABtkZlLtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 73, 73, 0, 73, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (531, 34, 'gJYAABtkZk/tSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 171, 171, 0, 171, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (532, 34, 'gJYAABtkZlntSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1713, 1713, 0, 1713, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (533, 34, 'gJYAABtkZlvtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 22, 22, 0, 22, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (534, 34, 'gJYAABtkZlbtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 3926, 3926, 0, 3926, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (535, 34, 'gJYAABtkZlDtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (536, 34, 'gJYAABtkZk7tSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 38, 38, 0, 38, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (537, 34, 'gJYAABtkZlPtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 975, 975, 0, 975, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (538, 34, 'gJYAABtkZljtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 191, 191, 0, 191, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (539, 34, 'gJYAABtkZlrtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 3926, 3926, 0, 3926, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (540, 34, 'gJYAABtkZlHtSYg5', 'ueqbjUAvT+yik7HvpGllNx0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 3902, 3902, 0, 3902, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (541, 35, 'gJYAABtkZmrtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 38, 38, 0, 0, 0, 2, 38);
INSERT INTO `eas_wo_dtl` VALUES (542, 35, 'gJYAABtkZmPtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 182, 182, 0, 182, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (543, 35, 'gJYAABtkZmftSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1215, 1215, 0, 1215, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (544, 35, 'gJYAABtkZm3tSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6783, 6783, 0, 6783, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (545, 35, 'gJYAABtkZm7tSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (546, 35, 'gJYAABtkZmTtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (547, 35, 'gJYAABtkZm/tSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 304, 304, 0, 304, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (548, 35, 'gJYAABtkZmLtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3043, 3043, 0, 3043, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (549, 35, 'gJYAABtkZmbtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 22, 22, 0, 22, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (550, 35, 'gJYAABtkZmjtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6040, 6040, 0, 6040, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (551, 35, 'gJYAABtkZmntSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (552, 35, 'gJYAABtkZmXtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 59, 59, 0, 59, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (553, 35, 'gJYAABtkZmztSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1501, 1501, 0, 1501, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (554, 35, 'gJYAABtkZmHtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 294, 294, 0, 294, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (555, 35, 'gJYAABtkZmDtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6040, 6040, 0, 6040, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (556, 35, 'gJYAABtkZmvtSYg5', 'PVZkxpKQStWEcjDVVktYdh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 4502, 4502, 0, 4502, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (557, 36, 'gJYAABtkZo7tSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2881, 2881, 0, 2881, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (558, 36, 'gJYAABtkZoLtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 373, 373, 0, 373, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (559, 36, 'gJYAABtkZo3tSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7066, 7066, 0, 7066, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (560, 36, 'gJYAABtkZoztSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (561, 36, 'gJYAABtkZobtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (562, 36, 'gJYAABtkZoTtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 347, 347, 0, 347, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (563, 36, 'gJYAABtkZoXtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3473, 3473, 0, 3473, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (564, 36, 'gJYAABtkZoHtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 20, 20, 0, 20, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (565, 36, 'gJYAABtkZoftSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6820, 6820, 0, 6820, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (566, 36, 'gJYAABtkZoPtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (567, 36, 'gJYAABtkZoDtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 66, 66, 0, 66, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (568, 36, 'gJYAABtkZovtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1694, 1694, 0, 1694, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (569, 36, 'gJYAABtkZortSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 332, 332, 0, 332, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (570, 36, 'gJYAABtkZontSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6820, 6820, 0, 6820, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (571, 36, 'gJYAABtkZojtSYg5', '/wvbrhPaRnmg1SlkCyaRVx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 5083, 5083, 0, 5083, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (572, 37, 'gJYAABtkZpftSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 17387, 17387, 0, 17387, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (573, 37, 'gJYAABtkZpztSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1797, 1797, 0, 1627, 0, 2, 169);
INSERT INTO `eas_wo_dtl` VALUES (574, 37, 'gJYAABtkZpvtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 206, 206, 0, 206, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (575, 37, 'gJYAABtkZqbtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 42063, 42063, 0, 42063, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (576, 37, 'gJYAABtkZprtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 202, 202, 0, 202, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (577, 37, 'gJYAABtkZqPtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 203, 203, 0, 203, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (578, 37, 'gJYAABtkZqXtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2759, 2759, 0, 2759, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (579, 37, 'gJYAABtkZqLtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 27593, 27593, 0, 27593, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (580, 37, 'gJYAABtkZpjtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 266, 266, 0, 266, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (581, 37, 'gJYAABtkZpntSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 40600, 40600, 0, 40600, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (582, 37, 'gJYAABtkZp7tSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (583, 37, 'gJYAABtkZqHtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 395, 395, 0, 395, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (584, 37, 'gJYAABtkZqTtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 10087, 10087, 0, 10087, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (585, 37, 'gJYAABtkZp/tSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1977, 1977, 0, 1977, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (586, 37, 'gJYAABtkZqDtSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 40600, 40600, 0, 40600, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (587, 37, 'gJYAABtkZp3tSYg5', 'crSHPyj6Sd2FTJaKDtnTzx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 30261, 30261, 0, 30261, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (588, 38, 'gJYAABtlJd/tSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 22288, 22288, 0, 22288, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (589, 38, 'gJYAABtlJd7tSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1314, 1314, 0, 0, 0, 2, 1314);
INSERT INTO `eas_wo_dtl` VALUES (590, 38, 'gJYAABtlJeXtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 423, 423, 0, 423, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (591, 38, 'gJYAABtlJeHtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 1171, 1171, 0, 0, 0, 2, 1171);
INSERT INTO `eas_wo_dtl` VALUES (592, 38, 'gJYAABtlJeztSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 41705, 41705, 0, 41705, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (593, 38, 'gJYAABtlJertSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 200, 200, 0, 200, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (594, 38, 'gJYAABtlJeLtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (595, 38, 'gJYAABtlJePtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2224, 2224, 0, 2224, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (596, 38, 'gJYAABtlJe3tSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 22238, 22238, 0, 22238, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (597, 38, 'gJYAABtlJevtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 234, 234, 0, 234, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (598, 38, 'gJYAABtlJeftSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 40255, 40255, 0, 40255, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (599, 38, 'gJYAABtlJeTtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (600, 38, 'gJYAABtlJd3tSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 392, 392, 0, 392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (601, 38, 'gJYAABtlJebtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 10001, 10001, 0, 10001, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (602, 38, 'gJYAABtlJentSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1960, 1960, 0, 1960, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (603, 38, 'gJYAABtlJejtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 40255, 40255, 0, 40255, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (604, 38, 'gJYAABtlJeDtSYg5', 'vK5sWRykTvOxeGD6SgWawh0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 30004, 30004, 0, 30004, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (605, 39, 'gJYAABtlJgvtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 203, 203, 0, 203, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (606, 39, 'gJYAABtlJhXtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 202, 202, 0, 202, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (607, 39, 'gJYAABtlJgjtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3525, 3525, 0, 3525, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (608, 39, 'gJYAABtlJgztSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8303, 8303, 0, 8303, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (609, 39, 'gJYAABtlJg/tSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (610, 39, 'gJYAABtlJhHtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (611, 39, 'gJYAABtlJg7tSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 889, 889, 0, 889, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (612, 39, 'gJYAABtlJhPtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 8894, 8894, 0, 8894, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (613, 39, 'gJYAABtlJhTtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 66, 66, 0, 66, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (614, 39, 'gJYAABtlJhbtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 17050, 17050, 0, 17050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (615, 39, 'gJYAABtlJg3tSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 228, 228, 0, 228, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (616, 39, 'gJYAABtlJhDtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (617, 39, 'gJYAABtlJgntSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 233, 233, 0, 233, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (618, 39, 'gJYAABtlJhLtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 4236, 4236, 0, 4236, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (619, 39, 'gJYAABtlJgrtSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 17050, 17050, 0, 17050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (620, 39, 'gJYAABtlJhftSYg5', '7b1mi8DARXqSFDotQoKlCh0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 4236, 4236, 0, 4236, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (621, 40, 'gJYAABtmjsLtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 5700, 5700, 0, 5700, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (622, 40, 'gJYAABtmjsHtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 802, 802, 0, 802, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (623, 40, 'gJYAABtmjsTtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 2286, 2286, 0, 0, 0, 2, 2286);
INSERT INTO `eas_wo_dtl` VALUES (624, 40, 'gJYAABtmjsXtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 75, 75, 0, 0, 0, 2, 75);
INSERT INTO `eas_wo_dtl` VALUES (625, 40, 'gJYAABtmjsDtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 8588, 8588, 0, 8588, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (626, 40, 'gJYAABtmjr7tSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (627, 40, 'gJYAABtmjsbtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (628, 40, 'gJYAABtmjrvtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 382, 382, 0, 382, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (629, 40, 'gJYAABtmjr/tSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3825, 3825, 0, 3825, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (630, 40, 'gJYAABtmjrrtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 16, 16, 0, 16, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (631, 40, 'gJYAABtmjsftSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7648, 7648, 0, 7648, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (632, 40, 'gJYAABtmjsntSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 103, 103, 0, 103, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (633, 40, 'gJYAABtmjsjtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (634, 40, 'gJYAABtmjrztSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 103, 103, 0, 103, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (635, 40, 'gJYAABtmjr3tSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1900, 1900, 0, 1900, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (636, 40, 'gJYAABtmjsPtSYg5', 'D7JpzaEyRO+vf32DYqnQTx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7648, 7648, 0, 7648, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (637, 41, 'gJYAABtmjuPtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 5550, 5550, 0, 5550, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (638, 41, 'gJYAABtmjuDtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABXStV1ECefw', '01.02.01.001.1249', '荧光粉', 'KSL410', '克', 714, 714, 0, 714, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (639, 41, 'gJYAABtmjubtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1622, 1622, 0, 0, 0, 2, 1622);
INSERT INTO `eas_wo_dtl` VALUES (640, 41, 'gJYAABtmjuXtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 16, 16, 0, 0, 0, 2, 16);
INSERT INTO `eas_wo_dtl` VALUES (641, 41, 'gJYAABtmjuTtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 8362, 8362, 0, 8362, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (642, 41, 'gJYAABtmjuftSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (643, 41, 'gJYAABtmjt/tSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (644, 41, 'gJYAABtmjuntSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 324, 324, 0, 324, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (645, 41, 'gJYAABtmjt3tSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3245, 3245, 0, 3245, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (646, 41, 'gJYAABtmjujtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 26, 26, 0, 26, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (647, 41, 'gJYAABtmjuHtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7446, 7446, 0, 7446, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (648, 41, 'gJYAABtmjurtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 101, 101, 0, 101, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (649, 41, 'gJYAABtmjt7tSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (650, 41, 'gJYAABtmjuLtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 101, 101, 0, 101, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (651, 41, 'gJYAABtmjtztSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1850, 1850, 0, 1850, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (652, 41, 'gJYAABtmjuvtSYg5', '5MUT1lPaTn+b24VMuBj9cR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7446, 7446, 0, 7446, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (653, 42, 'gJYAABtmkVHtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 5102, 5102, 0, 5102, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (654, 42, 'gJYAABtmkVbtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 840, 840, 0, 840, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (655, 42, 'gJYAABtmkU/tSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 12514, 12514, 0, 12514, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (656, 42, 'gJYAABtmkVDtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (657, 42, 'gJYAABtmkVftSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (658, 42, 'gJYAABtmkUztSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 615, 615, 0, 615, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (659, 42, 'gJYAABtmkVXtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6150, 6150, 0, 6150, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (660, 42, 'gJYAABtmkUntSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 36, 36, 0, 36, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (661, 42, 'gJYAABtmkVTtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12079, 12079, 0, 12079, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (662, 42, 'gJYAABtmkUvtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (663, 42, 'gJYAABtmkU3tSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 118, 118, 0, 118, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (664, 42, 'gJYAABtmkU7tSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3001, 3001, 0, 3001, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (665, 42, 'gJYAABtmkVLtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 588, 588, 0, 588, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (666, 42, 'gJYAABtmkVPtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12079, 12079, 0, 12079, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (667, 42, 'gJYAABtmkUrtSYg5', 'HAfwWzvRQm2Wjr47ogMsWB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 9003, 9003, 0, 9003, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (668, 43, 'gJYAABtmkWLtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 7382, 7382, 0, 7287, 0, 2, 95);
INSERT INTO `eas_wo_dtl` VALUES (669, 43, 'gJYAABtmkWjtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1186, 1186, 0, 1160, 0, 2, 27);
INSERT INTO `eas_wo_dtl` VALUES (670, 43, 'gJYAABtmkWTtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 18323, 18323, 0, 18323, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (671, 43, 'gJYAABtmkWbtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 88, 88, 0, 88, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (672, 43, 'gJYAABtmkWDtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 88, 88, 0, 88, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (673, 43, 'gJYAABtmkWztSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 900, 900, 0, 900, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (674, 43, 'gJYAABtmkW3tSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 9005, 9005, 0, 9005, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (675, 43, 'gJYAABtmkWPtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 53, 53, 0, 53, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (676, 43, 'gJYAABtmkWrtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 17686, 17686, 0, 17686, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (677, 43, 'gJYAABtmkW7tSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (678, 43, 'gJYAABtmkWHtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 172, 172, 0, 172, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (679, 43, 'gJYAABtmkWntSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAABJZTI9ECefw', '02.03.20.002.1119', '平面支架', '2835E-20PCT-P0', '千个', 4394, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (680, 43, 'gJYAABtpuRTtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 4394, 4394, 0, 4394, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (681, 43, 'gJYAABtmkWXtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 861, 861, 0, 861, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (682, 43, 'gJYAABtmkWvtSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 17686, 17686, 0, 17686, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (683, 43, 'gJYAABtmkWftSYg5', 'p5+phxUPQCyZCVLhb/IuOx0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 13182, 13182, 0, 13182, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (684, 44, 'gJYAABtmkZftSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 3403, 3403, 0, 3000, 0, 2, 403);
INSERT INTO `eas_wo_dtl` VALUES (685, 44, 'gJYAABtmkYvtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 440, 440, 0, 0, 0, 2, 440);
INSERT INTO `eas_wo_dtl` VALUES (686, 44, 'gJYAABtmkZbtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8348, 8348, 0, 8348, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (687, 44, 'gJYAABtmkZXtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (688, 44, 'gJYAABtmkY/tSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (689, 44, 'gJYAABtmkY3tSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 410, 410, 0, 410, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (690, 44, 'gJYAABtmkY7tSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4103, 4103, 0, 4103, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (691, 44, 'gJYAABtmkYrtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 24, 24, 0, 24, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (692, 44, 'gJYAABtmkZDtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8058, 8058, 0, 8058, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (693, 44, 'gJYAABtmkYztSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (694, 44, 'gJYAABtmkYntSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 78, 78, 0, 78, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (695, 44, 'gJYAABtmkZTtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2002, 2002, 0, 2002, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (696, 44, 'gJYAABtmkZPtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 392, 392, 0, 392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (697, 44, 'gJYAABtmkZLtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8058, 8058, 0, 8058, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (698, 44, 'gJYAABtmkZHtSYg5', 'sBJOIoIURG23SL/HVzQ0zh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 6006, 6006, 0, 6006, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (699, 45, 'gJYAABtmknbtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 269, 269, 0, 269, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (700, 45, 'gJYAABtmkm3tSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 1345, 1345, 0, 1345, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (701, 45, 'gJYAABtmkmjtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 10763, 10763, 0, 10763, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (702, 45, 'gJYAABtmknftSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 40184, 40184, 0, 40184, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (703, 45, 'gJYAABtmkmrtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 178, 178, 0, 178, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (704, 45, 'gJYAABtmkmztSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 104, 104, 0, 104, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (705, 45, 'gJYAABtmknDtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1722, 1722, 0, 1722, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (706, 45, 'gJYAABtmknXtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 17220, 17220, 0, 17220, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (707, 45, 'gJYAABtmkmvtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 133, 133, 0, 133, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (708, 45, 'gJYAABtmknHtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 35783, 35783, 0, 35783, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (709, 45, 'gJYAABtmknLtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 35, 35, 0, 35, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (710, 45, 'gJYAABtmkm7tSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 348, 348, 0, 348, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (711, 45, 'gJYAABtmknPtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 8890, 8890, 0, 8890, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (712, 45, 'gJYAABtmkmntSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1742, 1742, 0, 1742, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (713, 45, 'gJYAABtmkm/tSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 35783, 35783, 0, 35783, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (714, 45, 'gJYAABtmknTtSYg5', 'sG+E4OsCSueAR6XrAD6DFh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 26671, 26671, 0, 26671, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (715, 46, 'gJYAABtnUxDtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 3600, 3600, 0, 3600, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (716, 46, 'gJYAABtnUxvtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1323, 1323, 0, 0, 0, 2, 1323);
INSERT INTO `eas_wo_dtl` VALUES (717, 46, 'gJYAABtnUxXtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 44, 44, 0, 0, 0, 2, 44);
INSERT INTO `eas_wo_dtl` VALUES (718, 46, 'gJYAABtnUw7tSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 491, 491, 0, 0, 0, 2, 491);
INSERT INTO `eas_wo_dtl` VALUES (719, 46, 'gJYAABtnUxHtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 5424, 5424, 0, 5424, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (720, 46, 'gJYAABtnUxbtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (721, 46, 'gJYAABtnUxPtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 14, 14, 0, 14, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (722, 46, 'gJYAABtnUxntSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 123, 123, 0, 123, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (723, 46, 'gJYAABtnUwztSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1234, 1234, 0, 1234, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (724, 46, 'gJYAABtnUw/tSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 10, 10, 0, 10, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (725, 46, 'gJYAABtnUxjtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4830, 4830, 0, 4830, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (726, 46, 'gJYAABtnUxrtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 65, 65, 0, 65, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (727, 46, 'gJYAABtnUxLtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (728, 46, 'gJYAABtnUw3tSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 65, 65, 0, 65, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (729, 46, 'gJYAABtnUxftSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1200, 1200, 0, 1200, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (730, 46, 'gJYAABtnUxTtSYg5', 'CJ2/sTezTR++b9/ukqY3Hh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4830, 4830, 0, 4830, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (731, 47, 'gJYAABtn9/TtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 27004, 27004, 0, 5000, 0, 2, 22004);
INSERT INTO `eas_wo_dtl` VALUES (732, 47, 'gJYAABtn9/DtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 3901, 3901, 0, 0, 0, 2, 3901);
INSERT INTO `eas_wo_dtl` VALUES (733, 47, 'gJYAABtn9/rtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 62559, 62559, 0, 62559, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (734, 47, 'gJYAABtn9/btSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 300, 300, 0, 300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (735, 47, 'gJYAABtn9/ztSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 302, 302, 0, 302, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (736, 47, 'gJYAABtn9/vtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3075, 3075, 0, 3075, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (737, 47, 'gJYAABtn9/ntSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 30746, 30746, 0, 30746, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (738, 47, 'gJYAABtn9/LtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 181, 181, 0, 181, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (739, 47, 'gJYAABtn9/PtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 60384, 60384, 0, 60384, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (740, 47, 'gJYAABtn9/3tSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 59, 59, 0, 59, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (741, 47, 'gJYAABtn9/7tSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 588, 588, 0, 588, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (742, 47, 'gJYAABtn9/HtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 15002, 15002, 0, 15002, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (743, 47, 'gJYAABtn9/ftSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2940, 2940, 0, 2940, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (744, 47, 'gJYAABtn9/jtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 60384, 60384, 0, 60384, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (745, 47, 'gJYAABtn9/XtSYg5', '79ERMD9mSoCK41LBd31UQR0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 45007, 45007, 0, 45007, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (746, 48, 'gJYAABtn+A7tSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 188, 188, 0, 188, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (747, 48, 'gJYAABtn+BDtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 151, 151, 0, 151, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (748, 48, 'gJYAABtn+AjtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4805, 4805, 0, 4805, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (749, 48, 'gJYAABtn+AbtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAwdkHhECefw', '01.02.01.006.0066', '键合银丝', 'JHB-J-23um', '米', 11769, 11769, 0, 11769, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (750, 48, 'gJYAABtn+AftSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 50, 50, 0, 50, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (751, 48, 'gJYAABtn+APtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (752, 48, 'gJYAABtn+A/tSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 825, 825, 0, 825, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (753, 48, 'gJYAABtn+AztSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 8251, 8251, 0, 8251, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (754, 48, 'gJYAABtn+ATtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 76, 76, 0, 76, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (755, 48, 'gJYAABtn+AntSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 16113, 16113, 0, 16113, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (756, 48, 'gJYAABtn+ALtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (757, 48, 'gJYAABtn+AXtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 157, 157, 0, 157, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (758, 48, 'gJYAABtpuRHtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 4003, 2300, 0, 4003, 1703, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (759, 48, 'gJYAABtn+AvtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 4003, 1703, 0, 4003, 2300, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (760, 48, 'gJYAABtn+ArtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 785, 785, 0, 785, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (761, 48, 'gJYAABtn+A3tSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 16113, 16113, 0, 16113, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (762, 48, 'gJYAABtn+AHtSYg5', 'zG1hPZmKS7WSMOiqH5BAoR0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 8006, 8006, 0, 8006, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (763, 49, 'gJYAABtpsJLtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 433, 433, 0, 433, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (764, 49, 'gJYAABtpsKDtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 18627, 18627, 0, 18627, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (765, 49, 'gJYAABtpsJXtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 943, 943, 0, 353, 0, 2, 590);
INSERT INTO `eas_wo_dtl` VALUES (766, 49, 'gJYAABtpsJztSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 39552, 39552, 0, 39552, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (767, 49, 'gJYAABtpsJ/tSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 100, 100, 0, 100, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (768, 49, 'gJYAABtpsJTtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 160, 160, 0, 160, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (769, 49, 'gJYAABtpsJ3tSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 4194, 4194, 0, 4194, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (770, 49, 'gJYAABtpsJrtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 41941, 41941, 0, 41941, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (771, 49, 'gJYAABtpsJvtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 336, 336, 0, 336, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (772, 49, 'gJYAABtpsKHtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 80402, 80402, 0, 80402, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (773, 49, 'gJYAABtpsJbtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 1087, 1087, 0, 1087, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (774, 49, 'gJYAABtpsJ7tSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 99, 99, 0, 99, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (775, 49, 'gJYAABtpsJftSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 1087, 1087, 0, 1087, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (776, 49, 'gJYAABtpsJjtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 19976, 19976, 0, 19976, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (777, 49, 'gJYAABtpsJPtSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 80402, 80402, 0, 80402, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (778, 49, 'gJYAABtpsJntSYg5', 'GZUL7/nwTYGiHfc/lekwXR0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 19976, 19976, 0, 19976, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (779, 50, 'gJYAABtpsL7tSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 314, 314, 0, 314, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (780, 50, 'gJYAABtpsMXtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 161, 161, 0, 161, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (781, 50, 'gJYAABtpsL/tSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2324, 2324, 0, 2324, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (782, 50, 'gJYAABtpsL3tSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6695, 6695, 0, 6695, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (783, 50, 'gJYAABtpsMbtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (784, 50, 'gJYAABtpsMPtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (785, 50, 'gJYAABtpsMDtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 710, 710, 0, 710, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (786, 50, 'gJYAABtpsMTtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 7100, 7100, 0, 7100, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (787, 50, 'gJYAABtpsLjtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 52, 52, 0, 52, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (788, 50, 'gJYAABtpsLntSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 13611, 13611, 0, 13611, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (789, 50, 'gJYAABtpsLftSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 184, 184, 0, 184, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (790, 50, 'gJYAABtpsLztSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (791, 50, 'gJYAABtpsLvtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 184, 184, 0, 184, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (792, 50, 'gJYAABtpsMHtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3382, 3382, 0, 3382, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (793, 50, 'gJYAABtpsLrtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13611, 13611, 0, 13611, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (794, 50, 'gJYAABtpsMLtSYg5', 'hlencoERTF6Q7Rv91/QBEh0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 3382, 3382, 0, 3382, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (795, 51, 'gJYAABtpsNDtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 376, 376, 0, 376, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (796, 51, 'gJYAABtpsNPtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 193, 193, 0, 193, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (797, 51, 'gJYAABtpsMntSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2783, 2783, 0, 2783, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (798, 51, 'gJYAABtpsM3tSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8016, 8016, 0, 8016, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (799, 51, 'gJYAABtpsNjtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (800, 51, 'gJYAABtpsNHtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (801, 51, 'gJYAABtpsNLtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 850, 850, 0, 850, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (802, 51, 'gJYAABtpsM/tSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 8501, 8501, 0, 8501, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (803, 51, 'gJYAABtpsMrtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 63, 63, 0, 63, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (804, 51, 'gJYAABtpsM7tSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 16296, 16296, 0, 16296, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (805, 51, 'gJYAABtpsNftSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 220, 220, 0, 220, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (806, 51, 'gJYAABtpsMvtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (807, 51, 'gJYAABtpsNXtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 220, 220, 0, 220, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (808, 51, 'gJYAABtpsNTtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 4049, 4049, 0, 4049, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (809, 51, 'gJYAABtpsNbtSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 16296, 16296, 0, 16296, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (810, 51, 'gJYAABtpsMztSYg5', 'x3kaIvBpRQO7nFBUPfqkFh0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 4049, 4049, 0, 4049, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (811, 52, 'gJYAABtpsPXtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 59, 59, 0, 59, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (812, 52, 'gJYAABtpsPztSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 558, 558, 0, 558, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (813, 52, 'gJYAABtpsP7tSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3123, 3123, 0, 3123, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (814, 52, 'gJYAABtpsPHtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 16541, 16541, 0, 16541, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (815, 52, 'gJYAABtpsP/tSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 89, 89, 0, 89, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (816, 52, 'gJYAABtpsPvtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 234, 234, 0, 234, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (817, 52, 'gJYAABtpsP3tSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 548, 548, 0, 548, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (818, 52, 'gJYAABtpsQDtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5479, 5479, 0, 5479, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (819, 52, 'gJYAABtpsPftSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 69, 69, 0, 69, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (820, 52, 'gJYAABtpsPrtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12562, 12562, 0, 12562, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (821, 52, 'gJYAABtpsPTtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (822, 52, 'gJYAABtpsPPtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 122, 122, 0, 122, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (823, 52, 'gJYAABtpsPjtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3121, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (824, 52, 'gJYAABuQfs7tSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3121, 3121, 0, 3121, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (825, 52, 'gJYAABtpsPntSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 612, 612, 0, 612, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (826, 52, 'gJYAABtpsPLtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12562, 12562, 0, 12562, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (827, 52, 'gJYAABtpsPbtSYg5', 'gPDTa41PQTSddPqPXTp31R0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 12484, 12484, 0, 12484, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (828, 53, 'gJYAABtqbqbtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 2, 2, 0, 0, 0, 2, 2);
INSERT INTO `eas_wo_dtl` VALUES (829, 53, 'gJYAABtqbqTtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 27, 27, 0, 27, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (830, 53, 'gJYAABtqbqztSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABhfXltECefw', '01.02.01.001.1272', '荧光粉', 'KSL220', '克', 13, 13, 0, 0, 0, 2, 13);
INSERT INTO `eas_wo_dtl` VALUES (831, 53, 'gJYAABtqbrTtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 196, 196, 0, 196, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (832, 53, 'gJYAABtqbrPtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (833, 53, 'gJYAABtqbqXtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (834, 53, 'gJYAABtqbq7tSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 21, 21, 0, 21, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (835, 53, 'gJYAABtqbrLtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 210, 210, 0, 210, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (836, 53, 'gJYAABtqbqvtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (837, 53, 'gJYAABtqbqntSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 403, 403, 0, 403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (838, 53, 'gJYAABtqbrbtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (839, 53, 'gJYAABtqbqrtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABC1FxVECefw', '01.02.13.040.3497', '纸箱', '35.5*35.5*27.5（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (840, 53, 'gJYAABtqbrHtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (841, 53, 'gJYAABtqbq3tSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (842, 53, 'gJYAABtqbqjtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 100, 100, 0, 100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (843, 53, 'gJYAABtqbq/tSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (844, 53, 'gJYAABtqbrXtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (845, 53, 'gJYAABtqbrDtSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (846, 53, 'gJYAABtqbqftSYg5', 'gJCfouUMShmtM3CwoNk2YR0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 200, 200, 0, 200, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (847, 54, 'gJYAABtvDvvtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 722, 722, 0, 722, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (848, 54, 'gJYAABtvDvftSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 241, 241, 0, 241, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (849, 54, 'gJYAABtvDv7tSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3846, 3846, 0, 3846, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (850, 54, 'gJYAABtvDvTtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 9986, 9986, 0, 9986, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (851, 54, 'gJYAABtvDvztSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (852, 54, 'gJYAABtvDv3tSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (853, 54, 'gJYAABtvDvrtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1059, 1059, 0, 1059, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (854, 54, 'gJYAABtvDvntSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 10589, 10589, 0, 10589, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (855, 54, 'gJYAABtvDvXtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 78, 78, 0, 78, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (856, 54, 'gJYAABtvDvjtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 20300, 20300, 0, 20300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (857, 54, 'gJYAABtvDvPtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 275, 275, 0, 275, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (858, 54, 'gJYAABtvDvbtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (859, 54, 'gJYAABtvDvHtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 275, 275, 0, 275, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (860, 54, 'gJYAABtvDv/tSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 5044, 5044, 0, 5044, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (861, 54, 'gJYAABtvDvLtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 20300, 20300, 0, 20300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (862, 54, 'gJYAABtvDvDtSYg5', '4nLf7+jrR1OqYE6/kzGCrx0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 5044, 5044, 0, 5044, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (863, 55, 'gJYAABtvDwLtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 12354, 12354, 0, 12354, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (864, 55, 'gJYAABtvDwftSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1276, 1276, 0, 0, 0, 2, 1276);
INSERT INTO `eas_wo_dtl` VALUES (865, 55, 'gJYAABtvDwbtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 146, 146, 0, 146, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (866, 55, 'gJYAABtvDxHtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 29887, 29887, 0, 29887, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (867, 55, 'gJYAABtvDwXtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 143, 143, 0, 143, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (868, 55, 'gJYAABtvDw7tSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 144, 144, 0, 144, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (869, 55, 'gJYAABtvDw/tSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1961, 1961, 0, 1961, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (870, 55, 'gJYAABtvDw3tSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 19605, 19605, 0, 19605, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (871, 55, 'gJYAABtvDwPtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 189, 189, 0, 189, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (872, 55, 'gJYAABtvDwTtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 28847, 28847, 0, 28847, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (873, 55, 'gJYAABtvDwntSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (874, 55, 'gJYAABtvDwztSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 281, 281, 0, 281, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (875, 55, 'gJYAABtvDxDtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7167, 7167, 0, 7167, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (876, 55, 'gJYAABtvDwrtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1405, 1405, 0, 1405, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (877, 55, 'gJYAABtvDwvtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 28847, 28847, 0, 28847, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (878, 55, 'gJYAABtvDwjtSYg5', 'MwGU8zrmSn+7aoJJU/3qDB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 21501, 21501, 0, 21501, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (879, 56, 'gJYAABtvDxntSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 215, 215, 0, 215, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (880, 56, 'gJYAABtvDxvtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 72, 72, 0, 72, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (881, 56, 'gJYAABtvDx7tSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1033, 1033, 0, 1033, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (882, 56, 'gJYAABtvDyXtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2975, 2975, 0, 2975, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (883, 56, 'gJYAABtvDxztSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (884, 56, 'gJYAABtvDyHtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (885, 56, 'gJYAABtvDx/tSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 316, 316, 0, 316, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (886, 56, 'gJYAABtvDyPtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 3155, 3155, 0, 3155, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (887, 56, 'gJYAABtvDx3tSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 23, 23, 0, 23, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (888, 56, 'gJYAABtvDyDtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 6049, 6049, 0, 6049, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (889, 56, 'gJYAABtvDxrtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 82, 82, 0, 82, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (890, 56, 'gJYAABtvDyTtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (891, 56, 'gJYAABtvDyLtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 82, 82, 0, 82, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (892, 56, 'gJYAABtvDxftSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1503, 1503, 0, 1503, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (893, 56, 'gJYAABtvDxjtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6049, 6049, 0, 6049, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (894, 56, 'gJYAABtvDxbtSYg5', '1BGIWXhtRLG0xeLQPxsQJB0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 1503, 1503, 0, 1503, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (895, 57, 'gJYAABtvDyrtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 1512, 1512, 0, 1512, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (896, 57, 'gJYAABtvDy3tSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 57, 57, 0, 57, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (897, 57, 'gJYAABtvDzTtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 92, 92, 0, 92, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (898, 57, 'gJYAABtvDyjtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 9289, 9289, 0, 9289, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (899, 57, 'gJYAABtvDzHtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 45, 45, 0, 45, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (900, 57, 'gJYAABtvDy7tSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (901, 57, 'gJYAABtvDzPtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 452, 452, 0, 452, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (902, 57, 'gJYAABtvDyvtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4517, 4517, 0, 4517, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (903, 57, 'gJYAABtvDzLtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 32, 32, 0, 32, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (904, 57, 'gJYAABtvDzbtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8966, 8966, 0, 8966, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (905, 57, 'gJYAABtvDzftSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (906, 57, 'gJYAABtvDy/tSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 87, 87, 0, 87, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (907, 57, 'gJYAABtvDzDtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2227, 2227, 0, 2227, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (908, 57, 'gJYAABtvDzXtSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 437, 437, 0, 437, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (909, 57, 'gJYAABtvDyntSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8966, 8966, 0, 8966, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (910, 57, 'gJYAABtvDyztSYg5', 'h2HG/lNUQpG5Tvs85QQr3h0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 6682, 6682, 0, 6682, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (911, 58, 'gJYAABtw8MztSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 83, 83, 0, 83, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (912, 58, 'gJYAABtw8MLtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 5470, 5470, 0, 5470, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (913, 58, 'gJYAABtw8MDtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 206, 206, 0, 0, 0, 2, 206);
INSERT INTO `eas_wo_dtl` VALUES (914, 58, 'gJYAABtw8M3tSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 14240, 14240, 0, 14240, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (915, 58, 'gJYAABtw8MvtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 36, 36, 0, 36, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (916, 58, 'gJYAABtw8MrtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (917, 58, 'gJYAABtw8MPtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1510, 1510, 0, 1510, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (918, 58, 'gJYAABtw8MftSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 15100, 15100, 0, 15100, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (919, 58, 'gJYAABtw8MTtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 111, 111, 0, 111, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (920, 58, 'gJYAABtw8MHtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 28948, 28948, 0, 28948, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (921, 58, 'gJYAABtw8L/tSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 392, 392, 0, 392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (922, 58, 'gJYAABtw8MXtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 36, 36, 0, 36, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (923, 58, 'gJYAABtw8MbtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 392, 392, 0, 392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (924, 58, 'gJYAABtw8M7tSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 7192, 7192, 0, 7192, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (925, 58, 'gJYAABtw8MjtSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 28948, 28948, 0, 28948, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (926, 58, 'gJYAABtw8MntSYg5', '6Prwrs9wQNaw2SG6E+q4Qx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 7192, 7192, 0, 7192, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (927, 59, 'gJYAABtywYLtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 39, 39, 0, 39, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (928, 59, 'gJYAABtywYbtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2605, 2605, 0, 2605, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (929, 59, 'gJYAABtywYftSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 98, 98, 0, 98, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (930, 59, 'gJYAABtywYPtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6783, 6783, 0, 6783, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (931, 59, 'gJYAABtywXrtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (932, 59, 'gJYAABtywYTtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (933, 59, 'gJYAABtywX3tSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 719, 719, 0, 719, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (934, 59, 'gJYAABtywX/tSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 7193, 7193, 0, 7193, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (935, 59, 'gJYAABtywYDtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 53, 53, 0, 53, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (936, 59, 'gJYAABtywX7tSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 13789, 13789, 0, 13789, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (937, 59, 'gJYAABtywXztSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 186, 186, 0, 186, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (938, 59, 'gJYAABtywYjtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (939, 59, 'gJYAABtywXvtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 186, 186, 0, 186, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (940, 59, 'gJYAABtywYntSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3426, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (941, 59, 'gJYAABuZ9QLtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3426, 3426, 0, 3426, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (942, 59, 'gJYAABtywYXtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13789, 13789, 0, 13789, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (943, 59, 'gJYAABtywYHtSYg5', 'EA91BNdaSKOeOhh3NS3AfR0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 3426, 3426, 0, 3426, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (944, 60, 'gJYAABtywbDtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 372, 372, 0, 372, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (945, 60, 'gJYAABtywabtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 144, 144, 0, 144, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (946, 60, 'gJYAABtywa3tSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2261, 2261, 0, 2261, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (947, 60, 'gJYAABtywa7tSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5997, 5997, 0, 5997, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (948, 60, 'gJYAABtywavtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (949, 60, 'gJYAABtywaPtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (950, 60, 'gJYAABtywbHtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 636, 636, 0, 636, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (951, 60, 'gJYAABtywajtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 6359, 6359, 0, 6359, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (952, 60, 'gJYAABtywaXtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 47, 47, 0, 47, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (953, 60, 'gJYAABtywaftSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 12191, 12191, 0, 12191, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (954, 60, 'gJYAABtywantSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 165, 165, 0, 165, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (955, 60, 'gJYAABtywaztSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (956, 60, 'gJYAABtywaTtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 165, 165, 0, 165, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (957, 60, 'gJYAABtywartSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3029, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (958, 60, 'gJYAABuZ9QrtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3029, 3029, 0, 3029, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (959, 60, 'gJYAABtywaLtSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12191, 12191, 0, 12191, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (960, 60, 'gJYAABtywa/tSYg5', 'IBjB3o0GSsKsR8CDvS5zUx0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 3029, 3029, 0, 3029, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (961, 61, 'gJYAABtywbftSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 17, 17, 0, 17, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (962, 61, 'gJYAABtywcTtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 1, 1, 0, 1, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (963, 61, 'gJYAABtywbntSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 110, 110, 0, 110, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (964, 61, 'gJYAABtywb/tSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 465, 465, 0, 465, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (965, 61, 'gJYAABtywcDtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (966, 61, 'gJYAABtywbztSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (967, 61, 'gJYAABtywcPtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 25, 25, 0, 25, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (968, 61, 'gJYAABtywcLtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 253, 253, 0, 253, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (969, 61, 'gJYAABtywbrtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (970, 61, 'gJYAABtywbXtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (971, 61, 'gJYAABtywbvtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (972, 61, 'gJYAABtywb7tSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (973, 61, 'gJYAABtywbjtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 103, 103, 0, 103, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (974, 61, 'gJYAABtywb3tSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (975, 61, 'gJYAABtywbbtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (976, 61, 'gJYAABtywcHtSYg5', '8X9al2efTFCNZlOnQbZbtB0NgN0=', 'gJYAABlFPCJECefw', '06.10.03.001.0100', 'DICE', 'S-DICE-BXHV1442', '千个', 205, 205, 0, 205, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (977, 62, 'gJYAABtywc/tSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 437, 437, 0, 437, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (978, 62, 'gJYAABtywcvtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 80, 80, 0, 80, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (979, 62, 'gJYAABtywc3tSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2277, 2277, 0, 2277, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (980, 62, 'gJYAABtywc7tSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5881, 5881, 0, 5881, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (981, 62, 'gJYAABtywdLtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (982, 62, 'gJYAABtywcrtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (983, 62, 'gJYAABtywdPtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 608, 608, 0, 608, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (984, 62, 'gJYAABtywcztSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6084, 6084, 0, 6084, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (985, 62, 'gJYAABtywdHtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 44, 44, 0, 44, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (986, 62, 'gJYAABtywdbtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12076, 12076, 0, 12076, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (987, 62, 'gJYAABtywcntSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (988, 62, 'gJYAABtywdDtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 118, 118, 0, 118, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (989, 62, 'gJYAABtywdftSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3000, 3000, 0, 3000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (990, 62, 'gJYAABtywdjtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 588, 588, 0, 588, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (991, 62, 'gJYAABtywdTtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12076, 12076, 0, 12076, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (992, 62, 'gJYAABtywdXtSYg5', 'JlwVdr7FSbOjHPSKiNE3ER0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 3000, 3000, 0, 3000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (993, 63, 'gJYAABt4COvtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 3000, 3000, 0, 3000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (994, 63, 'gJYAABt4CPbtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1717, 1717, 0, 0, 0, 2, 1717);
INSERT INTO `eas_wo_dtl` VALUES (995, 63, 'gJYAABt4CO/tSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 58, 58, 0, 0, 0, 2, 58);
INSERT INTO `eas_wo_dtl` VALUES (996, 63, 'gJYAABt4COztSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 443, 443, 0, 443, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (997, 63, 'gJYAABt4CPHtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 4520, 4520, 0, 4520, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (998, 63, 'gJYAABt4CO3tSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (999, 63, 'gJYAABt4CPLtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1000, 63, 'gJYAABt4CPDtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 151, 151, 0, 151, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1001, 63, 'gJYAABt4COjtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1506, 1506, 0, 1506, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1002, 63, 'gJYAABt4CPTtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4025, 4025, 0, 4025, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1003, 63, 'gJYAABt4CPXtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1004, 63, 'gJYAABt4CPPtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1005, 63, 'gJYAABt4COntSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1006, 63, 'gJYAABt4CO7tSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1000, 1000, 0, 1000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1007, 63, 'gJYAABt4COrtSYg5', 'dbFEgbp1RCKMKofVi1tY7R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4025, 4025, 0, 4025, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1008, 64, 'gJYAABt4CRbtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 3000, 3000, 0, 3000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1009, 64, 'gJYAABt4CSDtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1102, 1102, 0, 0, 0, 2, 1102);
INSERT INTO `eas_wo_dtl` VALUES (1010, 64, 'gJYAABt4CRvtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 37, 37, 0, 0, 0, 2, 37);
INSERT INTO `eas_wo_dtl` VALUES (1011, 64, 'gJYAABt4CRXtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 409, 409, 0, 409, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1012, 64, 'gJYAABt4CRftSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 4520, 4520, 0, 4520, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1013, 64, 'gJYAABt4CRztSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1014, 64, 'gJYAABt4CRntSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1015, 64, 'gJYAABt4CR7tSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 103, 103, 0, 103, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1016, 64, 'gJYAABt4CRHtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1028, 1028, 0, 1028, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1017, 64, 'gJYAABt4CRTtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 8, 8, 0, 8, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1018, 64, 'gJYAABt4CR3tSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4025, 4025, 0, 4025, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1019, 64, 'gJYAABt4CR/tSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1020, 64, 'gJYAABt4CRjtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1021, 64, 'gJYAABt4CRLtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1022, 64, 'gJYAABt4CRPtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1000, 1000, 0, 1000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1023, 64, 'gJYAABt4CRrtSYg5', 'dj8xGlfeQc29pIvGvBZUfB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4025, 4025, 0, 4025, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1024, 65, 'gJYAABt4CoztSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 4872, 4872, 0, 4872, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1025, 65, 'gJYAABt4CpTtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 255, 255, 0, 255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1026, 65, 'gJYAABt4Co/tSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 265, 265, 0, 265, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1027, 65, 'gJYAABt4CpbtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 18980, 18980, 0, 18980, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1028, 65, 'gJYAABt4CpftSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 91, 91, 0, 91, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1029, 65, 'gJYAABt4ContSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 91, 91, 0, 91, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1030, 65, 'gJYAABt4CpHtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1268, 1268, 0, 1268, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1031, 65, 'gJYAABt4Co7tSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 12680, 12680, 0, 12680, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1032, 65, 'gJYAABt4CovtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 114, 114, 0, 114, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1033, 65, 'gJYAABt4CpjtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 18320, 18320, 0, 18320, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1034, 65, 'gJYAABt4CortSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1035, 65, 'gJYAABt4CpLtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 178, 178, 0, 178, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1036, 65, 'gJYAABt4Co3tSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 4552, 4552, 0, 4552, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1037, 65, 'gJYAABt4CpPtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 892, 892, 0, 892, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1038, 65, 'gJYAABt4CpXtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 18320, 18320, 0, 18320, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1039, 65, 'gJYAABt4CpDtSYg5', 'E0VtvNJKQRSRDphe2opUAB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 13655, 13655, 0, 13655, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1040, 66, 'gJYAABt4CqHtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 6605, 6605, 0, 6605, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1041, 66, 'gJYAABt4CqntSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 346, 346, 0, 346, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1042, 66, 'gJYAABt4CqTtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 360, 360, 0, 360, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1043, 66, 'gJYAABt4CqvtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 25729, 25729, 0, 25729, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1044, 66, 'gJYAABt4CqztSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 123, 123, 0, 123, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1045, 66, 'gJYAABt4Cp7tSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 124, 124, 0, 124, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1046, 66, 'gJYAABt4CqbtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1719, 1719, 0, 1719, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1047, 66, 'gJYAABt4CqPtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 17188, 17188, 0, 17188, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1048, 66, 'gJYAABt4CqDtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 155, 155, 0, 155, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1049, 66, 'gJYAABt4Cq3tSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 24834, 24834, 0, 24834, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1050, 66, 'gJYAABt4Cp/tSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1051, 66, 'gJYAABt4CqftSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 242, 242, 0, 242, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1052, 66, 'gJYAABt4CqLtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 6170, 6170, 0, 6170, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1053, 66, 'gJYAABt4CqjtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1209, 1209, 0, 1209, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1054, 66, 'gJYAABt4CqrtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 24834, 24834, 0, 24834, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1055, 66, 'gJYAABt4CqXtSYg5', 'MbVO/KZUReu9x/85eCbAwB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 18510, 18510, 0, 18510, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1056, 67, 'gJYAABt4wFbtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 128, 128, 0, 128, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1057, 67, 'gJYAABt4wGHtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 401, 401, 0, 401, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1058, 67, 'gJYAABt4wFPtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4555, 4555, 0, 4555, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1059, 67, 'gJYAABt4wF3tSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8395, 8395, 0, 8395, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1060, 67, 'gJYAABt4wF/tSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1061, 67, 'gJYAABt4wFTtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1062, 67, 'gJYAABt4wFztSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 910, 910, 0, 910, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1063, 67, 'gJYAABt4wFntSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 9102, 9102, 0, 9102, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1064, 67, 'gJYAABt4wFjtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 62, 62, 0, 62, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1065, 67, 'gJYAABt4wFftSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 17239, 17239, 0, 17239, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1066, 67, 'gJYAABt4wFrtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1067, 67, 'gJYAABt4wFvtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 168, 168, 0, 168, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1068, 67, 'gJYAABt4wGDtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 4283, 4283, 0, 4283, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1069, 67, 'gJYAABt4wF7tSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 839, 839, 0, 839, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1070, 67, 'gJYAABt4wFLtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 17239, 17239, 0, 17239, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1071, 67, 'gJYAABt4wFXtSYg5', 'hkhyXAEWSuOKRCsOIK3Dvx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 4283, 4283, 0, 4283, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1072, 68, 'gJYAABt5LFrtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABiChQBECefw', '01.01.01.010.3459', 'DICE', 'DICE-BPA0F11A', '千个', 50000, 50000, 0, 50856, 856, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1073, 68, 'gJYAABt5LFXtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 22255, 22255, 0, 22255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1074, 68, 'gJYAABt5LFPtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 3760, 3760, 0, 3760, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1075, 68, 'gJYAABt5LFbtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABcwNiFECefw', '01.02.01.006.0082', '银线', 'JHB_K_18um', '米', 75050, 75050, 0, 75050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1076, 68, 'gJYAABt5LFvtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1077, 68, 'gJYAABt5LFftSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 6523, 6523, 0, 12523, 6000, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1078, 68, 'gJYAABt5LFntSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 65230, 65230, 0, 125230, 60000, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1079, 68, 'gJYAABt5LFHtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 385, 385, 0, 385, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1080, 68, 'gJYAABt5LFLtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1081, 68, 'gJYAABt5LF/tSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAAA+DghFECefw', '02.02.02.002.0015', '胶水', 'MS-042', '克', 150, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1082, 68, 'gJYAABt5OL/tSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1083, 68, 'gJYAABt5LF3tSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1084, 68, 'gJYAABt5LFztSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1085, 68, 'gJYAABt5LF7tSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1086, 68, 'gJYAABt5LFjtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1087, 68, 'gJYAABt5LFTtSYg5', '0oKQgokiR8aFIjpUKwbo3R0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1088, 69, 'gJYAABt5/m/tSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABXStMRECefw', '01.02.01.001.1252', '荧光粉', 'KSL510', '克', 36, 36, 0, 0, 0, 2, 36);
INSERT INTO `eas_wo_dtl` VALUES (1089, 69, 'gJYAABt5/m7tSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 435, 435, 0, 435, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1090, 69, 'gJYAABt5/nbtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABhfXltECefw', '01.02.01.001.1272', '荧光粉', 'KSL220', '克', 215, 215, 0, 0, 0, 2, 215);
INSERT INTO `eas_wo_dtl` VALUES (1091, 69, 'gJYAABt5/nHtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5637, 5637, 0, 5637, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1092, 69, 'gJYAABt5/njtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1093, 69, 'gJYAABt5/nntSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 26, 26, 0, 26, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1094, 69, 'gJYAABt5/nrtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 338, 338, 0, 338, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1095, 69, 'gJYAABt5/n7tSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3381, 3381, 0, 3381, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1096, 69, 'gJYAABt5/nXtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 30, 30, 0, 30, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1097, 69, 'gJYAABt5/nLtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 6482, 6482, 0, 6482, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1098, 69, 'gJYAABt5/oDtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (1099, 69, 'gJYAABt5/nPtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABC1FxVECefw', '01.02.13.040.3497', '纸箱', '35.5*35.5*27.5（五层加硬）', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (1100, 69, 'gJYAABt5/n3tSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1101, 69, 'gJYAABt5/nftSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 86, 86, 0, 86, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1102, 69, 'gJYAABt5/nDtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1610, 1610, 0, 1610, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1103, 69, 'gJYAABt5/nvtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1104, 69, 'gJYAABt5/n/tSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 86, 86, 0, 86, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1105, 69, 'gJYAABt5/nztSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6482, 6482, 0, 6482, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1106, 69, 'gJYAABt5/nTtSYg5', 'kYCrwnq7RJmRUxmy0e5ZbR0NgN0=', 'gJYAABctXNNECefw', '06.10.03.001.0068', 'DICE', 'S-DICE-BXCD1236', '千个', 3221, 3221, 0, 3221, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1107, 70, 'gJYAABt6LqbtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 4, 4, 0, 4, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1108, 70, 'gJYAABt6LqTtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 14, 14, 0, 14, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1109, 70, 'gJYAABt6LprtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 98, 98, 0, 98, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1110, 70, 'gJYAABt6LqHtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1111, 70, 'gJYAABt6LqLtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1112, 70, 'gJYAABt6LpztSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1113, 70, 'gJYAABt6LqXtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 21, 21, 0, 21, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1114, 70, 'gJYAABt6LqPtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 208, 208, 0, 208, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1115, 70, 'gJYAABt6LpjtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1116, 70, 'gJYAABt6Lp3tSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1117, 70, 'gJYAABt6LpntSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1118, 70, 'gJYAABt6Lp/tSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1119, 70, 'gJYAABt6LpvtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 103, 103, 0, 103, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1120, 70, 'gJYAABt6LpftSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1121, 70, 'gJYAABt6Lp7tSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1122, 70, 'gJYAABt6LqDtSYg5', '4xoFJ0n9QbKah5bI8n25mx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 103, 103, 0, 103, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1123, 71, 'gJYAABt6LrDtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 74, 74, 0, 74, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1124, 71, 'gJYAABt6Lr7tSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3195, 3195, 0, 3195, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1125, 71, 'gJYAABt6LrPtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 162, 162, 0, 162, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1126, 71, 'gJYAABt6LrntSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6785, 6785, 0, 6785, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1127, 71, 'gJYAABt6LrztSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1128, 71, 'gJYAABt6LrLtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1129, 71, 'gJYAABt6LrrtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 719, 719, 0, 719, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1130, 71, 'gJYAABt6LrjtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 7194, 7194, 0, 7194, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1131, 71, 'gJYAABt6LrftSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 58, 58, 0, 58, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1132, 71, 'gJYAABt6Lr/tSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 13792, 13792, 0, 13792, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1133, 71, 'gJYAABt6Lr3tSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 187, 187, 0, 187, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1134, 71, 'gJYAABt6LrvtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1135, 71, 'gJYAABt6LrTtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 187, 187, 0, 187, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1136, 71, 'gJYAABt6LrXtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3427, 3427, 0, 3427, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1137, 71, 'gJYAABt6LrHtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13792, 13792, 0, 13792, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1138, 71, 'gJYAABt6LrbtSYg5', 'e5ycaHwEQBWozoftMjbxyh0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 3427, 3427, 0, 3427, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1139, 72, 'gJYAABt6LsntSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 96, 96, 0, 96, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1140, 72, 'gJYAABt6LtLtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 455, 455, 0, 455, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1141, 72, 'gJYAABt6LsftSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3034, 3034, 0, 3034, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1142, 72, 'gJYAABt6LtbtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 16954, 16954, 0, 16954, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1143, 72, 'gJYAABt6LtPtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1144, 72, 'gJYAABt6LsztSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 44, 44, 0, 44, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1145, 72, 'gJYAABt6LsrtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 761, 761, 0, 761, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1146, 72, 'gJYAABt6LsvtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 7606, 7606, 0, 7606, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1147, 72, 'gJYAABt6Ls/tSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 54, 54, 0, 54, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1148, 72, 'gJYAABt6Ls7tSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 15098, 15098, 0, 15098, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1149, 72, 'gJYAABt6LtHtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1150, 72, 'gJYAABt6LsjtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 147, 147, 0, 147, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1151, 72, 'gJYAABt6LtXtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3751, 3751, 0, 3751, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1152, 72, 'gJYAABt6LtTtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 735, 735, 0, 735, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1153, 72, 'gJYAABt6Ls3tSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 15098, 15098, 0, 15098, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1154, 72, 'gJYAABt6LtDtSYg5', 'eWcLlt+YTbq51FMPNHMe1h0NgN0=', 'gJYAABctXHFECefw', '06.10.03.001.0089', 'DICE', 'S-DICE-BXCD1130', '千个', 11253, 11253, 0, 11253, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1155, 73, 'gJYAABt6LtvtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 43, 43, 0, 43, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1156, 73, 'gJYAABt6LtrtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 70, 70, 0, 70, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1157, 73, 'gJYAABt6LuTtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1140, 1140, 0, 1140, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1158, 73, 'gJYAABt6LujtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7589, 7589, 0, 7589, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1159, 73, 'gJYAABt6LuftSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1160, 73, 'gJYAABt6Lt3tSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1161, 73, 'gJYAABt6LubtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 340, 340, 0, 340, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1162, 73, 'gJYAABt6Lt7tSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3405, 3405, 0, 3405, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1163, 73, 'gJYAABt6LuDtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 24, 24, 0, 24, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1164, 73, 'gJYAABt6LuPtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6758, 6758, 0, 6758, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1165, 73, 'gJYAABt6LuntSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1166, 73, 'gJYAABt6Lt/tSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 66, 66, 0, 66, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1167, 73, 'gJYAABt6LuLtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1679, 1679, 0, 1679, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1168, 73, 'gJYAABt6LtztSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 329, 329, 0, 329, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1169, 73, 'gJYAABt6LuXtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6758, 6758, 0, 6758, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1170, 73, 'gJYAABt6LuHtSYg5', 'zIEmLHFlRiyLvcYiMJKd0R0NgN0=', 'gJYAABctXHFECefw', '06.10.03.001.0089', 'DICE', 'S-DICE-BXCD1130', '千个', 5037, 5037, 0, 5037, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1171, 74, 'gJYAABt6LvntSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 466, 466, 0, 466, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1172, 74, 'gJYAABt6LvrtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 85, 85, 0, 85, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1173, 74, 'gJYAABt6LvTtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2903, 2903, 0, 2903, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1174, 74, 'gJYAABt6LvvtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6276, 6276, 0, 6276, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1175, 74, 'gJYAABt6LvftSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1176, 74, 'gJYAABt6LvHtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 26, 26, 0, 26, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1177, 74, 'gJYAABt6Lv7tSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 649, 649, 0, 649, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1178, 74, 'gJYAABt6LvLtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6493, 6493, 0, 6493, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1179, 74, 'gJYAABt6LvDtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 46, 46, 0, 46, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1180, 74, 'gJYAABt6LvjtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12888, 12888, 0, 12888, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1181, 74, 'gJYAABt6LvztSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1182, 74, 'gJYAABt6Lv/tSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 126, 126, 0, 126, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1183, 74, 'gJYAABt6LvXtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3202, 3202, 0, 3202, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1184, 74, 'gJYAABt6LvbtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 628, 628, 0, 628, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1185, 74, 'gJYAABt6Lv3tSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12888, 12888, 0, 12888, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1186, 74, 'gJYAABt6LvPtSYg5', 'Q9hB0hmdSdyuCVYJRvxTax0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 3202, 3202, 0, 3202, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1187, 75, 'gJYAABt6LxXtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 209, 209, 0, 209, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1188, 75, 'gJYAABt6LxbtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 338, 338, 0, 338, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1189, 75, 'gJYAABt6LxftSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 5781, 5781, 0, 5781, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1190, 75, 'gJYAABt6Lx/tSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 36859, 36859, 0, 36859, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1191, 75, 'gJYAABt6LxrtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 163, 163, 0, 163, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1192, 75, 'gJYAABt6LxztSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 95, 95, 0, 145, 50, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1193, 75, 'gJYAABt6Lx7tSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1654, 1654, 0, 1654, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1194, 75, 'gJYAABt6LyTtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 16536, 16536, 0, 16536, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1195, 75, 'gJYAABt6LxvtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 118, 118, 0, 118, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1196, 75, 'gJYAABt6LxjtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 32823, 32823, 0, 32823, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1197, 75, 'gJYAABt6LxntSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1198, 75, 'gJYAABt6LyDtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 320, 320, 0, 320, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1199, 75, 'gJYAABt6LyLtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 8155, 8155, 0, 8155, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1200, 75, 'gJYAABt6LyHtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1598, 1598, 0, 1598, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1201, 75, 'gJYAABt6Lx3tSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 32823, 32823, 0, 32823, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1202, 75, 'gJYAABt6LyPtSYg5', '1rXtOuLdQnOJa4CKaaNjfx0NgN0=', 'gJYAABctXHFECefw', '06.10.03.001.0089', 'DICE', 'S-DICE-BXCD1130', '千个', 24464, 24464, 0, 24464, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1203, 76, 'gJYAABt6LzHtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 3359, 3359, 0, 3359, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1204, 76, 'gJYAABt6LyrtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 116, 116, 0, 116, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1205, 76, 'gJYAABt6Ly3tSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 599, 599, 0, 599, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1206, 76, 'gJYAABt6LzPtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 17494, 17494, 0, 17494, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1207, 76, 'gJYAABt6Ly/tSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 84, 84, 0, 84, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1208, 76, 'gJYAABt6LyjtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 61, 61, 0, 61, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1209, 76, 'gJYAABt6LyftSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 860, 860, 0, 860, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1210, 76, 'gJYAABt6LzTtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 8598, 8598, 0, 8598, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1211, 76, 'gJYAABt6LzXtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 51, 51, 0, 51, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1212, 76, 'gJYAABt6LzDtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 16885, 16885, 0, 16885, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1213, 76, 'gJYAABt6LyvtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1214, 76, 'gJYAABt6LyztSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 164, 164, 0, 164, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1215, 76, 'gJYAABt6LzbtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 4195, 4195, 0, 4195, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1216, 76, 'gJYAABt6LzLtSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 822, 822, 0, 822, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1217, 76, 'gJYAABt6Ly7tSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 16885, 16885, 0, 16885, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1218, 76, 'gJYAABt6LyntSYg5', 'ZjWJsr4hTzC5uLOKNLx4Qh0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 12585, 12585, 0, 12585, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1219, 77, 'gJYAABt6L0ftSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 907, 907, 0, 907, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1220, 77, 'gJYAABt6L0PtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 49, 49, 0, 49, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1221, 77, 'gJYAABt6L0ntSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 17, 17, 0, 17, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1222, 77, 'gJYAABt6L0XtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5135, 5135, 0, 5135, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1223, 77, 'gJYAABt6L0TtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1224, 77, 'gJYAABt6Lz7tSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1225, 77, 'gJYAABt6L0jtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 332, 332, 0, 332, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1226, 77, 'gJYAABt6L0ztSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3324, 3324, 0, 3324, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1227, 77, 'gJYAABt6Lz/tSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 23, 23, 0, 23, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1228, 77, 'gJYAABt6L0LtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4956, 4956, 0, 4956, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1229, 77, 'gJYAABt6L0btSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1230, 77, 'gJYAABt6L0HtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 48, 48, 0, 48, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1231, 77, 'gJYAABt6L0vtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1231, 1231, 0, 1231, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1232, 77, 'gJYAABt6L03tSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 241, 241, 0, 241, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1233, 77, 'gJYAABt6L0rtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4956, 4956, 0, 4956, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1234, 77, 'gJYAABt6L0DtSYg5', '889kQuqzRMG+q3/ULQxqqx0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 3694, 3694, 0, 3694, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1235, 78, 'gJYAABt8WVTtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 6000, 6000, 0, 6000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1236, 78, 'gJYAABt8WVftSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1754, 1754, 0, 0, 0, 2, 1754);
INSERT INTO `eas_wo_dtl` VALUES (1237, 78, 'gJYAABt8WVDtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 772, 772, 0, 772, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1238, 78, 'gJYAABt8WVbtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 18, 18, 0, 0, 0, 2, 18);
INSERT INTO `eas_wo_dtl` VALUES (1239, 78, 'gJYAABt8WVXtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 9040, 9040, 0, 9040, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1240, 78, 'gJYAABt8WVjtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1241, 78, 'gJYAABt8WU/tSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1242, 78, 'gJYAABt8WVrtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 351, 351, 0, 351, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1243, 78, 'gJYAABt8WUztSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3508, 3508, 0, 3508, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1244, 78, 'gJYAABt8WVntSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 28, 28, 0, 28, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1245, 78, 'gJYAABt8WVPtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8050, 8050, 0, 8050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1246, 78, 'gJYAABt8WVHtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 109, 109, 0, 109, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1247, 78, 'gJYAABt8WU3tSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1248, 78, 'gJYAABt8WVLtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 109, 109, 0, 109, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1249, 78, 'gJYAABt8WU7tSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2000, 2000, 0, 2000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1250, 78, 'gJYAABt8WVvtSYg5', 'nTkYn5eLRTa8NIUSmf9uIB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8050, 8050, 0, 8050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1251, 79, 'gJYAABt8WWTtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 10200, 10200, 0, 10200, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1252, 79, 'gJYAABt8WWftSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 6083, 6083, 0, 0, 0, 2, 6083);
INSERT INTO `eas_wo_dtl` VALUES (1253, 79, 'gJYAABt8WWXtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1809, 1809, 0, 648, 0, 2, 1161);
INSERT INTO `eas_wo_dtl` VALUES (1254, 79, 'gJYAABt8WWvtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 263, 263, 0, 0, 0, 2, 263);
INSERT INTO `eas_wo_dtl` VALUES (1255, 79, 'gJYAABt8WXDtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 15368, 15368, 0, 15368, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1256, 79, 'gJYAABt8WXHtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 57, 57, 0, 57, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1257, 79, 'gJYAABt8WWrtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1258, 79, 'gJYAABt8WW7tSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 586, 586, 0, 586, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1259, 79, 'gJYAABt8WW/tSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5861, 5861, 0, 5861, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1260, 79, 'gJYAABt8WWbtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 13685, 13685, 0, 13685, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1261, 79, 'gJYAABt8WXLtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 185, 185, 0, 185, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1262, 79, 'gJYAABt8WWztSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1263, 79, 'gJYAABt8WWjtSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 185, 185, 0, 185, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1264, 79, 'gJYAABt8WW3tSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3400, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1265, 79, 'gJYAABuZ9IztSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3400, 3400, 0, 3400, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1266, 79, 'gJYAABt8WWntSYg5', 'uCiBe6FFQK+2/rufKxvEZx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13685, 13685, 0, 13685, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1267, 80, 'gJYAABt8WXftSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 46, 46, 0, 46, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1268, 80, 'gJYAABt8WYXtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1980, 1980, 0, 1980, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1269, 80, 'gJYAABt8WXrtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 100, 100, 0, 100, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1270, 80, 'gJYAABt8WYDtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4204, 4204, 0, 4204, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1271, 80, 'gJYAABt8WYPtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1272, 80, 'gJYAABt8WXntSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1273, 80, 'gJYAABt8WYHtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 446, 446, 0, 446, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1274, 80, 'gJYAABt8WX/tSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 4458, 4458, 0, 4458, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1275, 80, 'gJYAABt8WX7tSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 36, 36, 0, 36, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1276, 80, 'gJYAABt8WYbtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 8545, 8545, 0, 8545, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1277, 80, 'gJYAABt8WYTtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 116, 116, 0, 116, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1278, 80, 'gJYAABt8WYLtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1279, 80, 'gJYAABt8WXvtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 116, 116, 0, 116, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1280, 80, 'gJYAABt8WXztSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2123, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1281, 80, 'gJYAABuZ9NvtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2123, 2123, 0, 2123, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1282, 80, 'gJYAABt8WXjtSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8545, 8545, 0, 8545, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1283, 80, 'gJYAABt8WX3tSYg5', 'TdcxWvBJSNuBvI8eKC9DnR0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 2123, 2123, 0, 2123, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1284, 81, 'gJYAABuEFgbtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 43, 43, 0, 43, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1285, 81, 'gJYAABuEFgvtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2819, 2819, 0, 2819, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1286, 81, 'gJYAABuEFgLtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 106, 106, 0, 106, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1287, 81, 'gJYAABuEFgjtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7340, 7340, 0, 7340, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1288, 81, 'gJYAABuEFf/tSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 19, 19, 0, 19, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1289, 81, 'gJYAABuEFf7tSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1290, 81, 'gJYAABuEFgPtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 778, 778, 0, 778, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1291, 81, 'gJYAABuEFgXtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 7784, 7784, 0, 7784, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1292, 81, 'gJYAABuEFgntSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 57, 57, 0, 57, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1293, 81, 'gJYAABuEFgHtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 14922, 14922, 0, 14922, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1294, 81, 'gJYAABuEFf3tSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 202, 202, 0, 202, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1295, 81, 'gJYAABuEFgDtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1296, 81, 'gJYAABuEFgftSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 202, 202, 0, 202, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1297, 81, 'gJYAABuEFgrtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3707, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1298, 81, 'gJYAABuZ9PLtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 370731, 3707, 0, 113129, 109422, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1299, 81, 'gJYAABuEFgTtSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 14922, 14922, 0, 14922, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1300, 81, 'gJYAABuEFfztSYg5', 'gdjfZg8BS+ulOM1xluISfx0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 3707, 3707, 0, 3707, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1301, 82, 'gJYAABuEFiHtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 235, 235, 0, 235, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1302, 82, 'gJYAABuEFiTtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 189, 189, 0, 189, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1303, 82, 'gJYAABuEFh3tSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 6009, 6009, 0, 6009, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1304, 82, 'gJYAABuEFhvtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAAwdkHhECefw', '01.02.01.006.0066', '键合银丝', 'JHB-J-23um', '米', 14717, 14717, 0, 14717, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1305, 82, 'gJYAABuEFhztSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 63, 63, 0, 63, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1306, 82, 'gJYAABuEFhftSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1307, 82, 'gJYAABuEFiPtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1032, 1032, 0, 1032, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1308, 82, 'gJYAABuEFiDtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 10318, 10318, 0, 10318, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1309, 82, 'gJYAABuEFhntSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 95, 95, 0, 95, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1310, 82, 'gJYAABuEFh/tSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 20148, 20148, 0, 20148, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1311, 82, 'gJYAABuEFhbtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1312, 82, 'gJYAABuEFhrtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 196, 196, 0, 196, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1313, 82, 'gJYAABuEFhjtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5006, 5006, 0, 5006, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1314, 82, 'gJYAABuEFh7tSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 981, 981, 0, 981, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1315, 82, 'gJYAABuEFiLtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 20148, 20148, 0, 20148, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1316, 82, 'gJYAABuEFhXtSYg5', 'Q3FMArhmRBKPKPVHQjmyNB0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 10012, 10012, 0, 10012, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1317, 83, 'gJYAABuKXabtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 81, 81, 0, 81, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1318, 83, 'gJYAABuKXaDtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 42, 42, 0, 42, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1319, 83, 'gJYAABuKXaHtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 603, 603, 0, 603, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1320, 83, 'gJYAABuKXZvtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1737, 1737, 0, 1737, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1321, 83, 'gJYAABuKXZntSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1322, 83, 'gJYAABuKXaXtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1323, 83, 'gJYAABuKXaftSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 184, 184, 0, 184, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1324, 83, 'gJYAABuKXaLtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 1842, 1842, 0, 1842, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1325, 83, 'gJYAABuKXZ3tSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 14, 14, 0, 14, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1326, 83, 'gJYAABuKXaPtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 3532, 3532, 0, 3532, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1327, 83, 'gJYAABuKXZjtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 48, 48, 0, 48, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1328, 83, 'gJYAABuKXaTtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1329, 83, 'gJYAABuKXZrtSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 48, 48, 0, 48, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1330, 83, 'gJYAABuKXZ/tSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 877, 877, 0, 877, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1331, 83, 'gJYAABuKXZ7tSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 3532, 3532, 0, 3532, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1332, 83, 'gJYAABuKXZztSYg5', 'mq7A7wqfRoiidhPEMYjisB0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 877, 877, 0, 877, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1333, 84, 'gJYAABuO8iLtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 14016, 14016, 0, 14016, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1334, 84, 'gJYAABuO8h/tSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 2025, 2025, 0, 2025, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1335, 84, 'gJYAABuO8ijtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 32471, 32471, 0, 32471, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1336, 84, 'gJYAABuO8iTtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 156, 156, 0, 156, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1337, 84, 'gJYAABuO8ivtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 157, 157, 0, 157, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1338, 84, 'gJYAABuO8irtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1596, 1596, 0, 1596, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1339, 84, 'gJYAABuO8iftSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 15958, 15958, 0, 15958, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1340, 84, 'gJYAABuO8iDtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 94, 94, 0, 94, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1341, 84, 'gJYAABuO8iHtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 31342, 31342, 0, 31342, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1342, 84, 'gJYAABuO8iztSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1343, 84, 'gJYAABuO8i3tSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 305, 305, 0, 305, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1344, 84, 'gJYAABuO8intSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7787, 7787, 0, 7787, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1345, 84, 'gJYAABuO8iXtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1526, 1526, 0, 1526, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1346, 84, 'gJYAABuO8ibtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 31342, 31342, 0, 31342, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1347, 84, 'gJYAABuO8iPtSYg5', 'Q4LMFpbRSL6v7/NbqdRhXB0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 23360, 23360, 0, 23360, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1348, 85, 'gJYAABuO8j/tSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2407, 2407, 0, 2407, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1349, 85, 'gJYAABuO8jftSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 50, 50, 0, 50, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1350, 85, 'gJYAABuO8jztSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAAAwdkHhECefw', '01.02.01.006.0066', '键合银丝', 'JHB-J-23um', '米', 8828, 8828, 0, 8828, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1351, 85, 'gJYAABuO8j7tSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 29, 29, 0, 29, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1352, 85, 'gJYAABuO8jTtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 35, 35, 0, 35, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1353, 85, 'gJYAABuO8kLtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 609, 609, 0, 609, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1354, 85, 'gJYAABuO8jntSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6091, 6091, 0, 6091, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1355, 85, 'gJYAABuO8jbtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 50, 50, 0, 50, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1356, 85, 'gJYAABuO8kHtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12086, 12086, 0, 12086, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1357, 85, 'gJYAABuO8jvtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1358, 85, 'gJYAABuO8jjtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 118, 118, 0, 118, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1359, 85, 'gJYAABuO8j3tSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3003, 3003, 0, 3003, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1360, 85, 'gJYAABuO8jXtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 589, 589, 0, 589, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1361, 85, 'gJYAABuO8kDtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12086, 12086, 0, 12086, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1362, 85, 'gJYAABuO8jrtSYg5', 'fxyo4ZrKTAGvOYFvHtSxBB0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 6005, 6005, 0, 6005, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1363, 86, 'gJYAABuO8mXtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 357, 357, 0, 357, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1364, 86, 'gJYAABuO8mPtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 397, 397, 0, 397, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1365, 86, 'gJYAABuO8l/tSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 10540, 10540, 0, 10540, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1366, 86, 'gJYAABuO8mTtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAAwdkHhECefw', '01.02.01.006.0066', '键合银丝', 'JHB-J-23um', '米', 40977, 40977, 0, 40977, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1367, 86, 'gJYAABuO8mbtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 134, 134, 0, 134, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1368, 86, 'gJYAABuO8mftSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 163, 163, 0, 163, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1369, 86, 'gJYAABuO8lrtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2828, 2828, 0, 2828, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1370, 86, 'gJYAABuO8mLtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 28274, 28274, 0, 28274, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1371, 86, 'gJYAABuO8lvtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 202, 202, 0, 202, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1372, 86, 'gJYAABuO8lntSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 56099, 56099, 0, 56099, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1373, 86, 'gJYAABuO8l3tSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 55, 55, 0, 55, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1374, 86, 'gJYAABuO8ljtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 546, 546, 0, 546, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1375, 86, 'gJYAABuO8mDtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 13938, 13938, 0, 13938, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1376, 86, 'gJYAABuO8l7tSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2732, 2732, 0, 2732, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1377, 86, 'gJYAABuO8lztSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 56099, 56099, 0, 56099, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1378, 86, 'gJYAABuO8mHtSYg5', 'TCyg8f4HTVSkMtBsDsuI9x0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 27875, 27875, 0, 27875, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1379, 87, 'gJYAABuQQm/tSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 170, 170, 0, 170, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1380, 87, 'gJYAABuQQmPtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2905, 2905, 0, 2905, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1381, 87, 'gJYAABuQQm7tSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 508, 508, 0, 508, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1382, 87, 'gJYAABuQQmbtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7044, 7044, 0, 7044, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1383, 87, 'gJYAABuQQmXtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1384, 87, 'gJYAABuQQmLtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1385, 87, 'gJYAABuQQmntSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 747, 747, 0, 747, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1386, 87, 'gJYAABuQQmHtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 7470, 7470, 0, 7470, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1387, 87, 'gJYAABuQQm3tSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 55, 55, 0, 55, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1388, 87, 'gJYAABuQQmjtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 14320, 14320, 0, 14320, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1389, 87, 'gJYAABuQQmrtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 194, 194, 0, 194, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1390, 87, 'gJYAABuQQmftSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1391, 87, 'gJYAABuQQmvtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 194, 194, 0, 194, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1392, 87, 'gJYAABuQQmztSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3558, 3558, 0, 3558, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1393, 87, 'gJYAABuQQmTtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 14320, 14320, 0, 14320, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1394, 87, 'gJYAABuQQmDtSYg5', 'B75qd/xNTHmKENRSp85Z9B0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 3558, 3558, 0, 3558, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1395, 88, 'gJYAABuQQnvtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 1113, 1113, 0, 1113, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1396, 88, 'gJYAABuQQnbtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAA2PVBJECefw', '01.02.01.001.1048', '荧光粉', 'GAL525-M', '克', 477, 477, 0, 477, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1397, 88, 'gJYAABuQQoPtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 216, 216, 0, 216, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1398, 88, 'gJYAABuQQnrtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10014, 10014, 0, 10014, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1399, 88, 'gJYAABuQQnztSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 48, 48, 0, 48, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1400, 88, 'gJYAABuQQnntSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 35, 35, 0, 35, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1401, 88, 'gJYAABuQQnjtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 556, 556, 0, 556, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1402, 88, 'gJYAABuQQnXtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 5565, 5565, 0, 5565, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1403, 88, 'gJYAABuQQoLtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 48, 48, 0, 48, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1404, 88, 'gJYAABuQQn3tSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 9666, 9666, 0, 9666, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1405, 88, 'gJYAABuQQnftSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1406, 88, 'gJYAABuQQoDtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 94, 94, 0, 94, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1407, 88, 'gJYAABuQQnTtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2401, 2401, 0, 2401, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1408, 88, 'gJYAABuQQn7tSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 471, 471, 0, 471, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1409, 88, 'gJYAABuQQn/tSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 9666, 9666, 0, 9666, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1410, 88, 'gJYAABuQQoHtSYg5', 'nx+w4EihRv2rL7su4Dq0xB0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 7204, 7204, 0, 7204, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1411, 89, 'gJYAABuQQo3tSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 420, 420, 0, 420, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1412, 89, 'gJYAABuQQpXtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 77, 77, 0, 77, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1413, 89, 'gJYAABuQQo7tSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 9, 9, 0, 9, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1414, 89, 'gJYAABuQQpftSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1344, 1344, 0, 1344, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1415, 89, 'gJYAABuQQpTtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1416, 89, 'gJYAABuQQpLtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1417, 89, 'gJYAABuQQpjtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 87, 87, 0, 87, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1418, 89, 'gJYAABuQQpHtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 868, 868, 0, 868, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1419, 89, 'gJYAABuQQpDtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 10, 10, 0, 10, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1420, 89, 'gJYAABuQQoztSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1195, 1195, 0, 1195, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1421, 89, 'gJYAABuQQpbtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1422, 89, 'gJYAABuQQovtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1423, 89, 'gJYAABuQQpntSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 297, 297, 0, 297, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1424, 89, 'gJYAABuQQprtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 58, 58, 0, 58, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1425, 89, 'gJYAABuQQo/tSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1195, 1195, 0, 1195, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1426, 89, 'gJYAABuQQpPtSYg5', 'Ng4awPc+RhaYw8Dg2x8Dtx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 890, 890, 0, 890, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1427, 90, 'gJYAABuQQqXtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 42, 42, 0, 42, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1428, 90, 'gJYAABuQQq3tSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1862, 1862, 0, 1862, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1429, 90, 'gJYAABuQQqLtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 47, 47, 0, 47, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1430, 90, 'gJYAABuQQq7tSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAAAwdkHhECefw', '01.02.01.006.0066', '键合银丝', 'JHB-J-23um', '米', 7033, 7033, 0, 9033, 2000, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1431, 90, 'gJYAABuQQqjtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1432, 90, 'gJYAABuQQqrtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1433, 90, 'gJYAABuQQqPtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 485, 485, 0, 485, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1434, 90, 'gJYAABuQQqDtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4853, 4853, 0, 4853, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1435, 90, 'gJYAABuQQqftSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 35, 35, 0, 35, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1436, 90, 'gJYAABuQQqbtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 9628, 9628, 0, 9628, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1437, 90, 'gJYAABuQQqntSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1438, 90, 'gJYAABuQQqztSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 94, 94, 0, 94, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1439, 90, 'gJYAABuQQqTtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2392, 2392, 0, 2392, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1440, 90, 'gJYAABuQQqHtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 469, 469, 0, 469, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1441, 90, 'gJYAABuQQqvtSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 9628, 9628, 0, 9628, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1442, 90, 'gJYAABuQQp/tSYg5', 'ZYAgeaspQRuTUDiH7GW0zR0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 4784, 4784, 0, 4784, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1443, 91, 'gJYAABuQQsDtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABiChQBECefw', '01.01.01.010.3459', 'DICE', 'DICE-BPA0F11A', '千个', 50000, 38244, 0, 38244, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1444, 91, 'gJYAABuZSG7tSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 50000, 11756, 0, 11756, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1445, 91, 'gJYAABuQQrvtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 22255, 22255, 0, 22255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1446, 91, 'gJYAABuQQrntSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 3760, 3760, 0, 3760, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1447, 91, 'gJYAABuQQrztSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABcwNiFECefw', '01.02.01.006.0082', '银线', 'JHB_K_18um', '米', 75050, 75050, 0, 75050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1448, 91, 'gJYAABuQQsHtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1449, 91, 'gJYAABuQQr3tSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 6523, 6523, 0, 6523, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1450, 91, 'gJYAABuQQr/tSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 65230, 65230, 0, 65230, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1451, 91, 'gJYAABuQQrftSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 385, 385, 0, 385, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1452, 91, 'gJYAABuQQrjtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1453, 91, 'gJYAABuQQsXtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1454, 91, 'gJYAABuQQsPtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1455, 91, 'gJYAABuQQsLtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1456, 91, 'gJYAABuQQsTtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1457, 91, 'gJYAABuQQr7tSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1458, 91, 'gJYAABuQQrrtSYg5', 'jnC5v2/pRwCgqinss1nXbx0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1459, 92, 'gJYAABuQQwPtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 5700, 5700, 0, 5700, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1460, 92, 'gJYAABuQQwvtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 3262, 3262, 0, 0, 0, 2, 3262);
INSERT INTO `eas_wo_dtl` VALUES (1461, 92, 'gJYAABuQQwLtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 842, 842, 0, 842, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1462, 92, 'gJYAABuQQwHtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 109, 109, 0, 0, 0, 2, 109);
INSERT INTO `eas_wo_dtl` VALUES (1463, 92, 'gJYAABuQQwftSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 8588, 8588, 0, 8588, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1464, 92, 'gJYAABuQQwXtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1465, 92, 'gJYAABuQQwjtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1466, 92, 'gJYAABuQQwbtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 286, 286, 0, 286, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1467, 92, 'gJYAABuQQv7tSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2861, 2861, 0, 2861, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1468, 92, 'gJYAABuQQwrtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7648, 7648, 0, 7648, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1469, 92, 'gJYAABuQQwTtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 103, 103, 0, 103, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1470, 92, 'gJYAABuQQwntSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1471, 92, 'gJYAABuQQv/tSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 103, 103, 0, 103, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1472, 92, 'gJYAABuQQv3tSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1900, 1900, 0, 1900, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1473, 92, 'gJYAABuQQwDtSYg5', 'UFOLYEAmSPiPKC2382+EAR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7648, 7648, 0, 7648, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1474, 93, 'gJYAABuQRGjtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 3000, 3000, 0, 3000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1475, 93, 'gJYAABuQRHLtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1102, 1102, 0, 0, 0, 2, 1102);
INSERT INTO `eas_wo_dtl` VALUES (1476, 93, 'gJYAABuQRGTtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 409, 409, 0, 409, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1477, 93, 'gJYAABuQRGPtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 37, 37, 0, 0, 0, 2, 37);
INSERT INTO `eas_wo_dtl` VALUES (1478, 93, 'gJYAABuQRGntSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 4520, 4520, 0, 4520, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1479, 93, 'gJYAABuQRG/tSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1480, 93, 'gJYAABuQRGvtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1481, 93, 'gJYAABuQRHHtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 103, 103, 0, 103, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1482, 93, 'gJYAABuQRGXtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1028, 1028, 0, 1028, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1483, 93, 'gJYAABuQRGftSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 8, 8, 0, 8, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1484, 93, 'gJYAABuQRHDtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4025, 4025, 0, 4025, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1485, 93, 'gJYAABuQRG3tSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1486, 93, 'gJYAABuQRGrtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1487, 93, 'gJYAABuQRGbtSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1488, 93, 'gJYAABuQRG7tSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1000, 1000, 0, 1000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1489, 93, 'gJYAABuQRGztSYg5', 'gFxnLqs4SliMd1ZgSeyhZx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4025, 4025, 0, 4025, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1490, 94, 'gJYAABuSz+HtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 10800, 10800, 0, 10800, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1491, 94, 'gJYAABuSz+PtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 6440, 6440, 0, 0, 0, 2, 6440);
INSERT INTO `eas_wo_dtl` VALUES (1492, 94, 'gJYAABuSz+7tSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1915, 1915, 0, 1915, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1493, 94, 'gJYAABuSz+DtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 279, 279, 0, 0, 0, 2, 279);
INSERT INTO `eas_wo_dtl` VALUES (1494, 94, 'gJYAABuSz+vtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 16272, 16272, 0, 16272, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1495, 94, 'gJYAABuSz+ztSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1496, 94, 'gJYAABuSz+btSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 42, 42, 0, 42, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1497, 94, 'gJYAABuSz+ntSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 621, 621, 0, 621, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1498, 94, 'gJYAABuSz+rtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6205, 6205, 0, 6205, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1499, 94, 'gJYAABuSz+LtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 14490, 14490, 0, 14490, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1500, 94, 'gJYAABuSz+3tSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 196, 196, 0, 196, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1501, 94, 'gJYAABuSz+jtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1502, 94, 'gJYAABuSz+TtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 196, 196, 0, 196, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1503, 94, 'gJYAABuSz+ftSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3600, 3600, 0, 3600, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1504, 94, 'gJYAABuSz+XtSYg5', 'RC0UJ126Q9SNgXLBThyr+h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 14490, 14490, 0, 14490, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1505, 95, 'gJYAABuS0ADtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 1200, 1200, 0, 1200, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1506, 95, 'gJYAABuSz/rtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 481, 481, 0, 0, 0, 2, 481);
INSERT INTO `eas_wo_dtl` VALUES (1507, 95, 'gJYAABuSz/jtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 169, 169, 0, 169, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1508, 95, 'gJYAABuSz/btSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 16, 16, 0, 0, 0, 2, 16);
INSERT INTO `eas_wo_dtl` VALUES (1509, 95, 'gJYAABuSz/ntSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 1808, 1808, 0, 1808, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1510, 95, 'gJYAABuSz/PtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1511, 95, 'gJYAABuSz/HtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1512, 95, 'gJYAABuSz/3tSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 81, 81, 0, 81, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1513, 95, 'gJYAABuSz/ftSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 805, 805, 0, 805, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1514, 95, 'gJYAABuSz/LtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 3, 3, 0, 3, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1515, 95, 'gJYAABuSz//tSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1610, 1610, 0, 1610, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1516, 95, 'gJYAABuSz/vtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1517, 95, 'gJYAABuSz/TtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1518, 95, 'gJYAABuSz/ztSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1519, 95, 'gJYAABuSz/XtSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 400, 400, 0, 400, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1520, 95, 'gJYAABuSz/7tSYg5', 'NkZ1kXYSRpmSoAzLJ19qFh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1610, 1610, 0, 1610, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1521, 96, 'gJYAABuS0nvtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 13155, 13155, 0, 13155, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1522, 96, 'gJYAABuS0njtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1900, 1900, 0, 1798, 0, 2, 102);
INSERT INTO `eas_wo_dtl` VALUES (1523, 96, 'gJYAABuS0oHtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 30476, 30476, 0, 30476, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1524, 96, 'gJYAABuS0n3tSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 146, 146, 0, 146, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1525, 96, 'gJYAABuS0oTtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 147, 147, 0, 147, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1526, 96, 'gJYAABuS0oPtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1498, 1498, 0, 1498, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1527, 96, 'gJYAABuS0oDtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 14978, 14978, 0, 14978, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1528, 96, 'gJYAABuS0nntSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 88, 88, 0, 88, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1529, 96, 'gJYAABuS0nrtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 29416, 29416, 0, 29416, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1530, 96, 'gJYAABuS0oXtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 29, 29, 0, 29, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1531, 96, 'gJYAABuS0obtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 286, 286, 0, 286, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1532, 96, 'gJYAABuS0oLtSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7308, 7308, 0, 7308, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1533, 96, 'gJYAABuS0n7tSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1432, 1432, 0, 1432, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1534, 96, 'gJYAABuS0n/tSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 29416, 29416, 0, 29416, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1535, 96, 'gJYAABuS0nztSYg5', 'Jeg0IZgETA2vQ2gjFs/8Ux0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 21925, 21925, 0, 21925, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1536, 97, 'gJYAABuUOgvtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 96, 96, 0, 96, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1537, 97, 'gJYAABuUOhXtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 95, 95, 0, 95, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1538, 97, 'gJYAABuUOgjtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1664, 1664, 0, 1664, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1539, 97, 'gJYAABuUOgztSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 3919, 3919, 0, 3919, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1540, 97, 'gJYAABuUOg/tSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1541, 97, 'gJYAABuUOhHtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1542, 97, 'gJYAABuUOg3tSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 420, 420, 0, 420, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1543, 97, 'gJYAABuUOhPtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 4198, 4198, 0, 4198, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1544, 97, 'gJYAABuUOhTtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 31, 31, 0, 31, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1545, 97, 'gJYAABuUOhbtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 8048, 8048, 0, 8048, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1546, 97, 'gJYAABuUOg7tSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 108, 108, 0, 108, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1547, 97, 'gJYAABuUOhDtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1548, 97, 'gJYAABuUOgntSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 110, 110, 0, 110, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1549, 97, 'gJYAABuUOhLtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1999, 1999, 0, 1999, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1550, 97, 'gJYAABuUOgrtSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8048, 8048, 0, 8048, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1551, 97, 'gJYAABuUOhftSYg5', 'dkK3EOJjQC2ZPeGyVCAiiR0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 1999, 1999, 0, 1999, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1552, 98, 'gJYAABuUOintSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAABX2Dn9ECefw', '01.02.01.001.1253', '荧光粉', 'KSL520', '克', 138, 138, 0, 0, 0, 2, 138);
INSERT INTO `eas_wo_dtl` VALUES (1553, 98, 'gJYAABuUOijtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAABX2Ai9ECefw', '01.02.01.001.1254', '荧光粉', 'KSL530', '克', 20, 20, 0, 0, 0, 2, 20);
INSERT INTO `eas_wo_dtl` VALUES (1554, 98, 'gJYAABuUOh7tSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAABX2DjNECefw', '01.02.01.001.1255', '荧光粉', 'KSL540', '克', 138, 138, 0, 0, 0, 2, 138);
INSERT INTO `eas_wo_dtl` VALUES (1555, 98, 'gJYAABuUOirtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2208, 2208, 0, 2208, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1556, 98, 'gJYAABuUOh/tSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1557, 98, 'gJYAABuUOh3tSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1558, 98, 'gJYAABuUOiPtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 132, 132, 0, 132, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1559, 98, 'gJYAABuUOivtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1324, 1324, 0, 1324, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1560, 98, 'gJYAABuUOiTtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 8, 8, 0, 8, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1561, 98, 'gJYAABuUOiXtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 3023, 3023, 0, 6047, 3023, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1562, 98, 'gJYAABuUOiftSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (1563, 98, 'gJYAABuUOiLtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 146, 146, 0, 146, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1564, 98, 'gJYAABuUOibtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 751, 751, 0, 1068, 316, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1565, 98, 'gJYAABuUOiztSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 147, 147, 0, 294, 147, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1566, 98, 'gJYAABuUOiDtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 3023, 3023, 0, 6047, 3023, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1567, 98, 'gJYAABuUOiHtSYg5', 'UHBf2KvHQLK76xQuVB4zwR0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 1502, 1502, 0, 1502, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1568, 99, 'gJYAABuUOkTtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 365, 365, 0, 150, 0, 2, 215);
INSERT INTO `eas_wo_dtl` VALUES (1569, 99, 'gJYAABuUOkLtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 1389, 1389, 0, 1389, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1570, 99, 'gJYAABuUOjjtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 9798, 9798, 0, 9798, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1571, 99, 'gJYAABuUOj/tSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 20075, 20075, 0, 20075, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1572, 99, 'gJYAABuUOkDtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 51, 51, 0, 51, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1573, 99, 'gJYAABuUOjrtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 82, 82, 0, 82, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1574, 99, 'gJYAABuUOkPtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2077, 2077, 0, 2077, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1575, 99, 'gJYAABuUOkHtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 20770, 20770, 0, 20770, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1576, 99, 'gJYAABuUOjbtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 149, 149, 0, 149, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1577, 99, 'gJYAABuUOjvtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 41226, 41226, 0, 41226, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1578, 99, 'gJYAABuUOjftSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1579, 99, 'gJYAABuUOj3tSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 402, 402, 0, 402, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1580, 99, 'gJYAABuUOjntSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 10242, 10242, 0, 10242, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1581, 99, 'gJYAABuUOjXtSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2008, 2008, 0, 2008, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1582, 99, 'gJYAABuUOjztSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 41226, 41226, 0, 41226, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1583, 99, 'gJYAABuUOj7tSYg5', 'pvmMAvHCT2KsVMURS0HU8B0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 10242, 10242, 0, 10242, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1584, 100, 'gJYAABuUOkftSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 107, 107, 0, 107, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1585, 100, 'gJYAABuUOkrtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2275, 2275, 0, 2275, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1586, 100, 'gJYAABuUOlbtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 770, 770, 0, 770, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1587, 100, 'gJYAABuUOlPtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5896, 5896, 0, 5896, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1588, 100, 'gJYAABuUOk3tSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1589, 100, 'gJYAABuUOlXtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1590, 100, 'gJYAABuUOk7tSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 610, 610, 0, 610, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1591, 100, 'gJYAABuUOlTtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6102, 6102, 0, 6102, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1592, 100, 'gJYAABuUOkztSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 44, 44, 0, 44, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1593, 100, 'gJYAABuUOlDtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12107, 12107, 0, 12107, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1594, 100, 'gJYAABuUOkntSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1595, 100, 'gJYAABuUOkvtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 118, 118, 0, 118, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1596, 100, 'gJYAABuUOk/tSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 3008, 3008, 0, 3008, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1597, 100, 'gJYAABuUOkjtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 590, 590, 0, 590, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1598, 100, 'gJYAABuUOlLtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12107, 12107, 0, 12107, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1599, 100, 'gJYAABuUOlHtSYg5', 'byg1s/W7RgClxmdActOT9R0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 3008, 3008, 0, 3008, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1600, 101, 'gJYAABuUOmbtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2412, 2412, 0, 2412, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1601, 101, 'gJYAABuUOl7tSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 51, 51, 0, 51, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1602, 101, 'gJYAABuUOl3tSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5898, 5898, 0, 5898, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1603, 101, 'gJYAABuUOmPtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1604, 101, 'gJYAABuUOmLtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1605, 101, 'gJYAABuUOlvtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 778, 778, 0, 778, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1606, 101, 'gJYAABuUOmHtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 7778, 7778, 0, 7778, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1607, 101, 'gJYAABuUOlztSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 50, 50, 0, 50, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1608, 101, 'gJYAABuUOmDtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12111, 12111, 0, 12111, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1609, 101, 'gJYAABuUOl/tSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1610, 101, 'gJYAABuUOmTtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 118, 118, 0, 118, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1611, 101, 'gJYAABue8GntSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABmA9yNECefw', '02.03.20.002.1308', '平面支架', '2836A_C2072_20_A4A20', '千个', 3009, 15, 0, 15, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1612, 101, 'gJYAABuUOmXtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 3009, 2994, 0, 2994, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1613, 101, 'gJYAABuUOlrtSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 590, 590, 0, 590, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1614, 101, 'gJYAABuUOmftSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12111, 12111, 0, 12111, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1615, 101, 'gJYAABuUOlntSYg5', 'lv2c9WWvSaWm8DwWGo8H1R0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 3009, 3009, 0, 3009, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1616, 102, 'gJYAABuUOnztSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 53, 53, 0, 53, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1617, 102, 'gJYAABuUOn3tSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2341, 2341, 0, 2341, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1618, 102, 'gJYAABuUOnrtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 59, 59, 0, 59, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1619, 102, 'gJYAABuUOoPtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5893, 5893, 0, 5893, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1620, 102, 'gJYAABuUOnntSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1621, 102, 'gJYAABuUOnvtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1622, 102, 'gJYAABuUOnftSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 707, 707, 0, 707, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1623, 102, 'gJYAABuUOnXtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 7072, 7072, 0, 7072, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1624, 102, 'gJYAABuUOn7tSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 44, 44, 0, 44, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1625, 102, 'gJYAABuUOnjtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12101, 12101, 0, 12101, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1626, 102, 'gJYAABuUOoTtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 118, 118, 0, 118, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1627, 102, 'gJYAABuUOoHtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1628, 102, 'gJYAABvREnTtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 118, 106, 0, 0, 0, NULL, 106);
INSERT INTO `eas_wo_dtl` VALUES (1629, 102, 'gJYAABue8G/tSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABmA9yNECefw', '02.03.20.002.1308', '平面支架', '2836A_C2072_20_A4A20', '千个', 3006, 3006, 0, 3006, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1630, 102, 'gJYAABuUOn/tSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 3006, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1631, 102, 'gJYAABuUOnbtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 589, 589, 0, 589, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1632, 102, 'gJYAABuUOoLtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12101, 12101, 0, 12101, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1633, 102, 'gJYAABuUOoDtSYg5', 'CDtXsT1pS8CeNK/c5Q/KaR0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 3006, 3006, 0, 3006, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1634, 103, 'gJYAABuV79PtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABX2Dn9ECefw', '01.02.01.001.1253', '荧光粉', 'KSL520', '克', 393, 393, 0, 0, 0, 2, 393);
INSERT INTO `eas_wo_dtl` VALUES (1635, 103, 'gJYAABuV78vtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABX2Ai9ECefw', '01.02.01.001.1254', '荧光粉', 'KSL530', '克', 57, 57, 0, 0, 0, 2, 57);
INSERT INTO `eas_wo_dtl` VALUES (1636, 103, 'gJYAABuV79TtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 736, 736, 0, 736, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1637, 103, 'gJYAABuV78jtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6300, 6300, 0, 6300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1638, 103, 'gJYAABuV78ftSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1639, 103, 'gJYAABuV79LtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1640, 103, 'gJYAABuV787tSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 742, 742, 0, 742, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1641, 103, 'gJYAABuV79XtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 7420, 7420, 0, 7420, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1642, 103, 'gJYAABuV78rtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 24, 24, 0, 24, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1643, 103, 'gJYAABuV783tSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8625, 8625, 0, 8625, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1644, 103, 'gJYAABuV79HtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1645, 103, 'gJYAABuV78btSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 416, 416, 0, 416, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1646, 103, 'gJYAABuV78ztSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2143, 2143, 0, 2143, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1647, 103, 'gJYAABuV78/tSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 420, 420, 0, 420, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1648, 103, 'gJYAABuV79DtSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8625, 8625, 0, 8625, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1649, 103, 'gJYAABuV78ntSYg5', 'nInu1fhfQ8i/3gRVtIjVmx0NgN0=', 'gJYAABctYrpECefw', '06.10.03.001.0073', 'DICE', 'S-DICE-BXCD1734', '千个', 4286, 4286, 0, 4286, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1650, 104, 'gJYAABuV7+ftSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 3, 3, 0, 0, 0, 2, 3);
INSERT INTO `eas_wo_dtl` VALUES (1651, 104, 'gJYAABuV7/LtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 10, 10, 0, 10, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1652, 104, 'gJYAABuV7+TtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 109, 109, 0, 109, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1653, 104, 'gJYAABuV7+7tSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1654, 104, 'gJYAABuV7/DtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1655, 104, 'gJYAABuV7+XtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1656, 104, 'gJYAABuV7+3tSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 22, 22, 0, 22, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1657, 104, 'gJYAABuV7+rtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 218, 218, 0, 218, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1658, 104, 'gJYAABuV7+ntSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1659, 104, 'gJYAABuV7+jtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1660, 104, 'gJYAABuV7+vtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1661, 104, 'gJYAABuV7+ztSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1662, 104, 'gJYAABuV7/HtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 103, 103, 0, 103, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1663, 104, 'gJYAABuV7+/tSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1664, 104, 'gJYAABuV7+PtSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1665, 104, 'gJYAABuV7+btSYg5', 'nVTyJyqTSMuJca4mFiBKqR0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 103, 103, 0, 103, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1666, 105, 'gJYAABuYstjtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 7620, 7620, 0, 7620, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1667, 105, 'gJYAABuYsuDtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 4360, 4360, 0, 0, 0, 2, 4360);
INSERT INTO `eas_wo_dtl` VALUES (1668, 105, 'gJYAABuYstftSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1125, 1125, 0, 1125, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1669, 105, 'gJYAABuYstbtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 146, 146, 0, 0, 0, 2, 146);
INSERT INTO `eas_wo_dtl` VALUES (1670, 105, 'gJYAABuYstztSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 11481, 11481, 0, 11481, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1671, 105, 'gJYAABuYstrtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 42, 42, 0, 42, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1672, 105, 'gJYAABuYst3tSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1673, 105, 'gJYAABuYstvtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 383, 383, 0, 383, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1674, 105, 'gJYAABuYstPtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3825, 3825, 0, 3825, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1675, 105, 'gJYAABuYst/tSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10224, 10224, 0, 10223, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1676, 105, 'gJYAABuYstntSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1677, 105, 'gJYAABuYst7tSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1678, 105, 'gJYAABuYstTtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1679, 105, 'gJYAABuYstLtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2540, 2540, 0, 2540, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1680, 105, 'gJYAABuYstXtSYg5', '66FJJdNITuatI7XUSqblmh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10224, 10224, 0, 10224, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1681, 106, 'gJYAABuaPMPtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 13800, 13800, 0, 13800, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1682, 106, 'gJYAABuaPMbtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 8312, 8312, 0, 0, 0, 2, 8312);
INSERT INTO `eas_wo_dtl` VALUES (1683, 106, 'gJYAABuaPL7tSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 2203, 2203, 0, 1709, 129, 2, 623);
INSERT INTO `eas_wo_dtl` VALUES (1684, 106, 'gJYAABuaPMDtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 293, 293, 0, 0, 0, 2, 293);
INSERT INTO `eas_wo_dtl` VALUES (1685, 106, 'gJYAABuaPMrtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 20792, 20792, 0, 20792, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1686, 106, 'gJYAABuaPMXtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 77, 77, 0, 77, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1687, 106, 'gJYAABuaPMvtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1688, 106, 'gJYAABuaPMftSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 688, 688, 0, 688, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1689, 106, 'gJYAABuaPMjtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6877, 6877, 0, 6877, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1690, 106, 'gJYAABuaPMntSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 18515, 18515, 0, 18515, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1691, 106, 'gJYAABuaPL3tSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 250, 250, 0, 250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1692, 106, 'gJYAABuaPMHtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1693, 106, 'gJYAABuaPMTtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 250, 250, 0, 250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1694, 106, 'gJYAABuaPL/tSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 4600, 4600, 0, 4600, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1695, 106, 'gJYAABuaPMLtSYg5', 'VGllrGJxRDOqNoBstGJ1uB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 18515, 18515, 0, 18515, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1696, 107, 'gJYAABuai5LtSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 11100, 11100, 0, 11100, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1697, 107, 'gJYAABuai5TtSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 6619, 6619, 0, 0, 0, 2, 6619);
INSERT INTO `eas_wo_dtl` VALUES (1698, 107, 'gJYAABuai5/tSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1968, 1968, 0, 0, 0, 2, 1968);
INSERT INTO `eas_wo_dtl` VALUES (1699, 107, 'gJYAABuai5HtSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 286, 286, 0, 0, 0, 2, 286);
INSERT INTO `eas_wo_dtl` VALUES (1700, 107, 'gJYAABuai5ztSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 16724, 16724, 0, 16724, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1701, 107, 'gJYAABuai53tSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 62, 62, 0, 62, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1702, 107, 'gJYAABuai5ftSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 43, 43, 0, 43, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1703, 107, 'gJYAABuai5rtSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 638, 638, 0, 638, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1704, 107, 'gJYAABuai5vtSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6378, 6378, 0, 6378, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1705, 107, 'gJYAABuai5PtSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 14893, 14893, 0, 14893, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1706, 107, 'gJYAABuai57tSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1707, 107, 'gJYAABuai5ntSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1708, 107, 'gJYAABuai5XtSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1709, 107, 'gJYAABuai5jtSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3700, 3700, 0, 3700, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1710, 107, 'gJYAABuai5btSYg5', 'St+aBQU4TgePlKrljCI7YR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 14893, 14893, 0, 14893, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1711, 108, 'gJYAABuai83tSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 260, 260, 0, 0, 0, 2, 260);
INSERT INTO `eas_wo_dtl` VALUES (1712, 108, 'gJYAABuai8PtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 1260, 1260, 0, 1260, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1713, 108, 'gJYAABuai8XtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 10482, 10482, 0, 10482, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1714, 108, 'gJYAABuai9DtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 45207, 45207, 0, 45207, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1715, 108, 'gJYAABuai8vtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 200, 200, 0, 200, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1716, 108, 'gJYAABuai8btSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 117, 117, 0, 117, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1717, 108, 'gJYAABuai8/tSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1991, 1991, 0, 1991, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1718, 108, 'gJYAABuai8LtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 19913, 19913, 0, 19913, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1719, 108, 'gJYAABuai8jtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 170, 170, 0, 170, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1720, 108, 'gJYAABuai8ztSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 40256, 40256, 0, 40256, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1721, 108, 'gJYAABuai8rtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1722, 108, 'gJYAABuai9HtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 392, 392, 0, 392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1723, 108, 'gJYAABufGyvtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 10002, 10002, 0, 10002, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1724, 108, 'gJYAABuai87tSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 10002, 0, 0, 0, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1725, 108, 'gJYAABuai8TtSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1960, 1960, 0, 1960, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1726, 108, 'gJYAABuai8ftSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 40256, 40256, 0, 48256, 8000, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1727, 108, 'gJYAABuai8ntSYg5', 'vzDR3FHjRJifMMnMEu4lWB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 30005, 30005, 0, 30005, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1728, 109, 'gJYAABucfJztSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 50000, 50000, 0, 50000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1729, 109, 'gJYAABucfJbtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 22255, 22255, 0, 22255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1730, 109, 'gJYAABucfJXtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 3760, 3760, 0, 3760, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1731, 109, 'gJYAABucfJjtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABcwNiFECefw', '01.02.01.006.0082', '银线', 'JHB_K_18um', '米', 75050, 75050, 0, 75050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1732, 109, 'gJYAABucfJ3tSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1733, 109, 'gJYAABucfJntSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 6523, 6523, 0, 6523, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1734, 109, 'gJYAABucfJvtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 65230, 65230, 0, 65230, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1735, 109, 'gJYAABucfJPtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 385, 385, 0, 385, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1736, 109, 'gJYAABucfJTtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1737, 109, 'gJYAABucfKHtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1738, 109, 'gJYAABucfJ/tSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1739, 109, 'gJYAABucfJ7tSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1740, 109, 'gJYAABucfKDtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1741, 109, 'gJYAABucfJrtSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1742, 109, 'gJYAABucfJftSYg5', '2doh5PFoSS+PInoDWzoQFx0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1743, 110, 'gJYAABudFBrtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 59, 59, 0, 59, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1744, 110, 'gJYAABudFCDtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 1, 1, 0, 0, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (1745, 110, 'gJYAABudFBvtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 6, 6, 0, 6, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1746, 110, 'gJYAABudFBftSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 67, 67, 0, 67, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1747, 110, 'gJYAABudFCbtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1748, 110, 'gJYAABudFCHtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1749, 110, 'gJYAABudFB/tSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 8, 8, 0, 8, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1750, 110, 'gJYAABudFB7tSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 83, 83, 0, 83, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1751, 110, 'gJYAABudFCLtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1752, 110, 'gJYAABudFBntSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1753, 110, 'gJYAABudFBjtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1754, 110, 'gJYAABudFCTtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1755, 110, 'gJYAABudFB3tSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 34, 34, 0, 34, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1756, 110, 'gJYAABudFCXtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1757, 110, 'gJYAABudFCPtSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1758, 110, 'gJYAABudFBztSYg5', 'I68/kr8AR8iBSqN9Rn+HBR0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 34, 34, 0, 34, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1759, 111, 'gJYAABudFEntSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 74, 74, 0, 74, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1760, 111, 'gJYAABudFEXtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 2, 2, 0, 0, 0, 2, 2);
INSERT INTO `eas_wo_dtl` VALUES (1761, 111, 'gJYAABudFEztSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 4, 4, 0, 4, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1762, 111, 'gJYAABudFEjtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 67, 67, 0, 67, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1763, 111, 'gJYAABudFEHtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1764, 111, 'gJYAABudFEvtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1765, 111, 'gJYAABudFD/tSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 8, 8, 0, 8, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1766, 111, 'gJYAABudFEftSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 78, 78, 0, 78, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1767, 111, 'gJYAABudFE3tSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1768, 111, 'gJYAABudFEPtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1769, 111, 'gJYAABudFELtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1770, 111, 'gJYAABudFETtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1771, 111, 'gJYAABudFErtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 34, 34, 0, 34, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1772, 111, 'gJYAABudFEbtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1773, 111, 'gJYAABudFE7tSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1774, 111, 'gJYAABudFEDtSYg5', '0WMxog2SRi+FZdMQDsh3Oh0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 34, 34, 0, 34, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1775, 112, 'gJYAABudFGntSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 55, 55, 0, 55, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1776, 112, 'gJYAABudFGHtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 1, 1, 0, 0, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (1777, 112, 'gJYAABudFG3tSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 6, 6, 0, 6, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1778, 112, 'gJYAABudFGvtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 67, 67, 0, 67, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1779, 112, 'gJYAABudFGztSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1780, 112, 'gJYAABudFGDtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1781, 112, 'gJYAABudFG7tSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 9, 9, 0, 9, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1782, 112, 'gJYAABudFGLtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 92, 92, 0, 92, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1783, 112, 'gJYAABudFGrtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1784, 112, 'gJYAABudFGjtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1785, 112, 'gJYAABudFGbtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1786, 112, 'gJYAABudFF/tSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1787, 112, 'gJYAABudFGTtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 34, 34, 0, 34, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1788, 112, 'gJYAABudFGPtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1789, 112, 'gJYAABudFGftSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1790, 112, 'gJYAABudFGXtSYg5', 'gp+QVFEGTF6b1+yG9SD1GR0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 34, 34, 0, 34, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1791, 113, 'gJYAABudFILtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 50, 50, 0, 50, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1792, 113, 'gJYAABudFHftSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 1, 1, 0, 0, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (1793, 113, 'gJYAABudFIHtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 9, 9, 0, 9, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1794, 113, 'gJYAABudFHztSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 62, 62, 0, 62, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1795, 113, 'gJYAABudFHrtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1796, 113, 'gJYAABudFHjtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1797, 113, 'gJYAABudFH7tSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 7, 7, 0, 7, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1798, 113, 'gJYAABudFH3tSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 72, 72, 0, 72, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1799, 113, 'gJYAABudFIDtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1800, 113, 'gJYAABudFHvtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 127, 127, 0, 127, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1801, 113, 'gJYAABudFH/tSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1802, 113, 'gJYAABudFHTtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1803, 113, 'gJYAABudFHXtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 32, 32, 0, 32, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1804, 113, 'gJYAABudFHbtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1805, 113, 'gJYAABudFHntSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 127, 127, 0, 127, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1806, 113, 'gJYAABudFIPtSYg5', 'mNxLoeueTumECgGhqcwBlB0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 32, 32, 0, 32, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1807, 114, 'gJYAABudFI/tSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 35, 35, 0, 35, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1808, 114, 'gJYAABudFIftSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 2, 2, 0, 0, 0, 2, 2);
INSERT INTO `eas_wo_dtl` VALUES (1809, 114, 'gJYAABudFJXtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 2, 2, 0, 2, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1810, 114, 'gJYAABudFIvtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 64, 64, 0, 64, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1811, 114, 'gJYAABudFJLtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1812, 114, 'gJYAABudFIztSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1813, 114, 'gJYAABudFJDtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2, 2, 0, 2, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1814, 114, 'gJYAABudFI7tSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 74, 74, 0, 74, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1815, 114, 'gJYAABudFIrtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1816, 114, 'gJYAABudFIjtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 131, 131, 0, 131, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1817, 114, 'gJYAABudFJPtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1818, 114, 'gJYAABudFIbtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1819, 114, 'gJYAABudFI3tSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 33, 33, 0, 33, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1820, 114, 'gJYAABudFJTtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1821, 114, 'gJYAABudFIntSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 131, 131, 0, 131, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1822, 114, 'gJYAABudFJHtSYg5', 'I1UwXww3Q8e8Dx9JcmFsgB0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 33, 33, 0, 33, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1823, 115, 'gJYAABudFMftSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 143, 143, 0, 0, 0, 2, 143);
INSERT INTO `eas_wo_dtl` VALUES (1824, 115, 'gJYAABudFL/tSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 811, 811, 0, 811, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1825, 115, 'gJYAABudFM3tSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 5329, 5329, 0, 5329, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1826, 115, 'gJYAABudFMTtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10919, 10919, 0, 10919, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1827, 115, 'gJYAABudFMjtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1828, 115, 'gJYAABudFMntSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 45, 45, 0, 45, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1829, 115, 'gJYAABudFMPtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1130, 1130, 0, 1130, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1830, 115, 'gJYAABudFMvtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 11296, 11296, 0, 11296, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1831, 115, 'gJYAABudFMbtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 81, 81, 0, 81, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1832, 115, 'gJYAABudFMHtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 22422, 22422, 0, 22422, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1833, 115, 'gJYAABudFMztSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1834, 115, 'gJYAABudFMDtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 218, 218, 0, 218, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1835, 115, 'gJYAABudFMLtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5571, 5571, 0, 5571, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1836, 115, 'gJYAABudFMrtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1092, 1092, 0, 1092, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1837, 115, 'gJYAABudFMXtSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 22422, 22422, 0, 22422, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1838, 115, 'gJYAABudFM7tSYg5', 'IUsaCe+HSGitQiSXnLkB9B0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 5571, 5571, 0, 5571, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1839, 116, 'gJYAABudFNftSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 25, 25, 0, 25, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1840, 116, 'gJYAABudFNXtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1, 1, 0, 1, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1841, 116, 'gJYAABudFODtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 1, 1, 0, 1, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1842, 116, 'gJYAABudFNbtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 1, 1, 0, 1, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1843, 116, 'gJYAABudFNHtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 48, 48, 0, 48, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1844, 116, 'gJYAABudFNLtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1845, 116, 'gJYAABudFN7tSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1846, 116, 'gJYAABudFOHtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2, 2, 0, 2, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1847, 116, 'gJYAABudFNjtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 25, 25, 0, 25, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1848, 116, 'gJYAABudFNztSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1849, 116, 'gJYAABudFNPtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 46, 46, 0, 46, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1850, 116, 'gJYAABudFN/tSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1851, 116, 'gJYAABudFNntSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1852, 116, 'gJYAABudFNrtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 11, 11, 0, 11, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1853, 116, 'gJYAABudFNTtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1854, 116, 'gJYAABudFNvtSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 46, 46, 0, 46, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1855, 116, 'gJYAABudFN3tSYg5', 'OLEpgJDnRuiQ+jLTl+ZcZR0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 34, 34, 0, 404, 370, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1856, 117, 'gJYAABudFOTtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 9038, 9038, 0, 9038, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1857, 117, 'gJYAABudFOntSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 934, 934, 0, 934, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1858, 117, 'gJYAABudFOjtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 107, 107, 0, 107, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1859, 117, 'gJYAABudFPPtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 21865, 21865, 0, 21865, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1860, 117, 'gJYAABudFOftSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 105, 105, 0, 105, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1861, 117, 'gJYAABudFPDtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 105, 105, 0, 105, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1862, 117, 'gJYAABudFPHtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1434, 1434, 0, 1434, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1863, 117, 'gJYAABudFO/tSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 14343, 14343, 0, 14343, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1864, 117, 'gJYAABudFOXtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 138, 138, 0, 138, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1865, 117, 'gJYAABudFObtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 21105, 21105, 0, 21105, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1866, 117, 'gJYAABudFOvtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1867, 117, 'gJYAABudFO7tSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 206, 206, 0, 206, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1868, 117, 'gJYAABujrSDtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 5243, 4003, 0, 4003, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1869, 117, 'gJYAABudFPLtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5243, 1240, 0, 1240, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1870, 117, 'gJYAABudFOztSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1028, 1028, 0, 1028, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1871, 117, 'gJYAABudFO3tSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 21105, 21105, 0, 21105, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1872, 117, 'gJYAABudFOrtSYg5', 'zn9pWLeGS0+2NcaiR69J6h0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 15730, 15730, 0, 15730, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1873, 118, 'gJYAABudixrtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 2250, 2250, 0, 2250, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1874, 118, 'gJYAABudixTtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 902, 902, 0, 0, 0, 2, 902);
INSERT INTO `eas_wo_dtl` VALUES (1875, 118, 'gJYAABudixLtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 317, 317, 0, 317, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1876, 118, 'gJYAABudixDtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 30, 30, 0, 30, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1877, 118, 'gJYAABudixPtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 3390, 3390, 0, 3390, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1878, 118, 'gJYAABudiw3tSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1879, 118, 'gJYAABudiwvtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1880, 118, 'gJYAABudixftSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 151, 151, 0, 151, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1881, 118, 'gJYAABudixHtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1510, 1510, 0, 1510, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1882, 118, 'gJYAABudiwztSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 6, 6, 0, 6, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1883, 118, 'gJYAABudixntSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 3019, 3019, 0, 3019, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1884, 118, 'gJYAABudixXtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1885, 118, 'gJYAABudiw7tSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1886, 118, 'gJYAABudixbtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1887, 118, 'gJYAABudiw/tSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 750, 750, 0, 750, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1888, 118, 'gJYAABudixjtSYg5', 'dzFppSQuTo21u3CVWR2/Ax0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 3019, 3019, 0, 3019, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1889, 119, 'gJYAABueVS3tSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 406, 406, 0, 0, 0, 2, 406);
INSERT INTO `eas_wo_dtl` VALUES (1890, 119, 'gJYAABueVTjtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 1277, 1277, 0, 1277, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1891, 119, 'gJYAABueVSrtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 14498, 14498, 0, 10522, 0, 2, 3977);
INSERT INTO `eas_wo_dtl` VALUES (1892, 119, 'gJYAABueVTTtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 26720, 26720, 0, 26720, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1893, 119, 'gJYAABueVTbtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 68, 68, 0, 68, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1894, 119, 'gJYAABueVSvtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 109, 109, 0, 109, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1895, 119, 'gJYAABueVTPtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2897, 2897, 0, 2897, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1896, 119, 'gJYAABueVTDtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 28970, 28970, 0, 28970, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1897, 119, 'gJYAABueVS/tSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 198, 198, 0, 198, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1898, 119, 'gJYAABueVS7tSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 54872, 54872, 0, 54872, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1899, 119, 'gJYAABueVTHtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 53, 53, 0, 53, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1900, 119, 'gJYAABueVTLtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 534, 534, 0, 534, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1901, 119, 'gJYAABueVTftSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 13633, 13633, 0, 13633, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1902, 119, 'gJYAABueVTXtSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2672, 2672, 0, 4172, 1500, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1903, 119, 'gJYAABueVSntSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 54872, 54872, 0, 54872, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1904, 119, 'gJYAABueVSztSYg5', 'DyOrB3+fRFCGkbg6t8aIQR0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 13633, 13633, 0, 13633, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1905, 120, 'gJYAABueVTvtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 3524, 3524, 0, 3524, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1906, 120, 'gJYAABueVUDtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 364, 364, 0, 38, 0, 2, 326);
INSERT INTO `eas_wo_dtl` VALUES (1907, 120, 'gJYAABueVT/tSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 42, 42, 0, 42, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1908, 120, 'gJYAABueVUrtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8526, 8526, 0, 8526, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1909, 120, 'gJYAABueVT7tSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1910, 120, 'gJYAABueVUftSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1911, 120, 'gJYAABueVUjtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 559, 559, 0, 559, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1912, 120, 'gJYAABueVUbtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5593, 5593, 0, 5593, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1913, 120, 'gJYAABueVTztSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 54, 54, 0, 54, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1914, 120, 'gJYAABueVT3tSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8230, 8230, 0, 8230, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1915, 120, 'gJYAABueVULtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1916, 120, 'gJYAABueVUXtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 80, 80, 0, 80, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1917, 120, 'gJYAABueVUntSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2045, 2045, 0, 2045, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1918, 120, 'gJYAABueVUPtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 401, 401, 0, 401, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1919, 120, 'gJYAABueVUTtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8230, 8230, 0, 8230, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1920, 120, 'gJYAABueVUHtSYg5', 'Mbg8KaOYQv6i62ltVVyh7h0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 6134, 6134, 0, 6134, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1921, 121, 'gJYAABueVVvtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 49, 49, 0, 0, 0, 2, 49);
INSERT INTO `eas_wo_dtl` VALUES (1922, 121, 'gJYAABueVVLtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAA2PVBJECefw', '01.02.01.001.1048', '荧光粉', 'GAL525-M', '克', 4840, 4840, 0, 4840, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1923, 121, 'gJYAABueVV3tSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 411, 411, 0, 411, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1924, 121, 'gJYAABueVVTtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 13994, 13994, 0, 13994, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1925, 121, 'gJYAABueVVftSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 36, 36, 0, 36, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1926, 121, 'gJYAABueVVPtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 57, 57, 0, 57, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1927, 121, 'gJYAABueVVntSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1500, 1500, 0, 1500, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1928, 121, 'gJYAABueVWDtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 15001, 15001, 0, 15001, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1929, 121, 'gJYAABueVVXtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 121, 121, 0, 121, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1930, 121, 'gJYAABueVVrtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 28739, 28739, 0, 28739, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1931, 121, 'gJYAABueVWHtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1932, 121, 'gJYAABueVV7tSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 280, 280, 0, 280, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1933, 121, 'gJYAABueVV/tSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7140, 7140, 0, 7140, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1934, 121, 'gJYAABueVVztSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1399, 1399, 0, 1399, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1935, 121, 'gJYAABueVVjtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 28739, 28739, 0, 28739, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1936, 121, 'gJYAABueVVbtSYg5', 'YqigBPPVQjeiJYu8KLs9jx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 7140, 7140, 0, 7140, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1937, 122, 'gJYAABufw4TtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 11202, 11202, 0, 11202, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1938, 122, 'gJYAABufw4LtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 681, 681, 0, 0, 0, 2, 681);
INSERT INTO `eas_wo_dtl` VALUES (1939, 122, 'gJYAABufw43tSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 247, 247, 0, 247, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1940, 122, 'gJYAABufw4PtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 590, 590, 0, 262, 0, 2, 327);
INSERT INTO `eas_wo_dtl` VALUES (1941, 122, 'gJYAABufw4DtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 21699, 21699, 0, 21699, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1942, 122, 'gJYAABufw3/tSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 104, 104, 0, 104, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1943, 122, 'gJYAABufw4vtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 105, 105, 0, 105, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1944, 122, 'gJYAABufw47tSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1118, 1118, 0, 1118, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1945, 122, 'gJYAABufw4XtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 11183, 11183, 0, 11183, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1946, 122, 'gJYAABufw4ntSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 130, 130, 0, 130, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1947, 122, 'gJYAABufw37tSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 20945, 20945, 0, 20945, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1948, 122, 'gJYAABufw4ztSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1949, 122, 'gJYAABufw4btSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 204, 204, 0, 204, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1950, 122, 'gJYAABufw4ftSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5204, 5204, 0, 5204, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1951, 122, 'gJYAABufw4HtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1020, 1020, 0, 1020, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1952, 122, 'gJYAABufw4jtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 20945, 20945, 0, 20945, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1953, 122, 'gJYAABufw4rtSYg5', 'ljRIJ58SR6mHNBAQ6DBz+B0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 15611, 15611, 0, 15611, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1954, 123, 'gJYAABufw5HtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 80, 80, 0, 0, 0, 2, 80);
INSERT INTO `eas_wo_dtl` VALUES (1955, 123, 'gJYAABufw5LtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 129, 129, 0, 129, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1956, 123, 'gJYAABufw5PtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2216, 2216, 0, 0, 0, 2, 2216);
INSERT INTO `eas_wo_dtl` VALUES (1957, 123, 'gJYAABufw5vtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 14127, 14127, 0, 14127, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1958, 123, 'gJYAABufw5btSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 63, 63, 0, 63, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1959, 123, 'gJYAABufw5jtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 37, 37, 0, 37, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1960, 123, 'gJYAABufw5rtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 634, 634, 0, 634, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1961, 123, 'gJYAABufw6DtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6338, 6338, 0, 6338, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1962, 123, 'gJYAABufw5ftSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 45, 45, 0, 45, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1963, 123, 'gJYAABufw5TtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12580, 12580, 0, 12580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1964, 123, 'gJYAABufw5XtSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1965, 123, 'gJYAABufw5ztSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 123, 123, 0, 123, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1966, 123, 'gJYAABufw57tSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3125, 3125, 0, 3125, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1967, 123, 'gJYAABufw53tSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 613, 613, 0, 585, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (1968, 123, 'gJYAABufw5ntSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12580, 12580, 0, 12580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1969, 123, 'gJYAABufw5/tSYg5', 'w6it6p+0RPmccIQnQI2r6x0NgN0=', 'gJYAABctXHFECefw', '06.10.03.001.0089', 'DICE', 'S-DICE-BXCD1130', '千个', 9376, 9376, 0, 9376, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1970, 124, 'gJYAABufw6ztSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 2413, 2413, 0, 2413, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1971, 124, 'gJYAABufw6jtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 132, 132, 0, 0, 0, 2, 132);
INSERT INTO `eas_wo_dtl` VALUES (1972, 124, 'gJYAABufw67tSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 44, 44, 0, 44, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1973, 124, 'gJYAABufw6vtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 13659, 13659, 0, 13659, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1974, 124, 'gJYAABufw6ntSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 66, 66, 0, 66, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1975, 124, 'gJYAABufw6PtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 47, 47, 0, 47, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1976, 124, 'gJYAABufw63tSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 884, 884, 0, 884, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1977, 124, 'gJYAABufw7DtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 8842, 8842, 0, 8842, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1978, 124, 'gJYAABufw6TtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 60, 60, 0, 60, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1979, 124, 'gJYAABufw6btSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 13184, 13184, 0, 13184, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1980, 124, 'gJYAABufw6rtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1981, 124, 'gJYAABufw6ftSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 128, 128, 0, 128, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1982, 124, 'gJYAABufw7HtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3275, 3275, 0, 3275, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1983, 124, 'gJYAABufw7LtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 642, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1984, 124, 'gJYAABuv6/HtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 642, 642, 0, 642, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1985, 124, 'gJYAABufw6/tSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13184, 13184, 0, 13184, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1986, 124, 'gJYAABufw6XtSYg5', 'lO4RLrTTRkCoxn4GoOasxB0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 9826, 9826, 0, 9826, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1987, 125, 'gJYAABufw8XtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 1800, 1800, 0, 1800, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1988, 125, 'gJYAABufw8rtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 631, 631, 0, 0, 0, 2, 631);
INSERT INTO `eas_wo_dtl` VALUES (1989, 125, 'gJYAABufw9HtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 253, 253, 0, 253, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1990, 125, 'gJYAABufw8btSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 24, 24, 0, 24, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1991, 125, 'gJYAABufw8ntSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 2712, 2712, 0, 2712, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1992, 125, 'gJYAABufw9LtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1993, 125, 'gJYAABufw8ztSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1994, 125, 'gJYAABufw8jtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 121, 121, 0, 121, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1995, 125, 'gJYAABufw8vtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1208, 1208, 0, 1208, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1996, 125, 'gJYAABufw8TtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 5, 5, 0, 5, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1997, 125, 'gJYAABufw83tSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2415, 2415, 0, 2415, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1998, 125, 'gJYAABufw9PtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1999, 125, 'gJYAABufw87tSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2000, 125, 'gJYAABufw8/tSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2001, 125, 'gJYAABufw8ftSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 600, 600, 0, 600, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2002, 125, 'gJYAABufw9DtSYg5', 'ruwgL53dTkGRC2B9JApMdR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2415, 2415, 0, 2415, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2003, 126, 'gJYAABufw+DtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 24900, 24900, 0, 24900, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2004, 126, 'gJYAABufw+LtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 9987, 9987, 0, 0, 0, 2, 9987);
INSERT INTO `eas_wo_dtl` VALUES (2005, 126, 'gJYAABufw9rtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 3504, 3504, 0, 3504, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2006, 126, 'gJYAABufw9vtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 328, 328, 0, 0, 0, 2, 328);
INSERT INTO `eas_wo_dtl` VALUES (2007, 126, 'gJYAABufw9/tSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 37516, 37516, 0, 37516, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2008, 126, 'gJYAABufw93tSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 139, 139, 0, 139, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2009, 126, 'gJYAABufw+PtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 97, 97, 0, 97, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2010, 126, 'gJYAABufw9ftSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1671, 1671, 0, 1671, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2011, 126, 'gJYAABufw97tSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 16710, 16710, 0, 16710, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2012, 126, 'gJYAABufw9btSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 68, 68, 0, 68, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2013, 126, 'gJYAABufw+TtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 33408, 33408, 0, 33408, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2014, 126, 'gJYAABufw9ntSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 452, 452, 0, 452, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2015, 126, 'gJYAABufw+XtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2016, 126, 'gJYAABufw9jtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 452, 452, 0, 452, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2017, 126, 'gJYAABufw9ztSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 8300, 8300, 0, 8300, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2018, 126, 'gJYAABufw+HtSYg5', 'JGVnvJpXRpS5Z3fgzp9uGx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 33408, 33408, 0, 33408, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2019, 127, 'gJYAABuhHwHtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 237, 237, 0, 0, 0, 2, 237);
INSERT INTO `eas_wo_dtl` VALUES (2020, 127, 'gJYAABuhHwztSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 745, 745, 0, 745, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2021, 127, 'gJYAABuhHv7tSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAABtJ0SVECefw', '01.02.01.001.1361', '荧光粉', 'G518M', '克', 8465, 8465, 0, 8465, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2022, 127, 'gJYAABuhHwjtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 15601, 15601, 0, 15601, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2023, 127, 'gJYAABuhHwrtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2024, 127, 'gJYAABuhHv/tSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 64, 64, 0, 64, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2025, 127, 'gJYAABuhHwftSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1691, 1691, 0, 1691, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2026, 127, 'gJYAABuhHwTtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 16914, 16914, 0, 16914, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2027, 127, 'gJYAABuhHwPtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 115, 115, 0, 115, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2028, 127, 'gJYAABuhHwLtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 32038, 32038, 0, 62038, 30000, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2029, 127, 'gJYAABuhHwXtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2030, 127, 'gJYAABuhHwbtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 312, 312, 0, 312, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2031, 127, 'gJYAABuhHwvtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7960, 7960, 0, 7960, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2032, 127, 'gJYAABuhHwntSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 1560, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2033, 127, 'gJYAABuv6/ntSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1560, 1560, 0, 1560, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2034, 127, 'gJYAABuhHv3tSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 32038, 32038, 0, 32038, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2035, 127, 'gJYAABuhHwDtSYg5', '5FZFc8LFRaeko9PZqxijeh0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 7960, 7960, 0, 7960, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2036, 128, 'gJYAABuhHxXtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 9133, 9133, 0, 9133, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2037, 128, 'gJYAABuhHxbtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 197, 197, 0, 0, 0, 2, 197);
INSERT INTO `eas_wo_dtl` VALUES (2038, 128, 'gJYAABuhHxPtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 916, 916, 0, 601, 0, 2, 315);
INSERT INTO `eas_wo_dtl` VALUES (2039, 128, 'gJYAABuhHxTtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 15891, 15891, 0, 15891, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2040, 128, 'gJYAABuhHxftSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2041, 128, 'gJYAABuhHxDtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 65, 65, 0, 65, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2042, 128, 'gJYAABuhHx3tSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2841, 2841, 0, 2841, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2043, 128, 'gJYAABuhHxLtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 28414, 28414, 0, 28414, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2044, 128, 'gJYAABuhHxHtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 186, 186, 0, 186, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2045, 128, 'gJYAABuhHw/tSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 32634, 32634, 0, 47851, 15217, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2046, 128, 'gJYAABuhHxztSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2047, 128, 'gJYAABuhHx7tSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 318, 318, 0, 318, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2048, 128, 'gJYAABuhHxntSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 8108, 8108, 0, 8108, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2049, 128, 'gJYAABuhHxjtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1589, 1589, 0, 1589, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2050, 128, 'gJYAABuhHxvtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 32634, 32634, 0, 32634, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2051, 128, 'gJYAABuhHxrtSYg5', 'bgtTQSW+SVG4B5octi0d0h0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 8108, 8108, 0, 8108, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2052, 129, 'gJYAABuhHzTtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 78, 78, 0, 0, 0, 2, 78);
INSERT INTO `eas_wo_dtl` VALUES (2053, 129, 'gJYAABuhHy/tSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 369, 369, 0, 0, 0, 2, 369);
INSERT INTO `eas_wo_dtl` VALUES (2054, 129, 'gJYAABuhHzPtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2402, 2402, 0, 0, 0, 2, 2402);
INSERT INTO `eas_wo_dtl` VALUES (2055, 129, 'gJYAABuhHzHtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 13743, 13743, 0, 13743, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2056, 129, 'gJYAABuhHy7tSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 61, 61, 0, 61, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2057, 129, 'gJYAABuhHzjtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 36, 36, 0, 36, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2058, 129, 'gJYAABuhHzLtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 617, 617, 0, 617, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2059, 129, 'gJYAABuhHyztSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6165, 6165, 0, 6165, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2060, 129, 'gJYAABuhHzftSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 44, 44, 0, 44, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2061, 129, 'gJYAABuhHy3tSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12238, 12238, 0, 12238, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2062, 129, 'gJYAABuhHyvtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2063, 129, 'gJYAABuhHzXtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 119, 119, 0, 119, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2064, 129, 'gJYAABuhHzbtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3040, 3040, 0, 3040, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2065, 129, 'gJYAABuhHzDtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 596, 596, 0, 596, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2066, 129, 'gJYAABuhHzrtSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12238, 12238, 0, 12238, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2067, 129, 'gJYAABuhHzntSYg5', 'Svo8AMXJR4GQmpF/K2Uf6B0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 9121, 9121, 0, 9121, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2068, 130, 'gJYAABuhH03tSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 5713, 5713, 0, 5713, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2069, 130, 'gJYAABuhH07tSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 143, 143, 0, 0, 0, 2, 143);
INSERT INTO `eas_wo_dtl` VALUES (2070, 130, 'gJYAABuhH1HtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 588, 588, 0, 0, 0, 2, 588);
INSERT INTO `eas_wo_dtl` VALUES (2071, 130, 'gJYAABuhH1DtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10035, 10035, 0, 10035, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2072, 130, 'gJYAABuhH0vtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 26, 26, 0, 26, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2073, 130, 'gJYAABuhH0XtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2074, 130, 'gJYAABuhH0rtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 962, 962, 0, 962, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2075, 130, 'gJYAABuhH0ztSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 9620, 9620, 0, 9620, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2076, 130, 'gJYAABuhH1LtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 67, 67, 0, 67, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2077, 130, 'gJYAABuhH0ntSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 20608, 20608, 0, 40608, 20000, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2078, 130, 'gJYAABuhH0jtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2079, 130, 'gJYAABuhH0/tSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 201, 201, 0, 57, 0, NULL, 144);
INSERT INTO `eas_wo_dtl` VALUES (2080, 130, 'gJYAABuhH0btSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5120, 5120, 0, 5120, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2081, 130, 'gJYAABuhH0ftSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1003, 1003, 0, 1003, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2082, 130, 'gJYAABuhH0PtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 20608, 20608, 0, 20608, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2083, 130, 'gJYAABuhH0TtSYg5', 'BLfKo8fdSxeghgDUx1hgnx0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 5120, 5120, 0, 5120, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2084, 131, 'gJYAABui2P3tSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 55, 55, 0, 0, 0, 2, 55);
INSERT INTO `eas_wo_dtl` VALUES (2085, 131, 'gJYAABui2PvtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 62, 62, 0, 0, 0, 2, 62);
INSERT INTO `eas_wo_dtl` VALUES (2086, 131, 'gJYAABui2PftSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1638, 1638, 0, 0, 0, 2, 1638);
INSERT INTO `eas_wo_dtl` VALUES (2087, 131, 'gJYAABui2PztSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6368, 6368, 0, 6368, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2088, 131, 'gJYAABui2P7tSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2089, 131, 'gJYAABui2P/tSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2090, 131, 'gJYAABui2PLtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 439, 439, 0, 439, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2091, 131, 'gJYAABui2PrtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4394, 4394, 0, 4394, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2092, 131, 'gJYAABui2PPtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 31, 31, 0, 31, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2093, 131, 'gJYAABui2PHtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8717, 8717, 0, 8717, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2094, 131, 'gJYAABui2PXtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2095, 131, 'gJYAABui2PDtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 85, 85, 0, 85, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2096, 131, 'gJYAABui2PjtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2166, 2166, 0, 2166, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2097, 131, 'gJYAABui2PbtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 425, 425, 0, 425, 199, NULL, 199);
INSERT INTO `eas_wo_dtl` VALUES (2098, 131, 'gJYAABui2PTtSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8717, 8717, 0, 8717, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2099, 131, 'gJYAABui2PntSYg5', 'c8mreorJR2exUiiGrT36Ih0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 4332, 4332, 0, 4332, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2100, 132, 'gJYAABui2QvtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 11522, 11522, 0, 1415, 569, 2, 10676);
INSERT INTO `eas_wo_dtl` VALUES (2101, 132, 'gJYAABui2QntSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 700, 700, 0, 0, 0, 2, 700);
INSERT INTO `eas_wo_dtl` VALUES (2102, 132, 'gJYAABui2RTtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 254, 254, 0, 254, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2103, 132, 'gJYAABui2QrtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 606, 606, 0, 0, 0, 2, 606);
INSERT INTO `eas_wo_dtl` VALUES (2104, 132, 'gJYAABui2QXtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 22319, 22319, 0, 22319, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2105, 132, 'gJYAABui2QbtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 107, 107, 0, 107, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2106, 132, 'gJYAABui2RLtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 108, 108, 0, 108, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2107, 132, 'gJYAABui2RXtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1150, 1150, 0, 1150, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2108, 132, 'gJYAABui2QztSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 11503, 11503, 0, 11503, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2109, 132, 'gJYAABui2RDtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 134, 134, 0, 134, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2110, 132, 'gJYAABui2QftSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 21543, 21543, 0, 21543, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2111, 132, 'gJYAABui2RPtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2112, 132, 'gJYAABui2Q3tSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 210, 210, 0, 200, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (2113, 132, 'gJYAABui2Q7tSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5352, 5352, 0, 5352, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2114, 132, 'gJYAABui2QjtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1049, 1049, 0, 1049, 1049, NULL, 1049);
INSERT INTO `eas_wo_dtl` VALUES (2115, 132, 'gJYAABui2Q/tSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 21543, 21543, 0, 21543, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2116, 132, 'gJYAABui2RHtSYg5', 'kC2lwhmhRJqlDDtWIez8Vh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 16057, 16057, 0, 16057, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2117, 133, 'gJYAABui2SftSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 49, 49, 0, 0, 0, 2, 49);
INSERT INTO `eas_wo_dtl` VALUES (2118, 133, 'gJYAABui2SXtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 54, 54, 0, 0, 0, 2, 54);
INSERT INTO `eas_wo_dtl` VALUES (2119, 133, 'gJYAABui2SHtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1446, 1446, 0, 0, 0, 2, 1446);
INSERT INTO `eas_wo_dtl` VALUES (2120, 133, 'gJYAABui2SbtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5621, 5621, 0, 5621, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2121, 133, 'gJYAABui2SjtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2122, 133, 'gJYAABui2SntSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2123, 133, 'gJYAABui2RztSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 388, 388, 0, 388, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2124, 133, 'gJYAABui2STtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3878, 3878, 0, 3878, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2125, 133, 'gJYAABui2R3tSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 28, 28, 0, 28, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2126, 133, 'gJYAABui2RvtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7695, 7695, 0, 7695, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2127, 133, 'gJYAABui2R/tSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2128, 133, 'gJYAABui2RrtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 75, 75, 0, 0, 0, NULL, 75);
INSERT INTO `eas_wo_dtl` VALUES (2129, 133, 'gJYAABui2SLtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1912, 1912, 0, 1912, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2130, 133, 'gJYAABui2SDtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 375, 375, 0, 375, 374, NULL, 374);
INSERT INTO `eas_wo_dtl` VALUES (2131, 133, 'gJYAABui2R7tSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7695, 7695, 0, 7695, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2132, 133, 'gJYAABui2SPtSYg5', 'Tjbv85DmTyym+fvR9/u+9x0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 3824, 3824, 0, 3824, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2133, 134, 'gJYAABui2TbtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 224, 224, 0, 0, 0, 2, 224);
INSERT INTO `eas_wo_dtl` VALUES (2134, 134, 'gJYAABui2S/tSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 26, 26, 0, 26, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2135, 134, 'gJYAABui2S7tSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABtJ0SVECefw', '01.02.01.001.1361', '荧光粉', 'G518M', '克', 1225, 1225, 0, 1225, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2136, 134, 'gJYAABui2TjtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 3920, 3920, 0, 3920, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2137, 134, 'gJYAABui2TXtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2138, 134, 'gJYAABui2TPtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2139, 134, 'gJYAABui2TntSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 253, 253, 0, 253, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2140, 134, 'gJYAABui2TLtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2532, 2532, 0, 2532, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2141, 134, 'gJYAABui2THtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 30, 30, 0, 30, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2142, 134, 'gJYAABui2S3tSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 3483, 3483, 0, 3483, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2143, 134, 'gJYAABui2TftSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2144, 134, 'gJYAABui2SztSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 34, 34, 0, 0, 0, NULL, 34);
INSERT INTO `eas_wo_dtl` VALUES (2145, 134, 'gJYAABui2TrtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 865, 865, 0, 865, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2146, 134, 'gJYAABui2TvtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 170, 170, 0, 170, 169, NULL, 169);
INSERT INTO `eas_wo_dtl` VALUES (2147, 134, 'gJYAABui2TDtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 3483, 3483, 0, 3483, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2148, 134, 'gJYAABui2TTtSYg5', 'lY2Az6YdS5Ga9sukIK+QcB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 2596, 2596, 0, 2596, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2149, 135, 'gJYAABui2gntSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 5806, 5806, 0, 5806, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2150, 135, 'gJYAABui2hTtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 186, 186, 0, 0, 0, 2, 186);
INSERT INTO `eas_wo_dtl` VALUES (2151, 135, 'gJYAABui2hbtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 1290, 1290, 0, 1172, 0, 2, 118);
INSERT INTO `eas_wo_dtl` VALUES (2152, 135, 'gJYAABui2g7tSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 13772, 13772, 0, 13772, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2153, 135, 'gJYAABui2grtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 35, 35, 0, 35, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2154, 135, 'gJYAABui2hXtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 56, 56, 0, 56, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2155, 135, 'gJYAABui2hPtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1239, 1239, 0, 1239, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2156, 135, 'gJYAABui2hHtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 12387, 12387, 0, 12387, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2157, 135, 'gJYAABui2g/tSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 79, 79, 0, 79, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2158, 135, 'gJYAABui2gztSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 28282, 28282, 0, 28282, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2159, 135, 'gJYAABui2hLtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2160, 135, 'gJYAABui2hftSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 275, 275, 0, 200, 0, NULL, 75);
INSERT INTO `eas_wo_dtl` VALUES (2161, 135, 'gJYAABui2hDtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7027, 7027, 0, 7027, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2162, 135, 'gJYAABui2gvtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1377, 1377, 0, 1209, 1209, NULL, 1377);
INSERT INTO `eas_wo_dtl` VALUES (2163, 135, 'gJYAABui2g3tSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 28282, 28282, 0, 28282, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2164, 135, 'gJYAABui2hjtSYg5', 'tb/96tRLSI2y6KFuYwRqxB0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 7027, 7027, 0, 7027, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2165, 136, 'gJYAABukX93tSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 202, 202, 0, 0, 0, 2, 202);
INSERT INTO `eas_wo_dtl` VALUES (2166, 136, 'gJYAABukX9vtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 23, 23, 0, 0, 0, 2, 23);
INSERT INTO `eas_wo_dtl` VALUES (2167, 136, 'gJYAABukX87tSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABhfXltECefw', '01.02.01.001.1272', '荧光粉', 'KSL220', '克', 37, 37, 0, 0, 0, 2, 37);
INSERT INTO `eas_wo_dtl` VALUES (2168, 136, 'gJYAABukX9rtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 344, 344, 0, 344, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2169, 136, 'gJYAABukX9HtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2170, 136, 'gJYAABukX9DtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2171, 136, 'gJYAABukX9ntSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 18, 18, 0, 18, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2172, 136, 'gJYAABukX9XtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 181, 181, 0, 181, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2173, 136, 'gJYAABukX9PtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2174, 136, 'gJYAABukX8/tSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 707, 707, 0, 707, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2175, 136, 'gJYAABukX9ftSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2176, 136, 'gJYAABukX9LtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (2177, 136, 'gJYAABukX9btSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 176, 176, 0, 176, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2178, 136, 'gJYAABukX9TtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 34, 34, 0, 0, 0, NULL, 34);
INSERT INTO `eas_wo_dtl` VALUES (2179, 136, 'gJYAABukX9ztSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 707, 707, 0, 707, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2180, 136, 'gJYAABukX9jtSYg5', 'qDwBwMgXQBqQcZ+GcYCqtB0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 176, 176, 0, 176, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2181, 137, 'gJYAABukX+ntSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 284, 284, 0, 0, 0, 2, 284);
INSERT INTO `eas_wo_dtl` VALUES (2182, 137, 'gJYAABukX+jtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 32, 32, 0, 0, 0, 2, 32);
INSERT INTO `eas_wo_dtl` VALUES (2183, 137, 'gJYAABukX+TtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABhfXltECefw', '01.02.01.001.1272', '荧光粉', 'KSL220', '克', 52, 52, 0, 0, 0, 2, 52);
INSERT INTO `eas_wo_dtl` VALUES (2184, 137, 'gJYAABukX+/tSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 483, 483, 0, 483, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2185, 137, 'gJYAABukX+LtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2186, 137, 'gJYAABukX+XtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2187, 137, 'gJYAABukX+7tSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 25, 25, 0, 25, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2188, 137, 'gJYAABukX/HtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 253, 253, 0, 253, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2189, 137, 'gJYAABukX+3tSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2190, 137, 'gJYAABukX+vtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 991, 991, 0, 991, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2191, 137, 'gJYAABukX+rtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2192, 137, 'gJYAABukX+ztSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2193, 137, 'gJYAABukX+btSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 246, 246, 0, 246, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2194, 137, 'gJYAABukX+ftSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 48, 48, 0, 0, 0, NULL, 48);
INSERT INTO `eas_wo_dtl` VALUES (2195, 137, 'gJYAABukX+PtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 991, 991, 0, 991, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2196, 137, 'gJYAABukX/DtSYg5', '5X85mW2sRHWmZnj69ete0x0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 246, 246, 0, 246, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2197, 138, 'gJYAABukYADtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2687, 2687, 0, 0, 0, 2, 2687);
INSERT INTO `eas_wo_dtl` VALUES (2198, 138, 'gJYAABukYAXtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 443, 443, 0, 0, 0, 2, 443);
INSERT INTO `eas_wo_dtl` VALUES (2199, 138, 'gJYAABukX/7tSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6590, 6590, 0, 6590, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2200, 138, 'gJYAABukX//tSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2201, 138, 'gJYAABukYAftSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2202, 138, 'gJYAABukX/ztSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 324, 324, 0, 324, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2203, 138, 'gJYAABukYATtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3239, 3239, 0, 3239, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2204, 138, 'gJYAABukX/ntSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 19, 19, 0, 19, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2205, 138, 'gJYAABukYAPtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6361, 6361, 0, 6384, 23, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2206, 138, 'gJYAABukX/vtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2207, 138, 'gJYAABukX/3tSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 62, 62, 0, 62, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2208, 138, 'gJYAABukYAbtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1580, 1580, 0, 1586, 6, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2209, 138, 'gJYAABukYAHtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 310, 310, 0, 0, 0, NULL, 310);
INSERT INTO `eas_wo_dtl` VALUES (2210, 138, 'gJYAABukYALtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6361, 6361, 0, 6361, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2211, 138, 'gJYAABukX/rtSYg5', 't9uPDlgSSF6KLSFmfIroZB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 4741, 4741, 0, 4741, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2212, 139, 'gJYAABukYA3tSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 8, 8, 0, 0, 0, 2, 8);
INSERT INTO `eas_wo_dtl` VALUES (2213, 139, 'gJYAABukYBDtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 227, 227, 0, 0, 0, 2, 227);
INSERT INTO `eas_wo_dtl` VALUES (2214, 139, 'gJYAABukYAvtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 82, 82, 0, 0, 0, 2, 82);
INSERT INTO `eas_wo_dtl` VALUES (2215, 139, 'gJYAABukYBHtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 404, 404, 0, 404, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2216, 139, 'gJYAABukYBbtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2217, 139, 'gJYAABukYBPtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2218, 139, 'gJYAABukYAztSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 21, 21, 0, 21, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2219, 139, 'gJYAABukYBrtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 212, 212, 0, 212, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2220, 139, 'gJYAABukYBftSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2221, 139, 'gJYAABukYBjtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 830, 830, 0, 830, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2222, 139, 'gJYAABukYBXtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2223, 139, 'gJYAABukYBntSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2224, 139, 'gJYAABukYA7tSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 206, 206, 0, 206, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2225, 139, 'gJYAABukYBLtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 40, 40, 0, 0, 0, NULL, 40);
INSERT INTO `eas_wo_dtl` VALUES (2226, 139, 'gJYAABukYBTtSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 830, 830, 0, 830, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2227, 139, 'gJYAABukYA/tSYg5', '/AHgW5APTwO9tS77TjAjNR0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 206, 206, 0, 206, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2228, 140, 'gJYAABukYCDtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 7, 7, 0, 0, 0, 2, 7);
INSERT INTO `eas_wo_dtl` VALUES (2229, 140, 'gJYAABukYCPtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 212, 212, 0, 0, 0, 2, 212);
INSERT INTO `eas_wo_dtl` VALUES (2230, 140, 'gJYAABukYB7tSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 77, 77, 0, 0, 0, 2, 77);
INSERT INTO `eas_wo_dtl` VALUES (2231, 140, 'gJYAABukYCTtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 377, 377, 0, 377, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2232, 140, 'gJYAABukYCntSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2233, 140, 'gJYAABukYCbtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2234, 140, 'gJYAABukYB/tSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 20, 20, 0, 20, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2235, 140, 'gJYAABukYC3tSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 198, 198, 0, 198, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2236, 140, 'gJYAABukYCrtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2237, 140, 'gJYAABukYCvtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 774, 774, 0, 774, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2238, 140, 'gJYAABukYCjtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2239, 140, 'gJYAABukYCztSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2240, 140, 'gJYAABukYCHtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 192, 192, 0, 192, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2241, 140, 'gJYAABukYCXtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 38, 38, 0, 0, 0, NULL, 38);
INSERT INTO `eas_wo_dtl` VALUES (2242, 140, 'gJYAABukYCftSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 774, 774, 0, 774, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2243, 140, 'gJYAABukYCLtSYg5', 'AyxmPOILSKKW+7G6GXRIah0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 192, 192, 0, 192, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2244, 141, 'gJYAABukYDntSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 11633, 11633, 0, 9800, 0, 2, 1833);
INSERT INTO `eas_wo_dtl` VALUES (2245, 141, 'gJYAABukYDftSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 707, 707, 0, 0, 0, 2, 707);
INSERT INTO `eas_wo_dtl` VALUES (2246, 141, 'gJYAABukYELtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 256, 256, 0, 256, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2247, 141, 'gJYAABukYDjtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 612, 612, 0, 0, 0, 2, 612);
INSERT INTO `eas_wo_dtl` VALUES (2248, 141, 'gJYAABukYDPtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 22534, 22534, 0, 22534, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2249, 141, 'gJYAABukYDTtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 108, 108, 0, 108, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2250, 141, 'gJYAABukYEDtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 109, 109, 0, 109, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2251, 141, 'gJYAABukYEPtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1161, 1161, 0, 1161, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2252, 141, 'gJYAABukYDrtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 11613, 11613, 0, 11613, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2253, 141, 'gJYAABukYD7tSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 135, 135, 0, 135, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2254, 141, 'gJYAABukYDXtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 21750, 21750, 0, 21750, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2255, 141, 'gJYAABukYEHtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2256, 141, 'gJYAABukYDvtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 212, 212, 0, 212, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2257, 141, 'gJYAABukYDztSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5404, 5404, 0, 5404, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2258, 141, 'gJYAABukYDbtSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1059, 1059, 0, 0, 0, NULL, 1059);
INSERT INTO `eas_wo_dtl` VALUES (2259, 141, 'gJYAABukYD3tSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 21750, 21750, 0, 21750, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2260, 141, 'gJYAABukYD/tSYg5', 'rj8Fn4OXQVygTsalNoBCbB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 16211, 16211, 0, 16211, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2261, 142, 'gJYAABuku+ztSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 245, 245, 0, 245, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2262, 142, 'gJYAABuku+btSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 6462, 6462, 0, 0, 0, 2, 6462);
INSERT INTO `eas_wo_dtl` VALUES (2263, 142, 'gJYAABuku97tSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 218, 218, 0, 156, 0, 2, 62);
INSERT INTO `eas_wo_dtl` VALUES (2264, 142, 'gJYAABuku+ftSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 16840, 16840, 0, 16840, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2265, 142, 'gJYAABuku+XtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 43, 43, 0, 43, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2266, 142, 'gJYAABuku+ntSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 68, 68, 0, 68, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2267, 142, 'gJYAABuku+HtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1786, 1786, 0, 1786, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2268, 142, 'gJYAABuku9/tSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 17857, 17857, 0, 17857, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2269, 142, 'gJYAABuku+rtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 132, 132, 0, 132, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2270, 142, 'gJYAABuku+3tSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 34233, 34233, 0, 32030, 0, NULL, 2203);
INSERT INTO `eas_wo_dtl` VALUES (2271, 142, 'gJYAABuku+jtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAubixpECefw', '01.02.13.030.0058', '卷盘', '13*8', '个', 463, 463, 0, 16, 0, NULL, 447);
INSERT INTO `eas_wo_dtl` VALUES (2272, 142, 'gJYAABuku+DtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 42, 42, 0, 42, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2273, 142, 'gJYAABuku+TtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 463, 463, 0, 463, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2274, 142, 'gJYAABuk6jPtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 8505, 829, 0, 829, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2275, 142, 'gJYAABuku+PtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 8505, 7676, 0, 7676, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2276, 142, 'gJYAABuku+vtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 34233, 34233, 0, 34233, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2277, 142, 'gJYAABuku+LtSYg5', 'h45mSqe0RWustB83Iv0Zix0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 8505, 8505, 0, 8505, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2278, 143, 'gJYAABulfMntSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 50000, 50000, 0, 50000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2279, 143, 'gJYAABulfMTtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 22255, 22255, 0, 22255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2280, 143, 'gJYAABulfMLtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 3760, 3760, 0, 3760, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2281, 143, 'gJYAABulfMXtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABcwNiFECefw', '01.02.01.006.0082', '银线', 'JHB_K_18um', '米', 75050, 75050, 0, 75050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2282, 143, 'gJYAABulfMrtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2283, 143, 'gJYAABulfMbtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 6523, 6523, 0, 6523, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2284, 143, 'gJYAABulfMjtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 65230, 65230, 0, 65230, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2285, 143, 'gJYAABulfMDtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 385, 385, 0, 385, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2286, 143, 'gJYAABulfMHtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2287, 143, 'gJYAABulfM7tSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2288, 143, 'gJYAABulfMztSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2289, 143, 'gJYAABulfMvtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2290, 143, 'gJYAABulfM3tSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2291, 143, 'gJYAABulfMftSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2292, 143, 'gJYAABulfMPtSYg5', 'CRrAUmK8Q4yb53SzFQ1pth0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 599, 19, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2293, 144, 'gJYAABumSavtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 57, 57, 0, 57, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2294, 144, 'gJYAABumSaLtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 20, 20, 0, 20, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2295, 144, 'gJYAABumSa/tSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 428, 428, 0, 0, 0, 2, 428);
INSERT INTO `eas_wo_dtl` VALUES (2296, 144, 'gJYAABumSa7tSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1520, 1520, 0, 1520, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2297, 144, 'gJYAABumSartSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2298, 144, 'gJYAABumSaTtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2299, 144, 'gJYAABumSaztSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 91, 91, 0, 91, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2300, 144, 'gJYAABumSaPtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 907, 907, 0, 907, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2301, 144, 'gJYAABumSantSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 6, 6, 0, 6, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2302, 144, 'gJYAABumSaftSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1800, 1800, 0, 1800, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2303, 144, 'gJYAABumSabtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2304, 144, 'gJYAABumSaXtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 18, 18, 0, 0, 0, NULL, 18);
INSERT INTO `eas_wo_dtl` VALUES (2305, 144, 'gJYAABumSajtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 447, 447, 0, 447, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2306, 144, 'gJYAABumSbDtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 88, 88, 0, 0, 0, NULL, 88);
INSERT INTO `eas_wo_dtl` VALUES (2307, 144, 'gJYAABumSaHtSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1800, 1800, 0, 1800, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2308, 144, 'gJYAABumSa3tSYg5', 'JWjANUEVQ0WURLh7SFYF6x0NgN0=', 'gJYAABc3p0xECefw', '06.10.03.001.0091', 'DICE', 'S-DICE-BXHV1931', '千个', 894, 894, 0, 894, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2309, 145, 'gJYAABunSw/tSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 101, 101, 0, 45, 0, 2, 56);
INSERT INTO `eas_wo_dtl` VALUES (2310, 145, 'gJYAABunSxftSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 793, 793, 0, 0, 0, 2, 793);
INSERT INTO `eas_wo_dtl` VALUES (2311, 145, 'gJYAABunSxHtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 394, 394, 0, 394, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2312, 145, 'gJYAABunSxTtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2313, 145, 'gJYAABunSxntSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2314, 145, 'gJYAABunSxjtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 41, 41, 0, 41, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2315, 145, 'gJYAABunSxLtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 408, 408, 0, 408, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2316, 145, 'gJYAABunSxDtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 3, 3, 0, 3, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2317, 145, 'gJYAABunSw7tSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 810, 810, 0, 810, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2318, 145, 'gJYAABunSw3tSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2319, 145, 'gJYAABunSxbtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2320, 145, 'gJYAABunSwrtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 4, 4, 0, 2, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (2321, 145, 'gJYAABunSwvtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2322, 145, 'gJYAABunSxrtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 201, 201, 0, 201, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2323, 145, 'gJYAABunSxPtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (2324, 145, 'gJYAABunSwztSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (2325, 145, 'gJYAABunSxXtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 810, 810, 0, 810, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2326, 145, 'gJYAABunSxvtSYg5', 'soDWou1aSCew0Bei/bbTrh0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 201, 201, 0, 201, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2327, 146, 'gJYAABunSyTtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 204, 204, 0, 0, 0, 2, 204);
INSERT INTO `eas_wo_dtl` VALUES (2328, 146, 'gJYAABunSyHtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 29, 29, 0, 0, 0, 2, 29);
INSERT INTO `eas_wo_dtl` VALUES (2329, 146, 'gJYAABunSyrtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 472, 472, 0, 472, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2330, 146, 'gJYAABunSybtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2331, 146, 'gJYAABunSy3tSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 1, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2332, 146, 'gJYAABunSyztSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 23, 23, 0, 23, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2333, 146, 'gJYAABunSyntSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 232, 232, 0, 232, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2334, 146, 'gJYAABunSyLtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2335, 146, 'gJYAABunSyPtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 455, 455, 0, 455, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2336, 146, 'gJYAABunSy7tSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2337, 146, 'gJYAABunSy/tSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (2338, 146, 'gJYAABunSyvtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 113, 113, 0, 113, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2339, 146, 'gJYAABunSyftSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 22, 22, 0, 0, 0, NULL, 22);
INSERT INTO `eas_wo_dtl` VALUES (2340, 146, 'gJYAABunSyjtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 455, 455, 0, 455, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2341, 146, 'gJYAABunSyXtSYg5', 'ugEDgLbLQpmy6662RDFCKx0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 339, 339, 0, 339, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2342, 147, 'gJYAABuodq3tSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 50000, 50000, 0, 50000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2343, 147, 'gJYAABuodqftSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 22255, 22255, 0, 22255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2344, 147, 'gJYAABuodqbtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 3760, 3760, 0, 3760, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2345, 147, 'gJYAABuodqntSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 75050, 75050, 0, 75050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2346, 147, 'gJYAABuodq7tSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2347, 147, 'gJYAABuodqrtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 6523, 6523, 0, 6523, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2348, 147, 'gJYAABuodqztSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 65230, 65230, 0, 65230, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2349, 147, 'gJYAABuodqTtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 385, 385, 0, 385, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2350, 147, 'gJYAABuodqXtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2351, 147, 'gJYAABuodrLtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2352, 147, 'gJYAABuodrDtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2353, 147, 'gJYAABuodq/tSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2354, 147, 'gJYAABuodrHtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2355, 147, 'gJYAABuodqvtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2356, 147, 'gJYAABuodqjtSYg5', 'R1tJE4y7QWaIU8q9DD6MVR0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 760, 180, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2357, 148, 'gJYAABuodsjtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 5100, 5100, 0, 5100, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2358, 148, 'gJYAABuodsrtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1491, 1491, 0, 0, 0, 2, 1491);
INSERT INTO `eas_wo_dtl` VALUES (2359, 148, 'gJYAABuodsPtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 656, 656, 0, 656, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2360, 148, 'gJYAABuodsXtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 15, 15, 0, 15, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2361, 148, 'gJYAABuodsntSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 7684, 7684, 0, 7684, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2362, 148, 'gJYAABuodsvtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2363, 148, 'gJYAABuods/tSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2364, 148, 'gJYAABuods3tSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 298, 298, 0, 298, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2365, 148, 'gJYAABuodsDtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2982, 2982, 0, 2982, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2366, 148, 'gJYAABuodsztSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 24, 24, 0, 24, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2367, 148, 'gJYAABuodsbtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6843, 6843, 0, 6843, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2368, 148, 'gJYAABuodsHtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2369, 148, 'gJYAABuodsftSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 92, 92, 0, 92, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2370, 148, 'gJYAABuodsLtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1700, 1700, 0, 1700, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2371, 148, 'gJYAABuodsTtSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 92, 92, 0, 0, 0, NULL, 92);
INSERT INTO `eas_wo_dtl` VALUES (2372, 148, 'gJYAABuods7tSYg5', 'N0a470yzSx+fd6yYf4F43x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6843, 6843, 0, 6843, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2373, 149, 'gJYAABuqg3ftSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 227, 227, 0, 0, 0, 2, 227);
INSERT INTO `eas_wo_dtl` VALUES (2374, 149, 'gJYAABuqg3XtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 14, 14, 0, 0, 0, 2, 14);
INSERT INTO `eas_wo_dtl` VALUES (2375, 149, 'gJYAABuqg4DtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 5, 5, 0, 5, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2376, 149, 'gJYAABuqg3btSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 12, 12, 0, 0, 0, 2, 12);
INSERT INTO `eas_wo_dtl` VALUES (2377, 149, 'gJYAABuqg3HtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 440, 440, 0, 440, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2378, 149, 'gJYAABuqg3LtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2379, 149, 'gJYAABuqg3/tSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2380, 149, 'gJYAABuqg4HtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 23, 23, 0, 23, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2381, 149, 'gJYAABuqg3jtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 227, 227, 0, 227, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2382, 149, 'gJYAABuqg3ztSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 3, 3, 0, 3, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2383, 149, 'gJYAABuqg3PtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 424, 424, 0, 424, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2384, 149, 'gJYAABuqg37tSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2385, 149, 'gJYAABuqg3ntSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (2386, 149, 'gJYAABuqg3rtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 105, 105, 0, 105, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2387, 149, 'gJYAABuqg3TtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (2388, 149, 'gJYAABuqg3vtSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 424, 424, 0, 424, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2389, 149, 'gJYAABuqg33tSYg5', 'Lm8+dy2XTo6QB7BSFniuwx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 316, 316, 0, 316, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2390, 150, 'gJYAABuqg5DtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 441, 441, 0, 0, 0, 2, 441);
INSERT INTO `eas_wo_dtl` VALUES (2391, 150, 'gJYAABuqg5ftSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 81, 81, 0, 81, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2392, 150, 'gJYAABuqg5HtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 9, 9, 0, 9, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2393, 150, 'gJYAABuqg5jtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1409, 1409, 0, 1409, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2394, 150, 'gJYAABuqg5btSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2395, 150, 'gJYAABuqg53tSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2396, 150, 'gJYAABuqg5rtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 91, 91, 0, 91, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2397, 150, 'gJYAABuqg5TtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 910, 910, 0, 910, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2398, 150, 'gJYAABuqg5PtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 11, 11, 0, 11, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2399, 150, 'gJYAABuqg4/tSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1252, 1252, 0, 1252, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2400, 150, 'gJYAABuqg5ntSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2401, 150, 'gJYAABuqg47tSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (2402, 150, 'gJYAABuqg5vtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 311, 311, 0, 311, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2403, 150, 'gJYAABuqg5ztSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 61, 61, 0, 0, 0, NULL, 61);
INSERT INTO `eas_wo_dtl` VALUES (2404, 150, 'gJYAABuqg5LtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1252, 1252, 0, 1252, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2405, 150, 'gJYAABuqg5XtSYg5', '4UH7rRlJQhmD+5CueXpNax0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 933, 933, 0, 933, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2406, 151, 'gJYAABurPNLtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 224, 224, 0, 0, 0, 2, 224);
INSERT INTO `eas_wo_dtl` VALUES (2407, 151, 'gJYAABurPMTtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 13, 13, 0, 13, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2408, 151, 'gJYAABurPMjtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 4, 4, 0, 4, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2409, 151, 'gJYAABurPMztSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 12, 12, 0, 0, 0, 2, 12);
INSERT INTO `eas_wo_dtl` VALUES (2410, 151, 'gJYAABurPMbtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 419, 419, 0, 419, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2411, 151, 'gJYAABurPMPtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2412, 151, 'gJYAABurPMftSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2413, 151, 'gJYAABurPNPtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 22, 22, 0, 22, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2414, 151, 'gJYAABurPNDtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 223, 223, 0, 223, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2415, 151, 'gJYAABurPMvtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2416, 151, 'gJYAABurPM3tSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 404, 404, 0, 404, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2417, 151, 'gJYAABurPMntSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2418, 151, 'gJYAABurPM7tSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (2419, 151, 'gJYAABurPM/tSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 100, 100, 0, 100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2420, 151, 'gJYAABurPMXtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (2421, 151, 'gJYAABurPMrtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 404, 404, 0, 404, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2422, 151, 'gJYAABurPNHtSYg5', 'uL9YLo4vT6OofkdVDu8hyh0NgN0=', 'gJYAABctWP5ECefw', '06.10.03.001.0077', 'DICE', 'S-DICE-BXCD11334', '千个', 301, 301, 0, 301, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2423, 152, 'gJYAABurPN/tSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 185, 185, 0, 185, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2424, 152, 'gJYAABurPOHtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 27, 27, 0, 27, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2425, 152, 'gJYAABurPOLtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 428, 428, 0, 428, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2426, 152, 'gJYAABurPNztSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2427, 152, 'gJYAABurPOXtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2428, 152, 'gJYAABurPOftSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 21, 21, 0, 21, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2429, 152, 'gJYAABurPN7tSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 210, 210, 0, 210, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2430, 152, 'gJYAABurPODtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2431, 152, 'gJYAABurPNntSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2432, 152, 'gJYAABurPObtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2433, 152, 'gJYAABurPNrtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (2434, 152, 'gJYAABurPOTtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 103, 103, 0, 103, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2435, 152, 'gJYAABurPNvtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (2436, 152, 'gJYAABurPN3tSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2437, 152, 'gJYAABurPOPtSYg5', 'zvuLDgJKROW9pvqURUYryB0NgN0=', 'gJYAABctWP5ECefw', '06.10.03.001.0077', 'DICE', 'S-DICE-BXCD11334', '千个', 308, 308, 0, 308, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2438, 153, 'gJYAABur71PtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 5400, 5400, 0, 5400, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2439, 153, 'gJYAABur71XtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1578, 1578, 0, 0, 0, 2, 1578);
INSERT INTO `eas_wo_dtl` VALUES (2440, 153, 'gJYAABur70/tSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 694, 694, 0, 694, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2441, 153, 'gJYAABur71DtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 16, 16, 0, 16, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2442, 153, 'gJYAABur71TtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 8136, 8136, 0, 8136, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2443, 153, 'gJYAABur71btSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2444, 153, 'gJYAABur71rtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 19, 19, 0, 19, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2445, 153, 'gJYAABur71jtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 316, 316, 0, 316, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2446, 153, 'gJYAABur70ztSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3157, 3157, 0, 3157, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2447, 153, 'gJYAABur71ftSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 25, 25, 0, 25, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2448, 153, 'gJYAABur71LtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7245, 7245, 0, 7245, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2449, 153, 'gJYAABur703tSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2450, 153, 'gJYAABur71HtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 98, 98, 0, 98, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2451, 153, 'gJYAABur707tSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1800, 1800, 0, 1800, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2452, 153, 'gJYAABur70vtSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 98, 98, 0, 0, 0, NULL, 98);
INSERT INTO `eas_wo_dtl` VALUES (2453, 153, 'gJYAABur71ntSYg5', 'M4nBURBOQim4o7DYnwPwth0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7245, 7245, 0, 7245, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2454, 154, 'gJYAABusfPPtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 3606, 3606, 0, 3606, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2455, 154, 'gJYAABusfO3tSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 505, 505, 0, 381, 0, 2, 123);
INSERT INTO `eas_wo_dtl` VALUES (2456, 154, 'gJYAABusfOztSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 97, 97, 0, 97, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2457, 154, 'gJYAABusfO7tSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5995, 5995, 0, 5995, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2458, 154, 'gJYAABusfPHtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2459, 154, 'gJYAABusfPbtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2460, 154, 'gJYAABusfO/tSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 577, 577, 0, 577, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2461, 154, 'gJYAABusfPLtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5769, 5769, 0, 5769, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2462, 154, 'gJYAABusfOvtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 43, 43, 0, 43, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2463, 154, 'gJYAABusfOntSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12312, 12312, 0, 12312, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2464, 154, 'gJYAABusfPXtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2465, 154, 'gJYAABusfOjtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 120, 120, 0, 0, 0, NULL, 120);
INSERT INTO `eas_wo_dtl` VALUES (2466, 154, 'gJYAABusfOrtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3059, 3059, 0, 3059, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2467, 154, 'gJYAABusfPTtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 600, 600, 0, 0, 0, NULL, 600);
INSERT INTO `eas_wo_dtl` VALUES (2468, 154, 'gJYAABusfPDtSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12312, 12312, 0, 12312, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2469, 154, 'gJYAABusfPftSYg5', 'EIFnx4kAQfuKEylVIbNvmB0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 3059, 3059, 0, 3059, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2470, 155, 'gJYAAButox/tSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 101, 101, 0, 0, 0, 2, 101);
INSERT INTO `eas_wo_dtl` VALUES (2471, 155, 'gJYAAButoxXtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4332, 4332, 0, 4332, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2472, 155, 'gJYAAButoxvtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 219, 219, 0, 0, 0, 2, 219);
INSERT INTO `eas_wo_dtl` VALUES (2473, 155, 'gJYAAButoxntSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 9199, 9199, 0, 9199, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2474, 155, 'gJYAAButoxbtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2475, 155, 'gJYAAButoxHtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2476, 155, 'gJYAAButoxjtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 975, 975, 0, 975, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2477, 155, 'gJYAAButoxrtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 9755, 9755, 0, 9755, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2478, 155, 'gJYAAButoxDtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 78, 78, 0, 78, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2479, 155, 'gJYAAButoxftSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 18700, 18700, 0, 0, 0, NULL, 18700);
INSERT INTO `eas_wo_dtl` VALUES (2480, 155, 'gJYAAButox3tSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2481, 155, 'gJYAAButox7tSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 253, 253, 0, 253, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2482, 155, 'gJYAAButoxTtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 4646, 4646, 0, 4646, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2483, 155, 'gJYAAButoxPtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 253, 253, 0, 0, 0, NULL, 253);
INSERT INTO `eas_wo_dtl` VALUES (2484, 155, 'gJYAAButoxLtSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 18700, 18700, 0, 18700, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2485, 155, 'gJYAAButoxztSYg5', 'mDXFtySSSg2f0AOpm1Xrch0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 4646, 4646, 0, 4646, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2486, 156, 'gJYAAButo6TtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2482, 2482, 0, 2482, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2487, 156, 'gJYAAButo6DtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 419, 419, 0, 380, 0, 2, 39);
INSERT INTO `eas_wo_dtl` VALUES (2488, 156, 'gJYAAButo5ztSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6469, 6469, 0, 6469, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2489, 156, 'gJYAAButo6ftSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2490, 156, 'gJYAAButo6btSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2491, 156, 'gJYAAButo57tSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 318, 318, 0, 318, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2492, 156, 'gJYAAButo6LtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3179, 3179, 0, 3179, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2493, 156, 'gJYAAButo6PtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 19, 19, 0, 19, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2494, 156, 'gJYAAButo5rtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6244, 6244, 0, 6244, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2495, 156, 'gJYAAButo5/tSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2496, 156, 'gJYAAButo6jtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 61, 61, 0, 0, 0, NULL, 61);
INSERT INTO `eas_wo_dtl` VALUES (2497, 156, 'gJYAAButo5vtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1551, 1551, 0, 1551, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2498, 156, 'gJYAAButo6HtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 304, 304, 0, 0, 0, NULL, 304);
INSERT INTO `eas_wo_dtl` VALUES (2499, 156, 'gJYAAButo6XtSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6244, 6244, 0, 6244, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2500, 156, 'gJYAAButo53tSYg5', '+zNyWjz/QgyLDQ/arqicyx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 4654, 4654, 0, 4654, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2501, 157, 'gJYAAButo8ztSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 29, 29, 0, 0, 0, 2, 29);
INSERT INTO `eas_wo_dtl` VALUES (2502, 157, 'gJYAAButo8LtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1260, 1260, 0, 668, 0, 2, 592);
INSERT INTO `eas_wo_dtl` VALUES (2503, 157, 'gJYAAButo8ftSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 64, 64, 0, 0, 0, 2, 64);
INSERT INTO `eas_wo_dtl` VALUES (2504, 157, 'gJYAAButo8btSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2675, 2675, 0, 2675, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2505, 157, 'gJYAAButo8PtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2506, 157, 'gJYAAButo77tSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2507, 157, 'gJYAAButo8XtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 284, 284, 0, 284, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2508, 157, 'gJYAAButo8jtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 2837, 2837, 0, 2837, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2509, 157, 'gJYAAButo73tSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 23, 23, 0, 23, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2510, 157, 'gJYAAButo8TtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 5438, 5438, 0, 0, 0, NULL, 5438);
INSERT INTO `eas_wo_dtl` VALUES (2511, 157, 'gJYAAButo8rtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2512, 157, 'gJYAAButo8vtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 74, 74, 0, 74, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2513, 157, 'gJYAAButo8HtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1351, 1351, 0, 1351, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2514, 157, 'gJYAAButo8DtSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 74, 74, 0, 0, 0, NULL, 74);
INSERT INTO `eas_wo_dtl` VALUES (2515, 157, 'gJYAAButo7/tSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5438, 5438, 0, 5438, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2516, 157, 'gJYAAButo8ntSYg5', 'GSatEXu/Tgy5mV6agXA1Hh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 1351, 1351, 0, 1351, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2517, 158, 'gJYAAButo9vtSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 50000, 50000, 0, 50000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2518, 158, 'gJYAAButo9btSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 22255, 22255, 0, 22255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2519, 158, 'gJYAAButo9TtSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 3760, 3760, 0, 3760, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2520, 158, 'gJYAAButo9jtSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 75050, 75050, 0, 75050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2521, 158, 'gJYAAButo9ztSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2522, 158, 'gJYAAButo9ftSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 6523, 6523, 0, 6523, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2523, 158, 'gJYAAButo9rtSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 65230, 65230, 0, 65230, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2524, 158, 'gJYAAButo9LtSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 385, 385, 0, 385, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2525, 158, 'gJYAAButo9PtSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2526, 158, 'gJYAAButo+DtSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2527, 158, 'gJYAAButo97tSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2528, 158, 'gJYAAButo93tSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2529, 158, 'gJYAAButo9/tSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2530, 158, 'gJYAAButo9ntSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2531, 158, 'gJYAAButo9XtSYg5', 'e7FU16DyS4aZ2jw/R8Rd9x0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2532, 159, 'gJYAABu0akLtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 25000, 25000, 0, 25000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2533, 159, 'gJYAABu0ajztSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 11128, 11128, 0, 11128, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2534, 159, 'gJYAABu0ajvtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 1880, 1880, 0, 1880, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2535, 159, 'gJYAABu0aj/tSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 37525, 37525, 0, 37525, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2536, 159, 'gJYAABu0akPtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 63, 63, 0, 63, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2537, 159, 'gJYAABu0aj7tSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 3262, 3262, 0, 3262, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2538, 159, 'gJYAABu0akHtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 32615, 32615, 0, 32615, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2539, 159, 'gJYAABu0ajntSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 193, 193, 0, 193, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2540, 159, 'gJYAABu0ajrtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2541, 159, 'gJYAABu0akftSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2542, 159, 'gJYAABu0akXtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 25000, 25000, 0, 25000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2543, 159, 'gJYAABu0akTtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 865, 865, 0, 865, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2544, 159, 'gJYAABu0akbtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 100625, 100625, 0, 100625, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2545, 159, 'gJYAABu0akDtSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 100625, 100625, 0, 100625, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2546, 159, 'gJYAABu0aj3tSYg5', 'II12HpVwRrebOEtO3bJeZh0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 290, 290, 0, 290, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2547, 160, 'gJYAABu1KALtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 900, 900, 0, 900, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2548, 160, 'gJYAABu1J/3tSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 361, 361, 0, 0, 0, 2, 361);
INSERT INTO `eas_wo_dtl` VALUES (2549, 160, 'gJYAABu1J/rtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 127, 127, 0, 111, 0, 2, 16);
INSERT INTO `eas_wo_dtl` VALUES (2550, 160, 'gJYAABu1J/jtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 12, 12, 0, 12, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2551, 160, 'gJYAABu1J/ztSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 1356, 1356, 0, 1356, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2552, 160, 'gJYAABu1J/XtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2553, 160, 'gJYAABu1J/ntSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2554, 160, 'gJYAABu1J//tSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 60, 60, 0, 60, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2555, 160, 'gJYAABu1J/vtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 604, 604, 0, 604, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2556, 160, 'gJYAABu1J/PtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2557, 160, 'gJYAABu1KAHtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1208, 1208, 0, 1208, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2558, 160, 'gJYAABu1J/btSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2559, 160, 'gJYAABu1J/7tSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2560, 160, 'gJYAABu1J/ftSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 300, 300, 0, 300, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2561, 160, 'gJYAABu1J/TtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 16, 16, 0, 0, 0, NULL, 16);
INSERT INTO `eas_wo_dtl` VALUES (2562, 160, 'gJYAABu1KADtSYg5', 'oLcAJGCFSKuZxL4ML6psbh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1208, 1208, 0, 1208, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2563, 161, 'gJYAABu1gtDtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 1800, 1800, 0, 1800, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2564, 161, 'gJYAABu1gsvtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 722, 722, 0, 0, 0, 2, 722);
INSERT INTO `eas_wo_dtl` VALUES (2565, 161, 'gJYAABu1gsntSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 253, 253, 0, 0, 0, 2, 253);
INSERT INTO `eas_wo_dtl` VALUES (2566, 161, 'gJYAABu1gsbtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 24, 24, 0, 24, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2567, 161, 'gJYAABu1gsrtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 2712, 2712, 0, 2712, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2568, 161, 'gJYAABu1gsPtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2569, 161, 'gJYAABu1gsftSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2570, 161, 'gJYAABu1gs3tSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 121, 121, 0, 121, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2571, 161, 'gJYAABu1gsjtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1208, 1208, 0, 1208, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2572, 161, 'gJYAABu1gsHtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 5, 5, 0, 5, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2573, 161, 'gJYAABu1gs/tSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2415, 2415, 0, 2415, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2574, 161, 'gJYAABu1gsTtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2575, 161, 'gJYAABu1gsztSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2576, 161, 'gJYAABu1gsXtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 600, 600, 0, 600, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2577, 161, 'gJYAABu1gsLtSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 33, 33, 0, 0, 0, NULL, 33);
INSERT INTO `eas_wo_dtl` VALUES (2578, 161, 'gJYAABu1gs7tSYg5', 'HBSPnh3zQmeWpf0Sc4f/LR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2415, 2415, 0, 2415, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2579, 162, 'gJYAABu1gxjtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 20000, 20000, 0, 20000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2580, 162, 'gJYAABu1gxLtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 8902, 8902, 0, 8902, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2581, 162, 'gJYAABu1gxHtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 1504, 1504, 0, 1504, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2582, 162, 'gJYAABu1gxXtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 30020, 30020, 0, 30020, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2583, 162, 'gJYAABu1gxntSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 50, 50, 0, 50, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2584, 162, 'gJYAABu1gxTtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 2609, 2609, 0, 2609, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2585, 162, 'gJYAABu1gxftSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 26092, 26092, 0, 26092, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2586, 162, 'gJYAABu1gw/tSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 154, 154, 0, 154, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2587, 162, 'gJYAABu1gxDtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2588, 162, 'gJYAABu1gx3tSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2589, 162, 'gJYAABu1gxvtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 20000, 20000, 0, 20000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2590, 162, 'gJYAABu1gxrtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 692, 692, 0, 692, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2591, 162, 'gJYAABu1gxztSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 80500, 80500, 0, 80500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2592, 162, 'gJYAABu1gxbtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 80500, 80500, 0, 80500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2593, 162, 'gJYAABu1gxPtSYg5', 'pvzOe3+iQRiWngrwxygedh0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 232, 232, 0, 232, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2594, 163, 'gJYAABu4a//tSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 10000, 10000, 0, 10000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2595, 163, 'gJYAABu4a/rtSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 4451, 4451, 0, 4451, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2596, 163, 'gJYAABu4a/jtSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 752, 752, 0, 752, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2597, 163, 'gJYAABu4a/ztSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 15010, 15010, 0, 15010, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2598, 163, 'gJYAABu4bADtSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2599, 163, 'gJYAABu4a/vtSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 1305, 1305, 0, 1305, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2600, 163, 'gJYAABu4a/7tSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 13046, 13046, 0, 13046, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2601, 163, 'gJYAABu4a/btSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 77, 77, 0, 77, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2602, 163, 'gJYAABu4a/ftSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2603, 163, 'gJYAABu4bATtSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2604, 163, 'gJYAABu4bALtSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 10000, 10000, 0, 10000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2605, 163, 'gJYAABu4bAHtSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 346, 346, 0, 346, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2606, 163, 'gJYAABu4bAPtSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 40250, 40250, 0, 40250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2607, 163, 'gJYAABu4a/3tSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 40250, 40250, 0, 40250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2608, 163, 'gJYAABu4a/ntSYg5', 'jdYCi4umR6yrCZHyIf7P6B0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 116, 116, 0, 116, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2609, 164, 'gJYAABu4bILtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 37, 37, 0, 37, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2610, 164, 'gJYAABu4bH/tSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 139, 139, 0, 139, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2611, 164, 'gJYAABu4bHXtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 984, 984, 0, 0, 0, 2, 984);
INSERT INTO `eas_wo_dtl` VALUES (2612, 164, 'gJYAABu4bHztSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2015, 2015, 0, 2015, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2613, 164, 'gJYAABu4bH3tSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2614, 164, 'gJYAABu4bHTtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2615, 164, 'gJYAABu4bIDtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 209, 209, 0, 209, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2616, 164, 'gJYAABu4bH7tSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2085, 2085, 0, 2085, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2617, 164, 'gJYAABu4bHLtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 15, 15, 0, 15, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2618, 164, 'gJYAABu4bHjtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4139, 4139, 0, 4139, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2619, 164, 'gJYAABu4bHPtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (2620, 164, 'gJYAABu4bIHtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2621, 164, 'gJYAABu4bIPtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (2622, 164, 'gJYAABu4bHntSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 55, 55, 0, 55, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2623, 164, 'gJYAABu4bHbtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1028, 1028, 0, 1028, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2624, 164, 'gJYAABu4bHHtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (2625, 164, 'gJYAABu4bHftSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 55, 55, 0, 0, 0, NULL, 55);
INSERT INTO `eas_wo_dtl` VALUES (2626, 164, 'gJYAABu4bHrtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4139, 4139, 0, 4139, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2627, 164, 'gJYAABu4bHvtSYg5', 'M3tt5+CZRb6s7F9NEp8Gax0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 1028, 1028, 0, 1028, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2628, 165, 'gJYAABu4bJ/tSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 124, 124, 0, 124, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2629, 165, 'gJYAABu4bJTtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1127, 1127, 0, 0, 0, 2, 1127);
INSERT INTO `eas_wo_dtl` VALUES (2630, 165, 'gJYAABu4bJjtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 405, 405, 0, 0, 0, 2, 405);
INSERT INTO `eas_wo_dtl` VALUES (2631, 165, 'gJYAABu4bJztSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2773, 2773, 0, 2773, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2632, 165, 'gJYAABu4bJrtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2633, 165, 'gJYAABu4bKDtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2634, 165, 'gJYAABu4bJftSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 287, 287, 0, 287, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2635, 165, 'gJYAABu4bJ3tSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2870, 2870, 0, 2870, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2636, 165, 'gJYAABu4bJXtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 21, 21, 0, 21, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2637, 165, 'gJYAABu4bKLtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5695, 5695, 0, 5695, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2638, 165, 'gJYAABu4bJvtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (2639, 165, 'gJYAABu4bJPtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2640, 165, 'gJYAABu4bKPtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (2641, 165, 'gJYAABu4bKHtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2642, 165, 'gJYAABu4bJ7tSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1415, 1415, 0, 1415, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2643, 165, 'gJYAABu4bKXtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (2644, 165, 'gJYAABu4bJntSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 75, 75, 0, 0, 0, NULL, 75);
INSERT INTO `eas_wo_dtl` VALUES (2645, 165, 'gJYAABu4bJbtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5695, 5695, 0, 5695, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2646, 165, 'gJYAABu4bKTtSYg5', '2odChiALRS+H3OSNHd8NDx0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1415, 1415, 0, 1415, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2647, 166, 'gJYAABu4bLftSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 7335, 7335, 0, 7335, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2648, 166, 'gJYAABu4bLntSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 158, 158, 0, 35, 0, 2, 123);
INSERT INTO `eas_wo_dtl` VALUES (2649, 166, 'gJYAABu4bLXtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 736, 736, 0, 736, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2650, 166, 'gJYAABu4bLjtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 12762, 12762, 0, 12762, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2651, 166, 'gJYAABu4bLvtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2652, 166, 'gJYAABu4bMTtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 47, 47, 0, 47, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2653, 166, 'gJYAABu4bMHtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2282, 2282, 0, 2282, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2654, 166, 'gJYAABu4bLTtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 22818, 22818, 0, 14695, 0, 1, 8123);
INSERT INTO `eas_wo_dtl` VALUES (2655, 166, 'gJYAABu4bLPtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 150, 150, 0, 150, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2656, 166, 'gJYAABu4bLLtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 26208, 26208, 0, 26208, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2657, 166, 'gJYAABu4bL/tSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (2658, 166, 'gJYAABu4bMLtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2659, 166, 'gJYAABu4bLrtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 130, 130, 0, 0, 0, NULL, 130);
INSERT INTO `eas_wo_dtl` VALUES (2660, 166, 'gJYAABu4bMDtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 346, 346, 0, 346, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2661, 166, 'gJYAABu4bLztSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 6511, 6511, 0, 6511, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2662, 166, 'gJYAABu4bLbtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 130, 130, 0, 0, 0, NULL, 130);
INSERT INTO `eas_wo_dtl` VALUES (2663, 166, 'gJYAABu4bMPtSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 346, 346, 0, 0, 0, NULL, 346);
INSERT INTO `eas_wo_dtl` VALUES (2664, 166, 'gJYAABu4bL7tSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 26208, 26208, 0, 26208, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2665, 166, 'gJYAABu4bL3tSYg5', 'GEdbU3+HRIi2QxROCLsSix0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 6511, 6511, 0, 6511, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2666, 167, 'gJYAABu4bMftSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 7533, 7533, 0, 7533, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2667, 167, 'gJYAABu4bM/tSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 1055, 1055, 0, 376, 0, 2, 679);
INSERT INTO `eas_wo_dtl` VALUES (2668, 167, 'gJYAABu4bMntSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 203, 203, 0, 103, 0, 2, 100);
INSERT INTO `eas_wo_dtl` VALUES (2669, 167, 'gJYAABu4bM3tSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 12763, 12763, 0, 12763, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2670, 167, 'gJYAABu4bMjtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2671, 167, 'gJYAABu4bNPtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 47, 47, 0, 47, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2672, 167, 'gJYAABu4bNftSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1281, 1281, 0, 1281, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2673, 167, 'gJYAABu4bNXtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 12806, 12806, 0, 12806, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2674, 167, 'gJYAABu4bNTtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 98, 98, 0, 98, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2675, 167, 'gJYAABu4bMrtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 26209, 26209, 0, 11596, 0, NULL, 14613);
INSERT INTO `eas_wo_dtl` VALUES (2676, 167, 'gJYAABu4bNbtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (2677, 167, 'gJYAABu4bNLtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2678, 167, 'gJYAABu4bMztSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 130, 130, 0, 0, 0, NULL, 130);
INSERT INTO `eas_wo_dtl` VALUES (2679, 167, 'gJYAABu4bNDtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 346, 346, 0, 346, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2680, 167, 'gJYAABu4bM7tSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 6512, 6512, 0, 6512, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2681, 167, 'gJYAABu4bNHtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 130, 130, 0, 0, 0, NULL, 130);
INSERT INTO `eas_wo_dtl` VALUES (2682, 167, 'gJYAABu4bNjtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 346, 346, 0, 0, 0, NULL, 346);
INSERT INTO `eas_wo_dtl` VALUES (2683, 167, 'gJYAABu4bMvtSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 26209, 26209, 0, 26209, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2684, 167, 'gJYAABu4bNntSYg5', 'S1TMrOOpR7OQhxaQGsVJVh0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 6512, 6512, 0, 6512, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2685, 168, 'gJYAABu4bN3tSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAA95La9ECefw', '01.01.01.010.2047', 'DICE', 'DICE-BXCD2630', '千个', 5343, 0, 0, 0, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2686, 168, 'gJYAABu4bOjtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 5962, 5962, 0, 5962, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2687, 168, 'gJYAABu4bOntSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 149, 149, 0, 0, 0, 2, 149);
INSERT INTO `eas_wo_dtl` VALUES (2688, 168, 'gJYAABu4bO3tSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 614, 614, 0, 614, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2689, 168, 'gJYAABu4bOztSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10472, 10472, 0, 10472, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2690, 168, 'gJYAABu4bOftSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2691, 168, 'gJYAABu4bOvtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 38, 38, 0, 38, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2692, 168, 'gJYAABu4bOTtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1004, 1004, 0, 1004, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2693, 168, 'gJYAABu4bObtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 10039, 10039, 0, 10039, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2694, 168, 'gJYAABu4bO7tSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 69, 69, 0, 69, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2695, 168, 'gJYAABu4bOPtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 21505, 21505, 0, 0, 0, NULL, 21505);
INSERT INTO `eas_wo_dtl` VALUES (2696, 168, 'gJYAABu4bOHtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (2697, 168, 'gJYAABu4bN/tSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2698, 168, 'gJYAABu4bOLtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 107, 107, 0, 0, 0, NULL, 107);
INSERT INTO `eas_wo_dtl` VALUES (2699, 168, 'gJYAABu4bOrtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 284, 284, 0, 284, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2700, 168, 'gJYAABu4bODtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5343, 5343, 0, 5343, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2701, 168, 'gJYAABu4bN7tSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 107, 107, 0, 0, 0, NULL, 107);
INSERT INTO `eas_wo_dtl` VALUES (2702, 168, 'gJYAABu4bOXtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 284, 284, 0, 0, 0, NULL, 284);
INSERT INTO `eas_wo_dtl` VALUES (2703, 168, 'gJYAABu4bNztSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 21505, 21505, 0, 21505, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2704, 168, 'gJYAABvGrZvtSYg5', 'okHyMLphRxu2NRmCeFqgqB0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 5343, 5343, 0, 5343, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2705, 169, 'gJYAABu4b1HtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 7200, 7200, 0, 7200, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2706, 169, 'gJYAABu4b1PtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 2104, 2104, 0, 0, 0, 2, 2104);
INSERT INTO `eas_wo_dtl` VALUES (2707, 169, 'gJYAABu4b03tSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 926, 926, 0, 0, 0, 2, 926);
INSERT INTO `eas_wo_dtl` VALUES (2708, 169, 'gJYAABu4b07tSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 21, 21, 0, 21, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2709, 169, 'gJYAABu4b1LtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 10848, 10848, 0, 10848, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2710, 169, 'gJYAABu4b1TtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2711, 169, 'gJYAABu4b1jtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2712, 169, 'gJYAABu4b1btSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 421, 421, 0, 421, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2713, 169, 'gJYAABu4b0rtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4210, 4210, 0, 4210, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2714, 169, 'gJYAABu4b1XtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 34, 34, 0, 34, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2715, 169, 'gJYAABu4b1DtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 9660, 9660, 0, 0, 0, NULL, 9660);
INSERT INTO `eas_wo_dtl` VALUES (2716, 169, 'gJYAABu4b0vtSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 12, 12, 0, 3, 0, NULL, 9);
INSERT INTO `eas_wo_dtl` VALUES (2717, 169, 'gJYAABu4b0/tSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 131, 131, 0, 54, 0, NULL, 77);
INSERT INTO `eas_wo_dtl` VALUES (2718, 169, 'gJYAABu4b0ztSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2400, 2400, 0, 2400, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2719, 169, 'gJYAABu4b0ntSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 131, 131, 0, 0, 0, NULL, 131);
INSERT INTO `eas_wo_dtl` VALUES (2720, 169, 'gJYAABu4b1ftSYg5', 'PpVB4wlxSeWkO18zbwcSAh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 9660, 9660, 0, 9660, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2721, 170, 'gJYAABvGNeztSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 750, 750, 0, 750, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2722, 170, 'gJYAABvGNeftSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 301, 301, 0, 0, 0, 2, 301);
INSERT INTO `eas_wo_dtl` VALUES (2723, 170, 'gJYAABvGNeXtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 106, 106, 0, 0, 0, 2, 106);
INSERT INTO `eas_wo_dtl` VALUES (2724, 170, 'gJYAABvGNeLtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 10, 10, 0, 10, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2725, 170, 'gJYAABvGNebtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 1130, 1130, 0, 1130, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2726, 170, 'gJYAABvGNd7tSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2727, 170, 'gJYAABvGNePtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2728, 170, 'gJYAABvGNentSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 50, 50, 0, 50, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2729, 170, 'gJYAABvGNeTtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 503, 503, 0, 503, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2730, 170, 'gJYAABvGNd3tSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2731, 170, 'gJYAABvGNevtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1006, 1006, 0, 0, 0, NULL, 1006);
INSERT INTO `eas_wo_dtl` VALUES (2732, 170, 'gJYAABvGNeDtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2733, 170, 'gJYAABvGNejtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 14, 14, 0, 0, 0, NULL, 14);
INSERT INTO `eas_wo_dtl` VALUES (2734, 170, 'gJYAABvGNeHtSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 250, 250, 0, 250, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2735, 170, 'gJYAABvGNd/tSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 14, 14, 0, 0, 0, NULL, 14);
INSERT INTO `eas_wo_dtl` VALUES (2736, 170, 'gJYAABvGNertSYg5', 'wrwnnSpQSpCJ2LlYobnOwB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1006, 1006, 0, 1006, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2737, 171, 'gJYAABvGNgftSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 100, 100, 0, 100, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2738, 171, 'gJYAABvGNgLtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 45, 45, 0, 45, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2739, 171, 'gJYAABvGNgDtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 8, 8, 0, 8, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2740, 171, 'gJYAABvGNgTtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2741, 171, 'gJYAABvGNgjtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2742, 171, 'gJYAABvGNgPtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 13, 13, 0, 0, 0, 1, 13);
INSERT INTO `eas_wo_dtl` VALUES (2743, 171, 'gJYAABvGNgbtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 130, 130, 0, 0, 0, 1, 130);
INSERT INTO `eas_wo_dtl` VALUES (2744, 171, 'gJYAABvGNf7tSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2745, 171, 'gJYAABvGNf/tSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2746, 171, 'gJYAABvGNgztSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2747, 171, 'gJYAABvGNgrtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 100, 100, 0, 100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2748, 171, 'gJYAABvGNgntSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2749, 171, 'gJYAABvGNgvtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 403, 403, 0, 403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2750, 171, 'gJYAABvGNgXtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 403, 403, 0, 403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2751, 171, 'gJYAABvGNgHtSYg5', 'lC97LMqsRfa+0IZhXi7Mhx0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2752, 172, 'gJYAABvKKsXtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 10500, 10500, 0, 10500, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2753, 172, 'gJYAABvKKs3tSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 6008, 6008, 0, 0, 0, 2, 6008);
INSERT INTO `eas_wo_dtl` VALUES (2754, 172, 'gJYAABvKKsTtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1551, 1551, 0, 1500, 0, 2, 51);
INSERT INTO `eas_wo_dtl` VALUES (2755, 172, 'gJYAABvKKsPtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 202, 202, 0, 202, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2756, 172, 'gJYAABvKKsrtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 15820, 15820, 0, 15820, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2757, 172, 'gJYAABvKKsbtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 58, 58, 0, 58, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2758, 172, 'gJYAABvKKsjtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 37, 37, 0, 37, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2759, 172, 'gJYAABvKKsntSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 527, 527, 0, 527, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2760, 172, 'gJYAABvKKsDtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5271, 5271, 0, 5271, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2761, 172, 'gJYAABvKKsztSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 14088, 14088, 0, 0, 0, NULL, 14088);
INSERT INTO `eas_wo_dtl` VALUES (2762, 172, 'gJYAABvKKsvtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 17, 17, 0, 0, 0, NULL, 17);
INSERT INTO `eas_wo_dtl` VALUES (2763, 172, 'gJYAABvKKsLtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 190, 190, 0, 0, 0, NULL, 190);
INSERT INTO `eas_wo_dtl` VALUES (2764, 172, 'gJYAABvKKr/tSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3500, 3500, 0, 3500, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2765, 172, 'gJYAABvKKsftSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 190, 190, 0, 0, 0, NULL, 190);
INSERT INTO `eas_wo_dtl` VALUES (2766, 172, 'gJYAABvKKsHtSYg5', 'P5pbS42TTDmeUVdddoclyx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 14088, 14088, 0, 14088, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2767, 173, 'gJYAABvKKtrtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 4800, 4800, 0, 4800, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2768, 173, 'gJYAABvKKtztSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1403, 1403, 0, 0, 0, 2, 1403);
INSERT INTO `eas_wo_dtl` VALUES (2769, 173, 'gJYAABvKKtbtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 617, 617, 0, 0, 0, 2, 617);
INSERT INTO `eas_wo_dtl` VALUES (2770, 173, 'gJYAABvKKtftSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 14, 14, 0, 14, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2771, 173, 'gJYAABvKKtvtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 7232, 7232, 0, 1507, 0, NULL, 5725);
INSERT INTO `eas_wo_dtl` VALUES (2772, 173, 'gJYAABvKKt3tSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2773, 173, 'gJYAABvKKuHtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2774, 173, 'gJYAABvKKt/tSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 281, 281, 0, 281, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2775, 173, 'gJYAABvKKtPtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2806, 2806, 0, 2806, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2776, 173, 'gJYAABvKKt7tSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 22, 22, 0, 22, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2777, 173, 'gJYAABvKKtntSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6440, 6440, 0, 0, 0, NULL, 6440);
INSERT INTO `eas_wo_dtl` VALUES (2778, 173, 'gJYAABvKKtTtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (2779, 173, 'gJYAABvKKtjtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 87, 87, 0, 0, 0, NULL, 87);
INSERT INTO `eas_wo_dtl` VALUES (2780, 173, 'gJYAABvKKtXtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1600, 1600, 0, 1600, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2781, 173, 'gJYAABvKKtLtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 87, 87, 0, 0, 0, NULL, 87);
INSERT INTO `eas_wo_dtl` VALUES (2782, 173, 'gJYAABvKKuDtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6440, 6440, 0, 6440, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2783, 174, 'gJYAABvKKu/tSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 90000, 90000, 0, 89991, 0, 0, 9);
INSERT INTO `eas_wo_dtl` VALUES (2784, 174, 'gJYAABvKKurtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 40059, 40059, 0, 40059, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2785, 174, 'gJYAABvKKujtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 6768, 6768, 0, 6768, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2786, 174, 'gJYAABvKKuztSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 135090, 135090, 0, 135090, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2787, 174, 'gJYAABvKKvDtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 225, 225, 0, 225, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2788, 174, 'gJYAABvKKuvtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 11741, 11741, 0, 11741, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2789, 174, 'gJYAABvKKu7tSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 117414, 117414, 0, 117414, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2790, 174, 'gJYAABvKKubtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 693, 693, 0, 693, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2791, 174, 'gJYAABvKKuftSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 108, 108, 0, 72, 0, NULL, 36);
INSERT INTO `eas_wo_dtl` VALUES (2792, 174, 'gJYAABvKKvTtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 270, 270, 0, 270, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2793, 174, 'gJYAABvKKvLtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 90000, 90000, 0, 90000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2794, 174, 'gJYAABvKKvHtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3114, 3114, 0, 3114, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2795, 174, 'gJYAABvKKvPtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 362250, 362250, 0, 350723, 0, NULL, 11528);
INSERT INTO `eas_wo_dtl` VALUES (2796, 174, 'gJYAABvKKu3tSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 362250, 362250, 0, 362250, 297528, NULL, 297528);
INSERT INTO `eas_wo_dtl` VALUES (2797, 174, 'gJYAABvKKuntSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 1044, 1044, 0, 854, 350, NULL, 540);
INSERT INTO `eas_wo_dtl` VALUES (2798, 175, 'gJYAABvKKwbtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 1163, 1163, 0, 1163, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2799, 175, 'gJYAABvKKvrtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 24, 24, 0, 0, 0, 2, 24);
INSERT INTO `eas_wo_dtl` VALUES (2800, 175, 'gJYAABvKKwHtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 133, 133, 0, 133, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2801, 175, 'gJYAABvKKwTtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4423, 4423, 0, 4423, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2802, 175, 'gJYAABvKKv3tSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2803, 175, 'gJYAABvKKwrtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 14, 14, 0, 14, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2804, 175, 'gJYAABvKKwftSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 308, 308, 0, 308, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2805, 175, 'gJYAABvKKvvtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3081, 3081, 0, 3081, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2806, 175, 'gJYAABvKKwntSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 19, 19, 0, 19, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2807, 175, 'gJYAABvKKv/tSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4269, 4269, 0, 0, 0, NULL, 4269);
INSERT INTO `eas_wo_dtl` VALUES (2808, 175, 'gJYAABvKKwjtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (2809, 175, 'gJYAABvKKvntSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2810, 175, 'gJYAABvKKwPtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (2811, 175, 'gJYAABvKKwLtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 56, 56, 0, 0, 0, NULL, 56);
INSERT INTO `eas_wo_dtl` VALUES (2812, 175, 'gJYAABvKKv7tSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1061, 1061, 0, 1061, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2813, 175, 'gJYAABvKKwDtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (2814, 175, 'gJYAABvKKvztSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 56, 56, 0, 0, 0, NULL, 56);
INSERT INTO `eas_wo_dtl` VALUES (2815, 175, 'gJYAABvKKwXtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4269, 4269, 0, 4269, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2816, 175, 'gJYAABvKKvjtSYg5', 'rqVCdq3hQKOnS1KV7oY66R0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 3182, 3182, 0, 3182, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2817, 176, 'gJYAABvLqZntSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 5000, 5000, 0, 5000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2818, 176, 'gJYAABvLqZPtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 2226, 2226, 0, 2226, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2819, 176, 'gJYAABvLqZLtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 376, 376, 0, 376, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2820, 176, 'gJYAABvLqZbtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 7505, 7505, 0, 7505, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2821, 176, 'gJYAABvLqZrtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2822, 176, 'gJYAABvLqZXtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 652, 652, 0, 0, 0, 1, 652);
INSERT INTO `eas_wo_dtl` VALUES (2823, 176, 'gJYAABvLqZjtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 6523, 6523, 0, 0, 0, 1, 6523);
INSERT INTO `eas_wo_dtl` VALUES (2824, 176, 'gJYAABvLqZDtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 39, 39, 0, 39, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2825, 176, 'gJYAABvLqZHtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (2826, 176, 'gJYAABvLqZ7tSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2827, 176, 'gJYAABvLqZztSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 5000, 5000, 0, 5000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2828, 176, 'gJYAABvLqZvtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 173, 173, 0, 173, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2829, 176, 'gJYAABvLqZ3tSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 20125, 20125, 0, 20125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2830, 176, 'gJYAABvLqZftSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 20125, 20125, 0, 20125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2831, 176, 'gJYAABvLqZTtSYg5', '5GoHrOtIQSyiJElyBHORUR0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 58, 58, 0, 58, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2832, 177, 'gJYAABvMSlztSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 275, 275, 0, 275, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2833, 177, 'gJYAABvMSlvtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 31, 31, 0, 0, 0, 2, 31);
INSERT INTO `eas_wo_dtl` VALUES (2834, 177, 'gJYAABvMSlXtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABhfXltECefw', '01.02.01.001.1272', '荧光粉', 'KSL220', '克', 50, 50, 0, 0, 0, 2, 50);
INSERT INTO `eas_wo_dtl` VALUES (2835, 177, 'gJYAABvMSmXtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 468, 468, 0, 468, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2836, 177, 'gJYAABvMSlftSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2837, 177, 'gJYAABvMSl/tSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2838, 177, 'gJYAABvMSmPtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 25, 25, 0, 25, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2839, 177, 'gJYAABvMSmftSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 245, 245, 0, 245, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2840, 177, 'gJYAABvMSmHtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2841, 177, 'gJYAABvMSl7tSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 960, 960, 0, 0, 0, NULL, 960);
INSERT INTO `eas_wo_dtl` VALUES (2842, 177, 'gJYAABvMSl3tSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2843, 177, 'gJYAABvMSmTtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2844, 177, 'gJYAABvMSmLtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (2845, 177, 'gJYAABvMSlrtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 13, 13, 0, 0, 0, NULL, 13);
INSERT INTO `eas_wo_dtl` VALUES (2846, 177, 'gJYAABvMSlntSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 239, 239, 0, 239, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2847, 177, 'gJYAABvMSlbtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (2848, 177, 'gJYAABvMSmDtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 13, 13, 0, 0, 0, NULL, 13);
INSERT INTO `eas_wo_dtl` VALUES (2849, 177, 'gJYAABvMSljtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 960, 960, 0, 960, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2850, 177, 'gJYAABvMSmbtSYg5', 'jVPtklYCR6qtppbYecgymh0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 239, 239, 0, 239, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2851, 178, 'gJYAABvOKUrtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 560, 560, 0, 0, 0, 2, 560);
INSERT INTO `eas_wo_dtl` VALUES (2852, 178, 'gJYAABvOKUftSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 65, 65, 0, 65, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2853, 178, 'gJYAABvOKUntSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3065, 3065, 0, 0, 0, 2, 3065);
INSERT INTO `eas_wo_dtl` VALUES (2854, 178, 'gJYAABvOKUTtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7359, 7359, 0, 7359, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2855, 178, 'gJYAABvOKUPtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2856, 178, 'gJYAABvOKULtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2857, 178, 'gJYAABvOKTztSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 633, 633, 0, 633, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2858, 178, 'gJYAABvOKUjtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6333, 6333, 0, 6333, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2859, 178, 'gJYAABvOKTntSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 74, 74, 0, 74, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2860, 178, 'gJYAABvOKUvtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8712, 8712, 0, 0, 0, NULL, 8712);
INSERT INTO `eas_wo_dtl` VALUES (2861, 178, 'gJYAABvOKTvtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (2862, 178, 'gJYAABvOKUHtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2863, 178, 'gJYAABvOKT3tSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 43, 43, 0, 0, 0, NULL, 43);
INSERT INTO `eas_wo_dtl` VALUES (2864, 178, 'gJYAABvOKUbtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 115, 115, 0, 0, 0, NULL, 115);
INSERT INTO `eas_wo_dtl` VALUES (2865, 178, 'gJYAABvOKT7tSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2165, 2165, 0, 2165, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2866, 178, 'gJYAABvOKUXtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 43, 43, 0, 0, 0, NULL, 43);
INSERT INTO `eas_wo_dtl` VALUES (2867, 178, 'gJYAABvOKTrtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 115, 115, 0, 0, 0, NULL, 115);
INSERT INTO `eas_wo_dtl` VALUES (2868, 178, 'gJYAABvOKT/tSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8712, 8712, 0, 8712, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2869, 178, 'gJYAABvOKUDtSYg5', '/upvfU28QuG/gklpW/xBpR0NgN0=', 'gJYAABc3p0xECefw', '06.10.03.001.0091', 'DICE', 'S-DICE-BXHV1931', '千个', 4329, 4329, 0, 4329, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2870, 179, 'gJYAABvOKWjtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 12933, 12933, 0, 5858, 0, 2, 7075);
INSERT INTO `eas_wo_dtl` VALUES (2871, 179, 'gJYAABvOKXDtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1336, 1336, 0, 500, 0, 2, 836);
INSERT INTO `eas_wo_dtl` VALUES (2872, 179, 'gJYAABvOKW7tSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 153, 153, 0, 0, 0, 2, 153);
INSERT INTO `eas_wo_dtl` VALUES (2873, 179, 'gJYAABvOKXrtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 31289, 31289, 0, 31289, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2874, 179, 'gJYAABvOKW3tSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 150, 150, 0, 98, 0, NULL, 52);
INSERT INTO `eas_wo_dtl` VALUES (2875, 179, 'gJYAABvOKXHtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 136, 136, 0, 136, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2876, 179, 'gJYAABvOKXjtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 2053, 2053, 0, 2053, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2877, 179, 'gJYAABvOKXXtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 20525, 20525, 0, 20525, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2878, 179, 'gJYAABvOKWntSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 198, 198, 0, 198, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2879, 179, 'gJYAABvOKWrtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 30201, 30201, 0, 0, 0, NULL, 30201);
INSERT INTO `eas_wo_dtl` VALUES (2880, 179, 'gJYAABvOKWvtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (2881, 179, 'gJYAABvOKXbtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 23, 23, 0, 18, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (2882, 179, 'gJYAABvOKXTtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 150, 150, 0, 0, 0, NULL, 150);
INSERT INTO `eas_wo_dtl` VALUES (2883, 179, 'gJYAABvOKXftSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 399, 399, 0, 0, 0, NULL, 399);
INSERT INTO `eas_wo_dtl` VALUES (2884, 179, 'gJYAABvOKXntSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7503, 7503, 0, 7503, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2885, 179, 'gJYAABvOKW/tSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 150, 150, 0, 0, 0, NULL, 150);
INSERT INTO `eas_wo_dtl` VALUES (2886, 179, 'gJYAABvOKWztSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 399, 399, 0, 0, 0, NULL, 399);
INSERT INTO `eas_wo_dtl` VALUES (2887, 179, 'gJYAABvOKXPtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 30201, 30201, 0, 30201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2888, 179, 'gJYAABvOKXLtSYg5', 'scYH4oTmQvynQN52UKA1Kx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 22510, 22510, 0, 22510, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2889, 180, 'gJYAABvP8UvtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 13454, 13454, 0, 0, 0, 2, 13454);
INSERT INTO `eas_wo_dtl` VALUES (2890, 180, 'gJYAABvP8UftSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1943, 1943, 0, 0, 0, 2, 1943);
INSERT INTO `eas_wo_dtl` VALUES (2891, 180, 'gJYAABvP8VLtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 31167, 31167, 0, 4113, 0, NULL, 27054);
INSERT INTO `eas_wo_dtl` VALUES (2892, 180, 'gJYAABvP8U3tSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 149, 149, 0, 0, 0, NULL, 149);
INSERT INTO `eas_wo_dtl` VALUES (2893, 180, 'gJYAABvP8U/tSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 135, 135, 0, 98, 0, NULL, 37);
INSERT INTO `eas_wo_dtl` VALUES (2894, 180, 'gJYAABvP8VftSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1532, 1532, 0, 1532, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2895, 180, 'gJYAABvP8VHtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 15318, 15318, 0, 15318, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2896, 180, 'gJYAABvP8UjtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 90, 90, 0, 90, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2897, 180, 'gJYAABvP8UrtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 30084, 30084, 0, 0, 0, NULL, 30084);
INSERT INTO `eas_wo_dtl` VALUES (2898, 180, 'gJYAABvP8UntSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (2899, 180, 'gJYAABvP8VTtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 22, 22, 0, 0, 0, NULL, 22);
INSERT INTO `eas_wo_dtl` VALUES (2900, 180, 'gJYAABvP8VjtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 149, 149, 0, 0, 0, NULL, 149);
INSERT INTO `eas_wo_dtl` VALUES (2901, 180, 'gJYAABvP8VbtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 398, 398, 0, 0, 0, NULL, 398);
INSERT INTO `eas_wo_dtl` VALUES (2902, 180, 'gJYAABvP8VPtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7474, 7474, 0, 7474, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2903, 180, 'gJYAABvP8VXtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 149, 149, 0, 0, 0, NULL, 149);
INSERT INTO `eas_wo_dtl` VALUES (2904, 180, 'gJYAABvP8U7tSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 398, 398, 0, 0, 0, NULL, 398);
INSERT INTO `eas_wo_dtl` VALUES (2905, 180, 'gJYAABvP8VDtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 30084, 30084, 0, 30084, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2906, 180, 'gJYAABvP8UztSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 22423, 22423, 0, 22423, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2907, 181, 'gJYAABvP8VvtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 5211, 5211, 0, 5211, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2908, 181, 'gJYAABvP8WPtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 730, 730, 0, 0, 0, 2, 730);
INSERT INTO `eas_wo_dtl` VALUES (2909, 181, 'gJYAABvP8V3tSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 141, 141, 0, 0, 0, 2, 141);
INSERT INTO `eas_wo_dtl` VALUES (2910, 181, 'gJYAABvP8WDtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8829, 8829, 0, 0, 0, NULL, 8829);
INSERT INTO `eas_wo_dtl` VALUES (2911, 181, 'gJYAABvP8VztSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 23, 23, 0, 0, 0, NULL, 23);
INSERT INTO `eas_wo_dtl` VALUES (2912, 181, 'gJYAABvP8WftSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 32, 32, 0, 0, 0, NULL, 32);
INSERT INTO `eas_wo_dtl` VALUES (2913, 181, 'gJYAABvP8WrtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 886, 886, 0, 451, 0, 1, 435);
INSERT INTO `eas_wo_dtl` VALUES (2914, 181, 'gJYAABvP8WntSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 8859, 8859, 0, 8859, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2915, 181, 'gJYAABvP8WjtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 68, 68, 0, 68, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2916, 181, 'gJYAABvP8V7tSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 18131, 18131, 0, 0, 0, NULL, 18131);
INSERT INTO `eas_wo_dtl` VALUES (2917, 181, 'gJYAABvP8WvtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (2918, 181, 'gJYAABvP8WXtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 14, 14, 0, 0, 0, NULL, 14);
INSERT INTO `eas_wo_dtl` VALUES (2919, 181, 'gJYAABvP8WHtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 90, 90, 0, 0, 0, NULL, 90);
INSERT INTO `eas_wo_dtl` VALUES (2920, 181, 'gJYAABvP8WTtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 240, 240, 0, 0, 0, NULL, 240);
INSERT INTO `eas_wo_dtl` VALUES (2921, 181, 'gJYAABvP8WLtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 4505, 4505, 0, 4505, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2922, 181, 'gJYAABvP8WbtSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 90, 90, 0, 0, 0, NULL, 90);
INSERT INTO `eas_wo_dtl` VALUES (2923, 181, 'gJYAABvP8WztSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 240, 240, 0, 0, 0, NULL, 240);
INSERT INTO `eas_wo_dtl` VALUES (2924, 181, 'gJYAABvP8V/tSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 18131, 18131, 0, 3044, 0, NULL, 15087);
INSERT INTO `eas_wo_dtl` VALUES (2925, 181, 'gJYAABvP8W3tSYg5', '9LXg/PIDQYesVfBL2c/Qch0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 4505, 4505, 0, 4505, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2926, 182, 'gJYAABvP8XXtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 5943, 5943, 0, 2063, 0, 2, 3880);
INSERT INTO `eas_wo_dtl` VALUES (2927, 182, 'gJYAABvP8XftSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 128, 128, 0, 0, 0, 2, 128);
INSERT INTO `eas_wo_dtl` VALUES (2928, 182, 'gJYAABvP8XPtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 596, 596, 0, 111, 0, 2, 485);
INSERT INTO `eas_wo_dtl` VALUES (2929, 182, 'gJYAABvP8XbtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10340, 10340, 0, 0, 0, NULL, 10340);
INSERT INTO `eas_wo_dtl` VALUES (2930, 182, 'gJYAABvP8XntSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 26, 26, 0, 0, 0, NULL, 26);
INSERT INTO `eas_wo_dtl` VALUES (2931, 182, 'gJYAABvP8YLtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 38, 38, 0, 0, 0, NULL, 38);
INSERT INTO `eas_wo_dtl` VALUES (2932, 182, 'gJYAABvP8X/tSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1849, 1849, 0, 0, 0, 1, 1849);
INSERT INTO `eas_wo_dtl` VALUES (2933, 182, 'gJYAABvP8XLtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 18488, 18488, 0, 4, 0, 1, 18485);
INSERT INTO `eas_wo_dtl` VALUES (2934, 182, 'gJYAABvP8XHtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 121, 121, 0, 15, 0, 5, 107);
INSERT INTO `eas_wo_dtl` VALUES (2935, 182, 'gJYAABvP8XDtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 21234, 21234, 0, 0, 0, NULL, 21234);
INSERT INTO `eas_wo_dtl` VALUES (2936, 182, 'gJYAABvP8X3tSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (2937, 182, 'gJYAABvP8YDtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 16, 16, 0, 0, 0, NULL, 16);
INSERT INTO `eas_wo_dtl` VALUES (2938, 182, 'gJYAABvP8XjtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 106, 106, 0, 0, 0, NULL, 106);
INSERT INTO `eas_wo_dtl` VALUES (2939, 182, 'gJYAABvP8X7tSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 281, 281, 0, 0, 0, NULL, 281);
INSERT INTO `eas_wo_dtl` VALUES (2940, 182, 'gJYAABvP8XrtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5276, 5276, 0, 5276, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2941, 182, 'gJYAABvP8XTtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 106, 106, 0, 0, 0, NULL, 106);
INSERT INTO `eas_wo_dtl` VALUES (2942, 182, 'gJYAABvP8YHtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 281, 281, 0, 0, 0, NULL, 281);
INSERT INTO `eas_wo_dtl` VALUES (2943, 182, 'gJYAABvP8XztSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 21234, 21234, 0, 0, 0, NULL, 21234);
INSERT INTO `eas_wo_dtl` VALUES (2944, 182, 'gJYAABvP8XvtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 5276, 5276, 0, 5276, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2945, 183, 'gJYAABvQ2+ztSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 8, 8, 0, 0, 0, 2, 8);
INSERT INTO `eas_wo_dtl` VALUES (2946, 183, 'gJYAABvQ2+7tSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 12, 12, 0, 0, 0, 2, 12);
INSERT INTO `eas_wo_dtl` VALUES (2947, 183, 'gJYAABvQ2/TtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 228, 228, 0, 0, 0, 2, 228);
INSERT INTO `eas_wo_dtl` VALUES (2948, 183, 'gJYAABvQ2+LtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1358, 1358, 0, 0, 0, NULL, 1358);
INSERT INTO `eas_wo_dtl` VALUES (2949, 183, 'gJYAABvQ2+ftSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (2950, 183, 'gJYAABvQ2/LtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (2951, 183, 'gJYAABvQ2+jtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 61, 61, 0, 0, 0, 1, 61);
INSERT INTO `eas_wo_dtl` VALUES (2952, 183, 'gJYAABvQ2+ntSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 609, 609, 0, 0, 0, 1, 609);
INSERT INTO `eas_wo_dtl` VALUES (2953, 183, 'gJYAABvQ2+XtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 4, 4, 0, 0, 0, 5, 4);
INSERT INTO `eas_wo_dtl` VALUES (2954, 183, 'gJYAABvQ2/PtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1209, 1209, 0, 0, 0, NULL, 1209);
INSERT INTO `eas_wo_dtl` VALUES (2955, 183, 'gJYAABvQ2+TtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2956, 183, 'gJYAABvQ2+rtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2957, 183, 'gJYAABvQ2+btSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (2958, 183, 'gJYAABvQ2+/tSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 16, 16, 0, 0, 0, NULL, 16);
INSERT INTO `eas_wo_dtl` VALUES (2959, 183, 'gJYAABvQ2+vtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 300, 300, 0, 311, 0, 3, -11);
INSERT INTO `eas_wo_dtl` VALUES (2960, 183, 'gJYAABvQ2/HtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (2961, 183, 'gJYAABvQ2+3tSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 16, 16, 0, 0, 0, NULL, 16);
INSERT INTO `eas_wo_dtl` VALUES (2962, 183, 'gJYAABvQ2+PtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1209, 1209, 0, 0, 0, NULL, 1209);
INSERT INTO `eas_wo_dtl` VALUES (2963, 183, 'gJYAABvQ2/DtSYg5', '3ipwVSJRRAaS5KHUiTqbmR0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 901, 901, 0, 0, 0, 0, 901);
INSERT INTO `eas_wo_dtl` VALUES (2964, 184, 'gJYAABvSYWLtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 100000, 100000, 0, 100000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2965, 184, 'gJYAABvSYVztSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 44510, 44510, 0, 42240, 0, 2, 2270);
INSERT INTO `eas_wo_dtl` VALUES (2966, 184, 'gJYAABvSYVvtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 7520, 7520, 0, 7520, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2967, 184, 'gJYAABvSYV/tSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 150100, 150100, 0, 150100, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2968, 184, 'gJYAABvSYWPtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 250, 250, 0, 250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2969, 184, 'gJYAABvSYV7tSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 13046, 13046, 0, 13046, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2970, 184, 'gJYAABvSYWHtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 130460, 130460, 0, 130460, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2971, 184, 'gJYAABvSYVntSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 770, 770, 0, 0, 0, 5, 770);
INSERT INTO `eas_wo_dtl` VALUES (2972, 184, 'gJYAABvSYVrtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 120, 120, 0, 0, 0, NULL, 120);
INSERT INTO `eas_wo_dtl` VALUES (2973, 184, 'gJYAABvSYWftSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 300, 300, 0, 300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2974, 184, 'gJYAABvSYWXtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 100000, 100000, 0, 100000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2975, 184, 'gJYAABvSYWTtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3460, 3460, 0, 2327, 0, NULL, 1133);
INSERT INTO `eas_wo_dtl` VALUES (2976, 184, 'gJYAABvSYWbtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 402500, 402500, 0, 223875, 0, NULL, 178625);
INSERT INTO `eas_wo_dtl` VALUES (2977, 184, 'gJYAABvSYWDtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 402500, 402500, 0, 282848, 0, NULL, 119653);
INSERT INTO `eas_wo_dtl` VALUES (2978, 184, 'gJYAABvSYV3tSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 1160, 1160, 0, 92, 0, NULL, 1068);
INSERT INTO `eas_wo_dtl` VALUES (2979, 185, 'gJYAABvSYx3tSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 115, 115, 0, 0, 0, 2, 115);
INSERT INTO `eas_wo_dtl` VALUES (2980, 185, 'gJYAABvSYx/tSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 2, 2, 0, 0, 0, 2, 2);
INSERT INTO `eas_wo_dtl` VALUES (2981, 185, 'gJYAABvSYxvtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 11, 11, 0, 0, 0, 2, 11);
INSERT INTO `eas_wo_dtl` VALUES (2982, 185, 'gJYAABvSYx7tSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 199, 199, 0, 0, 0, NULL, 199);
INSERT INTO `eas_wo_dtl` VALUES (2983, 185, 'gJYAABvSYyHtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2984, 185, 'gJYAABvSYyrtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2985, 185, 'gJYAABvSYyftSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 36, 36, 0, 0, 0, 1, 36);
INSERT INTO `eas_wo_dtl` VALUES (2986, 185, 'gJYAABvSYxrtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 357, 357, 0, 0, 0, 1, 357);
INSERT INTO `eas_wo_dtl` VALUES (2987, 185, 'gJYAABvSYxntSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 0, 0, 5, 2);
INSERT INTO `eas_wo_dtl` VALUES (2988, 185, 'gJYAABvSYxjtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 409, 409, 0, 0, 0, NULL, 409);
INSERT INTO `eas_wo_dtl` VALUES (2989, 185, 'gJYAABvSYyXtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2990, 185, 'gJYAABvSYyjtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2991, 185, 'gJYAABvSYyDtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (2992, 185, 'gJYAABvSYybtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (2993, 185, 'gJYAABvSYyLtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 102, 102, 0, 102, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2994, 185, 'gJYAABvSYxztSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (2995, 185, 'gJYAABvSYyntSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (2996, 185, 'gJYAABvSYyTtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 409, 409, 0, 0, 0, NULL, 409);
INSERT INTO `eas_wo_dtl` VALUES (2997, 185, 'gJYAABvSYyPtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 102, 102, 0, 102, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2998, 186, 'gJYAABvUNy/tSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 6300, 6300, 0, 6300, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2999, 186, 'gJYAABvUNzPtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 3795, 3795, 0, 0, 0, 2, 3795);
INSERT INTO `eas_wo_dtl` VALUES (3000, 186, 'gJYAABvUNyrtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1006, 1006, 0, 0, 0, 2, 1006);
INSERT INTO `eas_wo_dtl` VALUES (3001, 186, 'gJYAABvUNy3tSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 134, 134, 0, 134, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (3002, 186, 'gJYAABvUNzbtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 9492, 9492, 0, 0, 0, NULL, 9492);
INSERT INTO `eas_wo_dtl` VALUES (3003, 186, 'gJYAABvUNzHtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 35, 35, 0, 11, 0, NULL, 24);
INSERT INTO `eas_wo_dtl` VALUES (3004, 186, 'gJYAABvUNyntSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 0, 0, NULL, 22);
INSERT INTO `eas_wo_dtl` VALUES (3005, 186, 'gJYAABvUNzLtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 314, 314, 0, 0, 0, 1, 314);
INSERT INTO `eas_wo_dtl` VALUES (3006, 186, 'gJYAABvUNzTtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3140, 3140, 0, 0, 0, 1, 3140);
INSERT INTO `eas_wo_dtl` VALUES (3007, 186, 'gJYAABvUNzXtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8453, 8453, 0, 0, 0, NULL, 8453);
INSERT INTO `eas_wo_dtl` VALUES (3008, 186, 'gJYAABvUNyvtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 11, 11, 0, 0, 0, NULL, 11);
INSERT INTO `eas_wo_dtl` VALUES (3009, 186, 'gJYAABvUNzftSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 116, 116, 0, 0, 0, NULL, 116);
INSERT INTO `eas_wo_dtl` VALUES (3010, 186, 'gJYAABvUNyztSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2100, 2100, 0, 2100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3011, 186, 'gJYAABvUNzDtSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 116, 116, 0, 0, 0, NULL, 116);
INSERT INTO `eas_wo_dtl` VALUES (3012, 186, 'gJYAABvUNy7tSYg5', 'gLHeRxkdTp++i2otQuT9Ph0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8453, 8453, 0, 0, 0, NULL, 8453);
INSERT INTO `eas_wo_dtl` VALUES (3013, 187, 'gJYAABvU0gDtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 11, 11, 0, 0, 0, 2, 11);
INSERT INTO `eas_wo_dtl` VALUES (3014, 187, 'gJYAABvU0fntSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 319, 319, 0, 0, 0, 2, 319);
INSERT INTO `eas_wo_dtl` VALUES (3015, 187, 'gJYAABvU0fftSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 116, 116, 0, 0, 0, 2, 116);
INSERT INTO `eas_wo_dtl` VALUES (3016, 187, 'gJYAABvU0f7tSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 568, 568, 0, 0, 0, NULL, 568);
INSERT INTO `eas_wo_dtl` VALUES (3017, 187, 'gJYAABvU0fXtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3018, 187, 'gJYAABvU0gHtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (3019, 187, 'gJYAABvU0gLtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 30, 30, 0, 0, 0, 1, 30);
INSERT INTO `eas_wo_dtl` VALUES (3020, 187, 'gJYAABvU0frtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 298, 298, 0, 0, 0, 1, 298);
INSERT INTO `eas_wo_dtl` VALUES (3021, 187, 'gJYAABvU0gftSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 0, 0, 5, 2);
INSERT INTO `eas_wo_dtl` VALUES (3022, 187, 'gJYAABvU0fbtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1166, 1166, 0, 0, 0, NULL, 1166);
INSERT INTO `eas_wo_dtl` VALUES (3023, 187, 'gJYAABvU0f3tSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3024, 187, 'gJYAABvU0fvtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3025, 187, 'gJYAABvU0fztSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (3026, 187, 'gJYAABvU0gbtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 15, 15, 0, 0, 0, NULL, 15);
INSERT INTO `eas_wo_dtl` VALUES (3027, 187, 'gJYAABvU0fjtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 290, 290, 0, 290, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3028, 187, 'gJYAABvU0gPtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (3029, 187, 'gJYAABvU0gXtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 15, 15, 0, 0, 0, NULL, 15);
INSERT INTO `eas_wo_dtl` VALUES (3030, 187, 'gJYAABvU0gTtSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1166, 1166, 0, 0, 0, NULL, 1166);
INSERT INTO `eas_wo_dtl` VALUES (3031, 187, 'gJYAABvU0f/tSYg5', 'ATLIfPyeTJOZuhG0JgUuHR0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 290, 290, 0, 290, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3032, 188, 'gJYAABvU0hTtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 154, 154, 0, 0, 0, 2, 154);
INSERT INTO `eas_wo_dtl` VALUES (3033, 188, 'gJYAABvU0hDtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 17, 17, 0, 0, 0, 2, 17);
INSERT INTO `eas_wo_dtl` VALUES (3034, 188, 'gJYAABvU0gvtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABhfXltECefw', '01.02.01.001.1272', '荧光粉', 'KSL220', '克', 28, 28, 0, 0, 0, 2, 28);
INSERT INTO `eas_wo_dtl` VALUES (3035, 188, 'gJYAABvU0hrtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 261, 261, 0, 0, 0, NULL, 261);
INSERT INTO `eas_wo_dtl` VALUES (3036, 188, 'gJYAABvU0grtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3037, 188, 'gJYAABvU0g3tSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3038, 188, 'gJYAABvU0hjtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 14, 14, 0, 0, 0, 1, 14);
INSERT INTO `eas_wo_dtl` VALUES (3039, 188, 'gJYAABvU0hPtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 137, 137, 0, 0, 0, 1, 137);
INSERT INTO `eas_wo_dtl` VALUES (3040, 188, 'gJYAABvU0hXtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 0, 0, 5, 1);
INSERT INTO `eas_wo_dtl` VALUES (3041, 188, 'gJYAABvU0gztSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 537, 537, 0, 0, 0, NULL, 537);
INSERT INTO `eas_wo_dtl` VALUES (3042, 188, 'gJYAABvU0g/tSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3043, 188, 'gJYAABvU0g7tSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3044, 188, 'gJYAABvU0hztSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (3045, 188, 'gJYAABvU0hntSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (3046, 188, 'gJYAABvU0hvtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 133, 133, 0, 133, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3047, 188, 'gJYAABvU0hHtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (3048, 188, 'gJYAABvU0hLtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (3049, 188, 'gJYAABvU0hbtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 537, 537, 0, 0, 0, NULL, 537);
INSERT INTO `eas_wo_dtl` VALUES (3050, 188, 'gJYAABvU0hftSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 133, 133, 0, 133, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3051, 189, 'gJYAABvU0kHtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 190, 190, 0, 0, 0, 2, 190);
INSERT INTO `eas_wo_dtl` VALUES (3052, 189, 'gJYAABvU0jbtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 21, 21, 0, 0, 0, 2, 21);
INSERT INTO `eas_wo_dtl` VALUES (3053, 189, 'gJYAABvU0kTtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABhfXltECefw', '01.02.01.001.1272', '荧光粉', 'KSL220', '克', 34, 34, 0, 0, 0, 2, 34);
INSERT INTO `eas_wo_dtl` VALUES (3054, 189, 'gJYAABvU0kLtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 322, 322, 0, 0, 0, NULL, 322);
INSERT INTO `eas_wo_dtl` VALUES (3055, 189, 'gJYAABvU0j7tSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3056, 189, 'gJYAABvU0j/tSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3057, 189, 'gJYAABvU0jvtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 17, 17, 0, 0, 0, 1, 17);
INSERT INTO `eas_wo_dtl` VALUES (3058, 189, 'gJYAABvU0kXtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 169, 169, 0, 0, 0, 1, 169);
INSERT INTO `eas_wo_dtl` VALUES (3059, 189, 'gJYAABvU0kbtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 0, 0, 5, 1);
INSERT INTO `eas_wo_dtl` VALUES (3060, 189, 'gJYAABvU0jrtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 662, 662, 0, 0, 0, NULL, 662);
INSERT INTO `eas_wo_dtl` VALUES (3061, 189, 'gJYAABvU0jftSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3062, 189, 'gJYAABvU0kDtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3063, 189, 'gJYAABvU0jztSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (3064, 189, 'gJYAABvU0jjtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 9, 9, 0, 0, 0, NULL, 9);
INSERT INTO `eas_wo_dtl` VALUES (3065, 189, 'gJYAABvU0kPtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 164, 164, 0, 164, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3066, 189, 'gJYAABvU0kjtSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (3067, 189, 'gJYAABvU0j3tSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 9, 9, 0, 0, 0, NULL, 9);
INSERT INTO `eas_wo_dtl` VALUES (3068, 189, 'gJYAABvU0jntSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 662, 662, 0, 0, 0, NULL, 662);
INSERT INTO `eas_wo_dtl` VALUES (3069, 189, 'gJYAABvU0kftSYg5', 'n386PwxFTby3ISob6LrjrB0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 164, 164, 0, 164, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3070, 190, 'gJYAABvU0mXtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 5675, 5675, 0, 0, 0, 2, 5675);
INSERT INTO `eas_wo_dtl` VALUES (3071, 190, 'gJYAABvU0mPtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 345, 345, 0, 0, 0, 2, 345);
INSERT INTO `eas_wo_dtl` VALUES (3072, 190, 'gJYAABvU0m/tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 125, 125, 0, 0, 0, 2, 125);
INSERT INTO `eas_wo_dtl` VALUES (3073, 190, 'gJYAABvU0mTtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 299, 299, 0, 0, 0, 2, 299);
INSERT INTO `eas_wo_dtl` VALUES (3074, 190, 'gJYAABvU0l/tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10993, 10993, 0, 0, 0, NULL, 10993);
INSERT INTO `eas_wo_dtl` VALUES (3075, 190, 'gJYAABvU0mDtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 53, 53, 0, 0, 0, NULL, 53);
INSERT INTO `eas_wo_dtl` VALUES (3076, 190, 'gJYAABvU0m7tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 48, 48, 0, 0, 0, NULL, 48);
INSERT INTO `eas_wo_dtl` VALUES (3077, 190, 'gJYAABvU0nHtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 567, 567, 0, 0, 0, 1, 567);
INSERT INTO `eas_wo_dtl` VALUES (3078, 190, 'gJYAABvU0mbtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5666, 5666, 0, 0, 0, 1, 5666);
INSERT INTO `eas_wo_dtl` VALUES (3079, 190, 'gJYAABvU0mztSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 66, 66, 0, 0, 0, 5, 66);
INSERT INTO `eas_wo_dtl` VALUES (3080, 190, 'gJYAABvU0mHtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10611, 10611, 0, 0, 0, NULL, 10611);
INSERT INTO `eas_wo_dtl` VALUES (3081, 190, 'gJYAABvU0mftSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3082, 190, 'gJYAABvU0mLtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (3083, 190, 'gJYAABvU0mrtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 53, 53, 0, 0, 0, NULL, 53);
INSERT INTO `eas_wo_dtl` VALUES (3084, 190, 'gJYAABvU0mjtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 140, 140, 0, 0, 0, NULL, 140);
INSERT INTO `eas_wo_dtl` VALUES (3085, 190, 'gJYAABvU0mntSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2636, 2636, 0, 2636, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3086, 190, 'gJYAABvU0nDtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 53, 53, 0, 0, 0, NULL, 53);
INSERT INTO `eas_wo_dtl` VALUES (3087, 190, 'gJYAABvU0l7tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 140, 140, 0, 0, 0, NULL, 140);
INSERT INTO `eas_wo_dtl` VALUES (3088, 190, 'gJYAABvU0mvtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10611, 10611, 0, 0, 0, NULL, 10611);
INSERT INTO `eas_wo_dtl` VALUES (3089, 190, 'gJYAABvU0m3tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 7909, 7909, 0, 7909, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3090, 191, 'gJYAABvU0oXtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 61, 61, 0, 0, 0, 2, 61);
INSERT INTO `eas_wo_dtl` VALUES (3091, 191, 'gJYAABvU0oLtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 231, 231, 0, 0, 0, 2, 231);
INSERT INTO `eas_wo_dtl` VALUES (3092, 191, 'gJYAABvU0njtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1632, 1632, 0, 0, 0, 2, 1632);
INSERT INTO `eas_wo_dtl` VALUES (3093, 191, 'gJYAABvU0n/tSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 3343, 3343, 0, 0, 0, NULL, 3343);
INSERT INTO `eas_wo_dtl` VALUES (3094, 191, 'gJYAABvU0oDtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 9, 9, 0, 0, 0, NULL, 9);
INSERT INTO `eas_wo_dtl` VALUES (3095, 191, 'gJYAABvU0nbtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (3096, 191, 'gJYAABvU0oPtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 346, 346, 0, 0, 0, 1, 346);
INSERT INTO `eas_wo_dtl` VALUES (3097, 191, 'gJYAABvU0oHtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3458, 3458, 0, 0, 0, 1, 3458);
INSERT INTO `eas_wo_dtl` VALUES (3098, 191, 'gJYAABvU0nXtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 25, 25, 0, 0, 0, 5, 25);
INSERT INTO `eas_wo_dtl` VALUES (3099, 191, 'gJYAABvU0nvtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6865, 6865, 0, 0, 0, NULL, 6865);
INSERT INTO `eas_wo_dtl` VALUES (3100, 191, 'gJYAABvU0nftSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (3101, 191, 'gJYAABvU0oTtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (3102, 191, 'gJYAABvU0obtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 34, 34, 0, 0, 0, NULL, 34);
INSERT INTO `eas_wo_dtl` VALUES (3103, 191, 'gJYAABvU0nztSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 91, 91, 0, 0, 0, NULL, 91);
INSERT INTO `eas_wo_dtl` VALUES (3104, 191, 'gJYAABvU0nntSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1706, 1706, 0, 1706, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3105, 191, 'gJYAABvU0nTtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 34, 34, 0, 0, 0, NULL, 34);
INSERT INTO `eas_wo_dtl` VALUES (3106, 191, 'gJYAABvU0nrtSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 91, 91, 0, 0, 0, NULL, 91);
INSERT INTO `eas_wo_dtl` VALUES (3107, 191, 'gJYAABvU0n3tSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6865, 6865, 0, 0, 0, NULL, 6865);
INSERT INTO `eas_wo_dtl` VALUES (3108, 191, 'gJYAABvU0n7tSYg5', 'FzFWIwVgS9WfvPvi8nXYJh0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 1706, 1706, 0, 1706, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3109, 192, 'gJYAABvU0q3tSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2988, 2988, 0, 0, 0, 2, 2988);
INSERT INTO `eas_wo_dtl` VALUES (3110, 192, 'gJYAABvU0rXtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 492, 492, 0, 0, 0, 2, 492);
INSERT INTO `eas_wo_dtl` VALUES (3111, 192, 'gJYAABvU0qvtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7330, 7330, 0, 0, 0, NULL, 7330);
INSERT INTO `eas_wo_dtl` VALUES (3112, 192, 'gJYAABvU0qztSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 35, 35, 0, 0, 0, NULL, 35);
INSERT INTO `eas_wo_dtl` VALUES (3113, 192, 'gJYAABvU0rTtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 32, 32, 0, 0, 0, NULL, 32);
INSERT INTO `eas_wo_dtl` VALUES (3114, 192, 'gJYAABvU0qntSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 360, 360, 0, 0, 0, 1, 360);
INSERT INTO `eas_wo_dtl` VALUES (3115, 192, 'gJYAABvU0rLtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3602, 3602, 0, 0, 0, 1, 3602);
INSERT INTO `eas_wo_dtl` VALUES (3116, 192, 'gJYAABvU0qXtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 21, 21, 0, 0, 0, 5, 21);
INSERT INTO `eas_wo_dtl` VALUES (3117, 192, 'gJYAABvU0rDtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7075, 7075, 0, 0, 0, NULL, 7075);
INSERT INTO `eas_wo_dtl` VALUES (3118, 192, 'gJYAABvU0qrtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (3119, 192, 'gJYAABvU0rHtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (3120, 192, 'gJYAABvU0qftSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 35, 35, 0, 0, 0, NULL, 35);
INSERT INTO `eas_wo_dtl` VALUES (3121, 192, 'gJYAABvU0qbtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 94, 94, 0, 0, 0, NULL, 94);
INSERT INTO `eas_wo_dtl` VALUES (3122, 192, 'gJYAABvU0rbtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1758, 1758, 0, 1758, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3123, 192, 'gJYAABvU0q7tSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 35, 35, 0, 0, 0, NULL, 35);
INSERT INTO `eas_wo_dtl` VALUES (3124, 192, 'gJYAABvU0rPtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 94, 94, 0, 0, 0, NULL, 94);
INSERT INTO `eas_wo_dtl` VALUES (3125, 192, 'gJYAABvU0q/tSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7075, 7075, 0, 0, 0, NULL, 7075);
INSERT INTO `eas_wo_dtl` VALUES (3126, 192, 'gJYAABvU0qjtSYg5', '3Z6hzb3hQvavt6oeRszgnB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 5273, 5273, 0, 5273, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3127, 193, 'gJYAABvWE17tSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 3150, 3150, 0, 3150, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3128, 193, 'gJYAABvWE1rtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1263, 1263, 0, 0, 0, 2, 1263);
INSERT INTO `eas_wo_dtl` VALUES (3129, 193, 'gJYAABvWE1jtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 443, 443, 0, 0, 0, 2, 443);
INSERT INTO `eas_wo_dtl` VALUES (3130, 193, 'gJYAABvWE1TtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 41, 41, 0, 0, 0, 2, 41);
INSERT INTO `eas_wo_dtl` VALUES (3131, 193, 'gJYAABvWE1ntSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 4746, 4746, 0, 0, 0, NULL, 4746);
INSERT INTO `eas_wo_dtl` VALUES (3132, 193, 'gJYAABvWE1HtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 18, 18, 0, 0, 0, NULL, 18);
INSERT INTO `eas_wo_dtl` VALUES (3133, 193, 'gJYAABvWE1XtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 0, 0, NULL, 11);
INSERT INTO `eas_wo_dtl` VALUES (3134, 193, 'gJYAABvWE1vtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 211, 211, 0, 0, 0, 1, 211);
INSERT INTO `eas_wo_dtl` VALUES (3135, 193, 'gJYAABvWE1ftSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2114, 2114, 0, 0, 0, 1, 2114);
INSERT INTO `eas_wo_dtl` VALUES (3136, 193, 'gJYAABvWE1DtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 9, 9, 0, 0, 0, 5, 9);
INSERT INTO `eas_wo_dtl` VALUES (3137, 193, 'gJYAABvWE13tSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4226, 4226, 0, 0, 0, NULL, 4226);
INSERT INTO `eas_wo_dtl` VALUES (3138, 193, 'gJYAABvWE1LtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (3139, 193, 'gJYAABvWE1btSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 58, 58, 0, 0, 0, NULL, 58);
INSERT INTO `eas_wo_dtl` VALUES (3140, 193, 'gJYAABvWE1PtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1050, 1050, 0, 1050, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3141, 193, 'gJYAABvWE0/tSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 58, 58, 0, 0, 0, NULL, 58);
INSERT INTO `eas_wo_dtl` VALUES (3142, 193, 'gJYAABvWE1ztSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4226, 4226, 0, 0, 0, NULL, 4226);
INSERT INTO `eas_wo_dtl` VALUES (3143, 194, 'gJYAABvWE7ntSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 860, 860, 0, 0, 0, 2, 860);
INSERT INTO `eas_wo_dtl` VALUES (3144, 194, 'gJYAABvWE7LtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 286, 286, 0, 0, 0, 2, 286);
INSERT INTO `eas_wo_dtl` VALUES (3145, 194, 'gJYAABvWE7vtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4578, 4578, 0, 0, 0, 2, 4578);
INSERT INTO `eas_wo_dtl` VALUES (3146, 194, 'gJYAABvWE7DtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 11888, 11888, 0, 0, 0, NULL, 11888);
INSERT INTO `eas_wo_dtl` VALUES (3147, 194, 'gJYAABvWE7rtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (3148, 194, 'gJYAABvWE7ftSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (3149, 194, 'gJYAABvWE7btSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1261, 1261, 0, 0, 0, 1, 1261);
INSERT INTO `eas_wo_dtl` VALUES (3150, 194, 'gJYAABvWE7PtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 12606, 12606, 0, 0, 0, 1, 12606);
INSERT INTO `eas_wo_dtl` VALUES (3151, 194, 'gJYAABvWE7HtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 93, 93, 0, 0, 0, 5, 93);
INSERT INTO `eas_wo_dtl` VALUES (3152, 194, 'gJYAABvWE7XtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 24165, 24165, 0, 0, 0, NULL, 24165);
INSERT INTO `eas_wo_dtl` VALUES (3153, 194, 'gJYAABvWE7TtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 9, 9, 0, 0, 0, NULL, 9);
INSERT INTO `eas_wo_dtl` VALUES (3154, 194, 'gJYAABvWE6/tSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 18, 18, 0, 0, 0, NULL, 18);
INSERT INTO `eas_wo_dtl` VALUES (3155, 194, 'gJYAABvWE67tSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 120, 120, 0, 0, 0, NULL, 120);
INSERT INTO `eas_wo_dtl` VALUES (3156, 194, 'gJYAABvWE7ztSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 319, 319, 0, 0, 0, NULL, 319);
INSERT INTO `eas_wo_dtl` VALUES (3157, 194, 'gJYAABvWE77tSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 6004, 6004, 0, 6004, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3158, 194, 'gJYAABvWE7jtSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 120, 120, 0, 0, 0, NULL, 120);
INSERT INTO `eas_wo_dtl` VALUES (3159, 194, 'gJYAABvWE73tSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 319, 319, 0, 0, 0, NULL, 319);
INSERT INTO `eas_wo_dtl` VALUES (3160, 194, 'gJYAABvWE63tSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 24165, 24165, 0, 0, 0, NULL, 24165);
INSERT INTO `eas_wo_dtl` VALUES (3161, 194, 'gJYAABvWE6ztSYg5', 'DwL12JPaSRGi15NSRA9jjB0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 6004, 6004, 0, 6004, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3162, 195, 'gJYAABvWE87tSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 597, 597, 0, 0, 0, 2, 597);
INSERT INTO `eas_wo_dtl` VALUES (3163, 195, 'gJYAABvWE8ntSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 199, 199, 0, 0, 0, 2, 199);
INSERT INTO `eas_wo_dtl` VALUES (3164, 195, 'gJYAABvWE8/tSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3181, 3181, 0, 0, 0, 2, 3181);
INSERT INTO `eas_wo_dtl` VALUES (3165, 195, 'gJYAABvWE8btSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8259, 8259, 0, 0, 0, NULL, 8259);
INSERT INTO `eas_wo_dtl` VALUES (3166, 195, 'gJYAABvWE8LtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (3167, 195, 'gJYAABvWE9DtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 15, 15, 0, 0, 0, NULL, 15);
INSERT INTO `eas_wo_dtl` VALUES (3168, 195, 'gJYAABvWE8PtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 876, 876, 0, 0, 0, 1, 876);
INSERT INTO `eas_wo_dtl` VALUES (3169, 195, 'gJYAABvWE8TtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 8758, 8758, 0, 0, 0, 1, 8758);
INSERT INTO `eas_wo_dtl` VALUES (3170, 195, 'gJYAABvWE8HtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 65, 65, 0, 0, 0, 5, 65);
INSERT INTO `eas_wo_dtl` VALUES (3171, 195, 'gJYAABvWE8XtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 16789, 16789, 0, 0, 0, NULL, 16789);
INSERT INTO `eas_wo_dtl` VALUES (3172, 195, 'gJYAABvWE83tSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (3173, 195, 'gJYAABvWE8rtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 13, 13, 0, 0, 0, NULL, 13);
INSERT INTO `eas_wo_dtl` VALUES (3174, 195, 'gJYAABvWE9HtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 83, 83, 0, 0, 0, NULL, 83);
INSERT INTO `eas_wo_dtl` VALUES (3175, 195, 'gJYAABvWE8ftSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 222, 222, 0, 0, 0, NULL, 222);
INSERT INTO `eas_wo_dtl` VALUES (3176, 195, 'gJYAABvWE8vtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 4171, 4171, 0, 4105, 0, 3, 66);
INSERT INTO `eas_wo_dtl` VALUES (3177, 195, 'gJYAABvWE8ztSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 83, 83, 0, 0, 0, NULL, 83);
INSERT INTO `eas_wo_dtl` VALUES (3178, 195, 'gJYAABvWE9PtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 222, 222, 0, 0, 0, NULL, 222);
INSERT INTO `eas_wo_dtl` VALUES (3179, 195, 'gJYAABvWE9LtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 16789, 16789, 0, 0, 0, NULL, 16789);
INSERT INTO `eas_wo_dtl` VALUES (3180, 195, 'gJYAABvWE8jtSYg5', 'YT3wnQVyQkSC5H3w0UsYjx0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 4171, 4171, 0, 4171, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3181, 196, 'gJYAABvXXhHtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 154, 154, 0, 0, 0, 2, 154);
INSERT INTO `eas_wo_dtl` VALUES (3182, 196, 'gJYAABvXXiHtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 6623, 6623, 0, 0, 0, 2, 6623);
INSERT INTO `eas_wo_dtl` VALUES (3183, 196, 'gJYAABvXXhTtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 335, 335, 0, 0, 0, 2, 335);
INSERT INTO `eas_wo_dtl` VALUES (3184, 196, 'gJYAABvXXh3tSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 14063, 14063, 0, 0, 0, NULL, 14063);
INSERT INTO `eas_wo_dtl` VALUES (3185, 196, 'gJYAABvXXh/tSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 36, 36, 0, 0, 0, NULL, 36);
INSERT INTO `eas_wo_dtl` VALUES (3186, 196, 'gJYAABvXXhftSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 51, 51, 0, 0, 0, NULL, 51);
INSERT INTO `eas_wo_dtl` VALUES (3187, 196, 'gJYAABvXXh7tSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1491, 1491, 0, 0, 0, 1, 1491);
INSERT INTO `eas_wo_dtl` VALUES (3188, 196, 'gJYAABvXXhvtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 14912, 14912, 0, 0, 0, 1, 14912);
INSERT INTO `eas_wo_dtl` VALUES (3189, 196, 'gJYAABvXXhztSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 119, 119, 0, 0, 0, 5, 119);
INSERT INTO `eas_wo_dtl` VALUES (3190, 196, 'gJYAABvXXiLtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 28588, 28588, 0, 0, 0, NULL, 28588);
INSERT INTO `eas_wo_dtl` VALUES (3191, 196, 'gJYAABvXXhjtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 11, 11, 0, 0, 0, NULL, 11);
INSERT INTO `eas_wo_dtl` VALUES (3192, 196, 'gJYAABvXXhXtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (3193, 196, 'gJYAABvXXiDtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 142, 142, 0, 0, 0, NULL, 142);
INSERT INTO `eas_wo_dtl` VALUES (3194, 196, 'gJYAABvXXhbtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 378, 378, 0, 0, 0, NULL, 378);
INSERT INTO `eas_wo_dtl` VALUES (3195, 196, 'gJYAABvXXhntSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 7103, 7103, 0, 0, 0, 3, 7103);
INSERT INTO `eas_wo_dtl` VALUES (3196, 196, 'gJYAABvXXhDtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 142, 142, 0, 0, 0, NULL, 142);
INSERT INTO `eas_wo_dtl` VALUES (3197, 196, 'gJYAABvXXhLtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 378, 378, 0, 0, 0, NULL, 378);
INSERT INTO `eas_wo_dtl` VALUES (3198, 196, 'gJYAABvXXhPtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 28588, 28588, 0, 0, 0, NULL, 28588);
INSERT INTO `eas_wo_dtl` VALUES (3199, 196, 'gJYAABvXXhrtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 7103, 7103, 0, 183, 0, 0, 6919);
INSERT INTO `eas_wo_dtl` VALUES (3200, 197, 'gJYAABvXXjLtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 15, 15, 0, 0, 0, 2, 15);
INSERT INTO `eas_wo_dtl` VALUES (3201, 197, 'gJYAABvXXj7tSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 574, 574, 0, 0, 0, 2, 574);
INSERT INTO `eas_wo_dtl` VALUES (3202, 197, 'gJYAABvXXjPtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 24, 24, 0, 0, 0, 2, 24);
INSERT INTO `eas_wo_dtl` VALUES (3203, 197, 'gJYAABvXXj3tSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1392, 1392, 0, 0, 0, NULL, 1392);
INSERT INTO `eas_wo_dtl` VALUES (3204, 197, 'gJYAABvXXjbtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3205, 197, 'gJYAABvXXkDtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (3206, 197, 'gJYAABvXXjjtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 148, 148, 0, 0, 0, 1, 148);
INSERT INTO `eas_wo_dtl` VALUES (3207, 197, 'gJYAABvXXjXtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 1476, 1476, 0, 0, 0, 1, 1476);
INSERT INTO `eas_wo_dtl` VALUES (3208, 197, 'gJYAABvXXjftSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 11, 11, 0, 0, 0, 5, 11);
INSERT INTO `eas_wo_dtl` VALUES (3209, 197, 'gJYAABvXXjHtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 2829, 2829, 0, 0, 0, NULL, 2829);
INSERT INTO `eas_wo_dtl` VALUES (3210, 197, 'gJYAABvXXj/tSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3211, 197, 'gJYAABvXXjntSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (3212, 197, 'gJYAABvXXjDtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 14, 14, 0, 0, 0, NULL, 14);
INSERT INTO `eas_wo_dtl` VALUES (3213, 197, 'gJYAABvXXjvtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 37, 37, 0, 0, 0, NULL, 37);
INSERT INTO `eas_wo_dtl` VALUES (3214, 197, 'gJYAABvXXkLtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 703, 703, 0, 0, 0, 3, 703);
INSERT INTO `eas_wo_dtl` VALUES (3215, 197, 'gJYAABvXXjTtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 14, 14, 0, 0, 0, NULL, 14);
INSERT INTO `eas_wo_dtl` VALUES (3216, 197, 'gJYAABvXXjrtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 37, 37, 0, 0, 0, NULL, 37);
INSERT INTO `eas_wo_dtl` VALUES (3217, 197, 'gJYAABvXXkHtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2829, 2829, 0, 0, 0, NULL, 2829);
INSERT INTO `eas_wo_dtl` VALUES (3218, 197, 'gJYAABvXXjztSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 703, 703, 0, 703, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3219, 198, 'gJYAABvXXkjtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 15, 15, 0, 0, 0, 2, 15);
INSERT INTO `eas_wo_dtl` VALUES (3220, 198, 'gJYAABvXXlHtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 3, 3, 0, 0, 0, 2, 3);
INSERT INTO `eas_wo_dtl` VALUES (3221, 198, 'gJYAABvXXkntSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 0, 0, 0, 0, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (3222, 198, 'gJYAABvXXlLtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 49, 49, 0, 0, 0, NULL, 49);
INSERT INTO `eas_wo_dtl` VALUES (3223, 198, 'gJYAABvXXlDtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3224, 198, 'gJYAABvXXlbtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3225, 198, 'gJYAABvXXlTtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3, 3, 0, 0, 0, 1, 3);
INSERT INTO `eas_wo_dtl` VALUES (3226, 198, 'gJYAABvXXkztSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 31, 31, 0, 0, 0, 1, 31);
INSERT INTO `eas_wo_dtl` VALUES (3227, 198, 'gJYAABvXXkvtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (3228, 198, 'gJYAABvXXkftSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 43, 43, 0, 0, 0, NULL, 43);
INSERT INTO `eas_wo_dtl` VALUES (3229, 198, 'gJYAABvXXljtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3230, 198, 'gJYAABvXXlftSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3231, 198, 'gJYAABvXXlPtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3232, 198, 'gJYAABvXXkbtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3233, 198, 'gJYAABvXXlXtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 11, 11, 0, 11, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3234, 198, 'gJYAABvXXk3tSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3235, 198, 'gJYAABvXXk7tSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (3236, 198, 'gJYAABvXXkrtSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 43, 43, 0, 0, 0, NULL, 43);
INSERT INTO `eas_wo_dtl` VALUES (3237, 198, 'gJYAABvXXk/tSYg5', 'brUewIAjSIagwx3Iqi3sOx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 32, 32, 0, 0, 0, 0, 32);
INSERT INTO `eas_wo_dtl` VALUES (3238, 199, 'gJYAABvXXmztSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 1210, 1210, 0, 0, 0, 2, 1210);
INSERT INTO `eas_wo_dtl` VALUES (3239, 199, 'gJYAABvXXmbtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 42, 42, 0, 0, 0, 2, 42);
INSERT INTO `eas_wo_dtl` VALUES (3240, 199, 'gJYAABvXXmftSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 216, 216, 0, 0, 0, 2, 216);
INSERT INTO `eas_wo_dtl` VALUES (3241, 199, 'gJYAABvXXm7tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6303, 6303, 0, 0, 0, NULL, 6303);
INSERT INTO `eas_wo_dtl` VALUES (3242, 199, 'gJYAABvXXmntSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (3243, 199, 'gJYAABvXXl/tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (3244, 199, 'gJYAABvXXmPtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 310, 310, 0, 0, 0, 1, 310);
INSERT INTO `eas_wo_dtl` VALUES (3245, 199, 'gJYAABvXXm3tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3098, 3098, 0, 0, 0, 1, 3098);
INSERT INTO `eas_wo_dtl` VALUES (3246, 199, 'gJYAABvXXm/tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 18, 18, 0, 0, 0, 5, 18);
INSERT INTO `eas_wo_dtl` VALUES (3247, 199, 'gJYAABvXXmrtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6083, 6083, 0, 0, 0, NULL, 6083);
INSERT INTO `eas_wo_dtl` VALUES (3248, 199, 'gJYAABvXXmLtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (3249, 199, 'gJYAABvXXmvtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (3250, 199, 'gJYAABvXXmDtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (3251, 199, 'gJYAABvXXmHtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 80, 80, 0, 0, 0, NULL, 80);
INSERT INTO `eas_wo_dtl` VALUES (3252, 199, 'gJYAABvXXnDtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1511, 1511, 0, 1511, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3253, 199, 'gJYAABvXXmXtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (3254, 199, 'gJYAABvXXl7tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 80, 80, 0, 0, 0, NULL, 80);
INSERT INTO `eas_wo_dtl` VALUES (3255, 199, 'gJYAABvXXmjtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6083, 6083, 0, 0, 0, NULL, 6083);
INSERT INTO `eas_wo_dtl` VALUES (3256, 199, 'gJYAABvXXmTtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 4534, 4534, 0, 4534, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3257, 200, 'gJYAABvXXoLtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 3307, 3307, 0, 0, 0, 2, 3307);
INSERT INTO `eas_wo_dtl` VALUES (3258, 200, 'gJYAABvXXnrtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 463, 463, 0, 0, 0, 2, 463);
INSERT INTO `eas_wo_dtl` VALUES (3259, 200, 'gJYAABvXXnjtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 89, 89, 0, 0, 0, 2, 89);
INSERT INTO `eas_wo_dtl` VALUES (3260, 200, 'gJYAABvXXnvtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5498, 5498, 0, 0, 0, NULL, 5498);
INSERT INTO `eas_wo_dtl` VALUES (3261, 200, 'gJYAABvXXoDtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 14, 14, 0, 0, 0, NULL, 14);
INSERT INTO `eas_wo_dtl` VALUES (3262, 200, 'gJYAABvXXoPtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (3263, 200, 'gJYAABvXXnztSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 529, 529, 0, 0, 0, 1, 529);
INSERT INTO `eas_wo_dtl` VALUES (3264, 200, 'gJYAABvXXoHtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5291, 5291, 0, 0, 0, 1, 5291);
INSERT INTO `eas_wo_dtl` VALUES (3265, 200, 'gJYAABvXXnftSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 40, 40, 0, 0, 0, 5, 40);
INSERT INTO `eas_wo_dtl` VALUES (3266, 200, 'gJYAABvXXnTtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 11291, 11291, 0, 0, 0, NULL, 11291);
INSERT INTO `eas_wo_dtl` VALUES (3267, 200, 'gJYAABvXXnntSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3268, 200, 'gJYAABvXXn7tSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (3269, 200, 'gJYAABvXXoXtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 56, 56, 0, 0, 0, NULL, 56);
INSERT INTO `eas_wo_dtl` VALUES (3270, 200, 'gJYAABvXXnbtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 149, 149, 0, 0, 0, NULL, 149);
INSERT INTO `eas_wo_dtl` VALUES (3271, 200, 'gJYAABvXXnXtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2805, 2805, 0, 2805, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3272, 200, 'gJYAABvXXn/tSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 56, 56, 0, 0, 0, NULL, 56);
INSERT INTO `eas_wo_dtl` VALUES (3273, 200, 'gJYAABvXXnPtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 149, 149, 0, 0, 0, NULL, 149);
INSERT INTO `eas_wo_dtl` VALUES (3274, 200, 'gJYAABvXXn3tSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 11291, 11291, 0, 0, 0, NULL, 11291);
INSERT INTO `eas_wo_dtl` VALUES (3275, 200, 'gJYAABvXXoTtSYg5', 'TWpbsP9VQ46a5H6Qnf+pTx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 2805, 2805, 0, 2805, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3276, 201, 'gJYAABvXXpntSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 64, 64, 0, 0, 0, 2, 64);
INSERT INTO `eas_wo_dtl` VALUES (3277, 201, 'gJYAABvXXpbtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 244, 244, 0, 0, 0, 2, 244);
INSERT INTO `eas_wo_dtl` VALUES (3278, 201, 'gJYAABvXXoztSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1722, 1722, 0, 0, 0, 2, 1722);
INSERT INTO `eas_wo_dtl` VALUES (3279, 201, 'gJYAABvXXpPtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 3528, 3528, 0, 0, 0, NULL, 3528);
INSERT INTO `eas_wo_dtl` VALUES (3280, 201, 'gJYAABvXXpTtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 9, 9, 0, 0, 0, NULL, 9);
INSERT INTO `eas_wo_dtl` VALUES (3281, 201, 'gJYAABvXXortSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 13, 13, 0, 0, 0, NULL, 13);
INSERT INTO `eas_wo_dtl` VALUES (3282, 201, 'gJYAABvXXpftSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 365, 365, 0, 0, 0, 1, 365);
INSERT INTO `eas_wo_dtl` VALUES (3283, 201, 'gJYAABvXXpXtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3650, 3650, 0, 0, 0, 1, 3650);
INSERT INTO `eas_wo_dtl` VALUES (3284, 201, 'gJYAABvXXontSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 26, 26, 0, 0, 0, 5, 26);
INSERT INTO `eas_wo_dtl` VALUES (3285, 201, 'gJYAABvXXo/tSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7246, 7246, 0, 0, 0, NULL, 7246);
INSERT INTO `eas_wo_dtl` VALUES (3286, 201, 'gJYAABvXXovtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (3287, 201, 'gJYAABvXXpjtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (3288, 201, 'gJYAABvXXprtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 36, 36, 0, 0, 0, NULL, 36);
INSERT INTO `eas_wo_dtl` VALUES (3289, 201, 'gJYAABvXXpDtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 96, 96, 0, 0, 0, NULL, 96);
INSERT INTO `eas_wo_dtl` VALUES (3290, 201, 'gJYAABvXXo3tSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1800, 1800, 0, 1800, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3291, 201, 'gJYAABvXXojtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 36, 36, 0, 0, 0, NULL, 36);
INSERT INTO `eas_wo_dtl` VALUES (3292, 201, 'gJYAABvXXo7tSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 96, 96, 0, 0, 0, NULL, 96);
INSERT INTO `eas_wo_dtl` VALUES (3293, 201, 'gJYAABvXXpHtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7246, 7246, 0, 0, 0, NULL, 7246);
INSERT INTO `eas_wo_dtl` VALUES (3294, 201, 'gJYAABvXXpLtSYg5', 'FC8DJZzaSiaWf0MNw/IdbB0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 1800, 1800, 0, 1800, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3295, 202, 'gJYAABvXnwPtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 192, 192, 0, 0, 0, 2, 192);
INSERT INTO `eas_wo_dtl` VALUES (3296, 202, 'gJYAABvXnwvtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1349, 1349, 0, 0, 0, 2, 1349);
INSERT INTO `eas_wo_dtl` VALUES (3297, 202, 'gJYAABvXnwXtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 36, 36, 0, 0, 0, 2, 36);
INSERT INTO `eas_wo_dtl` VALUES (3298, 202, 'gJYAABvXnvztSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2756, 2756, 0, 0, 0, NULL, 2756);
INSERT INTO `eas_wo_dtl` VALUES (3299, 202, 'gJYAABvXnwHtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (3300, 202, 'gJYAABvXnv3tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (3301, 202, 'gJYAABvXnwjtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 286, 286, 0, 0, 0, 1, 286);
INSERT INTO `eas_wo_dtl` VALUES (3302, 202, 'gJYAABvXnwTtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2862, 2862, 0, 0, 0, 1, 2862);
INSERT INTO `eas_wo_dtl` VALUES (3303, 202, 'gJYAABvXnwftSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 20, 20, 0, 0, 0, 5, 20);
INSERT INTO `eas_wo_dtl` VALUES (3304, 202, 'gJYAABvXnwztSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5660, 5660, 0, 0, 0, NULL, 5660);
INSERT INTO `eas_wo_dtl` VALUES (3305, 202, 'gJYAABvXnwbtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (3306, 202, 'gJYAABvXnwDtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3307, 202, 'gJYAABvXnwntSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (3308, 202, 'gJYAABvXnv7tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 75, 75, 0, 0, 0, NULL, 75);
INSERT INTO `eas_wo_dtl` VALUES (3309, 202, 'gJYAABvXnw3tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1406, 1406, 0, 1406, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3310, 202, 'gJYAABvXnwLtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (3311, 202, 'gJYAABvXnv/tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 75, 75, 0, 0, 0, NULL, 75);
INSERT INTO `eas_wo_dtl` VALUES (3312, 202, 'gJYAABvXnwrtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5660, 5660, 0, 0, 0, NULL, 5660);
INSERT INTO `eas_wo_dtl` VALUES (3313, 202, 'gJYAABvXnw7tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1406, 1406, 0, 1406, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3314, 203, 'gJYAABvXnxbtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 144, 144, 0, 0, 0, 2, 144);
INSERT INTO `eas_wo_dtl` VALUES (3315, 203, 'gJYAABvXnx7tSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1350, 1350, 0, 0, 0, 2, 1350);
INSERT INTO `eas_wo_dtl` VALUES (3316, 203, 'gJYAABvXnxvtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 56, 56, 0, 0, 0, 2, 56);
INSERT INTO `eas_wo_dtl` VALUES (3317, 203, 'gJYAABvXnxHtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2747, 2747, 0, 0, 0, NULL, 2747);
INSERT INTO `eas_wo_dtl` VALUES (3318, 203, 'gJYAABvXnyPtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (3319, 203, 'gJYAABvXnxztSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (3320, 203, 'gJYAABvXnxLtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 292, 292, 0, 0, 0, 1, 292);
INSERT INTO `eas_wo_dtl` VALUES (3321, 203, 'gJYAABvXnxPtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2920, 2920, 0, 0, 0, 1, 2920);
INSERT INTO `eas_wo_dtl` VALUES (3322, 203, 'gJYAABvXnxTtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 20, 20, 0, 0, 0, 5, 20);
INSERT INTO `eas_wo_dtl` VALUES (3323, 203, 'gJYAABvXnxjtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5640, 5640, 0, 0, 0, NULL, 5640);
INSERT INTO `eas_wo_dtl` VALUES (3324, 203, 'gJYAABvXnxftSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (3325, 203, 'gJYAABvXnxXtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3326, 203, 'gJYAABvXnx/tSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (3327, 203, 'gJYAABvXnxntSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 75, 75, 0, 0, 0, NULL, 75);
INSERT INTO `eas_wo_dtl` VALUES (3328, 203, 'gJYAABvXnxrtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1401, 1401, 0, 1401, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3329, 203, 'gJYAABvXnyLtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (3330, 203, 'gJYAABvXnyDtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 75, 75, 0, 0, 0, NULL, 75);
INSERT INTO `eas_wo_dtl` VALUES (3331, 203, 'gJYAABvXnyHtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5640, 5640, 0, 0, 0, NULL, 5640);
INSERT INTO `eas_wo_dtl` VALUES (3332, 203, 'gJYAABvXnx3tSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1401, 1401, 0, 1401, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3333, 204, 'gJYAABvXnyntSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 163, 163, 0, 0, 0, 2, 163);
INSERT INTO `eas_wo_dtl` VALUES (3334, 204, 'gJYAABvXnyjtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1221, 1221, 0, 0, 0, 2, 1221);
INSERT INTO `eas_wo_dtl` VALUES (3335, 204, 'gJYAABvXnzPtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 45, 45, 0, 0, 0, 2, 45);
INSERT INTO `eas_wo_dtl` VALUES (3336, 204, 'gJYAABvXny7tSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2494, 2494, 0, 0, 0, NULL, 2494);
INSERT INTO `eas_wo_dtl` VALUES (3337, 204, 'gJYAABvXnzLtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (3338, 204, 'gJYAABvXnzftSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 9, 9, 0, 0, 0, NULL, 9);
INSERT INTO `eas_wo_dtl` VALUES (3339, 204, 'gJYAABvXnzHtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 265, 265, 0, 0, 0, 1, 265);
INSERT INTO `eas_wo_dtl` VALUES (3340, 204, 'gJYAABvXny3tSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2651, 2651, 0, 0, 0, 1, 2651);
INSERT INTO `eas_wo_dtl` VALUES (3341, 204, 'gJYAABvXnyvtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 18, 18, 0, 0, 0, 5, 18);
INSERT INTO `eas_wo_dtl` VALUES (3342, 204, 'gJYAABvXnzbtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5121, 5121, 0, 0, 0, NULL, 5121);
INSERT INTO `eas_wo_dtl` VALUES (3343, 204, 'gJYAABvXnzjtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (3344, 204, 'gJYAABvXnyztSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3345, 204, 'gJYAABvXny/tSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 25, 25, 0, 0, 0, NULL, 25);
INSERT INTO `eas_wo_dtl` VALUES (3346, 204, 'gJYAABvXnyftSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 68, 68, 0, 0, 0, NULL, 68);
INSERT INTO `eas_wo_dtl` VALUES (3347, 204, 'gJYAABvXnzDtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1272, 1272, 0, 1272, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (3348, 204, 'gJYAABvXnzXtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 25, 25, 0, 0, 0, NULL, 25);
INSERT INTO `eas_wo_dtl` VALUES (3349, 204, 'gJYAABvXnzTtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 68, 68, 0, 0, 0, NULL, 68);
INSERT INTO `eas_wo_dtl` VALUES (3350, 204, 'gJYAABvXnyrtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5121, 5121, 0, 0, 0, NULL, 5121);
INSERT INTO `eas_wo_dtl` VALUES (3351, 204, 'gJYAABvXnybtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1272, 1272, 0, 0, 0, 0, 1272);
INSERT INTO `eas_wo_dtl` VALUES (3352, 205, 'gJYAABvXn6TtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2762, 2762, 0, 0, 0, 2, 2762);
INSERT INTO `eas_wo_dtl` VALUES (3353, 205, 'gJYAABvXn6ftSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 291, 291, 0, 0, 0, 2, 291);
INSERT INTO `eas_wo_dtl` VALUES (3354, 205, 'gJYAABvXn7HtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6062, 6062, 0, 0, 0, NULL, 6062);
INSERT INTO `eas_wo_dtl` VALUES (3355, 205, 'gJYAABvXn6ntSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 29, 29, 0, 0, 0, NULL, 29);
INSERT INTO `eas_wo_dtl` VALUES (3356, 205, 'gJYAABvXn6LtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 26, 26, 0, 0, 0, NULL, 26);
INSERT INTO `eas_wo_dtl` VALUES (3357, 205, 'gJYAABvXn6jtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 298, 298, 0, 0, 0, 1, 298);
INSERT INTO `eas_wo_dtl` VALUES (3358, 205, 'gJYAABvXn6DtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2979, 2979, 0, 0, 0, 1, 2979);
INSERT INTO `eas_wo_dtl` VALUES (3359, 205, 'gJYAABvXn63tSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 18, 18, 0, 0, 0, 5, 18);
INSERT INTO `eas_wo_dtl` VALUES (3360, 205, 'gJYAABvXn6HtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5851, 5851, 0, 0, 0, NULL, 5851);
INSERT INTO `eas_wo_dtl` VALUES (3361, 205, 'gJYAABvXn67tSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (3362, 205, 'gJYAABvXn7DtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3363, 205, 'gJYAABvXn6rtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 29, 29, 0, 0, 0, NULL, 29);
INSERT INTO `eas_wo_dtl` VALUES (3364, 205, 'gJYAABvXn6/tSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 77, 77, 0, 0, 0, NULL, 77);
INSERT INTO `eas_wo_dtl` VALUES (3365, 205, 'gJYAABvXn6XtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1454, 1454, 0, 1110, 0, 3, 344);
INSERT INTO `eas_wo_dtl` VALUES (3366, 205, 'gJYAABvXn6vtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 29, 29, 0, 0, 0, NULL, 29);
INSERT INTO `eas_wo_dtl` VALUES (3367, 205, 'gJYAABvXn6btSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 77, 77, 0, 0, 0, NULL, 77);
INSERT INTO `eas_wo_dtl` VALUES (3368, 205, 'gJYAABvXn6ztSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5851, 5851, 0, 0, 0, NULL, 5851);
INSERT INTO `eas_wo_dtl` VALUES (3369, 205, 'gJYAABvXn6PtSYg5', 'dCUbHaexRGqO1RqqMzhpWB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 4361, 4361, 0, 4361, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3370, 206, 'gJYAABvYub7tSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 70000, 70000, 0, 69992, 0, 0, 8);
INSERT INTO `eas_wo_dtl` VALUES (3371, 206, 'gJYAABvYubjtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 31157, 31157, 0, 0, 0, 2, 31157);
INSERT INTO `eas_wo_dtl` VALUES (3372, 206, 'gJYAABvYubftSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 5264, 5264, 0, 2692, 0, 2, 2572);
INSERT INTO `eas_wo_dtl` VALUES (3373, 206, 'gJYAABvYubvtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 105070, 105070, 0, 47500, 0, NULL, 57570);
INSERT INTO `eas_wo_dtl` VALUES (3374, 206, 'gJYAABvYub/tSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 175, 175, 0, 132, 0, NULL, 43);
INSERT INTO `eas_wo_dtl` VALUES (3375, 206, 'gJYAABvYubrtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 9132, 9132, 0, 0, 0, 1, 9132);
INSERT INTO `eas_wo_dtl` VALUES (3376, 206, 'gJYAABvYub3tSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 91322, 91322, 0, 0, 0, 1, 91322);
INSERT INTO `eas_wo_dtl` VALUES (3377, 206, 'gJYAABvYubXtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 539, 539, 0, 0, 0, 5, 539);
INSERT INTO `eas_wo_dtl` VALUES (3378, 206, 'gJYAABvYubbtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 84, 84, 0, 0, 0, NULL, 84);
INSERT INTO `eas_wo_dtl` VALUES (3379, 206, 'gJYAABvYucPtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 210, 210, 0, 90, 0, NULL, 120);
INSERT INTO `eas_wo_dtl` VALUES (3380, 206, 'gJYAABvYucHtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 70000, 70000, 0, 28306, 0, 3, 41694);
INSERT INTO `eas_wo_dtl` VALUES (3381, 206, 'gJYAABvYucDtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 2422, 2422, 0, 0, 0, NULL, 2422);
INSERT INTO `eas_wo_dtl` VALUES (3382, 206, 'gJYAABvYucLtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 281750, 281750, 0, 0, 0, NULL, 281750);
INSERT INTO `eas_wo_dtl` VALUES (3383, 206, 'gJYAABvYubztSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 281750, 281750, 0, 0, 0, NULL, 281750);
INSERT INTO `eas_wo_dtl` VALUES (3384, 206, 'gJYAABvYubntSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '铝箔袋', '470*500*0.12C-自制铝箔袋', '个', 812, 812, 0, 0, 0, NULL, 812);
INSERT INTO `eas_wo_dtl` VALUES (3385, 207, 'gJYAABvYuzLtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 1830, 1830, 0, 1830, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (3386, 207, 'gJYAABvYuzjtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1047, 1047, 0, 0, 0, 2, 1047);
INSERT INTO `eas_wo_dtl` VALUES (3387, 207, 'gJYAABvYuzHtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 270, 270, 0, 0, 0, 2, 270);
INSERT INTO `eas_wo_dtl` VALUES (3388, 207, 'gJYAABvYuy/tSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 35, 35, 0, 0, 0, 2, 35);
INSERT INTO `eas_wo_dtl` VALUES (3389, 207, 'gJYAABvYuzbtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 2757, 2757, 0, 0, 0, NULL, 2757);
INSERT INTO `eas_wo_dtl` VALUES (3390, 207, 'gJYAABvYuzPtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (3391, 207, 'gJYAABvYuzTtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (3392, 207, 'gJYAABvYuzXtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 92, 92, 0, 0, 0, 1, 92);
INSERT INTO `eas_wo_dtl` VALUES (3393, 207, 'gJYAABvYuy3tSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 919, 919, 0, 0, 0, 1, 919);
INSERT INTO `eas_wo_dtl` VALUES (3394, 207, 'gJYAABvYuzftSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2455, 2455, 0, 0, 0, NULL, 2455);
INSERT INTO `eas_wo_dtl` VALUES (3395, 207, 'gJYAABvYuzntSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (3396, 207, 'gJYAABvYuyvtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 34, 34, 0, 0, 0, NULL, 34);
INSERT INTO `eas_wo_dtl` VALUES (3397, 207, 'gJYAABvYuyztSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 610, 610, 0, 0, 0, 3, 610);
INSERT INTO `eas_wo_dtl` VALUES (3398, 207, 'gJYAABvYuzDtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 34, 34, 0, 0, 0, NULL, 34);
INSERT INTO `eas_wo_dtl` VALUES (3399, 207, 'gJYAABvYuy7tSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2455, 2455, 0, 0, 0, NULL, 2455);
INSERT INTO `eas_wo_dtl` VALUES (3400, 208, 'gJYAABvYu0XtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 6300, 6300, 0, 6291, 0, 0, 9);
INSERT INTO `eas_wo_dtl` VALUES (3401, 208, 'gJYAABvYu0ntSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 3795, 3795, 0, 0, 0, 2, 3795);
INSERT INTO `eas_wo_dtl` VALUES (3402, 208, 'gJYAABvYu0DtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1006, 1006, 0, 0, 0, 2, 1006);
INSERT INTO `eas_wo_dtl` VALUES (3403, 208, 'gJYAABvYu0PtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 134, 134, 0, 0, 0, 2, 134);
INSERT INTO `eas_wo_dtl` VALUES (3404, 208, 'gJYAABvYu0ztSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 9492, 9492, 0, 0, 0, NULL, 9492);
INSERT INTO `eas_wo_dtl` VALUES (3405, 208, 'gJYAABvYu0ftSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 35, 35, 0, 0, 0, NULL, 35);
INSERT INTO `eas_wo_dtl` VALUES (3406, 208, 'gJYAABvYuz/tSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 0, 0, NULL, 22);
INSERT INTO `eas_wo_dtl` VALUES (3407, 208, 'gJYAABvYu0jtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 314, 314, 0, 0, 0, 1, 314);
INSERT INTO `eas_wo_dtl` VALUES (3408, 208, 'gJYAABvYu0rtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3140, 3140, 0, 0, 0, 1, 3140);
INSERT INTO `eas_wo_dtl` VALUES (3409, 208, 'gJYAABvYu0vtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8453, 8453, 0, 0, 0, NULL, 8453);
INSERT INTO `eas_wo_dtl` VALUES (3410, 208, 'gJYAABvYu0HtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 11, 11, 0, 0, 0, NULL, 11);
INSERT INTO `eas_wo_dtl` VALUES (3411, 208, 'gJYAABvYu03tSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 116, 116, 0, 0, 0, NULL, 116);
INSERT INTO `eas_wo_dtl` VALUES (3412, 208, 'gJYAABvYu0LtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2100, 2100, 0, 0, 0, 3, 2100);
INSERT INTO `eas_wo_dtl` VALUES (3413, 208, 'gJYAABvYu0btSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 116, 116, 0, 0, 0, NULL, 116);
INSERT INTO `eas_wo_dtl` VALUES (3414, 208, 'gJYAABvYu0TtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8453, 8453, 0, 0, 0, NULL, 8453);
INSERT INTO `eas_wo_dtl` VALUES (3415, 209, 'gJYAABsNOqftSYg5', 'GqtVt8pJTE6umVLlJFVuIx0NgN0=', 'gJYAABoE+7FECefw', '06.03.03.007.0441', '2835阳光色贴片', 'S-BEN-27E-21H-18-P54-6', '个', 155000, 155000, 1, 155000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3416, 210, 'gJYAABtvDnLtSYg5', 'oLIUjor0TjWs4hpuEs1BfR0NgN0=', 'gJYAABexS4lECefw', '06.03.03.007.0326', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCA-E', '个', 75452, 75452, 1, 75452, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3417, 211, 'gJYAABud7KbtSYg5', '1WQHTuGhQJO4hbRNs5vARh0NgN0=', 'gJYAABexS4lECefw', '06.03.03.007.0326', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCA-E', '个', 623523, 623523, 1, 623523, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3418, 212, 'gJYAABud7K/tSYg5', 'APn638ZPQ0OefYwjuf82bh0NgN0=', 'gJYAABc/84NECefw', '06.03.03.001.0530', '2835白色贴片', 'S-BEN-40E-11L-03-B32-B', '个', 396000, 396000, 1, 396000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3419, 213, 'gJYAABujdvXtSYg5', 'uFFeu4peT9K6M3IkMJO9Wh0NgN0=', 'gJYAABexP8lECefw', '06.03.03.001.0951', '2835白色贴片', 'S-BEN-40H-31H-09-JCC-E', '个', 60000, 60000, 1, 60000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3420, 213, 'gJYAABujdvbtSYg5', 'uFFeu4peT9K6M3IkMJO9Wh0NgN0=', 'gJYAABi9DKpECefw', '06.03.03.007.0392', '2835阳光色贴片', 'S-BEN-27E-31H-09-JG7-4', '个', 74000, 74000, 1, 74000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3421, 214, 'gJYAABujdwDtSYg5', '9In3YA86RB+qUtcN+EBwbR0NgN0=', 'gJYAABixvAFECefw', '06.03.03.001.1019', '2835白色贴片', 'S-BEN-50E-21M-06-K25-5', '个', 80000, 80000, 1, 80000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3422, 215, 'gJYAABujdxbtSYg5', 'TPEcyaVtS/e5CxJ3q/dv7B0NgN0=', 'gJYAABoE/fJECefw', '06.03.03.001.1085', '2835白色贴片', 'S-BEN-50E-21H-18-P54-6', '个', 100000, 100000, 1, 100000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3423, 216, 'gJYAABujsPXtSYg5', 'f9xiMLQjQnCZva1xHJepAh0NgN0=', 'gJYAABelM9tECefw', '06.03.03.001.0894', '2835白色贴片', 'S-BEN-50G-31H-09-JD6-F', '个', 189000, 189000, 1, 189000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3424, 216, 'gJYAABujsPPtSYg5', 'f9xiMLQjQnCZva1xHJepAh0NgN0=', 'gJYAABexNk9ECefw', '06.03.03.001.0956', '2835白色贴片', 'S-BEN-57G-31H-09-JCA-E', '个', 319000, 319000, 1, 319000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3425, 216, 'gJYAABujsPDtSYg5', 'f9xiMLQjQnCZva1xHJepAh0NgN0=', 'gJYAABiYdOdECefw', '06.03.03.001.1017', '2835白色贴片', 'S-BEN-50G-31H-09-JCG-E', '个', 312000, 312000, 1, 312000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3426, 216, 'gJYAABujsPTtSYg5', 'f9xiMLQjQnCZva1xHJepAh0NgN0=', 'gJYAABeZCbJECefw', '06.03.03.007.0280', '2835阳光色贴片', 'S-BEN-30E-31H-09-JC1-0', '个', 121000, 121000, 1, 121000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3427, 216, 'gJYAABujsPLtSYg5', 'f9xiMLQjQnCZva1xHJepAh0NgN0=', 'gJYAABelLQRECefw', '06.03.03.007.0289', '2835阳光色贴片', 'S-BEN-27G-31H-09-JD6-F', '个', 661000, 661000, 1, 386777, 0, NULL, 274223);
INSERT INTO `eas_wo_dtl` VALUES (3428, 216, 'gJYAABujsPHtSYg5', 'f9xiMLQjQnCZva1xHJepAh0NgN0=', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', '个', 344000, 344000, 1, 344000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3429, 217, 'gJYAABujsQPtSYg5', '/wirNI8HTw+jyOA2Dkqfsh0NgN0=', 'gJYAABelDUlECefw', '06.03.03.001.0900', '2835白色贴片', 'S-XEN-50G-31H-09-H15-C', '个', 120000, 120000, 1, 120000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3430, 218, 'gJYAABujsQbtSYg5', 'vHqa+VZ3QkqMppGPEJneHx0NgN0=', 'gJYAABqtS+dECefw', '06.03.03.007.0475', '2835阳光色贴片', 'S-BEN-27E-11L-03-BB7-9', '个', 370000, 370000, 1, 370000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3431, 219, 'gJYAABunL4vtSYg5', 'NreJ6pLTQbq5jelOivHieh0NgN0=', 'gJYAABph4NFECefw', '06.03.03.001.1110', '2835白色贴片', 'S-BEN-40G-11L-03-D0H-B', '个', 192000, 192000, 1, 143000, 0, NULL, 49000);
INSERT INTO `eas_wo_dtl` VALUES (3432, 219, 'gJYAABunL4rtSYg5', 'NreJ6pLTQbq5jelOivHieh0NgN0=', 'gJYAABqtSsBECefw', '06.03.03.001.1126', '2835白色贴片', 'S-BEN-65E-11L-03-BB7-9', '个', 180000, 180000, 1, 180000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3433, 219, 'gJYAABunL43tSYg5', 'NreJ6pLTQbq5jelOivHieh0NgN0=', 'gJYAABeo2rpECefw', '06.03.03.002.0010', '2835阳光色贴片', 'S-BEN-15S-11L-03-D21-0', '个', 300000, 300000, 1, 300000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3434, 219, 'gJYAABunL47tSYg5', 'NreJ6pLTQbq5jelOivHieh0NgN0=', 'gJYAABph3NNECefw', '06.03.03.007.0468', '2835阳光色贴片', 'S-BEN-27G-11L-03-D0H-B', '个', 150000, 150000, 1, 150000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3435, 219, 'gJYAABunL4ztSYg5', 'NreJ6pLTQbq5jelOivHieh0NgN0=', 'gJYAABph3xtECefw', '06.03.03.007.0471', '2835阳光色贴片', 'S-BEN-30G-11L-03-D0H-B', '个', 243000, 243000, 1, 243000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3436, 220, 'gJYAABunL6vtSYg5', 'KH8JkHUsRp+QjqPS0OCwpB0NgN0=', 'gJYAABc/84NECefw', '06.03.03.001.0530', '2835白色贴片', 'S-BEN-40E-11L-03-B32-B', '个', 160000, 160000, 1, 160000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3437, 220, 'gJYAABunL63tSYg5', 'KH8JkHUsRp+QjqPS0OCwpB0NgN0=', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', '个', 55000, 55000, 1, 55000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3438, 220, 'gJYAABunL6/tSYg5', 'KH8JkHUsRp+QjqPS0OCwpB0NgN0=', 'gJYAABdAK2lECefw', '06.03.03.007.0063', '2835阳光色贴片', 'S-BEN-27G-11M-03-E01-L', '个', 91145, 91145, 1, 91145, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3439, 220, 'gJYAABunL6ztSYg5', 'KH8JkHUsRp+QjqPS0OCwpB0NgN0=', 'gJYAABdBOsVECefw', '06.03.03.007.0144', '2835阳光色贴片', 'S-BEN-30G-11M-03-E01-L', '个', 160000, 160000, 1, 160000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3440, 220, 'gJYAABunL67tSYg5', 'KH8JkHUsRp+QjqPS0OCwpB0NgN0=', 'gJYAABeMqepECefw', '06.03.03.007.0274', '2835阳光色贴片', 'S-BEN-30E-11M-03-F0E-9', '个', 80000, 80000, 1, 80000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3441, 221, 'gJYAABunL7XtSYg5', 'U9XnmweQT/i/bKFBHqbEnx0NgN0=', 'gJYAABlDdmZECefw', '06.03.03.001.1040', '2835白色贴片', 'S-BEN-50G-41H-12-K16-7', '个', 300000, 300000, 1, 300000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3442, 222, 'gJYAABunL8XtSYg5', '+zb/o+lPQ/WSsIjTSKjX5R0NgN0=', 'gJYAABeZGItECefw', '06.03.03.001.0880', '2835白色贴片', 'S-BEN-50E-31H-09-JC1-0', '个', 350000, 350000, 1, 350000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3443, 222, 'gJYAABunL8ftSYg5', '+zb/o+lPQ/WSsIjTSKjX5R0NgN0=', 'gJYAABeZCU9ECefw', '06.03.03.001.0882', '2835白色贴片', 'S-BEN-65E-31H-09-JC1-0', '个', 200000, 200000, 1, 100000, 0, NULL, 100000);
INSERT INTO `eas_wo_dtl` VALUES (3444, 222, 'gJYAABunL8TtSYg5', '+zb/o+lPQ/WSsIjTSKjX5R0NgN0=', 'gJYAABeZGVFECefw', '06.03.03.007.0279', '2835阳光色贴片', 'S-BEN-27E-31H-09-JC1-0', '个', 80000, 80000, 1, 80000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3445, 222, 'gJYAABunL8btSYg5', '+zb/o+lPQ/WSsIjTSKjX5R0NgN0=', 'gJYAABhu5IlECefw', '06.03.03.007.0383', '2835阳光色贴片', 'S-XEN-30G-31H-09-H06-C', '个', 400000, 400000, 1, 390000, 0, NULL, 10000);
INSERT INTO `eas_wo_dtl` VALUES (3446, 223, 'gJYAABunL87tSYg5', 'fo4AajSWQGakNYBDV/leih0NgN0=', 'gJYAABed7/9ECefw', '06.03.03.007.0286', '2835阳光色贴片', 'S-BEN-30G-31H-09-JC1-0', '个', 100000, 100000, 1, 100000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3447, 223, 'gJYAABunL9DtSYg5', 'fo4AajSWQGakNYBDV/leih0NgN0=', 'gJYAABexNSVECefw', '06.03.03.007.0327', '2835阳光色贴片', 'S-BEN-30H-31H-09-JCC-E', '个', 80000, 80000, 1, 80000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3448, 223, 'gJYAABunL8/tSYg5', 'fo4AajSWQGakNYBDV/leih0NgN0=', 'gJYAABggOhZECefw', '06.03.03.007.0374', '2835阳光色贴片', 'S-BEN-35C-31H-09-J58-2', '个', 40000, 40000, 1, 40000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3449, 224, 'gJYAABuq9eTtSYg5', 'uTKnCMb5Q/6DEug1Q313Xx0NgN0=', 'gJYAABeMrX1ECefw', '06.03.03.001.0874', '2835白色贴片', 'S-BEN-65E-11M-03-F0E-9', '个', 120000, 120000, 1, 120000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3450, 224, 'gJYAABuq9eXtSYg5', 'uTKnCMb5Q/6DEug1Q313Xx0NgN0=', 'gJYAABph3olECefw', '06.03.03.007.0469', '2835阳光色贴片', 'S-BEN-30E-11L-03-D0H-B', '个', 420781, 200000, 1, 200000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3451, 224, 'gJYAABuq9ebtSYg5', 'uTKnCMb5Q/6DEug1Q313Xx0NgN0=', 'gJYAABqtSZtECefw', '06.03.03.007.0479', '2835阳光色贴片', 'S-BEN-35E-11L-03-BB7-9', '个', 100781, 100781, 1, 100781, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3452, 225, 'gJYAABuq9fTtSYg5', 'BwGzjRhRRfiYkeKt9eP+th0NgN0=', 'gJYAABfXUo1ECefw', '06.03.03.007.0331', '2835阳光色贴片', 'S-BEN-27E-11L-03-BA4-6', '个', 70736, 70736, 1, 70736, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3453, 226, 'gJYAABuq9fftSYg5', '9e55xrx2QOKSDUlRh12RmB0NgN0=', 'gJYAABfXUo1ECefw', '06.03.03.007.0331', '2835阳光色贴片', 'S-BEN-27E-11L-03-BA4-6', '个', 60000, 60000, 1, 60000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3454, 227, 'gJYAABuq9f/tSYg5', 'zy9lpKpMRk+Woe3GHhsydx0NgN0=', 'gJYAABqtSZtECefw', '06.03.03.007.0479', '2835阳光色贴片', 'S-BEN-35E-11L-03-BB7-9', '个', 50000, 50000, 1, 50000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3455, 228, 'gJYAABuq9gvtSYg5', 'jvnI2727T+iNuqFIoDv+EB0NgN0=', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', '个', 29923, 29923, 1, 29923, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3456, 229, 'gJYAABuq9h7tSYg5', '8xkbUwgaQl+po6AS3LgaLh0NgN0=', 'gJYAABmdj81ECefw', '06.03.03.001.1073', '2835白色贴片', 'S-BEN-65G-21H-18-P58-5', '个', 70000, 70000, 1, 70000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3457, 230, 'gJYAABuq9ibtSYg5', 'fibg/+ezTu2RWP2EPbMxMx0NgN0=', 'gJYAABkHIdhECefw', '06.03.03.001.1034', '2835白色贴片', 'S-BEN-40E-21M-06-L02-2', '个', 370000, 370000, 1, 370000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3458, 231, 'gJYAABuq9jHtSYg5', 'wPN4ULQ/RamLXO0U3EAcmR0NgN0=', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', '个', 1300000, 1300000, 1, 1300000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3459, 232, 'gJYAABuq9jTtSYg5', 'pMiqmVP7SGatDD4rTRI8fB0NgN0=', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', '个', 900000, 900000, 1, 900000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3460, 233, 'gJYAABuq9jftSYg5', 'hDips8ptSceuaZhXyjvpbh0NgN0=', 'gJYAABelKqVECefw', '06.03.03.001.0906', '2835白色贴片', 'S-BEN-50G-31H-09-JE6-E', '个', 750000, 750000, 1, 750000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3461, 234, 'gJYAABut/kbtSYg5', '+bUYAYolSIK6HebLGlVuvx0NgN0=', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', '个', 308427, 308427, 1, 308427, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3462, 234, 'gJYAABut/kXtSYg5', '+bUYAYolSIK6HebLGlVuvx0NgN0=', 'gJYAABqtSsBECefw', '06.03.03.001.1126', '2835白色贴片', 'S-BEN-65E-11L-03-BB7-9', '个', 151890, 151890, 1, 151890, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3463, 234, 'gJYAABut/kTtSYg5', '+bUYAYolSIK6HebLGlVuvx0NgN0=', 'gJYAABqtSZtECefw', '06.03.03.007.0479', '2835阳光色贴片', 'S-BEN-35E-11L-03-BB7-9', '个', 174683, 174683, 1, 174683, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3464, 235, 'gJYAABut/kntSYg5', '8ED4PD5gS6SFJjfQlLiwjB0NgN0=', 'gJYAABlG8O5ECefw', '06.03.03.007.0410', '2835阳光色贴片', 'S-BEN-30G-21H-18-P58-5', '个', 319382, 319382, 1, 319382, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3465, 236, 'gJYAABut/lTtSYg5', 'E62SDME8Syqq+alygxgn4B0NgN0=', 'gJYAABdADdRECefw', '06.03.03.007.0076', '2835阳光色贴片', 'S-BEN-27G-41H-12-K01-4', '个', 30000, 30000, 1, 30000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3466, 236, 'gJYAABut/lXtSYg5', 'E62SDME8Syqq+alygxgn4B0NgN0=', 'gJYAABlDfHhECefw', '06.03.03.007.0405', '2835阳光色贴片', 'S-BEN-27E-41H-12-K15-7', '个', 30000, 30000, 1, 30000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3467, 237, 'gJYAABut/ljtSYg5', '04tB5/h4ThSiOn6OxZZMPh0NgN0=', 'gJYAABo8ZNZECefw', '06.03.03.001.1100', '2835白色贴片', 'S-BEN-50E-11L-03-BB5-E', '个', 65000, 65000, 1, 65000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3468, 238, 'gJYAABut/qntSYg5', 'NqtJRfXnRUaztrRf9dImKx0NgN0=', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', '个', 139000, 139000, 1, 139000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3469, 239, 'gJYAABut/sbtSYg5', 'ISIwjasxRdGnGk+LBO72Kh0NgN0=', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', '个', 11859, 11859, 1, 11859, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3470, 240, 'gJYAABuwSYftSYg5', 'BItuW/saRoWtkpFEJzSt3h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3471, 240, 'gJYAABuwSYbtSYg5', 'BItuW/saRoWtkpFEJzSt3h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3472, 240, 'gJYAABuwSYjtSYg5', 'BItuW/saRoWtkpFEJzSt3h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3473, 240, 'gJYAABuwSYXtSYg5', 'BItuW/saRoWtkpFEJzSt3h0NgN0=', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', '个', 100000, 100000, 1, 62816, 0, NULL, 37184);
INSERT INTO `eas_wo_dtl` VALUES (3474, 241, 'gJYAABuwSY/tSYg5', 'yAnt2nuFRXmdzRvU7F9p7B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3475, 241, 'gJYAABuwSY3tSYg5', 'yAnt2nuFRXmdzRvU7F9p7B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3476, 241, 'gJYAABuwSY7tSYg5', 'yAnt2nuFRXmdzRvU7F9p7B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3477, 241, 'gJYAABuwSYztSYg5', 'yAnt2nuFRXmdzRvU7F9p7B0NgN0=', 'gJYAABelKqVECefw', '06.03.03.001.0906', '2835白色贴片', 'S-BEN-50G-31H-09-JE6-E', '个', 100000, 100000, 1, 79995, 0, NULL, 20005);
INSERT INTO `eas_wo_dtl` VALUES (3478, 242, 'gJYAABuxHIXtSYg5', '0npkxoqSQmuSN3OtnVx5Oh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3479, 242, 'gJYAABuxHIPtSYg5', '0npkxoqSQmuSN3OtnVx5Oh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3480, 242, 'gJYAABuxHITtSYg5', '0npkxoqSQmuSN3OtnVx5Oh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3481, 242, 'gJYAABuxHILtSYg5', '0npkxoqSQmuSN3OtnVx5Oh0NgN0=', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', '个', 100000, 100000, 1, 58160, 0, NULL, 41840);
INSERT INTO `eas_wo_dtl` VALUES (3482, 243, 'gJYAABuxHIvtSYg5', 'HMK103CUTPazbw3byMaU2B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3483, 243, 'gJYAABuxHIntSYg5', 'HMK103CUTPazbw3byMaU2B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3484, 243, 'gJYAABuxHIrtSYg5', 'HMK103CUTPazbw3byMaU2B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3485, 243, 'gJYAABuxHIjtSYg5', 'HMK103CUTPazbw3byMaU2B0NgN0=', 'gJYAABelLQRECefw', '06.03.03.007.0289', '2835阳光色贴片', 'S-BEN-27G-31H-09-JD6-F', '个', 100000, 100000, 1, 74681, 0, NULL, 25319);
INSERT INTO `eas_wo_dtl` VALUES (3486, 244, 'gJYAABuxHKrtSYg5', 'MUctBc2DSG6SDErvN1JTDx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3487, 244, 'gJYAABuxHKjtSYg5', 'MUctBc2DSG6SDErvN1JTDx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3488, 244, 'gJYAABuxHKntSYg5', 'MUctBc2DSG6SDErvN1JTDx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3489, 244, 'gJYAABuxHKftSYg5', 'MUctBc2DSG6SDErvN1JTDx0NgN0=', 'gJYAABelMq9ECefw', '06.03.03.001.0907', '2835白色贴片', 'S-BEN-65G-31H-09-JE6-E', '个', 100000, 100000, 1, 67381, 0, NULL, 32619);
INSERT INTO `eas_wo_dtl` VALUES (3490, 245, 'gJYAABuxHMjtSYg5', 'RX9AXFoURbS4NkeI5FgVnB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3491, 245, 'gJYAABuxHMbtSYg5', 'RX9AXFoURbS4NkeI5FgVnB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3492, 245, 'gJYAABuxHMftSYg5', 'RX9AXFoURbS4NkeI5FgVnB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3493, 245, 'gJYAABuxHMXtSYg5', 'RX9AXFoURbS4NkeI5FgVnB0NgN0=', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', '个', 100000, 100000, 1, 82965, 0, NULL, 17035);
INSERT INTO `eas_wo_dtl` VALUES (3494, 246, 'gJYAABuxHM/tSYg5', '4AkSsNzbT3SXyfQtMNlKgB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3495, 246, 'gJYAABuxHM3tSYg5', '4AkSsNzbT3SXyfQtMNlKgB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (3496, 246, 'gJYAABuxHM7tSYg5', '4AkSsNzbT3SXyfQtMNlKgB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (3497, 246, 'gJYAABuxHMztSYg5', '4AkSsNzbT3SXyfQtMNlKgB0NgN0=', 'gJYAABdBT6NECefw', '06.03.03.007.0154', '2835阳光色贴片', 'S-BEN-30G-31H-09-J76-4', '个', 100000, 100000, 1, 85000, 0, NULL, 15000);
INSERT INTO `eas_wo_dtl` VALUES (3498, 247, 'gJYAABuxHlDtSYg5', '3zrzH/FLRbqHwNLs43ucch0NgN0=', 'gJYAABeMqEpECefw', '06.03.03.007.0276', '2835阳光色贴片', 'S-BEN-27E-12H-18-P06-3', '个', 245000, 245000, 1, 245000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3499, 248, 'gJYAABuxHlXtSYg5', 'EcFumlFvSduxYXyFxHDIwx0NgN0=', 'gJYAABdAOMRECefw', '06.03.03.007.0037', '2835阳光色贴片', 'S-BEN-27E-21H-06-L01-1', '个', 20000, 20000, 1, 20000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3500, 249, 'gJYAABuxHljtSYg5', 'iDeD1Z9lTlWj67BMprNYWR0NgN0=', 'gJYAABlG8GRECefw', '06.03.03.007.0409', '2835阳光色贴片', 'S-BEN-27G-21H-18-P58-5', '个', 65000, 65000, 1, 65000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3501, 250, 'gJYAABuxHlvtSYg5', 'P7ucMZQGQVy7RdZZq2vAmB0NgN0=', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', '个', 500000, 500000, 1, 500000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3502, 251, 'gJYAABuxHmbtSYg5', 'tDn7kpZHQqmQ8Tr7eCgGQB0NgN0=', 'gJYAABdADdRECefw', '06.03.03.007.0076', '2835阳光色贴片', 'S-BEN-27G-41H-12-K01-4', '个', 105000, 105000, 1, 105000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3503, 252, 'gJYAABuxHmztSYg5', 'pIM9c9ACTvu4/zIpYu/vRR0NgN0=', 'gJYAABqtLR5ECefw', '06.03.03.007.0478', '2835阳光色贴片', 'S-BEN-30E-11M-03-BB7-D', '个', 475000, 475000, 1, 475000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3504, 253, 'gJYAABuxHnbtSYg5', 'TjAKrRfgT7iB0SvB+bcqRh0NgN0=', 'gJYAABeMqepECefw', '06.03.03.007.0274', '2835阳光色贴片', 'S-BEN-30E-11M-03-F0E-9', '个', 545000, 545000, 1, 545000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3505, 254, 'gJYAABuxHnntSYg5', 'tlLpEU6ZTFGVzQRZOYmPzR0NgN0=', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', '个', 105000, 105000, 1, 105000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3506, 255, 'gJYAABuxHn/tSYg5', '4od6GhuNR9mMxoLHc3Q0XR0NgN0=', 'gJYAABexS4lECefw', '06.03.03.007.0326', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCA-E', '个', 320000, 320000, 1, 320000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3507, 256, 'gJYAABuxHoXtSYg5', 'GN27r5a4TjysMcMZOmAd7h0NgN0=', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', '个', 140000, 140000, 1, 140000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3508, 257, 'gJYAABuxHojtSYg5', 'tLNb8q4iScuEHMcW2ZrJ8B0NgN0=', 'gJYAABeox5RECefw', '06.03.03.002.0015', '2835阳光色贴片', 'S-BEN-35G-11M-03-F0D-9', '个', 485000, 485000, 1, 485000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3509, 258, 'gJYAABuxHo3tSYg5', '2aum8Mm7QHSVGWhdFzlzNh0NgN0=', 'gJYAABc/84NECefw', '06.03.03.001.0530', '2835白色贴片', 'S-BEN-40E-11L-03-B32-B', '个', 396000, 396000, 1, 396000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3510, 259, 'gJYAABuxHpDtSYg5', 'wCltn1xbS6inLNC/Ciuk6h0NgN0=', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', '个', 1134000, 1134000, 1, 1134000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3511, 260, 'gJYAABuxHpPtSYg5', 'LcI3KbI1S+OHsnVKQwWYgh0NgN0=', 'gJYAABo8ZNZECefw', '06.03.03.001.1100', '2835白色贴片', 'S-BEN-50E-11L-03-BB5-E', '个', 108000, 108000, 1, 108000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3512, 261, 'gJYAABuxHpbtSYg5', 'uqJtPHmwRYm459RhzDgSRh0NgN0=', 'gJYAABqtLItECefw', '06.03.03.001.1125', '2835白色贴片', 'S-BEN-50E-11M-03-BB7-D', '个', 576000, 576000, 1, 576000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3513, 262, 'gJYAABuxHpntSYg5', 'SGU0fzS6Qaut/J3n25cMKx0NgN0=', 'gJYAABeMqrRECefw', '06.03.03.001.0872', '2835白色贴片', 'S-BEN-50E-11M-03-F0E-9', '个', 255000, 255000, 1, 255000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3514, 263, 'gJYAABuxHpztSYg5', 'YGorLrP6T6CK6CZLGIwcTB0NgN0=', 'gJYAABeZGItECefw', '06.03.03.001.0880', '2835白色贴片', 'S-BEN-50E-31H-09-JC1-0', '个', 15000, 15000, 1, 15000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3515, 264, 'gJYAABuxHp/tSYg5', 'jZryNZ5qTva7+sj8945nbx0NgN0=', 'gJYAABexR4ZECefw', '06.03.03.001.0952', '2835白色贴片', 'S-BEN-50E-31H-09-JC7-E', '个', 75000, 75000, 1, 75000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3516, 265, 'gJYAABuxHqXtSYg5', 'eDS2V+ikQUG4Hl9DSOcefR0NgN0=', 'gJYAABexSAlECefw', '06.03.03.001.0953', '2835白色贴片', 'S-BEN-50G-31H-09-JCA-E', '个', 250000, 250000, 1, 250000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3517, 266, 'gJYAABuxHqjtSYg5', '/cC60BWARySnYGulffXfOB0NgN0=', 'gJYAABeMrEZECefw', '06.03.03.001.0873', '2835白色贴片', 'S-BEN-57E-11M-03-F0E-9', '个', 45000, 45000, 1, 45000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3518, 267, 'gJYAABuxHqvtSYg5', 'ctjbDa+fTh6GVGHMsf9u7R0NgN0=', 'gJYAABeZGCFECefw', '06.03.03.001.0885', '2835白色贴片', 'S-BEN-57E-12M-03-F4C-7', '个', 140000, 140000, 1, 140000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3519, 268, 'gJYAABuxHrDtSYg5', 'kWY3NA7RRc+ZkadWAv7XrR0NgN0=', 'gJYAABdF0bZECefw', '06.03.03.004.0006', '2835红色贴片（植物照明）', 'S-BEN-PCR-21H-06-N11-1', '个', 334135, 334135, 1, 334135, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3520, 269, 'gJYAABuxHrPtSYg5', 'KufcvZFpQxSFYUF75PkhQx0NgN0=', 'gJYAABexNk9ECefw', '06.03.03.001.0956', '2835白色贴片', 'S-BEN-57G-31H-09-JCA-E', '个', 280000, 280000, 1, 280000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3521, 270, 'gJYAABuxHrrtSYg5', 'aMWYSJCESVWwu6jsYat30B0NgN0=', 'gJYAABhu6ntECefw', '06.03.03.001.1013', '2835白色贴片', 'S-XEN-40G-31H-09-H06-C', '个', 72000, 72000, 1, 72000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3522, 271, 'gJYAABuyyZHtSYg5', '4dk/pCBjRLmiu4kYUnRl0B0NgN0=', 'gJYAABmRrgFECefw', '06.03.03.007.0428', '2835阳光色贴片', 'S-SEN-27H-12M-03-F11-3', '个', 60000, 60000, 1, 60000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3523, 272, 'gJYAABvGNrbtSYg5', 'zaMsFWi/RT+n9CuYDvaU7x0NgN0=', 'gJYAABelNjNECefw', '06.03.03.001.0899', '2835白色贴片', 'S-XEN-50G-31H-09-H14-C', '个', 3000, 3000, 1, 3000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3524, 273, 'gJYAABvGtCjtSYg5', 'M2F+LrQfRCeKUWdwhQw/jR0NgN0=', 'gJYAABed8ShECefw', '06.03.03.001.0887', '2835白色贴片', 'S-BEN-40G-31H-09-JC1-0', '个', 81000, 81000, 1, 81000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3525, 273, 'gJYAABvGtCntSYg5', 'M2F+LrQfRCeKUWdwhQw/jR0NgN0=', 'gJYAABeZGVFECefw', '06.03.03.007.0279', '2835阳光色贴片', 'S-BEN-27E-31H-09-JC1-0', '个', 222000, 141000, 1, 141000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3526, 274, 'gJYAABvKFg3tSYg5', '2cKo7rCPRKePL156JVzAtB0NgN0=', 'gJYAABqtTH1ECefw', '06.03.03.001.1122', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-9', '个', 550000, 550000, 1, 550000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3527, 275, 'gJYAABvKFiDtSYg5', 'kuf7rwT0TvilGUN/ME028h0NgN0=', 'gJYAABhu5PRECefw', '06.03.03.001.1014', '2835白色贴片', 'S-XEN-50G-31H-09-H06-C', '个', 69000, 69000, 1, 69000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3528, 276, 'gJYAABvKFkXtSYg5', 'QpOK1ZgaSDSUmpJGvtjofB0NgN0=', 'gJYAABqtK2RECefw', '06.03.03.007.0480', '2835阳光色贴片', 'S-BEN-35E-11M-03-BB7-D', '个', 200000, 200000, 1, 200000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (3529, 277, 'gJYAABvYH0ntSYg5', '8vz8MGvPQQWGDmmZ75WMXh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (3530, 277, 'gJYAABvYH0rtSYg5', '8vz8MGvPQQWGDmmZ75WMXh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 19, 19, 0, 0, 0, NULL, 19);
INSERT INTO `eas_wo_dtl` VALUES (3531, 277, 'gJYAABvX8JTtSYg5', '8vz8MGvPQQWGDmmZ75WMXh0NgN0=', 'gJYAABelKc5ECefw', '06.03.03.001.0905', '2835白色贴片', 'S-BEN-40G-31H-09-JE6-E', '个', 365000, 365000, 1, 0, 0, NULL, 365000);

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '算法模型，模型定义：机种（显指、色温、流明、波长），BOM组合（支架型号、AB胶型号、荧光粉组合、芯片型号、芯片波段），色区，出货要求。' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '抗沉淀粉' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_anti_starch
-- ----------------------------
INSERT INTO `t_anti_starch` VALUES (1, NULL, '抗沉淀粉WP-60m', '恒极', 0.11, 0.008, '2019-12-09 17:05:13', 0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求对应的前测规则' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_bom_Phosphor
-- ----------------------------
DROP TABLE IF EXISTS `t_bom_Phosphor`;
CREATE TABLE `t_bom_Phosphor`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bom_id` bigint(20) NOT NULL COMMENT 'bom id',
  `phosphor_id` bigint(20) NOT NULL COMMENT '荧光粉id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_bom_id`(`bom_id`) USING BTREE,
  INDEX `fk_phosphor_id`(`phosphor_id`) USING BTREE,
  CONSTRAINT `fk_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `t_bom` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_phosphor_id` FOREIGN KEY (`phosphor_id`) REFERENCES `t_phosphor` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom与荧光粉对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_bom_chip
-- ----------------------------
DROP TABLE IF EXISTS `t_bom_chip`;
CREATE TABLE `t_bom_chip`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bom_id` bigint(20) NOT NULL COMMENT 'bom_id',
  `chip_id` bigint(20) NOT NULL COMMENT '芯片id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom与芯片关系表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '推荐BOM时选择的禁用和必选的荧光粉' ROW_FORMAT = Dynamic;

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
  `gule_hight_lsl` double NULL DEFAULT NULL COMMENT '胶体高度下限',
  `gule_hight_usl` double NULL DEFAULT NULL COMMENT '胶体高度上限',
  `bom_id` bigint(20) NOT NULL COMMENT 'bomId',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_t_bom_target_parameter_bom_id`(`bom_id`) USING BTREE,
  CONSTRAINT `fk_t_bom_target_parameter_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `t_bom` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '推荐BOM时的机种目标参数' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '芯片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_chip
-- ----------------------------
INSERT INTO `t_chip` VALUES (1, NULL, 'S-DICE-BXCD12364', '', '开发晶', '42', 3.5, 0, 350, 310, NULL, NULL, 350, 310, NULL, '2019-12-09 17:17:42', 0, 0);
INSERT INTO `t_chip` VALUES (2, NULL, 'S-DICE-BXCD1234', '', '开发晶', '42', 3, 0, 100, 80, NULL, NULL, 100, 80, NULL, '2019-12-09 17:19:34', 0, 0);
INSERT INTO `t_chip` VALUES (3, NULL, 'S-DICE-BXCD1835', '', '开发晶', '120', 3.3, 2.8, 250, 230, NULL, NULL, 250, 230, NULL, '2019-12-09 17:21:18', 0, 0);
INSERT INTO `t_chip` VALUES (4, NULL, 'S-DICE-BXCD1026', '', '开发晶', '150', 3.3, 3, 340, 250, NULL, NULL, 340, 250, NULL, '2019-12-09 17:22:31', 0, 0);
INSERT INTO `t_chip` VALUES (5, NULL, 'DICE-BHA0K19H', '', '顺昌', '30', 20.5, 18.5, 270, 245, NULL, NULL, 270, 245, NULL, '2019-12-09 17:24:10', 0, 0);
INSERT INTO `t_chip` VALUES (6, NULL, 'S-DICE-BXCD1130', '', '开发晶', '150', 3.4, 0, 350, 300, NULL, NULL, 350, 300, NULL, '2019-12-09 17:25:17', 0, 0);
INSERT INTO `t_chip` VALUES (7, NULL, 'S-DICE-BXCD2630', '', '开发晶', '120', 3, 0, 260, 230, NULL, NULL, 260, 230, NULL, '2019-12-09 17:26:42', 0, 0);
INSERT INTO `t_chip` VALUES (8, NULL, 'DICE-BPAOI18D-F', '', '顺昌', '60', 3.3, 0, 115, 110, NULL, NULL, 115, 110, NULL, '2019-12-09 17:28:06', 1, 0);
INSERT INTO `t_chip` VALUES (9, NULL, 'DICE-BPA0I18D-F', '', '顺昌', '60', 3.3, 0, 115, 110, NULL, NULL, 115, 110, NULL, '2019-12-09 17:30:40', 0, 0);
INSERT INTO `t_chip` VALUES (10, NULL, 'DICE-BPA0I18D-S', '', '顺昌', '60', 3.4, 2.8, 200, 110, NULL, NULL, 200, 110, NULL, '2019-12-09 17:31:41', 0, 0);
INSERT INTO `t_chip` VALUES (11, NULL, 'DICE-BPA0I18F-F', '', '顺昌', '60', 3.3, 0, 115, 110, NULL, NULL, 115, 110, NULL, '2019-12-09 17:32:31', 0, 0);
INSERT INTO `t_chip` VALUES (12, NULL, 'DICE-K-18CBMJD', '', '三安', '60', 3.2, 2.9, 75, 65, NULL, NULL, 75, 65, NULL, '2019-12-09 17:55:52', 0, 0);
INSERT INTO `t_chip` VALUES (13, NULL, 'DICE-HL-Y19CB', '', '华磊', '60', 3.3, 2.9, 100, 85, NULL, NULL, 100, 85, NULL, '2019-12-12 09:28:46', 0, 0);
INSERT INTO `t_chip` VALUES (14, NULL, 'S-DICE-BXCD1029(X10B)', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-12-13 09:27:01', 0, 0);
INSERT INTO `t_chip` VALUES (15, NULL, 'S-DICE-BXCD2240', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-12-13 09:30:10', 0, 0);
INSERT INTO `t_chip` VALUES (16, NULL, 'DICE-CL-12A1WAF', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-12-16 14:19:56', 0, 0);
INSERT INTO `t_chip` VALUES (17, NULL, 'DICE_BXCD1734', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-12-27 16:40:36', 0, 0);
INSERT INTO `t_chip` VALUES (18, NULL, 'S-DICE-BXHV1931', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-12-28 14:38:27', 0, 0);
INSERT INTO `t_chip` VALUES (19, NULL, 'S-DICE-BXCD1835-M2', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-12-30 17:30:46', 0, 0);
INSERT INTO `t_chip` VALUES (20, NULL, 'BXCD1029(X10B)', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-02 16:19:44', 0, 0);
INSERT INTO `t_chip` VALUES (21, NULL, 'S-DICE-BXCD1734', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2020-01-16 15:38:51', 0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 95 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '芯片波段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_chip_wl_rank
-- ----------------------------
INSERT INTO `t_chip_wl_rank` VALUES (1, '波段1', 1, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (2, '波段2', 1, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (3, '波段3', 1, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (4, '波段4', 1, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (5, '波段5', 1, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (6, '波段1', 2, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (7, '波段2', 2, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (8, '波段3', 2, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (9, '波段4', 2, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (10, '波段5', 2, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (11, '波段1', 3, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (12, '波段2', 3, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (13, '波段3', 3, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (14, '波段4', 3, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (15, '波段1', 4, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (16, '波段2', 4, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (17, '波段3', 4, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (18, '波段4', 4, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (19, '波段1', 5, 448, 446, 0);
INSERT INTO `t_chip_wl_rank` VALUES (20, '波段2', 5, 450, 448, 0);
INSERT INTO `t_chip_wl_rank` VALUES (21, '波段3', 5, 452, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (22, '波段4', 5, 454, 452, 0);
INSERT INTO `t_chip_wl_rank` VALUES (23, '波段5', 5, 456, 454, 0);
INSERT INTO `t_chip_wl_rank` VALUES (24, '波段6', 5, 458, 456, 0);
INSERT INTO `t_chip_wl_rank` VALUES (25, '波段1', 6, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (26, '波段2', 6, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (27, '波段3', 6, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (28, '波段4', 6, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (29, '波段5', 6, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (30, '波段1', 7, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (31, '波段2', 7, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (32, '波段3', 7, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (33, '波段4', 7, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (34, '波段5', 7, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (35, '波段1', 8, 447.5, 445, 0);
INSERT INTO `t_chip_wl_rank` VALUES (36, '波段2', 8, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (37, '波段3', 8, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (38, '波段4', 8, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (39, '波段5', 8, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (40, '波段6', 8, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (41, '波段1', 9, 447.5, 445, 0);
INSERT INTO `t_chip_wl_rank` VALUES (42, '波段2', 9, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (43, '波段3', 9, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (44, '波段4', 9, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (45, '波段5', 9, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (46, '波段6', 9, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (47, '波段1', 10, 445, 442.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (48, '波段2', 10, 447.5, 445, 0);
INSERT INTO `t_chip_wl_rank` VALUES (49, '波段3', 10, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (50, '波段4', 10, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (51, '波段5', 10, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (52, '波段6', 10, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (53, '波段7', 10, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (54, '波段8', 10, 462.5, 460, 0);
INSERT INTO `t_chip_wl_rank` VALUES (55, '波段1', 11, 447.5, 445, 0);
INSERT INTO `t_chip_wl_rank` VALUES (56, '波段2', 11, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (57, '波段3', 11, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (58, '波段4', 11, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (59, '波段5', 11, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (60, '波段6', 11, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (61, '波段1', 12, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (62, '波段2', 12, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (63, '波段3', 12, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (64, '波段4', 12, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (65, '波段1', 13, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (66, '波段2', 13, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (67, '波段3', 13, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (68, '波段4', 13, 447.5, 445, 0);
INSERT INTO `t_chip_wl_rank` VALUES (69, '波段5', 13, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (70, '波段6', 13, 460, 457.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (71, '波段1', 14, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (72, '波段2', 14, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (73, '波段3', 14, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (74, '波段1', 15, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (75, '波段2', 15, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (76, '波段3', 15, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (77, '波段1', 16, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (78, '波段2', 16, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (79, '波段3', 16, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (80, '波段1', 17, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (81, '波段2', 17, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (82, '波段1', 18, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (83, '波段2', 18, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (84, '波段3', 18, 457.5, 455, 0);
INSERT INTO `t_chip_wl_rank` VALUES (85, '波段1', 19, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (86, '波段2', 19, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (87, '波段3', 19, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (88, '波段1', 20, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (89, '波段2', 20, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (90, '波段3', 20, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (91, '波段4', 14, 450, 447.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (92, '波段1', 21, 452.5, 450, 0);
INSERT INTO `t_chip_wl_rank` VALUES (93, '波段2', 21, 455, 452.5, 0);
INSERT INTO `t_chip_wl_rank` VALUES (94, '波段3', 21, 450, 447.5, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种对应的色区' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '常规色区-四边形色区' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '扩散粉' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_eqpt
-- ----------------------------
INSERT INTO `t_eqpt` VALUES (1, NULL, 1, 4, NULL, 0, 'JAZM-GS101-17070267', 0, '2019-12-09 16:55:42', 0);
INSERT INTO `t_eqpt` VALUES (2, NULL, 2, 4, NULL, 0, 'MLSD-GS101-17080006', 0, '2019-12-09 16:55:57', 0);
INSERT INTO `t_eqpt` VALUES (3, NULL, 3, 4, NULL, 0, 'MLSD-GS101-17090003', 0, '2019-12-09 16:56:11', 0);
INSERT INTO `t_eqpt` VALUES (4, NULL, 4, 4, NULL, 0, 'MLSD-GS101-17090006', 0, '2019-12-09 16:56:24', 0);
INSERT INTO `t_eqpt` VALUES (5, NULL, 5, 4, NULL, 0, 'MLS-GS101-18030019', 0, '2019-12-09 16:56:45', 0);
INSERT INTO `t_eqpt` VALUES (6, NULL, 6, 4, NULL, 0, 'MLS-GS101-18030020', 0, '2019-12-09 16:57:00', 0);
INSERT INTO `t_eqpt` VALUES (7, NULL, 7, 4, NULL, 0, 'MLS-GS101-18030023', 0, '2019-12-09 16:57:21', 0);
INSERT INTO `t_eqpt` VALUES (8, NULL, 8, 4, NULL, 0, 'MLS-GS101-18030027', 0, '2019-12-09 16:57:34', 0);
INSERT INTO `t_eqpt` VALUES (9, NULL, 9, 4, NULL, 0, 'MLS-GS101-18030028', 0, '2019-12-09 16:57:48', 0);
INSERT INTO `t_eqpt` VALUES (10, NULL, 10, 4, NULL, 0, 'MLS-GS101-18030029', 0, '2019-12-09 16:58:01', 0);
INSERT INTO `t_eqpt` VALUES (11, NULL, 11, 4, NULL, 0, 'MLS-GS101-18030031', 0, '2019-12-09 16:58:13', 0);
INSERT INTO `t_eqpt` VALUES (12, NULL, 12, 4, NULL, 0, 'MLS-GS101-18030040', 0, '2019-12-09 16:58:29', 0);
INSERT INTO `t_eqpt` VALUES (13, NULL, 13, 4, NULL, 0, 'MLS-GS101-18060006', 0, '2019-12-09 16:58:41', 0);
INSERT INTO `t_eqpt` VALUES (14, NULL, 14, 4, NULL, 0, 'MLS-GS101-18060009', 0, '2019-12-09 16:58:56', 0);
INSERT INTO `t_eqpt` VALUES (15, NULL, 15, 4, NULL, 0, 'MLS-GS101-18090007', 0, '2019-12-09 16:59:10', 0);
INSERT INTO `t_eqpt` VALUES (16, NULL, 16, 4, NULL, 0, 'MLS-GS101-18090011', 0, '2019-12-09 16:59:21', 0);
INSERT INTO `t_eqpt` VALUES (17, NULL, 17, 4, NULL, 0, 'MLS-GS101-18100001', 0, '2019-12-09 16:59:33', 0);
INSERT INTO `t_eqpt` VALUES (18, NULL, 18, 4, NULL, 0, 'MLS-GS101-18100002', 0, '2019-12-09 16:59:46', 0);
INSERT INTO `t_eqpt` VALUES (19, NULL, 19, 4, NULL, 0, 'MLS-GS101-18100003', 0, '2019-12-09 16:59:58', 0);
INSERT INTO `t_eqpt` VALUES (20, NULL, 20, 4, NULL, 0, 'MLS-GS101-18100005', 0, '2019-12-09 17:00:17', 0);
INSERT INTO `t_eqpt` VALUES (21, NULL, 21, 4, NULL, 0, 'MLS-GS101-18100006', 0, '2019-12-09 17:00:40', 0);
INSERT INTO `t_eqpt` VALUES (22, NULL, 22, 4, NULL, 0, 'MLS-GS101-18100007', 0, '2019-12-09 17:00:54', 0);
INSERT INTO `t_eqpt` VALUES (23, NULL, 23, 4, NULL, 0, 'MLS-GS101-18100008', 0, '2019-12-09 17:01:08', 0);
INSERT INTO `t_eqpt` VALUES (24, NULL, 24, 4, NULL, 0, 'MLS-GS101-18100009', 0, '2019-12-09 17:01:21', 0);
INSERT INTO `t_eqpt` VALUES (25, NULL, 25, 4, NULL, 0, 'MLS-GS101-18100011', 0, '2019-12-09 17:01:38', 0);
INSERT INTO `t_eqpt` VALUES (26, NULL, 26, 4, NULL, 0, 'MLS-GS101-18100012', 0, '2019-12-09 17:01:52', 0);
INSERT INTO `t_eqpt` VALUES (27, NULL, 27, 4, NULL, 0, 'MLS-GS101-18100013', 0, '2019-12-09 17:02:11', 0);
INSERT INTO `t_eqpt` VALUES (28, NULL, 28, 4, NULL, 0, 'MLS-GS101-18100016', 0, '2019-12-09 17:02:30', 0);
INSERT INTO `t_eqpt` VALUES (29, NULL, 29, 4, NULL, 0, 'MLS-GS101-18100018', 0, '2019-12-09 17:02:53', 0);
INSERT INTO `t_eqpt` VALUES (30, NULL, 30, 4, NULL, 0, 'MLS-GS101-18110004', 0, '2019-12-09 17:03:06', 0);
INSERT INTO `t_eqpt` VALUES (31, NULL, 31, 4, NULL, 0, 'MLS-GS101-18110005', 0, '2019-12-09 17:03:22', 0);
INSERT INTO `t_eqpt` VALUES (32, NULL, 32, 4, NULL, 0, 'MLS-GS101-18110006', 0, '2019-12-09 17:03:34', 0);
INSERT INTO `t_eqpt` VALUES (33, NULL, 33, 4, NULL, 0, 'MLS-GS101-18110007', 0, '2019-12-09 17:03:48', 0);
INSERT INTO `t_eqpt` VALUES (34, NULL, 34, 4, NULL, 0, 'MLS-GS101-18110016', 0, '2019-12-09 17:04:04', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备阀体表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_eqpt_valve
-- ----------------------------
INSERT INTO `t_eqpt_valve` VALUES (1, 1, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (2, 1, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (3, 2, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (4, 2, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (5, 3, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (6, 3, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (7, 4, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (8, 4, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (9, 5, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (10, 5, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (11, 6, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (12, 6, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (13, 7, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (14, 7, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (15, 8, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (16, 8, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (17, 9, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (18, 9, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (19, 10, '18位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (20, 10, '18位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (21, 11, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (22, 11, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (23, 12, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (24, 12, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (25, 13, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (26, 13, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (27, 14, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (28, 14, '16位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (29, 15, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (30, 15, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (31, 16, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (32, 16, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (33, 17, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (34, 17, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (35, 18, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (36, 18, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (37, 19, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (38, 19, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (39, 20, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (40, 20, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (41, 21, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (42, 21, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (43, 22, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (44, 22, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (45, 23, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (46, 23, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (47, 24, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (48, 24, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (49, 25, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (50, 25, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (51, 26, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (52, 26, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (53, 27, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (54, 27, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (55, 28, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (56, 28, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (57, 29, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (58, 29, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (59, 30, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (60, 30, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (61, 31, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (62, 31, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (63, 32, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (64, 32, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (65, 33, '6位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (66, 33, '6位阀-右', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (67, 34, '16位阀-左', '', 0);
INSERT INTO `t_eqpt_valve` VALUES (68, 34, '16位阀-右', '', 0);

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
INSERT INTO `t_eqpt_valve_state_df` VALUES (1, '待生产', 1, '2019-12-09 16:46:17');
INSERT INTO `t_eqpt_valve_state_df` VALUES (2, '生产中', 2, '2019-12-09 16:46:17');
INSERT INTO `t_eqpt_valve_state_df` VALUES (3, '阀体NG', 3, '2019-12-09 16:46:17');
INSERT INTO `t_eqpt_valve_state_df` VALUES (4, '已关闭', 4, '2019-12-09 16:46:17');

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
INSERT INTO `t_feed_exception_reason` VALUES (1, '无芯片', 1, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (2, '无支架', 2, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (3, '无荧光粉', 3, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (4, '胶水规格不足两种', 4, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (5, '芯片超过一种', 5, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (6, '支架超过一种', 6, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (7, '荧光粉超过四种', 7, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (8, '抗沉淀粉超过一种', 8, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (9, '扩散粉超过一种', 9, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (10, '抗沉淀粉与扩散粉同时存在', 10, '2019-12-09 16:46:17');
INSERT INTO `t_feed_exception_reason` VALUES (11, '胶水规格超过两种', 11, '2019-12-09 16:46:17');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '胶水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_glue
-- ----------------------------
INSERT INTO `t_glue` VALUES (1, 1, 10, '2019-12-09 17:11:58', 0, 0);
INSERT INTO `t_glue` VALUES (2, 1, 10, '2019-12-09 17:12:29', 0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '胶水详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_glue_dtl
-- ----------------------------
INSERT INTO `t_glue_dtl` VALUES (1, 1, 'A', NULL, 'WM-3321A', '', 8500, 6000, 70, 60, 1.2, '2019-12-09 17:11:58');
INSERT INTO `t_glue_dtl` VALUES (2, 1, 'B', NULL, 'WM-3321B', '', 8500, 6000, 70, 60, 1.2, '2019-12-09 17:11:58');
INSERT INTO `t_glue_dtl` VALUES (3, 2, 'A', NULL, 'MN-003A', '', 6000, 4000, 85, 70, 1.2, '2019-12-09 17:12:29');
INSERT INTO `t_glue_dtl` VALUES (4, 2, 'B', NULL, 'MN-003B', '', 6000, 4000, 85, 70, 1.2, '2019-12-09 17:12:29');

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
INSERT INTO `t_group` VALUES (1, 0, NULL, '木林森股份', NULL, '0', '0', 0, '2019-12-09 16:46:16');
INSERT INTO `t_group` VALUES (2, 1, NULL, '中山木林森电子', NULL, '0,1', '1', 0, '2019-12-09 16:46:16');
INSERT INTO `t_group` VALUES (3, 2, NULL, '照明器件', NULL, '0,1,2', '2', 0, '2019-12-09 16:46:16');
INSERT INTO `t_group` VALUES (4, 3, NULL, '五厂一部', '01.19.20.01.02.061', '0,1,2,3', '3', 0, '2019-12-09 16:46:16');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '模型与bom的关系, 单层工艺以一对一，双层工艺一对二' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_model_bom_chip_wl_rank
-- ----------------------------
DROP TABLE IF EXISTS `t_model_bom_chip_wl_rank`;
CREATE TABLE `t_model_bom_chip_wl_rank`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chip_wl_rank_id` bigint(20) NOT NULL COMMENT '芯片波段ID',
  `model_bom_id` bigint(20) NOT NULL COMMENT 't_model_bom 表的ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '生产搭配对应的芯片波段' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配比详细信息（配比库）' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求对应的非正常烤规则' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求与前测规则对应关系,单层工艺对应一条前测规则，双层工艺对应两条前测规则' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求与非正常烤规则对应关系，单层工艺对应一条前测规则，双层工艺对应两条前测规则' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种对应的出货需求,一个机种对应多个出货要求' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出货要求详情' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '荧光粉' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_phosphor
-- ----------------------------
INSERT INTO `t_phosphor` VALUES (1, NULL, 'NS525', '英特美', NULL, NULL, 14.422, NULL, 525, 4.7, 0.6463, 0.3532, NULL, '2019-12-09 17:15:43', 0, 0, 5);
INSERT INTO `t_phosphor` VALUES (2, NULL, 'NS565', '英特美', NULL, NULL, 15.327, NULL, 563, 4.7, 0.444, 0.5407, NULL, '2019-12-09 17:18:52', 0, 0, 5);
INSERT INTO `t_phosphor` VALUES (3, NULL, 'GAL532-M', '英特美', NULL, NULL, 20.196, NULL, 532, 4.8, 0.3702, 0.5708, NULL, '2019-12-09 17:21:44', 0, 0, 2);
INSERT INTO `t_phosphor` VALUES (4, NULL, 'GAL535-M', '英特美', NULL, NULL, 18.21, NULL, 533, 4.8, 0.36, 0.5678, NULL, '2019-12-09 17:21:31', 0, 0, 2);
INSERT INTO `t_phosphor` VALUES (5, NULL, 'GAL525-M', '英特美', NULL, NULL, 14.4, NULL, 523, 4.8, 0.3448, 0.5724, NULL, '2019-12-09 17:23:30', 0, 0, 2);
INSERT INTO `t_phosphor` VALUES (6, NULL, '阳光4号', '英特美', NULL, NULL, 17.9, NULL, 558, 4.8, 0.4461, 0.5366, NULL, '2019-12-09 17:24:36', 0, 0, 3);
INSERT INTO `t_phosphor` VALUES (7, NULL, '阳光5号', '英特美', NULL, NULL, 16.7, NULL, 550, 4.8, 0.4461, 0.5366, 133, '2019-12-09 17:29:24', 0, 0, 3);
INSERT INTO `t_phosphor` VALUES (8, NULL, '阳光525-15', '英特美', NULL, NULL, 17.283, NULL, 526, 4.8, 0.3512, 0.5692, 116, '2019-12-09 17:28:57', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (9, NULL, '阳光531-15', '英特美', NULL, NULL, 18.4, NULL, 531, 4.8, 0.3654, 0.5699, 114, '2019-12-09 17:28:51', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (10, NULL, '阳光535-15', '英特美', NULL, NULL, 18.1, NULL, 534, 4.8, 0.3739, 0.5701, 113, '2019-12-09 17:28:36', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (11, NULL, 'NS600', '英特美', NULL, NULL, 14.698, NULL, 599, 4.7, 0.5778, 0.4207, NULL, '2019-12-09 17:31:02', 0, 0, 5);
INSERT INTO `t_phosphor` VALUES (12, NULL, 'MLS628-02', '英特美', NULL, NULL, 15.9, NULL, 627, 3.2, 0.645, 0.3546, 75, '2019-12-09 17:33:54', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (13, NULL, 'MLS650', '英特美', NULL, NULL, 13.608, NULL, 651, 3.2, 0.6694, 0.3297, NULL, '2019-12-09 17:36:02', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (14, NULL, 'MLS615', '英特美', NULL, NULL, 14.492, NULL, 615, 3.2, 0.616, 0.3832, 75, '2019-12-09 17:37:27', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (15, NULL, 'MQ-010', '布莱特', NULL, NULL, 9, NULL, 655, 3.2, 0.675, 0.325, NULL, '2019-12-09 17:41:34', 0, 0, 13);
INSERT INTO `t_phosphor` VALUES (16, NULL, 'KSG-001', '英特美', NULL, NULL, 20.3, NULL, 521, 4.8, 0.337, 0.5818, NULL, '2019-12-09 17:47:24', 0, 0, 4);
INSERT INTO `t_phosphor` VALUES (17, NULL, 'MU-001', '博睿', NULL, NULL, 22.4, NULL, 537, 4.85, 0.38, 0.57, 107.7, '2019-12-09 17:48:13', 0, 0, 8);
INSERT INTO `t_phosphor` VALUES (18, NULL, 'MU-009', '博睿', NULL, NULL, 21.13, NULL, 554, 4.8, 0.442, 0.5399, 111, '2019-12-09 17:49:48', 0, 0, 10);
INSERT INTO `t_phosphor` VALUES (19, NULL, 'NS550-02', '英特美', NULL, NULL, 8.3, NULL, 545, 4.7, 0.399, 0.5711, NULL, '2019-12-09 17:49:54', 0, 0, 6);
INSERT INTO `t_phosphor` VALUES (20, NULL, 'R301', '英特美', NULL, NULL, 19.807, NULL, 631, 3.2, 0.6541, 0.3454, NULL, '2019-12-10 16:02:32', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (21, NULL, 'MU-007', '博睿', NULL, NULL, 14, NULL, 536, 4.85, 0.38, 0.574, 104.5, '2019-12-09 17:53:01', 0, 0, 10);
INSERT INTO `t_phosphor` VALUES (22, NULL, 'MU-008', '博睿', NULL, NULL, 13, NULL, 627, 3.8, 0.647, 0.352, 74, '2019-12-09 18:00:40', 0, 0, 10);
INSERT INTO `t_phosphor` VALUES (23, NULL, 'R201', '英特美', NULL, NULL, NULL, NULL, 627.5, 3.2, NULL, NULL, NULL, '2019-12-14 15:59:50', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (24, NULL, 'KSL210', '', NULL, NULL, NULL, NULL, 543, 4.8, NULL, NULL, NULL, '2019-12-11 09:37:46', 0, 0, 4);
INSERT INTO `t_phosphor` VALUES (25, NULL, 'IM-017', '', NULL, NULL, NULL, NULL, 625, 3.2, NULL, NULL, NULL, '2019-12-14 15:59:37', 0, 0, 7);
INSERT INTO `t_phosphor` VALUES (26, NULL, 'IM-019', '', NULL, NULL, NULL, NULL, 536, 4.8, NULL, NULL, NULL, '2019-12-12 09:30:42', 0, 0, 7);
INSERT INTO `t_phosphor` VALUES (27, NULL, 'MU-013-H', '博睿', NULL, NULL, NULL, NULL, 530, 4.8, NULL, NULL, NULL, '2019-12-12 20:26:57', 0, 0, 9);
INSERT INTO `t_phosphor` VALUES (28, NULL, 'IM-013H', '', NULL, NULL, NULL, NULL, 529.1, 4.8, NULL, NULL, NULL, '2019-12-14 10:18:13', 0, 0, 7);
INSERT INTO `t_phosphor` VALUES (29, NULL, 'MU-036', '', NULL, NULL, NULL, NULL, 626, 3.2, NULL, NULL, NULL, '2019-12-14 14:17:57', 0, 0, 8);
INSERT INTO `t_phosphor` VALUES (30, NULL, 'G101', '', NULL, NULL, NULL, NULL, 531, 4.8, 0.361, 0.568, NULL, '2019-12-14 15:50:15', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (31, NULL, 'G201', '', NULL, NULL, NULL, NULL, 533.5, 4.8, 0.372, 0.566, NULL, '2019-12-14 15:50:55', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (32, NULL, 'KSL410', '', NULL, NULL, NULL, NULL, 543.5, 4.8, 0.372, 0.566, NULL, '2019-12-14 15:54:46', 0, 0, 4);
INSERT INTO `t_phosphor` VALUES (33, NULL, 'MLS650-03', '', NULL, NULL, NULL, NULL, 649.5, 3.2, 0.669, 0.331, NULL, '2019-12-14 16:03:17', 0, 0, 1);
INSERT INTO `t_phosphor` VALUES (34, NULL, 'MU-028-H', '', NULL, NULL, NULL, NULL, 615, 3.2, NULL, NULL, NULL, '2019-12-16 14:21:37', 0, 0, 9);
INSERT INTO `t_phosphor` VALUES (35, NULL, 'MU-035', '', NULL, NULL, NULL, NULL, 542, 4.8, NULL, NULL, NULL, '2019-12-16 14:21:51', 0, 0, 8);
INSERT INTO `t_phosphor` VALUES (36, NULL, 'MU-008-H', '博瑞', NULL, NULL, NULL, NULL, 631, 3.8, NULL, NULL, NULL, '2019-12-18 08:43:31', 0, 0, 9);
INSERT INTO `t_phosphor` VALUES (37, NULL, 'KSL310', '', NULL, NULL, NULL, NULL, 535, 4.8, NULL, NULL, NULL, '2019-12-27 16:49:32', 0, 0, 4);

-- ----------------------------
-- Table structure for t_phosphor_type
-- ----------------------------
DROP TABLE IF EXISTS `t_phosphor_type`;
CREATE TABLE `t_phosphor_type`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '荧光粉类型名称',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false 正常、true 删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '荧光粉类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_phosphor_type
-- ----------------------------
INSERT INTO `t_phosphor_type` VALUES (1, '英特美阳光系列', 0);
INSERT INTO `t_phosphor_type` VALUES (2, '英特美GAL系列', 0);
INSERT INTO `t_phosphor_type` VALUES (3, '英特美YAG系列', 0);
INSERT INTO `t_phosphor_type` VALUES (4, '英特美KS系列', 0);
INSERT INTO `t_phosphor_type` VALUES (5, '英特美硅酸盐系列', 0);
INSERT INTO `t_phosphor_type` VALUES (6, '英特美硅酸盐细粉系列', 0);
INSERT INTO `t_phosphor_type` VALUES (7, '英特美IM系列', 0);
INSERT INTO `t_phosphor_type` VALUES (8, '博睿A类粉', 0);
INSERT INTO `t_phosphor_type` VALUES (9, '博睿B类粉', 0);
INSERT INTO `t_phosphor_type` VALUES (10, '博睿C类粉', 0);
INSERT INTO `t_phosphor_type` VALUES (11, '博睿硅酸盐细粉', 0);
INSERT INTO `t_phosphor_type` VALUES (12, '博睿铝酸盐细粉', 0);
INSERT INTO `t_phosphor_type` VALUES (13, '布莱特氮化物粉', 0);
INSERT INTO `t_phosphor_type` VALUES (14, '布莱特铝酸盐粉', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_role
-- ----------------------------
INSERT INTO `t_role` VALUES (1, 1, '超级管理员', '', 0, '2019-11-14 18:52:11');
INSERT INTO `t_role` VALUES (2, 4, '配比工程师', '', 0, '2019-12-09 17:36:04');
INSERT INTO `t_role` VALUES (3, 4, '配胶员', '', 0, '2019-12-11 10:01:06');
INSERT INTO `t_role` VALUES (4, 4, '测试员', '', 0, '2019-12-12 17:56:03');
INSERT INTO `t_role` VALUES (5, 2, '系统管理员', '', 0, '2019-12-13 16:19:26');
INSERT INTO `t_role` VALUES (6, 2, '生技工程师', '', 0, '2019-12-13 16:19:47');
INSERT INTO `t_role` VALUES (7, 2, '生产厂长', '', 0, '2019-12-13 16:20:01');

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
) ENGINE = InnoDB AUTO_INCREMENT = 323 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色权限表' ROW_FORMAT = Dynamic;

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
INSERT INTO `t_role_privilege` VALUES (67, 1, 67);
INSERT INTO `t_role_privilege` VALUES (68, 1, 68);
INSERT INTO `t_role_privilege` VALUES (69, 2, 1);
INSERT INTO `t_role_privilege` VALUES (70, 2, 2);
INSERT INTO `t_role_privilege` VALUES (71, 2, 3);
INSERT INTO `t_role_privilege` VALUES (72, 2, 4);
INSERT INTO `t_role_privilege` VALUES (73, 2, 5);
INSERT INTO `t_role_privilege` VALUES (74, 2, 6);
INSERT INTO `t_role_privilege` VALUES (75, 2, 7);
INSERT INTO `t_role_privilege` VALUES (76, 2, 8);
INSERT INTO `t_role_privilege` VALUES (77, 2, 9);
INSERT INTO `t_role_privilege` VALUES (78, 2, 10);
INSERT INTO `t_role_privilege` VALUES (79, 2, 11);
INSERT INTO `t_role_privilege` VALUES (80, 2, 12);
INSERT INTO `t_role_privilege` VALUES (81, 2, 13);
INSERT INTO `t_role_privilege` VALUES (82, 2, 14);
INSERT INTO `t_role_privilege` VALUES (83, 2, 15);
INSERT INTO `t_role_privilege` VALUES (84, 2, 16);
INSERT INTO `t_role_privilege` VALUES (85, 2, 17);
INSERT INTO `t_role_privilege` VALUES (86, 2, 24);
INSERT INTO `t_role_privilege` VALUES (87, 2, 25);
INSERT INTO `t_role_privilege` VALUES (88, 2, 26);
INSERT INTO `t_role_privilege` VALUES (89, 2, 27);
INSERT INTO `t_role_privilege` VALUES (90, 2, 28);
INSERT INTO `t_role_privilege` VALUES (91, 2, 29);
INSERT INTO `t_role_privilege` VALUES (92, 2, 30);
INSERT INTO `t_role_privilege` VALUES (93, 2, 31);
INSERT INTO `t_role_privilege` VALUES (94, 2, 32);
INSERT INTO `t_role_privilege` VALUES (95, 2, 33);
INSERT INTO `t_role_privilege` VALUES (96, 2, 34);
INSERT INTO `t_role_privilege` VALUES (97, 2, 35);
INSERT INTO `t_role_privilege` VALUES (98, 2, 36);
INSERT INTO `t_role_privilege` VALUES (99, 2, 37);
INSERT INTO `t_role_privilege` VALUES (100, 2, 38);
INSERT INTO `t_role_privilege` VALUES (101, 2, 39);
INSERT INTO `t_role_privilege` VALUES (102, 2, 40);
INSERT INTO `t_role_privilege` VALUES (103, 2, 41);
INSERT INTO `t_role_privilege` VALUES (104, 2, 42);
INSERT INTO `t_role_privilege` VALUES (105, 2, 43);
INSERT INTO `t_role_privilege` VALUES (106, 2, 44);
INSERT INTO `t_role_privilege` VALUES (107, 2, 45);
INSERT INTO `t_role_privilege` VALUES (108, 2, 46);
INSERT INTO `t_role_privilege` VALUES (109, 2, 47);
INSERT INTO `t_role_privilege` VALUES (110, 2, 48);
INSERT INTO `t_role_privilege` VALUES (111, 2, 49);
INSERT INTO `t_role_privilege` VALUES (112, 2, 50);
INSERT INTO `t_role_privilege` VALUES (113, 2, 51);
INSERT INTO `t_role_privilege` VALUES (114, 2, 52);
INSERT INTO `t_role_privilege` VALUES (115, 2, 53);
INSERT INTO `t_role_privilege` VALUES (116, 2, 67);
INSERT INTO `t_role_privilege` VALUES (117, 2, 68);
INSERT INTO `t_role_privilege` VALUES (118, 3, 1);
INSERT INTO `t_role_privilege` VALUES (119, 3, 2);
INSERT INTO `t_role_privilege` VALUES (120, 3, 3);
INSERT INTO `t_role_privilege` VALUES (121, 3, 4);
INSERT INTO `t_role_privilege` VALUES (122, 3, 5);
INSERT INTO `t_role_privilege` VALUES (123, 3, 6);
INSERT INTO `t_role_privilege` VALUES (124, 3, 7);
INSERT INTO `t_role_privilege` VALUES (125, 3, 8);
INSERT INTO `t_role_privilege` VALUES (126, 3, 9);
INSERT INTO `t_role_privilege` VALUES (127, 3, 27);
INSERT INTO `t_role_privilege` VALUES (128, 3, 28);
INSERT INTO `t_role_privilege` VALUES (129, 3, 33);
INSERT INTO `t_role_privilege` VALUES (130, 3, 68);
INSERT INTO `t_role_privilege` VALUES (131, 4, 1);
INSERT INTO `t_role_privilege` VALUES (132, 4, 2);
INSERT INTO `t_role_privilege` VALUES (133, 4, 3);
INSERT INTO `t_role_privilege` VALUES (134, 4, 4);
INSERT INTO `t_role_privilege` VALUES (135, 4, 5);
INSERT INTO `t_role_privilege` VALUES (136, 4, 6);
INSERT INTO `t_role_privilege` VALUES (137, 4, 7);
INSERT INTO `t_role_privilege` VALUES (138, 4, 8);
INSERT INTO `t_role_privilege` VALUES (139, 4, 9);
INSERT INTO `t_role_privilege` VALUES (140, 4, 10);
INSERT INTO `t_role_privilege` VALUES (141, 4, 11);
INSERT INTO `t_role_privilege` VALUES (142, 4, 12);
INSERT INTO `t_role_privilege` VALUES (143, 4, 13);
INSERT INTO `t_role_privilege` VALUES (144, 4, 14);
INSERT INTO `t_role_privilege` VALUES (145, 4, 15);
INSERT INTO `t_role_privilege` VALUES (146, 4, 16);
INSERT INTO `t_role_privilege` VALUES (147, 4, 17);
INSERT INTO `t_role_privilege` VALUES (148, 4, 27);
INSERT INTO `t_role_privilege` VALUES (149, 4, 28);
INSERT INTO `t_role_privilege` VALUES (150, 4, 34);
INSERT INTO `t_role_privilege` VALUES (151, 4, 35);
INSERT INTO `t_role_privilege` VALUES (152, 4, 36);
INSERT INTO `t_role_privilege` VALUES (153, 4, 37);
INSERT INTO `t_role_privilege` VALUES (154, 4, 38);
INSERT INTO `t_role_privilege` VALUES (155, 4, 50);
INSERT INTO `t_role_privilege` VALUES (156, 4, 68);
INSERT INTO `t_role_privilege` VALUES (157, 5, 1);
INSERT INTO `t_role_privilege` VALUES (158, 5, 2);
INSERT INTO `t_role_privilege` VALUES (159, 5, 3);
INSERT INTO `t_role_privilege` VALUES (160, 5, 4);
INSERT INTO `t_role_privilege` VALUES (161, 5, 5);
INSERT INTO `t_role_privilege` VALUES (162, 5, 6);
INSERT INTO `t_role_privilege` VALUES (163, 5, 7);
INSERT INTO `t_role_privilege` VALUES (164, 5, 8);
INSERT INTO `t_role_privilege` VALUES (165, 5, 9);
INSERT INTO `t_role_privilege` VALUES (166, 5, 10);
INSERT INTO `t_role_privilege` VALUES (167, 5, 11);
INSERT INTO `t_role_privilege` VALUES (168, 5, 12);
INSERT INTO `t_role_privilege` VALUES (169, 5, 13);
INSERT INTO `t_role_privilege` VALUES (170, 5, 14);
INSERT INTO `t_role_privilege` VALUES (171, 5, 15);
INSERT INTO `t_role_privilege` VALUES (172, 5, 16);
INSERT INTO `t_role_privilege` VALUES (173, 5, 17);
INSERT INTO `t_role_privilege` VALUES (174, 5, 18);
INSERT INTO `t_role_privilege` VALUES (175, 5, 19);
INSERT INTO `t_role_privilege` VALUES (176, 5, 20);
INSERT INTO `t_role_privilege` VALUES (177, 5, 21);
INSERT INTO `t_role_privilege` VALUES (178, 5, 22);
INSERT INTO `t_role_privilege` VALUES (179, 5, 23);
INSERT INTO `t_role_privilege` VALUES (180, 5, 24);
INSERT INTO `t_role_privilege` VALUES (181, 5, 25);
INSERT INTO `t_role_privilege` VALUES (182, 5, 26);
INSERT INTO `t_role_privilege` VALUES (183, 5, 27);
INSERT INTO `t_role_privilege` VALUES (184, 5, 28);
INSERT INTO `t_role_privilege` VALUES (185, 5, 29);
INSERT INTO `t_role_privilege` VALUES (186, 5, 30);
INSERT INTO `t_role_privilege` VALUES (187, 5, 31);
INSERT INTO `t_role_privilege` VALUES (188, 5, 32);
INSERT INTO `t_role_privilege` VALUES (189, 5, 33);
INSERT INTO `t_role_privilege` VALUES (190, 5, 34);
INSERT INTO `t_role_privilege` VALUES (191, 5, 35);
INSERT INTO `t_role_privilege` VALUES (192, 5, 36);
INSERT INTO `t_role_privilege` VALUES (193, 5, 37);
INSERT INTO `t_role_privilege` VALUES (194, 5, 38);
INSERT INTO `t_role_privilege` VALUES (195, 5, 39);
INSERT INTO `t_role_privilege` VALUES (196, 5, 40);
INSERT INTO `t_role_privilege` VALUES (197, 5, 41);
INSERT INTO `t_role_privilege` VALUES (198, 5, 42);
INSERT INTO `t_role_privilege` VALUES (199, 5, 43);
INSERT INTO `t_role_privilege` VALUES (200, 5, 44);
INSERT INTO `t_role_privilege` VALUES (201, 5, 45);
INSERT INTO `t_role_privilege` VALUES (202, 5, 46);
INSERT INTO `t_role_privilege` VALUES (203, 5, 47);
INSERT INTO `t_role_privilege` VALUES (204, 5, 48);
INSERT INTO `t_role_privilege` VALUES (205, 5, 49);
INSERT INTO `t_role_privilege` VALUES (206, 5, 50);
INSERT INTO `t_role_privilege` VALUES (207, 5, 51);
INSERT INTO `t_role_privilege` VALUES (208, 5, 52);
INSERT INTO `t_role_privilege` VALUES (209, 5, 53);
INSERT INTO `t_role_privilege` VALUES (210, 5, 54);
INSERT INTO `t_role_privilege` VALUES (211, 5, 55);
INSERT INTO `t_role_privilege` VALUES (212, 5, 56);
INSERT INTO `t_role_privilege` VALUES (213, 5, 57);
INSERT INTO `t_role_privilege` VALUES (214, 5, 58);
INSERT INTO `t_role_privilege` VALUES (215, 5, 59);
INSERT INTO `t_role_privilege` VALUES (216, 5, 60);
INSERT INTO `t_role_privilege` VALUES (217, 5, 61);
INSERT INTO `t_role_privilege` VALUES (218, 5, 62);
INSERT INTO `t_role_privilege` VALUES (219, 5, 63);
INSERT INTO `t_role_privilege` VALUES (220, 5, 64);
INSERT INTO `t_role_privilege` VALUES (221, 5, 65);
INSERT INTO `t_role_privilege` VALUES (222, 5, 66);
INSERT INTO `t_role_privilege` VALUES (223, 5, 67);
INSERT INTO `t_role_privilege` VALUES (224, 5, 68);
INSERT INTO `t_role_privilege` VALUES (225, 6, 1);
INSERT INTO `t_role_privilege` VALUES (226, 6, 2);
INSERT INTO `t_role_privilege` VALUES (227, 6, 3);
INSERT INTO `t_role_privilege` VALUES (228, 6, 4);
INSERT INTO `t_role_privilege` VALUES (229, 6, 5);
INSERT INTO `t_role_privilege` VALUES (230, 6, 6);
INSERT INTO `t_role_privilege` VALUES (231, 6, 7);
INSERT INTO `t_role_privilege` VALUES (232, 6, 8);
INSERT INTO `t_role_privilege` VALUES (233, 6, 9);
INSERT INTO `t_role_privilege` VALUES (234, 6, 10);
INSERT INTO `t_role_privilege` VALUES (235, 6, 11);
INSERT INTO `t_role_privilege` VALUES (236, 6, 12);
INSERT INTO `t_role_privilege` VALUES (237, 6, 13);
INSERT INTO `t_role_privilege` VALUES (238, 6, 14);
INSERT INTO `t_role_privilege` VALUES (239, 6, 15);
INSERT INTO `t_role_privilege` VALUES (240, 6, 16);
INSERT INTO `t_role_privilege` VALUES (241, 6, 17);
INSERT INTO `t_role_privilege` VALUES (242, 6, 24);
INSERT INTO `t_role_privilege` VALUES (243, 6, 25);
INSERT INTO `t_role_privilege` VALUES (244, 6, 26);
INSERT INTO `t_role_privilege` VALUES (245, 6, 27);
INSERT INTO `t_role_privilege` VALUES (246, 6, 28);
INSERT INTO `t_role_privilege` VALUES (247, 6, 29);
INSERT INTO `t_role_privilege` VALUES (248, 6, 30);
INSERT INTO `t_role_privilege` VALUES (249, 6, 31);
INSERT INTO `t_role_privilege` VALUES (250, 6, 32);
INSERT INTO `t_role_privilege` VALUES (251, 6, 33);
INSERT INTO `t_role_privilege` VALUES (252, 6, 34);
INSERT INTO `t_role_privilege` VALUES (253, 6, 35);
INSERT INTO `t_role_privilege` VALUES (254, 6, 36);
INSERT INTO `t_role_privilege` VALUES (255, 6, 37);
INSERT INTO `t_role_privilege` VALUES (256, 6, 38);
INSERT INTO `t_role_privilege` VALUES (257, 6, 39);
INSERT INTO `t_role_privilege` VALUES (258, 6, 40);
INSERT INTO `t_role_privilege` VALUES (259, 6, 41);
INSERT INTO `t_role_privilege` VALUES (260, 6, 42);
INSERT INTO `t_role_privilege` VALUES (261, 6, 43);
INSERT INTO `t_role_privilege` VALUES (262, 6, 44);
INSERT INTO `t_role_privilege` VALUES (263, 6, 45);
INSERT INTO `t_role_privilege` VALUES (264, 6, 46);
INSERT INTO `t_role_privilege` VALUES (265, 6, 47);
INSERT INTO `t_role_privilege` VALUES (266, 6, 48);
INSERT INTO `t_role_privilege` VALUES (267, 6, 49);
INSERT INTO `t_role_privilege` VALUES (268, 6, 50);
INSERT INTO `t_role_privilege` VALUES (269, 6, 51);
INSERT INTO `t_role_privilege` VALUES (270, 6, 52);
INSERT INTO `t_role_privilege` VALUES (271, 6, 53);
INSERT INTO `t_role_privilege` VALUES (272, 6, 67);
INSERT INTO `t_role_privilege` VALUES (273, 6, 68);
INSERT INTO `t_role_privilege` VALUES (274, 7, 1);
INSERT INTO `t_role_privilege` VALUES (275, 7, 2);
INSERT INTO `t_role_privilege` VALUES (276, 7, 3);
INSERT INTO `t_role_privilege` VALUES (277, 7, 4);
INSERT INTO `t_role_privilege` VALUES (278, 7, 5);
INSERT INTO `t_role_privilege` VALUES (279, 7, 6);
INSERT INTO `t_role_privilege` VALUES (280, 7, 7);
INSERT INTO `t_role_privilege` VALUES (281, 7, 8);
INSERT INTO `t_role_privilege` VALUES (282, 7, 9);
INSERT INTO `t_role_privilege` VALUES (283, 7, 10);
INSERT INTO `t_role_privilege` VALUES (284, 7, 11);
INSERT INTO `t_role_privilege` VALUES (285, 7, 12);
INSERT INTO `t_role_privilege` VALUES (286, 7, 13);
INSERT INTO `t_role_privilege` VALUES (287, 7, 14);
INSERT INTO `t_role_privilege` VALUES (288, 7, 15);
INSERT INTO `t_role_privilege` VALUES (289, 7, 16);
INSERT INTO `t_role_privilege` VALUES (290, 7, 17);
INSERT INTO `t_role_privilege` VALUES (291, 7, 24);
INSERT INTO `t_role_privilege` VALUES (292, 7, 25);
INSERT INTO `t_role_privilege` VALUES (293, 7, 26);
INSERT INTO `t_role_privilege` VALUES (294, 7, 27);
INSERT INTO `t_role_privilege` VALUES (295, 7, 28);
INSERT INTO `t_role_privilege` VALUES (296, 7, 29);
INSERT INTO `t_role_privilege` VALUES (297, 7, 30);
INSERT INTO `t_role_privilege` VALUES (298, 7, 31);
INSERT INTO `t_role_privilege` VALUES (299, 7, 32);
INSERT INTO `t_role_privilege` VALUES (300, 7, 33);
INSERT INTO `t_role_privilege` VALUES (301, 7, 34);
INSERT INTO `t_role_privilege` VALUES (302, 7, 35);
INSERT INTO `t_role_privilege` VALUES (303, 7, 36);
INSERT INTO `t_role_privilege` VALUES (304, 7, 37);
INSERT INTO `t_role_privilege` VALUES (305, 7, 38);
INSERT INTO `t_role_privilege` VALUES (306, 7, 39);
INSERT INTO `t_role_privilege` VALUES (307, 7, 40);
INSERT INTO `t_role_privilege` VALUES (308, 7, 41);
INSERT INTO `t_role_privilege` VALUES (309, 7, 42);
INSERT INTO `t_role_privilege` VALUES (310, 7, 43);
INSERT INTO `t_role_privilege` VALUES (311, 7, 44);
INSERT INTO `t_role_privilege` VALUES (312, 7, 45);
INSERT INTO `t_role_privilege` VALUES (313, 7, 46);
INSERT INTO `t_role_privilege` VALUES (314, 7, 47);
INSERT INTO `t_role_privilege` VALUES (315, 7, 48);
INSERT INTO `t_role_privilege` VALUES (316, 7, 49);
INSERT INTO `t_role_privilege` VALUES (317, 7, 50);
INSERT INTO `t_role_privilege` VALUES (318, 7, 51);
INSERT INTO `t_role_privilege` VALUES (319, 7, 52);
INSERT INTO `t_role_privilege` VALUES (320, 7, 53);
INSERT INTO `t_role_privilege` VALUES (321, 7, 67);
INSERT INTO `t_role_privilege` VALUES (322, 7, 68);

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
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '支架' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_scaffold
-- ----------------------------
INSERT INTO `t_scaffold` VALUES (1, NULL, '2835_F1975_13_A4A22', '', NULL, 1, 1.45, 1.13, 3.4, 2.74, 0.4, '2019-12-09 17:06:01', 0, 0);
INSERT INTO `t_scaffold` VALUES (2, NULL, '2835G_F1975_20_A4A22', '', NULL, 1, 1.95, 1.36, 2.77, 2.35, 0.4, '2019-12-09 17:06:57', 0, 0);
INSERT INTO `t_scaffold` VALUES (3, NULL, '2835X_C2075_20_A4A24', '', NULL, 1, 1.8, 1.2, 2.64, 2.16, 0.43, '2019-12-09 17:07:20', 0, 0);
INSERT INTO `t_scaffold` VALUES (4, NULL, '2835H_C2075_30_A4C22', '', NULL, 1, 1.95, 1.481, 2.77, 2.35, 0.45, '2019-12-09 17:07:45', 0, 0);
INSERT INTO `t_scaffold` VALUES (5, NULL, '2835H_C2075_40_B5C22', '', NULL, 1, 1.95, 1.481, 2.77, 2.35, 0.45, '2019-12-09 17:08:08', 0, 0);
INSERT INTO `t_scaffold` VALUES (6, NULL, '2835K_C2075_60_B5C22', '', NULL, 1, 1.95, 1.481, 2.77, 2.35, 0.45, '2019-12-09 17:09:14', 0, 0);
INSERT INTO `t_scaffold` VALUES (7, NULL, '2835N_A2075_30_A4A22', '', NULL, 1, 1.96, 1.495, 2.772, 2.372, 0.45, '2019-12-09 17:09:43', 0, 0);
INSERT INTO `t_scaffold` VALUES (8, NULL, '2835P-A2075-60-B5C22', '', NULL, 1, 1.96, 1.495, 2.772, 2.372, 0.45, '2019-12-09 17:10:09', 0, 0);
INSERT INTO `t_scaffold` VALUES (9, NULL, '2835J_C2075_40_A10A22', '', NULL, 1, 2, 0.8, 2.8, 2.3, 0.47, '2019-12-09 17:10:33', 0, 0);
INSERT INTO `t_scaffold` VALUES (10, NULL, '2835Y_C2375_40_A13A22', '', NULL, 1, 1.915, 1.385, 2.765, 2.3, 0.45, '2019-12-09 17:11:00', 0, 0);
INSERT INTO `t_scaffold` VALUES (11, NULL, '2835A_C2075_30_A4A22', '', NULL, 0, 1.48, 2.3, 0.75, NULL, NULL, '2019-12-09 17:11:15', 0, 0);
INSERT INTO `t_scaffold` VALUES (12, NULL, '2835M_C2572_60_B5A20', '', NULL, 1, 2.08, 1.56, 2.92, 2.46, 0.45, '2019-12-09 17:11:38', 0, 0);
INSERT INTO `t_scaffold` VALUES (13, NULL, '2835E-20PCT-P0', '', NULL, 1, 2.08, 1.56, 2.92, 2.46, 0.45, '2019-12-09 17:12:00', 0, 0);
INSERT INTO `t_scaffold` VALUES (14, NULL, '2835E_H2572_60B10_B2A20', '', NULL, 1, 2.08, 1.56, 2.92, 2.46, 0.45, '2019-12-09 17:12:23', 0, 0);
INSERT INTO `t_scaffold` VALUES (15, NULL, '2835D_H2572_60_B2A20', '', NULL, 1, 2, 1.55, 2.75, 2.35, 0.45, '2019-12-09 17:12:42', 0, 0);
INSERT INTO `t_scaffold` VALUES (16, NULL, '2836A_C2072_20_A4A20', '', NULL, 1, 2.2, 1.4, 2.85, 2.2, 0.55, '2019-12-09 17:13:07', 0, 0);
INSERT INTO `t_scaffold` VALUES (17, NULL, '2836A_C2072_20B03_A4A20', '', NULL, 1, 2.2, 1.4, 2.85, 2.2, 0.55, '2019-12-09 17:13:26', 0, 0);
INSERT INTO `t_scaffold` VALUES (18, NULL, '2837A_C2572_60_B5A20', '', NULL, 0, 1.9, 2.2, 0.4, NULL, NULL, '2019-12-09 17:13:41', 0, 0);
INSERT INTO `t_scaffold` VALUES (19, NULL, '3030A_C2572_60_B5A18', '', NULL, 0, 2.1, 2.45, 0.38, NULL, NULL, '2019-12-09 17:13:57', 0, 0);
INSERT INTO `t_scaffold` VALUES (20, NULL, '3030M_C2572_60_B5A18', '', NULL, 0, 2.1, 2.45, 0.38, NULL, NULL, '2019-12-09 17:14:14', 0, 0);
INSERT INTO `t_scaffold` VALUES (21, NULL, '4014B_C2575_40_A4A36', '', NULL, 1, 2.5, 0.78, 3.4, 1.23, 0.4, '2019-12-09 17:14:35', 0, 0);
INSERT INTO `t_scaffold` VALUES (22, NULL, '020_C1560_30_A13A16', '', NULL, 1, 2, 0.35, 3.45, 0.45, 0.28, '2019-12-09 17:14:54', 0, 0);
INSERT INTO `t_scaffold` VALUES (23, NULL, '2835Y_C2375_40_A10A22', '', NULL, 1, 1.48, 1.68, 1.57, 1.21, 0.45, '2019-12-11 20:21:39', 1, 0);
INSERT INTO `t_scaffold` VALUES (24, NULL, '2835Y_C2375_40_A10A22', '', NULL, 1, 1.915, 1.385, 2.765, 2.3, 0.45, '2019-12-12 09:27:47', 0, 0);
INSERT INTO `t_scaffold` VALUES (25, NULL, '2835H_C2075_20_A4C22', '', NULL, 1, 1.95, 1.481, 2.77, 2.35, 0.45, '2019-12-14 09:55:25', 0, 0);

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
INSERT INTO `t_spc_base_rule` VALUES (1, 1, '控制图上有%m个点位于控制线以外', 1, NULL, '2020-05-19 14:20:26');
INSERT INTO `t_spc_base_rule` VALUES (2, 2, '连续%m点落在中心线的同一侧', 9, NULL, '2020-05-19 14:20:26');
INSERT INTO `t_spc_base_rule` VALUES (3, 3, '连续%m点递增或递减', 6, NULL, '2020-05-19 14:20:26');
INSERT INTO `t_spc_base_rule` VALUES (4, 4, '连续%m点中相邻点交替上下', 14, NULL, '2020-05-19 14:20:26');
INSERT INTO `t_spc_base_rule` VALUES (5, 5, '连续%m点中有%m点落在中心线同一侧的B区以外', 3, 3, '2020-05-19 14:20:26');
INSERT INTO `t_spc_base_rule` VALUES (6, 6, '连续%m点中有%m点落在中心线同一侧的C区之外', 5, 4, '2020-05-19 14:20:26');
INSERT INTO `t_spc_base_rule` VALUES (7, 7, '连续%m点落在C区之内', 15, NULL, '2020-05-19 14:20:26');
INSERT INTO `t_spc_base_rule` VALUES (8, 8, '连续%m点落在中心线两侧，但无%m点在C区之内', 8, 1, '2020-05-19 14:20:26');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '每一个机种对应对应的spc规则' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '每一个机种对应对应的spc规则详细' ROW_FORMAT = Dynamic;

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
INSERT INTO `t_task_state_df` VALUES (1, '待生产', 1, '2019-12-09 16:46:17');
INSERT INTO `t_task_state_df` VALUES (2, '试样前测中', 2, '2019-12-09 16:46:17');
INSERT INTO `t_task_state_df` VALUES (3, '试样前测NG', 3, '2019-12-09 16:46:17');
INSERT INTO `t_task_state_df` VALUES (4, '试样前测通过', 4, '2019-12-09 16:46:17');
INSERT INTO `t_task_state_df` VALUES (5, '试样品质测试NG', 5, '2019-12-09 16:46:17');
INSERT INTO `t_task_state_df` VALUES (6, '批量生产', 6, '2019-12-09 16:46:17');
INSERT INTO `t_task_state_df` VALUES (7, '批量生产中有阀体NG', 7, '2019-12-09 16:46:17');
INSERT INTO `t_task_state_df` VALUES (8, '工单关闭', 8, '2019-12-09 16:46:17');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种定义' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种点胶高度' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (1, 1, 'admin', 'admin', '4297f44b13955235245b2497399d7a93', 0, 0, '2019-11-17 16:53:49');
INSERT INTO `t_user` VALUES (2, 1, 'yunke_zlq', 'zhangluqi', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-09 16:54:54');
INSERT INTO `t_user` VALUES (3, 4, '刘湘丽', 'liuxiangli', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-09 17:36:25');
INSERT INTO `t_user` VALUES (4, 4, '陈伟柯', 'chenweike', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-09 17:36:52');
INSERT INTO `t_user` VALUES (5, 1, 'yunke_lh', 'luhuan', '96e79218965eb72c92a549dd5a330112', 0, 0, '2019-12-09 18:02:17');
INSERT INTO `t_user` VALUES (6, 4, '配胶员', 'peijiaoyua', 'e10adc3949ba59abbe56e057f20f883e', 0, 1, '2019-12-11 10:01:52');
INSERT INTO `t_user` VALUES (7, 4, '配胶员', 'peijiaoyuan', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-11 21:51:07');
INSERT INTO `t_user` VALUES (8, 4, '测试员', 'ceshiyuan', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-12 17:56:26');
INSERT INTO `t_user` VALUES (9, 2, '石红丽', 'shihongli', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-13 16:20:40');
INSERT INTO `t_user` VALUES (10, 2, '张丽英', 'zhangliying', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-13 16:21:13');
INSERT INTO `t_user` VALUES (11, 2, '韦升聪', 'weishengcong', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-13 16:22:12');
INSERT INTO `t_user` VALUES (12, 2, '陈杰', 'chenjie', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2019-12-13 16:22:33');

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user_role
-- ----------------------------
INSERT INTO `t_user_role` VALUES (1, 1, 1);
INSERT INTO `t_user_role` VALUES (2, 2, 1);
INSERT INTO `t_user_role` VALUES (3, 3, 2);
INSERT INTO `t_user_role` VALUES (4, 4, 2);
INSERT INTO `t_user_role` VALUES (5, 5, 1);
INSERT INTO `t_user_role` VALUES (7, 7, 3);
INSERT INTO `t_user_role` VALUES (8, 8, 4);
INSERT INTO `t_user_role` VALUES (9, 9, 5);
INSERT INTO `t_user_role` VALUES (10, 10, 6);
INSERT INTO `t_user_role` VALUES (11, 11, 6);
INSERT INTO `t_user_role` VALUES (12, 12, 7);

-- ----------------------------
-- View structure for bom_view
-- ----------------------------
DROP VIEW IF EXISTS `bom_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `bom_view` AS select `bom`.`bom_id` AS `bom_id`,`bom`.`scaffold_id` AS `scaffold_id`,`bom`.`glue_id` AS `glue_id`,`bom`.`anti_starch_id` AS `anti_starch_id`,`bom`.`diffusion_powder_id` AS `diffusion_powder_id`,`bom`.`chip_count` AS `chip_count`,`bom`.`chip_list` AS `chip_list`,count(`c`.`phosphor_id`) AS `phosphor_count`,group_concat(`c`.`phosphor_id` separator ',') AS `phosphor_list` from (((select `a`.`id` AS `bom_id`,`a`.`scaffold_id` AS `scaffold_id`,`a`.`glue_id` AS `glue_id`,`a`.`anti_starch_id` AS `anti_starch_id`,`a`.`diffusion_powder_id` AS `diffusion_powder_id`,count(`b`.`chip_id`) AS `chip_count`,group_concat(`b`.`chip_id` separator ',') AS `chip_list` from (`yk_ai_test`.`t_bom` `a` left join `yk_ai_test`.`t_bom_chip` `b` on((`a`.`id` = `b`.`bom_id`))) group by `a`.`id`)) `bom` left join `yk_ai_test`.`t_bom_Phosphor` `c` on((`bom`.`bom_id` = `c`.`bom_id`))) group by `bom`.`bom_id`;

-- ----------------------------
-- View structure for t_ai_model_dtl
-- ----------------------------
DROP VIEW IF EXISTS `t_ai_model_dtl`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `t_ai_model_dtl` AS select distinct `t_model_material_info`.`model_id` AS `model_id`,`t_model_material_info`.`type_machine_id` AS `type_machine_id`,`t_model_material_info`.`color_region_id` AS `color_region_id`,`t_model_material_info`.`output_require_machine_id` AS `output_require_machine_id`,`t_model_material_info`.`bom_id` AS `bom_id`,`t_model_material_info`.`chip_wl_rank_id` AS `chip_wl_rank_id`,`t_model_material_info`.`chip_wl_rank` AS `chip_wl_rank`,`t_model_material_info`.`phosphor_id_list` AS `phosphor_id_list`,`t_model_material_info`.`pcount` AS `pcount`,`t_model_material_info`.`anti_type` AS `anti_type`,`t_model_material_info`.`anti_starch_id` AS `anti_starch_id`,`t_model_material_info`.`diffusion_powder_id` AS `diffusion_powder_id`,`t_model_material_info`.`scaffold_id` AS `scaffold_id`,`t_model_material_info`.`chip_id` AS `chip_id`,`t_model_material_info`.`glue_id` AS `glue_id`,`yk_ai_test`.`t_glue`.`ratio_a` AS `ratio_a`,`yk_ai_test`.`t_glue`.`ratio_b` AS `ratio_b`,ifnull(`yk_ai_test`.`t_diffusion_powder`.`add_proportion`,`yk_ai_test`.`t_anti_starch`.`add_proportion`) AS `ratio_anti`,`yk_ai_test`.`t_type_machine`.`ra_target` AS `ra_target`,`yk_ai_test`.`t_output_requirements_dtl`.`cp_x` AS `cp_x`,`yk_ai_test`.`t_output_requirements_dtl`.`cp_y` AS `cp_y` from (((((((select `yk_ai_test`.`t_ai_model`.`id` AS `model_id`,`yk_ai_test`.`t_ai_model`.`type_machine_id` AS `type_machine_id`,`yk_ai_test`.`t_ai_model`.`color_region_id` AS `color_region_id`,`yk_ai_test`.`t_ai_model`.`output_require_machine_id` AS `output_require_machine_id`,`yk_ai_test`.`t_model_bom`.`bom_id` AS `bom_id`,`chip_wl_rank`.`chip_wl_rank_id` AS `chip_wl_rank_id`,`chip_wl_rank`.`chip_wl_rank` AS `chip_wl_rank`,`phosphor`.`phosphor_id_list` AS `phosphor_id_list`,`phosphor`.`pcount` AS `pcount`,(case when ((`tb`.`diffusion_powder_id` is not null) or (`tb`.`anti_starch_id` is not null)) then 0 else 1 end) AS `anti_type`,`tb`.`anti_starch_id` AS `anti_starch_id`,`tb`.`diffusion_powder_id` AS `diffusion_powder_id`,`tb`.`scaffold_id` AS `scaffold_id`,`chip`.`chip_id` AS `chip_id`,`tb`.`glue_id` AS `glue_id` from (((((`yk_ai_test`.`t_ai_model` left join `yk_ai_test`.`t_model_bom` on((`yk_ai_test`.`t_ai_model`.`id` = `yk_ai_test`.`t_model_bom`.`model_id`))) left join `yk_ai_test`.`t_bom` `tb` on((`yk_ai_test`.`t_model_bom`.`bom_id` = `tb`.`id`))) left join (select `yk_ai_test`.`t_bom_Phosphor`.`bom_id` AS `bom_id`,group_concat(`yk_ai_test`.`t_bom_Phosphor`.`phosphor_id` order by `yk_ai_test`.`t_bom_Phosphor`.`phosphor_id` ASC separator ',') AS `phosphor_id_list`,count(0) AS `pcount` from `yk_ai_test`.`t_bom_Phosphor` group by `yk_ai_test`.`t_bom_Phosphor`.`bom_id`) `phosphor` on((`phosphor`.`bom_id` = `tb`.`id`))) left join (select `a`.`model_bom_id` AS `model_bom_id`,group_concat(`a`.`chip_wl_rank_id` order by `a`.`chip_wl_rank_id` ASC separator ',') AS `chip_wl_rank_id`,(sum(`a`.`chip_wl_rank`) / count(0)) AS `chip_wl_rank` from (select `yk_ai_test`.`t_model_bom_chip_wl_rank`.`model_bom_id` AS `model_bom_id`,`yk_ai_test`.`t_model_bom_chip_wl_rank`.`chip_wl_rank_id` AS `chip_wl_rank_id`,((`yk_ai_test`.`t_chip_wl_rank`.`wl_min` + `yk_ai_test`.`t_chip_wl_rank`.`wl_max`) / 2) AS `chip_wl_rank` from (`yk_ai_test`.`t_model_bom_chip_wl_rank` left join `yk_ai_test`.`t_chip_wl_rank` on((`yk_ai_test`.`t_model_bom_chip_wl_rank`.`chip_wl_rank_id` = `yk_ai_test`.`t_chip_wl_rank`.`id`)))) `a` group by `a`.`model_bom_id`) `chip_wl_rank` on((`chip_wl_rank`.`model_bom_id` = `tb`.`id`))) left join (select `yk_ai_test`.`t_bom_chip`.`bom_id` AS `bom_id`,group_concat(`yk_ai_test`.`t_bom_chip`.`chip_id` order by `yk_ai_test`.`t_bom_chip`.`chip_id` ASC separator ',') AS `chip_id` from `yk_ai_test`.`t_bom_chip` group by `yk_ai_test`.`t_bom_chip`.`bom_id`) `chip` on((`chip`.`bom_id` = `tb`.`id`))) where ((`yk_ai_test`.`t_ai_model`.`is_delete` = 0) and (`yk_ai_test`.`t_ai_model`.`disabled` = 0)) group by `yk_ai_test`.`t_ai_model`.`id`,`yk_ai_test`.`t_ai_model`.`color_region_id`,`yk_ai_test`.`t_ai_model`.`output_require_machine_id`,`chip_wl_rank`.`chip_wl_rank_id`,`yk_ai_test`.`t_model_bom`.`bom_id`,`tb`.`scaffold_id`,`chip`.`chip_id`,`tb`.`glue_id`)) `t_model_material_info` left join `yk_ai_test`.`t_output_requirements_dtl` on((`yk_ai_test`.`t_output_requirements_dtl`.`output_require_id` = `t_model_material_info`.`output_require_machine_id`))) left join `yk_ai_test`.`t_type_machine` on((`yk_ai_test`.`t_type_machine`.`id` = `t_model_material_info`.`type_machine_id`))) left join `yk_ai_test`.`t_glue` on((`yk_ai_test`.`t_glue`.`id` = `t_model_material_info`.`glue_id`))) left join `yk_ai_test`.`t_diffusion_powder` on((`yk_ai_test`.`t_diffusion_powder`.`id` = `t_model_material_info`.`diffusion_powder_id`))) left join `yk_ai_test`.`t_anti_starch` on((`yk_ai_test`.`t_anti_starch`.`id` = `t_model_material_info`.`anti_starch_id`)));

-- ----------------------------
-- View structure for t_model_task_id_dtl
-- ----------------------------
DROP VIEW IF EXISTS `t_model_task_id_dtl`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `t_model_task_id_dtl` AS select `bs_task_state`.`model_id` AS `model_id`,`bs_task_state`.`task_id` AS `task_id`,`bs_task_state`.`id` AS `task_state_id`,`bs_task_state`.`create_time` AS `task_state_id_create_time`,`bs_task`.`create_time` AS `task_id_create_time`,`bs_task_state`.`task_df_id` AS `task_df_id`,`d_upload_file`.`id` AS `file_id`,`d_upload_file`.`create_time` AS `file_id_create_time`,`d_upload_file`.`classType` AS `classType`,`d_file_summary`.`euclidean_distance_x` AS `euclidean_distance_x`,`d_file_summary`.`euclidean_distance_y` AS `euclidean_distance_y` from (((`bs_task` left join `bs_task_state` on((`bs_task_state`.`task_id` = `bs_task`.`id`))) join `d_upload_file` on((`bs_task_state`.`id` = `d_upload_file`.`task_state_id`))) left join `d_file_summary` on((`d_upload_file`.`id` = `d_file_summary`.`file_id`))) where ((`d_upload_file`.`is_delete` = 0) and (`bs_task_state`.`is_retest` = FALSE) and (`d_file_summary`.`euclidean_distance_x` <= 0.003) and (`d_file_summary`.`euclidean_distance_y` <= 0.003) and (`d_file_summary`.`total_size` > 100) and (`bs_task_state`.`task_df_id` not in (1,3,5)));

SET FOREIGN_KEY_CHECKS = 1;
