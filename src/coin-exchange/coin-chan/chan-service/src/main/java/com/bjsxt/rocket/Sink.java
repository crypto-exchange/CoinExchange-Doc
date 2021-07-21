package com.bjsxt.rocket;

import org.springframework.cloud.stream.annotation.Input;
import org.springframework.messaging.MessageChannel;

public interface Sink {

    @Input("tio_group")
    MessageChannel messageGroupChannel() ;
}
