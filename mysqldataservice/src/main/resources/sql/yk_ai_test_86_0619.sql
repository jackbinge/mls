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

 Date: 19/06/2020 10:41:37
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
  `system_task_type` int(11) NULL DEFAULT NULL COMMENT '0 EAS工单，1是纯打样工单',
  `close_user` bigint(20) NULL DEFAULT NULL COMMENT '关闭工单的用户',
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
  `model_id` bigint(20) NOT NULL COMMENT '当前状态对应的算法模型',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间/此条记录的生成时间',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '当前是否处于活动状态',
  `model_create_time` datetime(0) NOT NULL COMMENT '配方创建时间/修改时间',
  `ratio_create_time` datetime(0) NULL DEFAULT NULL COMMENT '配比创建时间/修改时间',
  `process_type` int(11) NOT NULL COMMENT '流程类型 0 主流程，1 打样流程',
  `process_create_time` datetime(0) NOT NULL COMMENT '流程开始时间(主流程为EAS工单投产的时间，打样流程为发起打样的时间)',
  `process_version` int(11) NOT NULL COMMENT '流程版本（主流程默认为0不变，打样流程从零开始 每发起一次 版本号+1，从 1开始计算）',
  `process_initiator` bigint(20) NOT NULL COMMENT ' 流程的发起人 （主流程为EAS投产人，打样流程为打样发起人）',
  `initiate_reason` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发起流程的原因 ',
  `model_version` int(11) NOT NULL COMMENT '配方版本 每次修改后加1 从0 开始',
  `ratio_version` int(11) NULL DEFAULT NULL COMMENT '配比版本 每次修改后加1 从0 开始',
  `model_creator` bigint(20) NOT NULL COMMENT '配方操作人/创建人 主流程第一个配方是 投产用户，打样流程的第一个配方操作人时发起打样流程的人',
  `ratio_creator` bigint(20) NULL DEFAULT NULL COMMENT '配比操作人/创建人 主流成第一个配比是 投产用户，打样流程的第一个配比操作人是发起打样流程的人',
  `rar9_type` tinyint(4) NULL DEFAULT 1 COMMENT '0 忽略 1不忽略',
  `ratio_source` int(11) NULL DEFAULT NULL COMMENT '配比来源 0 配比数据库中，1 系统推荐，2 用户编辑 没有配比时为null',
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
  `r9_yield` double NULL DEFAULT NULL COMMENT 'r9良率',
  `ra_target` double NULL DEFAULT NULL COMMENT '显色指数,目标值/ra系列',
  `ra_re_max` double NULL DEFAULT NULL COMMENT '限制范围上限，用于算法显指良率统计',
  `ra_re_min` double NULL DEFAULT NULL COMMENT '显色指数下限，用于算法显指良率统计',
  `r9` double NULL DEFAULT NULL COMMENT 'R9',
  `lumen_lsl` double NULL DEFAULT NULL COMMENT '流明下限',
  `lumen_usl` double NULL DEFAULT NULL COMMENT '流明上限    ',
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
  `judge_type` int(11) NULL DEFAULT NULL COMMENT '0 正常判定为 ok,1 NG 后改判,2 强制通过',
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
) ENGINE = InnoDB AUTO_INCREMENT = 154 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '从木林森EAS同步的工单，需要用户手动转为我们系统的工单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eas_wo
-- ----------------------------
INSERT INTO `eas_wo` VALUES (1, 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'MLSDZ-1-20200507-0080', '2020-05-07', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 1600000, 1600000, '2020-05-07', '2020-05-16', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (2, 'iWLw395sQPSBqec9roPOWR0NgN0=', 'MLSDZ-1-20200507-0081', '2020-05-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 90000000, 88856852, '2020-05-09', '2020-05-16', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (3, 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'MLSDZ-1-20200511-0126', '2020-05-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250013', 7474173, 7474173, '2020-05-11', '2020-05-19', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (4, 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'MLSDZ-1-20200511-0128', '2020-05-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdGAKJECefw', '06.03.03.001.0713', '2835白色贴片', 'S-BEN-57G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901240332', 5275609, 5275609, '2020-05-11', '2020-05-19', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (5, 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'MLSDZ-1-20200513-0080', '2020-05-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 100000000, 98000000, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (6, 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'MLSDZ-1-20200513-0081', '2020-05-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdGAKJECefw', '06.03.03.001.0713', '2835白色贴片', 'S-BEN-57G-11M-03-E01-L', 'MTR-0001', '标准生产', 'BOM201901240332', 101735, 0, '2020-05-13', '2020-05-20', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (7, 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'MLSDZ-1-20200514-0069', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABl5qWtECefw', '06.03.03.007.0420', '2835阳光色贴片', 'S-BEN-30S-11L-03-D0G-T', 'MTR-0001', '标准生产', 'BOM201908120128', 133335, 133335, '2020-05-14', '2020-05-23', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (8, 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'MLSDZ-1-20200514-0071', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190282', 2636243, 2548118, '2020-05-14', '2020-05-22', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (9, 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'MLSDZ-1-20200515-0044', '2020-05-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 1050000, 1050000, '2020-05-15', '2020-05-23', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (10, 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'MLSDZ-1-20200518-0018', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180064', 7102526, 7102526, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-06-18 11:37:59', NULL);
INSERT INTO `eas_wo` VALUES (11, 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'MLSDZ-1-20200518-0019', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtKtJECefw', '06.03.03.001.1127', '2835白色贴片', 'S-BEN-65E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180070', 702787, 8496, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (12, 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'MLSDZ-1-20200518-0021', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBVtpECefw', '06.03.03.007.0151', '2835阳光色贴片', 'S-BEN-30G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210369', 1511427, 1445000, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (13, 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'MLSDZ-1-20200518-0037', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3xtECefw', '06.03.03.007.0471', '2835阳光色贴片', 'S-BEN-30G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070049', 1406297, 1406297, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (14, 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'MLSDZ-1-20200518-0038', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3WVECefw', '06.03.03.001.1113', '2835白色贴片', 'S-BEN-50G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070044', 1401325, 1401325, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (15, 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'MLSDZ-1-20200518-0039', '2020-05-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph2NVECefw', '06.03.03.007.0473', '2835阳光色贴片', 'S-BEN-35G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070048', 1272221, 1272221, '2020-05-18', '2020-05-25', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (16, 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'MLSDZ-1-20200519-0001', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 70000000, 68600000, '2020-05-20', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (17, 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'MLSDZ-1-20200519-0021', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMycpECefw', '03.03.28.002.2071', '2835阳光色贴片', 'XEN-27G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290060', 610000, 518500, '2020-05-19', '2020-06-01', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (18, 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'MLSDZ-1-20200519-0022', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 2100000, 2016000, '2020-05-19', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (19, 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'MLSDZ-1-20200519-0085', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMsm1ECefw', '03.03.28.002.2072', '2835阳光色贴片', 'XEN-30G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290047', 570000, 484500, '2020-05-19', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (20, 'zbQ71UMATayD6LGFEomudB0NgN0=', 'MLSDZ-1-20200519-0086', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMycpECefw', '03.03.28.002.2071', '2835阳光色贴片', 'XEN-27G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290060', 1010000, 771320, '2020-05-19', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (21, 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'MLSDZ-1-20200519-0087', '2020-05-19', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMzipECefw', '03.03.28.002.2067', '2835阳光色贴片', 'XEN-30G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290042', 2500000, 2178000, '2020-05-19', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (22, 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'MLSDZ-1-20200521-0024', '2020-05-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 100000000, 98000000, '2020-05-21', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (23, '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'MLSDZ-1-20200521-0026', '2020-05-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo3bbFECefw', '06.03.03.001.1093', '2835白色贴片', 'S-BEN-50E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910180018', 1048224, 1048224, '2020-05-21', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (24, 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'MLSDZ-1-20200521-0027', '2020-05-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140026', 4005265, 4005265, '2020-05-21', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (25, '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'MLSDZ-1-20200521-0060', '2020-05-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010020', 1010215, 1010215, '2020-05-21', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (26, 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'MLSDZ-1-20200521-0061', '2020-05-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdi9ECefw', '06.03.03.007.0386', '2835阳光色贴片', 'S-BEN-28G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010019', 1002487, 922288, '2020-05-21', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (27, '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'MLSDZ-1-20200521-0062', '2020-05-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/NCFECefw', '06.03.03.007.0461', '2835阳光色贴片', 'S-BEN-30E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240304', 1043019, 1043019, '2020-05-21', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (28, 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'MLSDZ-1-20200521-0066', '2020-05-21', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 2350000, 2328250, '2020-05-21', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (29, 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'MLSDZ-1-20200522-0005', '2020-05-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBVtpECefw', '06.03.03.007.0151', '2835阳光色贴片', 'S-BEN-30G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210369', 1535385, 1466293, '2020-05-22', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (30, 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'MLSDZ-1-20200522-0006', '2020-05-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMqrRECefw', '06.03.03.001.0872', '2835白色贴片', 'S-BEN-50E-11M-03-F0E-9', 'MTR-0001', '标准生产', 'BOM201903140034', 5177114, 5041587, '2020-05-22', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (31, 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'MLSDZ-1-20200522-0009', '2020-05-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph4NFECefw', '06.03.03.001.1110', '2835白色贴片', 'S-BEN-40G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070041', 1233127, 1167036, '2020-05-22', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (32, 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'MLSDZ-1-20200522-0021', '2020-05-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 50000, 0, '2020-05-22', '2020-05-30', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (33, 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'MLSDZ-1-20200522-0024', '2020-05-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 2360000, 1005000, '2020-05-22', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (34, 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'MLSDZ-1-20200523-0013', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 40000000, 39200000, '2020-05-23', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (35, '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'MLSDZ-1-20200523-0017', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABi8Xc9ECefw', '06.03.03.007.0396', '2835阳光色贴片', 'S-BEN-30E-31H-09-JG7-4', 'MTR-0001', '标准生产', 'BOM201906170068', 1042654, 983616, '2020-05-23', '2020-05-31', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (36, 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'MLSDZ-1-20200523-0022', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph361ECefw', '06.03.03.007.0472', '2835阳光色贴片', 'S-BEN-35E-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070051', 1513665, 1371345, '2020-05-23', '2020-05-31', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (37, 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'MLSDZ-1-20200523-0023', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph269ECefw', '06.03.03.001.1118', '2835白色贴片', 'S-BEN-65G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070036', 1523904, 1437895, '2020-05-23', '2020-05-31', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (38, 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'MLSDZ-1-20200523-0024', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph2x1ECefw', '06.03.03.001.1115', '2835白色贴片', 'S-BEN-57G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070039', 519167, 519167, '2020-05-23', '2020-05-31', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (39, 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'MLSDZ-1-20200523-0025', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU2dECefw', '06.03.03.001.0964', '2835白色贴片', 'S-BEN-65E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010106', 103863, 103863, '2020-05-23', '2020-05-31', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (40, 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'MLSDZ-1-20200523-0026', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU9JECefw', '06.03.03.001.0962', '2835白色贴片', 'S-BEN-40E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010103', 102723, 102723, '2020-05-23', '2020-05-31', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (41, 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'MLSDZ-1-20200523-0027', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/aBBECefw', '06.03.03.001.1104', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-7', 'MTR-0001', '标准生产', 'BOM201910240296', 1520681, 1452250, '2020-05-23', '2020-05-31', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (42, 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'MLSDZ-1-20200523-0033', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABvbHRxECefw', '06.03.03.007.0499', '2835阳光色贴片', 'S-BEN-20G-11M-03-F7J-9', 'MTR-0001', '标准生产', 'BOM202005210081', 152159, 152159, '2020-05-23', '2020-05-31', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (43, 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'MLSDZ-1-20200523-0040', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMs4ZECefw', '03.03.28.001.3504', '2835白色贴片', 'XEN-50G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290068', 700000, 0, '2020-05-23', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (44, 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'MLSDZ-1-20200523-0041', '2020-05-23', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMy25ECefw', '03.03.28.001.3508', '2835白色贴片', 'XEN-50G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290073', 1650000, 741049, '2020-05-23', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (45, 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'MLSDZ-1-20200525-0078', '2020-05-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 100000000, 98000000, '2020-05-25', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (46, 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'MLSDZ-1-20200526-0010', '2020-05-26', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMsm1ECefw', '03.03.28.002.2072', '2835阳光色贴片', 'XEN-30G-31H-09-H06-C', 'MTR-0001', '标准生产', 'BOM202002290047', 700000, 523500, '2020-05-26', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (47, 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'MLSDZ-1-20200526-0016', '2020-05-26', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBVtpECefw', '06.03.03.007.0151', '2835阳光色贴片', 'S-BEN-30G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210369', 2503171, 2390528, '2020-05-26', '2020-06-02', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (48, 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'MLSDZ-1-20200527-0106', '2020-05-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 733510, 704170, '2020-05-27', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (49, 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'MLSDZ-1-20200527-0109', '2020-05-27', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 1214088, 1178681, '2020-05-27', '2020-06-03', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (50, 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'MLSDZ-1-20200528-0020', '2020-05-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190255', 2050195, 1723383, '2020-05-28', '2020-06-04', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (51, 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'MLSDZ-1-20200528-0036', '2020-05-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 21070, 21070, '2020-05-28', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (52, 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'MLSDZ-1-20200529-0050', '2020-05-29', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 100000000, 98000000, '2020-05-29', '2020-06-06', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (53, 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'MLSDZ-1-20200529-0054', '2020-05-28', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtJly5ECefw', '06.03.03.007.0491', '2835阳光色贴片', 'S-BEN-22E-11M-03-F0H-5', 'MTR-0001', '标准生产', 'BOM202002280009', 1063577, 0, '2020-05-28', '2020-06-04', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (54, '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'MLSDZ-1-20200529-0055', '2020-05-29', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtJnYBECefw', '06.03.03.001.1139', '2835白色贴片', 'S-BEN-40E-11M-03-F0H-5', 'MTR-0001', '标准生产', 'BOM202002280023', 1051800, 0, '2020-05-29', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (55, 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'MLSDZ-1-20200529-0070', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK2RECefw', '06.03.03.007.0480', '2835阳光色贴片', 'S-BEN-35E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180057', 2037777, 2002439, '2020-06-01', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (56, 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'MLSDZ-1-20200529-0086', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 4654769, 4654769, '2020-06-01', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (57, 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'MLSDZ-1-20200529-0089', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 2050676, 1958396, '2020-06-01', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (58, 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'MLSDZ-1-20200529-0092', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU9JECefw', '06.03.03.001.0962', '2835白色贴片', 'S-BEN-40E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010103', 7522104, 7371662, '2020-06-01', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (59, '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'MLSDZ-1-20200529-0094', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU9JECefw', '06.03.03.001.0962', '2835白色贴片', 'S-BEN-40E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010103', 3418307, 3349941, '2020-06-01', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (60, 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'MLSDZ-1-20200529-0097', '2020-05-29', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoE+7FECefw', '06.03.03.007.0441', '2835阳光色贴片', 'S-BEN-27E-21H-18-P54-6', 'MTR-0001', '标准生产', 'BOM201909280042', 1228912, 1171638, '2020-05-29', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (61, 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'MLSDZ-1-20200529-0099', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3xtECefw', '06.03.03.007.0471', '2835阳光色贴片', 'S-BEN-30G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070049', 2514687, 2401526, '2020-06-01', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (62, 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'MLSDZ-1-20200529-0100', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph2NVECefw', '06.03.03.007.0473', '2835阳光色贴片', 'S-BEN-35G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070048', 2515528, 2402329, '2020-06-01', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (63, 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'MLSDZ-1-20200529-0110', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250013', 5717013, 4704001, '2020-06-01', '2020-06-13', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (64, 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'MLSDZ-1-20200601-0011', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ3pZECefw', '06.03.03.007.0495', '2835全光谱机种', 'S-IEN-27R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060041', 32584, 24760, '2020-06-01', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (65, 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'MLSDZ-1-20200601-0012', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ9qlECefw', '06.03.03.007.0496', '2835全光谱机种', 'S-IEN-30R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060039', 16250, 7727, '2020-06-01', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (66, '12ROCjmgRHeE5juvu111Bx0NgN0=', 'MLSDZ-1-20200601-0013', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ215ECefw', '06.03.03.007.0497', '2835全光谱机种', 'S-IEN-35R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060040', 30693, 27911, '2020-06-01', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (67, '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'MLSDZ-1-20200601-0014', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ3VFECefw', '06.03.03.001.1144', '2835全光谱机种', 'S-IEN-40R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060035', 59666, 57613, '2020-06-01', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (68, '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'MLSDZ-1-20200601-0015', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU2dECefw', '06.03.03.001.0964', '2835白色贴片', 'S-BEN-65E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010106', 3200609, 3136597, '2020-06-01', '2020-06-18', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (69, 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'MLSDZ-1-20200601-0017', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABviP/FECefw', '06.03.03.007.0503', '2835阳光色贴片', 'S-BEN-27G-31H-09-JC6-P', 'MTR-0001', '标准生产', 'BOM202005270012', 101622, 89847, '2020-06-01', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (70, 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'MLSDZ-1-20200601-0018', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABviQTZECefw', '06.03.03.001.1153', '2835白色贴片', 'S-BEN-50G-31H-09-JC6-P', 'MTR-0001', '标准生产', 'BOM202005270024', 102580, 88375, '2020-06-01', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (71, '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'MLSDZ-1-20200601-0022', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBVtpECefw', '06.03.03.007.0151', '2835阳光色贴片', 'S-BEN-30G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210369', 2138576, 2042340, '2020-06-01', '2020-06-08', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (72, 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'MLSDZ-1-20200601-0024', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdi9ECefw', '06.03.03.007.0386', '2835阳光色贴片', 'S-BEN-28G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010019', 4160008, 3971262, '2020-06-01', '2020-06-08', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (73, 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'MLSDZ-1-20200601-0045', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABuQ3AFECefw', '06.03.03.001.1145', '2835全光谱机种', 'S-IEN-50R-11L-03-A01-A', 'MTR-0001', '标准生产', 'BOM202004060037', 19951, 18770, '2020-06-01', '2020-06-08', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (74, 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'MLSDZ-1-20200601-0064', '2020-06-01', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 20000, 20000, '2020-06-01', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (75, '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'MLSDZ-1-20200602-0081', '2020-06-02', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABviIslECefw', '06.03.03.001.1149', '2835白色贴片', 'S-BEN-50G-31H-09-JG6-P', 'MTR-0001', '标准生产', 'BOM202005270034', 100881, 86533, '2020-06-02', '2020-06-09', '无', NULL, 0, 4, '2020-06-18 11:38:00', NULL);
INSERT INTO `eas_wo` VALUES (76, '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'MLSDZ-1-20200602-0082', '2020-06-02', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABviOttECefw', '06.03.03.007.0500', '2835阳光色贴片', 'S-BEN-27G-31H-09-JG6-P', 'MTR-0001', '标准生产', 'BOM202005270033', 101397, 96163, '2020-06-02', '2020-06-09', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (77, '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'MLSDZ-1-20200602-0083', '2020-06-02', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3WVECefw', '06.03.03.001.1113', '2835白色贴片', 'S-BEN-50G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070044', 1072684, 1017789, '2020-06-02', '2020-06-09', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (78, '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'MLSDZ-1-20200602-0087', '2020-06-02', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMyT5ECefw', '03.03.28.002.2065', '2835阳光色贴片', 'XEN-27G-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290062', 20000, 20000, '2020-06-02', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (79, '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'MLSDZ-1-20200603-0093', '2020-06-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3NNECefw', '06.03.03.007.0468', '2835阳光色贴片', 'S-BEN-27G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070053', 1023943, 961390, '2020-06-03', '2020-06-10', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (80, 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'MLSDZ-1-20200603-0095', '2020-06-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph2x1ECefw', '06.03.03.001.1115', '2835白色贴片', 'S-BEN-57G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070039', 1046095, 998794, '2020-06-03', '2020-06-10', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (81, 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'MLSDZ-1-20200603-0096', '2020-06-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3xtECefw', '06.03.03.007.0471', '2835阳光色贴片', 'S-BEN-30G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070049', 18336680, 7117912, '2020-06-03', '2020-06-10', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (82, 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'MLSDZ-1-20200603-0097', '2020-06-03', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph2NVECefw', '06.03.03.007.0473', '2835阳光色贴片', 'S-BEN-35G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070048', 18054758, 7383190, '2020-06-03', '2020-06-10', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (83, 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'MLSDZ-1-20200604-0040', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 48000000, '2020-06-04', '2020-06-20', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (84, 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'MLSDZ-1-20200604-0085', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140026', 1493890, 1487879, '2020-06-04', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (85, 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'MLSDZ-1-20200604-0086', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/alpECefw', '06.03.03.001.1103', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240298', 3372675, 3305222, '2020-06-04', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (86, 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'MLSDZ-1-20200604-0087', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdi9ECefw', '06.03.03.007.0386', '2835阳光色贴片', 'S-BEN-28G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010019', 3552424, 918000, '2020-06-04', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (87, 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'MLSDZ-1-20200604-0088', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMq9ECefw', '06.03.03.001.0907', '2835白色贴片', 'S-BEN-65G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190269', 3310269, 646000, '2020-06-04', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (88, 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'MLSDZ-1-20200604-0089', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKc5ECefw', '06.03.03.001.0905', '2835白色贴片', 'S-BEN-40G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190256', 1002171, 722000, '2020-06-04', '2020-06-11', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (89, 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'MLSDZ-1-20200604-0099', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU9JECefw', '06.03.03.001.0962', '2835白色贴片', 'S-BEN-40E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010103', 3162032, 3098791, '2020-06-04', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (90, 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'MLSDZ-1-20200604-0100', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdBVtpECefw', '06.03.03.007.0151', '2835阳光色贴片', 'S-BEN-30G-31H-09-J21-1', 'MTR-0001', '标准生产', 'BOM201901210369', 3327437, 3124973, '2020-06-04', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (91, 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'MLSDZ-1-20200604-0101', '2020-06-04', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU2dECefw', '06.03.03.001.0964', '2835白色贴片', 'S-BEN-65E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010106', 1536239, 1467108, '2020-06-04', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (92, 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'MLSDZ-1-20200605-0063', '2020-06-05', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABqtK/hECefw', '06.03.03.001.1123', '2835白色贴片', 'S-BEN-40E-11M-03-BB7-D', 'MTR-0001', '标准生产', 'BOM201912180064', 13137259, 7089000, '2020-06-05', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (93, 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'MLSDZ-1-20200605-0064', '2020-06-05', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeMqrRECefw', '06.03.03.001.0872', '2835白色贴片', 'S-BEN-50E-11M-03-F0E-9', 'MTR-0001', '标准生产', 'BOM201903140034', 3144384, 0, '2020-06-05', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (94, '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'MLSDZ-1-20200605-0066', '2020-06-05', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyadECefw', '06.03.03.002.0011', '2835阳光色贴片', 'S-BEN-27G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210037', 1492153, 12486, '2020-06-05', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (95, 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'MLSDZ-1-20200605-0067', '2020-06-05', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU2dECefw', '06.03.03.001.0964', '2835白色贴片', 'S-BEN-65E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010106', 3318820, 2706295, '2020-06-05', '2020-06-12', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (96, 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'MLSDZ-1-20200606-0023', '2020-06-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 48000000, '2020-06-06', '2020-06-27', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (97, 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'MLSDZ-1-20200606-0039', '2020-06-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABJnRWtECefw', '03.03.28.001.1123', '2835白色贴片', 'E2835UW25', 'MTR-0001', '标准生产', 'BOM201804240031', 100000, 0, '2020-06-08', '2020-06-23', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (98, 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'MLSDZ-1-20200608-0004', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 23212000, '2020-06-08', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (99, '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'MLSDZ-1-20200608-0009', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/aBBECefw', '06.03.03.001.1104', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-7', 'MTR-0001', '标准生产', 'BOM201910240296', 509072, 155386, '2020-06-08', '2020-06-15', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (100, 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'MLSDZ-1-20200608-0033', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexP8lECefw', '06.03.03.001.0951', '2835白色贴片', 'S-BEN-40H-31H-09-JCC-E', 'MTR-0001', '标准生产', 'BOM201903260092', 583640, 0, '2020-06-08', '2020-06-15', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (101, 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'MLSDZ-1-20200608-0034', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU2dECefw', '06.03.03.001.0964', '2835白色贴片', 'S-BEN-65E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010106', 5724525, 0, '2020-06-08', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (102, 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'MLSDZ-1-20200608-0035', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/bTRECefw', '06.03.03.001.1105', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240294', 0, 0, '2020-06-08', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (103, 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'MLSDZ-1-20200608-0042', '2020-06-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABJnRWtECefw', '03.03.28.001.1123', '2835白色贴片', 'E2835UW25', 'MTR-0001', '标准生产', 'BOM201804240031', 30000000, 14280000, '2020-06-08', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (104, '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'MLSDZ-1-20200608-0057', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdVNECefw', '06.03.03.007.0388', '2835阳光色贴片', 'S-BEN-36G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010021', 1010064, 0, '2020-06-08', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (105, 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'MLSDZ-1-20200608-0058', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010020', 1688365, 1279025, '2020-06-08', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (106, 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'MLSDZ-1-20200608-0060', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexNk9ECefw', '06.03.03.001.0956', '2835白色贴片', 'S-BEN-57G-31H-09-JCA-E', 'MTR-0001', '标准生产', 'BOM201903260098', 3028424, 1870000, '2020-06-08', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (107, 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'MLSDZ-1-20200608-0061', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190255', 2003627, 0, '2020-06-08', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (108, '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'MLSDZ-1-20200608-0062', '2020-06-08', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMq9ECefw', '06.03.03.001.0907', '2835白色贴片', 'S-BEN-65G-31H-09-JE6-E', 'MTR-0001', '标准生产', 'BOM201903190269', 1703625, 0, '2020-06-08', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (109, '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'MLSDZ-1-20200609-0060', '2020-06-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140026', 2404128, 0, '2020-06-09', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (110, 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'MLSDZ-1-20200609-0061', '2020-06-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABfXU9JECefw', '06.03.03.001.0962', '2835白色贴片', 'S-BEN-40E-11L-03-BA4-6', 'MTR-0001', '标准生产', 'BOM201904010103', 11587188, 884606, '2020-06-09', '2020-06-16', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (111, 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'MLSDZ-1-20200609-0090', '2020-06-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 50000000, 0, '2020-06-09', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (112, 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'MLSDZ-1-20200609-0097', '2020-06-09', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 2000000, 1536577, '2020-06-09', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (113, 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'MLSDZ-1-20200610-0024', '2020-06-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMseFECefw', '03.03.28.002.2066', '2835阳光色贴片', 'XEN-27H-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290044', 50000, 50000, '2020-06-10', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (114, 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'MLSDZ-1-20200610-0027', '2020-06-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtasOBECefw', '03.03.28.001.3555', '2835白色贴片', 'XEN-65G-31H-09-H04-C', 'MTR-0001', '标准生产', 'BOM202003100067', 500000, 0, '2020-06-10', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (115, '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'MLSDZ-1-20200610-0071', '2020-06-10', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/alpECefw', '06.03.03.001.1103', '2835白色贴片', 'S-BEN-40E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240298', 8346692, 3711660, '2020-06-10', '2020-06-17', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (116, 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'MLSDZ-1-20200611-0003', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoC9WdECefw', '06.03.03.001.1083', '2835白色贴片', 'S-BEN-75G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201909270028', 3101986, 0, '2020-06-11', '2020-06-18', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (117, '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'MLSDZ-1-20200611-0004', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyadECefw', '06.03.03.002.0011', '2835阳光色贴片', 'S-BEN-27G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210037', 2174416, 0, '2020-06-11', '2020-06-18', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (118, 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'MLSDZ-1-20200611-0005', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 3203573, 481047, '2020-06-11', '2020-06-18', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (119, 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'MLSDZ-1-20200611-0012', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABv+UWJECefw', '06.03.03.007.0506', '2835阳光色贴片', 'S-BEN-20G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM202006040041', 1516503, 0, '2020-06-11', '2020-06-18', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (120, 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'MLSDZ-1-20200611-0013', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3NNECefw', '06.03.03.007.0468', '2835阳光色贴片', 'S-BEN-27G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070053', 2527225, 0, '2020-06-11', '2020-06-18', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (121, '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'MLSDZ-1-20200611-0015', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABph3WVECefw', '06.03.03.001.1113', '2835白色贴片', 'S-BEN-50G-11L-03-D0H-B', 'MTR-0001', '标准生产', 'BOM201911070044', 1256333, 0, '2020-06-11', '2020-06-18', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (122, 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'MLSDZ-1-20200611-0016', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABJnRWtECefw', '03.03.28.001.1123', '2835白色贴片', 'E2835UW25', 'MTR-0001', '标准生产', 'BOM201804240031', 35000000, 0, '2020-06-11', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (123, 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'MLSDZ-1-20200611-0040', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMseFECefw', '03.03.28.002.2066', '2835阳光色贴片', 'XEN-27H-31H-09-H15-C', 'MTR-0001', '标准生产', 'BOM202002290044', 1500000, 0, '2020-06-11', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (124, 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'MLSDZ-1-20200611-0076', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABlG8GRECefw', '06.03.03.007.0409', '2835阳光色贴片', 'S-BEN-27G-21H-18-P58-5', 'MTR-0001', '标准生产', 'BOM201907310009', 1077699, 0, '2020-06-11', '2020-06-18', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (125, 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'MLSDZ-1-20200611-0078', '2020-06-11', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABo/bTRECefw', '06.03.03.001.1105', '2835白色贴片', 'S-BEN-50E-11L-03-BB7-E', 'MTR-0001', '标准生产', 'BOM201910240294', 5763633, 0, '2020-06-11', '2020-06-19', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (126, 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'MLSDZ-1-20200612-0075', '2020-06-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140026', 2837352, 0, '2020-06-12', '2020-06-19', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (127, 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'MLSDZ-1-20200612-0076', '2020-06-12', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABoyykJECefw', '06.03.03.007.0445', '2835阳光色贴片', 'S-BEN-27E-21H-36-R25-4', 'MTR-0001', '标准生产', 'BOM201910140026', 1742234, 0, '2020-06-12', '2020-06-19', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (128, 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'MLSDZ-1-20200613-0016', '2020-06-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 80000000, 0, '2020-06-13', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (129, 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'MLSDZ-1-20200613-0030', '2020-06-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAAz65hNECefw', '03.03.28.001.0653', '2835白色贴片', 'E2835UW105-2B', 'MTR-0001', '标准生产', 'BOM201806120006', 100000, 0, '2020-06-13', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (130, 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'MLSDZ-1-20200613-0070', '2020-06-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABpiwvBECefw', '03.03.28.001.3212', '2835白色贴片', 'G2835UW50', 'MTR-0001', '标准生产', 'BOM201911070163', 50000, 0, '2020-06-13', '2020-06-24', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (131, 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'MLSDZ-1-20200613-0074', '2020-06-13', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtFTdJECefw', '06.03.03.001.1132', '2835白色贴片', 'S-BEN-50G-31H-09-JCH-F', 'MTR-0001', '标准生产', 'BOM202002250013', 5098330, 0, '2020-06-13', '2020-06-21', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (132, 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'MLSDZ-1-20200615-0080', '2020-06-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyadECefw', '06.03.03.002.0011', '2835阳光色贴片', 'S-BEN-27G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210037', 16006994, 0, '2020-06-15', '2020-06-22', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (133, 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'MLSDZ-1-20200615-0084', '2020-06-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeo3FtECefw', '06.03.03.001.0925', '2835白色贴片', 'S-BEN-65G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210043', 874939, 0, '2020-06-15', '2020-06-22', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (134, 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'MLSDZ-1-20200615-0087', '2020-06-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeo2+9ECefw', '06.03.03.001.0923', '2835白色贴片', 'S-BEN-57G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210039', 17409208, 0, '2020-06-15', '2020-06-22', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (135, 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'MLSDZ-1-20200615-0088', '2020-06-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeoyURECefw', '06.03.03.002.0013', '2835阳光色贴片', 'S-BEN-30G-11M-03-F0D-9', 'MTR-0001', '标准生产', 'BOM201903210028', 8597675, 0, '2020-06-15', '2020-06-22', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (136, 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'MLSDZ-1-20200616-0029', '2020-06-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABtMtBJECefw', '03.03.28.001.3506', '2835白色贴片', 'XEN-65G-31H-09-H14-C', 'MTR-0001', '标准生产', 'BOM202002290053', 2500000, 0, '2020-06-16', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (137, 'hB/lyJucR7WG4ySipFISah0NgN0=', 'MLSDZ-1-20200616-0037', '2020-06-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAARdpvNECefw', '03.03.28.002.0072', '2835阳光色贴片', 'E2835US21', 'MTR-0001', '标准生产', 'BOM201707310068', 100000000, 0, '2020-06-16', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (138, 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'MLSDZ-1-20200616-0041', '2020-06-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABpiwvBECefw', '03.03.28.001.3212', '2835白色贴片', 'G2835UW50', 'MTR-0001', '标准生产', 'BOM201911070163', 50000, 0, '2020-06-16', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (139, 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'MLSDZ-1-20200616-0066', '2020-06-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAAAz65hNECefw', '03.03.28.001.0653', '2835白色贴片', 'E2835UW105-2B', 'MTR-0001', '标准生产', 'BOM201806120006', 10280000, 0, '2020-06-16', '2020-06-30', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (140, 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'MLSDZ-1-20200616-0071', '2020-06-16', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABiYdcJECefw', '06.03.03.007.0387', '2835阳光色贴片', 'S-BEN-31G-31H-09-J8C-E', 'MTR-0001', '标准生产', 'BOM201906010020', 1528101, 0, '2020-06-16', '2020-06-26', '无', NULL, 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (141, '3fSZgjU4TPiUlesU3cUwmh0NgN0=', 'MLSDZ-1-20200617-0045', '2020-06-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABwICZNECefw', '06.03.03.007.0510', '2835阳光色贴片', 'S-XEN-27H-31H-09-H15-C-1', 'MTR-0001', '标准生产', 'BOM202006130020', 1327216, 0, '2020-06-17', '2020-07-02', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (142, 'e58WfT2vTPykhGsQtFDLUx0NgN0=', 'MLSDZ-1-20200617-0047', '2020-06-17', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABwLzQ5ECefw', '06.03.03.007.0524', '2835阳光色贴片', 'S-BEN-27G-21H-18-P58-51', 'MTR-0001', '标准生产', 'BOM202006160101', 204000, 0, '2020-06-17', '2020-07-02', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (143, 'jOEth8A2Q7OVJ3MZHb1lQh0NgN0=', 'MLSDZ-2-20200520-0040', '2020-05-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 16717871, 0, '2020-05-20', '2020-05-30', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (144, '2kNxAdlZQqaGCRwiw4LNXR0NgN0=', 'MLSDZ-2-20200520-0041', '2020-05-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelKqVECefw', '06.03.03.001.0906', '2835白色贴片', 'S-BEN-50G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 10662680, 35127, '2020-05-20', '2020-05-30', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (145, 'QdA/2I1tSemxq8eOefpRNh0NgN0=', 'MLSDZ-2-20200520-0042', '2020-05-20', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 6157010, 0, '2020-05-20', '2020-05-30', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (146, 'NFASX5A8QlqgJdZMDSn1dR0NgN0=', 'MLSDZ-2-20200522-0087', '2020-05-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZGItECefw', '06.03.03.001.0880', '2835白色贴片', 'S-BEN-50E-31H-09-JC1-0', 'MTR-0002', '返工生产', NULL, 158470, 107502, '2020-05-22', '2020-05-22', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (147, '4HzvXTvxSTGALe//UbQ51B0NgN0=', 'MLSDZ-2-20200522-0094', '2020-05-22', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABgXJO1ECefw', '06.03.03.007.0373', '2835阳光色贴片', 'S-XEN-27H-31H-09-H15-C', 'MTR-0002', '返工生产', NULL, 346148, 346148, '2020-05-22', '2020-05-30', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (148, 'J5tCuwKDRfOppSCreptiXh0NgN0=', 'MLSDZ-2-20200525-0015', '2020-05-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 2165000, 2165000, '2020-05-25', '2020-06-06', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (149, 'mh+E8X+yRaqbCvhUQYI2AR0NgN0=', 'MLSDZ-2-20200525-0016', '2020-05-25', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 450000, 450000, '2020-05-25', '2020-06-06', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (150, 'rT2vZ2XjQ5KDGYkCRMIWTB0NgN0=', 'MLSDZ-2-20200606-0063', '2020-06-06', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABdADKNECefw', '06.03.03.001.0562', '2835白色贴片', 'S-BEN-40E-31H-09-J21-1', 'MTR-0002', '返工生产', NULL, 1795000, 1795000, '2020-06-06', '2020-06-27', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (151, '9MRA1TBtQ5yFyONJ61BbxB0NgN0=', 'MLSDZ-2-20200615-0106', '2020-06-15', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABexS4lECefw', '06.03.03.007.0326', '2835阳光色贴片', 'S-BEN-30G-31H-09-JCA-E', 'MTR-0002', '返工生产', NULL, 362881, 0, '2020-06-15', '2020-06-30', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (152, 'FkzdcQD8Rv+zlhpHOAZ1/B0NgN0=', 'MLSDZ-2-20200618-0058', '2020-06-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABeZChVECefw', '06.03.03.007.0284', '2835阳光色贴片', 'S-BEN-35E-12M-03-F4C-7', 'MTR-0002', '返工生产', NULL, 9140000, 0, '2020-06-18', '2020-06-30', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);
INSERT INTO `eas_wo` VALUES (153, 'DEpyNHJNQya11xAsGOal0h0NgN0=', 'MLSDZ-2-20200618-0060', '2020-06-18', '下达', 'gJYAAAAAVifM567U', '01.19.10.07', '电子公司电子器件厂', 'gJYAAAdLuTDM567U', '01.19.20.01.02.061', '电子公司五厂一部', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', 'MTR-0002', '返工生产', NULL, 1108392, 0, '2020-06-18', '2020-06-30', '无', '1,2,3', 0, 4, '2020-06-18 11:38:01', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2335 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '从木林森EAS同步的工单，需要用户手动转为我们系统的工单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of eas_wo_dtl
-- ----------------------------
INSERT INTO `eas_wo_dtl` VALUES (1, 1, 'gJYAABvKKtrtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 4800, 4800, 0, 4800, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2, 1, 'gJYAABvKKtztSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1403, 1403, 0, 0, 0, 2, 1403);
INSERT INTO `eas_wo_dtl` VALUES (3, 1, 'gJYAABvKKtbtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 617, 617, 0, 617, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (4, 1, 'gJYAABvKKtftSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 14, 14, 0, 14, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (5, 1, 'gJYAABvKKtvtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 7232, 7232, 0, 7232, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (6, 1, 'gJYAABvKKt3tSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (7, 1, 'gJYAABvKKuHtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (8, 1, 'gJYAABvKKt/tSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 281, 281, 0, 281, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (9, 1, 'gJYAABvKKtPtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2806, 2806, 0, 2806, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (10, 1, 'gJYAABvKKt7tSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 22, 22, 0, 22, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (11, 1, 'gJYAABvKKtntSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6440, 6440, 0, 6440, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (12, 1, 'gJYAABvKKtTtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (13, 1, 'gJYAABvKKtjtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 87, 87, 0, 87, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (14, 1, 'gJYAABvKKtXtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1600, 1600, 0, 1600, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (15, 1, 'gJYAABvKKtLtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 87, 87, 0, 87, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (16, 1, 'gJYAABvKKuDtSYg5', 'lE8QlXJnRHeVIPrELX94wh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6440, 6440, 0, 6440, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (17, 2, 'gJYAABvKKu/tSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 90000, 90000, 0, 90000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (18, 2, 'gJYAABvKKurtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 40059, 40059, 0, 40059, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (19, 2, 'gJYAABvKKujtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 6768, 6768, 0, 6768, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (20, 2, 'gJYAABvKKuztSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 135090, 135090, 0, 135090, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (21, 2, 'gJYAABvKKvDtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 225, 225, 0, 225, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (22, 2, 'gJYAABvKKuvtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 11741, 11741, 0, 11741, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (23, 2, 'gJYAABvKKu7tSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 117414, 117414, 0, 117414, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (24, 2, 'gJYAABvKKubtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 693, 693, 0, 693, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (25, 2, 'gJYAABvKKuftSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 108, 108, 0, 108, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (26, 2, 'gJYAABvKKvTtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 270, 270, 0, 270, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (27, 2, 'gJYAABvKKvLtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 90000, 90000, 0, 90000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (28, 2, 'gJYAABvKKvHtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3114, 3114, 0, 3114, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (29, 2, 'gJYAABvKKvPtSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 362250, 362250, 0, 362250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (30, 2, 'gJYAABvKKu3tSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 362250, 362250, 0, 659778, 297528, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (31, 2, 'gJYAABvKKuntSYg5', 'iWLw395sQPSBqec9roPOWR0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1044, 1044, 0, 1394, 350, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (32, 3, 'gJYAABvP8UvtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 13454, 13454, 0, 13454, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (33, 3, 'gJYAABvP8UftSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1943, 1943, 0, 1035, 0, 2, 908);
INSERT INTO `eas_wo_dtl` VALUES (34, 3, 'gJYAABvP8VLtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 31167, 31167, 0, 31167, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (35, 3, 'gJYAABvP8U3tSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 149, 149, 0, 149, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (36, 3, 'gJYAABvP8U/tSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 135, 135, 0, 135, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (37, 3, 'gJYAABvP8VftSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1532, 1532, 0, 1532, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (38, 3, 'gJYAABvP8VHtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 15318, 15318, 0, 15318, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (39, 3, 'gJYAABvP8UjtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 90, 90, 0, 90, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (40, 3, 'gJYAABvP8UrtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 30084, 30084, 0, 55084, 25000, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (41, 3, 'gJYAABvP8UntSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (42, 3, 'gJYAABvP8VTtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (43, 3, 'gJYAABvP8VjtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 149, 149, 0, 149, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (44, 3, 'gJYAABvP8VbtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 398, 398, 0, 398, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (45, 3, 'gJYAABvP8VPtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 7474, 7474, 0, 7474, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (46, 3, 'gJYAABvP8VXtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 149, 149, 0, 0, 0, NULL, 149);
INSERT INTO `eas_wo_dtl` VALUES (47, 3, 'gJYAABvP8U7tSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 398, 398, 0, 398, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (48, 3, 'gJYAABvP8VDtSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 30084, 30084, 0, 30084, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (49, 3, 'gJYAABvP8UztSYg5', 'Hk4xyz73S22qPgQGFT/FUh0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 22423, 22423, 0, 22423, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (50, 4, 'gJYAABvP8XXtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 5943, 5943, 0, 5943, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (51, 4, 'gJYAABvP8XftSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 128, 128, 0, 128, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (52, 4, 'gJYAABvP8XPtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 596, 596, 0, 596, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (53, 4, 'gJYAABvP8XbtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10340, 10340, 0, 10340, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (54, 4, 'gJYAABvP8XntSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 26, 26, 0, 26, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (55, 4, 'gJYAABvP8YLtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 38, 38, 0, 38, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (56, 4, 'gJYAABvP8X/tSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1849, 1849, 0, 1849, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (57, 4, 'gJYAABvP8XLtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 18488, 18488, 0, 18488, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (58, 4, 'gJYAABvP8XHtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 121, 121, 0, 121, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (59, 4, 'gJYAABvP8XDtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 21234, 21234, 0, 21234, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (60, 4, 'gJYAABvP8X3tSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (61, 4, 'gJYAABvP8YDtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (62, 4, 'gJYAABvP8XjtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 106, 106, 0, 106, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (63, 4, 'gJYAABvP8X7tSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 281, 281, 0, 281, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (64, 4, 'gJYAABvP8XrtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5276, 5276, 0, 5276, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (65, 4, 'gJYAABvP8XTtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 106, 106, 0, 0, 0, NULL, 106);
INSERT INTO `eas_wo_dtl` VALUES (66, 4, 'gJYAABvP8YHtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 281, 281, 0, 281, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (67, 4, 'gJYAABvP8XztSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 21234, 21234, 0, 21234, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (68, 4, 'gJYAABvP8XvtSYg5', 'VZe9P2UEQ1ihGc8dbmIp5B0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 5276, 5276, 0, 5276, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (69, 5, 'gJYAABvSYWLtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 100000, 100000, 0, 100000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (70, 5, 'gJYAABvSYVztSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 44510, 44510, 0, 44510, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (71, 5, 'gJYAABvSYVvtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 7520, 7520, 0, 7520, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (72, 5, 'gJYAABvSYV/tSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 150100, 150100, 0, 150100, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (73, 5, 'gJYAABvSYWPtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 250, 250, 0, 250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (74, 5, 'gJYAABvSYV7tSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 13046, 13046, 0, 13046, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (75, 5, 'gJYAABvSYWHtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 130460, 130460, 0, 130460, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (76, 5, 'gJYAABvSYVntSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 770, 770, 0, 770, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (77, 5, 'gJYAABvSYVrtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (78, 5, 'gJYAABvSYWftSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 300, 300, 0, 300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (79, 5, 'gJYAABvSYWXtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 100000, 100000, 0, 100000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (80, 5, 'gJYAABvSYWTtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3460, 3460, 0, 3460, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (81, 5, 'gJYAABvSYWbtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 402500, 402500, 0, 402500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (82, 5, 'gJYAABvSYWDtSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 402500, 402500, 0, 402500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (83, 5, 'gJYAABvSYV3tSYg5', 'A+DdRq9UQ1K2AwQlpJWN3R0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1160, 1160, 0, 1160, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (84, 6, 'gJYAABvSYx3tSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 115, 115, 0, 115, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (85, 6, 'gJYAABvSYx/tSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 2, 2, 0, 2, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (86, 6, 'gJYAABvSYxvtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 11, 11, 0, 11, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (87, 6, 'gJYAABvSYx7tSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 199, 199, 0, 199, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (88, 6, 'gJYAABvSYyHtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (89, 6, 'gJYAABvSYyrtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (90, 6, 'gJYAABvSYyftSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 36, 36, 0, 36, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (91, 6, 'gJYAABvSYxrtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 357, 357, 0, 357, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (92, 6, 'gJYAABvSYxntSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (93, 6, 'gJYAABvSYxjtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 409, 409, 0, 409, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (94, 6, 'gJYAABvSYyXtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (95, 6, 'gJYAABvSYyjtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (96, 6, 'gJYAABvSYyDtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (97, 6, 'gJYAABvSYybtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (98, 6, 'gJYAABvSYyLtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 102, 102, 0, 102, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (99, 6, 'gJYAABvSYxztSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (100, 6, 'gJYAABvSYyntSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (101, 6, 'gJYAABvSYyTtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 409, 409, 0, 409, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (102, 6, 'gJYAABvSYyPtSYg5', 'GXRi4Yb2Tu6WYvGQd7Vktx0NgN0=', 'gJYAABctV9hECefw', '06.10.03.001.0071', 'DICE', 'S-DICE-BXCD2630', '千个', 102, 102, 0, 102, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (103, 7, 'gJYAABvU0hTtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 154, 154, 0, 154, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (104, 7, 'gJYAABvU0hDtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABWeWgpECefw', '01.02.01.001.1244', '荧光粉', 'MLS650-03', '克', 17, 17, 0, 0, 0, 2, 17);
INSERT INTO `eas_wo_dtl` VALUES (105, 7, 'gJYAABvU0gvtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABhfXltECefw', '01.02.01.001.1272', '荧光粉', 'KSL220', '克', 28, 28, 0, 0, 0, 2, 28);
INSERT INTO `eas_wo_dtl` VALUES (106, 7, 'gJYAABvU0hrtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 261, 261, 0, 261, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (107, 7, 'gJYAABvU0grtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (108, 7, 'gJYAABvU0g3tSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (109, 7, 'gJYAABvU0hjtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 14, 14, 0, 14, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (110, 7, 'gJYAABvU0hPtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 137, 137, 0, 137, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (111, 7, 'gJYAABvU0hXtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (112, 7, 'gJYAABvU0gztSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 537, 537, 0, 537, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (113, 7, 'gJYAABvU0g/tSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (114, 7, 'gJYAABvU0g7tSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (115, 7, 'gJYAABvU0hztSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (116, 7, 'gJYAABvU0hntSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (117, 7, 'gJYAABvU0hvtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 133, 133, 0, 133, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (118, 7, 'gJYAABvU0hHtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (119, 7, 'gJYAABvU0hLtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (120, 7, 'gJYAABvU0hbtSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 537, 537, 0, 537, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (121, 7, 'gJYAABvU0hftSYg5', 'iuoWfuYyQ1yTbJH6iPpPEx0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 133, 133, 0, 133, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (122, 8, 'gJYAABvU0mXtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 5675, 5675, 0, 5675, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (123, 8, 'gJYAABvU0mPtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 345, 345, 0, 345, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (124, 8, 'gJYAABvU0m/tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 125, 125, 0, 125, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (125, 8, 'gJYAABvU0mTtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 299, 299, 0, 0, 0, 2, 299);
INSERT INTO `eas_wo_dtl` VALUES (126, 8, 'gJYAABvU0l/tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10993, 10993, 0, 10993, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (127, 8, 'gJYAABvU0mDtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 53, 53, 0, 53, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (128, 8, 'gJYAABvU0m7tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 48, 48, 0, 48, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (129, 8, 'gJYAABvU0nHtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 567, 567, 0, 567, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (130, 8, 'gJYAABvU0mbtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5666, 5666, 0, 5666, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (131, 8, 'gJYAABvU0mztSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 66, 66, 0, 66, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (132, 8, 'gJYAABvU0mHtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10611, 10611, 0, 10611, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (133, 8, 'gJYAABvU0mftSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (134, 8, 'gJYAABvU0mLtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (135, 8, 'gJYAABvU0mrtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 53, 53, 0, 53, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (136, 8, 'gJYAABvU0mjtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 140, 140, 0, 140, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (137, 8, 'gJYAABvU0mntSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2636, 2636, 0, 2636, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (138, 8, 'gJYAABvU0nDtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 53, 53, 0, 0, 0, NULL, 53);
INSERT INTO `eas_wo_dtl` VALUES (139, 8, 'gJYAABvU0l7tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 140, 140, 0, 140, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (140, 8, 'gJYAABvU0mvtSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10611, 10611, 0, 10611, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (141, 8, 'gJYAABvU0m3tSYg5', 'UlKz1MdSSduEqVQsT1DQMx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 7909, 7909, 0, 7909, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (142, 9, 'gJYAABvWE17tSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 3150, 3150, 0, 3150, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (143, 9, 'gJYAABvWE1rtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1263, 1263, 0, 0, 0, 2, 1263);
INSERT INTO `eas_wo_dtl` VALUES (144, 9, 'gJYAABvWE1jtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 443, 443, 0, 443, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (145, 9, 'gJYAABvWE1TtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 41, 41, 0, 41, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (146, 9, 'gJYAABvWE1ntSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 4746, 4746, 0, 4746, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (147, 9, 'gJYAABvWE1HtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (148, 9, 'gJYAABvWE1XtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (149, 9, 'gJYAABvWE1vtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 211, 211, 0, 211, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (150, 9, 'gJYAABvWE1ftSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2114, 2114, 0, 2114, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (151, 9, 'gJYAABvWE1DtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 9, 9, 0, 9, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (152, 9, 'gJYAABvWE13tSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4226, 4226, 0, 4226, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (153, 9, 'gJYAABvWE1LtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (154, 9, 'gJYAABvWE1btSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 58, 58, 0, 58, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (155, 9, 'gJYAABvWE1PtSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1050, 1050, 0, 1050, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (156, 9, 'gJYAABvWE0/tSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 58, 58, 0, 58, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (157, 9, 'gJYAABvWE1ztSYg5', 'juD6osJ8QKW8C6x4jFPrBR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4226, 4226, 0, 4226, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (158, 10, 'gJYAABvXXhHtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 154, 154, 0, 154, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (159, 10, 'gJYAABvXXiHtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 6623, 6623, 0, 6623, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (160, 10, 'gJYAABvXXhTtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 335, 335, 0, 335, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (161, 10, 'gJYAABvXXh3tSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 14063, 14063, 0, 14063, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (162, 10, 'gJYAABvXXh/tSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 36, 36, 0, 36, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (163, 10, 'gJYAABvXXhftSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 51, 51, 0, 51, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (164, 10, 'gJYAABvXXh7tSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1491, 1491, 0, 1491, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (165, 10, 'gJYAABvXXhvtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 14912, 14912, 0, 14912, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (166, 10, 'gJYAABvXXhztSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 119, 119, 0, 119, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (167, 10, 'gJYAABvXXiLtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 28588, 28588, 0, 28588, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (168, 10, 'gJYAABvXXhjtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (169, 10, 'gJYAABvXXhXtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (170, 10, 'gJYAABvXXiDtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 142, 142, 0, 142, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (171, 10, 'gJYAABvXXhbtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 378, 378, 0, 378, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (172, 10, 'gJYAABvXXhntSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 7103, 7103, 0, 7103, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (173, 10, 'gJYAABvXXhDtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 142, 142, 0, 0, 0, NULL, 142);
INSERT INTO `eas_wo_dtl` VALUES (174, 10, 'gJYAABvXXhLtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 378, 378, 0, 378, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (175, 10, 'gJYAABvXXhPtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 28588, 28588, 0, 28588, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (176, 10, 'gJYAABvXXhrtSYg5', 'Atku5Ej0Tv+H2JWMa6NO1R0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 7103, 7103, 0, 7103, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (177, 11, 'gJYAABvXXjLtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 15, 15, 0, 15, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (178, 11, 'gJYAABvXXj7tSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 574, 574, 0, 574, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (179, 11, 'gJYAABvXXjPtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 24, 24, 0, 24, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (180, 11, 'gJYAABvXXj3tSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1392, 1392, 0, 1392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (181, 11, 'gJYAABvXXjbtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (182, 11, 'gJYAABvXXkDtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (183, 11, 'gJYAABvXXjjtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 148, 148, 0, 148, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (184, 11, 'gJYAABvXXjXtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 1476, 1476, 0, 1476, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (185, 11, 'gJYAABvXXjftSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 11, 11, 0, 11, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (186, 11, 'gJYAABvXXjHtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 2829, 2829, 0, 2829, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (187, 11, 'gJYAABvXXj/tSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (188, 11, 'gJYAABvXXjntSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (189, 11, 'gJYAABvXXjDtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 14, 14, 0, 14, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (190, 11, 'gJYAABvXXjvtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 37, 37, 0, 37, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (191, 11, 'gJYAABvXXkLtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 703, 703, 0, 703, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (192, 11, 'gJYAABvXXjTtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 14, 14, 0, 0, 0, NULL, 14);
INSERT INTO `eas_wo_dtl` VALUES (193, 11, 'gJYAABvXXjrtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 37, 37, 0, 37, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (194, 11, 'gJYAABvXXkHtSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2829, 2829, 0, 2829, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (195, 11, 'gJYAABvXXjztSYg5', 'M1/waNEgQKW35SL1ApggnB0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 703, 703, 0, 703, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (196, 12, 'gJYAABvXXmztSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 1210, 1210, 0, 1210, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (197, 12, 'gJYAABvXXmbtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 42, 42, 0, 0, 0, 2, 42);
INSERT INTO `eas_wo_dtl` VALUES (198, 12, 'gJYAABvXXmftSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 216, 216, 0, 216, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (199, 12, 'gJYAABvXXm7tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6303, 6303, 0, 6303, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (200, 12, 'gJYAABvXXmntSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (201, 12, 'gJYAABvXXl/tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (202, 12, 'gJYAABvXXmPtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 310, 310, 0, 310, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (203, 12, 'gJYAABvXXm3tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3098, 3098, 0, 3098, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (204, 12, 'gJYAABvXXm/tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 18, 18, 0, 18, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (205, 12, 'gJYAABvXXmrtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6083, 6083, 0, 6083, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (206, 12, 'gJYAABvXXmLtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (207, 12, 'gJYAABvXXmvtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (208, 12, 'gJYAABvXXmDtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (209, 12, 'gJYAABvXXmHtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 80, 80, 0, 80, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (210, 12, 'gJYAABvXXnDtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1511, 1511, 0, 1511, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (211, 12, 'gJYAABvXXmXtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (212, 12, 'gJYAABvXXl7tSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 80, 80, 0, 80, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (213, 12, 'gJYAABvXXmjtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6083, 6083, 0, 6083, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (214, 12, 'gJYAABvXXmTtSYg5', 'oxZT465JTSqxP/JfIPMP3B0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 4534, 4534, 0, 4534, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (215, 13, 'gJYAABvXnwPtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 192, 192, 0, 192, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (216, 13, 'gJYAABvXnwvtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1349, 1349, 0, 1349, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (217, 13, 'gJYAABvXnwXtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 36, 36, 0, 36, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (218, 13, 'gJYAABvXnvztSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2756, 2756, 0, 2756, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (219, 13, 'gJYAABvXnwHtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (220, 13, 'gJYAABvXnv3tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (221, 13, 'gJYAABvXnwjtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 286, 286, 0, 286, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (222, 13, 'gJYAABvXnwTtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2862, 2862, 0, 2862, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (223, 13, 'gJYAABvXnwftSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 20, 20, 0, 20, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (224, 13, 'gJYAABvXnwztSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5660, 5660, 0, 5660, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (225, 13, 'gJYAABvXnwbtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (226, 13, 'gJYAABvXnwDtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (227, 13, 'gJYAABvXnwntSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (228, 13, 'gJYAABvXnv7tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (229, 13, 'gJYAABvXnw3tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1406, 1406, 0, 1406, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (230, 13, 'gJYAABvXnwLtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (231, 13, 'gJYAABvXnv/tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (232, 13, 'gJYAABvXnwrtSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5660, 5660, 0, 5660, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (233, 13, 'gJYAABvXnw7tSYg5', 'CS16ebtDS2udduTz2vY5sh0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1406, 1406, 0, 1406, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (234, 14, 'gJYAABvXnxbtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 144, 144, 0, 144, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (235, 14, 'gJYAABvXnx7tSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1350, 1350, 0, 1350, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (236, 14, 'gJYAABvXnxvtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 56, 56, 0, 56, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (237, 14, 'gJYAABvXnxHtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2747, 2747, 0, 2747, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (238, 14, 'gJYAABvXnyPtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (239, 14, 'gJYAABvXnxztSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (240, 14, 'gJYAABvXnxLtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 292, 292, 0, 292, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (241, 14, 'gJYAABvXnxPtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2920, 2920, 0, 2920, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (242, 14, 'gJYAABvXnxTtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 20, 20, 0, 20, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (243, 14, 'gJYAABvXnxjtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5640, 5640, 0, 5640, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (244, 14, 'gJYAABvXnxftSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (245, 14, 'gJYAABvXnxXtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (246, 14, 'gJYAABvXnx/tSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (247, 14, 'gJYAABvXnxntSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (248, 14, 'gJYAABvXnxrtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1401, 1401, 0, 1401, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (249, 14, 'gJYAABvXnyLtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (250, 14, 'gJYAABvXnyDtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (251, 14, 'gJYAABvXnyHtSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5640, 5640, 0, 5640, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (252, 14, 'gJYAABvXnx3tSYg5', 'Yg43eMGyQ8iChk9/kumJiR0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1401, 1401, 0, 1401, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (253, 15, 'gJYAABvXnyntSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 163, 163, 0, 163, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (254, 15, 'gJYAABvXnyjtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1221, 1221, 0, 1221, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (255, 15, 'gJYAABvXnzPtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 45, 45, 0, 45, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (256, 15, 'gJYAABvXny7tSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2494, 2494, 0, 2494, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (257, 15, 'gJYAABvXnzLtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (258, 15, 'gJYAABvXnzftSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (259, 15, 'gJYAABvXnzHtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 265, 265, 0, 265, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (260, 15, 'gJYAABvXny3tSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2651, 2651, 0, 2651, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (261, 15, 'gJYAABvXnyvtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 18, 18, 0, 18, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (262, 15, 'gJYAABvXnzbtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5121, 5121, 0, 5121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (263, 15, 'gJYAABvXnzjtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (264, 15, 'gJYAABvXnyztSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (265, 15, 'gJYAABvXny/tSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (266, 15, 'gJYAABvXnyftSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 68, 68, 0, 68, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (267, 15, 'gJYAABvXnzDtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1272, 1272, 0, 1272, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (268, 15, 'gJYAABvXnzXtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 25, 25, 0, 0, 0, NULL, 25);
INSERT INTO `eas_wo_dtl` VALUES (269, 15, 'gJYAABvXnzTtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 68, 68, 0, 68, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (270, 15, 'gJYAABvXnyrtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5121, 5121, 0, 5121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (271, 15, 'gJYAABvXnybtSYg5', 'SVwnSF+cRJue9vYQvesOOR0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1272, 1272, 0, 1272, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (272, 16, 'gJYAABvYub7tSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 70000, 70000, 0, 70000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (273, 16, 'gJYAABvYubjtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 31157, 31157, 0, 31157, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (274, 16, 'gJYAABvYubftSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 5264, 5264, 0, 5264, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (275, 16, 'gJYAABvYubvtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 105070, 105070, 0, 105070, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (276, 16, 'gJYAABvYub/tSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 175, 175, 0, 175, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (277, 16, 'gJYAABvYubrtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABYUWVZECefw', '01.02.03.013.1002', '胶水', 'WM-3322A', '克', 9132, 9132, 0, 9119, 0, 1, 13);
INSERT INTO `eas_wo_dtl` VALUES (278, 16, 'gJYAABvYub3tSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABYUWQlECefw', '01.02.03.013.1003', '胶水', 'WM-3322B', '克', 91322, 91322, 0, 91192, 0, 1, 130);
INSERT INTO `eas_wo_dtl` VALUES (279, 16, 'gJYAABvYubXtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 539, 539, 0, 539, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (280, 16, 'gJYAABvYubbtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 84, 84, 0, 84, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (281, 16, 'gJYAABvYucPtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 210, 210, 0, 210, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (282, 16, 'gJYAABvYucHtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 70000, 70000, 0, 70000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (283, 16, 'gJYAABvYucDtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 2422, 2422, 0, 2422, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (284, 16, 'gJYAABvYucLtSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 281750, 281750, 0, 281750, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (285, 16, 'gJYAABvYubztSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 281750, 281750, 0, 281750, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (286, 16, 'gJYAABvYubntSYg5', 'y6oxDur4TDesz8rKY5V4TR0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 812, 812, 0, 812, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (287, 17, 'gJYAABvYuzLtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 1830, 1830, 0, 1830, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (288, 17, 'gJYAABvYuzjtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1047, 1047, 0, 0, 0, 2, 1047);
INSERT INTO `eas_wo_dtl` VALUES (289, 17, 'gJYAABvYuzHtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 270, 270, 0, 270, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (290, 17, 'gJYAABvYuy/tSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 35, 35, 0, 35, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (291, 17, 'gJYAABvYuzbtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 2757, 2757, 0, 2757, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (292, 17, 'gJYAABvYuzPtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (293, 17, 'gJYAABvYuzTtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (294, 17, 'gJYAABvYuzXtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 92, 92, 0, 92, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (295, 17, 'gJYAABvYuy3tSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 919, 919, 0, 919, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (296, 17, 'gJYAABvYuzftSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2455, 2455, 0, 2455, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (297, 17, 'gJYAABvYuzntSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (298, 17, 'gJYAABvYuyvtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (299, 17, 'gJYAABvYuyztSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 610, 610, 0, 610, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (300, 17, 'gJYAABvYuzDtSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (301, 17, 'gJYAABvYuy7tSYg5', 'ey8bk2tjRL64E29jP07wbB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2455, 2455, 0, 2455, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (302, 18, 'gJYAABvYu0XtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 6300, 6300, 0, 6300, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (303, 18, 'gJYAABvYu0ntSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 3795, 3795, 0, 0, 0, 2, 3795);
INSERT INTO `eas_wo_dtl` VALUES (304, 18, 'gJYAABvYu0DtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1006, 1006, 0, 1006, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (305, 18, 'gJYAABvYu0PtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 134, 134, 0, 134, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (306, 18, 'gJYAABvYu0ztSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 9492, 9492, 0, 9492, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (307, 18, 'gJYAABvYu0ftSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 35, 35, 0, 35, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (308, 18, 'gJYAABvYuz/tSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (309, 18, 'gJYAABvYu0jtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 314, 314, 0, 314, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (310, 18, 'gJYAABvYu0rtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3140, 3140, 0, 3140, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (311, 18, 'gJYAABvYu0vtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8453, 8453, 0, 8453, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (312, 18, 'gJYAABvYu0HtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 11, 11, 0, 0, 0, NULL, 11);
INSERT INTO `eas_wo_dtl` VALUES (313, 18, 'gJYAABvYu03tSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 116, 116, 0, 116, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (314, 18, 'gJYAABvYu0LtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2100, 2100, 0, 2100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (315, 18, 'gJYAABvYu0btSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 116, 116, 0, 116, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (316, 18, 'gJYAABvYu0TtSYg5', 'CCGEl/oMSxmyCOZSAFPZgB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8453, 8453, 0, 8453, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (317, 19, 'gJYAABvZZlDtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 1710, 1710, 0, 1710, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (318, 19, 'gJYAABvZZljtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 628, 628, 0, 0, 0, 2, 628);
INSERT INTO `eas_wo_dtl` VALUES (319, 19, 'gJYAABvZZk3tSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 233, 233, 0, 233, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (320, 19, 'gJYAABvZZkntSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 21, 21, 0, 21, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (321, 19, 'gJYAABvZZlHtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 2576, 2576, 0, 2576, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (322, 19, 'gJYAABvZZlTtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (323, 19, 'gJYAABvZZkztSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (324, 19, 'gJYAABvZZlbtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 59, 59, 0, 59, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (325, 19, 'gJYAABvZZkvtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 586, 586, 0, 586, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (326, 19, 'gJYAABvZZk/tSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 5, 5, 0, 5, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (327, 19, 'gJYAABvZZlXtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2294, 2294, 0, 2294, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (328, 19, 'gJYAABvZZk7tSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (329, 19, 'gJYAABvZZkrtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (330, 19, 'gJYAABvZZlPtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 570, 570, 0, 570, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (331, 19, 'gJYAABvZZlftSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (332, 19, 'gJYAABvZZlLtSYg5', 'DOvhUF4ZT2GLbkd9x8ECxh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2294, 2294, 0, 2294, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (333, 20, 'gJYAABvZZm/tSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 3030, 3030, 0, 3030, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (334, 20, 'gJYAABvZZnXtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1734, 1734, 0, 0, 0, 2, 1734);
INSERT INTO `eas_wo_dtl` VALUES (335, 20, 'gJYAABvZZm7tSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 447, 447, 0, 447, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (336, 20, 'gJYAABvZZmztSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 58, 58, 0, 58, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (337, 20, 'gJYAABvZZnPtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 4565, 4565, 0, 4565, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (338, 20, 'gJYAABvZZnDtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (339, 20, 'gJYAABvZZnHtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (340, 20, 'gJYAABvZZnLtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 152, 152, 0, 152, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (341, 20, 'gJYAABvZZmrtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1521, 1521, 0, 1521, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (342, 20, 'gJYAABvZZnTtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4065, 4065, 0, 4065, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (343, 20, 'gJYAABvZZnbtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (344, 20, 'gJYAABvZZmjtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 56, 56, 0, 56, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (345, 20, 'gJYAABvZZmntSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1010, 1010, 0, 1010, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (346, 20, 'gJYAABvZZm3tSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 56, 56, 0, 56, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (347, 20, 'gJYAABvZZmvtSYg5', 'zbQ71UMATayD6LGFEomudB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4065, 4065, 0, 4065, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (348, 21, 'gJYAABvZZo7tSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 7500, 7500, 0, 7500, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (349, 21, 'gJYAABvZZoTtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 3666, 3666, 0, 0, 0, 2, 3666);
INSERT INTO `eas_wo_dtl` VALUES (350, 21, 'gJYAABvZZpDtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1008, 1008, 0, 1008, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (351, 21, 'gJYAABvZZojtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 122, 122, 0, 122, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (352, 21, 'gJYAABvZZpLtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 11300, 11300, 0, 11300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (353, 21, 'gJYAABvZZontSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 42, 42, 0, 42, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (354, 21, 'gJYAABvZZpHtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 26, 26, 0, 26, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (355, 21, 'gJYAABvZZoPtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 367, 367, 0, 367, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (356, 21, 'gJYAABvZZoztSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3665, 3665, 0, 3665, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (357, 21, 'gJYAABvZZortSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 28, 28, 0, 28, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (358, 21, 'gJYAABvZZobtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10063, 10063, 0, 10063, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (359, 21, 'gJYAABvZZo3tSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 13, 13, 0, 0, 0, NULL, 13);
INSERT INTO `eas_wo_dtl` VALUES (360, 21, 'gJYAABvZZoftSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (361, 21, 'gJYAABvZZoXtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2500, 2500, 0, 2500, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (362, 21, 'gJYAABvZZo/tSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 138, 138, 0, 138, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (363, 21, 'gJYAABvZZovtSYg5', 'WRotNhF2QuWlc/0QwVihWR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10063, 10063, 0, 10063, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (364, 22, 'gJYAABva2ZLtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 100000, 100000, 0, 100000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (365, 22, 'gJYAABva2ZHtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAAAAFAAxECefw', '01.02.01.001.0055', '荧光粉', '阳光4号', '克', 44510, 44510, 0, 44510, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (366, 22, 'gJYAABva2Y7tSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 7520, 7520, 0, 7520, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (367, 22, 'gJYAABva2Y3tSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 158000, 158000, 0, 158000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (368, 22, 'gJYAABva2ZbtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 250, 250, 0, 250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (369, 22, 'gJYAABva2ZDtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABqxu7dECefw', '01.02.03.014.0211', '硅胶', 'MN-006A', '克', 13046, 13046, 0, 13046, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (370, 22, 'gJYAABva2ZTtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABqxvCdECefw', '01.02.03.014.0212', '硅胶', 'MN-006B', '克', 130460, 130460, 0, 130460, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (371, 22, 'gJYAABva2YvtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 770, 770, 0, 770, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (372, 22, 'gJYAABva2YztSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (373, 22, 'gJYAABva2ZPtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 300, 300, 0, 300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (374, 22, 'gJYAABva2ZjtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 100000, 100000, 0, 100000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (375, 22, 'gJYAABva2ZftSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3460, 3460, 0, 3460, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (376, 22, 'gJYAABva2ZntSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 402500, 402500, 0, 402500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (377, 22, 'gJYAABva2ZXtSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 402500, 402500, 0, 402500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (378, 22, 'gJYAABva2Y/tSYg5', 'v0+2i2KeSHu9BUaicwyFUx0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1160, 1160, 0, 1160, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (379, 23, 'gJYAABva2bLtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 13, 13, 0, 13, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (380, 23, 'gJYAABva2aPtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 820, 820, 0, 820, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (381, 23, 'gJYAABva2aXtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 19, 19, 0, 19, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (382, 23, 'gJYAABva2bPtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 3082, 3082, 0, 3082, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (383, 23, 'gJYAABva2aHtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (384, 23, 'gJYAABva2abtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (385, 23, 'gJYAABva2bHtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 213, 213, 0, 213, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (386, 23, 'gJYAABva2aftSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2126, 2126, 0, 2126, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (387, 23, 'gJYAABva2artSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 15, 15, 0, 15, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (388, 23, 'gJYAABva2bDtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4219, 4219, 0, 4219, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (389, 23, 'gJYAABva2a3tSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (390, 23, 'gJYAABva2a/tSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (391, 23, 'gJYAABva2aTtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (392, 23, 'gJYAABva2avtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 56, 56, 0, 56, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (393, 23, 'gJYAABva2aztSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1048, 1048, 0, 1048, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (394, 23, 'gJYAABva2a7tSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (395, 23, 'gJYAABva2antSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 56, 56, 0, 56, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (396, 23, 'gJYAABva2ajtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4219, 4219, 0, 4219, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (397, 23, 'gJYAABva2aLtSYg5', '3HzUCJgBQNeAJjt1S3s24h0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 2096, 2096, 0, 2096, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (398, 24, 'gJYAABva2cftSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 103, 103, 0, 103, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (399, 24, 'gJYAABva2cPtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 114, 114, 0, 114, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (400, 24, 'gJYAABva2b7tSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3029, 3029, 0, 3029, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (401, 24, 'gJYAABva2cTtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAwdkHhECefw', '01.02.01.006.0066', '键合银丝', 'JHB-J-23um', '米', 11775, 11775, 0, 11775, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (402, 24, 'gJYAABva2cjtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 38, 38, 0, 38, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (403, 24, 'gJYAABva2cXtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 42, 42, 0, 42, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (404, 24, 'gJYAABva2bjtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 813, 813, 0, 813, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (405, 24, 'gJYAABva2cLtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 8125, 8125, 0, 8125, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (406, 24, 'gJYAABva2bntSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 58, 58, 0, 58, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (407, 24, 'gJYAABva2bftSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 16121, 16121, 0, 16121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (408, 24, 'gJYAABva2bbtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (409, 24, 'gJYAABva2cbtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (410, 24, 'gJYAABva2brtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 80, 80, 0, 0, 0, NULL, 80);
INSERT INTO `eas_wo_dtl` VALUES (411, 24, 'gJYAABva2bvtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 213, 213, 0, 213, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (412, 24, 'gJYAABva2cDtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 4005, 4005, 0, 4005, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (413, 24, 'gJYAABva2b/tSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 80, 80, 0, 0, 0, NULL, 80);
INSERT INTO `eas_wo_dtl` VALUES (414, 24, 'gJYAABva2b3tSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 213, 213, 0, 213, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (415, 24, 'gJYAABva2bztSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 16121, 16121, 0, 16121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (416, 24, 'gJYAABva2cHtSYg5', 'TLuIuHScRqKlJC0DZbEm2h0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 8011, 8011, 0, 8011, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (417, 25, 'gJYAABvbbg3tSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 1717, 1717, 0, 1717, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (418, 25, 'gJYAABvbbhXtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 283, 283, 0, 283, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (419, 25, 'gJYAABvbbgvtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4213, 4213, 0, 4213, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (420, 25, 'gJYAABvbbgztSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (421, 25, 'gJYAABvbbhTtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (422, 25, 'gJYAABvbbgntSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 207, 207, 0, 207, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (423, 25, 'gJYAABvbbhHtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2070, 2070, 0, 2070, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (424, 25, 'gJYAABvbbgXtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 12, 12, 0, 12, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (425, 25, 'gJYAABvbbhDtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4066, 4066, 0, 4066, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (426, 25, 'gJYAABvbbgrtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (427, 25, 'gJYAABvbbhLtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (428, 25, 'gJYAABvbbgftSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (429, 25, 'gJYAABvbbgbtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (430, 25, 'gJYAABvbbhbtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1010, 1010, 0, 1010, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (431, 25, 'gJYAABvbbg7tSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (432, 25, 'gJYAABvbbhPtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (433, 25, 'gJYAABvbbg/tSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4066, 4066, 0, 4066, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (434, 25, 'gJYAABvbbgjtSYg5', '7Y4G6qDvTEOIlD52gIhxEh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 3031, 3031, 0, 3031, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (435, 26, 'gJYAABvbbh/tSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2186, 2186, 0, 2186, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (436, 26, 'gJYAABvbbhvtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 158, 158, 0, 87, 0, 2, 71);
INSERT INTO `eas_wo_dtl` VALUES (437, 26, 'gJYAABvbbijtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 53, 53, 0, 53, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (438, 26, 'gJYAABvbbiLtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4180, 4180, 0, 4180, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (439, 26, 'gJYAABvbbiDtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (440, 26, 'gJYAABvbbiXtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (441, 26, 'gJYAABvbbh3tSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 240, 240, 0, 240, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (442, 26, 'gJYAABvbbiztSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2401, 2401, 0, 2401, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (443, 26, 'gJYAABvbbivtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 29, 29, 0, 29, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (444, 26, 'gJYAABvbbiPtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4035, 4035, 0, 4035, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (445, 26, 'gJYAABvbbirtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (446, 26, 'gJYAABvbbhrtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (447, 26, 'gJYAABvbbiTtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (448, 26, 'gJYAABvbbiftSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 53, 53, 0, 53, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (449, 26, 'gJYAABvbbibtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1002, 1002, 0, 1002, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (450, 26, 'gJYAABvbbh7tSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (451, 26, 'gJYAABvbbintSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 53, 53, 0, 53, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (452, 26, 'gJYAABvbbiHtSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4035, 4035, 0, 4035, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (453, 26, 'gJYAABvbbhztSYg5', 'FhzVyhkrR2SxEHs5wytG+B0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 3007, 3007, 0, 3007, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (454, 27, 'gJYAABvbbjbtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 149, 149, 0, 149, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (455, 27, 'gJYAABvbbjXtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 50, 50, 0, 50, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (456, 27, 'gJYAABvbbjvtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 717, 717, 0, 717, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (457, 27, 'gJYAABvbbkLtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2065, 2065, 0, 2065, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (458, 27, 'gJYAABvbbjftSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (459, 27, 'gJYAABvbbjTtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (460, 27, 'gJYAABvbbj3tSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 219, 219, 0, 219, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (461, 27, 'gJYAABvbbkDtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 2190, 2190, 0, 2190, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (462, 27, 'gJYAABvbbjrtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 16, 16, 0, 16, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (463, 27, 'gJYAABvbbj/tSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 4198, 4198, 0, 4198, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (464, 27, 'gJYAABvbbj7tSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (465, 27, 'gJYAABvbbjDtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (466, 27, 'gJYAABvbbjntSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (467, 27, 'gJYAABvbbjztSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 55, 55, 0, 55, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (468, 27, 'gJYAABvbbjLtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1043, 1043, 0, 1043, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (469, 27, 'gJYAABvbbjjtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (470, 27, 'gJYAABvbbkHtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 55, 55, 0, 55, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (471, 27, 'gJYAABvbbjPtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4198, 4198, 0, 4198, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (472, 27, 'gJYAABvbbjHtSYg5', '5S829FmrSdmPPUxrjkyb0R0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 1043, 1043, 0, 1043, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (473, 28, 'gJYAABvbbtvtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 7050, 7050, 0, 7050, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (474, 28, 'gJYAABvbbt3tSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 2060, 2060, 0, 0, 0, 2, 2060);
INSERT INTO `eas_wo_dtl` VALUES (475, 28, 'gJYAABvbbtftSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 907, 907, 0, 907, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (476, 28, 'gJYAABvbbtntSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 21, 21, 0, 21, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (477, 28, 'gJYAABvbbtztSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 10622, 10622, 0, 10622, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (478, 28, 'gJYAABvbbt7tSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (479, 28, 'gJYAABvbbuLtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (480, 28, 'gJYAABvbbuDtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 412, 412, 0, 412, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (481, 28, 'gJYAABvbbtXtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4122, 4122, 0, 4122, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (482, 28, 'gJYAABvbbt/tSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 33, 33, 0, 33, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (483, 28, 'gJYAABvbbtrtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 9459, 9459, 0, 9459, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (484, 28, 'gJYAABvbbtPtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (485, 28, 'gJYAABvbbtjtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 129, 129, 0, 129, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (486, 28, 'gJYAABvbbtbtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2350, 2350, 0, 2350, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (487, 28, 'gJYAABvbbtTtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 129, 129, 0, 129, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (488, 28, 'gJYAABvbbuHtSYg5', 'qGxek7DiQN+RixNYCpEF0h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 9459, 9459, 0, 9459, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (489, 29, 'gJYAABvb0JntSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 1466, 1466, 0, 1466, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (490, 29, 'gJYAABvb0IjtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 161, 161, 0, 161, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (491, 29, 'gJYAABvb0I7tSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 44, 44, 0, 44, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (492, 29, 'gJYAABvb0JjtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6403, 6403, 0, 6403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (493, 29, 'gJYAABvb0JPtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (494, 29, 'gJYAABvb0IrtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (495, 29, 'gJYAABvb0JHtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 293, 293, 0, 293, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (496, 29, 'gJYAABvb0JftSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2933, 2933, 0, 2933, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (497, 29, 'gJYAABvb0JbtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 22, 22, 0, 22, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (498, 29, 'gJYAABvb0JTtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6180, 6180, 0, 6180, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (499, 29, 'gJYAABvb0I3tSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (500, 29, 'gJYAABvb0JXtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (501, 29, 'gJYAABvb0IvtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 31, 31, 0, 0, 0, NULL, 31);
INSERT INTO `eas_wo_dtl` VALUES (502, 29, 'gJYAABvb0IztSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 82, 82, 0, 82, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (503, 29, 'gJYAABvb0JrtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1535, 1535, 0, 1535, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (504, 29, 'gJYAABvb0JDtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 31, 31, 0, 0, 0, NULL, 31);
INSERT INTO `eas_wo_dtl` VALUES (505, 29, 'gJYAABvb0IntSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 82, 82, 0, 82, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (506, 29, 'gJYAABvb0JLtSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6180, 6180, 0, 6180, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (507, 29, 'gJYAABvb0I/tSYg5', 'DgWmabPoS8a/QYAT8jDu4h0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 4606, 4606, 0, 4606, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (508, 30, 'gJYAABvb0KvtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 754, 754, 0, 125, 0, 2, 629);
INSERT INTO `eas_wo_dtl` VALUES (509, 30, 'gJYAABvb0KztSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 138, 138, 0, 138, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (510, 30, 'gJYAABvb0KXtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4694, 4694, 0, 4694, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (511, 30, 'gJYAABvb0K3tSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10147, 10147, 0, 10147, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (512, 30, 'gJYAABvb0KjtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 26, 26, 0, 26, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (513, 30, 'gJYAABvb0KHtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 37, 37, 0, 37, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (514, 30, 'gJYAABvb0K/tSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1050, 1050, 0, 1050, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (515, 30, 'gJYAABvb0J/tSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 10498, 10498, 0, 10498, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (516, 30, 'gJYAABvb0J7tSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 75, 75, 0, 75, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (517, 30, 'gJYAABvb0KrtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 20838, 20838, 0, 20838, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (518, 30, 'gJYAABvb0KntSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (519, 30, 'gJYAABvb0KDtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (520, 30, 'gJYAABvb0KLtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 104, 104, 0, 0, 0, NULL, 104);
INSERT INTO `eas_wo_dtl` VALUES (521, 30, 'gJYAABvb0KTtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 275, 275, 0, 275, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (522, 30, 'gJYAABvb0KftSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5177, 5177, 0, 5177, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (523, 30, 'gJYAABvb0KbtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 104, 104, 0, 0, 0, NULL, 104);
INSERT INTO `eas_wo_dtl` VALUES (524, 30, 'gJYAABvb0LDtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 275, 275, 0, 275, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (525, 30, 'gJYAABvb0K7tSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 20838, 20838, 0, 20838, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (526, 30, 'gJYAABvb0KPtSYg5', 'CmaR0226Qd+kwrHNo3mYLx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 5177, 5177, 0, 5177, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (527, 31, 'gJYAABvb0NvtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 730, 730, 0, 730, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (528, 31, 'gJYAABvb0NLtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 73, 73, 0, 73, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (529, 31, 'gJYAABvb0NDtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 22, 22, 0, 22, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (530, 31, 'gJYAABvb0MrtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2417, 2417, 0, 2417, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (531, 31, 'gJYAABvb0M3tSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (532, 31, 'gJYAABvb0NTtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (533, 31, 'gJYAABvb0NjtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 307, 307, 0, 307, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (534, 31, 'gJYAABvb0NHtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 3068, 3068, 0, 3068, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (535, 31, 'gJYAABvb0NftSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 26, 26, 0, 26, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (536, 31, 'gJYAABvb0M7tSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4963, 4963, 0, 4963, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (537, 31, 'gJYAABvb0NntSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (538, 31, 'gJYAABvb0M/tSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (539, 31, 'gJYAABvb0MntSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 25, 25, 0, 0, 0, NULL, 25);
INSERT INTO `eas_wo_dtl` VALUES (540, 31, 'gJYAABvb0MztSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 66, 66, 0, 66, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (541, 31, 'gJYAABvb0NPtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1233, 1233, 0, 1233, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (542, 31, 'gJYAABvb0NXtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 25, 25, 0, 0, 0, NULL, 25);
INSERT INTO `eas_wo_dtl` VALUES (543, 31, 'gJYAABvb0NbtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 66, 66, 0, 66, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (544, 31, 'gJYAABvb0NrtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4963, 4963, 0, 4963, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (545, 31, 'gJYAABvb0MvtSYg5', 'HQRtpi7QTwSIMTDmEufpix0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1233, 1233, 0, 1233, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (546, 32, 'gJYAABvb0UjtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 150, 150, 0, 150, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (547, 32, 'gJYAABvb0UrtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 44, 44, 0, 0, 0, 2, 44);
INSERT INTO `eas_wo_dtl` VALUES (548, 32, 'gJYAABvb0UTtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 19, 19, 0, 19, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (549, 32, 'gJYAABvb0UXtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 0, 0, 0, 0, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (550, 32, 'gJYAABvb0UntSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 226, 226, 0, 226, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (551, 32, 'gJYAABvb0UvtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (552, 32, 'gJYAABvb0U/tSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (553, 32, 'gJYAABvb0U3tSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 9, 9, 0, 9, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (554, 32, 'gJYAABvb0ULtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 88, 88, 0, 88, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (555, 32, 'gJYAABvb0UztSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (556, 32, 'gJYAABvb0UftSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (557, 32, 'gJYAABvb0UDtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (558, 32, 'gJYAABvb0UbtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (559, 32, 'gJYAABvb0UPtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 50, 50, 0, 50, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (560, 32, 'gJYAABvb0UHtSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (561, 32, 'gJYAABvb0U7tSYg5', 'u8DWxlD0SWea0J8YVjru8B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (562, 33, 'gJYAABvb0VrtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 7080, 7080, 0, 7080, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (563, 33, 'gJYAABvb0V7tSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 4265, 4265, 0, 0, 0, 2, 4265);
INSERT INTO `eas_wo_dtl` VALUES (564, 33, 'gJYAABvb0VXtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 1130, 1130, 0, 479, 0, 2, 651);
INSERT INTO `eas_wo_dtl` VALUES (565, 33, 'gJYAABvb0VjtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 150, 150, 0, 150, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (566, 33, 'gJYAABvb0WHtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 10667, 10667, 0, 10667, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (567, 33, 'gJYAABvb0VztSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (568, 33, 'gJYAABvb0VTtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (569, 33, 'gJYAABvb0V3tSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 353, 353, 0, 353, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (570, 33, 'gJYAABvb0V/tSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3528, 3528, 0, 3528, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (571, 33, 'gJYAABvb0WDtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 9499, 9499, 0, 9499, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (572, 33, 'gJYAABvb0VbtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (573, 33, 'gJYAABvb0WLtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 130, 130, 0, 130, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (574, 33, 'gJYAABvb0VftSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2360, 2360, 0, 2360, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (575, 33, 'gJYAABvb0VvtSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 130, 130, 0, 130, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (576, 33, 'gJYAABvb0VntSYg5', 'ansRP+fvSPSSta9osWtV5h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 9499, 9499, 0, 9499, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (577, 34, 'gJYAABvdIq3tSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 40000, 40000, 0, 40000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (578, 34, 'gJYAABvdIqztSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAAAAFAAxECefw', '01.02.01.001.0055', '荧光粉', '阳光4号', '克', 17804, 17804, 0, 17804, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (579, 34, 'gJYAABvdIqntSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 3008, 3008, 0, 3008, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (580, 34, 'gJYAABvdIqjtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 63200, 63200, 0, 63200, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (581, 34, 'gJYAABvdIrHtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 100, 100, 0, 100, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (582, 34, 'gJYAABvdIqvtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 5218, 5218, 0, 5218, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (583, 34, 'gJYAABvdIq/tSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 52184, 52184, 0, 52184, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (584, 34, 'gJYAABvdIqbtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 308, 308, 0, 308, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (585, 34, 'gJYAABvdIqftSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 48, 48, 0, 48, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (586, 34, 'gJYAABvdIq7tSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (587, 34, 'gJYAABvdIrPtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 40000, 40000, 0, 40000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (588, 34, 'gJYAABvdIrLtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1384, 1384, 0, 1384, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (589, 34, 'gJYAABvdIrTtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 161000, 161000, 0, 161000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (590, 34, 'gJYAABvdIrDtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 161000, 161000, 0, 161000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (591, 34, 'gJYAABvdIqrtSYg5', 'AK5EuP9vTYqPneIE23eRNh0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 464, 464, 0, 464, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (592, 35, 'gJYAABvdI9btSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 27, 27, 0, 0, 0, 2, 27);
INSERT INTO `eas_wo_dtl` VALUES (593, 35, 'gJYAABvdI+DtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 43, 43, 0, 43, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (594, 35, 'gJYAABvdI+HtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 739, 739, 0, 739, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (595, 35, 'gJYAABvdI9rtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4713, 4713, 0, 4713, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (596, 35, 'gJYAABvdI9ztSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (597, 35, 'gJYAABvdI+XtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (598, 35, 'gJYAABvdI9/tSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 211, 211, 0, 211, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (599, 35, 'gJYAABvdI+btSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2114, 2114, 0, 2114, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (600, 35, 'gJYAABvdI+LtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 15, 15, 0, 15, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (601, 35, 'gJYAABvdI9XtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4197, 4197, 0, 4197, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (602, 35, 'gJYAABvdI9vtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (603, 35, 'gJYAABvdI9ntSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (604, 35, 'gJYAABvdI97tSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (605, 35, 'gJYAABvdI+ftSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 55, 55, 0, 55, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (606, 35, 'gJYAABvdI9jtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1043, 1043, 0, 1043, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (607, 35, 'gJYAABvdI+PtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 21, 21, 0, 0, 0, NULL, 21);
INSERT INTO `eas_wo_dtl` VALUES (608, 35, 'gJYAABvdI+TtSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 55, 55, 0, 55, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (609, 35, 'gJYAABvdI93tSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4197, 4197, 0, 4197, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (610, 35, 'gJYAABvdI9ftSYg5', '9nIahuJYQ3O/Z6YCzn/DVR0NgN0=', 'gJYAABctWJxECefw', '06.10.03.001.0074', 'DICE', 'S-DICE-BXCD1029(X10B)', '千个', 3128, 3128, 0, 3128, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (611, 36, 'gJYAABvdJGntSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 31, 31, 0, 31, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (612, 36, 'gJYAABvdJF3tSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1169, 1169, 0, 1169, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (613, 36, 'gJYAABvdJGftSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 34, 34, 0, 34, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (614, 36, 'gJYAABvdJFrtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2967, 2967, 0, 2967, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (615, 36, 'gJYAABvdJGTtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (616, 36, 'gJYAABvdJGrtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (617, 36, 'gJYAABvdJFvtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 338, 338, 0, 338, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (618, 36, 'gJYAABvdJGjtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3383, 3383, 0, 3383, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (619, 36, 'gJYAABvdJFntSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 22, 22, 0, 22, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (620, 36, 'gJYAABvdJGXtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6093, 6093, 0, 6093, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (621, 36, 'gJYAABvdJGPtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (622, 36, 'gJYAABvdJGLtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (623, 36, 'gJYAABvdJFztSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (624, 36, 'gJYAABvdJGHtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (625, 36, 'gJYAABvdJGvtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1514, 1514, 0, 1514, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (626, 36, 'gJYAABvdJF7tSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (627, 36, 'gJYAABvdJGbtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (628, 36, 'gJYAABvdJF/tSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6093, 6093, 0, 6093, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (629, 36, 'gJYAABvdJGDtSYg5', 'EOHMXdfhSouWhUlT/Y9PIx0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1514, 1514, 0, 1514, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (630, 37, 'gJYAABvdJHbtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 143, 143, 0, 143, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (631, 37, 'gJYAABvdJHDtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1621, 1621, 0, 1621, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (632, 37, 'gJYAABvdJHvtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 45, 45, 0, 45, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (633, 37, 'gJYAABvdJHPtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2987, 2987, 0, 2987, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (634, 37, 'gJYAABvdJH3tSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (635, 37, 'gJYAABvdJH/tSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (636, 37, 'gJYAABvdJHztSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 324, 324, 0, 324, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (637, 37, 'gJYAABvdJHXtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3238, 3238, 0, 3238, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (638, 37, 'gJYAABvdJHrtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 22, 22, 0, 22, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (639, 37, 'gJYAABvdJHTtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6134, 6134, 0, 6134, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (640, 37, 'gJYAABvdJHftSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (641, 37, 'gJYAABvdJIDtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (642, 37, 'gJYAABvdJHLtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (643, 37, 'gJYAABvdJHjtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (644, 37, 'gJYAABvdJG/tSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1524, 1524, 0, 1524, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (645, 37, 'gJYAABvdJH7tSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (646, 37, 'gJYAABvdJHHtSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (647, 37, 'gJYAABvdJHntSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6134, 6134, 0, 6134, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (648, 37, 'gJYAABvdJG7tSYg5', 'NAoQuoScRPGmz4DmNpqs8B0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1524, 1524, 0, 1524, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (649, 38, 'gJYAABvdJJftSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 48, 48, 0, 48, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (650, 38, 'gJYAABvdJIjtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 547, 547, 0, 547, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (651, 38, 'gJYAABvdJJbtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 21, 21, 0, 21, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (652, 38, 'gJYAABvdJIbtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1018, 1018, 0, 1018, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (653, 38, 'gJYAABvdJIvtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (654, 38, 'gJYAABvdJJPtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (655, 38, 'gJYAABvdJI7tSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 108, 108, 0, 108, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (656, 38, 'gJYAABvdJJXtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1082, 1082, 0, 1082, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (657, 38, 'gJYAABvdJI3tSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 8, 8, 0, 8, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (658, 38, 'gJYAABvdJJDtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2090, 2090, 0, 2090, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (659, 38, 'gJYAABvdJIftSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (660, 38, 'gJYAABvdJIntSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (661, 38, 'gJYAABvdJI/tSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (662, 38, 'gJYAABvdJJLtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (663, 38, 'gJYAABvdJIXtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 519, 519, 0, 519, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (664, 38, 'gJYAABvdJJHtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (665, 38, 'gJYAABvdJIztSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (666, 38, 'gJYAABvdJIrtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2090, 2090, 0, 2090, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (667, 38, 'gJYAABvdJJTtSYg5', 'JlDD0qGDQ4q7PJ20E+nZIR0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 519, 519, 0, 519, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (668, 39, 'gJYAABvdJKDtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 5, 5, 0, 0, 0, 2, 5);
INSERT INTO `eas_wo_dtl` VALUES (669, 39, 'gJYAABvdJKjtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 5, 5, 0, 5, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (670, 39, 'gJYAABvdJJvtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 86, 86, 0, 86, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (671, 39, 'gJYAABvdJKHtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 204, 204, 0, 204, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (672, 39, 'gJYAABvdJKTtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (673, 39, 'gJYAABvdJKbtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (674, 39, 'gJYAABvdJKPtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 22, 22, 0, 22, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (675, 39, 'gJYAABvdJKntSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 218, 218, 0, 218, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (676, 39, 'gJYAABvdJKrtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (677, 39, 'gJYAABvdJKvtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 418, 418, 0, 418, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (678, 39, 'gJYAABvdJKXtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (679, 39, 'gJYAABvdJJ3tSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (680, 39, 'gJYAABvdJJztSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (681, 39, 'gJYAABvdJJrtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (682, 39, 'gJYAABvdJKftSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 104, 104, 0, 104, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (683, 39, 'gJYAABvdJJ/tSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (684, 39, 'gJYAABvdJKLtSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (685, 39, 'gJYAABvdJJ7tSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 418, 418, 0, 418, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (686, 39, 'gJYAABvdJKztSYg5', 'vIebR12KTZyuRV6Crm87iR0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 104, 104, 0, 104, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (687, 40, 'gJYAABvdJLjtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 5, 5, 0, 0, 0, 2, 5);
INSERT INTO `eas_wo_dtl` VALUES (688, 40, 'gJYAABvdJLbtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 5, 5, 0, 5, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (689, 40, 'gJYAABvdJLLtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 82, 82, 0, 82, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (690, 40, 'gJYAABvdJL7tSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (691, 40, 'gJYAABvdJMHtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (692, 40, 'gJYAABvdJL3tSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (693, 40, 'gJYAABvdJLftSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 22, 22, 0, 22, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (694, 40, 'gJYAABvdJLntSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 216, 216, 0, 216, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (695, 40, 'gJYAABvdJLDtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (696, 40, 'gJYAABvdJLvtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (697, 40, 'gJYAABvdJMLtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (698, 40, 'gJYAABvdJLztSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (699, 40, 'gJYAABvdJLHtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (700, 40, 'gJYAABvdJLrtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (701, 40, 'gJYAABvdJLXtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 103, 103, 0, 103, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (702, 40, 'gJYAABvdJLPtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (703, 40, 'gJYAABvdJMDtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (704, 40, 'gJYAABvdJL/tSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (705, 40, 'gJYAABvdJLTtSYg5', 'hfeoel/QTWi+pITgEiSqXx0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 103, 103, 0, 103, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (706, 41, 'gJYAABvdJMvtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 141, 141, 0, 0, 0, 2, 141);
INSERT INTO `eas_wo_dtl` VALUES (707, 41, 'gJYAABvdJNPtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 73, 73, 0, 73, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (708, 41, 'gJYAABvdJMztSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1045, 1045, 0, 1045, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (709, 41, 'gJYAABvdJMrtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 3011, 3011, 0, 3011, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (710, 41, 'gJYAABvdJNbtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (711, 41, 'gJYAABvdJNftSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (712, 41, 'gJYAABvdJM3tSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 319, 319, 0, 319, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (713, 41, 'gJYAABvdJNLtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 3193, 3193, 0, 3193, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (714, 41, 'gJYAABvdJMbtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 24, 24, 0, 24, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (715, 41, 'gJYAABvdJMftSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 6121, 6121, 0, 6121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (716, 41, 'gJYAABvdJNHtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAA8X1DZECefw', '01.02.13.040.3377', '纸箱', '纸箱245*220*182mm粘胶', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (717, 41, 'gJYAABvdJNDtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (718, 41, 'gJYAABvdJMntSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAAFD8ZECefw', '01.02.13.080.0032', '纯铝印刷袋', '纯铝印刷袋216*240*0.12', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (719, 41, 'gJYAABvdJNTtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (720, 41, 'gJYAABvdJM7tSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1521, 1521, 0, 1521, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (721, 41, 'gJYAABvdJMXtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (722, 41, 'gJYAABvdJNXtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (723, 41, 'gJYAABvdJMjtSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6121, 6121, 0, 6121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (724, 41, 'gJYAABvdJM/tSYg5', 'QdiCJ7E6Tl27kprqVTYWph0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1521, 1521, 0, 1521, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (725, 42, 'gJYAABvdJeLtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 43, 43, 0, 43, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (726, 42, 'gJYAABvdJdvtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 510, 510, 0, 510, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (727, 42, 'gJYAABvdJePtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 37, 37, 0, 37, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (728, 42, 'gJYAABvdJebtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 298, 298, 0, 298, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (729, 42, 'gJYAABvdJeDtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (730, 42, 'gJYAABvdJeTtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (731, 42, 'gJYAABvdJd/tSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 31, 31, 0, 31, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (732, 42, 'gJYAABvdJd7tSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 309, 309, 0, 309, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (733, 42, 'gJYAABvdJdztSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (734, 42, 'gJYAABvdJeXtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 612, 612, 0, 612, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (735, 42, 'gJYAABvdJertSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (736, 42, 'gJYAABvdJeHtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (737, 42, 'gJYAABvdJejtSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 152, 152, 0, 152, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (738, 42, 'gJYAABvdJentSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (739, 42, 'gJYAABvdJeftSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 612, 612, 0, 612, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (740, 42, 'gJYAABvdJd3tSYg5', 'ScKO2E+6QEmVjrbAfKFp7h0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 152, 152, 0, 152, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (741, 43, 'gJYAABvdSVjtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 2100, 2100, 0, 2100, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (742, 43, 'gJYAABvdSVntSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 772, 772, 0, 0, 0, 2, 772);
INSERT INTO `eas_wo_dtl` VALUES (743, 43, 'gJYAABvdSVXtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 296, 296, 0, 296, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (744, 43, 'gJYAABvdSVHtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 28, 28, 0, 28, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (745, 43, 'gJYAABvdSVftSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 3164, 3164, 0, 3164, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (746, 43, 'gJYAABvdSVbtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (747, 43, 'gJYAABvdSU/tSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (748, 43, 'gJYAABvdSVTtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 141, 141, 0, 141, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (749, 43, 'gJYAABvdSVPtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1409, 1409, 0, 1409, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (750, 43, 'gJYAABvdSVztSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 6, 6, 0, 6, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (751, 43, 'gJYAABvdSU7tSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2818, 2818, 0, 2818, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (752, 43, 'gJYAABvdSVLtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (753, 43, 'gJYAABvdSVvtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (754, 43, 'gJYAABvdSVDtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 700, 700, 0, 700, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (755, 43, 'gJYAABvdSVrtSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (756, 43, 'gJYAABvdSV3tSYg5', 'T48vIqbXT8+9dR9AoCskPR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2818, 2818, 0, 2818, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (757, 44, 'gJYAABvdSW7tSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 4950, 4950, 0, 4950, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (758, 44, 'gJYAABvdSXDtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1447, 1447, 0, 0, 0, 2, 1447);
INSERT INTO `eas_wo_dtl` VALUES (759, 44, 'gJYAABvdSWrtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 637, 637, 0, 56, 0, 2, 581);
INSERT INTO `eas_wo_dtl` VALUES (760, 44, 'gJYAABvdSWvtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 15, 15, 0, 15, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (761, 44, 'gJYAABvdSW/tSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 7458, 7458, 0, 7458, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (762, 44, 'gJYAABvdSXHtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (763, 44, 'gJYAABvdSXXtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (764, 44, 'gJYAABvdSXPtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 289, 289, 0, 289, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (765, 44, 'gJYAABvdSWjtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2894, 2894, 0, 2894, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (766, 44, 'gJYAABvdSXLtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 23, 23, 0, 23, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (767, 44, 'gJYAABvdSW3tSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6641, 6641, 0, 6641, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (768, 44, 'gJYAABvdSWbtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (769, 44, 'gJYAABvdSWztSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 91, 91, 0, 91, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (770, 44, 'gJYAABvdSWntSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1650, 1650, 0, 1650, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (771, 44, 'gJYAABvdSWftSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 91, 91, 0, 91, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (772, 44, 'gJYAABvdSXTtSYg5', 'ctCX4jBcSq25Al7QZkjfjB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6641, 6641, 0, 6641, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (773, 45, 'gJYAABvfGKXtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 100000, 100000, 0, 100000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (774, 45, 'gJYAABvfGKTtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 44510, 44510, 0, 44510, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (775, 45, 'gJYAABvfGKHtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 7520, 7520, 0, 7520, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (776, 45, 'gJYAABvfGKDtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 158000, 158000, 0, 158000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (777, 45, 'gJYAABvfGKntSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 250, 250, 0, 250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (778, 45, 'gJYAABvfGKPtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 13046, 13046, 0, 13046, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (779, 45, 'gJYAABvfGKftSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 130460, 130460, 0, 130460, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (780, 45, 'gJYAABvfGJ7tSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 770, 770, 0, 770, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (781, 45, 'gJYAABvfGJ/tSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (782, 45, 'gJYAABvfGKbtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 300, 300, 0, 300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (783, 45, 'gJYAABvfGKvtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 100000, 100000, 0, 100000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (784, 45, 'gJYAABvfGKrtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3460, 3460, 0, 3460, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (785, 45, 'gJYAABvfGKztSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 402500, 402500, 0, 402500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (786, 45, 'gJYAABvfGKjtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 402500, 402500, 0, 402500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (787, 45, 'gJYAABvfGKLtSYg5', 'OSY5w01QSH+r8sKBVUqq5h0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1160, 1160, 0, 1160, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (788, 46, 'gJYAABvfoTftSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 2100, 2100, 0, 2100, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (789, 46, 'gJYAABvfoT/tSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 772, 772, 0, 0, 0, 2, 772);
INSERT INTO `eas_wo_dtl` VALUES (790, 46, 'gJYAABvfoTLtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 286, 286, 0, 0, 0, 2, 286);
INSERT INTO `eas_wo_dtl` VALUES (791, 46, 'gJYAABvfoTDtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 26, 26, 0, 26, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (792, 46, 'gJYAABvfoTjtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 3164, 3164, 0, 3164, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (793, 46, 'gJYAABvfoTvtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (794, 46, 'gJYAABvfoTTtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (795, 46, 'gJYAABvfoT3tSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 72, 72, 0, 72, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (796, 46, 'gJYAABvfoTPtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 720, 720, 0, 720, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (797, 46, 'gJYAABvfoTbtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 6, 6, 0, 6, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (798, 46, 'gJYAABvfoTztSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2818, 2818, 0, 2818, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (799, 46, 'gJYAABvfoTXtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (800, 46, 'gJYAABvfoTHtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (801, 46, 'gJYAABvfoTrtSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 700, 700, 0, 700, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (802, 46, 'gJYAABvfoT7tSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (803, 46, 'gJYAABvfoTntSYg5', 'ho3fyytSRUm+qs/HwTfUXB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2818, 2818, 0, 2818, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (804, 47, 'gJYAABvfoc7tSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 2391, 2391, 0, 2391, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (805, 47, 'gJYAABvfocDtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 263, 263, 0, 263, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (806, 47, 'gJYAABvfocPtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 72, 72, 0, 72, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (807, 47, 'gJYAABvfoc3tSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 10438, 10438, 0, 10438, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (808, 47, 'gJYAABvfocjtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 50, 50, 0, 50, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (809, 47, 'gJYAABvfocHtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (810, 47, 'gJYAABvfocXtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 478, 478, 0, 478, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (811, 47, 'gJYAABvfocztSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4781, 4781, 0, 4781, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (812, 47, 'gJYAABvfocrtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 36, 36, 0, 36, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (813, 47, 'gJYAABvfocntSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10075, 10075, 0, 10075, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (814, 47, 'gJYAABvfocvtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (815, 47, 'gJYAABvfocbtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 146, 146, 0, 146, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (816, 47, 'gJYAABvfoc/tSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2503, 2503, 0, 2503, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (817, 47, 'gJYAABvfocLtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 146, 146, 0, 146, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (818, 47, 'gJYAABvfocftSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10075, 10075, 0, 10075, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (819, 47, 'gJYAABvfocTtSYg5', 'H+lCt31tSBy+IWA9F/XTgx0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 7510, 7510, 0, 7510, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (820, 48, 'gJYAABvielLtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 2201, 2201, 0, 4950, 2749, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (821, 48, 'gJYAABviek7tSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 883, 883, 0, 0, 0, 2, 883);
INSERT INTO `eas_wo_dtl` VALUES (822, 48, 'gJYAABviekztSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 310, 310, 0, 0, 0, 2, 310);
INSERT INTO `eas_wo_dtl` VALUES (823, 48, 'gJYAABviekjtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 29, 29, 0, 65, 36, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (824, 48, 'gJYAABviek3tSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 3315, 3315, 0, 3315, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (825, 48, 'gJYAABviekXtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (826, 48, 'gJYAABviekntSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 8, 8, 0, 17, 10, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (827, 48, 'gJYAABviek/tSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 148, 148, 0, 332, 184, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (828, 48, 'gJYAABviekvtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1477, 1477, 0, 3322, 1845, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (829, 48, 'gJYAABviekTtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 6, 6, 0, 14, 8, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (830, 48, 'gJYAABvielHtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2952, 2952, 0, 6641, 3689, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (831, 48, 'gJYAABviekbtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (832, 48, 'gJYAABviekrtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (833, 48, 'gJYAABviekftSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 734, 734, 0, 1650, 916, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (834, 48, 'gJYAABviekPtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (835, 48, 'gJYAABvielDtSYg5', 'zo6/BOqISgePogs3WvkeBx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2952, 2952, 0, 6641, 3689, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (836, 49, 'gJYAABvieu7tSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 43, 43, 0, 43, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (837, 49, 'gJYAABvieuvtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 165, 165, 0, 165, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (838, 49, 'gJYAABvieuLtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1161, 1161, 0, 1161, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (839, 49, 'gJYAABvieuftSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2380, 2380, 0, 2380, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (840, 49, 'gJYAABvieujtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (841, 49, 'gJYAABvieuHtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (842, 49, 'gJYAABvieu3tSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 246, 246, 0, 246, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (843, 49, 'gJYAABvieurtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2462, 2462, 0, 2462, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (844, 49, 'gJYAABvieuDtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 18, 18, 0, 18, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (845, 49, 'gJYAABvieuTtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4887, 4887, 0, 4887, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (846, 49, 'gJYAABvieuntSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (847, 49, 'gJYAABvieuztSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 71, 71, 0, 71, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (848, 49, 'gJYAABvieuPtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1214, 1214, 0, 1214, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (849, 49, 'gJYAABviet/tSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 71, 71, 0, 71, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (850, 49, 'gJYAABvieuXtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4887, 4887, 0, 4887, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (851, 49, 'gJYAABvieubtSYg5', 'PiJxFH9OSIWMVh9kLGyMqx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 1214, 1214, 0, 1214, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (852, 50, 'gJYAABvjK6XtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 3534, 3534, 0, 3534, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (853, 50, 'gJYAABvjK63tSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 365, 365, 0, 365, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (854, 50, 'gJYAABvjK6rtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 42, 42, 0, 42, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (855, 50, 'gJYAABvjK7TtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8549, 8549, 0, 8549, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (856, 50, 'gJYAABvjK6ntSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (857, 50, 'gJYAABvjK6ztSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 37, 37, 0, 37, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (858, 50, 'gJYAABvjK7LtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 561, 561, 0, 561, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (859, 50, 'gJYAABvjK7HtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5608, 5608, 0, 5608, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (860, 50, 'gJYAABvjK6btSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 54, 54, 0, 54, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (861, 50, 'gJYAABvjK6ftSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8252, 8252, 0, 8252, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (862, 50, 'gJYAABvjK6jtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (863, 50, 'gJYAABvjK67tSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (864, 50, 'gJYAABvjK7PtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2050, 2050, 0, 2050, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (865, 50, 'gJYAABvjK6vtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (866, 50, 'gJYAABvjK7DtSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8252, 8252, 0, 8252, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (867, 50, 'gJYAABvjK6/tSYg5', 'HRhkHfNoSG+g2eMV2XtE0x0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 6151, 6151, 0, 6151, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (868, 51, 'gJYAABvkXFntSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 63, 63, 0, 1500, 1437, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (869, 51, 'gJYAABvkXF3tSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 38, 38, 0, 0, 0, 2, 38);
INSERT INTO `eas_wo_dtl` VALUES (870, 51, 'gJYAABvkXFTtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 10, 10, 0, 0, 0, 2, 10);
INSERT INTO `eas_wo_dtl` VALUES (871, 51, 'gJYAABvkXFftSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 1, 1, 0, 32, 30, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (872, 51, 'gJYAABvkXGDtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 95, 95, 0, 95, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (873, 51, 'gJYAABvkXFvtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (874, 51, 'gJYAABvkXFPtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 5, 5, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (875, 51, 'gJYAABvkXFztSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3, 3, 0, 75, 72, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (876, 51, 'gJYAABvkXF7tSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 31, 31, 0, 748, 716, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (877, 51, 'gJYAABvkXF/tSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 85, 85, 0, 2013, 1928, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (878, 51, 'gJYAABvkXFXtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (879, 51, 'gJYAABvkXGHtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (880, 51, 'gJYAABvkXFbtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 21, 21, 0, 500, 479, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (881, 51, 'gJYAABvkXFrtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (882, 51, 'gJYAABvkXFjtSYg5', 'KGdjcQjqRmK4ncyWato8Rx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 85, 85, 0, 2013, 1928, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (883, 52, 'gJYAABvmj/HtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 100000, 100000, 0, 100000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (884, 52, 'gJYAABvmj/DtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAAAAFAAxECefw', '01.02.01.001.0055', '荧光粉', '阳光4号', '克', 44510, 44510, 0, 44510, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (885, 52, 'gJYAABvmj+3tSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 7520, 7520, 0, 7520, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (886, 52, 'gJYAABvmj+ztSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 158000, 158000, 0, 158000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (887, 52, 'gJYAABvmj/XtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 250, 250, 0, 250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (888, 52, 'gJYAABvmj+/tSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 13046, 13046, 0, 13046, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (889, 52, 'gJYAABvmj/PtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 130460, 130460, 0, 130460, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (890, 52, 'gJYAABvmj+rtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 770, 770, 0, 770, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (891, 52, 'gJYAABvmj+vtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (892, 52, 'gJYAABvmj/LtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 300, 300, 0, 300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (893, 52, 'gJYAABvmj/ftSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 100000, 100000, 0, 100000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (894, 52, 'gJYAABvmj/btSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3460, 3460, 0, 3460, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (895, 52, 'gJYAABvmj/jtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 402500, 402500, 0, 402500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (896, 52, 'gJYAABvmj/TtSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 402500, 402500, 0, 402500, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (897, 52, 'gJYAABvmj+7tSYg5', 'vuORSHvbSziG3tAdpZ2Avx0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1160, 1160, 0, 1160, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (898, 53, 'gJYAABvmmDftSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 93, 93, 0, 93, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (899, 53, 'gJYAABvmmDjtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 847, 847, 0, 847, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (900, 53, 'gJYAABvmmDztSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 304, 304, 0, 304, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (901, 53, 'gJYAABvmmDbtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2085, 2085, 0, 2085, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (902, 53, 'gJYAABvmmEDtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (903, 53, 'gJYAABvmmEHtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (904, 53, 'gJYAABvmmD/tSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 216, 216, 0, 216, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (905, 53, 'gJYAABvmmD3tSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2158, 2158, 0, 2158, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (906, 53, 'gJYAABvmmDvtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 15, 15, 0, 15, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (907, 53, 'gJYAABvmmELtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4281, 4281, 0, 4281, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (908, 53, 'gJYAABvmmDXtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (909, 53, 'gJYAABvmmEPtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 62, 62, 0, 62, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (910, 53, 'gJYAABvmmDntSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1064, 1064, 0, 1064, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (911, 53, 'gJYAABvmmDrtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 62, 62, 0, 62, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (912, 53, 'gJYAABvmmD7tSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4281, 4281, 0, 4281, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (913, 53, 'gJYAABvmmETtSYg5', 'RWppM9RZRdWxuo/wdmDmIx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 1064, 1064, 0, 1064, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (914, 54, 'gJYAABvmmErtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 18, 18, 0, 18, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (915, 54, 'gJYAABvmmFTtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 819, 819, 0, 819, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (916, 54, 'gJYAABvmmE/tSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 21, 21, 0, 21, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (917, 54, 'gJYAABvmmEztSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2062, 2062, 0, 2062, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (918, 54, 'gJYAABvmmEvtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (919, 54, 'gJYAABvmmFXtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (920, 54, 'gJYAABvmmFLtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 247, 247, 0, 247, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (921, 54, 'gJYAABvmmE7tSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2474, 2474, 0, 2474, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (922, 54, 'gJYAABvmmFPtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 15, 15, 0, 15, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (923, 54, 'gJYAABvmmFbtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4233, 4233, 0, 4233, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (924, 54, 'gJYAABvmmEjtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (925, 54, 'gJYAABvmmE3tSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 61, 61, 0, 61, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (926, 54, 'gJYAABvmmFHtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1052, 1052, 0, 1052, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (927, 54, 'gJYAABvmmFDtSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 61, 61, 0, 61, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (928, 54, 'gJYAABvmmFftSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4233, 4233, 0, 4233, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (929, 54, 'gJYAABvmmEntSYg5', '8XRQ1mEeQx2E+jdJgOepNx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 1052, 1052, 0, 1052, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (930, 55, 'gJYAABvmmoHtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 59, 59, 0, 59, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (931, 55, 'gJYAABvmmnrtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1548, 1548, 0, 1548, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (932, 55, 'gJYAABvmmnTtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 52, 52, 0, 52, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (933, 55, 'gJYAABvmmnvtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4035, 4035, 0, 4035, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (934, 55, 'gJYAABvmmnntSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (935, 55, 'gJYAABvmmn7tSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (936, 55, 'gJYAABvmmnbtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 428, 428, 0, 428, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (937, 55, 'gJYAABvmmnXtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 4279, 4279, 0, 4279, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (938, 55, 'gJYAABvmmn/tSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 32, 32, 0, 32, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (939, 55, 'gJYAABvmmoPtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 8202, 8202, 0, 8202, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (940, 55, 'gJYAABvmmn3tSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (941, 55, 'gJYAABvmmnztSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 119, 119, 0, 119, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (942, 55, 'gJYAABvmmnjtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2038, 2038, 0, 2038, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (943, 55, 'gJYAABvmmoLtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 119, 119, 0, 119, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (944, 55, 'gJYAABvmmoDtSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8202, 8202, 0, 8202, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (945, 55, 'gJYAABvmmnftSYg5', 'M23AzIGGT5yNhFOOKY8Kah0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 2038, 2038, 0, 2038, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (946, 56, 'gJYAABvmm6PtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 166, 166, 0, 166, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (947, 56, 'gJYAABvmm6DtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 631, 631, 0, 631, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (948, 56, 'gJYAABvmm5ftSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4453, 4453, 0, 4453, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (949, 56, 'gJYAABvmm5ztSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 9123, 9123, 0, 9123, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (950, 56, 'gJYAABvmm53tSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (951, 56, 'gJYAABvmm5btSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (952, 56, 'gJYAABvmm6LtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 944, 944, 0, 944, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (953, 56, 'gJYAABvmm5/tSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 9439, 9439, 0, 9439, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (954, 56, 'gJYAABvmm5XtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 67, 67, 0, 67, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (955, 56, 'gJYAABvmm5ntSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 18735, 18735, 0, 18735, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (956, 56, 'gJYAABvmm57tSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (957, 56, 'gJYAABvmm6HtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 272, 272, 0, 272, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (958, 56, 'gJYAABvmm5jtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 4655, 4655, 0, 4655, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (959, 56, 'gJYAABvmm5TtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 272, 272, 0, 272, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (960, 56, 'gJYAABvmm5rtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 18735, 18735, 0, 18735, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (961, 56, 'gJYAABvmm5vtSYg5', 'NrRCXid5TXmZvxuwVvLLAx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 4655, 4655, 0, 4655, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (962, 57, 'gJYAABvmm8btSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 73, 73, 0, 73, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (963, 57, 'gJYAABvmm8PtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 278, 278, 0, 278, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (964, 57, 'gJYAABvmm7rtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1962, 1962, 0, 1962, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (965, 57, 'gJYAABvmm7/tSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4019, 4019, 0, 4019, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (966, 57, 'gJYAABvmm8DtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (967, 57, 'gJYAABvmm7ntSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (968, 57, 'gJYAABvmm8XtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 416, 416, 0, 416, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (969, 57, 'gJYAABvmm8LtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4158, 4158, 0, 4158, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (970, 57, 'gJYAABvmm7jtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 30, 30, 0, 30, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (971, 57, 'gJYAABvmm7ztSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8254, 8254, 0, 8254, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (972, 57, 'gJYAABvmm8HtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (973, 57, 'gJYAABvmm8TtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (974, 57, 'gJYAABvmm7vtSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2051, 2051, 0, 2051, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (975, 57, 'gJYAABvmm7ftSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 120, 120, 0, 120, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (976, 57, 'gJYAABvmm73tSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8254, 8254, 0, 8254, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (977, 57, 'gJYAABvmm77tSYg5', 'ea0PQ49NQuGJ2yWGsHGtDR0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 2051, 2051, 0, 2051, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (978, 58, 'gJYAABvnS6ftSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 361, 361, 0, 218, 0, 2, 143);
INSERT INTO `eas_wo_dtl` VALUES (979, 58, 'gJYAABvnS6TtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 359, 359, 0, 359, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (980, 58, 'gJYAABvnS6HtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 6017, 6017, 0, 6017, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (981, 58, 'gJYAABvnS6ztSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 14743, 14743, 0, 14743, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (982, 58, 'gJYAABvnS67tSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 38, 38, 0, 38, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (983, 58, 'gJYAABvnS6vtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (984, 58, 'gJYAABvnS6XtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1579, 1579, 0, 1579, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (985, 58, 'gJYAABvnS6ntSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 15793, 15793, 0, 15793, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (986, 58, 'gJYAABvnS6DtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 117, 117, 0, 117, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (987, 58, 'gJYAABvnS6rtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 30276, 30276, 0, 30276, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (988, 58, 'gJYAABvnS6jtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (989, 58, 'gJYAABvnS6btSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 439, 439, 0, 439, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (990, 58, 'gJYAABvnS6PtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 7522, 7522, 0, 7522, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (991, 58, 'gJYAABvnS5/tSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 439, 439, 0, 439, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (992, 58, 'gJYAABvnS63tSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 30276, 30276, 0, 30276, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (993, 58, 'gJYAABvnS6LtSYg5', 'LMcAp/RnSxyKMq7MgQcUIR0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 7522, 7522, 0, 7522, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (994, 59, 'gJYAABvnS7ntSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 164, 164, 0, 0, 0, 2, 164);
INSERT INTO `eas_wo_dtl` VALUES (995, 59, 'gJYAABvnS7btSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 163, 163, 0, 163, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (996, 59, 'gJYAABvnS7PtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2734, 2734, 0, 2734, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (997, 59, 'gJYAABvnS77tSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6700, 6700, 0, 6700, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (998, 59, 'gJYAABvnS8DtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (999, 59, 'gJYAABvnS73tSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1000, 59, 'gJYAABvnS7ftSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 718, 718, 0, 718, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1001, 59, 'gJYAABvnS7vtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 7177, 7177, 0, 7177, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1002, 59, 'gJYAABvnS7LtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 53, 53, 0, 53, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1003, 59, 'gJYAABvnS7ztSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 13759, 13759, 0, 13759, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1004, 59, 'gJYAABvnS7rtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1005, 59, 'gJYAABvnS7jtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 200, 200, 0, 200, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1006, 59, 'gJYAABvnS7XtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3418, 3418, 0, 3418, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1007, 59, 'gJYAABvnS7HtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 200, 200, 0, 200, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1008, 59, 'gJYAABvnS7/tSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13759, 13759, 0, 13759, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1009, 59, 'gJYAABvnS7TtSYg5', '4LJFSm1pTum1qMADTiHP3x0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 3418, 3418, 0, 3418, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1010, 60, 'gJYAABvnS+HtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 318, 318, 0, 0, 0, 2, 318);
INSERT INTO `eas_wo_dtl` VALUES (1011, 60, 'gJYAABvnS97tSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 37, 37, 0, 37, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1012, 60, 'gJYAABvnS+DtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1740, 1740, 0, 1740, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1013, 60, 'gJYAABvnS9ztSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4178, 4178, 0, 4178, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1014, 60, 'gJYAABvnS9ntSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 15, 15, 0, 15, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1015, 60, 'gJYAABvnS9jtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1016, 60, 'gJYAABvnS9TtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 360, 360, 0, 360, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1017, 60, 'gJYAABvnS93tSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3595, 3595, 0, 3595, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1018, 60, 'gJYAABvnS9PtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 42, 42, 0, 42, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1019, 60, 'gJYAABvnS+LtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4946, 4946, 0, 4946, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1020, 60, 'gJYAABvnS9/tSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 4, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1021, 60, 'gJYAABvnS9vtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 72, 72, 0, 72, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1022, 60, 'gJYAABvnS9XtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1229, 1229, 0, 1229, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1023, 60, 'gJYAABvnS9rtSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 72, 72, 0, 72, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1024, 60, 'gJYAABvnS9btSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4946, 4946, 0, 4946, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1025, 60, 'gJYAABvnS9ftSYg5', 'lwPedDMgQxC4I5VTjgucfx0NgN0=', 'gJYAABc3p0xECefw', '06.10.03.001.0091', 'DICE', 'S-DICE-BXHV1931', '千个', 2458, 2458, 0, 2458, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1026, 61, 'gJYAABvnS+rtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 343, 343, 0, 343, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1027, 61, 'gJYAABvnS/HtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2413, 2413, 0, 2413, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1028, 61, 'gJYAABvnS+3tSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 64, 64, 0, 64, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1029, 61, 'gJYAABvnS+btSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4929, 4929, 0, 4929, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1030, 61, 'gJYAABvnS+ntSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1031, 61, 'gJYAABvnS+jtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1032, 61, 'gJYAABvnS+7tSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 512, 512, 0, 512, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1033, 61, 'gJYAABvnS+vtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5117, 5117, 0, 5117, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1034, 61, 'gJYAABvnS+/tSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 36, 36, 0, 36, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1035, 61, 'gJYAABvnS/LtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10122, 10122, 0, 10122, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1036, 61, 'gJYAABvnS+ztSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1037, 61, 'gJYAABvnS+XtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 147, 147, 0, 147, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1038, 61, 'gJYAABvnS/PtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 2515, 2515, 0, 2515, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1039, 61, 'gJYAABvnS+ftSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 147, 147, 0, 147, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1040, 61, 'gJYAABvnS/DtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10122, 10122, 0, 10122, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1041, 61, 'gJYAABvnS/TtSYg5', 'y5PWOdlTQS+wG6sISys52h0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 2515, 2515, 0, 2515, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1042, 62, 'gJYAABvnTALtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 323, 323, 0, 323, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1043, 62, 'gJYAABvnTAHtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2414, 2414, 0, 2414, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1044, 62, 'gJYAABvnTArtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 90, 90, 0, 90, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1045, 62, 'gJYAABvnTAbtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4930, 4930, 0, 4930, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1046, 62, 'gJYAABvnTAntSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1047, 62, 'gJYAABvnTAztSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1048, 62, 'gJYAABvnTAjtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 524, 524, 0, 524, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1049, 62, 'gJYAABvnTAXtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5242, 5242, 0, 5242, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1050, 62, 'gJYAABvnTATtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 36, 36, 0, 36, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1051, 62, 'gJYAABvnTAvtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10125, 10125, 0, 10125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1052, 62, 'gJYAABvnS//tSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1053, 62, 'gJYAABvnTADtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 147, 147, 0, 147, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1054, 62, 'gJYAABvnTAftSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 2516, 2516, 0, 2516, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1055, 62, 'gJYAABvnTA3tSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 147, 147, 0, 147, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1056, 62, 'gJYAABvnTAPtSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10125, 10125, 0, 10125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1057, 62, 'gJYAABvnS/7tSYg5', 'MTcCC1JAS/usZvyCPXMNUB0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 2516, 2516, 0, 2516, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1058, 63, 'gJYAABvnTQztSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 10291, 10291, 0, 10291, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1059, 63, 'gJYAABvnTQntSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1486, 1486, 0, 790, 0, 2, 696);
INSERT INTO `eas_wo_dtl` VALUES (1060, 63, 'gJYAABvnTRTtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 23840, 23840, 0, 23840, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1061, 63, 'gJYAABvnTQ7tSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 114, 114, 0, 114, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1062, 63, 'gJYAABvnTQ/tSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 103, 103, 0, 103, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1063, 63, 'gJYAABvnTRbtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1172, 1172, 0, 1172, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1064, 63, 'gJYAABvnTRHtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 11716, 11716, 0, 11716, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1065, 63, 'gJYAABvnTQrtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 69, 69, 0, 69, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1066, 63, 'gJYAABvnTQvtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 23011, 23011, 0, 23011, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1067, 63, 'gJYAABvnTRPtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 19, 19, 0, 19, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1068, 63, 'gJYAABvnTRftSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 334, 334, 0, 334, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1069, 63, 'gJYAABvnTRXtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5717, 5717, 0, 5717, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1070, 63, 'gJYAABvnTRLtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 334, 334, 0, 334, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1071, 63, 'gJYAABvnTRDtSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 23011, 23011, 0, 23011, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1072, 63, 'gJYAABvnTQ3tSYg5', 'es4OuuS6RQem/UBJ+pb7xB0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 17151, 17151, 0, 17151, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1073, 64, 'gJYAABvrK4rtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 70, 70, 0, 70, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1074, 64, 'gJYAABvrK4ftSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 2, 2, 0, 0, 0, 2, 2);
INSERT INTO `eas_wo_dtl` VALUES (1075, 64, 'gJYAABvrK47tSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 4, 4, 0, 0, 0, 2, 4);
INSERT INTO `eas_wo_dtl` VALUES (1076, 64, 'gJYAABvrK4ntSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 64, 64, 0, 64, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1077, 64, 'gJYAABvrK4TtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1078, 64, 'gJYAABvrK4ztSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1079, 64, 'gJYAABvrK4LtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 7, 7, 0, 7, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1080, 64, 'gJYAABvrK4jtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 74, 74, 0, 74, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1081, 64, 'gJYAABvrK4/tSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1082, 64, 'gJYAABvrK4XtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 131, 131, 0, 131, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1083, 64, 'gJYAABvrK5DtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1084, 64, 'gJYAABvrK4btSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (1085, 64, 'gJYAABvrK43tSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 33, 33, 0, 33, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1086, 64, 'gJYAABvrK4vtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (1087, 64, 'gJYAABvrK5HtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 131, 131, 0, 131, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1088, 64, 'gJYAABvrK4PtSYg5', 'IZRWtQXoRJWrDs6+lzDzgR0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 33, 33, 0, 33, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1089, 65, 'gJYAABvrK6LtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 28, 28, 0, 28, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1090, 65, 'gJYAABvrK6jtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 0, 0, 0, 0, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1091, 65, 'gJYAABvrK6PtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 3, 3, 0, 0, 0, 2, 3);
INSERT INTO `eas_wo_dtl` VALUES (1092, 65, 'gJYAABvrK57tSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1093, 65, 'gJYAABvrK6ztSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1094, 65, 'gJYAABvrK6ntSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1095, 65, 'gJYAABvrK6ftSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 4, 4, 0, 4, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1096, 65, 'gJYAABvrK6btSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 39, 39, 0, 39, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1097, 65, 'gJYAABvrK6rtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1098, 65, 'gJYAABvrK6DtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 65, 65, 0, 65, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1099, 65, 'gJYAABvrK6HtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1100, 65, 'gJYAABvrK5/tSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (1101, 65, 'gJYAABvrK6XtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 16, 16, 0, 16, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1102, 65, 'gJYAABvrK63tSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (1103, 65, 'gJYAABvrK6vtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 65, 65, 0, 65, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1104, 65, 'gJYAABvrK6TtSYg5', 'u4+ds8VmSDixDcydozMeQx0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 16, 16, 0, 16, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1105, 66, 'gJYAABvrK7rtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 49, 49, 0, 49, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1106, 66, 'gJYAABvrK7LtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 1, 1, 0, 0, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (1107, 66, 'gJYAABvrK77tSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 5, 5, 0, 0, 0, 2, 5);
INSERT INTO `eas_wo_dtl` VALUES (1108, 66, 'gJYAABvrK7ztSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1109, 66, 'gJYAABvrK73tSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1110, 66, 'gJYAABvrK7HtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1111, 66, 'gJYAABvrK7/tSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 8, 8, 0, 8, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1112, 66, 'gJYAABvrK7PtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 82, 82, 0, 82, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1113, 66, 'gJYAABvrK7vtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1114, 66, 'gJYAABvrK7jtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 124, 124, 0, 124, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1115, 66, 'gJYAABvrK7TtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1116, 66, 'gJYAABvrK7DtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (1117, 66, 'gJYAABvrK7XtSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 31, 31, 0, 31, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1118, 66, 'gJYAABvrK7ntSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (1119, 66, 'gJYAABvrK7ftSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 124, 124, 0, 124, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1120, 66, 'gJYAABvrK7btSYg5', '12ROCjmgRHeE5juvu111Bx0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 31, 31, 0, 31, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1121, 67, 'gJYAABvtH9DtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 95, 95, 0, 95, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1122, 67, 'gJYAABvrK8XtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 3, 3, 0, 0, 0, 2, 3);
INSERT INTO `eas_wo_dtl` VALUES (1123, 67, 'gJYAABvtH8/tSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 16, 16, 0, 0, 0, 2, 16);
INSERT INTO `eas_wo_dtl` VALUES (1124, 67, 'gJYAABvtH8vtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 117, 117, 0, 117, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1125, 67, 'gJYAABvtH8ntSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1126, 67, 'gJYAABvtH8jtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1127, 67, 'gJYAABvtH83tSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 14, 14, 0, 14, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1128, 67, 'gJYAABvtH8ztSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 136, 136, 0, 136, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1129, 67, 'gJYAABvtH87tSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1130, 67, 'gJYAABvtH8rtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 240, 240, 0, 240, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1131, 67, 'gJYAABvrK8LtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1132, 67, 'gJYAABvrK8TtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (1133, 67, 'gJYAABvrK8PtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 60, 60, 0, 60, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1134, 67, 'gJYAABvrK8btSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (1135, 67, 'gJYAABvrK8ftSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 240, 240, 0, 240, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1136, 67, 'gJYAABvtH9HtSYg5', '/1llp0N1RdSiV2lV0Qy4RR0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 60, 60, 0, 60, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1137, 68, 'gJYAABvtH9rtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 154, 154, 0, 0, 0, 2, 154);
INSERT INTO `eas_wo_dtl` VALUES (1138, 68, 'gJYAABvtH+TtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 153, 153, 0, 153, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1139, 68, 'gJYAABvtH9ftSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2664, 2664, 0, 2664, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1140, 68, 'gJYAABvtH9vtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6273, 6273, 0, 6273, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1141, 68, 'gJYAABvtH93tSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1142, 68, 'gJYAABvtH9/tSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1143, 68, 'gJYAABvtH9ztSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 672, 672, 0, 672, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1144, 68, 'gJYAABvtH+PtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 6720, 6720, 0, 6720, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1145, 68, 'gJYAABvtH+LtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 50, 50, 0, 50, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1146, 68, 'gJYAABvtH+XtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 12882, 12882, 0, 12882, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1147, 68, 'gJYAABvtH+DtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1148, 68, 'gJYAABvtH9ntSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 187, 187, 0, 187, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1149, 68, 'gJYAABvtH+HtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3201, 3201, 0, 3201, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1150, 68, 'gJYAABvtH97tSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 187, 187, 0, 187, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1151, 68, 'gJYAABvtH9jtSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12882, 12882, 0, 12882, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1152, 68, 'gJYAABvtH+btSYg5', '52VlFuYoR8y5fRnQ48pY5B0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 3201, 3201, 0, 3201, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1153, 69, 'gJYAABvtH/PtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 234, 234, 0, 234, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1154, 69, 'gJYAABvtH+3tSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 14, 14, 0, 0, 0, 2, 14);
INSERT INTO `eas_wo_dtl` VALUES (1155, 69, 'gJYAABvtH/TtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 4, 4, 0, 4, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1156, 69, 'gJYAABvtH/DtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 424, 424, 0, 424, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1157, 69, 'gJYAABvtH+/tSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1158, 69, 'gJYAABvtH+ztSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1159, 69, 'gJYAABvtH/LtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 23, 23, 0, 23, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1160, 69, 'gJYAABvtH/btSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 226, 226, 0, 226, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1161, 69, 'gJYAABvtH/XtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1162, 69, 'gJYAABvtH+7tSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 409, 409, 0, 409, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1163, 69, 'gJYAABvtH/ftSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1164, 69, 'gJYAABvtH/HtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1165, 69, 'gJYAABvtH+ntSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 102, 102, 0, 102, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1166, 69, 'gJYAABvtH+vtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1167, 69, 'gJYAABvtH+rtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 409, 409, 0, 409, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1168, 69, 'gJYAABvtH/jtSYg5', 'h5xmTGd2S2Go1q2pa4B8sx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 305, 305, 0, 305, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1169, 70, 'gJYAABvtIAftSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 185, 185, 0, 185, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1170, 70, 'gJYAABvtIAztSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 27, 27, 0, 0, 0, 2, 27);
INSERT INTO `eas_wo_dtl` VALUES (1171, 70, 'gJYAABvtIA7tSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 428, 428, 0, 428, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1172, 70, 'gJYAABvtIBDtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1173, 70, 'gJYAABvtIAvtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1174, 70, 'gJYAABvtIA/tSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 21, 21, 0, 21, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1175, 70, 'gJYAABvtIAbtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 210, 210, 0, 210, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1176, 70, 'gJYAABvtIArtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1177, 70, 'gJYAABvtIBPtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1178, 70, 'gJYAABvtIA3tSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1179, 70, 'gJYAABvtIAntSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1180, 70, 'gJYAABvtIBLtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 103, 103, 0, 103, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1181, 70, 'gJYAABvtIAjtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1182, 70, 'gJYAABvtIBHtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 413, 413, 0, 413, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1183, 70, 'gJYAABvtIBTtSYg5', 'XJSNofdlQWeg41GL+AfzEx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 308, 308, 0, 308, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1184, 71, 'gJYAABvtIDLtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 2043, 2043, 0, 2043, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1185, 71, 'gJYAABvtICTtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 225, 225, 0, 225, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1186, 71, 'gJYAABvtICftSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 61, 61, 0, 61, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1187, 71, 'gJYAABvtIDHtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8918, 8918, 0, 8918, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1188, 71, 'gJYAABvtICztSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 43, 43, 0, 43, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1189, 71, 'gJYAABvtICXtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 28, 28, 0, 28, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1190, 71, 'gJYAABvtICntSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 408, 408, 0, 408, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1191, 71, 'gJYAABvtIDDtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4085, 4085, 0, 4085, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1192, 71, 'gJYAABvtIC7tSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 31, 31, 0, 31, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1193, 71, 'gJYAABvtIC3tSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8608, 8608, 0, 8608, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1194, 71, 'gJYAABvtIC/tSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1195, 71, 'gJYAABvtICrtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1196, 71, 'gJYAABvtIDPtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2139, 2139, 0, 2139, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1197, 71, 'gJYAABvtICbtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1198, 71, 'gJYAABvtICvtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8608, 8608, 0, 8608, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1199, 71, 'gJYAABvtICjtSYg5', '2Iln5wiySFOgPnjGQc+UDx0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 6416, 6416, 0, 6416, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1200, 72, 'gJYAABvtIDntSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 9071, 9071, 0, 9071, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1201, 72, 'gJYAABvtIDbtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 654, 654, 0, 0, 0, 2, 654);
INSERT INTO `eas_wo_dtl` VALUES (1202, 72, 'gJYAABvtIEHtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 221, 221, 0, 221, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1203, 72, 'gJYAABvtIDztSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 17347, 17347, 0, 17347, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1204, 72, 'gJYAABvtIDrtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 83, 83, 0, 83, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1205, 72, 'gJYAABvtID7tSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 75, 75, 0, 75, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1206, 72, 'gJYAABvtIDjtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 996, 996, 0, 996, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1207, 72, 'gJYAABvtIEXtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 9963, 9963, 0, 9963, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1208, 72, 'gJYAABvtIEPtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 121, 121, 0, 121, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1209, 72, 'gJYAABvtID3tSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 16744, 16744, 0, 16744, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1210, 72, 'gJYAABvtIELtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1211, 72, 'gJYAABvtIETtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 243, 243, 0, 243, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1212, 72, 'gJYAABvtID/tSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 4160, 4160, 0, 4160, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1213, 72, 'gJYAABvtIEDtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 243, 243, 0, 40, 0, NULL, 203);
INSERT INTO `eas_wo_dtl` VALUES (1214, 72, 'gJYAABvtIDvtSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 16744, 16744, 0, 16744, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1215, 72, 'gJYAABvtIDftSYg5', 'jo9oszhNTvGOg5PKbtH3Gh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 12480, 12480, 0, 12480, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1216, 73, 'gJYAABvtIsrtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 21, 21, 0, 21, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1217, 73, 'gJYAABvtIsDtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAABTLY1lECefw', '01.02.01.001.1218', '荧光粉', 'KSR-001', '克', 1, 1, 0, 0, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (1218, 73, 'gJYAABvtIs/tSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1, 1, 0, 0, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (1219, 73, 'gJYAABvtIsTtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 39, 39, 0, 39, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1220, 73, 'gJYAABvtIs7tSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1221, 73, 'gJYAABvtIsXtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1222, 73, 'gJYAABvtIsztSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1, 1, 0, 1, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1223, 73, 'gJYAABvtIsjtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 46, 46, 0, 46, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1224, 73, 'gJYAABvtIsPtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1225, 73, 'gJYAABvtIsLtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 80, 80, 0, 80, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1226, 73, 'gJYAABvtIsftSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1227, 73, 'gJYAABvtIsntSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (1228, 73, 'gJYAABvtIsbtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 20, 20, 0, 20, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1229, 73, 'gJYAABvtIsvtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (1230, 73, 'gJYAABvtIsHtSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 80, 80, 0, 80, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1231, 73, 'gJYAABvtIs3tSYg5', 'oy1/fkkBRA+5jXznQS17bR0NgN0=', 'gJYAABl73TJECefw', '06.10.03.001.0105', 'DICE', 'S-DICE-BXQC2630', '千个', 20, 20, 0, 20, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1232, 74, 'gJYAABvuSZTtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 60, 60, 0, 60, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1233, 74, 'gJYAABvuSZjtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 36, 36, 0, 0, 0, 2, 36);
INSERT INTO `eas_wo_dtl` VALUES (1234, 74, 'gJYAABvuSY/tSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 10, 10, 0, 0, 0, 2, 10);
INSERT INTO `eas_wo_dtl` VALUES (1235, 74, 'gJYAABvuSZLtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 1, 1, 0, 1, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1236, 74, 'gJYAABvuSZvtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 90, 90, 0, 90, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1237, 74, 'gJYAABvuSZbtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1238, 74, 'gJYAABvuSY7tSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1239, 74, 'gJYAABvuSZftSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3, 3, 0, 3, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1240, 74, 'gJYAABvuSZntSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 30, 30, 0, 30, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1241, 74, 'gJYAABvuSZrtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1242, 74, 'gJYAABvuSZDtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1243, 74, 'gJYAABvuSZztSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1244, 74, 'gJYAABvuSZHtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 20, 20, 0, 20, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1245, 74, 'gJYAABvuSZXtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (1246, 74, 'gJYAABvuSZPtSYg5', 'FaHScC2+TTG4/VDp7eHRdB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1247, 75, 'gJYAABv5+dXtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 182, 182, 0, 182, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1248, 75, 'gJYAABv5+d3tSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 26, 26, 0, 0, 0, 2, 26);
INSERT INTO `eas_wo_dtl` VALUES (1249, 75, 'gJYAABv5+eDtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 421, 421, 0, 421, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1250, 75, 'gJYAABv5+dTtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1251, 75, 'gJYAABv5+dPtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1252, 75, 'gJYAABv5+dLtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 21, 21, 0, 21, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1253, 75, 'gJYAABv5+d/tSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 207, 207, 0, 207, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1254, 75, 'gJYAABv5+djtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1255, 75, 'gJYAABv5+dbtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 406, 406, 0, 406, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1256, 75, 'gJYAABv5+drtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1257, 75, 'gJYAABv5+dztSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1258, 75, 'gJYAABv5+dftSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 101, 101, 0, 101, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1259, 75, 'gJYAABv5+dvtSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (1260, 75, 'gJYAABv5+dntSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 406, 406, 0, 406, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1261, 75, 'gJYAABv5+d7tSYg5', '3n+AjoyCR4WwKljMAR60kh0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 303, 303, 0, 303, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1262, 76, 'gJYAABv5+fvtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 226, 226, 0, 226, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1263, 76, 'gJYAABv5+f3tSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 13, 13, 0, 0, 0, 2, 13);
INSERT INTO `eas_wo_dtl` VALUES (1264, 76, 'gJYAABv5+fTtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 4, 4, 0, 4, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1265, 76, 'gJYAABv5+fjtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABX2AeNECefw', '01.02.01.001.1256', '荧光粉', 'KSL310', '克', 12, 12, 0, 0, 0, 2, 12);
INSERT INTO `eas_wo_dtl` VALUES (1266, 76, 'gJYAABv5+fntSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 423, 423, 0, 423, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1267, 76, 'gJYAABv5+fDtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1268, 76, 'gJYAABv5+fztSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1269, 76, 'gJYAABv5+fXtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 23, 23, 0, 23, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1270, 76, 'gJYAABv5+fPtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 225, 225, 0, 225, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1271, 76, 'gJYAABv5+e/tSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 2, 2, 0, 2, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1272, 76, 'gJYAABv5+frtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 408, 408, 0, 408, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1273, 76, 'gJYAABv5+fHtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1274, 76, 'gJYAABv5+fLtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1275, 76, 'gJYAABv5+fbtSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 101, 101, 0, 101, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1276, 76, 'gJYAABv5+f7tSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (1277, 76, 'gJYAABv5+f/tSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 408, 408, 0, 408, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1278, 76, 'gJYAABv5+fftSYg5', '4hNR6ulDQUWZwUay1L6WWB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 304, 304, 0, 304, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1279, 77, 'gJYAABv5+gjtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 110, 110, 0, 110, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1280, 77, 'gJYAABv5+g7tSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1033, 1033, 0, 1033, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1281, 77, 'gJYAABv5+gvtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 43, 43, 0, 43, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1282, 77, 'gJYAABv5+gPtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2102, 2102, 0, 2102, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1283, 77, 'gJYAABv5+hLtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1284, 77, 'gJYAABv5+gztSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1285, 77, 'gJYAABv5+gXtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 224, 224, 0, 224, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1286, 77, 'gJYAABv5+gbtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2235, 2235, 0, 2235, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1287, 77, 'gJYAABv5+gftSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 16, 16, 0, 16, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1288, 77, 'gJYAABv5+gntSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4318, 4318, 0, 4318, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1289, 77, 'gJYAABv5+hHtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1290, 77, 'gJYAABv5+gTtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 63, 63, 0, 63, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1291, 77, 'gJYAABv5+grtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1073, 1073, 0, 1073, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1292, 77, 'gJYAABv5+hDtSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 63, 63, 0, 0, 0, NULL, 63);
INSERT INTO `eas_wo_dtl` VALUES (1293, 77, 'gJYAABv5+g/tSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4318, 4318, 0, 4318, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1294, 77, 'gJYAABv5+g3tSYg5', '0Pu/fnj3QoCfyUqXJg7/Wx0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1073, 1073, 0, 1073, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1295, 78, 'gJYAABv5+l3tSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 60, 60, 0, 60, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1296, 78, 'gJYAABv5+mHtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 36, 36, 0, 0, 0, 2, 36);
INSERT INTO `eas_wo_dtl` VALUES (1297, 78, 'gJYAABv5+ljtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 10, 10, 0, 0, 0, 2, 10);
INSERT INTO `eas_wo_dtl` VALUES (1298, 78, 'gJYAABv5+lvtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 1, 1, 0, 1, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1299, 78, 'gJYAABv5+mTtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 90, 90, 0, 90, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1300, 78, 'gJYAABv5+l/tSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1301, 78, 'gJYAABv5+lftSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1302, 78, 'gJYAABv5+mDtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3, 3, 0, 3, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1303, 78, 'gJYAABv5+mLtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 30, 30, 0, 30, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1304, 78, 'gJYAABv5+mPtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1305, 78, 'gJYAABv5+lntSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1306, 78, 'gJYAABv5+mXtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1307, 78, 'gJYAABv5+lrtSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 20, 20, 0, 20, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1308, 78, 'gJYAABv5+l7tSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (1309, 78, 'gJYAABv5+lztSYg5', '38CD/0ZnSmOvlqdbA8PjHB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 81, 81, 0, 81, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1310, 79, 'gJYAABv8hsbtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 979, 979, 0, 979, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1311, 79, 'gJYAABv8hs7tSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 147, 147, 0, 147, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1312, 79, 'gJYAABv8hsjtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 34, 34, 0, 34, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1313, 79, 'gJYAABv8hs3tSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2007, 2007, 0, 2007, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1314, 79, 'gJYAABv8htHtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1315, 79, 'gJYAABv8htLtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1316, 79, 'gJYAABv8hsztSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 245, 245, 0, 245, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1317, 79, 'gJYAABv8htDtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2447, 2447, 0, 2447, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1318, 79, 'gJYAABv8hsrtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 20, 20, 0, 20, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1319, 79, 'gJYAABv8hsvtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4121, 4121, 0, 4121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1320, 79, 'gJYAABv8hs/tSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1321, 79, 'gJYAABv8hsntSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1322, 79, 'gJYAABv8htTtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1024, 1024, 0, 1024, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1323, 79, 'gJYAABv8htPtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 60, 60, 0, 0, 0, NULL, 60);
INSERT INTO `eas_wo_dtl` VALUES (1324, 79, 'gJYAABv8hsftSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4121, 4121, 0, 4121, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1325, 79, 'gJYAABv8hsXtSYg5', '6Iq/vpThRTGWfrMOu7wcSh0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1024, 1024, 0, 1024, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1326, 80, 'gJYAABv8huftSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 97, 97, 0, 97, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1327, 80, 'gJYAABv8htrtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1102, 1102, 0, 1102, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1328, 80, 'gJYAABv8huXtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 42, 42, 0, 42, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1329, 80, 'gJYAABv8htntSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2050, 2050, 0, 2050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1330, 80, 'gJYAABv8ht7tSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1331, 80, 'gJYAABv8huLtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1332, 80, 'gJYAABv8huDtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 218, 218, 0, 218, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1333, 80, 'gJYAABv8huTtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2180, 2180, 0, 2180, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1334, 80, 'gJYAABv8ht/tSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 15, 15, 0, 15, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1335, 80, 'gJYAABv8huHtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4211, 4211, 0, 4211, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1336, 80, 'gJYAABv8htvtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1337, 80, 'gJYAABv8htztSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 61, 61, 0, 61, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1338, 80, 'gJYAABv8htjtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1046, 1046, 0, 1046, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1339, 80, 'gJYAABv8hubtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 61, 61, 0, 0, 0, NULL, 61);
INSERT INTO `eas_wo_dtl` VALUES (1340, 80, 'gJYAABv8ht3tSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4211, 4211, 0, 4211, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1341, 80, 'gJYAABv8huPtSYg5', 'dVpF60OzS9GiWWXjKZv8cB0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1046, 1046, 0, 1046, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1342, 81, 'gJYAABv8hvDtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 2503, 2503, 0, 2503, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1343, 81, 'gJYAABv8hvftSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 17594, 17594, 0, 17594, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1344, 81, 'gJYAABv8hvPtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 469, 469, 0, 469, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1345, 81, 'gJYAABv8hu3tSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 35940, 35940, 0, 35940, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1346, 81, 'gJYAABv8hu/tSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 92, 92, 0, 92, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1347, 81, 'gJYAABv8hu7tSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 132, 132, 0, 132, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1348, 81, 'gJYAABv8hvTtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3732, 3732, 0, 3732, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1349, 81, 'gJYAABv8hvHtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 37311, 37311, 0, 37311, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1350, 81, 'gJYAABv8hvXtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 266, 266, 0, 266, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1351, 81, 'gJYAABv8hvjtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 73805, 73805, 0, 73805, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1352, 81, 'gJYAABv8hvLtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 59, 59, 0, 59, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1353, 81, 'gJYAABv8huvtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 1071, 1071, 0, 1071, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1354, 81, 'gJYAABv8hvntSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 18337, 18337, 0, 18337, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1355, 81, 'gJYAABv8huztSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1071, 1071, 0, 0, 0, NULL, 1071);
INSERT INTO `eas_wo_dtl` VALUES (1356, 81, 'gJYAABv8hvbtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 73805, 73805, 0, 73805, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1357, 81, 'gJYAABv8hvrtSYg5', 'kJ7oVrz/QMWneIZQfKMkSh0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 18337, 18337, 0, 18337, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1358, 82, 'gJYAABv8hwHtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 2318, 2318, 0, 2318, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1359, 82, 'gJYAABv8hwDtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 17324, 17324, 0, 17324, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1360, 82, 'gJYAABv8hwntSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 643, 643, 0, 622, 0, 2, 21);
INSERT INTO `eas_wo_dtl` VALUES (1361, 82, 'gJYAABv8hwXtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 35387, 35387, 0, 35387, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1362, 82, 'gJYAABv8hwjtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 90, 90, 0, 90, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1363, 82, 'gJYAABv8hwvtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 130, 130, 0, 130, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1364, 82, 'gJYAABv8hwftSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3763, 3763, 0, 3763, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1365, 82, 'gJYAABv8hwTtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 37624, 37624, 0, 37624, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1366, 82, 'gJYAABv8hwPtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 262, 262, 0, 262, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1367, 82, 'gJYAABv8hwrtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 72670, 72670, 0, 72670, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1368, 82, 'gJYAABv8hv7tSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 58, 58, 0, 58, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1369, 82, 'gJYAABv8hv/tSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 1054, 1054, 0, 11, 0, NULL, 1043);
INSERT INTO `eas_wo_dtl` VALUES (1370, 82, 'gJYAABv8hwbtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 18055, 18055, 0, 13010, 0, 3, 5045);
INSERT INTO `eas_wo_dtl` VALUES (1371, 82, 'gJYAABv8hwztSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1054, 1054, 0, 0, 0, NULL, 1054);
INSERT INTO `eas_wo_dtl` VALUES (1372, 82, 'gJYAABv8hwLtSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 72670, 72670, 0, 72670, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1373, 82, 'gJYAABv8hv3tSYg5', 'piccQxtfQiC85AVnTJRkDB0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 18055, 18055, 0, 18055, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1374, 83, 'gJYAABv9jRHtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 50000, 50000, 0, 50000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1375, 83, 'gJYAABv9jRDtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAAAAFAAxECefw', '01.02.01.001.0055', '荧光粉', '阳光4号', '克', 22255, 22255, 0, 22255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1376, 83, 'gJYAABv9jQ3tSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 3760, 3760, 0, 3760, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1377, 83, 'gJYAABv9jQztSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 79000, 79000, 0, 79000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1378, 83, 'gJYAABv9jRXtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1379, 83, 'gJYAABv9jQ/tSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 6523, 6523, 0, 6523, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1380, 83, 'gJYAABv9jRPtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 65230, 65230, 0, 65230, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1381, 83, 'gJYAABv9jQrtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 385, 385, 0, 385, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1382, 83, 'gJYAABv9jQvtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1383, 83, 'gJYAABv9jRLtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1384, 83, 'gJYAABv9jRftSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1385, 83, 'gJYAABv9jRbtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1386, 83, 'gJYAABv9jRjtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1387, 83, 'gJYAABv9jRTtSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1388, 83, 'gJYAABv9jQ7tSYg5', 'qHuBlJ7wQT+zpLZq8Ect0h0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1389, 84, 'gJYAABv9/kDtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 1741, 1741, 0, 1741, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1390, 84, 'gJYAABv9/krtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 129, 129, 0, 129, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1391, 84, 'gJYAABv9/kntSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4392, 4392, 0, 4392, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1392, 84, 'gJYAABv9/kztSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 14, 14, 0, 14, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1393, 84, 'gJYAABv9/kvtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1394, 84, 'gJYAABv9/kPtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 279, 279, 0, 279, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1395, 84, 'gJYAABv9/kftSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2786, 2786, 0, 2786, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1396, 84, 'gJYAABv9/kHtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 19, 19, 0, 19, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1397, 84, 'gJYAABv9/j/tSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6013, 6013, 0, 6013, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1398, 84, 'gJYAABv9/kbtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1399, 84, 'gJYAABv9/kjtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 87, 87, 0, 0, 0, NULL, 87);
INSERT INTO `eas_wo_dtl` VALUES (1400, 84, 'gJYAABv9/kTtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1494, 1494, 0, 1494, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1401, 84, 'gJYAABv9/k3tSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 87, 87, 0, 0, 0, NULL, 87);
INSERT INTO `eas_wo_dtl` VALUES (1402, 84, 'gJYAABv9/kLtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6013, 6013, 0, 6013, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1403, 84, 'gJYAABv9/kXtSYg5', 'FKfPhrXZSW+dsJKQF62EJh0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 2988, 2988, 0, 2988, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1404, 85, 'gJYAABv9/lvtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4057, 4057, 0, 4057, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1405, 85, 'gJYAABv9/lrtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 127, 127, 0, 127, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1406, 85, 'gJYAABv9/ljtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 66, 66, 0, 0, 0, 2, 66);
INSERT INTO `eas_wo_dtl` VALUES (1407, 85, 'gJYAABv9/lXtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6678, 6678, 0, 6678, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1408, 85, 'gJYAABv9/lDtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1409, 85, 'gJYAABv9/l3tSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1410, 85, 'gJYAABv9/l/tSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 811, 811, 0, 811, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1411, 85, 'gJYAABv9/lHtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 8114, 8114, 0, 8114, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1412, 85, 'gJYAABv9/lbtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 67, 67, 0, 67, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1413, 85, 'gJYAABv9/lTtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 13575, 13575, 0, 13575, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1414, 85, 'gJYAABv9/lLtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1415, 85, 'gJYAABv9/lPtSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 197, 197, 0, 0, 0, NULL, 197);
INSERT INTO `eas_wo_dtl` VALUES (1416, 85, 'gJYAABv9/lntSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3373, 3373, 0, 3373, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1417, 85, 'gJYAABv9/lztSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 197, 197, 0, 0, 0, NULL, 197);
INSERT INTO `eas_wo_dtl` VALUES (1418, 85, 'gJYAABv9/l7tSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13575, 13575, 0, 13575, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1419, 85, 'gJYAABv9/lftSYg5', 'h+BChyAcSjygE8EdH12WVR0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 3373, 3373, 0, 3373, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1420, 86, 'gJYAABv9/mftSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 7746, 7746, 0, 7746, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1421, 86, 'gJYAABv9/mTtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 558, 558, 0, 0, 0, 2, 558);
INSERT INTO `eas_wo_dtl` VALUES (1422, 86, 'gJYAABv9/m/tSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 189, 189, 0, 189, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1423, 86, 'gJYAABv9/mrtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 14814, 14814, 0, 14814, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1424, 86, 'gJYAABv9/mjtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 71, 71, 0, 71, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1425, 86, 'gJYAABv9/mztSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 64, 64, 0, 64, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1426, 86, 'gJYAABv9/mbtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 851, 851, 0, 851, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1427, 86, 'gJYAABv9/nPtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 8508, 8508, 0, 8508, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1428, 86, 'gJYAABv9/nHtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 103, 103, 0, 103, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1429, 86, 'gJYAABv9/mvtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 14299, 14299, 0, 14299, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1430, 86, 'gJYAABv9/nDtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1431, 86, 'gJYAABv9/nLtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 207, 207, 0, 0, 0, NULL, 207);
INSERT INTO `eas_wo_dtl` VALUES (1432, 86, 'gJYAABv9/m3tSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3552, 3552, 0, 3552, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1433, 86, 'gJYAABv9/m7tSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 207, 207, 0, 0, 0, NULL, 207);
INSERT INTO `eas_wo_dtl` VALUES (1434, 86, 'gJYAABv9/mntSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 14299, 14299, 0, 14299, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1435, 86, 'gJYAABv9/mXtSYg5', 'gYpRm0pJR0m7UZX5ZFIusB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 10657, 10657, 0, 10657, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1436, 87, 'gJYAABv9/obtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 5627, 5627, 0, 5627, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1437, 87, 'gJYAABv9/nrtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 728, 728, 0, 0, 0, 2, 728);
INSERT INTO `eas_wo_dtl` VALUES (1438, 87, 'gJYAABv9/oXtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 13804, 13804, 0, 13804, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1439, 87, 'gJYAABv9/oPtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 66, 66, 0, 66, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1440, 87, 'gJYAABv9/n/tSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1441, 87, 'gJYAABv9/nvtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 678, 678, 0, 678, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1442, 87, 'gJYAABv9/n3tSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6784, 6784, 0, 6784, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1443, 87, 'gJYAABv9/nntSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 40, 40, 0, 40, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1444, 87, 'gJYAABv9/n7tSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 13324, 13324, 0, 13324, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1445, 87, 'gJYAABv9/oTtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1446, 87, 'gJYAABv9/nztSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 193, 193, 0, 0, 0, NULL, 193);
INSERT INTO `eas_wo_dtl` VALUES (1447, 87, 'gJYAABv9/oftSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3310, 3310, 0, 3310, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1448, 87, 'gJYAABv9/oLtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 193, 193, 0, 0, 0, NULL, 193);
INSERT INTO `eas_wo_dtl` VALUES (1449, 87, 'gJYAABv9/oHtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13324, 13324, 0, 13324, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1450, 87, 'gJYAABv9/oDtSYg5', 'rAJSyHpwTJGeA9LbJBBsKR0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 9931, 9931, 0, 9931, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1451, 88, 'gJYAABv9/pPtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 1603, 1603, 0, 1603, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1452, 88, 'gJYAABv9/o/tSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 271, 271, 0, 0, 0, 2, 271);
INSERT INTO `eas_wo_dtl` VALUES (1453, 88, 'gJYAABv9/oztSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4179, 4179, 0, 4179, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1454, 88, 'gJYAABv9/pftSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1455, 88, 'gJYAABv9/pXtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1456, 88, 'gJYAABv9/o7tSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 205, 205, 0, 205, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1457, 88, 'gJYAABv9/pHtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2054, 2054, 0, 2054, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1458, 88, 'gJYAABv9/pLtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 12, 12, 0, 12, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1459, 88, 'gJYAABv9/ortSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4034, 4034, 0, 4034, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1460, 88, 'gJYAABv9/pjtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1461, 88, 'gJYAABv9/pDtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 59, 59, 0, 0, 0, NULL, 59);
INSERT INTO `eas_wo_dtl` VALUES (1462, 88, 'gJYAABv9/ovtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1002, 1002, 0, 1002, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1463, 88, 'gJYAABv9/pbtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 59, 59, 0, 0, 0, NULL, 59);
INSERT INTO `eas_wo_dtl` VALUES (1464, 88, 'gJYAABv9/pTtSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4034, 4034, 0, 4034, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1465, 88, 'gJYAABv9/o3tSYg5', 'OpX6pR2jSrGG9wbWAY4INx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 3007, 3007, 0, 3007, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1466, 89, 'gJYAABv+ABDtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 152, 152, 0, 0, 0, 2, 152);
INSERT INTO `eas_wo_dtl` VALUES (1467, 89, 'gJYAABv+AA7tSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 151, 151, 0, 151, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1468, 89, 'gJYAABv+AAvtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2529, 2529, 0, 2529, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1469, 89, 'gJYAABv+ABbtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6198, 6198, 0, 6198, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1470, 89, 'gJYAABv+jLjtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1471, 89, 'gJYAABv+ABXtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1472, 89, 'gJYAABv+AA/tSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 664, 664, 0, 664, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1473, 89, 'gJYAABv+ABPtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 6639, 6639, 0, 6639, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1474, 89, 'gJYAABv+AArtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 49, 49, 0, 49, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1475, 89, 'gJYAABv+ABTtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 12727, 12727, 0, 12727, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1476, 89, 'gJYAABv+ABLtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1477, 89, 'gJYAABv+ABHtSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 185, 185, 0, 0, 0, NULL, 185);
INSERT INTO `eas_wo_dtl` VALUES (1478, 89, 'gJYAABv+AA3tSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3162, 3162, 0, 3162, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1479, 89, 'gJYAABv+AAntSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 185, 185, 0, 0, 0, NULL, 185);
INSERT INTO `eas_wo_dtl` VALUES (1480, 89, 'gJYAABv+ABftSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12727, 12727, 0, 12727, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1481, 89, 'gJYAABv+AAztSYg5', 'Ha1hpYVSQSG1qut7Tyy3hB0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 3162, 3162, 0, 3162, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1482, 90, 'gJYAABv+jMntSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 3178, 3178, 0, 3178, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1483, 90, 'gJYAABv+jLvtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 350, 350, 0, 350, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1484, 90, 'gJYAABv+jL7tSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 95, 95, 0, 95, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1485, 90, 'gJYAABv+jMjtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 13875, 13875, 0, 13875, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1486, 90, 'gJYAABv+jMPtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 67, 67, 0, 67, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1487, 90, 'gJYAABv+jLztSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 43, 43, 0, 43, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1488, 90, 'gJYAABv+jMDtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 636, 636, 0, 636, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1489, 90, 'gJYAABv+jMftSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6355, 6355, 0, 6355, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1490, 90, 'gJYAABv+jMXtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 48, 48, 0, 48, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1491, 90, 'gJYAABv+jMTtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 13393, 13393, 0, 13393, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1492, 90, 'gJYAABv+jMbtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1493, 90, 'gJYAABv+jMHtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 194, 194, 0, 0, 0, NULL, 194);
INSERT INTO `eas_wo_dtl` VALUES (1494, 90, 'gJYAABv+jMrtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3327, 3327, 0, 3327, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1495, 90, 'gJYAABv+jL3tSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 194, 194, 0, 0, 0, NULL, 194);
INSERT INTO `eas_wo_dtl` VALUES (1496, 90, 'gJYAABv+jMLtSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13393, 13393, 0, 13393, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1497, 90, 'gJYAABv+jL/tSYg5', 'mo/eo09yRpGw94R59b1ryx0NgN0=', 'gJYAABctYldECefw', '06.10.03.001.0072', 'DICE', 'S-DICE-BXCD1133(X11C)', '千个', 9982, 9982, 0, 9982, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1498, 91, 'gJYAABv+jNDtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 74, 74, 0, 0, 0, 2, 74);
INSERT INTO `eas_wo_dtl` VALUES (1499, 91, 'gJYAABv+jNrtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 73, 73, 0, 73, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1500, 91, 'gJYAABv+jM3tSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1278, 1278, 0, 1278, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1501, 91, 'gJYAABv+jNHtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 3011, 3011, 0, 3011, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1502, 91, 'gJYAABv+jNPtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1503, 91, 'gJYAABv+jNXtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1504, 91, 'gJYAABv+jNLtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 323, 323, 0, 323, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1505, 91, 'gJYAABv+jNntSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 3225, 3225, 0, 3225, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1506, 91, 'gJYAABv+jNjtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 24, 24, 0, 24, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1507, 91, 'gJYAABv+jNvtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 6183, 6183, 0, 6183, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1508, 91, 'gJYAABv+jNbtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1509, 91, 'gJYAABv+jM/tSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 90, 90, 0, 0, 0, NULL, 90);
INSERT INTO `eas_wo_dtl` VALUES (1510, 91, 'gJYAABv+jNftSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1536, 1536, 0, 1536, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1511, 91, 'gJYAABv+jNTtSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 90, 90, 0, 0, 0, NULL, 90);
INSERT INTO `eas_wo_dtl` VALUES (1512, 91, 'gJYAABv+jM7tSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6183, 6183, 0, 6183, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1513, 91, 'gJYAABv+jNztSYg5', 'dA8Is/SaTrudJZ1fjZGrbR0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 1536, 1536, 0, 1536, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1514, 92, 'gJYAABv/V0XtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 10505, 10505, 0, 10505, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1515, 92, 'gJYAABv/VzrtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 148, 148, 0, 148, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1516, 92, 'gJYAABv/VzvtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 558, 558, 0, 0, 0, 2, 558);
INSERT INTO `eas_wo_dtl` VALUES (1517, 92, 'gJYAABv/V0LtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 26012, 26012, 0, 26012, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1518, 92, 'gJYAABv/V0TtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 66, 66, 0, 66, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1519, 92, 'gJYAABv/VzztSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 95, 95, 0, 95, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1520, 92, 'gJYAABv/Vz3tSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 3129, 3129, 0, 3129, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1521, 92, 'gJYAABv/Vz7tSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 31290, 31290, 0, 31290, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1522, 92, 'gJYAABv/V0DtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 268, 268, 0, 268, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1523, 92, 'gJYAABv/V0ftSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 52877, 52877, 0, 52877, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1524, 92, 'gJYAABv/V0PtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 43, 43, 0, 43, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1525, 92, 'gJYAABv/V0btSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 767, 767, 0, 0, 0, NULL, 767);
INSERT INTO `eas_wo_dtl` VALUES (1526, 92, 'gJYAABv/Vz/tSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 13137, 13137, 0, 13137, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1527, 92, 'gJYAABv/VzntSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 767, 767, 0, 0, 0, NULL, 767);
INSERT INTO `eas_wo_dtl` VALUES (1528, 92, 'gJYAABv/VzjtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 52877, 52877, 0, 52877, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1529, 92, 'gJYAABv/V0HtSYg5', 'yX47oBceQbqPq7yafJw4nx0NgN0=', 'gJYAABn7DqtECefw', '06.10.03.001.0115', 'DICE', 'S-DICE-BXCD1835-M2', '千个', 13137, 13137, 0, 13137, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1530, 93, 'gJYAABv/V1ftSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 458, 458, 0, 0, 0, 2, 458);
INSERT INTO `eas_wo_dtl` VALUES (1531, 93, 'gJYAABv/V1jtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 84, 84, 0, 84, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1532, 93, 'gJYAABv/V1LtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2851, 2851, 0, 2851, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1533, 93, 'gJYAABv/V1ntSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6163, 6163, 0, 6163, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1534, 93, 'gJYAABv/V1XtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1535, 93, 'gJYAABv/V0/tSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1536, 93, 'gJYAABv/V1vtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 638, 638, 0, 638, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1537, 93, 'gJYAABv/V07tSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6376, 6376, 0, 6376, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1538, 93, 'gJYAABv/V03tSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 46, 46, 0, 46, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1539, 93, 'gJYAABv/V1btSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12656, 12656, 0, 12656, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1540, 93, 'gJYAABv/V0ztSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1541, 93, 'gJYAABv/V1HtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 184, 184, 0, 0, 0, NULL, 184);
INSERT INTO `eas_wo_dtl` VALUES (1542, 93, 'gJYAABv/V1TtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3144, 3144, 0, 3144, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1543, 93, 'gJYAABv/V1PtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 184, 184, 0, 0, 0, NULL, 184);
INSERT INTO `eas_wo_dtl` VALUES (1544, 93, 'gJYAABv/V1rtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12656, 12656, 0, 12656, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1545, 93, 'gJYAABv/V1DtSYg5', 'i9B1bLxbQ9SCODOe4Ll5Gh0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 3144, 3144, 0, 3144, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1546, 94, 'gJYAABv/V3ztSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 240, 240, 0, 240, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1547, 94, 'gJYAABv/V3TtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1781, 1781, 0, 1781, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1548, 94, 'gJYAABv/V3HtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 43, 43, 0, 0, 0, 2, 43);
INSERT INTO `eas_wo_dtl` VALUES (1549, 94, 'gJYAABv/V3jtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2925, 2925, 0, 2925, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1550, 94, 'gJYAABv/V3rtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 7, 7, 0, 7, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1551, 94, 'gJYAABv/V33tSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1552, 94, 'gJYAABv/V3ftSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 285, 285, 0, 285, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1553, 94, 'gJYAABv/V3LtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2850, 2850, 0, 2850, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1554, 94, 'gJYAABv/V3vtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 21, 21, 0, 21, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1555, 94, 'gJYAABv/V3PtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6006, 6006, 0, 6006, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1556, 94, 'gJYAABv/V3XtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1557, 94, 'gJYAABv/V37tSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 87, 87, 0, 0, 0, NULL, 87);
INSERT INTO `eas_wo_dtl` VALUES (1558, 94, 'gJYAABv/V3btSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1492, 1492, 0, 1492, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1559, 94, 'gJYAABv/V3DtSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 87, 87, 0, 0, 0, NULL, 87);
INSERT INTO `eas_wo_dtl` VALUES (1560, 94, 'gJYAABv/V3ntSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6006, 6006, 0, 6006, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1561, 94, 'gJYAABv/V3/tSYg5', '7guyBtvSRpKXTqZLJADPOB0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 1492, 1492, 0, 1492, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1562, 95, 'gJYAABv/V4ftSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 159, 159, 0, 0, 0, 2, 159);
INSERT INTO `eas_wo_dtl` VALUES (1563, 95, 'gJYAABv/V5HtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 158, 158, 0, 158, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1564, 95, 'gJYAABv/V4TtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2762, 2762, 0, 2762, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1565, 95, 'gJYAABv/V4jtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6505, 6505, 0, 6505, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1566, 95, 'gJYAABv/V4rtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 17, 17, 0, 17, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1567, 95, 'gJYAABv/V4ztSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 24, 24, 0, 24, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1568, 95, 'gJYAABv/V4ntSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 697, 697, 0, 697, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1569, 95, 'gJYAABv/V5DtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 6968, 6968, 0, 6968, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1570, 95, 'gJYAABv/V4/tSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 51, 51, 0, 51, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1571, 95, 'gJYAABv/V5LtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 13358, 13358, 0, 13358, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1572, 95, 'gJYAABv/V43tSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1573, 95, 'gJYAABv/V4btSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 194, 194, 0, 0, 0, NULL, 194);
INSERT INTO `eas_wo_dtl` VALUES (1574, 95, 'gJYAABv/V47tSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 3319, 3319, 0, 3319, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1575, 95, 'gJYAABv/V4vtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 194, 194, 0, 0, 0, NULL, 194);
INSERT INTO `eas_wo_dtl` VALUES (1576, 95, 'gJYAABv/V4XtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 13358, 13358, 0, 13358, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1577, 95, 'gJYAABv/V5PtSYg5', 'GDUA4OnxTrqHxIca7BZthR0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 3319, 3319, 0, 3319, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1578, 96, 'gJYAABwAd8LtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 50000, 16747, 0, 16747, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1579, 96, 'gJYAABwAHiTtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABnXfxlECefw', '01.01.01.010.3558', 'DICE', 'DICE-Y0609C', '千个', 50000, 33253, 0, 33317, 64, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1580, 96, 'gJYAABwAHiPtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 22255, 22255, 0, 22255, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1581, 96, 'gJYAABwAHiDtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABSneyVECefw', '01.02.01.001.1214', '荧光粉', 'MU-028-H', '克', 3760, 3760, 0, 3760, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1582, 96, 'gJYAABwAHh/tSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 79000, 79000, 0, 79000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1583, 96, 'gJYAABwAHijtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1584, 96, 'gJYAABwAHiLtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 6523, 6523, 0, 6523, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1585, 96, 'gJYAABwAHibtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 65230, 65230, 0, 65230, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1586, 96, 'gJYAABwAHh3tSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 385, 385, 0, 385, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1587, 96, 'gJYAABwAHh7tSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 60, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1588, 96, 'gJYAABwAHiXtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1589, 96, 'gJYAABwAHirtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1590, 96, 'gJYAABwAHintSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1591, 96, 'gJYAABwAHivtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1592, 96, 'gJYAABwAHiftSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1593, 96, 'gJYAABwAHiHtSYg5', 'nBjCBHJlSZG/9RZzHj968R0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1594, 97, 'gJYAABwARNvtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAABc2rwFECefw', '01.01.01.010.3392', 'DICE', 'DICE-BPA0G14A', '千个', 100, 100, 0, 100, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1595, 97, 'gJYAABwAROXtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 19, 19, 0, 19, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1596, 97, 'gJYAABwARN3tSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAAAsj/VBECefw', '01.02.01.001.1042', '荧光粉', '阳光535-15', '克', 5, 5, 0, 5, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1597, 97, 'gJYAABwAROPtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 1, 1, 0, 1, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1598, 97, 'gJYAABwARNntSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAABWXvNtECefw', '01.02.01.006.0077', '键合银丝', 'YA2M_0.75mil', '米', 158, 158, 0, 158, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1599, 97, 'gJYAABwARNrtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAABF8F4ZECefw', '01.02.01.100.1077', '瓷嘴', 'MH-035', '支', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1600, 97, 'gJYAABwARNztSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 17, 17, 0, 17, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1601, 97, 'gJYAABwAROLtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 169, 169, 0, 169, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1602, 97, 'gJYAABwARN/tSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1603, 97, 'gJYAABwAROHtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1604, 97, 'gJYAABwARN7tSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAAA+DghFECefw', '02.02.02.002.0015', '胶水', 'MS-042', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1605, 97, 'gJYAABwAROTtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAABdb1zpECefw', '02.03.20.002.1231', '平面支架', '2835H_F1975_20_A4C22', '千个', 100, 100, 0, 100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1606, 97, 'gJYAABwARNjtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1607, 97, 'gJYAABwARODtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 403, 403, 0, 403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1608, 97, 'gJYAABwARObtSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAABVgVmBECefw', '02.06.02.001.0003', '封带', 'MLS-006', '米', 403, 403, 0, 403, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1609, 97, 'gJYAABwARNftSYg5', 'hxDyQJOwS9eiFFP6f3qLcB0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1610, 98, 'gJYAABwA2zrtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 50000, 50000, 0, 50000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1611, 98, 'gJYAABwA2zftSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAAAAFAAxECefw', '01.02.01.001.0055', '荧光粉', '阳光4号', '克', 14525, 14525, 0, 14525, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1612, 98, 'gJYAABwA2z/tSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 4965, 4965, 0, 4965, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1613, 98, 'gJYAABwA2zbtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 79000, 79000, 0, 79000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1614, 98, 'gJYAABwA2z3tSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1615, 98, 'gJYAABwA2zjtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABqxu7dECefw', '01.02.03.014.0211', '硅胶', 'MN-006A', '克', 6535, 6535, 0, 6535, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1616, 98, 'gJYAABwA20PtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABqxvCdECefw', '01.02.03.014.0212', '硅胶', 'MN-006B', '克', 65350, 65350, 0, 65350, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1617, 98, 'gJYAABwA20HtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 365, 365, 0, 365, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1618, 98, 'gJYAABwA2zXtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 0, 0, NULL, 60);
INSERT INTO `eas_wo_dtl` VALUES (1619, 98, 'gJYAABwA2zvtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1620, 98, 'gJYAABwA20DtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1621, 98, 'gJYAABwA2z7tSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1622, 98, 'gJYAABwA20LtSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1623, 98, 'gJYAABwA2zztSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1624, 98, 'gJYAABwA2zntSYg5', 'pfKDDplxRge6jvjaVLohdx0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1625, 99, 'gJYAABwA26ntSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 47, 47, 0, 0, 0, 2, 47);
INSERT INTO `eas_wo_dtl` VALUES (1626, 99, 'gJYAABwA26/tSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 24, 24, 0, 24, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1627, 99, 'gJYAABwA26rtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 350, 350, 0, 350, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1628, 99, 'gJYAABwA26jtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1008, 1008, 0, 1008, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1629, 99, 'gJYAABwA27DtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1630, 99, 'gJYAABwA27HtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1631, 99, 'gJYAABwA26vtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 107, 107, 0, 107, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1632, 99, 'gJYAABwA267tSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 1069, 1069, 0, 1069, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1633, 99, 'gJYAABwA26XtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 8, 8, 0, 8, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1634, 99, 'gJYAABwA26btSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 2049, 2049, 0, 2049, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1635, 99, 'gJYAABwA26LtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1636, 99, 'gJYAABwA26PtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (1637, 99, 'gJYAABwA26ztSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 509, 509, 0, 509, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1638, 99, 'gJYAABwA26TtSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 30, 30, 0, 0, 0, NULL, 30);
INSERT INTO `eas_wo_dtl` VALUES (1639, 99, 'gJYAABwA26ftSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2049, 2049, 0, 2049, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1640, 99, 'gJYAABwA263tSYg5', '9nOpt5uTRb+muxh+PaYmcx0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 509, 509, 0, 509, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1641, 100, 'gJYAABwBCAjtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 15, 15, 0, 0, 0, 2, 15);
INSERT INTO `eas_wo_dtl` VALUES (1642, 100, 'gJYAABwBCBHtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 129, 129, 0, 129, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1643, 100, 'gJYAABwBCBDtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAABtJ0SVECefw', '01.02.01.001.1361', '荧光粉', 'G518M', '克', 426, 426, 0, 426, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1644, 100, 'gJYAABwBCA/tSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2638, 2638, 0, 2638, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1645, 100, 'gJYAABwBCBTtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 12, 12, 0, 12, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1646, 100, 'gJYAABwBCAftSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1647, 100, 'gJYAABwBCArtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 118, 118, 0, 118, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1648, 100, 'gJYAABwBCBLtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1184, 1184, 0, 1184, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1649, 100, 'gJYAABwBCBbtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 8, 8, 0, 8, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1650, 100, 'gJYAABwBCAntSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2349, 2349, 0, 2349, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1651, 100, 'gJYAABwBCA7tSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 2, 2, 0, 2, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1652, 100, 'gJYAABwBCAvtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 34, 34, 0, 0, 0, NULL, 34);
INSERT INTO `eas_wo_dtl` VALUES (1653, 100, 'gJYAABwBCAztSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 584, 584, 0, 584, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1654, 100, 'gJYAABwBCA3tSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 34, 34, 0, 0, 0, NULL, 34);
INSERT INTO `eas_wo_dtl` VALUES (1655, 100, 'gJYAABwBCBXtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2349, 2349, 0, 2349, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1656, 100, 'gJYAABwBCBPtSYg5', 'ZcUk6VYkSf65WY30zq1pPB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 1751, 1751, 0, 1751, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1657, 101, 'gJYAABwBCB/tSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 275, 275, 0, 0, 0, 2, 275);
INSERT INTO `eas_wo_dtl` VALUES (1658, 101, 'gJYAABwBCCntSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 273, 273, 0, 273, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1659, 101, 'gJYAABwBCBztSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 4764, 4764, 0, 1844, 0, 2, 2920);
INSERT INTO `eas_wo_dtl` VALUES (1660, 101, 'gJYAABwBCCDtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 11220, 11220, 0, 11220, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1661, 101, 'gJYAABwBCCLtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 29, 29, 0, 29, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1662, 101, 'gJYAABwBCCTtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 41, 41, 0, 41, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1663, 101, 'gJYAABwBCCHtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 1202, 1202, 0, 1202, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1664, 101, 'gJYAABwBCCjtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 12019, 12019, 0, 12019, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1665, 101, 'gJYAABwBCCftSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 89, 89, 0, 89, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1666, 101, 'gJYAABwBCCrtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 23041, 23041, 0, 23041, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1667, 101, 'gJYAABwBCCXtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 19, 19, 0, 19, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1668, 101, 'gJYAABwBCB7tSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 334, 334, 0, 0, 0, NULL, 334);
INSERT INTO `eas_wo_dtl` VALUES (1669, 101, 'gJYAABwBCCbtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 5725, 5725, 0, 5725, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1670, 101, 'gJYAABwBCCPtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 334, 334, 0, 0, 0, NULL, 334);
INSERT INTO `eas_wo_dtl` VALUES (1671, 101, 'gJYAABwBCB3tSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 23041, 23041, 0, 23041, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1672, 101, 'gJYAABwBCCvtSYg5', 'SyQHm4p3R1iAkdFmmo0oPB0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 5725, 5725, 0, 5725, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1673, 102, 'gJYAABwBCHLtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 0, 0, 0, 0, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1674, 102, 'gJYAABwBCHTtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 0, 0, 0, 0, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1675, 102, 'gJYAABwBCGvtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1676, 102, 'gJYAABwBCHHtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1677, 102, 'gJYAABwBCHDtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1678, 102, 'gJYAABwBCGrtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 0, 0, 0, 0, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1679, 102, 'gJYAABwBCHXtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 0, 0, 0, 0, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1680, 102, 'gJYAABwBCHPtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 0, 0, 0, 0, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1681, 102, 'gJYAABwBCG7tSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1682, 102, 'gJYAABwBCGztSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1683, 102, 'gJYAABwBCG3tSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1684, 102, 'gJYAABwBCHbtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 0, 0, 0, 255, 255, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1685, 102, 'gJYAABwBCG/tSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1686, 102, 'gJYAABwBCGntSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1687, 102, 'gJYAABwBCGjtSYg5', 'o69glgvgTZWf8TAwUsD54x0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 0, 0, 0, 8347, 8347, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1688, 103, 'gJYAABwBSvDtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABc2rwFECefw', '01.01.01.010.3392', 'DICE', 'DICE-BPA0G14A', '千个', 30000, 30000, 0, 30000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1689, 103, 'gJYAABwBSuztSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 5676, 5676, 0, 5676, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1690, 103, 'gJYAABwBSuvtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAAAsj/VBECefw', '01.02.01.001.1042', '荧光粉', '阳光535-15', '克', 1569, 1569, 0, 1569, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1691, 103, 'gJYAABwBSvPtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 180, 180, 0, 180, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1692, 103, 'gJYAABwBSvjtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABWXvNtECefw', '01.02.01.006.0077', '键合银丝', 'YA2M_0.75mil', '米', 47400, 47400, 0, 47400, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1693, 103, 'gJYAABwBSvTtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABF8F4ZECefw', '01.02.01.100.1077', '瓷嘴', 'MH-035', '支', 46, 46, 0, 46, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1694, 103, 'gJYAABwBSvHtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 5072, 5072, 0, 5072, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1695, 103, 'gJYAABwBSvrtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 50721, 50721, 0, 50721, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1696, 103, 'gJYAABwBSvbtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 429, 429, 0, 429, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1697, 103, 'gJYAABwBSu7tSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 36, 36, 0, 0, 0, NULL, 36);
INSERT INTO `eas_wo_dtl` VALUES (1698, 103, 'gJYAABwBSvXtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAAA+DghFECefw', '02.02.02.002.0015', '胶水', 'MS-042', '克', 165, 165, 0, 165, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1699, 103, 'gJYAABwBSvftSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABdb1zpECefw', '02.03.20.002.1231', '平面支架', '2835H_F1975_20_A4C22', '千个', 30000, 30000, 0, 30000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1700, 103, 'gJYAABwBSu/tSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1035, 1035, 0, 1035, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1701, 103, 'gJYAABwBSu3tSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 120750, 120750, 0, 120750, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1702, 103, 'gJYAABwBSvLtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 120750, 0, 0, 120750, 120750, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1703, 103, 'gJYAABwNYkbtSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABVgVmBECefw', '02.06.02.001.0003', '封带', 'MLS-006', '米', 120750, 120750, 0, 0, 0, NULL, 120750);
INSERT INTO `eas_wo_dtl` VALUES (1704, 103, 'gJYAABwBSvntSYg5', 'erKmwl9BTaeBKuffFq4dCB0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 348, 348, 0, 348, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1705, 104, 'gJYAABwBZ6PtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 1818, 1818, 0, 1381, 0, 2, 437);
INSERT INTO `eas_wo_dtl` VALUES (1706, 104, 'gJYAABwBZ67tSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 283, 283, 0, 0, 0, 2, 283);
INSERT INTO `eas_wo_dtl` VALUES (1707, 104, 'gJYAABwBZ6btSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4212, 4212, 0, 4212, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1708, 104, 'gJYAABwBZ6vtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1709, 104, 'gJYAABwBZ6ftSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1710, 104, 'gJYAABwBZ63tSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 207, 207, 0, 207, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1711, 104, 'gJYAABwBZ6HtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2070, 2070, 0, 2070, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1712, 104, 'gJYAABwBZ6TtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 12, 12, 0, 12, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1713, 104, 'gJYAABwBZ6rtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4066, 4066, 0, 4066, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1714, 104, 'gJYAABwBZ6jtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 3, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1715, 104, 'gJYAABwBZ6LtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 59, 59, 0, 0, 0, NULL, 59);
INSERT INTO `eas_wo_dtl` VALUES (1716, 104, 'gJYAABwBZ6ztSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1010, 1010, 0, 1010, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1717, 104, 'gJYAABwBZ6XtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 59, 59, 0, 0, 0, NULL, 59);
INSERT INTO `eas_wo_dtl` VALUES (1718, 104, 'gJYAABwBZ6DtSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4066, 4066, 0, 4066, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1719, 104, 'gJYAABwBZ6ntSYg5', '8OyiCqwURdmiiE1s1KFkDB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 3030, 3030, 0, 3030, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1720, 105, 'gJYAABwBZ7ntSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2870, 2870, 0, 0, 0, 2, 2870);
INSERT INTO `eas_wo_dtl` VALUES (1721, 105, 'gJYAABwBZ77tSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 473, 473, 0, 0, 0, 2, 473);
INSERT INTO `eas_wo_dtl` VALUES (1722, 105, 'gJYAABwBZ7ftSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7040, 7040, 0, 7040, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1723, 105, 'gJYAABwBZ7jtSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1724, 105, 'gJYAABwBZ73tSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1725, 105, 'gJYAABwBZ7PtSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 346, 346, 0, 346, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1726, 105, 'gJYAABwBZ7ztSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3460, 3460, 0, 3460, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1727, 105, 'gJYAABwBZ7HtSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 20, 20, 0, 20, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1728, 105, 'gJYAABwBZ7vtSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6796, 6796, 0, 6796, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1729, 105, 'gJYAABwBZ7btSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1730, 105, 'gJYAABwBZ7TtSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 99, 99, 0, 0, 0, NULL, 99);
INSERT INTO `eas_wo_dtl` VALUES (1731, 105, 'gJYAABwBZ7/tSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1688, 1688, 0, 1688, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1732, 105, 'gJYAABwBZ7XtSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 99, 99, 0, 0, 0, NULL, 99);
INSERT INTO `eas_wo_dtl` VALUES (1733, 105, 'gJYAABwBZ7rtSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6796, 6796, 0, 6796, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1734, 105, 'gJYAABwBZ7LtSYg5', 'mr91UzYcQ3mkb6p17vTOwB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 5065, 5065, 0, 5065, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1735, 106, 'gJYAABwBZ8rtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 78, 78, 0, 0, 0, 2, 78);
INSERT INTO `eas_wo_dtl` VALUES (1736, 106, 'gJYAABwBZ8btSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 368, 368, 0, 174, 0, 2, 194);
INSERT INTO `eas_wo_dtl` VALUES (1737, 106, 'gJYAABwBZ8ntSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2392, 2392, 0, 0, 0, 2, 2392);
INSERT INTO `eas_wo_dtl` VALUES (1738, 106, 'gJYAABwBZ8ftSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 13688, 13688, 0, 13688, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1739, 106, 'gJYAABwBZ8XtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 61, 61, 0, 61, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1740, 106, 'gJYAABwBZ87tSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 32, 32, 0, 32, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1741, 106, 'gJYAABwBZ8jtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 614, 614, 0, 614, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1742, 106, 'gJYAABwBZ8LtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6141, 6141, 0, 6141, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1743, 106, 'gJYAABwBZ8/tSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 44, 44, 0, 44, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1744, 106, 'gJYAABwBZ8TtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12189, 12189, 0, 12189, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1745, 106, 'gJYAABwBZ83tSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 10, 10, 0, 10, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1746, 106, 'gJYAABwBZ8PtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 177, 177, 0, 0, 0, NULL, 177);
INSERT INTO `eas_wo_dtl` VALUES (1747, 106, 'gJYAABwBZ8vtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3028, 3028, 0, 3028, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1748, 106, 'gJYAABwBZ8ztSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 177, 177, 0, 0, 0, NULL, 177);
INSERT INTO `eas_wo_dtl` VALUES (1749, 106, 'gJYAABwBZ9HtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12189, 12189, 0, 12189, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1750, 106, 'gJYAABwBZ9DtSYg5', 'iH4c04p7Q8iaAU8DAwwW5B0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 9085, 9085, 0, 9085, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1751, 107, 'gJYAABwBZ9vtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 3454, 3454, 0, 0, 0, 2, 3454);
INSERT INTO `eas_wo_dtl` VALUES (1752, 107, 'gJYAABwBZ+PtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 357, 357, 0, 0, 0, 2, 357);
INSERT INTO `eas_wo_dtl` VALUES (1753, 107, 'gJYAABwBZ+DtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 41, 41, 0, 41, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1754, 107, 'gJYAABwBZ+rtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8355, 8355, 0, 8355, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1755, 107, 'gJYAABwBZ9/tSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 40, 40, 0, 40, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1756, 107, 'gJYAABwBZ+LtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 36, 36, 0, 36, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1757, 107, 'gJYAABwBZ+jtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 548, 548, 0, 548, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1758, 107, 'gJYAABwBZ+ftSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5481, 5481, 0, 5481, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1759, 107, 'gJYAABwBZ9ztSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 53, 53, 0, 53, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1760, 107, 'gJYAABwBZ93tSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8065, 8065, 0, 8065, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1761, 107, 'gJYAABwBZ97tSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1762, 107, 'gJYAABwBZ+TtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 117, 117, 0, 0, 0, NULL, 117);
INSERT INTO `eas_wo_dtl` VALUES (1763, 107, 'gJYAABwBZ+ntSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2004, 2004, 0, 2004, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1764, 107, 'gJYAABwBZ+HtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 117, 117, 0, 0, 0, NULL, 117);
INSERT INTO `eas_wo_dtl` VALUES (1765, 107, 'gJYAABwBZ+btSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8065, 8065, 0, 8065, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1766, 107, 'gJYAABwBZ+XtSYg5', 'WUuRmxN7SvCaGH8LQHZyLx0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 6011, 6011, 0, 6011, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1767, 108, 'gJYAABwBZ/7tSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2896, 2896, 0, 0, 0, 2, 2896);
INSERT INTO `eas_wo_dtl` VALUES (1768, 108, 'gJYAABwBZ/LtSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 375, 375, 0, 0, 0, 2, 375);
INSERT INTO `eas_wo_dtl` VALUES (1769, 108, 'gJYAABwBZ/3tSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7104, 7104, 0, 7104, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1770, 108, 'gJYAABwBZ/vtSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 34, 34, 0, 34, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1771, 108, 'gJYAABwBZ/ftSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 31, 31, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1772, 108, 'gJYAABwBZ/PtSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 349, 349, 0, 349, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1773, 108, 'gJYAABwBZ/XtSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3491, 3491, 0, 3491, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1774, 108, 'gJYAABwBZ/HtSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 21, 21, 0, 21, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1775, 108, 'gJYAABwBZ/btSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6857, 6857, 0, 6857, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1776, 108, 'gJYAABwBZ/ztSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1777, 108, 'gJYAABwBZ/TtSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 99, 99, 0, 0, 0, NULL, 99);
INSERT INTO `eas_wo_dtl` VALUES (1778, 108, 'gJYAABwBZ//tSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1704, 1704, 0, 1704, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1779, 108, 'gJYAABwBZ/rtSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 99, 99, 0, 0, 0, NULL, 99);
INSERT INTO `eas_wo_dtl` VALUES (1780, 108, 'gJYAABwBZ/ntSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6857, 6857, 0, 6857, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1781, 108, 'gJYAABwBZ/jtSYg5', '0NrKUYm5Rw+77BnmotcwLB0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 5111, 5111, 0, 5111, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1782, 109, 'gJYAABwBxF7tSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 2802, 2802, 0, 2802, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1783, 109, 'gJYAABwBxGjtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 207, 207, 0, 207, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1784, 109, 'gJYAABwBxGftSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 7068, 7068, 0, 7068, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1785, 109, 'gJYAABwBxGrtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1786, 109, 'gJYAABwBxGntSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 25, 25, 0, 25, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1787, 109, 'gJYAABwBxGHtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 448, 448, 0, 448, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1788, 109, 'gJYAABwBxGXtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4484, 4484, 0, 4484, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1789, 109, 'gJYAABwBxF/tSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 31, 31, 0, 31, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1790, 109, 'gJYAABwBxF3tSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 9677, 9677, 0, 9677, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1791, 109, 'gJYAABwBxGTtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1792, 109, 'gJYAABwBxGbtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 140, 140, 0, 0, 0, NULL, 140);
INSERT INTO `eas_wo_dtl` VALUES (1793, 109, 'gJYAABwBxGLtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2404, 2404, 0, 2404, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1794, 109, 'gJYAABwBxGvtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 140, 140, 0, 0, 0, NULL, 140);
INSERT INTO `eas_wo_dtl` VALUES (1795, 109, 'gJYAABwBxGDtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 9677, 9677, 0, 9677, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1796, 109, 'gJYAABwBxGPtSYg5', '6/qjgvIxQvCNqzXKCQxU9h0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 4808, 4808, 0, 4808, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1797, 110, 'gJYAABwBxHztSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 556, 556, 0, 0, 0, 2, 556);
INSERT INTO `eas_wo_dtl` VALUES (1798, 110, 'gJYAABwBxHntSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 553, 553, 0, 143, 0, 2, 409);
INSERT INTO `eas_wo_dtl` VALUES (1799, 110, 'gJYAABwBxHbtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 9269, 9269, 0, 0, 0, 2, 9269);
INSERT INTO `eas_wo_dtl` VALUES (1800, 110, 'gJYAABwBxIHtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 22711, 22711, 0, 22711, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1801, 110, 'gJYAABwBxIPtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 58, 58, 0, 58, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1802, 110, 'gJYAABwBxIDtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 83, 83, 0, 83, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1803, 110, 'gJYAABwBxHrtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 2433, 2433, 0, 2433, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1804, 110, 'gJYAABwBxH7tSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 24328, 24328, 0, 24328, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1805, 110, 'gJYAABwBxHXtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 180, 180, 0, 180, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1806, 110, 'gJYAABwBxH/tSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 46638, 46638, 0, 40234, 0, NULL, 6405);
INSERT INTO `eas_wo_dtl` VALUES (1807, 110, 'gJYAABwBxH3tSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 38, 38, 0, 38, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1808, 110, 'gJYAABwBxHvtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 677, 677, 0, 0, 0, NULL, 677);
INSERT INTO `eas_wo_dtl` VALUES (1809, 110, 'gJYAABwBxHjtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 11587, 11587, 0, 11587, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1810, 110, 'gJYAABwBxHTtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 677, 677, 0, 0, 0, NULL, 677);
INSERT INTO `eas_wo_dtl` VALUES (1811, 110, 'gJYAABwBxILtSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 46638, 46638, 0, 46638, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1812, 110, 'gJYAABwBxHftSYg5', 'jBoWk9JLT3eaVjDBSaToox0NgN0=', 'gJYAABc3pulECefw', '06.10.03.001.0092', 'DICE', 'S-DICE-BXCD2240', '千个', 11587, 11587, 0, 11587, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1813, 111, 'gJYAABwCPFvtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 50000, 50000, 0, 50000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1814, 111, 'gJYAABwCPFjtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAAAAFAAxECefw', '01.02.01.001.0055', '荧光粉', '阳光4号', '克', 14525, 14525, 0, 14525, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1815, 111, 'gJYAABwCPGDtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 4965, 4965, 0, 4965, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1816, 111, 'gJYAABwCPFftSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 79000, 79000, 0, 79000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1817, 111, 'gJYAABwCPF7tSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 125, 125, 0, 125, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1818, 111, 'gJYAABwCPFntSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABqxu7dECefw', '01.02.03.014.0211', '硅胶', 'MN-006A', '克', 6535, 6535, 0, 6535, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1819, 111, 'gJYAABwCPGTtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABqxvCdECefw', '01.02.03.014.0212', '硅胶', 'MN-006B', '克', 65350, 65350, 0, 65350, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1820, 111, 'gJYAABwCPGLtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 365, 365, 0, 365, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1821, 111, 'gJYAABwCPFbtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 60, 60, 0, 0, 0, NULL, 60);
INSERT INTO `eas_wo_dtl` VALUES (1822, 111, 'gJYAABwCPFztSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 150, 150, 0, 150, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1823, 111, 'gJYAABwCPGHtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 50000, 50000, 0, 50000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1824, 111, 'gJYAABwCPF/tSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1730, 1730, 0, 1730, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1825, 111, 'gJYAABwCPGPtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1826, 111, 'gJYAABwCPF3tSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201250, 201250, 0, 201250, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1827, 111, 'gJYAABwCPFrtSYg5', 'WosFDtDdSpaQFKyOU0jjkh0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 580, 580, 0, 580, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1828, 112, 'gJYAABwCPKLtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 6000, 6000, 0, 6000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1829, 112, 'gJYAABwCPJ7tSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 2406, 2406, 0, 0, 0, 2, 2406);
INSERT INTO `eas_wo_dtl` VALUES (1830, 112, 'gJYAABwCPJztSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 844, 844, 0, 0, 0, 2, 844);
INSERT INTO `eas_wo_dtl` VALUES (1831, 112, 'gJYAABwCPJjtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 79, 79, 0, 79, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1832, 112, 'gJYAABwCPJ3tSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 9040, 9040, 0, 9040, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1833, 112, 'gJYAABwCPJXtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 33, 33, 0, 33, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1834, 112, 'gJYAABwCPJntSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 21, 21, 0, 21, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1835, 112, 'gJYAABwCPJ/tSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 403, 403, 0, 403, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1836, 112, 'gJYAABwCPJvtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4027, 4027, 0, 4027, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1837, 112, 'gJYAABwCPJTtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 16, 16, 0, 16, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1838, 112, 'gJYAABwCPKHtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8050, 8050, 0, 8050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1839, 112, 'gJYAABwCPJbtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (1840, 112, 'gJYAABwCPJrtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 110, 110, 0, 0, 0, NULL, 110);
INSERT INTO `eas_wo_dtl` VALUES (1841, 112, 'gJYAABwCPJftSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2000, 2000, 0, 2000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1842, 112, 'gJYAABwCPJPtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 110, 110, 0, 0, 0, NULL, 110);
INSERT INTO `eas_wo_dtl` VALUES (1843, 112, 'gJYAABwCPKDtSYg5', 't5VZWcPlTISbYoC1oxxAjx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8050, 8050, 0, 8050, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1844, 113, 'gJYAABwDAw3tSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 150, 150, 0, 150, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1845, 113, 'gJYAABwDAw/tSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 56, 56, 0, 0, 0, 2, 56);
INSERT INTO `eas_wo_dtl` VALUES (1846, 113, 'gJYAABwDAwvtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 31, 31, 0, 0, 0, 2, 31);
INSERT INTO `eas_wo_dtl` VALUES (1847, 113, 'gJYAABwDAxLtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 2, 2, 0, 2, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1848, 113, 'gJYAABwDAxXtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 226, 226, 0, 226, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1849, 113, 'gJYAABwDAxPtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1850, 113, 'gJYAABwDAxbtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1851, 113, 'gJYAABwDAwrtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 10, 10, 0, 10, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1852, 113, 'gJYAABwDAwjtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 101, 101, 0, 101, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1853, 113, 'gJYAABwDAxDtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1854, 113, 'gJYAABwDAwntSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1855, 113, 'gJYAABwDAxTtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1856, 113, 'gJYAABwDAwztSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (1857, 113, 'gJYAABwDAxHtSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 50, 50, 0, 50, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1858, 113, 'gJYAABwDAxftSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (1859, 113, 'gJYAABwDAw7tSYg5', 'l9Jwbu1XT+uLo6/bJDkDgx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 201, 201, 0, 201, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1860, 114, 'gJYAABwDA0TtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 1500, 1500, 0, 1500, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1861, 114, 'gJYAABwDA0DtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 602, 602, 0, 0, 0, 2, 602);
INSERT INTO `eas_wo_dtl` VALUES (1862, 114, 'gJYAABwDAz7tSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 211, 211, 0, 0, 0, 2, 211);
INSERT INTO `eas_wo_dtl` VALUES (1863, 114, 'gJYAABwDAzrtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 20, 20, 0, 20, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1864, 114, 'gJYAABwDAz/tSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 2260, 2260, 0, 2260, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1865, 114, 'gJYAABwDAzftSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 8, 8, 0, 7, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (1866, 114, 'gJYAABwDAzvtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 5, 5, 0, 5, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1867, 114, 'gJYAABwDA0HtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 101, 101, 0, 101, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1868, 114, 'gJYAABwDAz3tSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1007, 1007, 0, 1007, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1869, 114, 'gJYAABwDAzbtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 4, 4, 0, 4, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1870, 114, 'gJYAABwDA0PtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 2013, 2013, 0, 2013, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1871, 114, 'gJYAABwDAzjtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (1872, 114, 'gJYAABwDAzztSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (1873, 114, 'gJYAABwDAzntSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 500, 500, 0, 500, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1874, 114, 'gJYAABwDAzXtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (1875, 114, 'gJYAABwDA0LtSYg5', 'HEHndkA8QlKyjqd+ux0hkx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 2013, 2013, 0, 2013, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1876, 115, 'gJYAABwDf+btSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 10040, 10040, 0, 0, 0, 2, 10040);
INSERT INTO `eas_wo_dtl` VALUES (1877, 115, 'gJYAABwDf+XtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 315, 315, 0, 315, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1878, 115, 'gJYAABwDf+PtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 164, 164, 0, 0, 0, 2, 164);
INSERT INTO `eas_wo_dtl` VALUES (1879, 115, 'gJYAABwDf+DtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 16526, 16526, 0, 16526, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1880, 115, 'gJYAABwDf9vtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 42, 42, 0, 42, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1881, 115, 'gJYAABwDf+jtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 29, 29, 0, 29, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1882, 115, 'gJYAABwDf+rtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 2008, 2008, 0, 2008, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1883, 115, 'gJYAABwDf9ztSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 20080, 20080, 0, 20080, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1884, 115, 'gJYAABwDf+HtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 167, 167, 0, 167, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1885, 115, 'gJYAABwDf9/tSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 33595, 33595, 0, 0, 0, NULL, 33595);
INSERT INTO `eas_wo_dtl` VALUES (1886, 115, 'gJYAABwDf93tSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1887, 115, 'gJYAABwDf97tSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 487, 487, 0, 0, 0, NULL, 487);
INSERT INTO `eas_wo_dtl` VALUES (1888, 115, 'gJYAABwDf+TtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 8347, 8347, 0, 8347, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1889, 115, 'gJYAABwDf+ftSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 487, 487, 0, 0, 0, NULL, 487);
INSERT INTO `eas_wo_dtl` VALUES (1890, 115, 'gJYAABwDf+ntSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 33595, 33595, 0, 33595, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1891, 115, 'gJYAABwDf+LtSYg5', '9ywSNP47Tx+yjZ35HMHj7x0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 8347, 8347, 0, 8347, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1892, 116, 'gJYAABwE3lztSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 195, 195, 0, 0, 0, 2, 195);
INSERT INTO `eas_wo_dtl` VALUES (1893, 116, 'gJYAABwE3mLtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAABtJ0SVECefw', '01.02.01.001.1361', '荧光粉', 'G518M', '克', 2813, 2813, 0, 1116, 0, 2, 1697);
INSERT INTO `eas_wo_dtl` VALUES (1894, 116, 'gJYAABwE3mHtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6080, 6080, 0, 6080, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1895, 116, 'gJYAABwE3mPtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1896, 116, 'gJYAABwE3mDtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1897, 116, 'gJYAABwE3mbtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 774, 774, 0, 774, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1898, 116, 'gJYAABwE3mjtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 7736, 7736, 0, 7736, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1899, 116, 'gJYAABwE3l/tSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 61, 61, 0, 61, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1900, 116, 'gJYAABwE3l7tSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12485, 12485, 0, 12485, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1901, 116, 'gJYAABwE3lvtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 10, 10, 0, 4, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (1902, 116, 'gJYAABwE3mftSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 181, 181, 0, 0, 0, NULL, 181);
INSERT INTO `eas_wo_dtl` VALUES (1903, 116, 'gJYAABwE3mXtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3102, 3102, 0, 3102, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1904, 116, 'gJYAABwE3mTtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 181, 181, 0, 0, 0, NULL, 181);
INSERT INTO `eas_wo_dtl` VALUES (1905, 116, 'gJYAABwE3lrtSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12485, 12485, 0, 12485, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1906, 116, 'gJYAABwE3l3tSYg5', 'uJYkMVm+SdKbolx5iyRl7B0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 3102, 3102, 0, 3102, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1907, 117, 'gJYAABwE3nrtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 350, 350, 0, 350, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1908, 117, 'gJYAABwE3nLtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 2595, 2595, 0, 0, 0, 2, 2595);
INSERT INTO `eas_wo_dtl` VALUES (1909, 117, 'gJYAABwE3m/tSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 62, 62, 0, 0, 0, 2, 62);
INSERT INTO `eas_wo_dtl` VALUES (1910, 117, 'gJYAABwE3nbtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4262, 4262, 0, 4262, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1911, 117, 'gJYAABwE3njtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 11, 11, 0, 11, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1912, 117, 'gJYAABwE3nvtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1913, 117, 'gJYAABwE3nXtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 415, 415, 0, 415, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1914, 117, 'gJYAABwE3nDtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 4153, 4153, 0, 4153, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1915, 117, 'gJYAABwE3nntSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 31, 31, 0, 31, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1916, 117, 'gJYAABwE3nHtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8752, 8752, 0, 8752, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1917, 117, 'gJYAABwE3nPtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (1918, 117, 'gJYAABwE3nztSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 127, 127, 0, 0, 0, NULL, 127);
INSERT INTO `eas_wo_dtl` VALUES (1919, 117, 'gJYAABwE3nTtSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2174, 2174, 0, 2174, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1920, 117, 'gJYAABwE3m7tSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 127, 127, 0, 0, 0, NULL, 127);
INSERT INTO `eas_wo_dtl` VALUES (1921, 117, 'gJYAABwE3nftSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8752, 8752, 0, 8752, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1922, 117, 'gJYAABwE3n3tSYg5', '/ywJzu2BRFSeE+1tGTxuyh0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 2174, 2174, 0, 2174, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1923, 118, 'gJYAABwE3pTtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 114, 114, 0, 0, 0, 2, 114);
INSERT INTO `eas_wo_dtl` VALUES (1924, 118, 'gJYAABwE3pHtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 434, 434, 0, 434, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1925, 118, 'gJYAABwE3ojtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 3065, 3065, 0, 0, 0, 2, 3065);
INSERT INTO `eas_wo_dtl` VALUES (1926, 118, 'gJYAABwE3o3tSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6279, 6279, 0, 6279, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1927, 118, 'gJYAABwE3o7tSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1928, 118, 'gJYAABwE3oftSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 23, 23, 0, 23, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1929, 118, 'gJYAABwE3pPtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 650, 650, 0, 650, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1930, 118, 'gJYAABwE3pDtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6496, 6496, 0, 6496, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1931, 118, 'gJYAABwE3obtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 46, 46, 0, 46, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1932, 118, 'gJYAABwE3ortSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 12894, 12894, 0, 12894, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1933, 118, 'gJYAABwE3o/tSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 10, 10, 0, 0, 0, NULL, 10);
INSERT INTO `eas_wo_dtl` VALUES (1934, 118, 'gJYAABwE3pLtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 187, 187, 0, 0, 0, NULL, 187);
INSERT INTO `eas_wo_dtl` VALUES (1935, 118, 'gJYAABwE3ontSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 3204, 3204, 0, 3204, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1936, 118, 'gJYAABwE3oXtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 187, 187, 0, 0, 0, NULL, 187);
INSERT INTO `eas_wo_dtl` VALUES (1937, 118, 'gJYAABwE3ovtSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 12894, 12894, 0, 12894, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1938, 118, 'gJYAABwE3oztSYg5', 'iOuJWhc4QcKXZlsMujM4Zx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 3204, 3204, 0, 3204, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1939, 119, 'gJYAABwE39HtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 3380, 3380, 0, 3380, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1940, 119, 'gJYAABwE38TtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 422, 422, 0, 422, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1941, 119, 'gJYAABwE38vtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 169, 169, 0, 169, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1942, 119, 'gJYAABwE387tSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2881, 2881, 0, 2881, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1943, 119, 'gJYAABwE38jtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 8, 8, 0, 8, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1944, 119, 'gJYAABwE383tSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 27, 27, 0, 27, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1945, 119, 'gJYAABwE38ftSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 337, 337, 0, 337, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1946, 119, 'gJYAABwE38rtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3372, 3372, 0, 3372, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1947, 119, 'gJYAABwE38XtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 35, 35, 0, 35, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1948, 119, 'gJYAABwE38ntSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6104, 6104, 0, 6104, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1949, 119, 'gJYAABwE39PtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (1950, 119, 'gJYAABwE38ztSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 89, 89, 0, 0, 0, NULL, 89);
INSERT INTO `eas_wo_dtl` VALUES (1951, 119, 'gJYAABwE38/tSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1517, 1517, 0, 1517, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1952, 119, 'gJYAABwE39LtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 89, 89, 0, 0, 0, NULL, 89);
INSERT INTO `eas_wo_dtl` VALUES (1953, 119, 'gJYAABwE38btSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6104, 6104, 0, 6104, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1954, 119, 'gJYAABwE39DtSYg5', 'Xe3UuW4cQHqsN+Z7kqGlXx0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1517, 1517, 0, 1517, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1955, 120, 'gJYAABwE3+btSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 2416, 2416, 0, 2416, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1956, 120, 'gJYAABwE3+7tSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 362, 362, 0, 124, 0, 2, 238);
INSERT INTO `eas_wo_dtl` VALUES (1957, 120, 'gJYAABwE3+jtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 85, 85, 0, 85, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1958, 120, 'gJYAABwE3+3tSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4953, 4953, 0, 4953, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1959, 120, 'gJYAABwE3/HtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 13, 13, 0, 13, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1960, 120, 'gJYAABwE3/LtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1961, 120, 'gJYAABwE3+ztSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 604, 604, 0, 604, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1962, 120, 'gJYAABwE3/DtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 6039, 6039, 0, 6039, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1963, 120, 'gJYAABwE3+rtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 48, 48, 0, 48, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1964, 120, 'gJYAABwE3+vtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10172, 10172, 0, 10172, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1965, 120, 'gJYAABwE3+/tSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (1966, 120, 'gJYAABwE3+ntSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 148, 148, 0, 0, 0, NULL, 148);
INSERT INTO `eas_wo_dtl` VALUES (1967, 120, 'gJYAABwE3/TtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 2527, 2527, 0, 2527, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1968, 120, 'gJYAABwE3/PtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 148, 148, 0, 0, 0, NULL, 148);
INSERT INTO `eas_wo_dtl` VALUES (1969, 120, 'gJYAABwE3+ftSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10172, 10172, 0, 10172, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1970, 120, 'gJYAABwE3+XtSYg5', 'spFMwkb+SsaZKKnzovSLIx0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 2527, 2527, 0, 2527, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1971, 121, 'gJYAABwE4ALtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 129, 129, 0, 0, 0, 2, 129);
INSERT INTO `eas_wo_dtl` VALUES (1972, 121, 'gJYAABwE4AjtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 1210, 1210, 0, 0, 0, 2, 1210);
INSERT INTO `eas_wo_dtl` VALUES (1973, 121, 'gJYAABwE4AXtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 50, 50, 0, 0, 0, 2, 50);
INSERT INTO `eas_wo_dtl` VALUES (1974, 121, 'gJYAABwE3/3tSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 2462, 2462, 0, 2462, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1975, 121, 'gJYAABwE4AztSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 6, 6, 0, 6, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1976, 121, 'gJYAABwE4AbtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 9, 9, 0, 9, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1977, 121, 'gJYAABwE3//tSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 262, 262, 0, 262, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1978, 121, 'gJYAABwE4ADtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 2618, 2618, 0, 2618, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (1979, 121, 'gJYAABwE4AHtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 18, 18, 0, 18, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1980, 121, 'gJYAABwE4APtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5057, 5057, 0, 5057, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1981, 121, 'gJYAABwE4AvtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (1982, 121, 'gJYAABwE3/7tSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 73, 73, 0, 0, 0, NULL, 73);
INSERT INTO `eas_wo_dtl` VALUES (1983, 121, 'gJYAABwE4ATtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABo8aXBECefw', '02.03.20.002.1338', '平面支架', '2836A_C2072_20B03_A4A20', '千个', 1256, 1256, 0, 1256, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1984, 121, 'gJYAABwE4ArtSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 73, 73, 0, 0, 0, NULL, 73);
INSERT INTO `eas_wo_dtl` VALUES (1985, 121, 'gJYAABwE4AntSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5057, 5057, 0, 5057, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1986, 121, 'gJYAABwE4AftSYg5', '3O7hmKjpR+ezJojGDEcnkR0NgN0=', 'gJYAABcsU7tECefw', '06.10.03.001.0070', 'DICE', 'S-DICE-BXCD1026', '千个', 1256, 1256, 0, 1256, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (1987, 122, 'gJYAABwE4CDtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAABc2rwFECefw', '01.01.01.010.3392', 'DICE', 'DICE-BPA0G14A', '千个', 35000, 35000, 0, 34971, 0, 0, 29);
INSERT INTO `eas_wo_dtl` VALUES (1988, 122, 'gJYAABwE4BztSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAAABdFKFECefw', '01.02.01.001.0153', '荧光粉', '阳光5号', '克', 6622, 6622, 0, 3079, 0, 2, 3543);
INSERT INTO `eas_wo_dtl` VALUES (1989, 122, 'gJYAABwE4BvtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAAAsj/VBECefw', '01.02.01.001.1042', '荧光粉', '阳光535-15', '克', 1831, 1831, 0, 1830, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (1990, 122, 'gJYAABwE4CLtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 210, 210, 0, 210, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (1991, 122, 'gJYAABwE4CftSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAABWXvNtECefw', '01.02.01.006.0077', '键合银丝', 'YA2M_0.75mil', '米', 55300, 55300, 0, 55300, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1992, 122, 'gJYAABwE4CPtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAABF8F4ZECefw', '01.02.01.100.1077', '瓷嘴', 'MH-035', '支', 54, 54, 0, 54, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (1993, 122, 'gJYAABwE4CHtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 5917, 5917, 0, 619, 0, 1, 5299);
INSERT INTO `eas_wo_dtl` VALUES (1994, 122, 'gJYAABwE4CrtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 59175, 59175, 0, 6182, 0, 1, 52992);
INSERT INTO `eas_wo_dtl` VALUES (1995, 122, 'gJYAABwE4CTtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 501, 501, 0, 501, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (1996, 122, 'gJYAABwE4B7tSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 42, 42, 0, 0, 0, NULL, 42);
INSERT INTO `eas_wo_dtl` VALUES (1997, 122, 'gJYAABwE4CXtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAAA+DghFECefw', '02.02.02.002.0015', '胶水', 'MS-042', '克', 193, 193, 0, 134, 0, NULL, 58);
INSERT INTO `eas_wo_dtl` VALUES (1998, 122, 'gJYAABwE4CbtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAABdb1zpECefw', '02.03.20.002.1231', '平面支架', '2835H_F1975_20_A4C22', '千个', 35000, 35000, 0, 35000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (1999, 122, 'gJYAABwE4B/tSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 1208, 1208, 0, 1184, 0, NULL, 23);
INSERT INTO `eas_wo_dtl` VALUES (2000, 122, 'gJYAABwE4B3tSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 140875, 140875, 0, 13260, 0, NULL, 127615);
INSERT INTO `eas_wo_dtl` VALUES (2001, 122, 'gJYAABwE4CntSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAABVgVmBECefw', '02.06.02.001.0003', '封带', 'MLS-006', '米', 140875, 140875, 0, 119598, 0, NULL, 21278);
INSERT INTO `eas_wo_dtl` VALUES (2002, 122, 'gJYAABwE4CjtSYg5', 'iH0ZYuuqQvqkiHGECOqWmB0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 406, 406, 0, 406, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2003, 123, 'gJYAABwE4SPtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 4500, 4500, 0, 4500, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2004, 123, 'gJYAABwE4SXtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 1687, 1687, 0, 0, 0, 2, 1687);
INSERT INTO `eas_wo_dtl` VALUES (2005, 123, 'gJYAABwE4SHtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABt0tChECefw', '01.02.01.001.1377', '荧光粉', 'G403', '克', 925, 925, 0, 0, 0, 2, 925);
INSERT INTO `eas_wo_dtl` VALUES (2006, 123, 'gJYAABwE4SjtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 70, 70, 0, 16, 0, 2, 54);
INSERT INTO `eas_wo_dtl` VALUES (2007, 123, 'gJYAABwE4SvtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 6780, 6780, 0, 2168, 0, NULL, 4612);
INSERT INTO `eas_wo_dtl` VALUES (2008, 123, 'gJYAABwE4SntSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 25, 25, 0, 0, 0, NULL, 25);
INSERT INTO `eas_wo_dtl` VALUES (2009, 123, 'gJYAABwE4SztSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2010, 123, 'gJYAABwE4SDtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 302, 302, 0, 302, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2011, 123, 'gJYAABwE4R7tSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3020, 3020, 0, 3020, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2012, 123, 'gJYAABwE4SbtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 24, 24, 0, 24, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2013, 123, 'gJYAABwE4R/tSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6038, 6038, 0, 6038, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2014, 123, 'gJYAABwE4SrtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 8, 8, 0, 0, 0, NULL, 8);
INSERT INTO `eas_wo_dtl` VALUES (2015, 123, 'gJYAABwE4SLtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 83, 83, 0, 0, 0, NULL, 83);
INSERT INTO `eas_wo_dtl` VALUES (2016, 123, 'gJYAABwE4SftSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 1500, 1500, 0, 1500, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2017, 123, 'gJYAABwE4S3tSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 83, 83, 0, 0, 0, NULL, 83);
INSERT INTO `eas_wo_dtl` VALUES (2018, 123, 'gJYAABwE4STtSYg5', 'qnr87LbgQBe7I/D0C7m40h0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6038, 6038, 0, 6038, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2019, 124, 'gJYAABwFiRvtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 1526, 1526, 0, 0, 0, 2, 1526);
INSERT INTO `eas_wo_dtl` VALUES (2020, 124, 'gJYAABwFiSDtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 279, 279, 0, 0, 0, 2, 279);
INSERT INTO `eas_wo_dtl` VALUES (2021, 124, 'gJYAABwFiSntSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABTLYxhECefw', '01.02.01.001.1220', '荧光粉', 'KSR-003', '克', 32, 32, 0, 0, 0, 2, 32);
INSERT INTO `eas_wo_dtl` VALUES (2022, 124, 'gJYAABwFiR3tSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 4882, 4882, 0, 4882, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2023, 124, 'gJYAABwFiSHtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 22, 22, 0, 22, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2024, 124, 'gJYAABwFiSftSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 16, 16, 0, 16, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2025, 124, 'gJYAABwFiR/tSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 315, 315, 0, 315, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2026, 124, 'gJYAABwFiR7tSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3153, 3153, 0, 3153, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2027, 124, 'gJYAABwFiSXtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 37, 37, 0, 37, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2028, 124, 'gJYAABwFiSPtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 4338, 4338, 0, 4338, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2029, 124, 'gJYAABwFiSLtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (2030, 124, 'gJYAABwFiSTtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 63, 63, 0, 0, 0, NULL, 63);
INSERT INTO `eas_wo_dtl` VALUES (2031, 124, 'gJYAABwFiSbtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1078, 1078, 0, 1078, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2032, 124, 'gJYAABwFiRztSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 63, 63, 0, 0, 0, NULL, 63);
INSERT INTO `eas_wo_dtl` VALUES (2033, 124, 'gJYAABwFiSjtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 4338, 4338, 0, 4338, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2034, 124, 'gJYAABwFiRrtSYg5', 'CRQk25PJSrmGMy7u3LyGIB0NgN0=', 'gJYAABlFPCJECefw', '06.10.03.001.0100', 'DICE', 'S-DICE-BXHV1442', '千个', 2155, 2155, 0, 2155, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2035, 125, 'gJYAABwFiWLtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 5002, 5002, 0, 0, 0, 2, 5002);
INSERT INTO `eas_wo_dtl` VALUES (2036, 125, 'gJYAABwFiWXtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 222, 222, 0, 0, 0, 2, 222);
INSERT INTO `eas_wo_dtl` VALUES (2037, 125, 'gJYAABwFiVvtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 11412, 11412, 0, 11412, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2038, 125, 'gJYAABwFiWHtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 29, 29, 0, 29, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2039, 125, 'gJYAABwFiWDtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 20, 20, 0, 20, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2040, 125, 'gJYAABwFiVrtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1334, 1334, 0, 790, 0, 1, 544);
INSERT INTO `eas_wo_dtl` VALUES (2041, 125, 'gJYAABwFiWTtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 13338, 13338, 0, 12220, 0, 1, 1118);
INSERT INTO `eas_wo_dtl` VALUES (2042, 125, 'gJYAABwFiWPtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 116, 116, 0, 116, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2043, 125, 'gJYAABwFiV7tSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABQZfYVECefw', '01.02.13.010.1024', '封带', 'MT-009', '米', 23199, 23199, 0, 2532, 0, NULL, 20667);
INSERT INTO `eas_wo_dtl` VALUES (2044, 125, 'gJYAABwFiVztSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 19, 19, 0, 0, 0, NULL, 19);
INSERT INTO `eas_wo_dtl` VALUES (2045, 125, 'gJYAABwFiV3tSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 337, 337, 0, 0, 0, NULL, 337);
INSERT INTO `eas_wo_dtl` VALUES (2046, 125, 'gJYAABwFiWbtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 5764, 5764, 0, 5764, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2047, 125, 'gJYAABwFiV/tSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 337, 337, 0, 0, 0, NULL, 337);
INSERT INTO `eas_wo_dtl` VALUES (2048, 125, 'gJYAABwFiVntSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 23199, 23199, 0, 1591, 0, NULL, 21607);
INSERT INTO `eas_wo_dtl` VALUES (2049, 125, 'gJYAABwFiVjtSYg5', 'HaDe7wJCQV6b4uiDpnQh5x0NgN0=', 'gJYAABfoI/FECefw', '06.10.03.001.0096', 'DICE', 'S-DICE-BXCD1234', '千个', 5764, 5764, 0, 5764, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2050, 126, 'gJYAABwHE5ztSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 3307, 3307, 0, 2070, 0, 2, 1236);
INSERT INTO `eas_wo_dtl` VALUES (2051, 126, 'gJYAABwHE6btSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 245, 245, 0, 245, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2052, 126, 'gJYAABwHE6XtSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 8342, 8342, 0, 8342, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2053, 126, 'gJYAABwHE6jtSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 27, 27, 0, 22, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (2054, 126, 'gJYAABwHE6ftSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 30, 30, 0, 30, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2055, 126, 'gJYAABwHE5/tSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 529, 529, 0, 0, 0, 1, 529);
INSERT INTO `eas_wo_dtl` VALUES (2056, 126, 'gJYAABwHE6PtSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5292, 5292, 0, 0, 0, 1, 5292);
INSERT INTO `eas_wo_dtl` VALUES (2057, 126, 'gJYAABwHE53tSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 36, 36, 0, 36, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2058, 126, 'gJYAABwHE5vtSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 11420, 11420, 0, 11420, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2059, 126, 'gJYAABwHE6LtSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 9, 9, 0, 0, 0, NULL, 9);
INSERT INTO `eas_wo_dtl` VALUES (2060, 126, 'gJYAABwHE6TtSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 166, 166, 0, 0, 0, NULL, 166);
INSERT INTO `eas_wo_dtl` VALUES (2061, 126, 'gJYAABwHE6DtSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 2837, 2837, 0, 2837, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2062, 126, 'gJYAABwHE6ntSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 166, 166, 0, 0, 0, NULL, 166);
INSERT INTO `eas_wo_dtl` VALUES (2063, 126, 'gJYAABwHE57tSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 11420, 11420, 0, 0, 0, NULL, 11420);
INSERT INTO `eas_wo_dtl` VALUES (2064, 126, 'gJYAABwHE6HtSYg5', 'xNDRdLnqTEKApTMuVdzBjh0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 5675, 5675, 0, 5675, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2065, 127, 'gJYAABwHE63tSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 2030, 2030, 0, 0, 0, 2, 2030);
INSERT INTO `eas_wo_dtl` VALUES (2066, 127, 'gJYAABwHE7ftSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAABiGkWBECefw', '01.02.01.001.1274', '荧光粉', 'R301', '克', 150, 150, 0, 24, 0, 2, 126);
INSERT INTO `eas_wo_dtl` VALUES (2067, 127, 'gJYAABwHE7btSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 5122, 5122, 0, 5122, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2068, 127, 'gJYAABwHE7ntSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 17, 17, 0, 0, 0, NULL, 17);
INSERT INTO `eas_wo_dtl` VALUES (2069, 127, 'gJYAABwHE7jtSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 18, 18, 0, 18, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2070, 127, 'gJYAABwHE7DtSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 325, 325, 0, 0, 0, 1, 325);
INSERT INTO `eas_wo_dtl` VALUES (2071, 127, 'gJYAABwHE7TtSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3249, 3249, 0, 0, 0, 1, 3249);
INSERT INTO `eas_wo_dtl` VALUES (2072, 127, 'gJYAABwHE67tSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 22, 22, 0, 22, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2073, 127, 'gJYAABwHE6ztSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7012, 7012, 0, 7012, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2074, 127, 'gJYAABwHE7PtSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (2075, 127, 'gJYAABwHE7XtSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 102, 102, 0, 0, 0, NULL, 102);
INSERT INTO `eas_wo_dtl` VALUES (2076, 127, 'gJYAABwHE7HtSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1742, 1742, 0, 1742, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2077, 127, 'gJYAABwHE7rtSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 102, 102, 0, 0, 0, NULL, 102);
INSERT INTO `eas_wo_dtl` VALUES (2078, 127, 'gJYAABwHE6/tSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7012, 7012, 0, 0, 0, NULL, 7012);
INSERT INTO `eas_wo_dtl` VALUES (2079, 127, 'gJYAABwHE7LtSYg5', 'uVosdkwaQzy8dQynGMGWCB0NgN0=', 'gJYAABoPnHRECefw', '06.10.03.001.0118', 'DICE', 'S-DICE-BXHV1931-M1', '千个', 3484, 3484, 0, 3484, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2080, 128, 'gJYAABwHuKHtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 80000, 80000, 0, 80000, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2081, 128, 'gJYAABwHuJ7tSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAAAAFAAxECefw', '01.02.01.001.0055', '荧光粉', '阳光4号', '克', 23240, 23240, 0, 23240, 0, 2, 0);
INSERT INTO `eas_wo_dtl` VALUES (2082, 128, 'gJYAABwHuKbtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 7944, 7944, 0, 3859, 0, 2, 4085);
INSERT INTO `eas_wo_dtl` VALUES (2083, 128, 'gJYAABwHuJ3tSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 126400, 126400, 0, 104830, 0, NULL, 21570);
INSERT INTO `eas_wo_dtl` VALUES (2084, 128, 'gJYAABwHuKTtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 200, 200, 0, 200, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2085, 128, 'gJYAABwHuJ/tSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABqxu7dECefw', '01.02.03.014.0211', '硅胶', 'MN-006A', '克', 10456, 10456, 0, 10456, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2086, 128, 'gJYAABwHuKrtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABqxvCdECefw', '01.02.03.014.0212', '硅胶', 'MN-006B', '克', 104560, 104560, 0, 104560, 0, 1, 0);
INSERT INTO `eas_wo_dtl` VALUES (2087, 128, 'gJYAABwHuKjtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 584, 584, 0, 584, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2088, 128, 'gJYAABwHuJztSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 96, 96, 0, 0, 0, NULL, 96);
INSERT INTO `eas_wo_dtl` VALUES (2089, 128, 'gJYAABwHuKLtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 240, 240, 0, 30, 0, NULL, 210);
INSERT INTO `eas_wo_dtl` VALUES (2090, 128, 'gJYAABwHuKftSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 80000, 80000, 0, 80000, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2091, 128, 'gJYAABwHuKXtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 2768, 2768, 0, 0, 0, NULL, 2768);
INSERT INTO `eas_wo_dtl` VALUES (2092, 128, 'gJYAABwHuKntSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 322000, 322000, 0, 0, 0, NULL, 322000);
INSERT INTO `eas_wo_dtl` VALUES (2093, 128, 'gJYAABwHuKPtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 322000, 322000, 0, 304817, 0, NULL, 17183);
INSERT INTO `eas_wo_dtl` VALUES (2094, 128, 'gJYAABwHuKDtSYg5', 'k2ypQxNbTZac5DqvNv0whh0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 928, 928, 0, 928, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2095, 129, 'gJYAABwHuSntSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAABtyFrlECefw', '01.01.01.010.3808', 'DICE', 'DICE-Y0922C', '千个', 200, 200, 0, 200, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2096, 129, 'gJYAABwHuSjtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 2, 2, 0, 0, 0, 2, 2);
INSERT INTO `eas_wo_dtl` VALUES (2097, 129, 'gJYAABwHuSXtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAAAsj/VBECefw', '01.02.01.001.1042', '荧光粉', '阳光535-15', '克', 34, 34, 0, 0, 0, 2, 34);
INSERT INTO `eas_wo_dtl` VALUES (2098, 129, 'gJYAABwHuSrtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAAAlp3CdECefw', '01.02.01.006.0055', '银线', '高银线20*1000（MKE）', '米', 320, 320, 0, 320, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2099, 129, 'gJYAABwHuR7tSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAABF8F4ZECefw', '01.02.01.100.1077', '瓷嘴', 'MH-035', '支', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2100, 129, 'gJYAABwHuSLtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 21, 21, 0, 0, 0, 1, 21);
INSERT INTO `eas_wo_dtl` VALUES (2101, 129, 'gJYAABwHuSHtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 212, 212, 0, 0, 0, 1, 212);
INSERT INTO `eas_wo_dtl` VALUES (2102, 129, 'gJYAABwHuSztSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2103, 129, 'gJYAABwHuSvtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAABudn0pECefw', '01.02.13.040.5600', '纸箱', '40.2*40.2*27（5层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2104, 129, 'gJYAABwHuR/tSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAABD6Qx9ECefw', '02.02.02.002.0016', '绝缘胶', '绝缘胶_MC-002', '克', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2105, 129, 'gJYAABwHuSftSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAABskRR9ECefw', '02.03.20.002.1379', '平面支架', '2835E_C2372_50_B5A20', '千个', 100, 100, 0, 100, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2106, 129, 'gJYAABwHuSTtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (2107, 129, 'gJYAABwHuSbtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (2108, 129, 'gJYAABwHuSDtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 403, 403, 0, 0, 0, NULL, 403);
INSERT INTO `eas_wo_dtl` VALUES (2109, 129, 'gJYAABwHuSPtSYg5', 'nUIohx5QSQqEupjfPOUb3x0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2110, 130, 'gJYAABwHukrtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABpsKmJECefw', '01.01.01.010.3644', 'DICE', 'DICE-BPA0I18G-F', '千个', 50, 50, 0, 44, 0, 0, 6);
INSERT INTO `eas_wo_dtl` VALUES (2111, 130, 'gJYAABwHukPtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAAAsj/VBECefw', '01.02.01.001.1042', '荧光粉', '阳光535-15', '克', 15, 15, 0, 0, 0, 2, 15);
INSERT INTO `eas_wo_dtl` VALUES (2112, 130, 'gJYAABwHukntSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAAA+Zk5BECefw', '01.02.01.001.1070', '荧光粉', 'MLS631-02', '克', 1, 1, 0, 0, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (2113, 130, 'gJYAABwHuk7tSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABWXvNtECefw', '01.02.01.006.0077', '键合银丝', 'YA2M_0.75mil', '米', 80, 80, 0, 0, 0, NULL, 80);
INSERT INTO `eas_wo_dtl` VALUES (2114, 130, 'gJYAABwHukftSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABF8F4ZECefw', '01.02.01.100.1077', '瓷嘴', 'MH-035', '支', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2115, 130, 'gJYAABwHukjtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 10, 10, 0, 0, 0, 1, 10);
INSERT INTO `eas_wo_dtl` VALUES (2116, 130, 'gJYAABwHukvtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 100, 100, 0, 0, 0, 1, 100);
INSERT INTO `eas_wo_dtl` VALUES (2117, 130, 'gJYAABwHukXtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 1, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2118, 130, 'gJYAABwHukbtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABudn0pECefw', '01.02.13.040.5600', '纸箱', '40.2*40.2*27（5层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2119, 130, 'gJYAABwHukTtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABD6Qx9ECefw', '02.02.02.002.0016', '绝缘胶', '绝缘胶_MC-002', '克', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2120, 130, 'gJYAABwHukztSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABtgARNECefw', '02.03.20.002.1399', '平面支架', '2835Y_C2375_20_A13A22', '千个', 50, 50, 0, 0, 0, 3, 50);
INSERT INTO `eas_wo_dtl` VALUES (2121, 130, 'gJYAABwHulHtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (2122, 130, 'gJYAABwHuk3tSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 201, 201, 0, 0, 0, NULL, 201);
INSERT INTO `eas_wo_dtl` VALUES (2123, 130, 'gJYAABwHulDtSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201, 201, 0, 0, 0, NULL, 201);
INSERT INTO `eas_wo_dtl` VALUES (2124, 130, 'gJYAABwHuk/tSYg5', 'LWj7+jAtSV2eOpq6QJWFxB0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1, 1, 0, 1, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2125, 131, 'gJYAABwHunPtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 9177, 9177, 0, 0, 0, 2, 9177);
INSERT INTO `eas_wo_dtl` VALUES (2126, 131, 'gJYAABwHunDtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 1326, 1326, 0, 0, 0, 2, 1326);
INSERT INTO `eas_wo_dtl` VALUES (2127, 131, 'gJYAABwHunvtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 21260, 21260, 0, 21260, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2128, 131, 'gJYAABwHunXtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 102, 102, 0, 0, 0, NULL, 102);
INSERT INTO `eas_wo_dtl` VALUES (2129, 131, 'gJYAABwHunbtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 92, 92, 0, 92, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2130, 131, 'gJYAABwHun3tSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1045, 1045, 0, 0, 0, 1, 1045);
INSERT INTO `eas_wo_dtl` VALUES (2131, 131, 'gJYAABwHunjtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 10449, 10449, 0, 0, 0, 1, 10449);
INSERT INTO `eas_wo_dtl` VALUES (2132, 131, 'gJYAABwHunHtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 61, 61, 0, 61, 0, 5, 0);
INSERT INTO `eas_wo_dtl` VALUES (2133, 131, 'gJYAABwHunLtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 20521, 20521, 0, 20521, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2134, 131, 'gJYAABwHunrtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 17, 17, 0, 0, 0, NULL, 17);
INSERT INTO `eas_wo_dtl` VALUES (2135, 131, 'gJYAABwHun7tSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 298, 298, 0, 0, 0, NULL, 298);
INSERT INTO `eas_wo_dtl` VALUES (2136, 131, 'gJYAABwHunztSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 5098, 5098, 0, 5098, 0, 3, 0);
INSERT INTO `eas_wo_dtl` VALUES (2137, 131, 'gJYAABwHunntSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 298, 298, 0, 0, 0, NULL, 298);
INSERT INTO `eas_wo_dtl` VALUES (2138, 131, 'gJYAABwHunftSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 20521, 20521, 0, 0, 0, NULL, 20521);
INSERT INTO `eas_wo_dtl` VALUES (2139, 131, 'gJYAABwHunTtSYg5', 'vZ/mFY7USaWBxfXY9SK3aB0NgN0=', 'gJYAABtFJE1ECefw', '06.10.03.001.0139', 'DICE', 'S-DICE-BXCD1133(X11A)', '千个', 15295, 15295, 0, 15295, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2140, 132, 'gJYAABwJCHTtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAAAdqpRJECefw', '01.02.01.001.1035', '荧光粉', 'GAL535-M', '克', 2579, 2579, 0, 0, 0, 2, 2579);
INSERT INTO `eas_wo_dtl` VALUES (2141, 132, 'gJYAABwJCGztSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 19106, 19106, 0, 0, 0, 2, 19106);
INSERT INTO `eas_wo_dtl` VALUES (2142, 132, 'gJYAABwJCGntSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 458, 458, 0, 0, 0, 2, 458);
INSERT INTO `eas_wo_dtl` VALUES (2143, 132, 'gJYAABwJCHDtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 31374, 31374, 0, 31374, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2144, 132, 'gJYAABwJCHLtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 80, 80, 0, 0, 0, NULL, 80);
INSERT INTO `eas_wo_dtl` VALUES (2145, 132, 'gJYAABwJCHXtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 115, 115, 0, 96, 0, NULL, 19);
INSERT INTO `eas_wo_dtl` VALUES (2146, 132, 'gJYAABwJCG/tSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3057, 3057, 0, 0, 0, 1, 3057);
INSERT INTO `eas_wo_dtl` VALUES (2147, 132, 'gJYAABwJCGrtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 30573, 30573, 0, 0, 0, 1, 30573);
INSERT INTO `eas_wo_dtl` VALUES (2148, 132, 'gJYAABwJCHPtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 229, 229, 0, 150, 0, 5, 79);
INSERT INTO `eas_wo_dtl` VALUES (2149, 132, 'gJYAABwJCGvtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 64428, 64428, 0, 64428, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2150, 132, 'gJYAABwJCG3tSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 52, 52, 0, 0, 0, NULL, 52);
INSERT INTO `eas_wo_dtl` VALUES (2151, 132, 'gJYAABwJCHbtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 935, 935, 0, 0, 0, NULL, 935);
INSERT INTO `eas_wo_dtl` VALUES (2152, 132, 'gJYAABwJCG7tSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 16007, 16007, 0, 15132, 0, 3, 875);
INSERT INTO `eas_wo_dtl` VALUES (2153, 132, 'gJYAABwJCGjtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 935, 935, 0, 0, 0, NULL, 935);
INSERT INTO `eas_wo_dtl` VALUES (2154, 132, 'gJYAABwJCHHtSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 64428, 64428, 0, 0, 0, NULL, 64428);
INSERT INTO `eas_wo_dtl` VALUES (2155, 132, 'gJYAABwJCHftSYg5', 'DIHsxyFcS4OO3bceFo9cLh0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 16007, 16007, 0, 16007, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2156, 133, 'gJYAABwJCILtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 23, 23, 0, 0, 0, 2, 23);
INSERT INTO `eas_wo_dtl` VALUES (2157, 133, 'gJYAABwJCIjtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 66, 66, 0, 0, 0, 2, 66);
INSERT INTO `eas_wo_dtl` VALUES (2158, 133, 'gJYAABwJCIftSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 837, 837, 0, 0, 0, 2, 837);
INSERT INTO `eas_wo_dtl` VALUES (2159, 133, 'gJYAABwJCIPtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 1715, 1715, 0, 1715, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2160, 133, 'gJYAABwJCIntSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 4, 4, 0, 0, 0, NULL, 4);
INSERT INTO `eas_wo_dtl` VALUES (2161, 133, 'gJYAABwJCIrtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 6, 6, 0, 0, 0, NULL, 6);
INSERT INTO `eas_wo_dtl` VALUES (2162, 133, 'gJYAABwJCIztSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 177, 177, 0, 0, 0, 1, 177);
INSERT INTO `eas_wo_dtl` VALUES (2163, 133, 'gJYAABwJCI/tSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 1774, 1774, 0, 0, 0, 1, 1774);
INSERT INTO `eas_wo_dtl` VALUES (2164, 133, 'gJYAABwJCIDtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 13, 13, 0, 0, 0, 5, 13);
INSERT INTO `eas_wo_dtl` VALUES (2165, 133, 'gJYAABwJCIXtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 3522, 3522, 0, 3522, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2166, 133, 'gJYAABwJCIHtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 3, 3, 0, 0, 0, NULL, 3);
INSERT INTO `eas_wo_dtl` VALUES (2167, 133, 'gJYAABwJCI3tSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 51, 51, 0, 0, 0, NULL, 51);
INSERT INTO `eas_wo_dtl` VALUES (2168, 133, 'gJYAABwJCIvtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 875, 875, 0, 0, 0, 3, 875);
INSERT INTO `eas_wo_dtl` VALUES (2169, 133, 'gJYAABwJCI7tSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 51, 51, 0, 0, 0, NULL, 51);
INSERT INTO `eas_wo_dtl` VALUES (2170, 133, 'gJYAABwJCIbtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 3522, 3522, 0, 0, 0, NULL, 3522);
INSERT INTO `eas_wo_dtl` VALUES (2171, 133, 'gJYAABwJCITtSYg5', 'XVnFfd0hSa6Wvei6JiHKKx0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 875, 875, 0, 875, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2172, 134, 'gJYAABwJCKbtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAA2PVBJECefw', '01.02.01.001.1048', '荧光粉', 'GAL525-M', '克', 12557, 12557, 0, 0, 0, 2, 12557);
INSERT INTO `eas_wo_dtl` VALUES (2173, 134, 'gJYAABwJCKztSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 1255, 1255, 0, 0, 0, 2, 1255);
INSERT INTO `eas_wo_dtl` VALUES (2174, 134, 'gJYAABwJCK3tSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAABkHsQFECefw', '01.02.01.001.1279', '荧光粉', 'R201', '克', 38, 38, 0, 0, 0, 2, 38);
INSERT INTO `eas_wo_dtl` VALUES (2175, 134, 'gJYAABwJCKDtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 34122, 34122, 0, 6367, 0, NULL, 27755);
INSERT INTO `eas_wo_dtl` VALUES (2176, 134, 'gJYAABwJCKTtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 87, 87, 0, 0, 0, NULL, 87);
INSERT INTO `eas_wo_dtl` VALUES (2177, 134, 'gJYAABwJCKrtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 125, 125, 0, 0, 0, NULL, 125);
INSERT INTO `eas_wo_dtl` VALUES (2178, 134, 'gJYAABwJCKHtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 3517, 3517, 0, 0, 0, 1, 3517);
INSERT INTO `eas_wo_dtl` VALUES (2179, 134, 'gJYAABwJCKXtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 35167, 35167, 0, 0, 0, 1, 35167);
INSERT INTO `eas_wo_dtl` VALUES (2180, 134, 'gJYAABwJCJ/tSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 277, 277, 0, 0, 0, 5, 277);
INSERT INTO `eas_wo_dtl` VALUES (2181, 134, 'gJYAABwJCKntSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 70072, 70072, 0, 70072, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2182, 134, 'gJYAABwJCKPtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 56, 56, 0, 0, 0, NULL, 56);
INSERT INTO `eas_wo_dtl` VALUES (2183, 134, 'gJYAABwJCJ7tSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 1017, 1017, 0, 0, 0, NULL, 1017);
INSERT INTO `eas_wo_dtl` VALUES (2184, 134, 'gJYAABwJCKvtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 17409, 17409, 0, 0, 0, 3, 17409);
INSERT INTO `eas_wo_dtl` VALUES (2185, 134, 'gJYAABwJCKjtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 1017, 1017, 0, 0, 0, NULL, 1017);
INSERT INTO `eas_wo_dtl` VALUES (2186, 134, 'gJYAABwJCKftSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 70072, 70072, 0, 0, 0, NULL, 70072);
INSERT INTO `eas_wo_dtl` VALUES (2187, 134, 'gJYAABwJCKLtSYg5', 'YAG+KEGaQ+2hK5buSYSFwh0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 17409, 17409, 0, 17409, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2188, 135, 'gJYAABwJCMHtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 306, 306, 0, 0, 0, 2, 306);
INSERT INTO `eas_wo_dtl` VALUES (2189, 135, 'gJYAABwJCL7tSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAA7RlfJECefw', '01.02.01.001.1052', '荧光粉', 'MLS650', '克', 1166, 1166, 0, 0, 0, 2, 1166);
INSERT INTO `eas_wo_dtl` VALUES (2190, 135, 'gJYAABwJCLXtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAABbqeBVECefw', '01.02.01.001.1265', '荧光粉', 'GAL532-M', '克', 8225, 8225, 0, 0, 0, 2, 8225);
INSERT INTO `eas_wo_dtl` VALUES (2191, 135, 'gJYAABwJCLrtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 16851, 16851, 0, 0, 0, NULL, 16851);
INSERT INTO `eas_wo_dtl` VALUES (2192, 135, 'gJYAABwJCLvtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 43, 43, 0, 0, 0, NULL, 43);
INSERT INTO `eas_wo_dtl` VALUES (2193, 135, 'gJYAABwJCLTtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 62, 62, 0, 0, 0, NULL, 62);
INSERT INTO `eas_wo_dtl` VALUES (2194, 135, 'gJYAABwJCMDtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 1744, 1744, 0, 0, 0, 1, 1744);
INSERT INTO `eas_wo_dtl` VALUES (2195, 135, 'gJYAABwJCL3tSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 17434, 17434, 0, 0, 0, 1, 17434);
INSERT INTO `eas_wo_dtl` VALUES (2196, 135, 'gJYAABwJCLPtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 125, 125, 0, 0, 0, 5, 125);
INSERT INTO `eas_wo_dtl` VALUES (2197, 135, 'gJYAABwJCLftSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 34606, 34606, 0, 3105, 0, NULL, 31501);
INSERT INTO `eas_wo_dtl` VALUES (2198, 135, 'gJYAABwJCLztSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (2199, 135, 'gJYAABwJCL/tSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 502, 502, 0, 0, 0, NULL, 502);
INSERT INTO `eas_wo_dtl` VALUES (2200, 135, 'gJYAABwJCLbtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 8598, 8598, 0, 0, 0, 3, 8598);
INSERT INTO `eas_wo_dtl` VALUES (2201, 135, 'gJYAABwJCLLtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 502, 502, 0, 0, 0, NULL, 502);
INSERT INTO `eas_wo_dtl` VALUES (2202, 135, 'gJYAABwJCLjtSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 34606, 34606, 0, 0, 0, NULL, 34606);
INSERT INTO `eas_wo_dtl` VALUES (2203, 135, 'gJYAABwJCLntSYg5', 'gjSXDpxGQrCImRjQUiJPCB0NgN0=', 'gJYAABdcielECefw', '06.10.03.001.0093', 'DICE', 'S-DICE-BXCD1835', '千个', 8598, 8598, 0, 8598, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2204, 136, 'gJYAABwKXxHtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABnSNc9ECefw', '01.01.01.010.3557', 'DICE', 'DICE-BPA0L32B-F', '千个', 7500, 7500, 0, 7492, 0, 0, 8);
INSERT INTO `eas_wo_dtl` VALUES (2205, 136, 'gJYAABwKXxTtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABXStapECefw', '01.02.01.001.1251', '荧光粉', 'KSL610', '克', 3008, 3008, 0, 0, 0, 2, 3008);
INSERT INTO `eas_wo_dtl` VALUES (2206, 136, 'gJYAABwKXwrtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABt0s6tECefw', '01.02.01.001.1378', '荧光粉', 'G205', '克', 1056, 1056, 0, 0, 0, 2, 1056);
INSERT INTO `eas_wo_dtl` VALUES (2207, 136, 'gJYAABwKXwvtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABt9tQtECefw', '01.02.01.001.1381', '荧光粉', 'R102', '克', 99, 99, 0, 0, 0, 2, 99);
INSERT INTO `eas_wo_dtl` VALUES (2208, 136, 'gJYAABwKXxDtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABaJwLRECefw', '01.02.01.002.1204', '键合金丝', 'YGA2-20um', '米', 11300, 11300, 0, 0, 0, NULL, 11300);
INSERT INTO `eas_wo_dtl` VALUES (2209, 136, 'gJYAABwKXw3tSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABdWwSFECefw', '01.02.01.100.1230', '瓷嘴', 'MH-064', '支', 42, 42, 0, 0, 0, NULL, 42);
INSERT INTO `eas_wo_dtl` VALUES (2210, 136, 'gJYAABwKXw7tSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 26, 26, 0, 0, 0, NULL, 26);
INSERT INTO `eas_wo_dtl` VALUES (2211, 136, 'gJYAABwKXwjtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 503, 503, 0, 0, 0, 1, 503);
INSERT INTO `eas_wo_dtl` VALUES (2212, 136, 'gJYAABwKXw/tSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 5033, 5033, 0, 0, 0, 1, 5033);
INSERT INTO `eas_wo_dtl` VALUES (2213, 136, 'gJYAABwKXwntSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 21, 21, 0, 0, 0, 5, 21);
INSERT INTO `eas_wo_dtl` VALUES (2214, 136, 'gJYAABwKXxXtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 10063, 10063, 0, 0, 0, NULL, 10063);
INSERT INTO `eas_wo_dtl` VALUES (2215, 136, 'gJYAABwKXwftSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAAAyf/JdECefw', '01.02.13.040.3163', '纸箱', '35*35.5*20.5', '个', 13, 13, 0, 0, 0, NULL, 13);
INSERT INTO `eas_wo_dtl` VALUES (2216, 136, 'gJYAABwKXxbtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 138, 138, 0, 0, 0, NULL, 138);
INSERT INTO `eas_wo_dtl` VALUES (2217, 136, 'gJYAABwKXwztSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABnj9PZECefw', '02.03.20.002.1323', '平面支架', '2835E_H2572_60B10_B2A20', '千个', 2500, 2500, 0, 2315, 0, 3, 185);
INSERT INTO `eas_wo_dtl` VALUES (2218, 136, 'gJYAABwKXxPtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 138, 138, 0, 0, 0, NULL, 138);
INSERT INTO `eas_wo_dtl` VALUES (2219, 136, 'gJYAABwKXxLtSYg5', 'ByT1KNouRSyDLnXwteeciB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 10063, 10063, 0, 0, 0, NULL, 10063);
INSERT INTO `eas_wo_dtl` VALUES (2220, 137, 'gJYAABwKX9TtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABmkNCNECefw', '01.01.01.010.3543', 'DICE', 'DICE-BPA0F11C', '千个', 100000, 100000, 0, 99963, 0, 0, 37);
INSERT INTO `eas_wo_dtl` VALUES (2221, 137, 'gJYAABwKX9HtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAAAAFAAxECefw', '01.02.01.001.0055', '荧光粉', '阳光4号', '克', 29050, 29050, 0, 12147, 0, 2, 16904);
INSERT INTO `eas_wo_dtl` VALUES (2222, 137, 'gJYAABwKX9ntSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAAA/JIfpECefw', '01.02.01.001.1071', '荧光粉', 'MLS615', '克', 9930, 9930, 0, 0, 0, 2, 9930);
INSERT INTO `eas_wo_dtl` VALUES (2223, 137, 'gJYAABwKX9DtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABqzwahECefw', '01.02.01.006.0084', '银线', 'YF99-18um', '米', 158000, 158000, 0, 0, 0, NULL, 158000);
INSERT INTO `eas_wo_dtl` VALUES (2224, 137, 'gJYAABwKX9ftSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABnaR+RECefw', '01.02.01.100.1253', '瓷咀', 'MH-072', '支', 250, 250, 0, 72, 0, NULL, 178);
INSERT INTO `eas_wo_dtl` VALUES (2225, 137, 'gJYAABwKX9LtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABqxu7dECefw', '01.02.03.014.0211', '硅胶', 'MN-006A', '克', 13070, 13070, 0, 9474, 0, 1, 3596);
INSERT INTO `eas_wo_dtl` VALUES (2226, 137, 'gJYAABwKX93tSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABqxvCdECefw', '01.02.03.014.0212', '硅胶', 'MN-006B', '克', 130700, 130700, 0, 94740, 0, 1, 35960);
INSERT INTO `eas_wo_dtl` VALUES (2227, 137, 'gJYAABwKX9vtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 730, 730, 0, 0, 0, 5, 730);
INSERT INTO `eas_wo_dtl` VALUES (2228, 137, 'gJYAABwKX8/tSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABjJnXxECefw', '01.02.13.040.4965', '纸箱', '40.2*40.2*38（5层加硬）', '个', 120, 120, 0, 0, 0, NULL, 120);
INSERT INTO `eas_wo_dtl` VALUES (2229, 137, 'gJYAABwKX9XtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABndBcFECefw', '02.02.02.002.0042', '胶水', 'MS-043', '克', 300, 300, 0, 0, 0, NULL, 300);
INSERT INTO `eas_wo_dtl` VALUES (2230, 137, 'gJYAABwKX9rtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABmE5+5ECefw', '02.03.20.002.1310', '平面支架', '2835_F1975_10G_A4A22', '千个', 100000, 100000, 0, 61457, 0, 3, 38543);
INSERT INTO `eas_wo_dtl` VALUES (2231, 137, 'gJYAABwKX9jtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 3460, 3460, 0, 0, 0, NULL, 3460);
INSERT INTO `eas_wo_dtl` VALUES (2232, 137, 'gJYAABwKX9ztSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAAAId2XJECefw', '02.06.01.001.0010', '2835载带（浅杯）', '3.0*3.7*0.75', '米', 402500, 402500, 0, 0, 0, NULL, 402500);
INSERT INTO `eas_wo_dtl` VALUES (2233, 137, 'gJYAABwKX9btSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 402500, 402500, 0, 120750, 0, NULL, 281750);
INSERT INTO `eas_wo_dtl` VALUES (2234, 137, 'gJYAABwKX9PtSYg5', 'hB/lyJucR7WG4ySipFISah0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1160, 1160, 0, 231, 0, NULL, 929);
INSERT INTO `eas_wo_dtl` VALUES (2235, 138, 'gJYAABwK/FXtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABpy4Z5ECefw', '01.01.01.010.3647', 'DICE', 'DICE-CL-16A1WAF', '千个', 50, 50, 0, 35, 0, 0, 15);
INSERT INTO `eas_wo_dtl` VALUES (2236, 138, 'gJYAABwKYA7tSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAAAsj/VBECefw', '01.02.01.001.1042', '荧光粉', '阳光535-15', '克', 15, 15, 0, 0, 0, 2, 15);
INSERT INTO `eas_wo_dtl` VALUES (2237, 138, 'gJYAABwK/FTtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAAA+Zk5BECefw', '01.02.01.001.1070', '荧光粉', 'MLS631-02', '克', 1, 1, 0, 0, 0, 2, 1);
INSERT INTO `eas_wo_dtl` VALUES (2238, 138, 'gJYAABwK/FntSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABWXvNtECefw', '01.02.01.006.0077', '键合银丝', 'YA2M_0.75mil', '米', 80, 80, 0, 0, 0, NULL, 80);
INSERT INTO `eas_wo_dtl` VALUES (2239, 138, 'gJYAABwK/FLtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABF8F4ZECefw', '01.02.01.100.1077', '瓷嘴', 'MH-035', '支', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2240, 138, 'gJYAABwK/FPtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 10, 10, 0, 0, 0, 1, 10);
INSERT INTO `eas_wo_dtl` VALUES (2241, 138, 'gJYAABwK/FbtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 100, 100, 0, 0, 0, 1, 100);
INSERT INTO `eas_wo_dtl` VALUES (2242, 138, 'gJYAABwKYA/tSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 1, 1, 0, 0, 0, 5, 1);
INSERT INTO `eas_wo_dtl` VALUES (2243, 138, 'gJYAABwK/FHtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABudn0pECefw', '01.02.13.040.5600', '纸箱', '40.2*40.2*27（5层加硬）', '个', 0, 0, 0, 0, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2244, 138, 'gJYAABwK/FDtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABD6Qx9ECefw', '02.02.02.002.0016', '绝缘胶', '绝缘胶_MC-002', '克', 0, 0, 0, 49, 49, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2245, 138, 'gJYAABwK/FftSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABtgARNECefw', '02.03.20.002.1399', '平面支架', '2835Y_C2375_20_A13A22', '千个', 50, 50, 0, 0, 0, 3, 50);
INSERT INTO `eas_wo_dtl` VALUES (2246, 138, 'gJYAABwK/FztSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 2, 2, 0, 0, 0, NULL, 2);
INSERT INTO `eas_wo_dtl` VALUES (2247, 138, 'gJYAABwK/FjtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 201, 201, 0, 0, 0, NULL, 201);
INSERT INTO `eas_wo_dtl` VALUES (2248, 138, 'gJYAABwK/FvtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 201, 201, 0, 0, 0, NULL, 201);
INSERT INTO `eas_wo_dtl` VALUES (2249, 138, 'gJYAABwK/FrtSYg5', 'Hv1GuiRWRp6PempwQhtjdh0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2250, 139, 'gJYAABwK/z3tSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAABtyFrlECefw', '01.01.01.010.3808', 'DICE', 'DICE-Y0922C', '千个', 20560, 20560, 0, 16224, 0, 0, 4336);
INSERT INTO `eas_wo_dtl` VALUES (2251, 139, 'gJYAABwK/zztSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAAAiY50BECefw', '01.02.01.001.1039', '荧光粉', 'MLS628-02', '克', 156, 156, 0, 0, 0, 2, 156);
INSERT INTO `eas_wo_dtl` VALUES (2252, 139, 'gJYAABwK/zntSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAAAsj/VBECefw', '01.02.01.001.1042', '荧光粉', '阳光535-15', '克', 3451, 3451, 0, 0, 0, 2, 3451);
INSERT INTO `eas_wo_dtl` VALUES (2253, 139, 'gJYAABwK/z7tSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAAAlp3CdECefw', '01.02.01.006.0055', '银线', '高银线20*1000（MKE）', '米', 32896, 32896, 0, 23680, 0, NULL, 9216);
INSERT INTO `eas_wo_dtl` VALUES (2254, 139, 'gJYAABwK/zLtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAABF8F4ZECefw', '01.02.01.100.1077', '瓷嘴', 'MH-035', '支', 32, 32, 0, 31, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2255, 139, 'gJYAABwK/zbtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAAAuQnKxECefw', '01.02.03.010.1077', '胶水', 'WM-3321A', '克', 2181, 2181, 0, 0, 0, 1, 2181);
INSERT INTO `eas_wo_dtl` VALUES (2256, 139, 'gJYAABwK/zXtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAAAuQnshECefw', '01.02.03.010.1078', '胶水', 'WM-3321B', '克', 21814, 21814, 0, 0, 0, 1, 21814);
INSERT INTO `eas_wo_dtl` VALUES (2257, 139, 'gJYAABwK/0DtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 103, 103, 0, 0, 0, 5, 103);
INSERT INTO `eas_wo_dtl` VALUES (2258, 139, 'gJYAABwK/z/tSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAABudn0pECefw', '01.02.13.040.5600', '纸箱', '40.2*40.2*27（5层加硬）', '个', 20, 20, 0, 0, 0, NULL, 20);
INSERT INTO `eas_wo_dtl` VALUES (2259, 139, 'gJYAABwK/zPtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAABD6Qx9ECefw', '02.02.02.002.0016', '绝缘胶', '绝缘胶_MC-002', '克', 87, 87, 0, 49, 0, NULL, 39);
INSERT INTO `eas_wo_dtl` VALUES (2260, 139, 'gJYAABwK/zvtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAABskRR9ECefw', '02.03.20.002.1379', '平面支架', '2835E_C2372_50_B5A20', '千个', 10280, 10280, 0, 5430, 0, 3, 4850);
INSERT INTO `eas_wo_dtl` VALUES (2261, 139, 'gJYAABwK/zjtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAABNJj7ZECefw', '02.03.30.004.0023', '卷盘', '卷盘_15寸_8mm_143g_料车包装', '个', 425, 425, 0, 0, 0, NULL, 425);
INSERT INTO `eas_wo_dtl` VALUES (2262, 139, 'gJYAABwK/zrtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 41377, 41377, 0, 0, 0, NULL, 41377);
INSERT INTO `eas_wo_dtl` VALUES (2263, 139, 'gJYAABwK/zTtSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAABVgVJ1ECefw', '02.06.02.001.0002', '封带', 'MLS-002', '米', 41377, 41377, 0, 0, 0, NULL, 41377);
INSERT INTO `eas_wo_dtl` VALUES (2264, 139, 'gJYAABwK/zftSYg5', 'tdQiR2jzT1WkiW6J+lge2B0NgN0=', 'gJYAABYNthxECefw', '02.06.03.001.0001', '纯铝袋', '470*500*0.12C-自制铝箔袋', '个', 142, 142, 0, 0, 0, NULL, 142);
INSERT INTO `eas_wo_dtl` VALUES (2265, 140, 'gJYAABwK/6rtSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAABTLYpZECefw', '01.02.01.001.1217', '荧光粉', 'KSG-001', '克', 2598, 2598, 0, 0, 0, 2, 2598);
INSERT INTO `eas_wo_dtl` VALUES (2266, 140, 'gJYAABwK/67tSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAABTLYtdECefw', '01.02.01.001.1219', '荧光粉', 'KSR-002', '克', 428, 428, 0, 0, 0, 2, 428);
INSERT INTO `eas_wo_dtl` VALUES (2267, 140, 'gJYAABwK/6ftSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAAAlp26RECefw', '01.02.01.006.0056', '银线', '高银线23*1000（MKE）', '米', 6372, 6372, 0, 0, 0, NULL, 6372);
INSERT INTO `eas_wo_dtl` VALUES (2268, 140, 'gJYAABwK/6jtSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAAAAFAN5ECefw', '01.02.01.100.0017', '瓷嘴', 'SU-25190-435E25-ZF34-G1', '个', 31, 31, 0, 0, 0, NULL, 31);
INSERT INTO `eas_wo_dtl` VALUES (2269, 140, 'gJYAABwK/63tSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAAAAFAStECefw', '01.02.03.002.0003', '粘合剂', '白胶-KER3000M2', '克', 28, 28, 0, 0, 0, NULL, 28);
INSERT INTO `eas_wo_dtl` VALUES (2270, 140, 'gJYAABwK/6PtSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAABBF5z9ECefw', '01.02.03.014.0119', 'LED灌封胶', 'MN-003A', '克', 313, 313, 0, 0, 0, 1, 313);
INSERT INTO `eas_wo_dtl` VALUES (2271, 140, 'gJYAABwK/6ztSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAABBGHNZECefw', '01.02.03.014.0120', 'LED灌封胶', 'MN-003B', '克', 3132, 3132, 0, 0, 0, 1, 3132);
INSERT INTO `eas_wo_dtl` VALUES (2272, 140, 'gJYAABwK/6HtSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAAAmKcRVECefw', '01.02.10.015.0009', '抗沉淀粉', '抗沉淀粉WP-60m', '克', 18, 18, 0, 0, 0, 5, 18);
INSERT INTO `eas_wo_dtl` VALUES (2273, 140, 'gJYAABwK/6vtSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 6151, 6151, 0, 0, 0, NULL, 6151);
INSERT INTO `eas_wo_dtl` VALUES (2274, 140, 'gJYAABwK/6btSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (2275, 140, 'gJYAABwK/6TtSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 89, 89, 0, 0, 0, NULL, 89);
INSERT INTO `eas_wo_dtl` VALUES (2276, 140, 'gJYAABwK/6/tSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAABtXkmNECefw', '02.03.20.002.1397', '平面支架', '2835E_H2572_60B10_B7A20', '千个', 1528, 1528, 0, 0, 0, 3, 1528);
INSERT INTO `eas_wo_dtl` VALUES (2277, 140, 'gJYAABwK/6XtSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 89, 89, 0, 0, 0, NULL, 89);
INSERT INTO `eas_wo_dtl` VALUES (2278, 140, 'gJYAABwK/6ntSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 6151, 6151, 0, 0, 0, NULL, 6151);
INSERT INTO `eas_wo_dtl` VALUES (2279, 140, 'gJYAABwK/6LtSYg5', 'YFzWVjiNTKG9QmQpewJx3B0NgN0=', 'gJYAABctWWBECefw', '06.10.03.001.0084', 'DICE', 'S-DICE-BXCD12364', '千个', 4584, 4584, 0, 4584, 0, 0, 0);
INSERT INTO `eas_wo_dtl` VALUES (2280, 141, 'gJYAABwMhirtSYg5', '3fSZgjU4TPiUlesU3cUwmh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 5342, 5342, 0, 0, 0, NULL, 5342);
INSERT INTO `eas_wo_dtl` VALUES (2281, 141, 'gJYAABwMhijtSYg5', '3fSZgjU4TPiUlesU3cUwmh0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 5, 5, 0, 0, 0, NULL, 5);
INSERT INTO `eas_wo_dtl` VALUES (2282, 141, 'gJYAABwMhivtSYg5', '3fSZgjU4TPiUlesU3cUwmh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 53, 53, 0, 0, 0, NULL, 53);
INSERT INTO `eas_wo_dtl` VALUES (2283, 141, 'gJYAABwMhiftSYg5', '3fSZgjU4TPiUlesU3cUwmh0NgN0=', 'gJYAABSnueVECefw', '02.03.30.004.0028', '卷盘', '卷盘_7寸_8mm_44.44g_料车包装', '个', 263, 263, 0, 0, 0, NULL, 263);
INSERT INTO `eas_wo_dtl` VALUES (2284, 141, 'gJYAABwMhintSYg5', '3fSZgjU4TPiUlesU3cUwmh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 5342, 5342, 0, 0, 0, NULL, 5342);
INSERT INTO `eas_wo_dtl` VALUES (2285, 141, 'gJYAABwMhiztSYg5', '3fSZgjU4TPiUlesU3cUwmh0NgN0=', 'gJYAABgXJO1ECefw', '06.03.03.007.0373', '2835阳光色贴片', 'S-XEN-27H-31H-09-H15-C', '个', 1327216, 1327216, 1, 0, 0, NULL, 1327216);
INSERT INTO `eas_wo_dtl` VALUES (2286, 142, 'gJYAABwMu73tSYg5', 'e58WfT2vTPykhGsQtFDLUx0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 821, 821, 0, 0, 0, NULL, 821);
INSERT INTO `eas_wo_dtl` VALUES (2287, 142, 'gJYAABwMu7rtSYg5', 'e58WfT2vTPykhGsQtFDLUx0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2288, 142, 'gJYAABwMu7jtSYg5', 'e58WfT2vTPykhGsQtFDLUx0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (2289, 142, 'gJYAABwMu7ztSYg5', 'e58WfT2vTPykhGsQtFDLUx0NgN0=', 'gJYAABSnuNFECefw', '02.03.30.004.0029', '卷盘', '卷盘_13寸_8mm_94.94g_料车包装_扇形', '个', 12, 12, 0, 0, 0, NULL, 12);
INSERT INTO `eas_wo_dtl` VALUES (2290, 142, 'gJYAABwMu7ntSYg5', 'e58WfT2vTPykhGsQtFDLUx0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 821, 821, 0, 0, 0, NULL, 821);
INSERT INTO `eas_wo_dtl` VALUES (2291, 142, 'gJYAABwMu7vtSYg5', 'e58WfT2vTPykhGsQtFDLUx0NgN0=', 'gJYAABlG8GRECefw', '06.03.03.007.0409', '2835阳光色贴片', 'S-BEN-27G-21H-18-P58-5', '个', 204000, 204000, 1, 0, 0, NULL, 204000);
INSERT INTO `eas_wo_dtl` VALUES (2292, 143, 'gJYAABvaDM7tSYg5', 'jOEth8A2Q7OVJ3MZHb1lQh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 67289, 67289, 0, 0, 0, NULL, 67289);
INSERT INTO `eas_wo_dtl` VALUES (2293, 143, 'gJYAABvaDMztSYg5', 'jOEth8A2Q7OVJ3MZHb1lQh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 889, 889, 0, 0, 0, NULL, 889);
INSERT INTO `eas_wo_dtl` VALUES (2294, 143, 'gJYAABvaDM3tSYg5', 'jOEth8A2Q7OVJ3MZHb1lQh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 67289, 67289, 0, 0, 0, NULL, 67289);
INSERT INTO `eas_wo_dtl` VALUES (2295, 143, 'gJYAABvaDMvtSYg5', 'jOEth8A2Q7OVJ3MZHb1lQh0NgN0=', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', '个', 16717871, 16717871, 1, 16717871, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2296, 144, 'gJYAABvaDNXtSYg5', '2kNxAdlZQqaGCRwiw4LNXR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 42917, 42917, 0, 0, 0, NULL, 42917);
INSERT INTO `eas_wo_dtl` VALUES (2297, 144, 'gJYAABvaDNPtSYg5', '2kNxAdlZQqaGCRwiw4LNXR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 27, 27, 0, 0, 0, NULL, 27);
INSERT INTO `eas_wo_dtl` VALUES (2298, 144, 'gJYAABvaDNTtSYg5', '2kNxAdlZQqaGCRwiw4LNXR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 42917, 42917, 0, 0, 0, NULL, 42917);
INSERT INTO `eas_wo_dtl` VALUES (2299, 144, 'gJYAABvaDNLtSYg5', '2kNxAdlZQqaGCRwiw4LNXR0NgN0=', 'gJYAABelKqVECefw', '06.03.03.001.0906', '2835白色贴片', 'S-BEN-50G-31H-09-JE6-E', '个', 10662680, 10662680, 1, 10662680, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2300, 145, 'gJYAABvaDNztSYg5', 'QdA/2I1tSemxq8eOefpRNh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 24782, 24782, 0, 0, 0, NULL, 24782);
INSERT INTO `eas_wo_dtl` VALUES (2301, 145, 'gJYAABvaKCztSYg5', 'QdA/2I1tSemxq8eOefpRNh0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 241, 241, 0, 12, 0, NULL, 229);
INSERT INTO `eas_wo_dtl` VALUES (2302, 145, 'gJYAABvaDN3tSYg5', 'QdA/2I1tSemxq8eOefpRNh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 24782, 24782, 0, 0, 0, NULL, 24782);
INSERT INTO `eas_wo_dtl` VALUES (2303, 145, 'gJYAABvaDNvtSYg5', 'QdA/2I1tSemxq8eOefpRNh0NgN0=', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', '个', 6157010, 6157010, 1, 6157010, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2304, 146, 'gJYAABvcdxPtSYg5', 'NFASX5A8QlqgJdZMDSn1dR0NgN0=', 'gJYAABed8ShECefw', '06.03.03.001.0887', '2835白色贴片', 'S-BEN-40G-31H-09-JC1-0', '个', 15590, 15590, 1, 15590, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2305, 146, 'gJYAABvcdxDtSYg5', 'NFASX5A8QlqgJdZMDSn1dR0NgN0=', 'gJYAABelKc5ECefw', '06.03.03.001.0905', '2835白色贴片', 'S-BEN-40G-31H-09-JE6-E', '个', 32901, 32901, 1, 32901, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2306, 146, 'gJYAABvcdxTtSYg5', 'NFASX5A8QlqgJdZMDSn1dR0NgN0=', 'gJYAABexSNNECefw', '06.03.03.001.0960', '2835白色贴片', 'S-BEN-65G-31H-09-JCA-E', '个', 15340, 15340, 1, 15340, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2307, 146, 'gJYAABvcdxLtSYg5', 'NFASX5A8QlqgJdZMDSn1dR0NgN0=', 'gJYAABhu6ntECefw', '06.03.03.001.1013', '2835白色贴片', 'S-XEN-40G-31H-09-H06-C', '个', 48000, 48000, 1, 48000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2308, 146, 'gJYAABvcdxHtSYg5', 'NFASX5A8QlqgJdZMDSn1dR0NgN0=', 'gJYAABdBT6NECefw', '06.03.03.007.0154', '2835阳光色贴片', 'S-BEN-30G-31H-09-J76-4', '个', 46639, 46639, 1, 31639, 0, NULL, 15000);
INSERT INTO `eas_wo_dtl` VALUES (2309, 147, 'gJYAABvcuo3tSYg5', '4HzvXTvxSTGALe//UbQ51B0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1393, 1393, 0, 0, 0, NULL, 1393);
INSERT INTO `eas_wo_dtl` VALUES (2310, 147, 'gJYAABvcuovtSYg5', '4HzvXTvxSTGALe//UbQ51B0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2311, 147, 'gJYAABvcuortSYg5', '4HzvXTvxSTGALe//UbQ51B0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 14, 14, 0, 0, 0, NULL, 14);
INSERT INTO `eas_wo_dtl` VALUES (2312, 147, 'gJYAABvcuoztSYg5', '4HzvXTvxSTGALe//UbQ51B0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1393, 1393, 0, 0, 0, NULL, 1393);
INSERT INTO `eas_wo_dtl` VALUES (2313, 147, 'gJYAABvceG/tSYg5', '4HzvXTvxSTGALe//UbQ51B0NgN0=', 'gJYAABgXJO1ECefw', '06.03.03.007.0373', '2835阳光色贴片', 'S-XEN-27H-31H-09-H15-C', '个', 346148, 346148, 1, 346148, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2314, 148, 'gJYAABwAdlPtSYg5', 'J5tCuwKDRfOppSCreptiXh0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 8714, 8714, 0, 0, 0, NULL, 8714);
INSERT INTO `eas_wo_dtl` VALUES (2315, 148, 'gJYAABwAdlLtSYg5', 'J5tCuwKDRfOppSCreptiXh0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (2316, 148, 'gJYAABwAdlDtSYg5', 'J5tCuwKDRfOppSCreptiXh0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 126, 126, 0, 0, 0, NULL, 126);
INSERT INTO `eas_wo_dtl` VALUES (2317, 148, 'gJYAABwAdlHtSYg5', 'J5tCuwKDRfOppSCreptiXh0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 8714, 8714, 0, 0, 0, NULL, 8714);
INSERT INTO `eas_wo_dtl` VALUES (2318, 148, 'gJYAABveNTjtSYg5', 'J5tCuwKDRfOppSCreptiXh0NgN0=', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', '个', 2165000, 2165000, 1, 2165000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2319, 149, 'gJYAABwAdcPtSYg5', 'mh+E8X+yRaqbCvhUQYI2AR0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 1811, 1811, 0, 0, 0, NULL, 1811);
INSERT INTO `eas_wo_dtl` VALUES (2320, 149, 'gJYAABwAdcTtSYg5', 'mh+E8X+yRaqbCvhUQYI2AR0NgN0=', 'gJYAABuSwEhECefw', '01.02.13.040.5592', '纸箱', '35.5*35.5*28（五层加硬）', '个', 1, 1, 0, 0, 0, NULL, 1);
INSERT INTO `eas_wo_dtl` VALUES (2321, 149, 'gJYAABwAdcXtSYg5', 'mh+E8X+yRaqbCvhUQYI2AR0NgN0=', 'gJYAAAuQn09ECefw', '01.02.13.080.1100', '纯铝袋', '纯铝袋37*39*0.12', '个', 26, 26, 0, 0, 0, NULL, 26);
INSERT INTO `eas_wo_dtl` VALUES (2322, 149, 'gJYAABwAdcbtSYg5', 'mh+E8X+yRaqbCvhUQYI2AR0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 1811, 1811, 0, 0, 0, NULL, 1811);
INSERT INTO `eas_wo_dtl` VALUES (2323, 149, 'gJYAABveNT3tSYg5', 'mh+E8X+yRaqbCvhUQYI2AR0NgN0=', 'gJYAABelMYRECefw', '06.03.03.007.0300', '2835阳光色贴片', 'S-BEN-30G-31H-09-JE6-E', '个', 450000, 450000, 1, 450000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2324, 150, 'gJYAABwAVAvtSYg5', 'rT2vZ2XjQ5KDGYkCRMIWTB0NgN0=', 'gJYAAAAFCJFECefw', '01.02.13.010.0058', '封带', '封带MT-002', '米', 7225, 7225, 0, 0, 0, NULL, 7225);
INSERT INTO `eas_wo_dtl` VALUES (2325, 150, 'gJYAABwAVArtSYg5', 'rT2vZ2XjQ5KDGYkCRMIWTB0NgN0=', 'gJYAAAgmTbpECefw', '01.02.13.040.2878', '纸箱', '纸箱475*295*308mm粘胶', '个', 7, 7, 0, 0, 0, NULL, 7);
INSERT INTO `eas_wo_dtl` VALUES (2326, 150, 'gJYAABwAVA3tSYg5', 'rT2vZ2XjQ5KDGYkCRMIWTB0NgN0=', 'gJYAAAY7kCpECefw', '01.02.13.080.1063', '纯铝袋', '纯铝袋280*300*0.15', '个', 70, 70, 0, 0, 0, NULL, 70);
INSERT INTO `eas_wo_dtl` VALUES (2327, 150, 'gJYAABwAVAztSYg5', 'rT2vZ2XjQ5KDGYkCRMIWTB0NgN0=', 'gJYAAAmkEVRECefw', '02.06.01.001.0018', '2835PCT载带', '3.1*3.7*0.85', '米', 7225, 7225, 0, 0, 0, NULL, 7225);
INSERT INTO `eas_wo_dtl` VALUES (2328, 150, 'gJYAABwAVAntSYg5', 'rT2vZ2XjQ5KDGYkCRMIWTB0NgN0=', 'gJYAABdADKNECefw', '06.03.03.001.0562', '2835白色贴片', 'S-BEN-40E-31H-09-J21-1', '个', 1795000, 1795000, 1, 1795000, 0, NULL, 0);
INSERT INTO `eas_wo_dtl` VALUES (2329, 151, 'gJYAABwKSjLtSYg5', '9MRA1TBtQ5yFyONJ61BbxB0NgN0=', 'gJYAABdBVtpECefw', '06.03.03.007.0151', '2835阳光色贴片', 'S-BEN-30G-31H-09-J21-1', '个', 135519, 135519, 1, 0, 0, NULL, 135519);
INSERT INTO `eas_wo_dtl` VALUES (2330, 151, 'gJYAABwKSjHtSYg5', '9MRA1TBtQ5yFyONJ61BbxB0NgN0=', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', '个', 88125, 88125, 1, 0, 0, NULL, 88125);
INSERT INTO `eas_wo_dtl` VALUES (2331, 151, 'gJYAABwKSjTtSYg5', '9MRA1TBtQ5yFyONJ61BbxB0NgN0=', 'gJYAABi8Xc9ECefw', '06.03.03.007.0396', '2835阳光色贴片', 'S-BEN-30E-31H-09-JG7-4', '个', 80199, 80199, 1, 0, 0, NULL, 80199);
INSERT INTO `eas_wo_dtl` VALUES (2332, 151, 'gJYAABwKSjPtSYg5', '9MRA1TBtQ5yFyONJ61BbxB0NgN0=', 'gJYAABi8Xc9ECefw', '06.03.03.007.0396', '2835阳光色贴片', 'S-BEN-30E-31H-09-JG7-4', '个', 59038, 59038, 1, 0, 0, NULL, 59038);
INSERT INTO `eas_wo_dtl` VALUES (2333, 152, 'gJYAABwNMcDtSYg5', 'FkzdcQD8Rv+zlhpHOAZ1/B0NgN0=', 'gJYAABeZChVECefw', '06.03.03.007.0284', '2835阳光色贴片', 'S-BEN-35E-12M-03-F4C-7', '个', 9140000, 9140000, 1, 0, 0, NULL, 9140000);
INSERT INTO `eas_wo_dtl` VALUES (2334, 153, 'gJYAABwNMevtSYg5', 'DEpyNHJNQya11xAsGOal0h0NgN0=', 'gJYAABelNKNECefw', '06.03.03.007.0299', '2835阳光色贴片', 'S-BEN-27G-31H-09-JE6-E', '个', 1108392, 1108392, 1, 0, 0, NULL, 1108392);

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_bom
-- ----------------------------
INSERT INTO `t_bom` VALUES (1, 1, '组合1', 26, 2, NULL, 1, '2020-06-18 11:52:55', 0, 0, 0, NULL, 1);
INSERT INTO `t_bom` VALUES (2, 1, '组合2', 26, 2, NULL, 1, '2020-06-18 11:54:02', 0, 0, 0, NULL, 1);
INSERT INTO `t_bom` VALUES (3, 1, '组合3', 26, 2, NULL, 1, '2020-06-18 11:55:24', 0, 0, 0, NULL, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom与荧光粉对应关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_bom_Phosphor
-- ----------------------------
INSERT INTO `t_bom_Phosphor` VALUES (1, 1, 3);
INSERT INTO `t_bom_Phosphor` VALUES (2, 1, 12);
INSERT INTO `t_bom_Phosphor` VALUES (3, 1, 13);
INSERT INTO `t_bom_Phosphor` VALUES (4, 2, 4);
INSERT INTO `t_bom_Phosphor` VALUES (5, 2, 20);
INSERT INTO `t_bom_Phosphor` VALUES (6, 2, 13);
INSERT INTO `t_bom_Phosphor` VALUES (7, 3, 20);
INSERT INTO `t_bom_Phosphor` VALUES (8, 3, 13);
INSERT INTO `t_bom_Phosphor` VALUES (9, 3, 9);

-- ----------------------------
-- Table structure for t_bom_chip
-- ----------------------------
DROP TABLE IF EXISTS `t_bom_chip`;
CREATE TABLE `t_bom_chip`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bom_id` bigint(20) NOT NULL COMMENT 'bom_id',
  `chip_id` bigint(20) NOT NULL COMMENT '芯片id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'bom与芯片关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_bom_chip
-- ----------------------------
INSERT INTO `t_bom_chip` VALUES (1, 1, 3);
INSERT INTO `t_bom_chip` VALUES (2, 2, 3);
INSERT INTO `t_bom_chip` VALUES (3, 3, 3);

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
) ENGINE = InnoDB AUTO_INCREMENT = 108 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统菜单表' ROW_FORMAT = Dynamic;

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
INSERT INTO `t_privilege` VALUES (74, '工程打样管理', 1, 'productionProofManage', '', 0);
INSERT INTO `t_privilege` VALUES (75, '发起工程打样', 74, 'initiateProjectProofing', '', 1);
INSERT INTO `t_privilege` VALUES (76, '查看打样详情', 74, 'checkProofingDetails', '', 1);
INSERT INTO `t_privilege` VALUES (77, '查看打样记录', 74, 'checkTheProofingRecords', '', 1);
INSERT INTO `t_privilege` VALUES (78, '关闭打样', 74, 'closeTheProofing', '', 1);
INSERT INTO `t_privilege` VALUES (79, '打样详情', 74, 'productionProofManageInfo', '', 0);
INSERT INTO `t_privilege` VALUES (80, '开始打样', 79, 'startProofing', '', 1);
INSERT INTO `t_privilege` VALUES (81, '打样通过', 79, 'pullThrough', '', 1);
INSERT INTO `t_privilege` VALUES (82, '修改配方', 79, 'modifiedFormula', '', 1);
INSERT INTO `t_privilege` VALUES (83, '修改配比', 79, 'modifyTheProportion', '', 1);
INSERT INTO `t_privilege` VALUES (84, '在制设备管理', 79, 'in__ProcessEquipmentManagement', '', 1);
INSERT INTO `t_privilege` VALUES (85, '修改胶量', 79, 'modifiedResin', '', 1);
INSERT INTO `t_privilege` VALUES (86, '上传测试结果', 79, 'uploadTestResults', '', 1);
INSERT INTO `t_privilege` VALUES (87, '取消NG判定', 79, 'cancelThe_NGDecision', '', 1);
INSERT INTO `t_privilege` VALUES (88, '测试结果判定', 79, 'testResultDetermination', '', 1);
INSERT INTO `t_privilege` VALUES (89, '打样记录', 74, 'productionProofManageLog', '', 0);
INSERT INTO `t_privilege` VALUES (90, '生产统计分析', 0, 'analysisInfo', '', 0);
INSERT INTO `t_privilege` VALUES (91, '生产工单检索', 90, 'analysisManage', '', 0);
INSERT INTO `t_privilege` VALUES (92, '查看', 91, 'check', '', 1);
INSERT INTO `t_privilege` VALUES (93, '生产记录', 91, 'analysisManageLog', '', 0);
INSERT INTO `t_privilege` VALUES (94, '工程打样检索', 90, 'analysisProofManage', '', 0);
INSERT INTO `t_privilege` VALUES (95, '查看', 94, 'check', '', 1);
INSERT INTO `t_privilege` VALUES (96, '同步', 94, 'synchronization', '', 1);
INSERT INTO `t_privilege` VALUES (97, '打样详情', 94, 'analysisProofManageLog', '', 0);
INSERT INTO `t_privilege` VALUES (98, '工程打样管理', 6, 'testProof', '', 0);
INSERT INTO `t_privilege` VALUES (99, '查看打样详情', 98, 'checkProofingDetails', '', 1);
INSERT INTO `t_privilege` VALUES (100, '查看打样记录', 98, 'checkTheProofingRecords', '', 1);
INSERT INTO `t_privilege` VALUES (101, '打样详情', 98, 'testProofInfo', '', 0);
INSERT INTO `t_privilege` VALUES (102, '上传测试结果', 101, 'uploadTestResults', '', 1);
INSERT INTO `t_privilege` VALUES (103, '取消NG判定', 101, 'cancelThe_NGDecision', '', 1);
INSERT INTO `t_privilege` VALUES (104, '测试结果判定', 101, 'testResultDetermination', '', 1);
INSERT INTO `t_privilege` VALUES (105, '打样通过', 101, 'pullThrough', '', 1);
INSERT INTO `t_privilege` VALUES (106, '试样通过', 8, 'theSampleBy', '', 1);
INSERT INTO `t_privilege` VALUES (107, '打样记录', 98, 'testProofLog', '', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 542 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_role_privilege
-- ----------------------------
INSERT INTO `t_role_privilege` VALUES (50, 3, 1);
INSERT INTO `t_role_privilege` VALUES (51, 3, 2);
INSERT INTO `t_role_privilege` VALUES (52, 3, 3);
INSERT INTO `t_role_privilege` VALUES (53, 3, 4);
INSERT INTO `t_role_privilege` VALUES (54, 3, 5);
INSERT INTO `t_role_privilege` VALUES (55, 3, 6);
INSERT INTO `t_role_privilege` VALUES (56, 3, 7);
INSERT INTO `t_role_privilege` VALUES (57, 3, 8);
INSERT INTO `t_role_privilege` VALUES (58, 3, 9);
INSERT INTO `t_role_privilege` VALUES (59, 3, 27);
INSERT INTO `t_role_privilege` VALUES (60, 3, 28);
INSERT INTO `t_role_privilege` VALUES (61, 3, 33);
INSERT INTO `t_role_privilege` VALUES (62, 3, 68);
INSERT INTO `t_role_privilege` VALUES (63, 4, 1);
INSERT INTO `t_role_privilege` VALUES (64, 4, 2);
INSERT INTO `t_role_privilege` VALUES (65, 4, 3);
INSERT INTO `t_role_privilege` VALUES (66, 4, 4);
INSERT INTO `t_role_privilege` VALUES (67, 4, 5);
INSERT INTO `t_role_privilege` VALUES (68, 4, 6);
INSERT INTO `t_role_privilege` VALUES (69, 4, 7);
INSERT INTO `t_role_privilege` VALUES (70, 4, 8);
INSERT INTO `t_role_privilege` VALUES (71, 4, 9);
INSERT INTO `t_role_privilege` VALUES (72, 4, 10);
INSERT INTO `t_role_privilege` VALUES (73, 4, 11);
INSERT INTO `t_role_privilege` VALUES (74, 4, 12);
INSERT INTO `t_role_privilege` VALUES (75, 4, 13);
INSERT INTO `t_role_privilege` VALUES (76, 4, 14);
INSERT INTO `t_role_privilege` VALUES (77, 4, 15);
INSERT INTO `t_role_privilege` VALUES (78, 4, 16);
INSERT INTO `t_role_privilege` VALUES (79, 4, 17);
INSERT INTO `t_role_privilege` VALUES (80, 4, 27);
INSERT INTO `t_role_privilege` VALUES (81, 4, 28);
INSERT INTO `t_role_privilege` VALUES (82, 4, 34);
INSERT INTO `t_role_privilege` VALUES (83, 4, 35);
INSERT INTO `t_role_privilege` VALUES (84, 4, 36);
INSERT INTO `t_role_privilege` VALUES (85, 4, 37);
INSERT INTO `t_role_privilege` VALUES (86, 4, 38);
INSERT INTO `t_role_privilege` VALUES (87, 4, 50);
INSERT INTO `t_role_privilege` VALUES (88, 4, 68);
INSERT INTO `t_role_privilege` VALUES (89, 5, 1);
INSERT INTO `t_role_privilege` VALUES (90, 5, 2);
INSERT INTO `t_role_privilege` VALUES (91, 5, 3);
INSERT INTO `t_role_privilege` VALUES (92, 5, 4);
INSERT INTO `t_role_privilege` VALUES (93, 5, 5);
INSERT INTO `t_role_privilege` VALUES (94, 5, 6);
INSERT INTO `t_role_privilege` VALUES (95, 5, 7);
INSERT INTO `t_role_privilege` VALUES (96, 5, 8);
INSERT INTO `t_role_privilege` VALUES (97, 5, 9);
INSERT INTO `t_role_privilege` VALUES (98, 5, 10);
INSERT INTO `t_role_privilege` VALUES (99, 5, 11);
INSERT INTO `t_role_privilege` VALUES (100, 5, 12);
INSERT INTO `t_role_privilege` VALUES (101, 5, 13);
INSERT INTO `t_role_privilege` VALUES (102, 5, 14);
INSERT INTO `t_role_privilege` VALUES (103, 5, 15);
INSERT INTO `t_role_privilege` VALUES (104, 5, 16);
INSERT INTO `t_role_privilege` VALUES (105, 5, 17);
INSERT INTO `t_role_privilege` VALUES (106, 5, 18);
INSERT INTO `t_role_privilege` VALUES (107, 5, 19);
INSERT INTO `t_role_privilege` VALUES (108, 5, 20);
INSERT INTO `t_role_privilege` VALUES (109, 5, 21);
INSERT INTO `t_role_privilege` VALUES (110, 5, 22);
INSERT INTO `t_role_privilege` VALUES (111, 5, 23);
INSERT INTO `t_role_privilege` VALUES (112, 5, 24);
INSERT INTO `t_role_privilege` VALUES (113, 5, 25);
INSERT INTO `t_role_privilege` VALUES (114, 5, 26);
INSERT INTO `t_role_privilege` VALUES (115, 5, 27);
INSERT INTO `t_role_privilege` VALUES (116, 5, 28);
INSERT INTO `t_role_privilege` VALUES (117, 5, 29);
INSERT INTO `t_role_privilege` VALUES (118, 5, 30);
INSERT INTO `t_role_privilege` VALUES (119, 5, 31);
INSERT INTO `t_role_privilege` VALUES (120, 5, 32);
INSERT INTO `t_role_privilege` VALUES (121, 5, 33);
INSERT INTO `t_role_privilege` VALUES (122, 5, 34);
INSERT INTO `t_role_privilege` VALUES (123, 5, 35);
INSERT INTO `t_role_privilege` VALUES (124, 5, 36);
INSERT INTO `t_role_privilege` VALUES (125, 5, 37);
INSERT INTO `t_role_privilege` VALUES (126, 5, 38);
INSERT INTO `t_role_privilege` VALUES (127, 5, 39);
INSERT INTO `t_role_privilege` VALUES (128, 5, 40);
INSERT INTO `t_role_privilege` VALUES (129, 5, 41);
INSERT INTO `t_role_privilege` VALUES (130, 5, 42);
INSERT INTO `t_role_privilege` VALUES (131, 5, 43);
INSERT INTO `t_role_privilege` VALUES (132, 5, 44);
INSERT INTO `t_role_privilege` VALUES (133, 5, 45);
INSERT INTO `t_role_privilege` VALUES (134, 5, 46);
INSERT INTO `t_role_privilege` VALUES (135, 5, 47);
INSERT INTO `t_role_privilege` VALUES (136, 5, 48);
INSERT INTO `t_role_privilege` VALUES (137, 5, 49);
INSERT INTO `t_role_privilege` VALUES (138, 5, 50);
INSERT INTO `t_role_privilege` VALUES (139, 5, 51);
INSERT INTO `t_role_privilege` VALUES (140, 5, 52);
INSERT INTO `t_role_privilege` VALUES (141, 5, 53);
INSERT INTO `t_role_privilege` VALUES (142, 5, 54);
INSERT INTO `t_role_privilege` VALUES (143, 5, 55);
INSERT INTO `t_role_privilege` VALUES (144, 5, 56);
INSERT INTO `t_role_privilege` VALUES (145, 5, 57);
INSERT INTO `t_role_privilege` VALUES (146, 5, 58);
INSERT INTO `t_role_privilege` VALUES (147, 5, 59);
INSERT INTO `t_role_privilege` VALUES (148, 5, 60);
INSERT INTO `t_role_privilege` VALUES (149, 5, 61);
INSERT INTO `t_role_privilege` VALUES (150, 5, 62);
INSERT INTO `t_role_privilege` VALUES (151, 5, 63);
INSERT INTO `t_role_privilege` VALUES (152, 5, 64);
INSERT INTO `t_role_privilege` VALUES (153, 5, 65);
INSERT INTO `t_role_privilege` VALUES (154, 5, 66);
INSERT INTO `t_role_privilege` VALUES (155, 5, 67);
INSERT INTO `t_role_privilege` VALUES (156, 5, 68);
INSERT INTO `t_role_privilege` VALUES (157, 6, 1);
INSERT INTO `t_role_privilege` VALUES (158, 6, 2);
INSERT INTO `t_role_privilege` VALUES (159, 6, 3);
INSERT INTO `t_role_privilege` VALUES (160, 6, 4);
INSERT INTO `t_role_privilege` VALUES (161, 6, 5);
INSERT INTO `t_role_privilege` VALUES (162, 6, 6);
INSERT INTO `t_role_privilege` VALUES (163, 6, 7);
INSERT INTO `t_role_privilege` VALUES (164, 6, 8);
INSERT INTO `t_role_privilege` VALUES (165, 6, 9);
INSERT INTO `t_role_privilege` VALUES (166, 6, 10);
INSERT INTO `t_role_privilege` VALUES (167, 6, 11);
INSERT INTO `t_role_privilege` VALUES (168, 6, 12);
INSERT INTO `t_role_privilege` VALUES (169, 6, 13);
INSERT INTO `t_role_privilege` VALUES (170, 6, 14);
INSERT INTO `t_role_privilege` VALUES (171, 6, 15);
INSERT INTO `t_role_privilege` VALUES (172, 6, 16);
INSERT INTO `t_role_privilege` VALUES (173, 6, 17);
INSERT INTO `t_role_privilege` VALUES (174, 6, 24);
INSERT INTO `t_role_privilege` VALUES (175, 6, 25);
INSERT INTO `t_role_privilege` VALUES (176, 6, 26);
INSERT INTO `t_role_privilege` VALUES (177, 6, 27);
INSERT INTO `t_role_privilege` VALUES (178, 6, 28);
INSERT INTO `t_role_privilege` VALUES (179, 6, 29);
INSERT INTO `t_role_privilege` VALUES (180, 6, 30);
INSERT INTO `t_role_privilege` VALUES (181, 6, 31);
INSERT INTO `t_role_privilege` VALUES (182, 6, 32);
INSERT INTO `t_role_privilege` VALUES (183, 6, 33);
INSERT INTO `t_role_privilege` VALUES (184, 6, 34);
INSERT INTO `t_role_privilege` VALUES (185, 6, 35);
INSERT INTO `t_role_privilege` VALUES (186, 6, 36);
INSERT INTO `t_role_privilege` VALUES (187, 6, 37);
INSERT INTO `t_role_privilege` VALUES (188, 6, 38);
INSERT INTO `t_role_privilege` VALUES (189, 6, 39);
INSERT INTO `t_role_privilege` VALUES (190, 6, 40);
INSERT INTO `t_role_privilege` VALUES (191, 6, 41);
INSERT INTO `t_role_privilege` VALUES (192, 6, 42);
INSERT INTO `t_role_privilege` VALUES (193, 6, 43);
INSERT INTO `t_role_privilege` VALUES (194, 6, 44);
INSERT INTO `t_role_privilege` VALUES (195, 6, 45);
INSERT INTO `t_role_privilege` VALUES (196, 6, 46);
INSERT INTO `t_role_privilege` VALUES (197, 6, 47);
INSERT INTO `t_role_privilege` VALUES (198, 6, 48);
INSERT INTO `t_role_privilege` VALUES (199, 6, 49);
INSERT INTO `t_role_privilege` VALUES (200, 6, 50);
INSERT INTO `t_role_privilege` VALUES (201, 6, 51);
INSERT INTO `t_role_privilege` VALUES (202, 6, 52);
INSERT INTO `t_role_privilege` VALUES (203, 6, 53);
INSERT INTO `t_role_privilege` VALUES (204, 6, 67);
INSERT INTO `t_role_privilege` VALUES (205, 6, 68);
INSERT INTO `t_role_privilege` VALUES (206, 7, 1);
INSERT INTO `t_role_privilege` VALUES (207, 7, 2);
INSERT INTO `t_role_privilege` VALUES (208, 7, 3);
INSERT INTO `t_role_privilege` VALUES (209, 7, 4);
INSERT INTO `t_role_privilege` VALUES (210, 7, 5);
INSERT INTO `t_role_privilege` VALUES (211, 7, 6);
INSERT INTO `t_role_privilege` VALUES (212, 7, 7);
INSERT INTO `t_role_privilege` VALUES (213, 7, 8);
INSERT INTO `t_role_privilege` VALUES (214, 7, 9);
INSERT INTO `t_role_privilege` VALUES (215, 7, 10);
INSERT INTO `t_role_privilege` VALUES (216, 7, 11);
INSERT INTO `t_role_privilege` VALUES (217, 7, 12);
INSERT INTO `t_role_privilege` VALUES (218, 7, 13);
INSERT INTO `t_role_privilege` VALUES (219, 7, 14);
INSERT INTO `t_role_privilege` VALUES (220, 7, 15);
INSERT INTO `t_role_privilege` VALUES (221, 7, 16);
INSERT INTO `t_role_privilege` VALUES (222, 7, 17);
INSERT INTO `t_role_privilege` VALUES (223, 7, 24);
INSERT INTO `t_role_privilege` VALUES (224, 7, 25);
INSERT INTO `t_role_privilege` VALUES (225, 7, 26);
INSERT INTO `t_role_privilege` VALUES (226, 7, 27);
INSERT INTO `t_role_privilege` VALUES (227, 7, 28);
INSERT INTO `t_role_privilege` VALUES (228, 7, 29);
INSERT INTO `t_role_privilege` VALUES (229, 7, 30);
INSERT INTO `t_role_privilege` VALUES (230, 7, 31);
INSERT INTO `t_role_privilege` VALUES (231, 7, 32);
INSERT INTO `t_role_privilege` VALUES (232, 7, 33);
INSERT INTO `t_role_privilege` VALUES (233, 7, 34);
INSERT INTO `t_role_privilege` VALUES (234, 7, 35);
INSERT INTO `t_role_privilege` VALUES (235, 7, 36);
INSERT INTO `t_role_privilege` VALUES (236, 7, 37);
INSERT INTO `t_role_privilege` VALUES (237, 7, 38);
INSERT INTO `t_role_privilege` VALUES (238, 7, 39);
INSERT INTO `t_role_privilege` VALUES (239, 7, 40);
INSERT INTO `t_role_privilege` VALUES (240, 7, 41);
INSERT INTO `t_role_privilege` VALUES (241, 7, 42);
INSERT INTO `t_role_privilege` VALUES (242, 7, 43);
INSERT INTO `t_role_privilege` VALUES (243, 7, 44);
INSERT INTO `t_role_privilege` VALUES (244, 7, 45);
INSERT INTO `t_role_privilege` VALUES (245, 7, 46);
INSERT INTO `t_role_privilege` VALUES (246, 7, 47);
INSERT INTO `t_role_privilege` VALUES (247, 7, 48);
INSERT INTO `t_role_privilege` VALUES (248, 7, 49);
INSERT INTO `t_role_privilege` VALUES (249, 7, 50);
INSERT INTO `t_role_privilege` VALUES (250, 7, 51);
INSERT INTO `t_role_privilege` VALUES (251, 7, 52);
INSERT INTO `t_role_privilege` VALUES (252, 7, 53);
INSERT INTO `t_role_privilege` VALUES (253, 7, 67);
INSERT INTO `t_role_privilege` VALUES (254, 7, 68);
INSERT INTO `t_role_privilege` VALUES (328, 1, 1);
INSERT INTO `t_role_privilege` VALUES (329, 1, 2);
INSERT INTO `t_role_privilege` VALUES (330, 1, 3);
INSERT INTO `t_role_privilege` VALUES (331, 1, 4);
INSERT INTO `t_role_privilege` VALUES (332, 1, 5);
INSERT INTO `t_role_privilege` VALUES (333, 1, 6);
INSERT INTO `t_role_privilege` VALUES (334, 1, 7);
INSERT INTO `t_role_privilege` VALUES (335, 1, 8);
INSERT INTO `t_role_privilege` VALUES (336, 1, 9);
INSERT INTO `t_role_privilege` VALUES (337, 1, 10);
INSERT INTO `t_role_privilege` VALUES (338, 1, 11);
INSERT INTO `t_role_privilege` VALUES (339, 1, 12);
INSERT INTO `t_role_privilege` VALUES (340, 1, 13);
INSERT INTO `t_role_privilege` VALUES (341, 1, 14);
INSERT INTO `t_role_privilege` VALUES (342, 1, 15);
INSERT INTO `t_role_privilege` VALUES (343, 1, 16);
INSERT INTO `t_role_privilege` VALUES (344, 1, 17);
INSERT INTO `t_role_privilege` VALUES (345, 1, 18);
INSERT INTO `t_role_privilege` VALUES (346, 1, 19);
INSERT INTO `t_role_privilege` VALUES (347, 1, 20);
INSERT INTO `t_role_privilege` VALUES (348, 1, 21);
INSERT INTO `t_role_privilege` VALUES (349, 1, 22);
INSERT INTO `t_role_privilege` VALUES (350, 1, 23);
INSERT INTO `t_role_privilege` VALUES (351, 1, 74);
INSERT INTO `t_role_privilege` VALUES (352, 1, 79);
INSERT INTO `t_role_privilege` VALUES (353, 1, 89);
INSERT INTO `t_role_privilege` VALUES (354, 1, 90);
INSERT INTO `t_role_privilege` VALUES (355, 1, 91);
INSERT INTO `t_role_privilege` VALUES (356, 1, 93);
INSERT INTO `t_role_privilege` VALUES (357, 1, 94);
INSERT INTO `t_role_privilege` VALUES (358, 1, 97);
INSERT INTO `t_role_privilege` VALUES (359, 1, 98);
INSERT INTO `t_role_privilege` VALUES (360, 1, 101);
INSERT INTO `t_role_privilege` VALUES (361, 1, 107);
INSERT INTO `t_role_privilege` VALUES (362, 1, 24);
INSERT INTO `t_role_privilege` VALUES (363, 1, 25);
INSERT INTO `t_role_privilege` VALUES (364, 1, 26);
INSERT INTO `t_role_privilege` VALUES (365, 1, 27);
INSERT INTO `t_role_privilege` VALUES (366, 1, 28);
INSERT INTO `t_role_privilege` VALUES (367, 1, 29);
INSERT INTO `t_role_privilege` VALUES (368, 1, 30);
INSERT INTO `t_role_privilege` VALUES (369, 1, 31);
INSERT INTO `t_role_privilege` VALUES (370, 1, 32);
INSERT INTO `t_role_privilege` VALUES (371, 1, 33);
INSERT INTO `t_role_privilege` VALUES (372, 1, 34);
INSERT INTO `t_role_privilege` VALUES (373, 1, 35);
INSERT INTO `t_role_privilege` VALUES (374, 1, 36);
INSERT INTO `t_role_privilege` VALUES (375, 1, 37);
INSERT INTO `t_role_privilege` VALUES (376, 1, 38);
INSERT INTO `t_role_privilege` VALUES (377, 1, 39);
INSERT INTO `t_role_privilege` VALUES (378, 1, 40);
INSERT INTO `t_role_privilege` VALUES (379, 1, 41);
INSERT INTO `t_role_privilege` VALUES (380, 1, 42);
INSERT INTO `t_role_privilege` VALUES (381, 1, 43);
INSERT INTO `t_role_privilege` VALUES (382, 1, 44);
INSERT INTO `t_role_privilege` VALUES (383, 1, 45);
INSERT INTO `t_role_privilege` VALUES (384, 1, 46);
INSERT INTO `t_role_privilege` VALUES (385, 1, 47);
INSERT INTO `t_role_privilege` VALUES (386, 1, 48);
INSERT INTO `t_role_privilege` VALUES (387, 1, 49);
INSERT INTO `t_role_privilege` VALUES (388, 1, 50);
INSERT INTO `t_role_privilege` VALUES (389, 1, 51);
INSERT INTO `t_role_privilege` VALUES (390, 1, 52);
INSERT INTO `t_role_privilege` VALUES (391, 1, 53);
INSERT INTO `t_role_privilege` VALUES (392, 1, 54);
INSERT INTO `t_role_privilege` VALUES (393, 1, 55);
INSERT INTO `t_role_privilege` VALUES (394, 1, 56);
INSERT INTO `t_role_privilege` VALUES (395, 1, 57);
INSERT INTO `t_role_privilege` VALUES (396, 1, 58);
INSERT INTO `t_role_privilege` VALUES (397, 1, 59);
INSERT INTO `t_role_privilege` VALUES (398, 1, 60);
INSERT INTO `t_role_privilege` VALUES (399, 1, 61);
INSERT INTO `t_role_privilege` VALUES (400, 1, 62);
INSERT INTO `t_role_privilege` VALUES (401, 1, 63);
INSERT INTO `t_role_privilege` VALUES (402, 1, 64);
INSERT INTO `t_role_privilege` VALUES (403, 1, 65);
INSERT INTO `t_role_privilege` VALUES (404, 1, 66);
INSERT INTO `t_role_privilege` VALUES (405, 1, 67);
INSERT INTO `t_role_privilege` VALUES (406, 1, 68);
INSERT INTO `t_role_privilege` VALUES (407, 1, 69);
INSERT INTO `t_role_privilege` VALUES (408, 1, 70);
INSERT INTO `t_role_privilege` VALUES (409, 1, 71);
INSERT INTO `t_role_privilege` VALUES (410, 1, 72);
INSERT INTO `t_role_privilege` VALUES (411, 1, 73);
INSERT INTO `t_role_privilege` VALUES (412, 1, 75);
INSERT INTO `t_role_privilege` VALUES (413, 1, 76);
INSERT INTO `t_role_privilege` VALUES (414, 1, 77);
INSERT INTO `t_role_privilege` VALUES (415, 1, 78);
INSERT INTO `t_role_privilege` VALUES (416, 1, 80);
INSERT INTO `t_role_privilege` VALUES (417, 1, 81);
INSERT INTO `t_role_privilege` VALUES (418, 1, 82);
INSERT INTO `t_role_privilege` VALUES (419, 1, 83);
INSERT INTO `t_role_privilege` VALUES (420, 1, 84);
INSERT INTO `t_role_privilege` VALUES (421, 1, 85);
INSERT INTO `t_role_privilege` VALUES (422, 1, 86);
INSERT INTO `t_role_privilege` VALUES (423, 1, 87);
INSERT INTO `t_role_privilege` VALUES (424, 1, 88);
INSERT INTO `t_role_privilege` VALUES (425, 1, 92);
INSERT INTO `t_role_privilege` VALUES (426, 1, 95);
INSERT INTO `t_role_privilege` VALUES (427, 1, 96);
INSERT INTO `t_role_privilege` VALUES (428, 1, 99);
INSERT INTO `t_role_privilege` VALUES (429, 1, 100);
INSERT INTO `t_role_privilege` VALUES (430, 1, 102);
INSERT INTO `t_role_privilege` VALUES (431, 1, 103);
INSERT INTO `t_role_privilege` VALUES (432, 1, 104);
INSERT INTO `t_role_privilege` VALUES (433, 1, 105);
INSERT INTO `t_role_privilege` VALUES (434, 1, 106);
INSERT INTO `t_role_privilege` VALUES (435, 2, 1);
INSERT INTO `t_role_privilege` VALUES (436, 2, 2);
INSERT INTO `t_role_privilege` VALUES (437, 2, 3);
INSERT INTO `t_role_privilege` VALUES (438, 2, 4);
INSERT INTO `t_role_privilege` VALUES (439, 2, 5);
INSERT INTO `t_role_privilege` VALUES (440, 2, 6);
INSERT INTO `t_role_privilege` VALUES (441, 2, 7);
INSERT INTO `t_role_privilege` VALUES (442, 2, 8);
INSERT INTO `t_role_privilege` VALUES (443, 2, 9);
INSERT INTO `t_role_privilege` VALUES (444, 2, 10);
INSERT INTO `t_role_privilege` VALUES (445, 2, 11);
INSERT INTO `t_role_privilege` VALUES (446, 2, 12);
INSERT INTO `t_role_privilege` VALUES (447, 2, 13);
INSERT INTO `t_role_privilege` VALUES (448, 2, 14);
INSERT INTO `t_role_privilege` VALUES (449, 2, 15);
INSERT INTO `t_role_privilege` VALUES (450, 2, 16);
INSERT INTO `t_role_privilege` VALUES (451, 2, 17);
INSERT INTO `t_role_privilege` VALUES (452, 2, 18);
INSERT INTO `t_role_privilege` VALUES (453, 2, 19);
INSERT INTO `t_role_privilege` VALUES (454, 2, 20);
INSERT INTO `t_role_privilege` VALUES (455, 2, 21);
INSERT INTO `t_role_privilege` VALUES (456, 2, 22);
INSERT INTO `t_role_privilege` VALUES (457, 2, 23);
INSERT INTO `t_role_privilege` VALUES (458, 2, 74);
INSERT INTO `t_role_privilege` VALUES (459, 2, 79);
INSERT INTO `t_role_privilege` VALUES (460, 2, 89);
INSERT INTO `t_role_privilege` VALUES (461, 2, 90);
INSERT INTO `t_role_privilege` VALUES (462, 2, 91);
INSERT INTO `t_role_privilege` VALUES (463, 2, 93);
INSERT INTO `t_role_privilege` VALUES (464, 2, 94);
INSERT INTO `t_role_privilege` VALUES (465, 2, 97);
INSERT INTO `t_role_privilege` VALUES (466, 2, 98);
INSERT INTO `t_role_privilege` VALUES (467, 2, 101);
INSERT INTO `t_role_privilege` VALUES (468, 2, 107);
INSERT INTO `t_role_privilege` VALUES (469, 2, 24);
INSERT INTO `t_role_privilege` VALUES (470, 2, 25);
INSERT INTO `t_role_privilege` VALUES (471, 2, 26);
INSERT INTO `t_role_privilege` VALUES (472, 2, 27);
INSERT INTO `t_role_privilege` VALUES (473, 2, 28);
INSERT INTO `t_role_privilege` VALUES (474, 2, 29);
INSERT INTO `t_role_privilege` VALUES (475, 2, 30);
INSERT INTO `t_role_privilege` VALUES (476, 2, 31);
INSERT INTO `t_role_privilege` VALUES (477, 2, 32);
INSERT INTO `t_role_privilege` VALUES (478, 2, 33);
INSERT INTO `t_role_privilege` VALUES (479, 2, 34);
INSERT INTO `t_role_privilege` VALUES (480, 2, 35);
INSERT INTO `t_role_privilege` VALUES (481, 2, 36);
INSERT INTO `t_role_privilege` VALUES (482, 2, 37);
INSERT INTO `t_role_privilege` VALUES (483, 2, 38);
INSERT INTO `t_role_privilege` VALUES (484, 2, 39);
INSERT INTO `t_role_privilege` VALUES (485, 2, 40);
INSERT INTO `t_role_privilege` VALUES (486, 2, 41);
INSERT INTO `t_role_privilege` VALUES (487, 2, 42);
INSERT INTO `t_role_privilege` VALUES (488, 2, 43);
INSERT INTO `t_role_privilege` VALUES (489, 2, 44);
INSERT INTO `t_role_privilege` VALUES (490, 2, 45);
INSERT INTO `t_role_privilege` VALUES (491, 2, 46);
INSERT INTO `t_role_privilege` VALUES (492, 2, 47);
INSERT INTO `t_role_privilege` VALUES (493, 2, 48);
INSERT INTO `t_role_privilege` VALUES (494, 2, 49);
INSERT INTO `t_role_privilege` VALUES (495, 2, 50);
INSERT INTO `t_role_privilege` VALUES (496, 2, 51);
INSERT INTO `t_role_privilege` VALUES (497, 2, 52);
INSERT INTO `t_role_privilege` VALUES (498, 2, 53);
INSERT INTO `t_role_privilege` VALUES (499, 2, 54);
INSERT INTO `t_role_privilege` VALUES (500, 2, 55);
INSERT INTO `t_role_privilege` VALUES (501, 2, 56);
INSERT INTO `t_role_privilege` VALUES (502, 2, 57);
INSERT INTO `t_role_privilege` VALUES (503, 2, 58);
INSERT INTO `t_role_privilege` VALUES (504, 2, 59);
INSERT INTO `t_role_privilege` VALUES (505, 2, 60);
INSERT INTO `t_role_privilege` VALUES (506, 2, 61);
INSERT INTO `t_role_privilege` VALUES (507, 2, 62);
INSERT INTO `t_role_privilege` VALUES (508, 2, 63);
INSERT INTO `t_role_privilege` VALUES (509, 2, 64);
INSERT INTO `t_role_privilege` VALUES (510, 2, 65);
INSERT INTO `t_role_privilege` VALUES (511, 2, 66);
INSERT INTO `t_role_privilege` VALUES (512, 2, 67);
INSERT INTO `t_role_privilege` VALUES (513, 2, 68);
INSERT INTO `t_role_privilege` VALUES (514, 2, 69);
INSERT INTO `t_role_privilege` VALUES (515, 2, 70);
INSERT INTO `t_role_privilege` VALUES (516, 2, 71);
INSERT INTO `t_role_privilege` VALUES (517, 2, 72);
INSERT INTO `t_role_privilege` VALUES (518, 2, 73);
INSERT INTO `t_role_privilege` VALUES (519, 2, 75);
INSERT INTO `t_role_privilege` VALUES (520, 2, 76);
INSERT INTO `t_role_privilege` VALUES (521, 2, 77);
INSERT INTO `t_role_privilege` VALUES (522, 2, 78);
INSERT INTO `t_role_privilege` VALUES (523, 2, 80);
INSERT INTO `t_role_privilege` VALUES (524, 2, 81);
INSERT INTO `t_role_privilege` VALUES (525, 2, 82);
INSERT INTO `t_role_privilege` VALUES (526, 2, 83);
INSERT INTO `t_role_privilege` VALUES (527, 2, 84);
INSERT INTO `t_role_privilege` VALUES (528, 2, 85);
INSERT INTO `t_role_privilege` VALUES (529, 2, 86);
INSERT INTO `t_role_privilege` VALUES (530, 2, 87);
INSERT INTO `t_role_privilege` VALUES (531, 2, 88);
INSERT INTO `t_role_privilege` VALUES (532, 2, 92);
INSERT INTO `t_role_privilege` VALUES (533, 2, 95);
INSERT INTO `t_role_privilege` VALUES (534, 2, 96);
INSERT INTO `t_role_privilege` VALUES (535, 2, 99);
INSERT INTO `t_role_privilege` VALUES (536, 2, 100);
INSERT INTO `t_role_privilege` VALUES (537, 2, 102);
INSERT INTO `t_role_privilege` VALUES (538, 2, 103);
INSERT INTO `t_role_privilege` VALUES (539, 2, 104);
INSERT INTO `t_role_privilege` VALUES (540, 2, 105);
INSERT INTO `t_role_privilege` VALUES (541, 2, 106);

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
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '支架' ROW_FORMAT = Dynamic;

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
INSERT INTO `t_scaffold` VALUES (26, NULL, '2835E_H2572_60B10_B7A20', '', NULL, 0, 0.1, 0.2, 0.45, NULL, NULL, '2020-06-18 11:49:13', 0, 0);
INSERT INTO `t_scaffold` VALUES (27, NULL, '2835E_C2372_50_B5A20', '', NULL, 0, 2, 2, 2, NULL, NULL, '2020-06-18 17:33:27', 0, 0);

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
INSERT INTO `t_spc_base_rule` VALUES (1, 1, '控制图上有%m个点位于控制线以外', 1, NULL, '2020-06-18 11:30:36');
INSERT INTO `t_spc_base_rule` VALUES (2, 2, '连续%m点落在中心线的同一侧', 9, NULL, '2020-06-18 11:30:36');
INSERT INTO `t_spc_base_rule` VALUES (3, 3, '连续%m点递增或递减', 6, NULL, '2020-06-18 11:30:36');
INSERT INTO `t_spc_base_rule` VALUES (4, 4, '连续%m点中相邻点交替上下', 14, NULL, '2020-06-18 11:30:36');
INSERT INTO `t_spc_base_rule` VALUES (5, 5, '连续%m点中有%m点落在中心线同一侧的B区以外', 3, 3, '2020-06-18 11:30:36');
INSERT INTO `t_spc_base_rule` VALUES (6, 6, '连续%m点中有%m点落在中心线同一侧的C区之外', 5, 4, '2020-06-18 11:30:36');
INSERT INTO `t_spc_base_rule` VALUES (7, 7, '连续%m点落在C区之内', 15, NULL, '2020-06-18 11:30:36');
INSERT INTO `t_spc_base_rule` VALUES (8, 8, '连续%m点落在中心线两侧，但无%m点在C区之内', 8, 1, '2020-06-18 11:30:36');

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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务单状态定义' ROW_FORMAT = Dynamic;

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
INSERT INTO `t_task_state_df` VALUES (9, '打样通过', 9, '2020-05-26 16:54:17');
INSERT INTO `t_task_state_df` VALUES (10, '打样失败', 10, '2020-05-26 16:54:17');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_type_machine
-- ----------------------------
INSERT INTO `t_type_machine` VALUES (1, NULL, 'S-BEN-30G-11M-03-F0D-9', 90, 93.5, 91.5, 54, 3000, 55, 65, 452.5, 457.5, '2020-06-18 11:43:39', 0, NULL, 1, 0, 0);
INSERT INTO `t_type_machine` VALUES (2, NULL, 'E2835UW105-2B', 80, 83, 80, NULL, 6500, 12, 60, NULL, NULL, '2020-06-18 17:31:52', 0, NULL, 1, 0, 0);

-- ----------------------------
-- Table structure for t_type_machine_default_chip
-- ----------------------------
DROP TABLE IF EXISTS `t_type_machine_default_chip`;
CREATE TABLE `t_type_machine_default_chip`  (
  `t_type_machine_id` bigint(20) NULL DEFAULT NULL COMMENT '机种id',
  `chip_id` bigint(20) NULL DEFAULT NULL COMMENT '默认的芯片ID'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种默认的芯片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_type_machine_default_chip
-- ----------------------------
INSERT INTO `t_type_machine_default_chip` VALUES (1, 3);

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
-- Records of t_type_machine_default_other_material
-- ----------------------------
INSERT INTO `t_type_machine_default_other_material` VALUES (1, '1,2', 26, 2, NULL, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '机种点胶高度' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_type_machine_gule_high
-- ----------------------------
INSERT INTO `t_type_machine_gule_high` VALUES (1, 1, 0, -0.08, 0, 1);
INSERT INTO `t_type_machine_gule_high` VALUES (2, 2, 0, -0.08, 0, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户' ROW_FORMAT = Dynamic;

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
INSERT INTO `t_user` VALUES (13, 4, '李伟英', 'liweiying', '4297f44b13955235245b2497399d7a93', 0, 0, '2020-06-18 17:22:35');

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
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户角色表' ROW_FORMAT = Dynamic;

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
INSERT INTO `t_user_role` VALUES (13, 13, 2);

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
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `t_model_task_id_dtl` AS select `bs_task_state`.`model_id` AS `model_id`,`bs_task_state`.`task_id` AS `task_id`,`bs_task_state`.`id` AS `task_state_id`,`bs_task_state`.`create_time` AS `task_state_id_create_time`,`bs_task`.`create_time` AS `task_id_create_time`,`bs_task_state`.`task_df_id` AS `task_df_id`,`d_upload_file`.`id` AS `file_id`,`d_upload_file`.`create_time` AS `file_id_create_time`,`d_upload_file`.`classType` AS `classType`,`d_file_summary`.`euclidean_distance_x` AS `euclidean_distance_x`,`d_file_summary`.`euclidean_distance_y` AS `euclidean_distance_y` from (((`bs_task` left join `bs_task_state` on((`bs_task_state`.`task_id` = `bs_task`.`id`))) join `d_upload_file` on(find_in_set(`d_upload_file`.`id`,`bs_task_state`.`fileid_list`))) left join `d_file_summary` on((`d_upload_file`.`id` = `d_file_summary`.`file_id`))) where ((`d_upload_file`.`is_delete` = 0) and (`d_file_summary`.`euclidean_distance_x` <= 0.1) and (`d_file_summary`.`euclidean_distance_y` <= 0.1) and (`d_file_summary`.`total_size` >= 50) and (`bs_task_state`.`task_df_id` not in (1,3,5)));

SET FOREIGN_KEY_CHECKS = 1;
