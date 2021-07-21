package com.bjsxt.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bjsxt.domain.CashWithdrawAuditRecord;
import com.bjsxt.domain.CashWithdrawals;
import com.bjsxt.model.CashSellParam;
import com.bjsxt.model.R;
import com.bjsxt.service.CashWithdrawalsService;
import com.bjsxt.util.ReportCsvUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.CollectionUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.supercsv.cellprocessor.CellProcessorAdaptor;
import org.supercsv.cellprocessor.ift.CellProcessor;
import org.supercsv.util.CsvContext;
import springfox.documentation.annotations.ApiIgnore;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/cashWithdrawals")
@Api(tags = "GCN提现记录")
public class CashWithdrawalsController {

    @Autowired
    private CashWithdrawalsService cashWithdrawalsService;

    @GetMapping("/records")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "current", value = "当前页"),
            @ApiImplicitParam(name = "size", value = "每页显示的条数"),
            @ApiImplicitParam(name = "userId", value = "用户的ID"),
            @ApiImplicitParam(name = "userName", value = "用户的名称"),
            @ApiImplicitParam(name = "mobile", value = "用户的手机号"),
            @ApiImplicitParam(name = "status", value = "充值的状态"),
            @ApiImplicitParam(name = "numMin", value = "充值金额的最小值"),
            @ApiImplicitParam(name = "numMax", value = "充值金额的最小值"),
            @ApiImplicitParam(name = "startTime", value = "充值开始时间"),
            @ApiImplicitParam(name = "endTime", value = "充值结束时间"),
    })
    public R<Page<CashWithdrawals>> findByPage(
            @ApiIgnore Page<CashWithdrawals> page,
            Long userId, String userName, String mobile,
            Byte status, String numMin, String numMax,
            String startTime, String endTime
    ) {

        Page<CashWithdrawals> pageData = cashWithdrawalsService.findByPage(page, userId, userName, mobile, status, numMin, numMax, startTime, endTime);
        return R.ok(pageData);
    }


    @GetMapping("/records/export")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "userId", value = "用户的ID"),
            @ApiImplicitParam(name = "userName", value = "用户的名称"),
            @ApiImplicitParam(name = "mobile", value = "用户的手机号"),
            @ApiImplicitParam(name = "status", value = "充值的状态"),
            @ApiImplicitParam(name = "numMin", value = "充值金额的最小值"),
            @ApiImplicitParam(name = "numMax", value = "充值金额的最小值"),
            @ApiImplicitParam(name = "startTime", value = "充值开始时间"),
            @ApiImplicitParam(name = "endTime", value = "充值结束时间"),
    })
    public void recordsExport(
            Long userId, String userName, String mobile,
            Byte status, String numMin, String numMax,
            String startTime, String endTime
    ) {
        Page<CashWithdrawals> cashWithdrawalsPage = new Page<>(1, 10000);
        Page<CashWithdrawals> pageData = cashWithdrawalsService.findByPage(cashWithdrawalsPage, userId, userName, mobile, status, numMin, numMax, startTime, endTime);
        List<CashWithdrawals> records = pageData.getRecords();
        if (!CollectionUtils.isEmpty(records)) {
            ServletRequestAttributes requestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            String[] header = {"ID", "用户ID", "用户名", "提现金额(USDT)", "手续费", "到账金额", "提现开户名", "银行名称", "账户", "申请时间", "完成时间", "状态", "备注", "审核级数"};
            // 对象属性要一一对应
            String[] properties = {"id", "userId", "username", "num", "fee", "mum", "truename", "bank", "bankCard", "created", "lastTime", "status", "remark", "step"};

            CellProcessorAdaptor longToStringAdapter = new CellProcessorAdaptor() {
                @Override
                public <T> T execute(Object o, CsvContext csvContext) {
                    return (T) String.valueOf(o);
                }
            };

            // 对于金额,需要8位有效数字,金额
            DecimalFormat decimalFormat = new DecimalFormat("0.00000000");


            CellProcessorAdaptor moneyCellProcessorAdaptor = new CellProcessorAdaptor() {
                @Override
                public <T> T execute(Object o, CsvContext csvContext) {
                    BigDecimal num = (BigDecimal) o;
                    String numReal = decimalFormat.format(num);
                    return (T) numReal;
                }
            };

            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            CellProcessorAdaptor timeCellProcessorAdaptor = new CellProcessorAdaptor() {
                @Override
                public <T> T execute(Object o, CsvContext csvContext) {
                    if (o == null) {
                        return (T) "";
                    }
                    Date date = (Date) o;
                    String dateStr = simpleDateFormat.format(date);
                    return (T) dateStr;
                }
            };

            //状态：0-待审核；1-审核通过；2-拒绝；3-提现成功；
            CellProcessorAdaptor statusCellProcessorAdaptor = new CellProcessorAdaptor() {
                @Override
                public <T> T execute(Object o, CsvContext csvContext) {
                    Integer status = Integer.valueOf(String.valueOf(o));
                    String statusStr = "";
                    switch (status) {
                        case 0:
                            statusStr = "待审核";
                            break;
                        case 1:
                            statusStr = "审核通过";
                            break;
                        case 2:
                            statusStr = "拒绝";
                            break;
                        case 3:
                            statusStr = "提现成功";
                            break;
                        default:
                            statusStr = "未知";
                            break;

                    }
                    return (T) statusStr;
                }
            };

            CellProcessor[] cellProcessors = new CellProcessor[]{
                    longToStringAdapter, longToStringAdapter, null, //"ID", "用户ID", "用户名",
                    moneyCellProcessorAdaptor, moneyCellProcessorAdaptor, moneyCellProcessorAdaptor, // "提现金额(USDT)", "手续费", "到账金额",
                    null, null, null,//"提现开户名", "银行名称, 账号"
                    timeCellProcessorAdaptor, timeCellProcessorAdaptor, //  "申请时间", "完成时间"
                    statusCellProcessorAdaptor, // 状态
                    null, null // 备注 审核级数

            };


            try {
                // 导出csv文件
                ReportCsvUtils.reportListCsv(requestAttributes.getResponse(), header, properties, "场外交易提现审核.csv", records, cellProcessors);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }


    }


    @GetMapping("/user/records")
    @ApiOperation(value = "查询当前用户的充值记录")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "current", value = "当前页"),
            @ApiImplicitParam(name = "size", value = "每页显示的大小"),
            @ApiImplicitParam(name = "status", value = "充值的状态"),
    })
    public R<Page<CashWithdrawals>> findUserCashRecharge(@ApiIgnore Page<CashWithdrawals> page, Byte status) {
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
        Page<CashWithdrawals> cashWithdrawalsPage = cashWithdrawalsService.findCashWithdrawals(page, userId, status);
        return R.ok(cashWithdrawalsPage);
    }


    @PostMapping("/sell")
    @ApiOperation(value = "GCN的卖出操作")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "", value = "")
    })
    public R<Object> sell(@RequestBody @Validated CashSellParam cashSellParam) {
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
        boolean isOk = cashWithdrawalsService.sell(userId, cashSellParam);
        if (isOk) {
            return R.ok("提交申请成功");
        }
        return R.fail("提交申请失败");
    }



    @PostMapping("/updateWithdrawalsStatus")
    public R updateWithdrawalsStatus(@RequestBody CashWithdrawAuditRecord cashWithdrawAuditRecord){
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
        boolean isOk =  cashWithdrawalsService.updateWithdrawalsStatus(userId ,cashWithdrawAuditRecord) ;
        return isOk ? R.ok():R.fail("审核失败") ;
    }


}
