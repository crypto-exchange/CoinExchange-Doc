/*
 Navicat Premium Data Transfer

 Source Server         : Coin-Mysql
 Source Server Type    : MySQL
 Source Server Version : 50731
 Source Host           : mysql-server:3307
 Source Schema         : coin-exchange

 Target Server Type    : MySQL
 Target Server Version : 50731
 File Encoding         : 65001

 Date: 26/09/2020 11:20:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` bigint(18) NOT NULL COMMENT '用户id',
  `coin_id` bigint(18) NOT NULL COMMENT '币种id',
  `status` tinyint(1) NOT NULL COMMENT '账号状态：1，正常；2，冻结；',
  `balance_amount` decimal(40, 20) NOT NULL COMMENT '币种可用金额',
  `freeze_amount` decimal(40, 20) NOT NULL COMMENT '币种冻结金额',
  `recharge_amount` decimal(40, 20) NOT NULL COMMENT '累计充值金额',
  `withdrawals_amount` decimal(40, 20) NOT NULL COMMENT '累计提现金额',
  `net_value` decimal(40, 20) NOT NULL COMMENT '净值',
  `lock_margin` decimal(40, 20) NOT NULL COMMENT '占用保证金',
  `float_profit` decimal(40, 20) NOT NULL COMMENT '持仓盈亏/浮动盈亏',
  `total_profit` decimal(40, 20) NOT NULL COMMENT '总盈亏',
  `rec_addr` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '充值地址',
  `version` bigint(18) NOT NULL COMMENT '版本号',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `userid_coinid_unique`(`user_id`, `coin_id`) USING BTREE,
  INDEX `account_coin_id_ref`(`coin_id`) USING BTREE,
  INDEX `inx_platform_account`(`user_id`) USING BTREE,
  CONSTRAINT `account_ibfk_1` FOREIGN KEY (`coin_id`) REFERENCES `coin` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1024857048734756872 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户财产记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for account_detail
-- ----------------------------
DROP TABLE IF EXISTS `account_detail`;
CREATE TABLE `account_detail`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(18) NOT NULL COMMENT '用户id',
  `coin_id` bigint(30) NOT NULL COMMENT '币种id',
  `account_id` bigint(18) NOT NULL COMMENT '账户id',
  `ref_account_id` bigint(18) NOT NULL COMMENT '该笔流水资金关联方的账户id',
  `order_id` bigint(18) NOT NULL DEFAULT 0 COMMENT '订单ID',
  `direction` tinyint(1) NOT NULL COMMENT '入账为1，出账为2',
  `business_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务类型:\r\n充值(recharge_into) \r\n提现审核通过(withdrawals_out) \r\n下单(order_create) \r\n成交(order_turnover)\r\n成交手续费(order_turnover_poundage)  \r\n撤单(order_cancel)  \r\n注册奖励(bonus_register)\r\n提币冻结解冻(withdrawals)\r\n充人民币(recharge)\r\n提币手续费(withdrawals_poundage)   \r\n兑换(cny_btcx_exchange)\r\n奖励充值(bonus_into)\r\n奖励冻结(bonus_freeze)',
  `amount` decimal(40, 20) NOT NULL COMMENT '资产数量',
  `fee` decimal(40, 20) NULL DEFAULT NULL COMMENT '手续费',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流水状态：\r\n充值\r\n提现\r\n冻结\r\n解冻\r\n转出\r\n转入',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `payment_detail_accountid_fk`(`account_id`) USING BTREE,
  INDEX `payment_detail_userid_fk`(`user_id`) USING BTREE,
  INDEX `payment_detail_refaccountid_fk`(`ref_account_id`) USING BTREE,
  INDEX `fk_accountdetail_coinid`(`coin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1024533907399607364 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资金账户流水' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for address_pool
-- ----------------------------
DROP TABLE IF EXISTS `address_pool`;
CREATE TABLE `address_pool`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `coin_id` bigint(18) NOT NULL COMMENT '币种ID',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '地址',
  `keystore` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'keystore',
  `pwd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `coin_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '地址类型',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `unq_address`(`address`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1021646715368628227 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户的地址池' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for admin_address
-- ----------------------------
DROP TABLE IF EXISTS `admin_address`;
CREATE TABLE `admin_address`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `coin_id` bigint(18) NULL DEFAULT NULL COMMENT '币种Id',
  `keystore` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'eth keystore',
  `pwd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'eth账号密码',
  `address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `status` int(4) NULL DEFAULT NULL COMMENT '1:归账(冷钱包地址),2:打款,3:手续费',
  `coin_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1020596405017976835 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台归账手续费等账户' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for admin_bank
-- ----------------------------
DROP TABLE IF EXISTS `admin_bank`;
CREATE TABLE `admin_bank`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户人姓名',
  `bank_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户行名称',
  `bank_card` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '卡号',
  `coin_id` bigint(18) NULL DEFAULT NULL COMMENT '充值转换换币种ID',
  `coin_name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '币种名称',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态：0-无效；1-有效；',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1021703917179908098 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '人民币充值卡号管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for cash_recharge
-- ----------------------------
DROP TABLE IF EXISTS `cash_recharge`;
CREATE TABLE `cash_recharge`  (
  `id` bigint(18) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` bigint(18) UNSIGNED NOT NULL COMMENT '用户id',
  `coin_id` bigint(18) NOT NULL COMMENT '币种id',
  `coin_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币种名：cny，人民币；',
  `num` decimal(20, 2) UNSIGNED NOT NULL COMMENT '数量（充值金额）',
  `fee` decimal(20, 2) UNSIGNED NOT NULL COMMENT '手续费',
  `feecoin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手续费币种',
  `mum` decimal(20, 2) UNSIGNED NOT NULL COMMENT '成交量（到账金额）',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型：alipay，支付宝；cai1pay，财易付；bank，银联；',
  `tradeno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '充值订单号',
  `outtradeno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第三方订单号',
  `remark` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '充值备注备注',
  `audit_remark` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核备注',
  `step` tinyint(4) NULL DEFAULT NULL COMMENT '当前审核级数',
  `status` tinyint(4) NOT NULL COMMENT '状态：0-待审核；1-审核通过；2-拒绝；3-充值成功；',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行卡账户名',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `bank_card` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行卡号',
  `last_time` datetime(0) NULL DEFAULT NULL COMMENT '最后确认到账时间。',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `userid`(`user_id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1022673961309319171 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '充值表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cash_recharge_audit_record
-- ----------------------------
DROP TABLE IF EXISTS `cash_recharge_audit_record`;
CREATE TABLE `cash_recharge_audit_record`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` bigint(18) NULL DEFAULT NULL COMMENT '充值订单号',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '审核备注',
  `step` tinyint(4) NULL DEFAULT NULL COMMENT '当前审核级数',
  `audit_user_id` bigint(18) NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_user_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1022722556213473283 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '充值审核记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for cash_withdraw_audit_record
-- ----------------------------
DROP TABLE IF EXISTS `cash_withdraw_audit_record`;
CREATE TABLE `cash_withdraw_audit_record`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` bigint(18) NULL DEFAULT NULL COMMENT '提币订单号',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '审核备注',
  `step` tinyint(4) NULL DEFAULT NULL COMMENT '当前审核级数',
  `audit_user_id` bigint(18) NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_user_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1024533907189682179 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '提现审核记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for cash_withdrawals
-- ----------------------------
DROP TABLE IF EXISTS `cash_withdrawals`;
CREATE TABLE `cash_withdrawals`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(18) NOT NULL COMMENT '用户ID',
  `coin_id` bigint(18) NOT NULL COMMENT '币种ID',
  `account_id` bigint(18) NOT NULL COMMENT '资金账户ID',
  `num` decimal(20, 2) NOT NULL COMMENT '数量（提现金额）',
  `fee` decimal(20, 2) NOT NULL COMMENT '手续费',
  `mum` decimal(20, 2) NOT NULL COMMENT '到账金额',
  `truename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开户人',
  `bank` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '银行名称',
  `bank_prov` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行所在省',
  `bank_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '银行所在市',
  `bank_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `bank_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '银行账号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `step` tinyint(4) NULL DEFAULT NULL COMMENT '当前审核级数',
  `status` tinyint(4) NOT NULL COMMENT '状态：0-待审核；1-审核通过；2-拒绝；3-提现成功；',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `last_time` datetime(0) NULL DEFAULT NULL COMMENT '最后确认提现到账时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `userid`(`user_id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1023821218083762178 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '提现表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coin
-- ----------------------------
DROP TABLE IF EXISTS `coin`;
CREATE TABLE `coin`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '币种ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币种名称',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币种标题',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币种logo',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'xnb：人民币\r\ndefault：比特币系列\r\nETH：以太坊\r\nethToken：以太坊代币\r\n\r\n',
  `wallet` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'rgb：认购币\r\nqbb：钱包币\r\n',
  `round` tinyint(4) NOT NULL COMMENT '小数位数',
  `base_amount` decimal(20, 8) NULL DEFAULT NULL COMMENT '最小提现单位',
  `min_amount` decimal(20, 8) NULL DEFAULT NULL COMMENT '单笔最小提现数量',
  `max_amount` decimal(20, 8) NULL DEFAULT NULL COMMENT '单笔最大提现数量',
  `day_max_amount` decimal(20, 8) NULL DEFAULT NULL COMMENT '当日最大提现数量',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'status=1：启用\r\n0：禁用',
  `auto_out` double NULL DEFAULT 10 COMMENT '自动转出数量',
  `rate` double NULL DEFAULT 0 COMMENT '手续费率',
  `min_fee_num` decimal(20, 8) NULL DEFAULT NULL COMMENT '最低收取手续费个数',
  `withdraw_flag` tinyint(4) NULL DEFAULT 1 COMMENT '提现开关',
  `recharge_flag` tinyint(4) NULL DEFAULT 1 COMMENT '充值开关',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_name`(`name`) USING BTREE,
  INDEX `idx_status_wallet_type`(`wallet`, `status`, `type`) USING BTREE,
  INDEX `idx_create_time`(`created`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1022352720195104770 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '币种配置信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coin_balance
-- ----------------------------
DROP TABLE IF EXISTS `coin_balance`;
CREATE TABLE `coin_balance`  (
  `id` bigint(18) NOT NULL COMMENT '主键',
  `coin_id` bigint(18) NULL DEFAULT NULL COMMENT '币种ID',
  `coin_name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '币种名称',
  `system_balance` decimal(20, 8) NULL DEFAULT NULL COMMENT '系统余额（根据充值提币计算）',
  `coin_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '币种类型',
  `collect_account_balance` decimal(20, 8) NULL DEFAULT NULL COMMENT '归集账户余额',
  `loan_account_balance` decimal(20, 8) NULL DEFAULT NULL COMMENT '钱包账户余额',
  `fee_account_balance` decimal(20, 8) NULL DEFAULT NULL COMMENT '手续费账户余额(eth转账需要手续费)',
  `last_update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `recharge_account_balance` decimal(20, 8) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '币种余额' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for coin_config
-- ----------------------------
DROP TABLE IF EXISTS `coin_config`;
CREATE TABLE `coin_config`  (
  `id` bigint(18) NOT NULL COMMENT '币种ID(对应coin表ID)',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币种名称',
  `coin_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'btc-比特币系列；eth-以太坊；ethToken-以太坊代币；etc-以太经典；\\r\\n\\r\\n',
  `credit_limit` decimal(20, 8) NULL DEFAULT NULL COMMENT '钱包最低留存的币',
  `credit_max_limit` decimal(20, 8) NULL DEFAULT NULL COMMENT '当触发改状态的时候,开始归集',
  `rpc_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'rpc服务ip',
  `rpc_port` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'rpc服务port',
  `rpc_user` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'rpc用户',
  `rpc_pwd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'rpc密码',
  `last_block` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后一个区块',
  `wallet_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '钱包用户名',
  `wallet_pass` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '钱包密码',
  `contract_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '代币合约地址',
  `context` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'context',
  `min_confirm` int(4) NULL DEFAULT 1 COMMENT '最低确认数',
  `task` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '定时任务',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '是否可用0不可用,1可用',
  `auto_draw_limit` decimal(20, 8) NULL DEFAULT NULL,
  `auto_draw` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_wallet_type`(`coin_type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '币种配置信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for coin_recharge
-- ----------------------------
DROP TABLE IF EXISTS `coin_recharge`;
CREATE TABLE `coin_recharge`  (
  `id` bigint(18) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` bigint(18) UNSIGNED NOT NULL COMMENT '用户id',
  `coin_id` bigint(18) NOT NULL COMMENT '币种id',
  `coin_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '币种名称',
  `coin_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '币种类型',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '钱包地址',
  `confirm` int(1) NOT NULL COMMENT '充值确认数',
  `status` int(4) NULL DEFAULT 0 COMMENT '状态：0-待入帐；1-充值失败，2到账失败，3到账成功；',
  `txid` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易id',
  `amount` decimal(20, 8) NULL DEFAULT NULL,
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1026352852112707586 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数字货币充值记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coin_server
-- ----------------------------
DROP TABLE IF EXISTS `coin_server`;
CREATE TABLE `coin_server`  (
  `id` bigint(18) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `rpc_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '钱包服务器ip',
  `rpc_port` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '钱包服务器ip',
  `running` int(1) NOT NULL COMMENT '服务是否运行 0:正常,1:停止',
  `wallet_number` bigint(255) NOT NULL COMMENT '钱包服务器区块高度',
  `coin_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `mark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  `real_number` bigint(255) NULL DEFAULT NULL COMMENT '真实区块高度',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1017485995345301507 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '监测当前服务器Ip状态' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for coin_type
-- ----------------------------
DROP TABLE IF EXISTS `coin_type`;
CREATE TABLE `coin_type`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代码',
  `description` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述',
  `status` tinyint(4) NOT NULL COMMENT '状态：0-无效；1-有效；',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code_unique`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1021947708780457986 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '币种类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coin_withdraw
-- ----------------------------
DROP TABLE IF EXISTS `coin_withdraw`;
CREATE TABLE `coin_withdraw`  (
  `id` bigint(18) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` bigint(18) UNSIGNED NOT NULL COMMENT '用户id',
  `coin_id` bigint(18) NOT NULL COMMENT '币种id',
  `coin_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '币种名称',
  `coin_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '币种类型',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '钱包地址',
  `txid` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易id',
  `num` decimal(20, 8) NOT NULL COMMENT '提现量',
  `fee` decimal(20, 8) NOT NULL COMMENT '手续费()',
  `mum` decimal(20, 8) NOT NULL COMMENT '实际提现',
  `type` tinyint(1) NULL DEFAULT 0 COMMENT '0站内1其他2手工提币',
  `chain_fee` decimal(20, 8) NULL DEFAULT NULL COMMENT '链上手续费花费',
  `block_num` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '区块高度',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '后台审核人员提币备注备注',
  `wallet_mark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '钱包提币备注备注',
  `step` tinyint(4) NULL DEFAULT NULL COMMENT '当前审核级数',
  `status` tinyint(1) NOT NULL COMMENT '状态：0-审核中；1-成功；2-拒绝；3-撤销；4-审核通过；5-打币中；',
  `audit_time` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `userid`(`user_id`) USING BTREE,
  INDEX `coinname`(`coin_id`) USING BTREE,
  INDEX `idx_created`(`created`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数字货币提现记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for coin_withdraw_audit_record
-- ----------------------------
DROP TABLE IF EXISTS `coin_withdraw_audit_record`;
CREATE TABLE `coin_withdraw_audit_record`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` bigint(18) NULL DEFAULT NULL COMMENT '提币订单号',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '审核备注',
  `step` tinyint(4) NULL DEFAULT NULL COMMENT '当前审核级数',
  `audit_user_id` bigint(18) NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_user_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1022786667601342466 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '提币审核记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for config
-- ----------------------------
DROP TABLE IF EXISTS `config`;
CREATE TABLE `config`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置规则类型',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置规则代码',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置规则名称',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置规则描述',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置值',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1000739033304633480 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台配置信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for entrust_order
-- ----------------------------
DROP TABLE IF EXISTS `entrust_order`;
CREATE TABLE `entrust_order`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `user_id` bigint(18) NOT NULL COMMENT '用户ID',
  `market_id` bigint(18) NOT NULL COMMENT '市场ID',
  `market_type` tinyint(4) NULL DEFAULT NULL COMMENT '市场类型（1：币币交易，2：创新交易）',
  `symbol` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易对标识符',
  `market_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '交易市场',
  `price` decimal(40, 20) NOT NULL COMMENT '委托价格',
  `merge_low_price` decimal(40, 20) NULL DEFAULT NULL COMMENT '合并深度价格1',
  `merge_high_price` decimal(40, 20) NULL DEFAULT NULL COMMENT '合并深度价格2',
  `volume` decimal(40, 20) NOT NULL COMMENT '委托数量',
  `amount` decimal(40, 20) NOT NULL COMMENT '委托总额',
  `fee_rate` decimal(40, 20) NOT NULL COMMENT '手续费比率',
  `fee` decimal(40, 20) NOT NULL COMMENT '交易手续费',
  `contract_unit` int(11) NULL DEFAULT NULL COMMENT '合约单位',
  `deal` decimal(40, 20) NOT NULL COMMENT '成交数量',
  `freeze` decimal(40, 20) NOT NULL COMMENT '冻结量',
  `margin_rate` decimal(40, 20) NULL DEFAULT NULL COMMENT '保证金比例',
  `base_coin_rate` decimal(40, 20) NULL DEFAULT NULL COMMENT '基础货币对（USDT/BTC）兑换率',
  `price_coin_rate` decimal(40, 20) NULL DEFAULT NULL COMMENT '报价货币对（USDT/BTC)兑换率',
  `lock_margin` decimal(40, 20) NULL DEFAULT NULL COMMENT '占用保证金',
  `price_type` tinyint(4) NOT NULL DEFAULT 2 COMMENT '价格类型：1-市价；2-限价',
  `trade_type` tinyint(4) NULL DEFAULT NULL COMMENT '交易类型：1-开仓；2-平仓',
  `type` tinyint(4) NOT NULL COMMENT '买卖类型：1-买入；2-卖出\r\n2 卖出\r\n',
  `open_order_id` bigint(18) NULL DEFAULT NULL COMMENT '平仓委托关联单号',
  `status` tinyint(4) NOT NULL COMMENT 'status\r\n0未成交\r\n1已成交\r\n2已取消\r\n4异常单',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idnex_price`(`price`, `market_id`, `volume`, `deal`, `type`, `status`, `user_id`) USING BTREE,
  INDEX `idx_create_time`(`created`) USING BTREE,
  INDEX `idx_market_id`(`market_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1024857694347194370 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '委托订单信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for forex_account
-- ----------------------------
DROP TABLE IF EXISTS `forex_account`;
CREATE TABLE `forex_account`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `market_id` bigint(18) NULL DEFAULT NULL COMMENT '交易对ID',
  `market_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易对',
  `type` tinyint(4) NULL DEFAULT NULL COMMENT '持仓方向：1-买；2-卖',
  `amount` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '持仓量',
  `lock_amount` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '冻结持仓量',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态：1-有效；2-锁定；',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `unique_index`(`user_id`, `market_id`, `type`) USING BTREE,
  INDEX `idx_created`(`created`) USING BTREE,
  INDEX `idx_updated`(`last_update_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '创新交易持仓信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for forex_account_detail
-- ----------------------------
DROP TABLE IF EXISTS `forex_account_detail`;
CREATE TABLE `forex_account_detail`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_id` bigint(18) NULL DEFAULT NULL COMMENT '持仓账户ID',
  `type` tinyint(4) NULL DEFAULT NULL COMMENT '收支类型：开仓；2-平仓；',
  `amount` decimal(20, 8) NULL DEFAULT NULL COMMENT '持仓量',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_account_id`(`account_id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '持仓账户流水' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for forex_close_position_order
-- ----------------------------
DROP TABLE IF EXISTS `forex_close_position_order`;
CREATE TABLE `forex_close_position_order`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `market_id` bigint(18) NULL DEFAULT NULL COMMENT '交易对ID',
  `market_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易对名称',
  `type` tinyint(4) NULL DEFAULT NULL COMMENT '持仓方向：1-买；2-卖',
  `account_id` bigint(18) NULL DEFAULT NULL COMMENT '资金账户ID',
  `entrust_order_id` bigint(18) NULL DEFAULT NULL COMMENT '委托订单号',
  `order_id` bigint(18) NULL DEFAULT NULL COMMENT '成交订单号',
  `price` decimal(20, 8) NULL DEFAULT NULL COMMENT '成交价',
  `num` decimal(20, 8) NULL DEFAULT NULL COMMENT '成交数量',
  `open_id` bigint(18) NULL DEFAULT NULL COMMENT '关联开仓订单号',
  `profit` decimal(20, 8) NULL DEFAULT NULL COMMENT '平仓盈亏',
  `unlock_margin` decimal(20, 8) NULL DEFAULT NULL COMMENT '返回还保证金',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`created`) USING BTREE,
  INDEX `idx_update_time`(`last_update_time`) USING BTREE,
  INDEX `idx_market_id`(`market_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平仓详情' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for forex_coin
-- ----------------------------
DROP TABLE IF EXISTS `forex_coin`;
CREATE TABLE `forex_coin`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币种名称',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '币种标题',
  `sort` tinyint(4) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态: 0禁用 1启用',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '创新交易币种表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for forex_open_position_order
-- ----------------------------
DROP TABLE IF EXISTS `forex_open_position_order`;
CREATE TABLE `forex_open_position_order`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `market_id` bigint(18) NULL DEFAULT NULL COMMENT '交易对ID',
  `market_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易对名称',
  `coin_id` bigint(18) NULL DEFAULT NULL COMMENT '结算币种',
  `type` tinyint(4) NULL DEFAULT NULL COMMENT '持仓方向：1-买；2-卖',
  `account_id` bigint(18) NULL DEFAULT NULL COMMENT '资金账户ID',
  `entrust_order_id` bigint(18) NULL DEFAULT NULL COMMENT '委托订单',
  `order_id` bigint(18) NULL DEFAULT NULL COMMENT '成交订单号',
  `price` decimal(20, 8) NULL DEFAULT NULL COMMENT '成交价格',
  `num` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '成交数量',
  `lock_margin` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '扣除保证金',
  `close_num` decimal(20, 8) NULL DEFAULT 0.00000000 COMMENT '平仓量',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态：1：未平仓；2-已平仓',
  `last_update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`created`) USING BTREE,
  INDEX `idx_update_time`(`last_update_time`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_market_id`(`market_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '开仓订单信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for market
-- ----------------------------
DROP TABLE IF EXISTS `market`;
CREATE TABLE `market`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '市场ID',
  `type` tinyint(4) NOT NULL COMMENT '类型：1-数字货币；2：创新交易',
  `trade_area_id` bigint(18) NOT NULL COMMENT '交易区域ID',
  `sell_coin_id` bigint(18) NULL DEFAULT NULL COMMENT '卖方市场ID',
  `buy_coin_id` bigint(18) NOT NULL COMMENT '买方币种ID',
  `symbol` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易对标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市场logo',
  `open_price` decimal(20, 8) NOT NULL COMMENT '开盘价格',
  `fee_buy` decimal(20, 8) NOT NULL COMMENT '买入手续费率',
  `fee_sell` decimal(20, 8) NOT NULL COMMENT '卖出手续费率',
  `margin_rate` decimal(20, 8) NULL DEFAULT NULL COMMENT '保证金占用比例',
  `num_min` decimal(20, 8) NOT NULL COMMENT '单笔最小委托量',
  `num_max` decimal(20, 8) NOT NULL COMMENT '单笔最大委托量',
  `trade_min` decimal(20, 8) NOT NULL COMMENT '单笔最小成交额',
  `trade_max` decimal(20, 8) NOT NULL COMMENT '单笔最大成交额',
  `price_scale` tinyint(4) NULL DEFAULT 0 COMMENT '价格小数位',
  `num_scale` tinyint(4) NOT NULL DEFAULT 0 COMMENT '数量小数位',
  `contract_unit` int(11) NULL DEFAULT NULL COMMENT '合约单位',
  `point_value` decimal(20, 8) NULL DEFAULT NULL COMMENT '点',
  `merge_depth` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '合并深度（格式：4,3,2）4:表示为0.0001；3：表示为0.001',
  `trade_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '交易时间',
  `trade_week` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '交易周期',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序列',
  `status` tinyint(1) NOT NULL COMMENT '状态\r\n0禁用\r\n1启用',
  `fxcm_symbol` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '福汇API交易对',
  `yahoo_symbol` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '对应雅虎金融API交易对',
  `aliyun_symbol` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '对应阿里云API交易对',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_trade_area_id`(`trade_area_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_buy_coinid_sell_coinid`(`sell_coin_id`, `buy_coin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1022387688220798978 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易对配置信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mine_pool
-- ----------------------------
DROP TABLE IF EXISTS `mine_pool`;
CREATE TABLE `mine_pool`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `create_user` bigint(18) NULL DEFAULT NULL COMMENT '创建者',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '矿池' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for mine_pool_member
-- ----------------------------
DROP TABLE IF EXISTS `mine_pool_member`;
CREATE TABLE `mine_pool_member`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mine_pool_id` bigint(18) NULL DEFAULT NULL COMMENT '矿池ID',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `created` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '矿池成员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '简介',
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '作者',
  `status` int(1) NULL DEFAULT NULL COMMENT '文章状态',
  `sort` int(4) NOT NULL COMMENT '文章排序，越大越靠前',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '内容',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1021989613635514371 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统资讯公告信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for sms
-- ----------------------------
DROP TABLE IF EXISTS `sms`;
CREATE TABLE `sms`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `template_code` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '短信模板ID',
  `country_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '国际区号',
  `mobile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '短信接收手机号',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '短信内容',
  `status` int(4) NULL DEFAULT NULL COMMENT '短信状态：0，默认值；大于0，成功发送短信数量；小于0，异常；',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `last_update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '发送时间',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1024481107063861250 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '短信信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` bigint(18) NULL DEFAULT NULL COMMENT '上级菜单ID',
  `parent_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上级菜单唯一KEY值',
  `type` tinyint(4) NOT NULL DEFAULT 2 COMMENT '类型 1-分类 2-节点',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `target_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '目标地址',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序索引',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态 0-无效； 1-有效；',
  `create_by` bigint(18) NULL DEFAULT NULL COMMENT '创建人',
  `modify_by` bigint(18) NULL DEFAULT NULL COMMENT '修改人',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_privilege
-- ----------------------------
DROP TABLE IF EXISTS `sys_privilege`;
CREATE TABLE `sys_privilege`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `menu_id` bigint(18) NULL DEFAULT NULL COMMENT '所属菜单Id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '功能点名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '功能描述',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_by` bigint(18) NULL DEFAULT NULL COMMENT '创建人',
  `modify_by` bigint(18) NULL DEFAULT NULL COMMENT '修改人',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `unq_name`(`name`(191)) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1010101010101010193 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '权限配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代码',
  `description` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `create_by` bigint(18) NULL DEFAULT NULL COMMENT '创建人',
  `modify_by` bigint(18) NULL DEFAULT NULL COMMENT '修改人',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态0:禁用 1:启用',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1017767747970568195 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(18) NULL DEFAULT NULL,
  `menu_id` bigint(18) NULL DEFAULT NULL,
  `create_by` bigint(18) NULL DEFAULT NULL COMMENT '创建人',
  `modify_by` bigint(18) NULL DEFAULT NULL COMMENT '修改人',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1021574920731242499 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role_privilege
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_privilege`;
CREATE TABLE `sys_role_privilege`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(18) NOT NULL,
  `privilege_id` bigint(18) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1021574920613801987 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色权限配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role_privilege_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_privilege_user`;
CREATE TABLE `sys_role_privilege_user`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(18) NOT NULL COMMENT '角色Id',
  `user_id` bigint(18) NOT NULL COMMENT '用户Id',
  `privilege_id` bigint(18) NOT NULL COMMENT '权限Id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `pk_role_id_user_id_privilege_id`(`role_id`, `user_id`, `privilege_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1010101010101010228 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户权限配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账号',
  `password` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `fullname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `mobile` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态 0-无效； 1-有效；',
  `create_by` bigint(18) NULL DEFAULT NULL COMMENT '创建人',
  `modify_by` bigint(18) NULL DEFAULT NULL COMMENT '修改人',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1018715142409592835 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_log`;
CREATE TABLE `sys_user_log`  (
  `id` bigint(18) NOT NULL COMMENT '主键',
  `group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户Id',
  `type` smallint(4) NULL DEFAULT NULL COMMENT '日志类型 1查询 2修改 3新增 4删除 5导出 6审核',
  `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '方法',
  `params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '参数',
  `time` bigint(20) NULL DEFAULT NULL COMMENT '时间',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` bigint(18) NULL DEFAULT NULL COMMENT '角色ID',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `create_by` bigint(18) NULL DEFAULT NULL COMMENT '创建人',
  `modify_by` bigint(18) NULL DEFAULT NULL COMMENT '修改人',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1022060671264763907 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户角色配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for trade_area
-- ----------------------------
DROP TABLE IF EXISTS `trade_area`;
CREATE TABLE `trade_area`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易区名称',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易区代码',
  `type` tinyint(4) NULL DEFAULT NULL COMMENT '类型：1-数字货币交易；2-创新交易使用；',
  `coin_id` bigint(18) NULL DEFAULT NULL COMMENT '结算币种（仅创新交易需要使用）',
  `coin_name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结算币种名称（仅创新交易需要使用）',
  `sort` tinyint(4) NULL DEFAULT NULL COMMENT '排序',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态',
  `base_coin` bigint(18) NULL DEFAULT NULL COMMENT '是否作为基础结算货币,0否1是 供统计个人账户使用',
  `last_update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coin_id`(`coin_id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_update_time`(`last_update_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1012972836498837506 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易区' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for turnover_order
-- ----------------------------
DROP TABLE IF EXISTS `turnover_order`;
CREATE TABLE `turnover_order`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `market_id` bigint(18) NOT NULL COMMENT '市场ID',
  `market_type` int(11) NULL DEFAULT NULL COMMENT '交易对类型：1-币币交易；2-创新交易；',
  `trade_type` tinyint(1) NOT NULL COMMENT '交易类型:1 买 2卖',
  `symbol` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易对标识符',
  `market_name` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易对名称',
  `sell_user_id` bigint(18) NOT NULL COMMENT '卖方用户ID',
  `sell_coin_id` bigint(18) NOT NULL COMMENT '卖方币种ID',
  `sell_order_id` bigint(18) NOT NULL COMMENT '卖方委托订单ID',
  `sell_price` decimal(40, 20) NOT NULL COMMENT '卖方委托价格',
  `sell_fee_rate` decimal(40, 20) NOT NULL COMMENT '卖方手续费率',
  `sell_volume` decimal(40, 20) NOT NULL COMMENT '卖方委托数量',
  `buy_user_id` bigint(18) NOT NULL COMMENT '买方用户ID',
  `buy_coin_id` bigint(18) NOT NULL COMMENT '买方币种ID',
  `buy_order_id` bigint(18) NOT NULL COMMENT '买方委托订单ID',
  `buy_volume` decimal(40, 20) NOT NULL COMMENT '买方委托数量',
  `buy_price` decimal(40, 20) NOT NULL COMMENT '买方委托价格',
  `buy_fee_rate` decimal(40, 20) NOT NULL COMMENT '买方手续费率',
  `order_id` bigint(18) NOT NULL COMMENT '委托订单ID',
  `amount` decimal(40, 20) NOT NULL COMMENT '成交总额',
  `price` decimal(40, 20) NOT NULL COMMENT '成交价格',
  `volume` decimal(40, 20) NOT NULL COMMENT '成交数量',
  `deal_sell_fee` decimal(40, 20) NOT NULL COMMENT '成交卖出手续费',
  `deal_sell_fee_rate` decimal(40, 20) NOT NULL COMMENT '成交卖出手续费率',
  `deal_buy_fee` decimal(40, 20) NOT NULL COMMENT '成交买入手续费',
  `deal_buy_fee_rate` decimal(40, 20) NOT NULL COMMENT '成交买入成交率费',
  `status` tinyint(1) NOT NULL COMMENT '状态0待成交，1已成交，2撤销，3.异常',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`created`) USING BTREE,
  INDEX `idx_market_id`(`market_id`) USING BTREE,
  INDEX `turnover_sellorder_buyorder_market_index`(`market_id`, `sell_order_id`, `buy_order_id`) USING BTREE,
  INDEX `idx_selluserid`(`sell_user_id`) USING BTREE,
  INDEX `idx_buyuserid`(`buy_user_id`) USING BTREE,
  INDEX `idx_bid_sid`(`sell_order_id`, `buy_order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1016672239088892412 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '成交订单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for turnover_record
-- ----------------------------
DROP TABLE IF EXISTS `turnover_record`;
CREATE TABLE `turnover_record`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `market_id` bigint(18) NOT NULL COMMENT '市场ID',
  `price` decimal(20, 8) NOT NULL COMMENT '成交价',
  `volume` decimal(20, 8) NOT NULL COMMENT '成交数量',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '成交数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `type` tinyint(4) NULL DEFAULT 1 COMMENT '用户类型：1-普通用户；2-代理人',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `country_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '国际电话区号',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `paypassword` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '交易密码',
  `paypass_setting` tinyint(1) NULL DEFAULT 0 COMMENT '交易密码设置状态',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `real_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `id_card_type` tinyint(1) NULL DEFAULT NULL COMMENT '证件类型:1，身份证；2，军官证；3，护照；4，台湾居民通行证；5，港澳居民通行证；9，其他；',
  `auth_status` tinyint(4) NULL DEFAULT 0 COMMENT '认证状态：0-未认证；1-初级实名认证；2-高级实名认证',
  `ga_secret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Google令牌秘钥',
  `ga_status` tinyint(1) NULL DEFAULT 0 COMMENT 'Google认证开启状态,0,未启用，1启用',
  `id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `level` int(11) NULL DEFAULT NULL COMMENT '代理商级别',
  `authtime` datetime(0) NULL DEFAULT NULL COMMENT '认证时间',
  `logins` int(11) NULL DEFAULT 0 COMMENT '登录数',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态：0，禁用；1，启用；',
  `invite_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '邀请码',
  `invite_relation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '邀请关系',
  `direct_inviteid` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '直接邀请人ID',
  `is_deductible` int(11) NULL DEFAULT 0 COMMENT '0 否 1是  是否开启平台币抵扣手续费',
  `reviews_status` int(11) NULL DEFAULT 0 COMMENT '审核状态,1通过,2拒绝,0,待审核',
  `agent_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '代理商拒绝原因',
  `access_key_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'API的KEY',
  `access_key_secret` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'API的密钥',
  `refe_auth_id` bigint(30) NULL DEFAULT NULL COMMENT '引用认证状态id',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `idx_addtime`(`created`) USING BTREE,
  INDEX `username`(`username`(191)) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1024859055654637571 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_account_freeze
-- ----------------------------
DROP TABLE IF EXISTS `user_account_freeze`;
CREATE TABLE `user_account_freeze`  (
  `user_id` bigint(20) NOT NULL,
  `freeze` decimal(40, 20) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(18) NOT NULL COMMENT '用户ID',
  `coin_id` bigint(18) NOT NULL COMMENT '币种ID',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '地址',
  `keystore` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'keystore',
  `pwd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `markid` bigint(30) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `USERETH_UID_COINID_INX`(`user_id`, `coin_id`) USING BTREE,
  INDEX `USERETH_ADDRESS_INX`(`address`) USING BTREE,
  INDEX `idx_coin_id`(`coin_id`) USING BTREE,
  INDEX `idx_coin_id_address`(`coin_id`, `address`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1023123686447505411 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户钱包地址信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_address_error
-- ----------------------------
DROP TABLE IF EXISTS `user_address_error`;
CREATE TABLE `user_address_error`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(18) NOT NULL COMMENT '用户ID',
  `coin_id` bigint(18) NOT NULL COMMENT '币种ID',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '地址',
  `keystore` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'keystore',
  `pwd` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `USERETH_UID_COINID_INX`(`user_id`, `coin_id`) USING BTREE,
  INDEX `USERETH_ADDRESS_INX`(`address`) USING BTREE,
  INDEX `idx_coin_id`(`coin_id`) USING BTREE,
  INDEX `idx_coin_id_address`(`coin_id`, `address`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1021286658810392578 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户钱包地址信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_auth_audit_record
-- ----------------------------
DROP TABLE IF EXISTS `user_auth_audit_record`;
CREATE TABLE `user_auth_audit_record`  (
  `id` bigint(18) NOT NULL COMMENT '主键',
  `auth_code` bigint(18) NULL DEFAULT NULL COMMENT '对应user_auth_info表code',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态1同意2拒絕',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `step` tinyint(4) NULL DEFAULT NULL COMMENT '当前审核级数',
  `audit_user_id` bigint(18) NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_user_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '实名认证审核信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_auth_info
-- ----------------------------
DROP TABLE IF EXISTS `user_auth_info`;
CREATE TABLE `user_auth_info`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `image_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `serialno` int(11) NULL DEFAULT NULL COMMENT '序号：1-身份证正面照；2-身份证反面照；3-手持身份证照片；',
  `last_update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `auth_code` bigint(18) NULL DEFAULT NULL COMMENT '用户每组审核记录唯一标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1024472070150623236 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '实名认证信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_bank
-- ----------------------------
DROP TABLE IF EXISTS `user_bank`;
CREATE TABLE `user_bank`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` bigint(18) NOT NULL COMMENT '用户id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '银行卡名称',
  `real_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开户人',
  `bank` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开户行',
  `bank_prov` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户省',
  `bank_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户市',
  `bank_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开户地址',
  `bank_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开户账号',
  `status` tinyint(4) NOT NULL COMMENT '状态：0，禁用；1，启用；',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `userid`(`user_id`) USING BTREE,
  INDEX `create_time`(`created`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 149 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户人民币提现地址' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_coin_freeze
-- ----------------------------
DROP TABLE IF EXISTS `user_coin_freeze`;
CREATE TABLE `user_coin_freeze`  (
  `user_id` bigint(20) NOT NULL,
  `coin_id` bigint(20) NULL DEFAULT NULL,
  `freeze` decimal(10, 0) NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_favorite_market
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite_market`;
CREATE TABLE `user_favorite_market`  (
  `id` bigint(18) NOT NULL COMMENT '主键',
  `type` int(11) NULL DEFAULT NULL COMMENT '交易对类型：1-币币交易；2-创新交易；',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `market_id` bigint(18) NULL DEFAULT NULL COMMENT '交易对ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户收藏交易市场' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_login_log
-- ----------------------------
DROP TABLE IF EXISTS `user_login_log`;
CREATE TABLE `user_login_log`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户ID',
  `client_type` tinyint(4) NULL DEFAULT NULL COMMENT '客户端类型\r\n            1-PC\r\n            2-IOS\r\n            3-Android',
  `login_ip` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登录IP',
  `login_address` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登录地址',
  `login_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '登录时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_fk_login_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户登录日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user_wallet
-- ----------------------------
DROP TABLE IF EXISTS `user_wallet`;
CREATE TABLE `user_wallet`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(18) NOT NULL COMMENT '用户ID',
  `coin_id` bigint(18) NOT NULL COMMENT '币种ID',
  `coin_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '币种名称',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '提币地址名称',
  `addr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '地址',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态',
  `last_update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `userid`(`user_id`) USING BTREE,
  INDEX `idx_coinid`(`coin_id`) USING BTREE,
  INDEX `idx_create_time`(`created`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `coinname`(`coin_name`(191)) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1022770093960081410 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户提币地址' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for wallet_collect_task
-- ----------------------------
DROP TABLE IF EXISTS `wallet_collect_task`;
CREATE TABLE `wallet_collect_task`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `coin_id` bigint(18) NOT NULL COMMENT '币种ID',
  `coin_type` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '币种类型',
  `coin_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '币种名称',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '来自哪个用户',
  `txid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'txid',
  `amount` decimal(20, 8) NULL DEFAULT NULL COMMENT '归集数量',
  `chain_fee` decimal(20, 8) NULL DEFAULT NULL COMMENT '链上手续费',
  `mark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `status` int(10) NOT NULL DEFAULT 0 COMMENT '是否处理',
  `from_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来自哪个地址',
  `to_address` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '转到哪里',
  `last_update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1026352852179816450 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '当钱包需要归集的时候,会吧数据插入到该表,现在一般是用在eth和eth这类型需要归集的币种' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for web_config
-- ----------------------------
DROP TABLE IF EXISTS `web_config`;
CREATE TABLE `web_config`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT 'Id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '分组, LINK_BANNER ,WEB_BANNER',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '值',
  `sort` smallint(4) NULL DEFAULT 1 COMMENT '权重',
  `created` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '超链接地址',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否使用 0 否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1015194998290923523 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '网站配置信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for work_issue
-- ----------------------------
DROP TABLE IF EXISTS `work_issue`;
CREATE TABLE `work_issue`  (
  `id` bigint(18) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(18) NULL DEFAULT NULL COMMENT '用户id(提问用户id)',
  `answer_user_id` bigint(18) NULL DEFAULT NULL COMMENT '回复人id',
  `answer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '回复人名称',
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '工单内容',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '回答内容',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态：1-待回答；2-已回答；',
  `last_update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  `created` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工单记录' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
