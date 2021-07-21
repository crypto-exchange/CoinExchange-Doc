package com.bjsxt.dto;

import lombok.Data;
import lombok.experimental.Accessors;

import java.math.BigDecimal;


@Data
@Accessors(chain = true)
public class TurnoverData24HDTO {


    /**
     * 24小时成交量
     */
    private BigDecimal volume = BigDecimal.ZERO;

    /**
     * 24小时成交总额
     */
    private BigDecimal amount = BigDecimal.ZERO;
}
