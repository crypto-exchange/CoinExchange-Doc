package com.bjsxt.mappers;

import com.bjsxt.domain.Account;
import com.bjsxt.vo.AccountVo;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2020-11-11T10:48:41+0800",
    comments = "version: 1.2.0.Final, compiler: javac, environment: Java 1.8.0_191 (Oracle Corporation)"
)
@Component
public class AccountVoMappersImpl implements AccountVoMappers {

    @Override
    public AccountVo toConvertVo(Account source) {
        if ( source == null ) {
            return null;
        }

        AccountVo accountVo = new AccountVo();

        accountVo.setBalanceAmount( source.getBalanceAmount() );
        accountVo.setFreezeAmount( source.getFreezeAmount() );
        accountVo.setRechargeAmount( source.getRechargeAmount() );
        accountVo.setWithdrawalsAmount( source.getWithdrawalsAmount() );
        accountVo.setNetValue( source.getNetValue() );
        accountVo.setLockMargin( source.getLockMargin() );
        accountVo.setFloatProfit( source.getFloatProfit() );
        accountVo.setTotalProfit( source.getTotalProfit() );
        accountVo.setId( source.getId() );
        accountVo.setUserId( source.getUserId() );
        accountVo.setCoinId( source.getCoinId() );
        accountVo.setRecAddr( source.getRecAddr() );
        if ( source.getVersion() != null ) {
            accountVo.setVersion( source.getVersion().intValue() );
        }

        return accountVo;
    }

    @Override
    public List<AccountVo> toConvertVo(List<Account> source) {
        if ( source == null ) {
            return null;
        }

        List<AccountVo> list = new ArrayList<AccountVo>( source.size() );
        for ( Account account : source ) {
            list.add( toConvertVo( account ) );
        }

        return list;
    }

    @Override
    public Account toConvertEntity(AccountVo source) {
        if ( source == null ) {
            return null;
        }

        Account account = new Account();

        account.setId( source.getId() );
        account.setUserId( source.getUserId() );
        account.setCoinId( source.getCoinId() );
        account.setBalanceAmount( source.getBalanceAmount() );
        account.setFreezeAmount( source.getFreezeAmount() );
        account.setRechargeAmount( source.getRechargeAmount() );
        account.setWithdrawalsAmount( source.getWithdrawalsAmount() );
        account.setNetValue( source.getNetValue() );
        account.setLockMargin( source.getLockMargin() );
        account.setFloatProfit( source.getFloatProfit() );
        account.setTotalProfit( source.getTotalProfit() );
        account.setRecAddr( source.getRecAddr() );
        if ( source.getVersion() != null ) {
            account.setVersion( source.getVersion().longValue() );
        }

        return account;
    }

    @Override
    public List<Account> toConvertEntity(List<AccountVo> source) {
        if ( source == null ) {
            return null;
        }

        List<Account> list = new ArrayList<Account>( source.size() );
        for ( AccountVo accountVo : source ) {
            list.add( toConvertEntity( accountVo ) );
        }

        return list;
    }
}
