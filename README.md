# 后端项目模版

项目目录：
- app -- 应用代码模块
  - biz -- 业务代码模块
  - dal -- 数据访问模块
  - integration -- 第二方、第三方集成模块
  - web -- http接口模块
  - test -- 单元测试模块
- boot -- 启动模块
- config -- 配置文件
- dalgen -- 数据访问层生成器模块
- assembly -- 自定义打包模块
- deploy -- 维护脚本
- lib -- 直接导入jar目录
- docs -- 文档目录
  - db -- DDL
- Dockerfile -- Docker文件
- Jenkinsfile -- Jenkins Pipeline
- package.sh -- 打包脚本
- CHANGELOG.md
- README.md
.
|____app
| |____biz
| |____test
| |____web
| |____integration
| |____facade
| |____dal
|____boot
|____dalgen
|____bin
|____config
|____deploy
|____assembly
|____lib
|____docs
| |____deploy
| |____db
|____Dockerfile
|____Jenkinsfile
|____pom.xml
|____NOTICE
|____CHANGELOG.md
|____README.md

制品包目录：
```
.
|____boot
| |____cicd-repo-boot-0.0.1-SNAPSHOT.jar
|____bin
| |____restart.sh
| |____debugger.sh
| |____startup.sh
| |____startup-skywalking.sh
| |____shutdown.sh
|____conf
| |____app.properties
| |____application.yml
| |____application-eureka.yml
| |____application-tomcat.yml
| |____application-logging.yml
| |____application-datasource.yml
| |____logback-spring.xml
| |____jvm.options
|____lib
| |____xxx.jar
|____NOTICE
|____README.md
```

初始化源码：
```

```

新项目初始化子项目：
```

```
