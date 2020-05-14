package site.mingsha.eureka.server;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * @author mingsha
 * @Date 2020/4/12 15:35
 */
@EnableEurekaServer
@SpringBootApplication
public class EurekaServerApplication {

	public static void main(String[] args) {
		new SpringApplicationBuilder(EurekaServerApplication.class).web(true).run(args);
	}

}
