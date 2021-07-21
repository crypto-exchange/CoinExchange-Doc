package com.bjsxt.mappers;

import com.bjsxt.domain.Account;
import com.bjsxt.vo.AccountVo;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AccountVoMappers {

    AccountVoMappers INSTANCE = Mappers.getMapper(AccountVoMappers.class) ;

    /**
     * source 转化为AccountVo
     * @param source
     * @return
     */
    AccountVo toConvertVo(Account source) ;


    /**
     * source 转化为AccountVo
     * @param source
     * @return
     */
    List<AccountVo> toConvertVo(List<Account> source) ;


    /**
     * source 转化为AccountVo
     * @param source
     * @return
     */
    Account toConvertEntity(AccountVo source) ;


    /**
     * source 转化为AccountVo
     * @param source
     * @return
     */
    List<Account> toConvertEntity(List<AccountVo> source) ;
}
