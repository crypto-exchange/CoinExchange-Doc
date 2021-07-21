package com.bjsxt.mappers;

import com.bjsxt.domain.AdminBank;
import com.bjsxt.dto.AdminBankDto;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AdminBankDtoMappers {

    AdminBankDtoMappers INSTANCE = Mappers.getMapper(AdminBankDtoMappers.class) ;

    AdminBank toConvertEntity(AdminBankDto source) ;

    AdminBankDto toConvertDto(AdminBank source) ;


    List<AdminBank> toConvertEntity(List<AdminBankDto> source) ;

    List<AdminBankDto> toConvertDto(List<AdminBank> source) ;
}
