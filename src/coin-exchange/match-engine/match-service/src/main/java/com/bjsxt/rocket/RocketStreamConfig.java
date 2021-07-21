package com.bjsxt.rocket;

import org.springframework.cloud.stream.annotation.EnableBinding;
import org.springframework.context.annotation.Configuration;


/**
 * 开启我们的Stream的开发
 */
@Configuration
@EnableBinding(value = {Sink.class,Source.class}) //
public class RocketStreamConfig {
}
