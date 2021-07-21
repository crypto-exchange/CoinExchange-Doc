package com.bjsxt.config.rocket;

import org.springframework.cloud.stream.annotation.Output;
import org.springframework.messaging.MessageChannel;

public interface Source {

    @Output("order_out")
    MessageChannel outputMessage() ;
}
