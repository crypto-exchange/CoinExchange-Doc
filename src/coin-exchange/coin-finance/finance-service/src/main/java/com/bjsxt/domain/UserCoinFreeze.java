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

@ApiModel(value = "com-bjsxt-domain-UserCoinFreeze")
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName(value = "user_coin_freeze")
public class UserCoinFreeze {
    @TableId(value = "user_id", type = IdType.INPUT)
    @ApiModelProperty(value = "")
    private Long userId;

    @TableField(value = "coin_id")
    @ApiModelProperty(value = "")
    private Long coinId;

    @TableField(value = "freeze")
    @ApiModelProperty(value = "")
    private Long freeze;
}