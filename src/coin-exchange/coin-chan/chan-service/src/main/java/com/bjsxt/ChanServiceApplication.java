package com.bjsxt;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.tio.websocket.starter.EnableTioWebSocketServer;
import org.tio.websocket.starter.TioWebSocketServerBootstrap;


@SpringBootApplication
@EnableTioWebSocketServer // 开启tio的websocket
public class ChanServiceApplication {

    @Autowired
    private TioWebSocketServerBootstrap bootstrap ;

    public static void main(String[] args) {
        SpringApplication.run(ChanServiceApplication.class ,args) ;
    }

}
