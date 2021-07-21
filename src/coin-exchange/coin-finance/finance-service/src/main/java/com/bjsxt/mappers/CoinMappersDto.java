package com.bjsxt.mappers;

import com.bjsxt.domain.Coin;
import com.bjsxt.dto.CoinDto;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CoinMappersDto {

    CoinMappersDto INSTANCE = Mappers.getMapper(CoinMappersDto.class) ;

    Coin toConvertEntity(CoinDto source) ;

    List<Coin> toConvertEntity(List<CoinDto> source) ;

    CoinDto toConvertDto(Coin source) ;

    List<CoinDto> toConvertDto(List<Coin> source) ;
}
