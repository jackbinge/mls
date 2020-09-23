/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.18.50MLS主
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.18.50:3306
 Source Schema         : yk_ai_test

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 25/04/2020 15:35:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_phosphor_type
-- ----------------------------
DROP TABLE IF EXISTS `t_phosphor_type`;
CREATE TABLE `t_phosphor_type`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '荧光粉类型名称',
  `is_delete` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'false 正常、true 删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '荧光粉类型' ROW_FORMAT = Dynamic;

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

SET FOREIGN_KEY_CHECKS = 1;
