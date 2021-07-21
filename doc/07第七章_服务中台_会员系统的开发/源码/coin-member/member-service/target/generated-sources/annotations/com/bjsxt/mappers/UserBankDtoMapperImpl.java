package com.bjsxt.mappers;

import com.bjsxt.domain.UserBank;
import com.bjsxt.dto.UserBankDto;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2020-11-11T10:48:36+0800",
    comments = "version: 1.2.0.Final, compiler: javac, environment: Java 1.8.0_191 (Oracle Corporation)"
)
@Component
public class UserBankDtoMapperImpl implements UserBankDtoMapper {

    @Override
    public UserBank toConvertEntity(UserBankDto source) {
        if ( source == null ) {
            return null;
        }

        UserBank userBank = new UserBank();

        userBank.setRealName( source.getRealName() );
        userBank.setBank( source.getBank() );
        userBank.setBankProv( source.getBankProv() );
        userBank.setBankCity( source.getBankCity() );
        userBank.setBankAddr( source.getBankAddr() );
        userBank.setBankCard( source.getBankCard() );

        return userBank;
    }

    @Override
    public List<UserBank> toConvertEntity(List<UserBankDto> source) {
        if ( source == null ) {
            return null;
        }

        List<UserBank> list = new ArrayList<UserBank>( source.size() );
        for ( UserBankDto userBankDto : source ) {
            list.add( toConvertEntity( userBankDto ) );
        }

        return list;
    }

    @Override
    public UserBankDto toConvertDto(UserBank source) {
        if ( source == null ) {
            return null;
        }

        UserBankDto userBankDto = new UserBankDto();

        userBankDto.setRealName( source.getRealName() );
        userBankDto.setBank( source.getBank() );
        userBankDto.setBankProv( source.getBankProv() );
        userBankDto.setBankCity( source.getBankCity() );
        userBankDto.setBankAddr( source.getBankAddr() );
        userBankDto.setBankCard( source.getBankCard() );

        return userBankDto;
    }

    @Override
    public List<UserBankDto> toConvertDto(List<UserBank> source) {
        if ( source == null ) {
            return null;
        }

        List<UserBankDto> list = new ArrayList<UserBankDto>( source.size() );
        for ( UserBank userBank : source ) {
            list.add( toConvertDto( userBank ) );
        }

        return list;
    }
}
