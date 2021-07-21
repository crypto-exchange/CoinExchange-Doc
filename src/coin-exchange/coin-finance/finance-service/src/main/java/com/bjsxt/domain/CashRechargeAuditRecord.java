package com.bjsxt.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 充值审核记录
 */
@ApiModel(value = "com-bjsxt-domain-CashRechargeAuditRecord")
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName(value = "cash_recharge_audit_record")
public class CashRechargeAuditRecord {
    /**
     * 主键
     */
    @TableId(value = "id", type = IdType.AUTO)
    @ApiModelProperty(value = "主键")
    private Long id;

    /**
     * 充值订单号
     */
    @TableField(value = "order_id")
    @ApiModelProperty(value = "充值订单号")
    private Long orderId;

    /**
     * 状态
     */
    @TableField(value = "status")
    @ApiModelProperty(value = "状态")
    private Byte status;

    /**
     * 审核备注
     */
    @TableField(value = "remark")
    @ApiModelProperty(value = "审核备注")
    private String remark;

    /**
     * 当前审核级数
     */
    @TableField(value = "step")
    @ApiModelProperty(value = "当前审核级数")
    private Byte step;

    /**
     * 审核人ID
     */
    @TableField(value = "audit_user_id")
    @ApiModelProperty(value = "审核人ID")
    private Long auditUserId;

    /**
     * 审核人
     */
    @TableField(value = "audit_user_name")
    @ApiModelProperty(value = "审核人")
    private String auditUserName;

    /**
     * 创建时间
     */
    @TableField(value = "created")
    @ApiModelProperty(value = "创建时间")
    private Date created;
}