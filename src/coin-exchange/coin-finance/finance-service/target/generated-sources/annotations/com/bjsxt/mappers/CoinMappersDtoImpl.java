package com.bjsxt.mappers;

import com.bjsxt.domain.Coin;
import com.bjsxt.dto.CoinDto;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2020-12-24T18:32:52+0800",
    comments = "version: 1.2.0.Final, compiler: javac, environment: Java 11 (Oracle Corporation)"
)
@Component
public class CoinMappersDtoImpl implements CoinMappersDto {

    @Override
    public Coin toConvertEntity(CoinDto source) {
        if ( source == null ) {
            return null;
        }

        Coin coin = new Coin();

        coin.setId( source.getId() );
        coin.setName( source.getName() );
        coin.setTitle( source.getTitle() );
        coin.setImg( source.getImg() );
        coin.setBaseAmount( source.getBaseAmount() );
        coin.setMinAmount( source.getMinAmount() );
        coin.setMaxAmount( source.getMaxAmount() );
        coin.setDayMaxAmount( source.getDayMaxAmount() );

        return coin;
    }

    @Override
    public List<Coin> toConvertEntity(List<CoinDto> source) {
        if ( source == null ) {
            return null;
        }

        List<Coin> list = new ArrayList<Coin>( source.size() );
        for ( CoinDto coinDto : source ) {
            list.add( toConvertEntity( coinDto ) );
        }

        return list;
    }

    @Override
    public CoinDto toConvertDto(Coin source) {
        if ( source == null ) {
            return null;
        }

        CoinDto coinDto = new CoinDto();

        coinDto.setId( source.getId() );
        coinDto.setName( source.getName() );
        coinDto.setTitle( source.getTitle() );
        coinDto.setImg( source.getImg() );
        coinDto.setBaseAmount( source.getBaseAmount() );
        coinDto.setMinAmount( source.getMinAmount() );
        coinDto.setMaxAmount( source.getMaxAmount() );
        coinDto.setDayMaxAmount( source.getDayMaxAmount() );

        return coinDto;
    }

    @Override
    public List<CoinDto> toConvertDto(List<Coin> source) {
        if ( source == null ) {
            return null;
        }

        List<CoinDto> list = new ArrayList<CoinDto>( source.size() );
        for ( Coin coin : source ) {
            list.add( toConvertDto( coin ) );
        }

        return list;
    }
}
