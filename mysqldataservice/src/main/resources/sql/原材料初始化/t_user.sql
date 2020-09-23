/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.18.50MLS主
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.18.50:3306
 Source Schema         : yk_ai

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 25/04/2020 17:32:19
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;
