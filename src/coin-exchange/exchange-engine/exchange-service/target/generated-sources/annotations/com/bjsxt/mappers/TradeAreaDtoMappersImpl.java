package com.bjsxt.mappers;

import com.bjsxt.domain.TradeArea;
import com.bjsxt.dto.TradeAreaDto;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2020-12-24T18:36:12+0800",
    comments = "version: 1.2.0.Final, compiler: javac, environment: Java 11 (Oracle Corporation)"
)
@Component
public class TradeAreaDtoMappersImpl implements TradeAreaDtoMappers {

    @Override
    public TradeArea toConvertEntity(TradeAreaDto source) {
        if ( source == null ) {
            return null;
        }

        TradeArea tradeArea = new TradeArea();

        tradeArea.setId( source.getId() );
        tradeArea.setName( source.getName() );
        tradeArea.setCode( source.getCode() );
        if ( source.getType() != null ) {
            tradeArea.setType( source.getType().byteValue() );
        }
        tradeArea.setCoinId( source.getCoinId() );
        tradeArea.setCoinName( source.getCoinName() );
        tradeArea.setSort( (byte) source.getSort() );
        if ( source.getStatus() != null ) {
            tradeArea.setStatus( source.getStatus().byteValue() );
        }
        tradeArea.setLastUpdateTime( source.getLastUpdateTime() );

        return tradeArea;
    }

    @Override
    public TradeAreaDto toConvertDto(TradeArea source) {
        if ( source == null ) {
            return null;
        }

        TradeAreaDto tradeAreaDto = new TradeAreaDto();

        tradeAreaDto.setId( source.getId() );
        tradeAreaDto.setName( source.getName() );
        tradeAreaDto.setCode( source.getCode() );
        if ( source.getType() != null ) {
            tradeAreaDto.setType( source.getType().intValue() );
        }
        tradeAreaDto.setCoinId( source.getCoinId() );
        tradeAreaDto.setCoinName( source.getCoinName() );
        if ( source.getSort() != null ) {
            tradeAreaDto.setSort( source.getSort() );
        }
        if ( source.getStatus() != null ) {
            tradeAreaDto.setStatus( source.getStatus().intValue() );
        }
        tradeAreaDto.setLastUpdateTime( source.getLastUpdateTime() );

        return tradeAreaDto;
    }

    @Override
    public List<TradeArea> toConvertEntity(List<TradeAreaDto> source) {
        if ( source == null ) {
            return null;
        }

        List<TradeArea> list = new ArrayList<TradeArea>( source.size() );
        for ( TradeAreaDto tradeAreaDto : source ) {
            list.add( toConvertEntity( tradeAreaDto ) );
        }

        return list;
    }

    @Override
    public List<TradeAreaDto> toConvertDto(List<TradeArea> source) {
        if ( source == null ) {
            return null;
        }

        List<TradeAreaDto> list = new ArrayList<TradeAreaDto>( source.size() );
        for ( TradeArea tradeArea : source ) {
            list.add( toConvertDto( tradeArea ) );
        }

        return list;
    }
}
